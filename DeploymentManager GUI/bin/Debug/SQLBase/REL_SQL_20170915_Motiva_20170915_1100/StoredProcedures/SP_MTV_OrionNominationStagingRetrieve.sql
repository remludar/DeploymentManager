/****** Object:  StoredProcedure [dbo].[MTVOrionNominationStagingRetrieve]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVOrionNominationStagingRetrieve.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStagingRetrieve]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVOrionNominationStagingRetrieve] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVOrionNominationStagingRetrieve >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVOrionNominationStagingRetrieve]
	@CCTSite VARCHAR(8000),
	@Pump_Date_From DateTime,
	@Pump_Date_To DateTime,
	@ExternalMessageID VARCHAR(128)
AS

-- =============================================
-- Author:        Matthew Vorm
-- Create date:	  12/23/2015
-- Description:   Returns the table of Orion Nominations that fit the criteria parameters.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

BEGIN

	SELECT @CCTSite = REPLACE(@CCTSite, '''', '')
	SELECT @CCTSite = REPLACE(@CCTSite, ' ', '')

	DECLARE @CCTSiteCodes varchar(8000)
	set @CCTSiteCodes = @CCTSite

	declare @List table (Code varchar(50))
	while CHARINDEX(',', @CCTSiteCodes) > 0
		begin
			insert into @List (Code) values(LEFT(@CCTSiteCodes, CHARINDEX(',', @CCTSiteCodes) - 1))
			set @CCTSiteCodes = RIGHT(@CCTSiteCodes, len(@CCTSiteCodes) - CHARINDEX(',', @CCTSiteCodes))
		end
	insert into @List (Code) values(@CCTSiteCodes)

	SELECT 
		'RA' as DataSource,
		ISNULL(@CCTSite, '') AS Refinery,
		ISNULL(@ExternalMessageID, '') AS MessageID,
		GETDATE() AS DateTimeStamp
	
	SELECT 
		CONVERT(nvarchar(20), Stage.PrdctID) as PRODUCT_ID, 
		PUMP_DATE as PUMP_DATE, 
		CONVERT(float, ROUND((VOLUME / 42), 0)) as VOLUME, 
		CONVERT(nvarchar(20), LEFT(itc.ExtValue, 20)) as BATCH_NUMBER,
		CONVERT(nvarchar(20), PlnndTrnsfrID) as TENDER_ID,
		CONVERT(nvarchar(50), Product.PrdctNme) as PRODUCT,
		CONVERT(nvarchar(100), LEFT(VESSEL, 100)) as VESSEL,
		CONVERT(nvarchar(1), RDIndicator) as RECEIPT_LIFT,	--The XRef for this happens via Code
		CONVERT(nvarchar(14), LEFT(dlb.DynLstBxAbbv, 14)) as TRANSPORT_MODE,
		ISNULL(CONVERT(nvarchar(20), itc2.ExtValue), '') as CCTSITE,
		CONVERT(nvarchar(22), 'BBL') as UOM
	FROM dbo.MTVOrionNominationStaging as Stage
	LEFT JOIN v_MTVInterfaceTranslationCache itc on Stage.PlnndMvtID = itc.RAValue AND itc.Qualifier = 'ExternalBatch' AND itc.TableSource = 'PlannedMovement'
	LEFT JOIN v_MTVInterfaceTranslationCache itc2 on STage.LocaleID = itc2.RAValue AND itc2.Qualifier = 'CCTSite' AND itc2.TableSource = 'Locale'
	INNER JOIN Product on Stage.PrdctID = Product.PrdctID
	INNER JOIN DynamicListBox dlb on Stage.MethodTransportation = dlb.DynLstBxTyp AND dlb.DynLstBxQlfr = 'TransportationMethod'
		WHERE (@CCTSite IS NULL OR itc2.ExtValue in (Select * from @List))
			AND PUMP_DATE BETWEEN ISNULL(@Pump_Date_From,'1/1/1900') AND ISNULL(@Pump_Date_To,'12/31/3000')

	SELECT 
		@@ROWCOUNT as NominationCount

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStagingRetrieve]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVOrionNominationStagingRetrieve.sql'
	PRINT '<<< ALTERED StoredProcedure MTVOrionNominationStagingRetrieve >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVOrionNominationStagingRetrieve >>>'
END
 
