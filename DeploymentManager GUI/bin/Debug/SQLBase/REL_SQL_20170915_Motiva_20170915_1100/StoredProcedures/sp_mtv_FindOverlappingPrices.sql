/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_FindOverlappingPrices WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[mtv_FindOverlappingPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_FindOverlappingPrices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_FindOverlappingPrices]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[mtv_FindOverlappingPrices] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure mtv_FindOverlappingPrices >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[mtv_FindOverlappingPrices] 
	@PriceCurveID int,
	@QuoteStartDate DateTime,
	@QuoteEndDate DateTime
WITH EXECUTE AS 'dbo' AS

-- =============================================
-- Author:        MattV
-- Create date:	  20170508
-- Description:   Script to look up overlapping prices for FPS price update logic
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Select Idnty from RawPriceDetail
where RwPrceLcleID = @PriceCurveID
and @QuoteStartDate <= RPDtlQteToDte
and @QuoteEndDate >= RPDtlQteFrmDte

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[mtv_FindOverlappingPrices]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'mtv_FindOverlappingPrices.sql'
			PRINT '<<< ALTERED StoredProcedure mtv_FindOverlappingPrices >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure mtv_FindOverlappingPrices >>>'
	  END


PRINT 'Start Script=mtv_FindOverlappingPrices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_FindOverlappingPrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_FindOverlappingPrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_FindOverlappingPrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_FindOverlappingPrices >>>'

