/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[[MTVCreditInterfaceExternalExposure]]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTVCreditInterfaceExternalExposure].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceExternalExposure]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTVCreditInterfaceExternalExposure] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTVCreditInterfaceExternalExposure] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTVCreditInterfaceExternalExposure] >>>'


