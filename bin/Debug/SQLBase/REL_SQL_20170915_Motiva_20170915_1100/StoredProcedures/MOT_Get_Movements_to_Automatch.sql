/****** Object:  StoredProcedure [dbo].[MOT_Get_Movements_to_Automatch]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_Get_Movements_to_Automatch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Get_Movements_to_Automatch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MOT_Get_Movements_to_Automatch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MOT_Get_Movements_to_Automatch >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MOT_Get_Movements_to_Automatch]
AS

------------------------------------------------------------------------------------------------------------------
--  Procedure:  MOT_Get_Movements_to_Automatch
--  Created By: Jeni Fitschen
--  Created:    11/13/2013
--  Purpose:    Returns the lease movements ready to be automatched
------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Find the unmatched movements and group by location and movement date.
----------------------------------------------------------------------------------
SELECT MovementHeader.MvtHdrID
	, MovementHeader.MvtHdrDte
	, MovementHeader.MvtHdrLcleID
	, MovementHeader.MvtHdrMvtDcmntID
	, MONTH(MovementHeader.MvtHdrDte) AS MovementMonth
	, YEAR(MovementHeader.MvtHdrDte) AS MovementYear
INTO #Movement
FROM dbo.MovementHeader (NOLOCK)
WHERE MvtHdrMtchngStts in ('Y','O')
AND mvthdrstat = 'P'
AND LeaseDlHdrId IS NULL

----------------------------------------------------------------------------------
-- Group the unmatched movements, and create a grouping id for each.
----------------------------------------------------------------------------------
SELECT	IDENTITY(INT, 1,1) AS GroupId, 
		MvtHdrLcleID,
		MovementMonth,
		MovementYear
INTO  #MovementGroup
FROM  #Movement
GROUP BY MvtHdrLcleID,MovementMonth,MovementYear

----------------------------------------------------------------------------------
-- Return the movements to be matched with their corresponding grouping id
----------------------------------------------------------------------------------
SELECT	-1 AS MvtHdrId,
	NULL AS MvtHdrDte,
	NULL AS MvtHdrLcleID,
	NULL AS MvtHdrMvtDcmntID,
	NULL AS GroupId,
	'GroupId,MvtHdrDte' AS 'Sort',
	'GroupId' AS 'Group'
UNION
SELECT  #Movement.MvtHdrID
	, #Movement.MvtHdrDte
	, #Movement.MvtHdrLcleID
	, #Movement.MvtHdrMvtDcmntID
	, #MovementGroup.GroupId AS GroupId
	, null
	, null
FROM #MovementGroup
INNER JOIN #Movement
ON #MovementGroup.MovementMonth = #Movement.MovementMonth
AND #MovementGroup.MovementYear = #Movement.MovementYear
AND #MovementGroup.MvtHdrLcleID = #Movement.MvtHdrLcleID

DROP TABLE #Movement
DROP TABLE #MovementGroup

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MOT_Get_Movements_to_Automatch]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MOT_Get_Movements_to_Automatch.sql'
	PRINT '<<< ALTERED StoredProcedure MOT_Get_Movements_to_Automatch >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MOT_Get_Movements_to_Automatch >>>'
END

ALTER AUTHORIZATION ON [dbo].[MOT_Get_Movements_to_Automatch] TO  SCHEMA OWNER 
GO

GRANT EXECUTE ON [dbo].[MOT_Get_Movements_to_Automatch] TO [RightAngleAccess] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[MOT_Get_Movements_to_Automatch] TO [sysuser] AS [dbo]
GO


