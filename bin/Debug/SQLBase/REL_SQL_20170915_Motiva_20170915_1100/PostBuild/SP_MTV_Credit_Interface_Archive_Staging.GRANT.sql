/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[[MTVCreditInterfaceStagingArchive]]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTV_Credit_Interface_Archive_Staging].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Interface_Archive_Staging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTV_Credit_Interface_Archive_Staging] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTV_Credit_Interface_Archive_Staging] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTV_Credit_Interface_Archive_Staging] >>>'