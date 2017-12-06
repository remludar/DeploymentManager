/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_NotTCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationOrigin_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_NotTCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationOrigin_NotTCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'