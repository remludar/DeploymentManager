SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.ti_TaxRuleSet_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.ti_TaxRuleSet_MTV
    IF OBJECT_ID('dbo.ti_TaxRuleSet_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.ti_TaxRuleSet_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.ti_TaxRuleSet_MTV >>>'
  END
go


CREATE trigger ti_TaxRuleSet_MTV on dbo.TaxRuleSet AFTER INSERT as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       ti_TaxRuleSet_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom insert trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of new TaxRuleSet records
-- Created by: Eric Wallerstein
-- History:    06/12/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/12/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
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
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON 

Declare @i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
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
                ,@i_UserID = Inserted.RevisionUserID
    From   Inserted (nolock)
           left join Users (nolock)
                on Inserted.RevisionUserID = Users.UserID
  End


--
-- Insert a record into the MTV_TaxAudit table for each updated field on each changed record
--

-- Determine the first inserted record to process
Select @i_TxRleStID = Min(TxRleStID)
From   Inserted (nolock)

While @i_TxRleStID IS NOT NULL
  Begin

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Description'
            ,'<NEW>'
            ,Inserted.Description
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'From Date'
            ,'<NEW>'
            ,Convert(varchar,Inserted.FromDate,101) -- mm/dd/yyyy
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'To Date'
            ,'<NEW>'
            ,Convert(varchar,Inserted.ToDate,101) -- mm/dd/yyyy
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Type'
            ,'<NEW>'
            ,Case Inserted.Type When 'M' Then 'Movement' When 'F' Then 'Financial' Else Inserted.Type End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Status'
            ,'<NEW>'
            ,Case Inserted.Status When 'A' Then 'Active' When 'I' Then 'Inactive' Else Inserted.Status End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Load Fee'
            ,'<NEW>'
            ,Case Inserted.IsLoadFee When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.IsLoadFee End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Capped Tax'
            ,'<NEW>'
            ,Case Inserted.IsCappedTax When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.IsCappedTax End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'VAT Tax'
            ,'<NEW>'
            ,Case Inserted.IsVATTax When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.IsVATTax End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Embedded Tax'
            ,'<NEW>'
            ,Case Inserted.IsEmbeddedTax When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.IsEmbeddedTax End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Responsible Party'
            ,'<NEW>'
            ,Case Inserted.ResponsibleParty When 'B' Then 'Buyer' When 'S' Then 'Seller' Else Inserted.ResponsibleParty End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Create Remittable'
            ,'<NEW>'
            ,Case Inserted.CreateRemittable When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.CreateRemittable End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Invoiceable'
            ,'<NEW>'
            ,Case Inserted.Invoiceable When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.Invoiceable End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Allow Exemption'
            ,'<NEW>'
            ,Case Inserted.AllowExemption When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.AllowExemption End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Allow Deferred Billing'
            ,'<NEW>'
            ,Case Inserted.AllowDeferedBilling When 'Y' Then 'Yes' When 'N' Then 'No' When 'A' Then 'Always Defer' Else Inserted.AllowDeferedBilling End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Deferred Tax Term'
            ,'<NEW>'
            ,IsNull((Select Term.TrmAbbrvtn
                     From   Term (nolock)
                     Where  Term.TrmID = Inserted.TrmID
                    ),'(None)')
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Invoicing Description'
            ,'<NEW>'
            ,Inserted.InvoicingDescription
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'No Buyer License Indicates'
            ,'<NEW>'
            ,Case Inserted.NoBuyerLicenseFound When 'N' Then 'Non-Exempt' When 'E' Then 'Exempt' When 'S' Then 'Setup Error' Else Inserted.NoBuyerLicenseFound End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'No Seller License Indicates'
            ,'<NEW>'
            ,Case Inserted.NoSellerLicenseFound When 'N' Then 'Non-Exempt' When 'E' Then 'Exempt' When 'S' Then 'Setup Error' Else Inserted.NoSellerLicenseFound End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Use Position Holder Logic'
            ,'<NEW>'
            ,Case Inserted.UsePositionHolderLogic When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.UsePositionHolderLogic End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select @i_TxRleStID
            ,'Use Rack Movement Logic'
            ,'<NEW>'
            ,Case Inserted.UseRackLogic When 'Y' Then 'Yes' When 'N' Then 'No' Else Inserted.UseRackLogic End
      From   Inserted (nolock)
      Where  Inserted.TxRleStID = @i_TxRleStID


NextRecord:

    -- Process the next inserted record
    Select @i_TxRleStID = Min(TxRleStID)
    From   Inserted (nolock)
    Where  TxRleStID > @i_TxRleStID

  End

Insert MTV_TaxAudit
(DateModified
,UserID
,UserDBMnkr
,TxRleStID
,TabChanged
,EntityChanged
,OldValue
,NewValue
)
Select Current_TimeStamp
      ,@i_UserID
      ,@vc_User
      ,#Audit.TxRleStID
      ,'Properties'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By #Audit.Idnty

Drop Table #Audit

return

end

GO


IF OBJECT_ID('dbo.ti_TaxRuleSet_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.ti_TaxRuleSet_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.ti_TaxRuleSet_MTV >>>'

go
