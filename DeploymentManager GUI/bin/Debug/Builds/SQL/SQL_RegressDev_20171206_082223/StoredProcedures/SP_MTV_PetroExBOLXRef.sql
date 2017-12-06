/*
*****************************************************************************************************
USE FIND AND REPLACE ON PetroExBOLXRef WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_sp_PetroExBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_PetroExBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_PetroExBOLXRef]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_PetroExBOLXRef] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_PetroExBOLXRef >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_PetroExBOLXRef] @RowId INT = NULL, @BOL VARCHAR(9) = NULL
AS

-- =============================================
-- Author:        Ryan Borgman
-- Create date:	  10/16/2014
-- Description:   Xreference and error scrub PetroEx information
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_PetroExBOLXRef 18
-----------------------------------------------------------------------------

/*
--------------------------------------------
--DETERMINE ROWS TO PROCESS
--------------------------------------------
*/
CREATE TABLE #PetroExProcess (PTID INT) CREATE CLUSTERED INDEX IDX_C_PetroExProcess_PTID ON #PetroExProcess(PTID)

IF (@RowId IS NOT NULL AND @BOL IS NULL)
BEGIN
	INSERT	#PetroExProcess
	SELECT	MPESID
	FROM	MTVPetroExStaging
	WHERE	MTVPetroExStaging.TicketStatus NOT IN ('C','I')
	AND		MTVPetroExStaging.MPESID = @RowId
END
ELSE IF (@RowId IS NULL AND @BOL IS NOT NULL)
BEGIN
	INSERT	#PetroExProcess
	SELECT	MPESID
	FROM	MTVPetroExStaging
	WHERE	MTVPetroExStaging.TicketStatus NOT IN ('C','I')
	AND		MTVPetroExStaging.BOLNumber = @BOL
END
ELSE IF (@RowId IS NOT NULL AND @BOL IS NOT NULL)
BEGIN
	INSERT	#PetroExProcess
	SELECT	MPESID
	FROM	MTVPetroExStaging
	WHERE	MTVPetroExStaging.TicketStatus NOT IN ('C','I')
	AND		MTVPetroExStaging.BOLNumber = @BOL
	AND		MTVPetroExStaging.MPESID = @RowId
END
ELSE
BEGIN
	INSERT	#PetroExProcess
	SELECT	MPESID
	FROM	MTVPetroExStaging
	WHERE	MTVPetroExStaging.TicketStatus NOT IN ('C','I')
END

/*
--------------------------------------------
--Get XReference data for Lunderby Interface
--------------------------------------------
*/
DECLARE	@SourceSystemID	INT
		,@i_SQLError	INT
		
SELECT	@SourceSystemID	= SourceSystem.SrceSystmID FROM	SourceSystem WHERE SourceSystem.Name	= 'PetroEx'

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

/*
CREATE MOVEMENT DATE
*/
UPDATE	MTVPetroExStaging
SET		MTVPetroExStaging.RAMovementDate = DATEADD(HOUR,CONVERT(INT,SUBSTRING(LoadTime,1,2))
											,DATEADD(MINUTE,CONVERT(INT,SUBSTRING(LoadTime,3,2))
											,CONVERT(SMALLDATETIME,SUBSTRING(LoadDate,1,2) + '/' + SUBSTRING(LoadDate,3,2) + '/' + LEFT(DATEPART(YEAR,GETDATE()),2) + SUBSTRING(LoadDate,5,2))))
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.RAMovementDate IS NULL

/*
---------------------------------------------------------------
We will now try to find matching enteries in CORE SRA Tables
and assign IDS.  If no match is found, we will fall back to the 
XREFERNCE setup to try and find the data
---------------------------------------------------------------
*/

--CompanyID
UPDATE	MTVPetroExStaging
SET		RACompanyBAID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVPetroExStaging.CompanyID))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.ElementName	= 'CompanyId'
WHERE	MTVPetroExStaging.RACompanyBAID IS NULL

--TerminalID
UPDATE	MTVPetroExStaging
SET		RALocaleId	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVPetroExStaging.TerminalID))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.ElementName	= 'TerminalID'
WHERE	MTVPetroExStaging.RALocaleId IS NULL

--ProductCode
UPDATE	MTVPetroExStaging
SET		RAPrdctID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVPetroExStaging.ProductCode))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.ElementName	= 'ProductCode'
WHERE	MTVPetroExStaging.RAPrdctID IS NULL

--CarrierID
UPDATE	MTVPetroExStaging
SET		RACarrierBAID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVPetroExStaging.CarrierID))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.EndDate	>= MTVPetroExStaging.RAMovementDate
AND		#XRefWorkerTable.ElementName	= 'CarrierID'
WHERE	MTVPetroExStaging.RACarrierBAID IS NULL

/*
---------------------------------------------------------
Let's Do some Error Checking before we interface the data
---------------------------------------------------------
*/
--RESET MESSAGES IN TABLE
UPDATE	MTVPetroExStaging
SET		MTVPetroExStaging.ErrorMessage = NULL
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.ErrorMessage IS NOT NULL

--RESET STATUS IN TABLE
UPDATE	MTVPetroExStaging
SET		MTVPetroExStaging.TicketStatus = 'N'
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.TicketStatus = 'E'

--NULL RACompanyBAID
UPDATE	MTVPetroExStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= 'Can not find PetroEx CompanyID|| '
FROM	MTVPetroExStaging (NOLOCK)
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.RACompanyBAID IS NULL

--NULL RALocaleId
UPDATE	MTVPetroExStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find PetroEx TerminalId|| '
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.RALocaleId IS NULL

--NULL RAPrdctID
UPDATE	MTVPetroExStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find PetroEx ProductCode|| '
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.RAPrdctID IS NULL

--NULL RACarrierBAID
UPDATE	MTVPetroExStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find PetroEx CarrierBAID|| '
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	MTVPetroExStaging.RACarrierBAID IS NULL

--NULL RACarrierBAID
UPDATE	MTVPetroExStaging
SET		ErrorMessage	= ISNULL(ErrorMessage,'') + 'Please verify Cross-Reference setup to correct errors.'
FROM	MTVPetroExStaging
INNER JOIN #PetroExProcess
ON	MTVPetroExStaging.MPESID = #PetroExProcess.PTID
WHERE	TicketStatus	= 'E'

/*
--Now let's find all movements in error and check for nonerror
--related lines to display a warning message as to why it was not loaded
*/

SELECT	BOLNumber
INTO	#IAMINERROR
FROM	MTVPetroExStaging
WHERE	TicketStatus	= 'E'

UPDATE	MTVPetroExStaging
SET		MTVPetroExStaging.ErrorMessage = 'INFO:  Related Line item is in error, cannot load until all errors are resolved or in an ignore status'
FROM	MTVPetroExStaging
INNER JOIN	#IAMINERROR
ON	MTVPetroExStaging.BOLNumber = #IAMINERROR.BOLNumber
WHERE	TicketStatus	IN ('N','M')
AND		ErrorMessage IS NULL


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_PetroExBOLXRef]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_PetroExBOLXRef.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_PetroExBOLXRef >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_PetroExBOLXRef >>>'
	  END