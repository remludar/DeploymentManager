/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSStagePrices WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FPSStagePrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSStagePrices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSStagePrices]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FPSStagePrices] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTV_FPSStagePrices >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_FPSStagePrices]
		@HeaderId							INT				= NULL
	,	@HeaderImport						INT				= NULL
	,	@HeaderPrefix						VARCHAR(80)		= NULL
	,	@HeaderCountryCode					VARCHAR(80)		= NULL
	,	@HeaderSequenceNumber				INT				= NULL
	,	@HeaderRecordCounter				INT				= NULL
	,	@HeaderStatus						VARCHAR(80)		= NULL
	,	@HeaderRecordError					VARCHAR(80)		= NULL
	,	@HeaderGmtCreatedDate				SMALLDATETIME	= NULL	
	,	@HeaderGmtProcessedDate				SMALLDATETIME	= NULL	
	,	@ConditionsId						INT
	,	@ConditionsHeaderId					INT				= NULL
	,	@ConditionsRecordType				VARCHAR(80)		= NULL
	,	@ConditionsConditionType			VARCHAR(80)
	,	@ConditionsConditionTable			INT				= NULL
	,	@ConditionsConditionTableUsage		VARCHAR(80)		= NULL
	,	@ConditionsApplication				VARCHAR(80)		= NULL
	,	@ConditionsVaKey					VARCHAR(80)		= NULL
	,	@ConditionsSalesOrganization		VARCHAR(80)	
	,	@ConditionsDistributionChannel		INT
	,	@ConditionsSoldToCode				VARCHAR(80)		= NULL
	,	@ConditionsShipToCode				VARCHAR(80)		= NULL
	,	@ConditionsPlantCode				VARCHAR(80)	
	,	@ConditionsProduct					VARCHAR(80)	
	,	@ConditionsDivision					VARCHAR(80)	
	,	@ConditionsShippingCondition		VARCHAR(80)		= NULL
	,	@ConditionsCustomerGroup			VARCHAR(80)		= NULL
	,	@ConditionsStartDate				VARCHAR(80)	
	,	@ConditionsStartTime				VARCHAR(80)	
	,	@ConditionsEndDate					VARCHAR(80)	
	,	@ConditionsEndTime					VARCHAR(80)	
	,	@ConditionsValue					FLOAT	
	,	@ConditionsCurrency					VARCHAR(80)	
	,	@ConditionsQuantity					INT				= NULL
	,	@ConditionsUom						VARCHAR(80)	
	,	@ConditionsDeleteFlag				CHAR(1)			= NULL
	,	@ConditionsUpdateFlag				CHAR(1)			= NULL
	,	@ConditionsSequence					VARCHAR(80)		= NULL
	,	@RAPriceServiceId					INT				= NULL
	,	@RAProductId						INT				= NULL
	,	@RALocaleId							INT				= NULL
	,	@RAToLocaleId						INT				= NULL
	,	@RAPriceCurveId						INT				= NULL
	,	@RACurrencyId						INT				= NULL
	,	@RAUOMId							INT				= NULL
	,	@RAQuoteStart						VARCHAR(80)
	,	@RAQuoteEnd							VARCHAR(80)
	,	@RAValue							FLOAT
	,	@RecordStatus						CHAR(1)
	,	@ErrorMessage						VARCHAR(MAX)	= NULL
	,	@ImportDate							SMALLDATETIME
	,	@ModifiedDate						SMALLDATETIME
	,	@UserId								INT				= NULL
	,	@ProcessedDate						SMALLDATETIME	= NULL
	,	@RawPriceDtlIdnty					INT				= NULL
AS

-- =============================================
-- Author:        Larry Jones
-- Create date:	  09/29/2015
-- Description:   Adds prices from FPS to staging table.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER OFF
SET CONCAT_NULL_YIELDS_NULL ON

