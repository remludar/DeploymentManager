/****** Object:  StoredProcedure [dbo].[MTV_DLInvStaging_Purge]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_DLInvStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStaging_Purge]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_DLInvStaging_Purge] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_DLInvStaging_Purge >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_DLInvStaging_Purge]
AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  08FEB2017
-- Description:   Purge the MTVSAPXXStaging tables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare	@i_AcctPeriodsToKeep	int
Declare	@vc_AcctMonth			varchar(100)

select @i_AcctPeriodsToKeep = IsNull(dbo.GetRegistryValue('Motiva\DataLake\MonthsOfDataToKeep'), 3)

Select	@vc_AcctMonth = AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')
From	AccountingPeriod
Where	AccntngPrdID = (select	max(AccntngPrdID) - @i_AcctPeriodsToKeep from AccountingPeriod (NoLock) Where AccntngPrdCmplte = 'Y')

Set Rowcount 10000

While Exists (	Select	1
				From	MTVDLInvBalancesStaging
				Where	Status = 'C'
				And		AccountingMonth < @vc_AcctMonth
			)
begin
	Delete	MTVDLInvBalancesStaging
	Where	Status = 'C'
	And		AccountingMonth < @vc_AcctMonth
end


While Exists (	Select	1
				From	MTVDLInvInventoryTransactionsStaging
				Where	Status = 'C'
				And		AccountingPeriod < @vc_AcctMonth
				)
begin
	Delete	MTVDLInvInventoryTransactionsStaging
	Where	Status = 'C'
	And		AccountingPeriod < @vc_AcctMonth
end


While Exists (	Select	1
				From	MTVDLInvTransactionsStaging
				Where	Status = 'C'
				And		AccountingMonth < @vc_AcctMonth
			)
begin
	Delete	MTVDLInvTransactionsStaging
	Where	Status = 'C'
	And		AccountingMonth < @vc_AcctMonth
end


While Exists (	Select	1
				From	MTVDLInvPricesStaging
				Where	Status = 'C'
				And		AccountingMonth < @vc_AcctMonth
			)
begin
	Delete	MTVDLInvPricesStaging
	Where	Status = 'C'
	And		AccountingMonth < @vc_AcctMonth
end

Set Rowcount 0
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStaging_Purge]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_DLInvStaging_Purge.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_DLInvStaging_Purge >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_DLInvStaging_Purge >>>'
	  END

