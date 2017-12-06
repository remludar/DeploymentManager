/*
*****************************************************************************************************
USE FIND AND REPLACE ON OASActualXRef WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_sp_OASActualXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_OASActualXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OASActualXRef]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_OASActualXRef] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_OASActualXRef >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_OASActualXRef] @RowId INT = NULL, @BOL VARCHAR(9) = NULL
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  10/06/2015
-- Description:   Xreference and error scrub OAS Actual information
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_OASActualXRef 18
-----------------------------------------------------------------------------

/*
--------------------------------------------
--DETERMINE ROWS TO PROCESS
--------------------------------------------
*/
CREATE TABLE #OASActualProcess (PTID INT) CREATE CLUSTERED INDEX IDX_C_OASActualProcess_PTID ON #OASActualProcess(PTID)

IF (@RowId IS NOT NULL AND @BOL IS NULL)
BEGIN
	INSERT	#OASActualProcess
	SELECT	OASID
	FROM	MTVOASActualStaging
	WHERE	MTVOASActualStaging.TicketStatus NOT IN ('C','I')
	AND		MTVOASActualStaging.OASID = @RowId
END
ELSE IF (@RowId IS NULL AND @BOL IS NOT NULL)
BEGIN
	INSERT	#OASActualProcess
	SELECT	OASID
	FROM	MTVOASActualStaging
	WHERE	MTVOASActualStaging.TicketStatus NOT IN ('C','I')
	AND		MTVOASActualStaging.BOLNumber = @BOL
END
ELSE IF (@RowId IS NOT NULL AND @BOL IS NOT NULL)
BEGIN
	INSERT	#OASActualProcess
	SELECT	OASID
	FROM	MTVOASActualStaging
	WHERE	MTVOASActualStaging.TicketStatus NOT IN ('C','I')
	AND		MTVOASActualStaging.BOLNumber = @BOL
	AND		MTVOASActualStaging.OASID = @RowId
END
ELSE
BEGIN
	INSERT	#OASActualProcess
	SELECT	OASID
	FROM	MTVOASActualStaging
	WHERE	MTVOASActualStaging.TicketStatus NOT IN ('C','I')
END

/*
--------------------------------------------
--Get XReference data for Lunderby Interface
--------------------------------------------
*/
DECLARE	@SourceSystemID	INT
		,@i_SQLError	INT
		
SELECT	@SourceSystemID	= SourceSystem.SrceSystmID FROM	SourceSystem WHERE SourceSystem.Name	= 'OASActual'

SELECT	ElementName
		,ElementValue AS LDRValue
		,InternalValue AS SRAValue
		,StartDate
		,EndDate
INTO	#XRefWorkerTable
--select *
FROM	SourceSystemElement (NOLOCK)
INNER JOIN  SourceSystemElementXref (NOLOCK)
ON  SourceSystemElementXref.SrceSystmElmntID	= SourceSystemElement.SrceSystmElmntID
WHERE  SourceSystemElement.SrceSystmID	= @SourceSystemID

--select * from #XRefWorkerTable
--select * from #OASActualProcess

/*
CREATE MOVEMENT DATE
*/
UPDATE	MTVOASActualStaging
SET		MTVOASActualStaging.EndDate = MTVOASActualStaging.EndDate
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.EndDate IS NULL

/*
---------------------------------------------------------------
We will now try to find matching enteries in CORE SRA Tables
and assign IDS.  If no match is found, we will fall back to the 
XREFERNCE setup to try and find the data
---------------------------------------------------------------
*/

--ProductCode
--UPDATE	MTVOASActualStaging
--SET		RAPrdctID	= #XRefWorkerTable.SRAValue
----SELECT	*
--FROM	MTVOASActualStaging
--INNER JOIN #OASActualProcess
--ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
--INNER JOIN	#XRefWorkerTable
--ON		LTRIM(RTRIM(MTVOASActualStaging.ProductCode))	= #XRefWorkerTable.LDRValue
--AND		#XRefWorkerTable.StartDate	<= MTVOASActualStaging.EndDate
--AND		#XRefWorkerTable.EndDate	>= MTVOASActualStaging.EndDate
--AND		#XRefWorkerTable.ElementName	= 'ProductCode'
--WHERE	MTVOASActualStaging.RAPrdctID IS NULL
select *
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID

