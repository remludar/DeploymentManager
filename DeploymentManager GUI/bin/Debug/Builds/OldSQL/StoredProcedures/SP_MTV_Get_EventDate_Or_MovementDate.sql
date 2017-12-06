/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_EventDate_Or_MovementDate WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Get_EventDate_Or_MovementDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_EventDate_Or_MovementDate.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_EventDate_Or_MovementDate]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Get_EventDate_Or_MovementDate] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Get_EventDate_Or_MovementDate]  @vc_EventName     VarChar(80),
                    @c_Estimate       Char(1) = null,
                    @i_DlHdrID        Int,
                    @i_DlDtlID        Int,
                    @i_PlnndTrnsfrID  Int = null,
                    @i_XHdrID         Int = null,
					@dt_MovementDate  SmallDateTime = null
AS

-----------------------------------------------------------------------------------------------------------------------------
-- Name:	    MTV_Get_EventDate_Or_MovementDate
-- Overview:	SP_Get_EventDate returns a 1 X 2 array, consisting of the Event Date & the Actual/NotActual Event usage flag.
--              This SP calls SP_Get_EventDate and then specifies which column of the array should be used for valuation.
--              If the EventDate is not present, it will use the Transfer's Est. Movement Date for non-moved valuations
--              and the Movement's Movement dAte for moved (actualized) valuations.
-- Created by:	Bartt Shelton
-- History:	    06/10/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

----------------------------------------------------------------------------------------------------------------------

-- Declarations.

----------------------------------------------------------------------------------------------------------------------

DECLARE @dt_EventDate SmallDateTime,

        @dt_PTEstMovDate SmallDateTime,

        @SQL VarChar(500) = ''

IF OBJECT_ID('tempdb..#SP_Get_EventDate_Results') IS NOT NULL DROP TABLE #SP_Get_EventDate_Results

CREATE TABLE #SP_Get_EventDate_Results (EventDate DateTime, IsActual VarChar(100))

INSERT INTO #SP_Get_EventDate_Results (EventDate, IsActual)

EXECUTE SP_Get_EventDate @vc_EventName, '', @i_DlHdrID, @i_DlDtlID, @i_PlnndTrnsfrID, @i_XHdrID

SELECT @dt_EventDate = (SELECT TOP 1 #SP_Get_EventDate_Results.EventDate FROM #SP_Get_EventDate_Results

                        --WHERE #SP_Get_EventDate_Results.IsActual = ''

						),

       @dt_PTEstMovDate = (SELECT PT.EstimatedMovementDate

	                       FROM PlannedTransfer PT

						   WHERE PT.PlnndTrnsfrID = @i_PlnndTrnsfrID)

IF @i_XHdrID IS NULL

   SELECT ISNULL(@dt_EventDate, @dt_PTEstMovDate)

   ELSE SELECT ISNULL(@dt_EventDate, @dt_MovementDate)

IF OBJECT_ID('tempdb..#SP_Get_EventDate_Results') IS NOT NULL DROP TABLE #SP_Get_EventDate_Results

IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_EventDate_Or_MovementDate]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Get_EventDate_Or_MovementDate.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>'
	  END