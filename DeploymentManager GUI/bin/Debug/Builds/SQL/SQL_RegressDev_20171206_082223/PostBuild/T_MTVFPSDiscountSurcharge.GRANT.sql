/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSDiscountSurcharge]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSDiscountSurcharge.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSDiscountSurcharge]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSDiscountSurcharge] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSDiscountSurcharge >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSDiscountSurcharge >>>'
