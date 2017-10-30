/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_BAProdOriginLocDealDetails WITH YOUR view 
*****************************************************************************************************
*/

/****** Object:  v_BAProdOriginLocDealDetails [dbo].[v_BAProdOriginLocDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_BAProdOriginLocDealDetails.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdOriginLocDealDetails]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_BAProdOriginLocDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_BAProdOriginLocDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_BAProdOriginLocDealDetails >>>'
GO
