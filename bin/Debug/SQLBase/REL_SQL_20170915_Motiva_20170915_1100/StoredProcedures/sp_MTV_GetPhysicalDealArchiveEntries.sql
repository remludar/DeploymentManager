/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetPhysicalDealArchiveEntries WITH YOUR view (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure dbo.MTV_GetPhysicalDealArchiveEntries    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_GetPhysicalDealArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'dbo.MTV_GetPhysicalDealArchiveEntries') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE dbo.MTV_GetPhysicalDealArchiveEntries AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetPhysicalDealArchiveEntries >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_GetPhysicalDealArchiveEntries] 
	@Status varchar(1),
	@DlDtlIntrnlUserID int,
	@ContractNumber varchar(80),
	@DealRevisionDate DATE,
	@StrtgyID int
AS
-- =============================================
-- Author:        Alec Aquino
-- Create date:	  1/27/2016
-- Description:   Update Deal Detail IO GSAP Attributes from Maintenance Report
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 2016-09-19	DAO						Modifed procedure to store archive data in table for later retrieval so history would be retatained.
-----------------------------------------------------------------------------
-- 
SET NOCOUNT ON

DECLARE @sql VARCHAR(MAX)

SELECT @sql = '
CREATE TABLE #Original
(
	ID						int,
	ColDifferences			varchar(5000),
	DlHdrIntrnlUserID		int,
	DlHdrIntrnlNbr			varchar(20),
	DlHdrExtrnlCntctID		int,
	DlHdrIntrnlBAID			int,
	DlHdrExtrnlBAID			int,
	DlHdrTyp				int,
	Term					char(3),
	DlHdrDsplyDte			DateTime,
	DlHdrFrmDte				DateTime,
	DlHdrToDte				DateTime,
	DlHdrStat				char(1),
	DlHdrIntrnlPpr			char(1),
	DlHdrRvsnUserID			int,
	DlHdrCrtnDte			DateTime,
	DlHdrRvsnDte			DateTime,
	DlHdrRvsnLvl			int,
	DlDtlID					int,
	DlDtlSpplyDmnd			char(1),
	DlDtlFrmDte				DateTime,
	DlDtlToDte				DateTime,
	DlDtlQntty				Real,
	DlDtlDsplyUOM			int,
	DlDtlPrdctID			int,
	DlDtlLcleID				int,
	DlDtlMthdTrnsprttn		char(1),
	DlDtlTrmTrmID			int,
	DetailStatus			char(1),
	DlDtlCrtnDte			DateTime,
	DlDtlRvsnDte			DateTime,
	DlDtlRvsnLvl			int,
	DlHdrID					int,
	StrtgyID				int,
	DlDtlPrvsnID			int,
	PricingText1			varchar(5000),
	Actual					char(1),
	CostType				char(1),
	DlDtlPrvsnMntryDrctn	char(1),
	DeletedDetailStatus		char(1),
	DeletedDetailID			int,
	DlDtlIntrnlUserID		int,
	DeliveryTermID			int,
	AdjustedQuantity		real	
)

INSERT INTO #Original
SELECT Orig.ID,
null AS ColDifferences,
Orig.DlHdrIntrnlUserID,
Orig.DlHdrIntrnlNbr,
Orig.DlHdrExtrnlCntctID,
Orig.DlHdrIntrnlBAID,
Orig.DlHdrExtrnlBAID,
Orig.DlHdrTyp,
Orig.Term,
Orig.DlHdrDsplyDte,
Orig.DlHdrFrmDte,
Orig.DlHdrToDte,
Orig.DlHdrStat,
Orig.DlHdrIntrnlPpr,
Orig.DlHdrRvsnUserID,
Orig.DlHdrCrtnDte,
Orig.DlHdrRvsnDte,
Orig.DlHdrRvsnLvl,
Orig.DlDtlID,
Orig.DlDtlSpplyDmnd,
Orig.DlDtlFrmDte,
Orig.DlDtlToDte,
Orig.DlDtlQntty,
Orig.DlDtlDsplyUOM,
Orig.DlDtlPrdctID,
Orig.DlDtlLcleID,
Orig.DlDtlMthdTrnsprttn,
Orig.DlDtlTrmTrmID,
Orig.DetailStatus,
Orig.DlDtlCrtnDte,
Orig.DlDtlRvsnDte,
Orig.DlDtlRvsnLvl,
Orig.DlHdrID,
Orig.StrtgyID,
Orig.DlDtlPrvsnID,
Orig.PricingText1,
Orig.Actual,
Orig.CostType,
Orig.DlDtlPrvsnMntryDrctn,
Orig.DeletedDetailStatus,
Orig.DeletedDetailID,
Orig.DlDtlIntrnlUserID,
Orig.DeliveryTermID,
CASE Orig.DlDtlSpplyDmnd WHEN ''D'' THEN -Orig.DlDtlQntty ELSE Orig.DlDtlQntty END AS AdjustedQuantity 
FROM MTVPhysicalDealArchiveEntries Orig (NOLOCK)
WHERE 1 = 1
'

