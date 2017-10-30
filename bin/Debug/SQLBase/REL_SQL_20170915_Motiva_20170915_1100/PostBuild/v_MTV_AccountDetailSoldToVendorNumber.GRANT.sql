/*
*****************************************************************************************************
USE FIND AND REPLACE ON DealSoldToVendorNumber WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  DealSoldToVendorNumber [dbo].[v_MTV_AccountDetailSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailSoldToVendorNumber]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AccountDetailSoldToVendorNumber TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AccountDetailSoldToVendorNumber >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AccountDetailSoldToVendorNumber >>>'
