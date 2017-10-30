/****** Object:  StoredProcedure [dbo].[MTVLineLossAllowanceCheck]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVLineLossAllowanceCheck.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVLineLossAllowanceCheck]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVLineLossAllowanceCheck] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVLineLossAllowanceCheck >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVLineLossAllowanceCheck]
	@IsEstimate char(1),
	@PlnndTrnsfrID int,
	@XctnHdrID int
AS

-- =============================================
-- Author:        Matthew Vorm
-- Create date:	  05/02/2017
-- Description:   Returns the LineLoss attribute from PlnndTransfer if IsEstimate, otherwise from TransactionHeader.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

BEGIN

	IF @IsEstimate = 'Y'
	BEGIN 
	SELECT GC.GnrlCnfgMulti 
	from PlannedTransfer PT 
	join GeneralConfiguration GC 
	on GC.GnrlCnfgHdrID=PT.PhysicalLcleID 
	and GC.GnrlCnfgQlfr='LineLoss' 
	and GC.GnrlCnfgTblNme='Locale' 
	and PT.PlnndTrnsfrID=@PlnndTrnsfrID
	END

	ELSE BEGIN
	select GC.GnrlCnfgMulti from TransactionHeader TH 
	join GeneralConfiguration GC 
	on GC.GnrlCnfgHdrID=TH.MovementLcleID 
	and GC.GnrlCnfgQlfr='LineLoss' 
	and GC.GnrlCnfgTblNme='Locale' 
	and TH.XHdrID=@XctnHdrID
	END

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVLineLossAllowanceCheck]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVLineLossAllowanceCheck.sql'
	PRINT '<<< ALTERED StoredProcedure MTVLineLossAllowanceCheck >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVLineLossAllowanceCheck >>>'
END
 
PRINT 'Start Script=MTVLineLossAllowanceCheck.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVLineLossAllowanceCheck]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVLineLossAllowanceCheck TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVLineLossAllowanceCheck >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVLineLossAllowanceCheck >>>'
GO