IF (@Status IS NOT NULL) SELECT @sql = @sql + ' AND Orig.DlHdrStat = ''' + CAST(@Status AS VARCHAR) + ''''
IF (@DlDtlIntrnlUserID IS NOT NULL) SELECT @sql = @sql + ' AND Orig.DlDtlIntrnlUserID = ' + CAST(@DlDtlIntrnlUserID AS VARCHAR)
IF (@ContractNumber IS NOT NULL) SELECT @sql = @sql + ' AND Orig.DlHdrIntrnlNbr LIKE ''%' + CAST(@ContractNumber AS VARCHAR) + '%'''
IF (@DealRevisionDate IS NOT NULL) SELECT @sql = @sql + ' AND CAST(CAST(Orig.DlHdrRvsnDte AS DATE) AS VARCHAR) = ''' + CAST(CAST(@DealRevisionDate AS DATE) AS VARCHAR) + ''''
IF (@StrtgyID IS NOT NULL) SELECT @sql = @sql + ' AND Orig.StrtgyID = ' + CAST(@StrtgyID AS VARCHAR)


SELECT @sql = @sql + '

UPDATE Orig
SET ColDifferences = 
(CASE WHEN Orig.DlHdrIntrnlUserID	<>	Prev.DlHdrIntrnlUserID		Then ''DlHdrIntrnlUserID,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrExtrnlCntctID	<>	Prev.DlHdrExtrnlCntctID		Then ''DlHdrExtrnlCntctID,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrIntrnlBAID		<>	Prev.DlHdrIntrnlBAID		Then ''DlHdrIntrnlBAID,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrExtrnlBAID		<>	Prev.DlHdrExtrnlBAID		Then ''DlHdrExtrnlBAID,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrTyp				<>	Prev.DlHdrTyp				Then ''DlHdrTyp,'' ELSE '''' END	  +
CASE WHEN Orig.Term					<>	Prev.Term					Then ''Term,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrDsplyDte		<>	Prev.DlHdrDsplyDte			Then ''DlHdrDsplyDte,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrFrmDte			<>	Prev.DlHdrFrmDte			Then ''DlHdrFrmDte,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrToDte			<>	Prev.DlHdrToDte				Then ''DlHdrToDte,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrStat			<>	Prev.DlHdrStat				Then ''DlHdrStat,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrIntrnlPpr		<>	Prev.DlHdrIntrnlPpr			Then ''DlHdrIntrnlPpr,'' ELSE '''' END	  +
CASE WHEN Orig.DlHdrRvsnUserID		<>	Prev.DlHdrRvsnUserID		Then ''DlHdrRvsnUserID,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlSpplyDmnd		<>	Prev.DlDtlSpplyDmnd			Then ''DlDtlSpplyDmnd,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlFrmDte			<>	Prev.DlDtlFrmDte			Then ''DlDtlFrmDte,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlToDte			<>	Prev.DlDtlToDte				Then ''DlDtlToDte,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlQntty			<>	Prev.DlDtlQntty				Then ''DlDtlQntty,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlDsplyUOM		<>	Prev.DlDtlDsplyUOM			Then ''DlDtlDsplyUOM,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlPrdctID			<>	Prev.DlDtlPrdctID			Then ''DlDtlPrdctID,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlLcleID			<>	Prev.DlDtlLcleID			Then ''DlDtlLcleID,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlMthdTrnsprttn	<>	Prev.DlDtlMthdTrnsprttn		Then ''DlDtlMthdTrnsprttn,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlTrmTrmID		<>	Prev.DlDtlTrmTrmID			Then ''DlDtlTrmTrmID,'' ELSE '''' END	  +
CASE WHEN Orig.DetailStatus			<>	Prev.DetailStatus			Then ''DetailStatus,'' ELSE '''' END	  +
CASE WHEN Orig.StrtgyID				<>	Prev.StrtgyID				Then ''StrtgyID,'' ELSE '''' END	  +
CASE WHEN Orig.PricingText1			<>	Prev.PricingText1			Then ''PricingText1,'' ELSE '''' END	  +
CASE WHEN Orig.Actual				<>	Prev.Actual					Then ''Actual,'' ELSE '''' END	  +
CASE WHEN Orig.CostType				<>	Prev.CostType				Then ''CostType,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlPrvsnMntryDrctn <>	Prev.DlDtlPrvsnMntryDrctn	Then ''DlDtlPrvsnMntryDrctn,'' ELSE '''' END	  +
CASE WHEN Orig.DeletedDetailStatus	<>	Prev.DeletedDetailStatus	Then ''DeletedDetailStatus,'' ELSE '''' END	  +
CASE WHEN Orig.DeletedDetailID		<>	Prev.DeletedDetailID		Then ''DeletedDetailID,'' ELSE '''' END	  +
CASE WHEN Orig.DlDtlIntrnlUserID	<>	Prev.DlDtlIntrnlUserID		Then ''DlDtlIntrnlUserID,'' ELSE '''' END	  +
CASE WHEN Orig.DeliveryTermID		<>	Prev.DeliveryTermID			Then ''DeliveryTermID,'' ELSE '''' END	  )
FROM #Original Orig
INNER JOIN MTVPhysicalDealArchiveEntries Prev (NOLOCK)
ON Prev.ID = (SELECT MAX(ID) 
FROM MTVPhysicalDealArchiveEntries Temp
WHERE Orig.ID > Temp.ID
AND Orig.DlHdrID = Temp.DlHdrID
AND Orig.DlDtlID = Temp.DlDtlID
AND Orig.DlDtlPrvsnID = Temp.DlDtlPrvsnID)
'

SELECT @sql = @sql + ' 
SELECT
ColDifferences,
DlHdrIntrnlUserID,
DlHdrIntrnlNbr,
DlHdrExtrnlCntctID,
DlHdrIntrnlBAID,
DlHdrExtrnlBAID,
DlHdrTyp,
Term,
DlHdrDsplyDte,
DlHdrFrmDte,
DlHdrToDte,
DlHdrStat,
DlHdrIntrnlPpr,
DlHdrRvsnUserID,
DlHdrCrtnDte,
DlHdrRvsnDte,
DlHdrRvsnLvl,
DlDtlID,
DlDtlSpplyDmnd,
DlDtlFrmDte,
DlDtlToDte,
DlDtlQntty,
DlDtlDsplyUOM,
DlDtlPrdctID,
DlDtlLcleID,
DlDtlMthdTrnsprttn,
DlDtlTrmTrmID,
DetailStatus,
DlDtlCrtnDte,
DlDtlRvsnDte,
DlDtlRvsnLvl,
DlHdrID,
StrtgyID,
DlDtlPrvsnID,
PricingText1,
Actual,
CostType,
DlDtlPrvsnMntryDrctn,
DeletedDetailStatus,
DeletedDetailID,
DlDtlIntrnlUserID,
DeliveryTermID, 
AdjustedQuantity
FROM #Original 
ORDER BY DlHdrIntrnlNbr, DlHdrRvsnLvl DESC, DlDtlID, CostType, Actual, DlDtlPrvsnMntryDrctn '

EXECUTE (@sql)

GO
		
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'dbo.MTV_GetPhysicalDealArchiveEntries') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_GetPhysicalDealArchiveEntries.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetPhysicalDealArchiveEntries >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetPhysicalDealArchiveEntries >>>'
	  END


/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GetPhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_GetPhysicalDealArchiveEntries.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetPhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetPhysicalDealArchiveEntries TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetPhysicalDealArchiveEntries >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetPhysicalDealArchiveEntries >>>'
GO
