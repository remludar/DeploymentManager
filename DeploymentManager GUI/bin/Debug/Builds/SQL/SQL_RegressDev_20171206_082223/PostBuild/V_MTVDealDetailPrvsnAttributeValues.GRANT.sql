/*
*****************************************************************************************************
USE FIND AND REPLACE ON ViewName WITH YOUR view (NOTE:  v_CompanyName_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[V_MTVDealDetailPrvsnAttributeValues]    Script Date: DATECREATED ******/
PRINT 'Start Script=V_MTVDealDetailPrvsnAttributeValues.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[V_MTVDealDetailPrvsnAttributeValues]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.V_MTVDealDetailPrvsnAttributeValues TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View V_MTVDealDetailPrvsnAttributeValues >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View V_MTVDealDetailPrvsnAttributeValues >>>'
GO
