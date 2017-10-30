SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_DealDetailProvision_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_DealDetailProvision_MTV
    IF OBJECT_ID('dbo.tu_DealDetailProvision_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_DealDetailProvision_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_DealDetailProvision_MTV >>>'
  END
go


CREATE trigger tu_DealDetailProvision_MTV on dbo.DealDetailProvision AFTER UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       tu_DealDetailProvision_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom update trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of what changed on a DealDetailProvision record
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
    From   Inserted (nolock)
           join TaxProvision (nolock)
                on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
           join TaxRuleSet (nolock)
                on TaxProvision.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End


--
-- Insert a record into the MTV_TaxAudit table for each updated field on each changed record
--

-- Determine the first changed record to process
Select @i_DlDtlPrvsnID = Min(Inserted.DlDtlPrvsnID)
From   Inserted (nolock)
       join TaxProvision (nolock)
            on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID

While @i_DlDtlPrvsnID IS NOT NULL
  Begin

    Select @i_TxRleStID = TaxProvision.TxRleStID
    From   TaxProvision (nolock)
    Where  TaxProvision.DlDtlPrvsnID = @i_DlDtlPrvsnID
    
	if UPDATE(DlDtlPrvsnPrvsnID) -- this should typically never fire since the provision can't be changed once saved, but is here for completeness
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Provision Type'
            ,IsNull((Select Prvsn.PrvsnDscrptn
                     From   Prvsn (nolock)
                     Where  Prvsn.PrvsnID = Deleted.DlDtlPrvsnPrvsnID
                    ), Convert(varchar,Deleted.DlDtlPrvsnPrvsnID))
            ,IsNull((Select Prvsn.PrvsnDscrptn
                     From   Prvsn (nolock)
                     Where  Prvsn.PrvsnID = Inserted.DlDtlPrvsnPrvsnID
                    ), Convert(varchar,Inserted.DlDtlPrvsnPrvsnID))
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID
	   

    if UPDATE(CrrncyID)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Price Currency'
            ,IsNull((Select Currency.CrrncyNme
                     From   Currency (nolock)
                     Where  Currency.CrrncyID = Deleted.CrrncyID
                    ), Convert(varchar,Deleted.CrrncyID))
            ,IsNull((Select Currency.CrrncyNme
                     From   Currency (nolock)
                     Where  Currency.CrrncyID = Inserted.CrrncyID
                    ), Convert(varchar,Inserted.CrrncyID))
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    if UPDATE(UOMID)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Price UOM'
            ,IsNull((Select UnitOfMeasure.UOMAbbv
                     From   UnitOfMeasure (nolock)
                     Where  UnitOfMeasure.UOM = Deleted.UOMID
                    ), Convert(varchar,Deleted.UOMID))
            ,IsNull((Select UnitOfMeasure.UOMAbbv
                     From   UnitOfMeasure (nolock)
                     Where  UnitOfMeasure.UOM = Inserted.UOMID
                    ), Convert(varchar,Inserted.UOMID))
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID


     if UPDATE(Status)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Status'
            ,Case Deleted.Status When 'A' Then 'Active' When 'I' Then 'Inactive' Else Deleted.Status End
            ,Case Inserted.Status When 'A' Then 'Active' When 'I' Then 'Inactive' Else Inserted.Status End
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

	  if UPDATE(TrnsctnTypID)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Transaction Type'
            ,IsNull((Select TransactionType.TrnsctnTypDesc
                     From   TransactionType (nolock)
                     Where  TransactionType.TrnsctnTypID = Deleted.TrnsctnTypID
                    ), Convert(varchar,Deleted.TrnsctnTypID))
            ,IsNull((Select TransactionType.TrnsctnTypDesc
                     From   TransactionType (nolock)
                     Where  TransactionType.TrnsctnTypID = Inserted.TrnsctnTypID
                    ), Convert(varchar,Inserted.TrnsctnTypID))
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    if UPDATE(DlDtlPrvsnFrmDte)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'From Date'
            ,Convert(varchar,Deleted.DlDtlPrvsnFrmDte,101) -- mm/dd/yyyy
            ,Convert(varchar,Inserted.DlDtlPrvsnFrmDte,101) -- mm/dd/yyyy
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    if UPDATE(DlDtlPrvsnToDte)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'To Date'
            ,Convert(varchar,Deleted.DlDtlPrvsnToDte,101) -- mm/dd/yyyy
            ,Convert(varchar,Inserted.DlDtlPrvsnToDte,101) -- mm/dd/yyyy
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID
	        
	  if UPDATE(QuantityBasis)
      Insert #Audit
      ( TxRleStID
       ,DlDtlPrvsnID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,Inserted.DlDtlPrvsnID
            ,'Quantity Basis'
            ,Case Deleted.QuantityBasis When 'N' Then 'Net Quantity' When 'G' Then 'Gross Quantity' When 'X' Then 'As Billed' Else Deleted.QuantityBasis End
            ,Case Inserted.QuantityBasis When 'N' Then 'Net Quantity' When 'G' Then 'Gross Quantity' When 'X' Then 'As Billed' Else Inserted.QuantityBasis End
      From   Inserted (nolock)
             left join Deleted (nolock)
                  on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
      Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    ----if UPDATE(DecimalPlaces)
    ----  Insert #Audit
    ----  ( TxRleStID
    ----   ,DlDtlPrvsnID
    ----   ,EntityChanged
    ----   ,OldValue
    ----   ,NewValue
    ----  )
    ----  Select @i_TxRleStID
    ----        ,Inserted.DlDtlPrvsnID
    ----        ,'Precision'
    ----        ,IsNull(Convert(varchar,Deleted.DecimalPlaces),'')
    ----        ,IsNull(Convert(varchar,Inserted.DecimalPlaces),'')
    ----  From   Inserted (nolock)
    ----         left join Deleted (nolock)
    ----              on Inserted.DlDtlPrvsnID = Deleted.DlDtlPrvsnID
    ----  Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

NextRecord:

    -- Process the next changed record
    Select @i_DlDtlPrvsnID = Min(Inserted.DlDtlPrvsnID)
    From   Inserted (nolock)
           join TaxProvision (nolock)
                on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
    Where  Inserted.DlDtlPrvsnID > @i_DlDtlPrvsnID

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

IF OBJECT_ID('dbo.tu_DealDetailProvision_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_DealDetailProvision_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_DealDetailProvision_MTV >>>'

go
