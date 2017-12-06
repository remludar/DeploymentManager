/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [db_datareader].[MTV_GetTempMarkToMarket]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTempMarkToMarket.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[db_datareader].[MTVTempMarkToMarket]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [db_datareader].[MTVTempMarkToMarket] to sysuser, RightAngleAccess
	GRANT SELECT ON [db_datareader].[MTVTempMarkToMarket] to RiskDataUser
	
    PRINT '<<< GRANTED RIGHTS on Table MTVTempMarkToMarket >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTempMarkToMarket >>>'

