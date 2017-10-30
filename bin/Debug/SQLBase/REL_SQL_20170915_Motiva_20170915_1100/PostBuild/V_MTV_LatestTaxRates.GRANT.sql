/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_LatestTaxRates WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_LatestTaxRates [dbo].[v_MTV_LatestTaxRates]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_LatestTaxRates.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_LatestTaxRates]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_LatestTaxRates TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_LatestTaxRates >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_LatestTaxRates >>>'
GO
