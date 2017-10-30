PRINT 'Start Script=v_MTV_SAPARStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPARStatus]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_SAPARStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_SAPARStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_SAPARStatus >>>'
GO
