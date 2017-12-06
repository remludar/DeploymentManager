/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_Invoice_Template_Instructions_MTV_RINS WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[SP_Invoice_Template_Instructions_MTV_RINS]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions_MTV_RINS.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_Invoice_Template_Instructions_MTV_RINS]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SP_Invoice_Template_Instructions_MTV_RINS TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SP_Invoice_Template_Instructions_MTV_RINS >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SP_Invoice_Template_Instructions_MTV_RINS >>>'
GO
