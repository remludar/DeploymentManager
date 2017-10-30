PRINT 'Start Script=SP_MTV_CalcMvtQtySum.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CalcMvtQtySum]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_CalcMvtQtySum] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_CalcMvtQtySum >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_CalcMvtQtySum]
	@i_DlHdrID int,
	@i_DlDtlID int,
	@sdt_appdate smalldatetime,
	@c_RecDelBoth char(1) = null,
	@i_MonthsBack int,
	@c_GroupLocale char(1) = 'Y'
AS

-- =============================================
-- Author:        Jeremy von Hoff
-- Create date:	  25SEP2015
-- Description:   This SP pulls data from the CustomInvoiceInterface table,
--	pushes it into MTVStarMailStaging, ready for the user to run the StarMailExtract job
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
-- select * from generalconfiguration, dynamiclistbox where GnrlCnfgQlfr like 'mvts%' and DynLstBxQlfr = GnrlCnfgQlfr and GnrlCnfgMulti = dynlstbxtyp
-- select mvtdcmntextrnldcmntnbr, * from movementheader, movementdocument where MvtDcmntID = mvthdrmvtdcmntid and mvthdrid in (2054,2055,2056,2058,2057,2059)
-- exec MTV_CalcMvtQtySum 1396, 3, '3/1/2016', 'D', 3
declare	@vc_DynamicSQL varchar(8000)

select @vc_DynamicSQL = '
Select	IsNull(sum(MovementHeader.MvtHdrQty), 0) as TotalQty
From	MovementHeader (NoLock)
		Inner Join TransactionHeader (NoLock)
			on	MovementHeader.MvtHdrID			= TransactionHeader.XHdrMvtDtlMvtHdrID
			and	TransactionHeader.XHdrStat		= ''C''
		Inner Join DealDetail (NoLock)
			on	DealDetail.DealDetailID			= TransactionHeader.DealDetailID
			and	DealDetail.DlDtlDlHdrID			= '+Convert(varchar, @i_DlHdrID)+'
			and	DealDetail.DlDtlSpplyDmnd		= '+case when @c_RecDelBoth is null then 'DealDetail.DlDtlSpplyDmnd' else ''''+@c_RecDelBoth+'''' end + '
		Inner Join GeneralConfiguration GCProd (NoLock)
			on	GCProd.GnrlCnfgTblNme			= ''DealHeader''
			and	GCProd.GnrlCnfgQlfr				= ''MvtSumProductGroups''
			and	GCProd.GnrlCnfgHdrID			= '+Convert(varchar, @i_DlHdrID)+'
		Inner Join DynamicListBox DLBProd (NoLock)
			on	DLBProd.DynLstBxTyp				= GCProd.GnrlCnfgMulti
			and	DLBProd.DynLstBxQlfr			= ''MvtSumPrdctSubGroups'' --GCProd.GnrlCnfgQlfr
		Inner Join GeneralConfiguration GCMove (NoLock)
			on	GCMove.GnrlCnfgTblNme			= ''DealHeader''
			and	GCMove.GnrlCnfgQlfr				= ''MvtSumExcludeMoveTyp''
			and	GCMove.GnrlCnfgHdrID			= '+Convert(varchar, @i_DlHdrID)+'
		Inner Join DynamicListBox DLBMove (NoLock)
			on	DLBMove.DynLstBxTyp				= GCMove.GnrlCnfgMulti
			and	DLBMove.DynLstBxQlfr			= ''MvtSumExcludeMvtTyp'' --GCMove.GnrlCnfgQlfr
		Inner Join DynamicListBox DLBMoveTyp (NoLock)
			on	DLBMoveTyp.DynLstBxQlfr			= ''MovementType''
			and	DLBMoveTyp.DynLstBxTyp			= MovementHeader.MvtHdrTyp
Where	MovementHeader.MvtHdrStat				= ''A''
and		MovementHeader.MvtHdrDte				>= DateAdd(dd, day(dateadd(d, datediff(d, 0, DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')), 0)) * -1 + 1, dateadd(d, datediff(d, 0, DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')), 0))
and		MovementHeader.MvtHdrDte				<= DateAdd(minute, -1, DateAdd(mm, 1, DateAdd(dd, day(dateadd(d, datediff(d, 0, '''+Convert(varchar, @sdt_AppDate)+'''), 0)) * -1 + 1, dateadd(d, datediff(d, 0, '''+Convert(varchar, @sdt_AppDate)+'''), 0))))

-- And		DatePart(Year, MovementHeader.MvtHdrDte)	>= DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')

And		'',''+DLBMove.DynLstBxAbbv+'','' not like ''%,''+ rtrim(ltrim(DLBMoveTyp.DynLstBxAbbv)) +'',%''

' + case when @c_GroupLocale = 'Y' then '
And		Exists	(
				Select	1
				From	DealDetail LocationSub (NoLock)
				Where	LocationSub.DlDtlDlHdrID			= '+Convert(varchar, @i_DlHdrID)+'
				And		LocationSub.DlDtlID					= '+Convert(varchar, @i_DlDtlID)+'
				And		LocationSub.DlDtlLcleID				= MovementHeader.MvtHdrLcleID
				)'
else '' end + '

And		(GCProd.GnrlCnfgMulti = ''0'' -- All Product Subgroups
	or	Exists	(
				Select	1
				From	MovementDetail (NoLock)
						Inner Join Product (NoLock)
							on	Product.PrdctID						= MovementDetail.MvtDtlChmclChdPrdctID
						Inner Join GeneralConfiguration GCSub (NoLock)
							on	GCSub.GnrlCnfgTblNme				= ''Product''
							and	GCSub.GnrlCnfgQlfr					= ''PriceCommodityGroup''
							and	GCSub.GnrlCnfgHdrID					= Product.PrdctID
				Where	MovementHeader.MvtHdrID						= MovementDetail.MvtDtlMvtHdrID
				And		'',''+DLBProd.DynLstBxAbbv+'','' like ''%,''+ rtrim(ltrim(GCSub.GnrlCnfgMulti)) +'',%''
				And		Exists	(
								Select	1
								From	DealDetail Sub (NoLock)
										Inner Join GeneralConfiguration GCSub2 (NoLock)
											on	GCSub2.GnrlCnfgTblNme				= ''Product''
											and	GCSub2.GnrlCnfgQlfr					= ''PriceCommodityGroup''
											and	GCSub2.GnrlCnfgHdrID				= Sub.DlDtlPrdctID
								Where	Sub.DlDtlDlHdrID			= '+Convert(varchar, @i_DlHdrID)+'
								And		Sub.DlDtlID					= '+Convert(varchar, @i_DlDtlID)+'
								And		GCSub2.GnrlCnfgMulti		= GCSub.GnrlCnfgMulti
--								And		'',''+DLBProd.DynLstBxAbbv+'','' like ''%,''+ rtrim(ltrim(GCSub2.GnrlCnfgMulti)) +'',%''
								)
				)
		)
'


exec(@vc_DynamicSQL)
-- print(@vc_DynamicSQL)


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_CalcMvtQtySum]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_CalcMvtQtySum.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_CalcMvtQtySum >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_CalcMvtQtySum >>>'
	  END