--RACompanyBAID (Sender)
UPDATE	MTVOASActualStaging
SET		RACompanyBAID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOASActualStaging.Sender))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.EndDate	>= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.ElementName	= 'Sender'
WHERE	MTVOASActualStaging.RACompanyBAID IS NULL

--RALocaleId (Location)
UPDATE	MTVOASActualStaging
SET		RALocaleId	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOASActualStaging.Location))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.EndDate	>= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.ElementName	= 'Location'
WHERE	MTVOASActualStaging.RALocaleId IS NULL



--RAContactID (PersonToBeNotified)
UPDATE	MTVOASActualStaging
SET		RAContactID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOASActualStaging.PersonToBeNotified))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOASActualStaging.EndDate   --MTVOASActualStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.ElementName	= 'PersonToBeNotified'
WHERE	MTVOASActualStaging.RAContactID IS NULL

--RADestLocaleID (PortDesc)
UPDATE	MTVOASActualStaging
SET		RADestLocaleID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOASActualStaging.PortDesc))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOASActualStaging.EndDate   --MTVOASActualStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVOASActualStaging.EndDate
AND		#XRefWorkerTable.ElementName	= 'PortDesc'
WHERE	MTVOASActualStaging.RAContactID IS NULL


/*
---------------------------------------------------------
Let's Do some Error Checking before we interface the data
---------------------------------------------------------
*/
--RESET MESSAGES IN TABLE
UPDATE	MTVOASActualStaging
SET		MTVOASActualStaging.ErrorMessage = NULL
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.ErrorMessage IS NOT NULL

--RESET STATUS IN TABLE
UPDATE	MTVOASActualStaging
SET		MTVOASActualStaging.TicketStatus = 'N'
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.TicketStatus = 'E'

--NULL RAPrdctID
UPDATE	MTVOASActualStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find OASActual ProductCode|| '
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.RAPrdctID IS NULL

--NULL RACompanyBAID
UPDATE	MTVOASActualStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= 'Can not find OASActual CompanyID|| '
FROM	MTVOASActualStaging (NOLOCK)
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.RACompanyBAID IS NULL

--NULL RALocaleId
UPDATE	MTVOASActualStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find OASActual Location|| '
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.RALocaleId IS NULL



--NULL RAContactID
UPDATE	MTVOASActualStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find OASActual ContactID|| '
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.RAContactID IS NULL

--NULL RADestLocaleID
UPDATE	MTVOASActualStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find OASActual RADestLocaleID|| '
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	MTVOASActualStaging.RADestLocaleID IS NULL


UPDATE	MTVOASActualStaging
SET		ErrorMessage	= ISNULL(ErrorMessage,'') + 'Please verify Cross-Reference setup to correct errors.'
FROM	MTVOASActualStaging
INNER JOIN #OASActualProcess
ON	MTVOASActualStaging.OASID = #OASActualProcess.PTID
WHERE	TicketStatus	= 'E'

/*
--Now let's find all movements in error and check for nonerror
--related lines to display a warning message as to why it was not loaded
*/

SELECT	BOLNumber
INTO	#IAMINERROR
FROM	MTVOASActualStaging
WHERE	TicketStatus	= 'E'

UPDATE	MTVOASActualStaging
SET		MTVOASActualStaging.ErrorMessage = 'INFO:  Related Line item is in error, cannot load until all errors are resolved or in an ignore status'
FROM	MTVOASActualStaging
INNER JOIN	#IAMINERROR
ON	MTVOASActualStaging.BOLNumber = #IAMINERROR.BOLNumber
WHERE	TicketStatus	IN ('N','M')
AND		ErrorMessage IS NULL


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_OASActualXRef]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_OASActualXRef.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_OASActualXRef >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_OASActualXRef >>>'
	  END


	 