INSERT [dbo].[MTVFPSRackPriceStaging]
(
		idi_id
	,	idi_import
	,	prefix
	,	cou_code
	,	sequence_number
	,	record_number
	,	idi_status
	,	idi_rec_error
	,	CreatedDate
	,	idi_gmt_processed_date
	,	i_ogs_id
	,	i_ogs_idi_id
	,	i_ogs_rec_type
	,	i_ogs_condition_type
	,	i_ogs_condition_table
	,	i_ogs_cond_tab_usage
	,	i_ogs_application
	,	i_ogs_vakey
	,	i_ogs_sales_org
	,	i_ogs_dist_channel
	,	i_ogs_sold_to_code
	,	i_ogs_ship_to_code
	,	i_ogs_plant_code
	,	i_ogs_product
	,	i_ogs_division
	,	i_ogs_shipping_cond
	,	i_ogs_cust_group
	,	i_ogs_start_date
	,	i_ogs_start_time
	,	i_ogs_end_date
	,	i_ogs_end_time
	,	i_ogs_value
	,	i_ogs_currency
	,	i_ogs_quantity
	,	i_ogs_uom
	,	i_ogs_delete_flag
	,	i_ogs_update_flag
	,	i_ogs_sequence
	,	RAPriceServiceID
	,	RAProductID
	,	RALocaleID
	,	RAToLocaleID
	,	RAPriceCurveID
	,	RACurrencyID
	,	RAUOMID
	,	RAQuoteStart
	,	RAQuoteEnd
	,	RAValue
	,	RecordStatus
	,	ErrorMessage
	,	ImportDate
	,	ModifiedDate
	,	UserId
	,	ProcessedDate
	,	RawPriceDtlIdnty
)
SELECT	LTrim(RTrim(@HeaderId))
	,	LTrim(RTrim(@HeaderImport))
	,	LTrim(RTrim(@HeaderPrefix))
	,	LTrim(RTrim(@HeaderCountryCode))
	,	LTrim(RTrim(@HeaderSequenceNumber))
	,	LTrim(RTrim(@HeaderRecordCounter))
	,	LTrim(RTrim(@HeaderStatus))
	,	LTrim(RTrim(@HeaderRecordError))
	,	LTrim(RTrim(@HeaderGmtCreatedDate))
	,	LTrim(RTrim(@HeaderGmtProcessedDate))
	,	LTrim(RTrim(@ConditionsId))
	,	LTrim(RTrim(@ConditionsHeaderId))
	,	LTrim(RTrim(@ConditionsRecordType))
	,	LTrim(RTrim(@ConditionsConditionType))
	,	LTrim(RTrim(@ConditionsConditionTable))
	,	LTrim(RTrim(@ConditionsConditionTableUsage))
	,	LTrim(RTrim(@ConditionsApplication))
	,	LTrim(RTrim(@ConditionsVaKey))
	,	LTrim(RTrim(@ConditionsSalesOrganization))
	,	LTrim(RTrim(@ConditionsDistributionChannel))
	,	LTrim(RTrim(@ConditionsSoldToCode))
	,	LTrim(RTrim(@ConditionsShipToCode))
	,	LTrim(RTrim(@ConditionsPlantCode))
	,	LTrim(RTrim(@ConditionsProduct))
	,	LTrim(RTrim(@ConditionsDivision))
	,	LTrim(RTrim(@ConditionsShippingCondition))
	,	LTrim(RTrim(@ConditionsCustomerGroup))
	,	LTrim(RTrim(@ConditionsStartDate))
	,	LTrim(RTrim(@ConditionsStartTime))
	,	LTrim(RTrim(@ConditionsEndDate))
	,	LTrim(RTrim(@ConditionsEndTime))
	,	LTrim(RTrim(@ConditionsValue))
	,	LTrim(RTrim(@ConditionsCurrency))
	,	LTrim(RTrim(@ConditionsQuantity))
	,	LTrim(RTrim(@ConditionsUom))
	,	LTrim(RTrim(@ConditionsDeleteFlag))
	,	LTrim(RTrim(@ConditionsUpdateFlag))
	,	LTrim(RTrim(@ConditionsSequence))
	,	LTrim(RTrim(@RAPriceServiceId))
	,	LTrim(RTrim(@RAProductId))
	,	LTrim(RTrim(@RALocaleId))
	,	LTrim(RTrim(@RAToLocaleId))
	,	LTrim(RTrim(@RAPriceCurveId))
	,	LTrim(RTrim(@RACurrencyId))
	,	LTrim(RTrim(@RAUomId))
	,	LTrim(RTrim(@RAQuoteStart))
	,	LTrim(RTrim(@RAQuoteEnd))
	,	LTrim(RTrim(@RAValue))
	,	LTrim(RTrim(@RecordStatus))
	,	LTrim(RTrim(@ErrorMessage))
	,	LTrim(RTrim(@ImportDate))
	,	LTrim(RTrim(@ModifiedDate))
	,	LTrim(RTrim(@UserId))
	,	LTrim(RTrim(@ProcessedDate))
	,	LTrim(RTrim(@RawPriceDtlIdnty))

	SELECT SCOPE_IDENTITY()
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSStagePrices]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_FPSStagePrices.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FPSStagePrices >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FPSStagePrices >>>'
	  END
 
