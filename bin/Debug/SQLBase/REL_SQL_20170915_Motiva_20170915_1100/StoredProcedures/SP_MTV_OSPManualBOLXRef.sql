/*
*****************************************************************************************************
USE FIND AND REPLACE ON OSPManualBOLXRef WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_sp_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_OSPManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OSPManualBOLXRef]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_OSPManualBOLXRef] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_OSPManualBOLXRef >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_OSPManualBOLXRef] @RowId INT = NULL
AS

-- =============================================
-- Author:        Ryan Borgman
-- Create date:	  10/16/2014
-- Description:   Xreference and error scrub PetroEx information
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_OSPManualBOLXRef 18
-----------------------------------------------------------------------------

/*
--------------------------------------------
--Get XReference data for Lunderby Interface
--------------------------------------------
*/
DECLARE	@SourceSystemID	INT
		,@i_SQLError	INT
		
SELECT	@SourceSystemID	= SourceSystem.SrceSystmID FROM	SourceSystem WHERE SourceSystem.Name	= 'OSP'

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
---------------------------------------------------------------
We will now try to find matching enteries in CORE SRA Tables
and assign IDS.  If no match is found, we will fall back to the 
XREFERNCE setup to try and find the data
---------------------------------------------------------------
*/

--PartnerFrom
UPDATE	MTVOSPManulBOLStaging
SET		RAPartnerFromBAID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerFrom))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'PartnerFrom'
WHERE	MTVOSPManulBOLStaging.RAPartnerFromBAID IS NULL
AND		TicketStatus NOT IN ('I','C')

--PartnerTo
UPDATE	MTVOSPManulBOLStaging
SET		RAPartnerToBAID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerTo))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'PartnerTo'
WHERE	MTVOSPManulBOLStaging.RAPartnerToBAID IS NULL
AND		TicketStatus NOT IN ('I','C')

--DocumentNumber
UPDATE	MTVOSPManulBOLStaging
SET		RADocumentID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.DocumentNumber))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'DocumentNumber'
WHERE	MTVOSPManulBOLStaging.RADocumentID IS NULL
AND		TicketStatus NOT IN ('I','C')

--ProductCode
UPDATE	MTVOSPManulBOLStaging
SET		RAPrdctID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.ProductCode))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'ProductCode'
WHERE	MTVOSPManulBOLStaging.RAPrdctID IS NULL
AND		TicketStatus NOT IN ('I','C')

--LoadDepot
UPDATE	MTVOSPManulBOLStaging
SET		RALocaleId	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.LoadDepot))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'LoadDepot'
WHERE	MTVOSPManulBOLStaging.RALocaleId IS NULL
AND		TicketStatus NOT IN ('I','C')

--StLoc
UPDATE	MTVOSPManulBOLStaging
SET		RAStorageLcleID	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.StLoc))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'StLoc'
WHERE	MTVOSPManulBOLStaging.RAStorageLcleID IS NULL
AND		TicketStatus NOT IN ('I','C')

--ModeofTransport
UPDATE	MTVOSPManulBOLStaging
SET		RAMvtHdrType	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.ModeofTransport))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'ModeofTransport'
WHERE	MTVOSPManulBOLStaging.RAMvtHdrType IS NULL
AND		TicketStatus NOT IN ('I','C')

--ModeofTransport
UPDATE	MTVOSPManulBOLStaging
SET		RAMvtHdrType	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.ModeofTransport))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'ModeofTransport'
WHERE	MTVOSPManulBOLStaging.RAMvtHdrType IS NULL
AND		TicketStatus NOT IN ('I','C')

