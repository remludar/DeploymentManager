PRINT 'Start Script=SP_MTV_DLInvStage_Complete.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage_Complete]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_DLInvStage_Complete] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_DLInvStage_Complete >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_DLInvStage_Complete]		@i_AccntngPrdID int = null
AS

-- =============================================
-- Author:        Jeremy von Hoff
-- Create date:	  24MAR2016
-- Description:   This SP compiles inventory data, and stages it to
--		MTVDLInvTransactionsStaging, MTVDLInvBalancesStaging and MTVDLInvPricesStaging
--		ready for the user to run the DataLakeInventoryExtract job
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
-- exec MTV_DLInvStage_Complete 0
/*
select * from MTVDLInvTransactionsStaging
select * from MTVDLInvBalancesStaging
select * from MTVDLInvPricesStaging

*/
DECLARE	@vc_ErrorString				Varchar(1000),
		@vc_AcctMonth				Varchar(20),
		@i_VETradePeriodID			Int,
		@sdt_InsertDate				SmallDateTime


if IsNull(@i_AccntngPrdID, -1) = -1
begin
	set @vc_ErrorString = 'No accounting period was provided.';
	THROW 51000, @vc_ErrorString, 1
end

if @i_AccntngPrdID = 0 -- pick the current open period
	select @i_AccntngPrdID = max(AccountingPeriod.AccntngPrdID) from AccountingPeriod with (NoLock) where AccntngPrdCmplte = 'Y'

Select	@vc_AcctMonth = AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')
From	AccountingPeriod
Where	AccntngPrdID = @i_AccntngPrdID


if exists	(
			Select	1
			From	MTVDLInvInventoryTransactionsStaging Stg
			Where	Stg.AccountingPeriod	= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvTransactionsStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvBalancesStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvPricesStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
begin
	set @vc_ErrorString = 'There are Complete records for this Accounting Period ('+ @vc_AcctMonth + ') already';
	THROW 51000, @vc_ErrorString, 1
end
else -- We don't have any Complete records yet, so we'll set all the record to Complete for this AP
begin
	Update MTVDLInvInventoryTransactionsStaging Set Status = 'C' Where AccountingPeriod = @vc_AcctMonth

	Update MTVDLInvTransactionsStaging Set Status = 'C' Where AccountingMonth = @vc_AcctMonth

	Update MTVDLInvBalancesStaging Set Status = 'C' Where AccountingMonth = @vc_AcctMonth

	Update MTVDLInvPricesStaging Set Status = 'C' Where AccountingMonth = @vc_AcctMonth
end


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage_Complete]') IS NOT NULL
    BEGIN
		EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_DLInvStage_Complete.sql'
		PRINT '<<< ALTERED StoredProcedure MTV_DLInvStage_Complete >>>'
	END
ELSE
	BEGIN
		PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_DLInvStage_Complete >>>'
	END