SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_TaxLocation_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_TaxLocation_MTV
    IF OBJECT_ID('dbo.tu_TaxLocation_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_TaxLocation_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_TaxLocation_MTV >>>'
  END
go


CREATE trigger tu_TaxLocation_MTV on dbo.TaxLocation AFTER UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       tu_TaxLocation_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom update trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of updated TaxLocation records;
--             NOTE: This trigger should only fire if the Operator ('Is' or 'Is Not') is changed, since any
--                   other changes would be a change to the overall primary key (which forces a delete and insert)
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


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
 ,EntityChanged  varchar(200)
 ,OldValue       varchar(max)
 ,NewValue       varchar(max)
)

Create Table #TL
( Idnty          int IDENTITY(1,1)
 ,TxID           int
 ,TxRleStID      int
 ,TxRleID        int
 ,TxLctnTpeID    int
 ,LcleID         int
 ,Operator       char(2)
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
           join TaxRuleSet (nolock)
                on Inserted.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End


-- Populate the #TL temp table with all of the updated records so that we can attach an Idnty column to each record
-- and process them one-by-one; there is no single unique key for the TaxLocation table

Insert #TL
( TxID
 ,TxRleStID
 ,TxRleID
 ,TxLctnTpeID
 ,LcleID
 ,Operator
)
Select Inserted.TxID
      ,Inserted.TxRleStID
      ,Inserted.TxRleID
      ,Inserted.TxLctnTpeID
      ,Inserted.LcleID
      ,Inserted.Operator
From   Inserted
Order By Inserted.TxRleStID
        ,Inserted.TxRleID
        ,Inserted.TxLctnTpeID

--
-- Insert a record into the MTV_TaxAudit table for each field on each updated record
--

-- Determine the first updated record to process
Select @i_Idnty = Min(Idnty)
From   #TL (nolock)

While @i_Idnty IS NOT NULL
  Begin

      Insert #Audit
      ( TxRleStID
       ,EntityChanged
       ,OldValue
       ,NewValue
      )
      Select #TL.TxRleStID
            ,Coalesce(TaxRule.Description, Convert(varchar,#TL.TxRleID))
            ,Coalesce(TaxLocationType.TxLctnTpeNme, Convert(varchar,Deleted.TxLctnTpeID)) +
             ' ' + Case Deleted.Operator When '=' Then 'Is' When '<>' Then 'Is Not' Else Deleted.Operator End + ' ' +
             Coalesce(Locale.LcleNme, Convert(varchar,Deleted.LcleID))
            ,Coalesce(TaxLocationType.TxLctnTpeNme, Convert(varchar,#TL.TxLctnTpeID)) +
             ' ' + Case #TL.Operator When '=' Then 'Is' When '<>' Then 'Is Not' Else #TL.Operator End + ' ' +
             Coalesce(Locale.LcleNme, Convert(varchar,#TL.LcleID))
      From   #TL
             left join Deleted (nolock)
                  on #TL.TxID = Deleted.TxID
                 and #TL.TxRleStID = Deleted.TxRleStID
                 and #TL.TxRleID = Deleted.TxRleID
                 and #TL.TxLctnTpeID = Deleted.TxLctnTpeID
                 and #TL.LcleID = Deleted.LcleID
             -- I'm only joining to the following tables once, since these tables are based on the key fields, which should
             -- be the same between Inserted (#TL) and Deleted -- otherwise this Update trigger wouldn't have fired
             left join TaxRule (nolock)
                  on #TL.TxRleID = TaxRule.TxRleID
             left join TaxLocationType (nolock)
                  on #TL.TxLctnTpeID = TaxLocationType.TxLctnTpeID
             left join Locale (nolock)
                  on #TL.LcleID = Locale.LcleID
      Where  #TL.Idnty = @i_Idnty


NextRecord:

    -- Process the next updated record
    Select @i_Idnty = Min(Idnty)
    From   #TL (nolock)
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
      ,'Rules'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By #Audit.Idnty

Drop Table #Audit
Drop Table #TL

return

end

GO


IF OBJECT_ID('dbo.tu_TaxLocation_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_TaxLocation_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_TaxLocation_MTV >>>'

go
