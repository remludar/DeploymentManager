/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  MTV_TaxDetail [dbo].[v_MTV_TaxDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxDetail]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxDetail >>>'
GO
