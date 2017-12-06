SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_TaxRuleSetGeneralComments_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_TaxRuleSetGeneralComments_MTV
    IF OBJECT_ID('dbo.tu_TaxRuleSetGeneralComments_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_TaxRuleSetGeneralComments_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_TaxRuleSetGeneralComments_MTV >>>'
  END
go


CREATE trigger tu_TaxRuleSetGeneralComments_MTV on dbo.GeneralComment AFTER UPDATE as
--CREATE trigger tu_TaxRuleSetGeneralComments_MTV on dbo.GeneralComment INSTEAD OF UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       ti_TaxRuleSetGeneralComments_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom insert trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of new TaxRuleSetComments records
-- Created by: Eric Wallerstein
-- History:    06/13/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/13/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
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

Declare @i_Idnty           int
       ,@i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)
	   ,@txt_oldComments	varchar(max)
	   ,@txt_Comments		varchar(max)


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
 ,EntityChanged  varchar(200)
 ,OldValue       varchar(max)
 ,NewValue       varchar(max)
)

Create Table #GeneralComments
( Idnty             int IDENTITY(1,1)
 ,GnrlCmntQlfr		varchar(50)
 ,GnrlCmntHdrID	          int
 ,GnrlCmntDtlID	            int
 ,GnrlCmtTxtOldVal	varchar(max)
 ,GnrlCmntTxt	     varchar(max)
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
           join TaxRuleSet (nolock) on Inserted.GnrlCmntHdrID = TaxRuleSet.TxRleStID
           left join Users (nolock) on TaxRuleSet.RevisionUserID = Users.UserID
  End


-- Populate the #GeneralComments temp table with all of the inserted records so that we can attach an Idnty column to each record
-- and process them one-by-one; there is no single unique key for the TaxRuleSetLicense table
Select @i_TxRleStID = Min(GnrlCmntHdrID) from Inserted Where GnrlCmntQlfr = 'TaxRuleSetComment'


IF UPDATE (GnrlCmntTxt)

Insert #GeneralComments
( 
  GnrlCmntQlfr
 ,GnrlCmntHdrID	          
 ,GnrlCmntDtlID	  
 ,GnrlCmtTxtOldVal  
 ,GnrlCmntTxt	     
)
Select 
	   Inserted.GnrlCmntQlfr
	  ,Inserted.GnrlCmntHdrID
      ,Inserted.GnrlCmntDtlID
	  ,''
	  ,''
From   Inserted
Where  Inserted.GnrlCmntQlfr = 'TaxRuleSetComment'


-- The general comments txt field is of type text which is not allowed to be used in the trigger's inserted and deleted virtual table
-- a custom history table is created to keep a history of the previous and updated comments. 
-- this table was also created because an INSTEAD TRIGGER could not be used because that would involve the trigger making an insert into the GeneralComment table which is a core table.

-- Get current old value stored in custom history comment table
select @txt_oldComments = GnrlCmntTxtNewValue from MTV_GeneralComment gc
						  inner join Inserted on gc.GnrlCmntHdrID = Inserted.GnrlCmntHdrID  
						  where gc.GnrlCmntHdrID=Inserted.GnrlCmntHdrID AND gc.GnrlCmntQlfr ='TaxRuleSetComment' 

--- update the custom history table with the newly updated comment in the 
UPDATE dbo.MTV_GeneralComment SET GnrlCmntTxtOldValue =  @txt_oldComments , GnrlCmntTxtNewValue = GeneralComment.GnrlCmntTxt
from MTV_GeneralComment gc inner join GeneralComment  on gc.GnrlCmntHdrID = GeneralComment.GnrlCmntHdrID
WHERE gc.GnrlCmntHdrID=GeneralComment.GnrlCmntHdrID and gc.GnrlCmntQlfr = 'TaxRuleSetComment'  

-- Update #GeneralComments using from the custom comment table. This way will avoid us having to use the Inserted virtual table
BEGIN
	UPDATE #GeneralComments
	Set #GeneralComments.GnrlCmntTxt = MTV_GeneralComment.GnrlCmntTxtNewValue, #GeneralComments.GnrlCmtTxtOldVal = MTV_GeneralComment.GnrlCmntTxtOldValue
	From #GeneralComments , GeneralComment inner join MTV_GeneralComment ON GeneralComment.GnrlCmntHdrID = MTV_GeneralComment.GnrlCmntHdrID	
	Where #GeneralComments.GnrlCmntHdrID = GeneralComment.GnrlCmntHdrID
END


-- Determine the first updated record to process
Select @i_Idnty = Min(Idnty)
From   #GeneralComments (nolock)

While @i_Idnty IS NOT NULL
  Begin
       Insert  #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
        Select
	        --Inserted.GnrlCmntHdrID
			#GeneralComments.GnrlCmntHdrID
            ,'Comments'
            ,#GeneralComments.GnrlCmtTxtOldVal
		    ,#GeneralComments.GnrlCmntTxt
		From #GeneralComments
		where #GeneralComments.Idnty = @i_Idnty

NextRecord:
		-- Process the next inserted record
		Select @i_Idnty = Min(Idnty)
		From   #GeneralComments (nolock)
		Where  Idnty > @i_Idnty
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
      ,'Comments'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By #Audit.Idnty

Drop Table #Audit
Drop Table #GeneralComments

Return

end

GO


IF OBJECT_ID('dbo.tu_TaxRuleSetGeneralComments_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_TaxRuleSetGeneralComments_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_TaxRuleSetGeneralComments_MTV >>>'

GO
