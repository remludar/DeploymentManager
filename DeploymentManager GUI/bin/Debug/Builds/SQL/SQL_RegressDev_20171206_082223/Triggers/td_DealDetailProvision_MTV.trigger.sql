SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.td_DealDetailProvision_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.td_DealDetailProvision_MTV
    IF OBJECT_ID('dbo.td_DealDetailProvision_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.td_DealDetailProvision_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.td_DealDetailProvision_MTV >>>'
  END
go


CREATE trigger td_DealDetailProvision_MTV on dbo.DealDetailProvision AFTER DELETE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       td_DealDetailProvision_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom delete trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of new DealDetailProvision records
-- Created by: Eric Wallerstein
-- History:    06/18/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/18/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
--                                          LoginInformation table, we won't bother to look there for Revision User information;
--                                          instead, we'll check first to see if we can tell if the SPID is attached to a
--                                          RightAngle application (PB or .NET) -- if so, we'll get the Revision User from the
--                                          TaxRuleSet table; otherwise we'll get it from the SYSTEM_USER SQL property
--                                          ** NOTE: if the names of the RightAngle applications change, this check will need to change also **
--  06/27/2012    E.Wallerstein           Because this trigger was relying on the TaxProvision table to be able to determine the
--                                          TxRleStID and the last revision user associated with the TaxRuleSet, and because the TaxProvision
--                                          record is likely deleted prior to this provision's deletion being Inserted into DealDetailProvision,
--                                          we will need to allow a NULL to be written as the TxRleStID, UserID, and UserDBMnkr; either these
--                                          values will stay as NULL or we will have to devise some alternate way to populate the values;
--                                          In our looping we will now rely on the TmplteSrceTble being 'TX' instead of joining to the TaxProvision table
--  07/09/2012    E.Wallerstein           After more analysis, we found that deleted records from the LoginInformation table are archived
--                                          in the LoginInformationArchive table; after determining that the SPID is attached to a RightAngle
--                                          application, we should be able to look in the LoginInformation table for the SPID and then
--                                          look in the LoginInformationArchive table for the latest login date associated with the SPID if the
--                                          record wasn't found in the LoginInformation table
--                                          ** NOTE: this will only work for the PowerBuilder side, since the SPID logged for the .NET side is currently
--                                                   just the UserID * 1000
--  07/09/2012    E.Wallerstein           Added tracking for Provision Type
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON 

Declare @i_DlDtlPrvsnID    int
       ,@i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
 ,DlDtlPrvsnID   int
 ,EntityChanged  varchar(200)
 ,OldValue       varchar(max)
 ,NewValue       varchar(max)
)


--
-- Determine the Revision User ID from RightAngle (or from SQL Server if the change is happening outside of RightAngle)
--

-- if the SPID isn't tied to a RightAngle application, get the name of the user currently logged into SQL Server
-- because the update most likely came directly from a SQL Server Management Studio session
-- ** NOTE: if the RightAngle application names change, this check will need to be updated **
if (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) NOT In ('.Net SqlClient Data Provider', 'Right Angle IV')
  Select @vc_User = System_User

-- if the user name is NULL, that measns the update DID come from a RightAngle application, so attempt to get the UserDBMnkr and UserID
-- from the LoginInformation or LoginInformationArchive table (will only work for the PowerBuilder SRA application, since
-- the .NET application does not store an actual SPID in the SPID field -- it stores UserID * 1000)
if @vc_User is NULL and (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) = 'Right Angle IV'
  Begin
    Select @vc_User = LoginInformation.UserDBMnkr
          ,@i_UserID = LoginInformation.UserID
    From   LoginInformation (nolock)
    Where  LoginInformation.SPID = @@SPID

    -- if the user name is still NULL, try looking for the last record associated with the SPID in the LoginInformationArchive table
    if @vc_User is NULL
      Begin
        Select Top 1 @vc_User = LoginInformationArchive.UserDBMnkr
                    ,@i_UserID = LoginInformationArchive.UserID
        From   LoginInformationArchive (nolock)
        Where  LoginInformationArchive.SPID = @@SPID
        Order By LoginInformationArchive.LoginDate desc
      End
  End

-- if the user name is still NULL, that means the lookup in the LoginInformation (or LoginInformationArchive) table failed,
-- so get the the Revision User off the TaxRuleSet record
if @vc_User is NULL
  Begin
    Select Top 1 @vc_User  = Users.UserDBMnkr
                ,@i_UserID = TaxRuleSet.RevisionUserID
    From   Deleted (nolock)
           left join TaxProvision (nolock)
                on Deleted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
           left join TaxRuleSet (nolock)
                on TaxProvision.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End


