
/****** Object:  ViewName [dbo].[v_MTV_AcctDtl_AcctCodes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AcctDtl_AcctCodes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AcctDtl_AcctCodes]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AcctDtl_AcctCodes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AcctDtl_AcctCodes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AcctDtl_AcctCodes >>>'
