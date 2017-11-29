/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_BAProdDestLocDealDetails WITH YOUR view 
*****************************************************************************************************
*/

/****** Object:  v_BAProdDestLocDealDetails [dbo].[v_BAProdDestLocDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_BAProdDestLocDealDetails.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdDestLocDealDetails]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_BAProdDestLocDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_BAProdDestLocDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_BAProdDestLocDealDetails >>>'
GO
