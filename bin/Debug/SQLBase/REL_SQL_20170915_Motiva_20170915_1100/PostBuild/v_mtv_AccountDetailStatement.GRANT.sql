
/****** Object:   [dbo].[v_mtv_AccountDetailStatement]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_mtv_AccountDetailStatement.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_mtv_AccountDetailStatement]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_mtv_AccountDetailStatement TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_mtv_AccountDetailStatement >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_mtv_AccountDetailStatement >>>'
