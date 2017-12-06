

/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_MTV_Schedule_Single_Process WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[SP_MTV_Schedule_Single_Process]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTV_Schedule_Single_Process.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_MTV_Schedule_Single_Process]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SP_MTV_Schedule_Single_Process TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SP_MTV_Schedule_Single_Process >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SP_MTV_Schedule_Single_Process >>>'

GO