/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MotivaBuildStatisticsInsertUpdateSQLScripts.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MotivaBuildStatisticsInsertUpdateSQLScripts >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts] @ScriptName VARCHAR(500)  
AS

-- =============================================  
-- Author:        rlb  
-- Create date:   02/27/2013  
-- Description:   Used to Update or Insert SQL Scripts in MotivaBuildStat table for custom deployment  
-- =============================================  
-- Date         Modified By     Issue#  Modification  
-- -----------  --------------  ------  ---------------------------------------------------------------------  
  
-----------------------------------------------------------------------------  
SET NOCOUNT ON  
  
IF (SELECT Script FROM MotivaBuildStatistics WHERE MotivaBuildStatistics.Script = @ScriptName) IS NULL  
 BEGIN  
  INSERT MotivaBuildStatistics  
    (  
    Build  
    ,Script  
    ,CreationDate  
    )  
  SELECT NULL  
    ,@ScriptName  
    ,GETDATE()  
 END  
ELSE  
 BEGIN  
  UPDATE MotivaBuildStatistics  
  SET  Build   = NULL  
    ,ModifiedDate = GETDATE()  
  WHERE MotivaBuildStatistics.Script = @ScriptName  
 END  
  
SET NOCOUNT OFF  

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_sp_MotivaBuildStatisticsInsertUpdateSQLScripts.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MotivaBuildStatisticsInsertUpdateSQLScripts >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MotivaBuildStatisticsInsertUpdateSQLScripts >>>'
	  END