--All Unit of Measures
UPDATE	MTVOSPManulBOLStaging
SET		RAUOM	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.UnitofMeasure))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAUOM IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAUOM2	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.UnitofMeasure2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAUOM2 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAUOM3	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.UnitofMeasure3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAUOM3 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAProdDensityUoM	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.ProdDensityUoM))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAProdDensityUoM IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAProdTempUoM	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.ProdTempUoM))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAProdTempUoM IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp1UoM_1	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp1UoM_1))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp1UoM_1 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp1UoM_2	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp1UoM_2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp1UoM_2 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp1UoM_3	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp1UoM_3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp1UoM_3 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp2UoM_1	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp2UoM_1))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp2UoM_1 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp2UoM_2	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp2UoM_2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp2UoM_2 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp2UoM_3	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp2UoM_3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp2UoM_3 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp3UoM_1	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp3UoM_1))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp3UoM_1 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp3UoM_2	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp3UoM_2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp3UoM_2 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp3UoM_3	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp3UoM_3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp3UoM_3 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp4UoM_1	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp4UoM_1))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp4UoM_1 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp4UoM_2	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp4UoM_2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp4UoM_2 IS NULL
AND		TicketStatus NOT IN ('I','C')

UPDATE	MTVOSPManulBOLStaging
SET		RAComp4UoM_3	= #XRefWorkerTable.SRAValue
--SELECT	*
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.Comp4UoM_3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate	<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate	>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= 'UnitofMeasure'
WHERE	MTVOSPManulBOLStaging.RAComp4UoM_3 IS NULL
AND		TicketStatus NOT IN ('I','C')

 --SET ALL PartnerIDs
UPDATE	MTVOSPManulBOLStaging
SET		RAPartner1BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID1))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType1 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType1 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType1 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType1 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner2BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID2))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType2 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType2 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType2 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType2 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner3BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID3))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType3 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType3 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType3 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType3 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner4BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID4))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType4 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType4 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType4 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType4 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner5BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID5))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType5 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType5 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType5 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType5 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner6BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID6))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType6 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType6 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType6 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType6 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner7BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID7))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType7 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType7 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType7 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType7 = 'Vendor' THEN 'Vendor'
												ELSE ''	END
 

UPDATE	MTVOSPManulBOLStaging
SET		RAPartner8BAID	= #XRefWorkerTable.SRAValue 
--SELECT													
FROM	MTVOSPManulBOLStaging
INNER JOIN	#XRefWorkerTable
ON		LTRIM(RTRIM(MTVOSPManulBOLStaging.PartnerID8))	= #XRefWorkerTable.LDRValue
AND		#XRefWorkerTable.StartDate		<= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.EndDate		>= MTVOSPManulBOLStaging.LoadEndDate
AND		#XRefWorkerTable.ElementName	= CASE	WHEN PartnerType8 = 'ShipTo' THEN 'ShipTo'
												WHEN PartnerType8 = 'SoldTo' THEN 'SoldTo'
												WHEN PartnerType8 = 'Carrier' THEN 'Carrier'
												WHEN PartnerType8 = 'Vendor' THEN 'Vendor'
												ELSE ''	END

--Find Carrrier, I know we have already cross referenced above, but making it simplier for loading movement document step here
UPDATE	MTVOSPManulBOLStaging
SET		RACarrierBAID	= CASE	WHEN PartnerType1 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner1BAID
								WHEN PartnerType2 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner2BAID
								WHEN PartnerType3 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner3BAID
								WHEN PartnerType4 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner4BAID
								WHEN PartnerType5 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner5BAID
								WHEN PartnerType6 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner6BAID
								WHEN PartnerType7 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner7BAID
								WHEN PartnerType8 = 'Carrier' THEN MTVOSPManulBOLStaging.RAPartner8BAID	
								ELSE NULL END	
WHERE	MTVOSPManulBOLStaging.RACarrierBAID IS NULL
AND		TicketStatus NOT IN ('I','C')

/*
---------------------------------------------------------
Let's Do some Error Checking before we interface the data
---------------------------------------------------------
*/
--RESET MESSAGES IN TABLE
UPDATE	MTVOSPManulBOLStaging
SET		MTVOSPManulBOLStaging.ErrorMessage = NULL
WHERE	MTVOSPManulBOLStaging.ErrorMessage IS NOT NULL
AND		MTVOSPManulBOLStaging.TicketStatus <> 'C'
AND		MTVOSPManulBOLStaging.MOMBSID	= CASE WHEN @RowId IS NULL THEN MTVOSPManulBOLStaging.MOMBSID ELSE @RowId END

