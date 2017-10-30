SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.ti_TaxProvision_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.ti_TaxProvision_MTV
    IF OBJECT_ID('dbo.ti_TaxProvision_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.ti_TaxProvision_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.ti_TaxProvision_MTV >>>'
  END
go


CREATE trigger ti_TaxProvision_MTV on dbo.TaxProvision AFTER INSERT as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       ti_TaxProvision_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom insert trigger will update any records in the custom MTV_TaxAudit table that are associated
--             with the DlDtlPrvsnID *and* have a NULL TxRleStID in the MTV_TaxAudit.  This is necessary because the Insert
--             trigger on DealDetailProvision fires BEFORE a record is inserted into TaxProvision, which leaves us with
--             no way to determine the associated TaxRuleSet for auditing purposes
-- Created by: Eric Wallerstein
-- History:    06/25/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/25/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
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

Declare @i_DlDtlPrvsnID    int
       ,@i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)


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
           join TaxRuleSet (nolock)
                on Inserted.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End


-- Determine the first inserted record to process
Select @i_DlDtlPrvsnID = Min(Inserted.DlDtlPrvsnID)
From   Inserted (nolock)


While @i_DlDtlPrvsnID IS NOT NULL
  Begin

    -- Get the TxRleStID
    Select @i_TxRleStID = Inserted.TxRleStID
    From   Inserted
    Where  Inserted.DlDtlPrvsnID = @i_DlDtlPrvsnID

    --
    -- Update any records in the MTV_TaxAudit table that are associated with this DlDtlPrvsnID and which have a NULL UserID
    --

    Update MTV_TaxAudit
    Set    UserID = @i_UserID
          ,UserDBMnkr = @vc_User
          ,TxRleStID = @i_TxRleStID
    Where  MTV_TaxAudit.DlDtlPrvsnID = @i_DlDtlPrvsnID
      and  MTV_TaxAudit.TxRleStID is NULL


	INSERT INTO MTVTaxProvision(inserted.TxId, inserted.txRleStID, TRS.Description, inserted.DlDtlPrvsnId)
	SELECT Inserted.TxId, Inserted.TxRleStID, Description, Inserted.DlDtlPrvsnId
	FROM Inserted LEFT JOIN TaxRuleSet TRS ON TRS.TxRleStID = inserted.TxRleStID


NextRecord:

    -- Process the next inserted record
    Select @i_DlDtlPrvsnID = Min(Inserted.DlDtlPrvsnID)
    From   Inserted (nolock)
    Where  Inserted.DlDtlPrvsnID > @i_DlDtlPrvsnID

  End


return

end

GO

IF OBJECT_ID('dbo.ti_TaxProvision_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.ti_TaxProvision_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.ti_TaxProvision_MTV >>>'

go
