PRINT 'Start Script=MOT_Get_Movements_to_Automatch.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Get_Movements_to_Automatch]') IS NOT NULL
BEGIN
    GRANT  EXECUTE  ON dbo.MOT_Get_Movements_to_Automatch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_Get_Movements_to_Automatch >>>' 
END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_Get_Movements_to_Automatch >>>'
GO


