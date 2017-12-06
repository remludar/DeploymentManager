

/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSContractData_Grant WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTVTMSContractData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSContractData.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractData]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSContractData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSContractData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSContractData >>>'

GO