--
-- Insert a record into the MTV_TaxAudit table for each field on each deleted record
--

-- Determine the first deleted record to process
Select @i_DlDtlPrvsnID = Min(Deleted.DlDtlPrvsnID)
From   Deleted (nolock)
Where  Deleted.TmplteSrceTpe = 'TX' -- tax provision


While @i_DlDtlPrvsnID IS NOT NULL
  Begin

    Select @i_TxRleStID = TaxProvision.TxRleStID
    From   TaxProvision (nolock)
    Where  TaxProvision.DlDtlPrvsnID = @i_DlDtlPrvsnID
    
    -- if the TxRleStID is NULL, that means that the TaxProvision linker table record doesn't exist;
    -- to determine the TxRleStID, we'll look it up off a previous MTV_TaxAudit record
    if @i_TxRleStID is NULL
      Begin
        Select Top 1 @i_TxRleStID = MTV_TaxAudit.TxRleStID
        From   MTV_TaxAudit (nolock)
        Where  MTV_TaxAudit.DlDtlPrvsnID = @i_DlDtlPrvsnID
        Order By MTV_TaxAudit.DateModified desc
      End

	  
     Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Provision Type'
          ,IsNull((Select Prvsn.PrvsnDscrptn
                   From   Prvsn (nolock)
                   Where  Prvsn.PrvsnID = Deleted.DlDtlPrvsnPrvsnID
                  ), Convert(varchar,Deleted.DlDtlPrvsnPrvsnID))
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID


	Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Price Currency'
          ,IsNull((Select Currency.CrrncyNme
                   From   Currency (nolock)
                   Where  Currency.CrrncyID = Deleted.CrrncyID
                  ), Convert(varchar,Deleted.CrrncyID))
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Price UOM'
          ,IsNull((Select UnitOfMeasure.UOMAbbv
                   From   UnitOfMeasure (nolock)
                   Where  UnitOfMeasure.UOM = Deleted.UOMID
                  ), Convert(varchar,Deleted.UOMID))
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID
	
    Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Status'
          ,Case Deleted.Status When 'A' Then 'Active' When 'I' Then 'Inactive' Else Deleted.Status End
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID

	 Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Transaction Type'
          ,IsNull((Select TransactionType.TrnsctnTypDesc
                   From   TransactionType (nolock)
                   Where  TransactionType.TrnsctnTypID = Deleted.TrnsctnTypID
                  ), Convert(varchar,Deleted.TrnsctnTypID))
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'From Date'
          ,Convert(varchar,Deleted.DlDtlPrvsnFrmDte,101) -- mm/dd/yyyy
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'To Date'
          ,Convert(varchar,Deleted.DlDtlPrvsnToDte,101) -- mm/dd/yyyy
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID

   
    Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
    Select @i_TxRleStID
          ,Deleted.DlDtlPrvsnID
          ,'Quantity Basis'
          ,Case Deleted.QuantityBasis When 'N' Then 'Net Quantity' When 'G' Then 'Gross Quantity' When 'X' Then 'As Billed' Else Deleted.QuantityBasis End
          ,'<DELETED>'
    From   Deleted (nolock)
    Where  Deleted.DlDtlPrvsnID = @i_DlDtlPrvsnID


NextRecord:

    -- Process the next deleted record
    Select @i_DlDtlPrvsnID = Min(Deleted.DlDtlPrvsnID)
    From   Deleted (nolock)
    Where  Deleted.TmplteSrceTpe = 'TX' -- tax provision
      and  Deleted.DlDtlPrvsnID > @i_DlDtlPrvsnID

  End

Insert MTV_TaxAudit
(DateModified
,UserID
,UserDBMnkr
,TxRleStID
,DlDtlPrvsnID
,TabChanged
,EntityChanged
,OldValue
,NewValue
)
Select Current_TimeStamp
      ,@i_UserID
      ,@vc_User
      ,#Audit.TxRleStID
      ,#Audit.DlDtlPrvsnID
      ,'Provisions'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By #Audit.Idnty

Drop Table #Audit

return

end

GO

IF OBJECT_ID('dbo.td_DealDetailProvision_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.td_DealDetailProvision_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.td_DealDetailProvision_MTV >>>'

go
