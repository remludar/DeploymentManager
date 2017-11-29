/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_RequestMessage WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_RequestMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_RequestMessage.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_RequestMessage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_RequestMessage] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_RequestMessage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_RequestMessage]
AS
--------------------------------------------------------------------------------------------------------------  
-- Purpose:  To allow navigation from the Search Event Log report to the Search Event Log Data report  
-- Created By: Pat Newgent  
-- Created:    6/10/2009  
--------------------------------------------------------------------------------------------------------------  
select  
   RequestMessageId  
   ,MessageTypeId  
   ,OriginalMessageTxt  
   ,CreateDt  
from RequestMessage  
  


GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_RequestMessage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_RequestMessage.sql'
			PRINT '<<< ALTERED View v_RequestMessage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_RequestMessage >>>'
	  END
