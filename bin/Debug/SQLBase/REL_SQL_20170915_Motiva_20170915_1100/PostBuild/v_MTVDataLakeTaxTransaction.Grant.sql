/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVDataLakeTaxTransaction WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVDataLakeTaxTransaction [dbo].[v_MTVDataLakeTaxTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVDataLakeTaxTransaction.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVDataLakeTaxTransaction]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVDataLakeTaxTransaction TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVDataLakeTaxTransaction >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVDataLakeTaxTransaction >>>'
GO