--RESET STATUS IN TABLE
UPDATE	MTVOSPManulBOLStaging
SET		MTVOSPManulBOLStaging.TicketStatus = 'N'
WHERE	MTVOSPManulBOLStaging.TicketStatus = 'E'
AND		MTVOSPManulBOLStaging.MOMBSID	= CASE WHEN @RowId IS NULL THEN MTVOSPManulBOLStaging.MOMBSID ELSE @RowId END

--NULL LoadDepot
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find LoadDepot|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RALocaleId IS NULL

--NULL ModeofTransport
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ModeofTransport|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAMvtHdrType IS NULL

--NULL RACarrierBAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not determine Carrier|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RACarrierBAID IS NULL

--NULL RAPrdctID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ProductCode|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPrdctID IS NULL

--NULL RAUOM
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find UnitofMeasure|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAUOM IS NULL

--RAPartner1BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType1 + ': ' + PartnerID1 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner1BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType1 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType1) > 1)

--RAPartner2BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType2 + ': ' + PartnerID2 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner2BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType2 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType2) > 1)

--RAPartner3BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType3 + ': ' + PartnerID3 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner3BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType3 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType3) > 1)

--RAPartner4BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType4 + ': ' + PartnerID4 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner4BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType4 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType4) > 1)

--RAPartner5BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType5 + ': ' + PartnerID5 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner5BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType5 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType5) > 1)

--RAPartner6BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType6 + ': ' + PartnerID6 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner6BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType6 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType6) > 1)

--RAPartner7BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType7 + ': ' + PartnerID7 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner7BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType7 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType7) > 1)

--RAPartner8BAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ' + PartnerType8 + ': ' + PartnerID8 + '|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartner8BAID IS NULL
AND		(MTVOSPManulBOLStaging.PartnerType8 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.PartnerType8) > 1)

--RAUOM2
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find UnitofMeasure2|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAUOM2 IS NULL
AND		(MTVOSPManulBOLStaging.UnitofMeasure2 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.UnitofMeasure2) > 1)

--RAUOM3
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find UnitofMeasure3|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAUOM3 IS NULL
AND		(MTVOSPManulBOLStaging.UnitofMeasure3 IS NOT NULL AND LEN(MTVOSPManulBOLStaging.UnitofMeasure3) > 1)

--RAProdDensityUoM
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ProdDensityUoM|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAProdDensityUoM IS NULL
AND		(MTVOSPManulBOLStaging.ProdDensityUoM IS NOT NULL AND LEN(MTVOSPManulBOLStaging.ProdDensityUoM) > 1)

--RAProdTempUoM
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ProdTempUoM|| '
		--SELECT *
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAProdTempUoM IS NULL
AND		(MTVOSPManulBOLStaging.ProdTempUoM IS NOT NULL AND LEN(MTVOSPManulBOLStaging.ProdTempUoM) > 1)

/*
TODO: COMMENTED OUT FOR NOW, UNSURE IF THESE WILL BE REQUIRED OR NOT, SO COMMENT IN AS NECESSARY
--NULL RAPartnerFromBAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find PartnerFrom|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartnerFromBAID IS NULL

--NULL RAPartnerToBAID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find PartnerTo|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RAPartnerToBAID IS NULL

--NULL RADocumentID
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find DocumentID|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RADocumentID IS NULL

--NULL RADestLocaleId
UPDATE	MTVOSPManulBOLStaging
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Unable to determine Destination|| '
FROM	MTVOSPManulBOLStaging
WHERE	MTVOSPManulBOLStaging.RADestLocaleId IS NULL
*/

--WRAP UP Error Message
UPDATE	MTVOSPManulBOLStaging
SET		ErrorMessage	= ISNULL(ErrorMessage,'') + 'Please verify Cross-Reference setup to correct errors.'
FROM	MTVOSPManulBOLStaging
WHERE	TicketStatus	= 'E'


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_OSPManualBOLXRef]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_OSPManualBOLXRef.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_OSPManualBOLXRef >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_OSPManualBOLXRef >>>'
	  END