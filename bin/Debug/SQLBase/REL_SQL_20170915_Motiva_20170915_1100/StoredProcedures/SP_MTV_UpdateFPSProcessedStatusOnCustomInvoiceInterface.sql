/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter PROCEDURE [dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface] 
   @MessageIDS varchar(max)
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  11/10/2015
-- Description:   To update the FPS Processed Status on the table (custom invoice interface)
-- =============================================
-- Date         Modified By     Issue#  Modification 
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- THIS IS DEPRECATED, MOTIVA CODEBASE NO LONGER USES THIS SP
-----------------------------------------------------------------------------
Declare		@vc_Error					varchar(255)

Begin Try

	UPDATE	CII
			SET CII.FPSProcessedStatus = 'Y'
		FROM	CustomInvoiceInterface CII
		INNER JOIN dbo.fnParseList(',',@MessageIDS) as MessageQueueIDS
			ON MessageQueueIDS.Data = CII.MessageQueueID

End Try
Begin Catch						
		Select	@vc_Error	=  ERROR_MESSAGE()	
		GoTo	Error	
End Catch	

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	
		
----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
Raiserror (60010,-1,-1, @vc_Error	)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>'
	  END