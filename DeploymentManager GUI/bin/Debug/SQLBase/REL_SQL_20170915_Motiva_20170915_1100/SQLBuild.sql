
------------------------------------------------------------------------------------------------------------------
--Begining Of Script
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of TEST_SQL_20170915_Motiva_20170915_1100\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_exchdiff_statement_retrieve_details_with_regrades WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--drop procedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]
ALTER Procedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades] @i_SalesInvoiceHeaderID Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_exchdiff_statement_retrieve_details_with_regrades 140966          Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/3/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	09/24/2002	HMD		29096	Bad join in 2nd retrieval (prior month movement transactions)
--					29102	to inventory reconcile was causing reversals to show up twice
--						and causing price changes to show up twice.  Added reversal flag to join.
--	01/21/2003	JJF			Changed join in section that gets all chemicals that haven't been retrieved yet.
--	04/16/2003	JJF		32852	Changed join in 2nd retrieval -- not picking up financial reversals correctly
--	05/06/2003	JJF		33075	Previous change caused multiple rows to be returned. Altered select so 
--						the TransactionDetailLog.XDtlLgRvrsd flag is not retrieved.
--	05/08/2003	JJF			Rewrote the sp to include the 2 temp tables.  Too many problems in retrieving
--						all necessary data and performance
--	07/18/2003	RPN		34715	Made performance modifications to the stored procedure, enhancing the work done
--                                              around the temp tables created on 5/8/2003, and remove the UNION ALL statements.
--                                              The result set is now stored in temporary table prior to returning to the client.
--	09/12/2003	HMD		31701	Added perunitdecimalplaces and quantitydecimalplaces
-- 	02/17/2004	CM		33060	Added Having clause to exclude zero vol, value, activity records if reg entry = 'Y'
-- 	04/2/2005	CM 		33060	Modified Having clause to exclude anything that would round to an int of 0	
--	11/21/2006	Alex Steen		Fixed index hints for SQLServer2005
--  08/14/2008	DJB		77300	Change index name in the hint
--	09/15/2009	JMK		SF16340	Had to change how we get regrades since we build them dynamically in S9 and up.
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_ExcludeZeroBalanceNoXctn varchar(1)

----------------------------------------------------------------------------------------------------------------------
-- Create a temporary table for holding the Sum Total for each Exchange Diff Groups
----------------------------------------------------------------------------------------------------------------------
Create Table #ExchangeDiffSum
(
	UnitValue	Float,
	XHdrID		Int,
--	Reversed	Char(1),
	XGroupID	Int,
	SourceTable	Char(2)
)

----------------------------------------------------------------------------------------------------------------------
-- Create a temporary table for holding Prior Period Adjustments
----------------------------------------------------------------------------------------------------------------------
--Create Table #PriorPeriodAdjustment
--( 
--	XHdrID		Int,
--	AcctDtlAccntngPrdID int,
--	ChildPrdctID	int,
--	AcctDtlDlDtlDlHdrID int,
--	AcctDtlDlDtlID int,
--	SlsInvceDtlDlvryTrmID int,
--	AmountDue	FLoat
--)

Create Table #Type0Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	ExtrnlBAID				int Null,
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	AccntngPrdID			int Null,
	SlsInvceHdrUOM			varchar(20) Null,
	IESRowType				smallint Null
)

Create Table #Type1Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	ExtrnlBAID				varchar(100) Null,
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null,
	BasePrdctAbbv			varchar(20) Null,
	ThisMonthsBalance		float Null,
	LastMonthsBalance		float Null,
	IESRowType				smallint Null
)

Create Table #Type2Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	SlsInvceSttmntXHdrID		int	Null, 
	SlsInvceSttmntRvrsd		char(1)	Null, 
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	ParentPrdctAbbv			varchar(20)	Null, 
	ChildPrdctID			int	Null, 
	ChildPrdcAbbv			varchar(20)	Null, 
	OriginLcleAbbrvtn		varchar(20)	Null, 
	DestinationLcleAbbrvtn		varchar(20)	Null, 
	FOBLcleAbbrvtn			varchar(20)	Null, 
	Quantity			float	Null, 
	MvtDcmntExtrnlDcmntNbr		varchar(80)	Null, 
	MvtHdrDte			smalldatetime	Null, 
	XHdrTyp				char(1)	Null, 
	InvntryRcncleClsdAccntngPrdID	int	Null, 
	ChildPrdctOrder			smallint	Null, 
	Description			varchar(150)	Null, 
	TransactionDesc			varchar(50)	Null, 
	XchDiffGrpID1			int	Null, 
	XchDiffGrpName1			varchar(50)	Null, 
	XchUnitValue1			float	Null, 
	XchDiffGrpID2			int	Null, 
	XchDiffGrpName2			varchar(50)	Null, 
	XchUnitValue2			float	Null, 
	XchDiffGrpID3			int	Null, 
	XchDiffGrpName3			varchar(50)	Null, 
	XchUnitValue3			float	Null, 
	XchDiffGrpID4			int	Null, 
	XchDiffGrpName4			varchar(50)	Null, 
	XchUnitValue4			float	Null, 
	XchDiffGrpID5			int	Null, 
	XchDiffGrpName5			varchar(50)	Null, 
	XchUnitValue5			float	Null, 
	LastMonthsBalance		float	Null, 
	ThisMonthsbalance		float	Null, 
	Balance				float	Null, 
	DynLstBxDesc			varchar(50)	Null, 
	TotalValue			Float	Null,
	ContractContact			varchar(50)	Null, 
	UOMAbbv				varchar(20)	Null, 
	MovementTypeDesc		varchar(50)	Null,
	PerUnitDecimalPlaces		int		Null,
	QuantityDecimalPlaces		int		Null,
	AccountPeriod				int		NULL,
	ExternalBAID				int		NULL,
	Action						nvarchar(10) NULL,
	InterfaceMessage			varchar(2000) NULL,
	InterfaceFile				varchar(255) NULL,
	InterfaceID					varchar(20) NULL,
	ImportDate					smalldatetime NULL,
	ModifiedDate				smalldatetime NULL,
	UserId						int NULL,
	ProcessedDate				smalldatetime NULL,
	XHdrStat					char(1)	NULL,
	IESRowType					smallint NULL
)

Create Table #Type3Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	SlsInvceSttmntXHdrID		int	Null, 
	SlsInvceSttmntRvrsd		char(1)	Null, 
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	ParentPrdctAbbv			varchar(20)	Null, 
	ChildPrdctID			int	Null, 
	ChildPrdcAbbv			varchar(20)	Null, 
	OriginLcleAbbrvtn		varchar(20)	Null, 
	DestinationLcleAbbrvtn		varchar(20)	Null, 
	FOBLcleAbbrvtn			varchar(20)	Null, 
	Quantity			float	Null, 
	MvtDcmntExtrnlDcmntNbr		varchar(80)	Null, 
	MvtHdrDte			smalldatetime	Null, 
	XHdrTyp				char(1)	Null, 
	InvntryRcncleClsdAccntngPrdID	int	Null, 
	ChildPrdctOrder			smallint	Null, 
	Description			varchar(150)	Null, 
	TransactionDesc			varchar(50)	Null, 
	XchDiffGrpID1			int	Null, 
	XchDiffGrpName1			varchar(50)	Null, 
	XchUnitValue1			float	Null, 
	XchDiffGrpID2			int	Null, 
	XchDiffGrpName2			varchar(50)	Null, 
	XchUnitValue2			float	Null, 
	XchDiffGrpID3			int	Null, 
	XchDiffGrpName3			varchar(50)	Null, 
	XchUnitValue3			float	Null, 
	XchDiffGrpID4			int	Null, 
	XchDiffGrpName4			varchar(50)	Null, 
	XchUnitValue4			float	Null, 
	XchDiffGrpID5			int	Null, 
	XchDiffGrpName5			varchar(50)	Null, 
	XchUnitValue5			float	Null, 
	LastMonthsBalance		float	Null, 
	ThisMonthsbalance		float	Null, 
	Balance				float	Null, 
	DynLstBxDesc			varchar(50)	Null, 
	TotalValue			Float	Null,
	ContractContact			varchar(50)	Null, 
	UOMAbbv				varchar(20)	Null, 
	MovementTypeDesc		varchar(50)	Null,
	PerUnitDecimalPlaces		int		Null,
	QuantityDecimalPlaces		int		Null,
	AccountPeriod				int		NULL,
	ExternalBAID				int		NULL,
	Action						nvarchar(10) NULL,
	InterfaceMessage			varchar(2000) NULL,
	InterfaceFile				varchar(255) NULL,
	InterfaceID					varchar(20) NULL,
	ImportDate					smalldatetime NULL,
	ModifiedDate				smalldatetime NULL,
	UserId						int NULL,
	ProcessedDate				smalldatetime NULL,
	XHdrStat					char(1)	NULL,
	IESRowType					smallint NULL
)

If @i_SalesInvoiceHeaderID is null
Begin
	Return
End

Declare @i_ExchDiffTransactionGroup1ID		Int
Declare @i_ExchDiffTransactionGroup2ID		Int
Declare @i_ExchDiffTransactionGroup3ID		Int
Declare @i_ExchDiffTransactionGroup4ID		Int
Declare @i_ExchDiffTransactionGroup5ID		Int
Declare @i_ExchDiffTransactionGroup1Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup2Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup3Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup4Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup5Name	VarChar(50)

Select	@i_ExchDiffTransactionGroup1ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup1Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group1'
Select	@i_ExchDiffTransactionGroup2ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup2Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group2'
Select	@i_ExchDiffTransactionGroup3ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup3Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group3'
Select	@i_ExchDiffTransactionGroup4ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup4Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group4'
Select	@i_ExchDiffTransactionGroup5ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup5Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group5'

----------------------------------------------------------------------------------------------------------------------
-- BEGIN ADDED HMD 09/12/2003 31701 Determine per unit and quantity decimal places 
----------------------------------------------------------------------------------------------------------------------
Declare @i_QuantityDecimalPlaces int, @i_PerUnitDecimalPlaces int
Declare @vc_uomabbv varchar(20), @vc_key varchar(100), @vc_value varchar(100)

Select 	@vc_UOMAbbv = UOMAbbv,
	@i_PerUnitDecimalPlaces =  IsNull(PerUnitDecimalPlaces,0)
--select *
From	SalesInvoiceHeader (NoLock)
	Inner Join UnitofMeasure (NoLock) on SlsInvceHdrUOM = UOM
Where	SlsInvceHdrID = @i_SalesInvoiceHeaderID

select @vc_key = 'System\SalesInvoicing\UOMQttyDecimalsCombinedExchangeStatement\' + @vc_UOMAbbv

Exec sp_get_registry_value @vc_key, @vc_value out

IF @vc_value is not null
	BEGIN
	Select @i_QuantityDecimalPlaces = Convert(int, @vc_value)
	END
ELSE
	BEGIN
	Select @i_QuantityDecimalPlaces = 0
	END
----------------------------------------------------------------------------------------------------------------------
-- END ADDED HMD 09/12/2003 31701 Determine per unit and quantity decimal places 
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Calculate the Exchange Differential Sums for movement tranactions for both current and prior months
----------------------------------------------------------------------------------------------------------------------
declare @sql  varchar(2000)

select  @SQL = '
Insert #ExchangeDiffSum
Select	sum(SalesInvoiceDetail.SlsInvceDtlPrUntVle)
	,TransactionDetailLog.XDtlLgXDtlXHdrID
	,TransactionTypeGroup.XTpeGrpXGrpID
	,"X"
From	AccountDetail WITH (NoLock, index =IF1287_AccountDetail) 
		Inner Join	TransactionDetailLog (NoLock) 	On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceId
								and	AccountDetail.AcctDtlSrceTble 			= "X"
		Inner Join	SalesInvoiceDetail (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
		Inner Join	TransactionTypeGroup (NoLock) 	On	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
								And	TransactionTypeGroup.XTpeGrpXGrpID		 In ( ' + Convert(varchar(10), @i_ExchDiffTransactionGroup1ID) + ', ' + Convert(Varchar(10), @i_ExchDiffTransactionGroup2ID) + ', ' + convert(Varchar(10),@i_ExchDiffTransactionGroup3ID) + ', ' + Convert(varchar(10), @i_ExchDiffTransactionGroup4ID) + ', ' + Convert(varchar(10),@i_ExchDiffTransactionGroup5ID) + ')
Where 	AccountDetail.AcctDtlSlsInvceHdrID		= ' + convert(varchar(10),@i_SalesInvoiceHeaderID) + '
Group by TransactionDetailLog.XDtlLgXDtlXHdrID, TransactionTypeGroup.XTpeGrpXGrpID, AccountDetail.AcctDtlSrceTble

--select * from #ExchangeDiffSum
'

Execute (@sql)

----------------------------------------------------------------------------------------------------------------------
-- Calculate the Exchange Differential Sums for time tranactions for both current and prior months
----------------------------------------------------------------------------------------------------------------------
Select @sql = '
Insert #ExchangeDiffSum	
Select 	Sum(SalesInvoiceDetail.SlsInvceDtlPrUntVle)
	, TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty
	, TransactionTypeGroup.XTpeGrpXGrpID
	, "TT"
From	AccountDetail (NoLock)	
	Inner Join	TimeTransactionDetailLog (NoLock) 	On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceId
								And	AccountDetail.AcctDtlSrceTble 			= "TT"
	Inner Join	SalesInvoiceDetail	 (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
	Inner Join	TransactionTypeGroup (NoLock) 	 	On	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
								And	TransactionTypeGroup.XTpeGrpXGrpID		In ( ' + Convert(varchar(10), @i_ExchDiffTransactionGroup1ID) + ', ' + Convert(Varchar(10), @i_ExchDiffTransactionGroup2ID) + ', ' + convert(Varchar(10),@i_ExchDiffTransactionGroup3ID) + ', ' + Convert(varchar(10), @i_ExchDiffTransactionGroup4ID) + ', ' + Convert(varchar(10),@i_ExchDiffTransactionGroup5ID) + ')
Where 	AccountDetail.AcctDtlSlsInvceHdrID		= ' + convert(varchar(10),@i_SalesInvoiceHeaderID) + '
Group by TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty, TransactionTypeGroup.XTpeGrpXGrpID, AccountDetail.AcctDtlSrceTble

--select * from #ExchangeDiffSum
'

Execute (@sql)

----------------------------------------------------------------------------------------------------------------------
-- Calculate the statement balance
----------------------------------------------------------------------------------------------------------------------
Declare	@f_StatementBalance	float

Select	@f_StatementBalance =  Isnull((	Select Sum(  Case 
							When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
							Else StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
						   End)
					From	StatementBalance (NoLock)
						Inner Join	Product (NoLock)			On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
						Inner Join	SalesInvoiceHeader (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
						Inner Join 	v_UOMConversion	 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
													And	v_UOMConversion.FromUOM			= 3
					Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID ), 0.00)

--select getdate() 'Determine PPAs'
----------------------------------------------------------------------------------------------------------------------
-- Determine and Calculate the Values for all movement transactios that are prior month adjustements
----------------------------------------------------------------------------------------------------------------------
--Insert	#PriorPeriodAdjustment
--Select 	XDtlLgXDtlXHdrID,
--	AcctDtlAccntngPrdID,
--	ChildPrdctID,
--	AcctDtlDlDtlDlHdrID,
--	AcctDtlDlDtlID,
--	SlsInvceDtlDlvryTrmID
--	, Sum(SlsInvceDtlTrnsctnVle)
--	From 	SalesInvoiceDetail (	NoLock)
--		Inner Join		AccountDetail (NoLock)				On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
--											And	AccountDetail.AcctDtlSrceTble 			IN ('X', 'ML')
--		Inner Join		TransactionDetailLog (NoLock)			On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceID
----		Inner Join		TransactionHeader (NoLock)			On	TransactionDetailLog.XDtlLgXDtlXHdrID		= TransactionHEader.XHdrID
--	Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
--	And	Not Exists 	(
--					Select 	''
--					From	SalesInvoiceStatement (NoLock)
--					Where	SalesInvoiceStatement.SlsInvceSttmntXHdrID		=	TransactionDetailLog.XDtlLgXDtlXHdrID
--					And	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID --@i_SalesInvoiceHeaderID
--				)
--	Group By XDtlLgXDtlXHdrID,
--		AcctDtlAccntngPrdID,
--		ChildPrdctID,
--		AcctDtlDlDtlDlHdrID,
--		AcctDtlDlDtlID,
--		SlsInvceDtlDlvryTrmID

--select * from #PriorPeriodAdjustment


Insert #Type0Results
select distinct 
		StatementBalance.SttmntBlnceSlsInvceHdrID, 
		DealHeader.DlHdrExtrnlBAID,
		DealHeader.DlHdrExtrnlNbr,
		DealHeader.DlHdrIntrnlNbr,
		StatementBalance.SttmntBlnceAccntngPrdID,
		UnitOfMeasure.UOMAbbv,
		0
from StatementBalance (NoLock)
inner join SalesInvoiceHeader (NoLock)
on StatementBalance.SttmntBlnceSlsInvceHdrID = SalesInvoiceHeader.SlsInvceHdrID
inner join DealHeader (NoLock)
on StatementBalance.SttmntBlnceDlHdrID = DealHeader.DlHdrID
inner join UnitOfMeasure (NoLock)
on SalesInvoiceHeader.SlsInvceHdrUOM = UnitOfMeasure.UOM
where StatementBalance.SttmntBlnceSlsInvceHdrID	= @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


Insert #Type1Results
select distinct 
		StatementBalance.SttmntBlnceSlsInvceHdrID,
		DealHeader.DlHdrExtrnlBAID,
		DealHeader.DlHdrExtrnlNbr,
		DealHeader.DlHdrIntrnlNbr,
		Parent.PrdctAbbv,
		ISNULL(StatementBalance.SttmntBlnceEndngBlnce, 0.00),
		ISNULL(LastMonthBalance.SttmntBlnceEndngBlnce, 0.00),
		1
from StatementBalance (NoLock)
inner join DealHeader (NoLock)
on StatementBalance.SttmntBlnceDlHdrID = DealHeader.DlHdrID
inner join Product Parent (NoLock)
on StatementBalance.SttmntBlncePrdctID = Parent.PrdctID
left join StatementBalance LastMonthBalance
on StatementBalance.SttmntBlnceDlHdrID = LastMonthBalance.SttmntBlnceDlHdrID
and StatementBalance.SttmntBlncePrdctID = LastMonthBalance.SttmntBlncePrdctID
and StatementBalance.SttmntBlnceLstAccntngPrdID = LastMonthBalance.SttmntBlnceAccntngPrdID
where StatementBalance.SttmntBlncePrdctID in 
	(select distinct BaseChmclID from DealDetailRegradeRecipe
		where DealHeader.DlHdrID = DealDetailRegradeRecipe.DlDtlDlHdrID)
and StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


--select getdate() 'Get Movement Transactions'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Movement Transactions
----------------------------------------------------------------------------------------------------------------------
Insert	#Type2Results
select 	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID,
	SalesInvoiceStatement.SlsInvceSttmntXHdrID,
	SalesInvoiceStatement.SlsInvceSttmntRvrsd,
	Dealheader.DlHdrExtrnlNbr,
	DealHeader.DlHdrIntrnlNbr,
	Parent.PrdctAbbv 'ParentPrdctAbbv',
	Child.PrdctID 'ChildPrdctID',
	Child.PrdctAbbv 'ChildPrdcAbbv',
	Origin.LcleAbbrvtn 'OriginLcleAbbrvtn',
	Destination.LcleAbbrvtn 'DestinationLcleAbbrvtn',
	FOB.LcleAbbrvtn 'FOBLcleAbbrvtn',
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then ((InventoryReconcile.XHdrQty * Case InventoryReconcile.XHdrTyp + InventoryReconcile.InvntryRcncleRvrsd When 'RN' Then -1 When 'DY' Then -1 Else 1 End) * InventoryReconcile.XHdrSpcfcGrvty * ConversionFactor)
		Else (InventoryReconcile.XHdrQty * Case InventoryReconcile.XHdrTyp + InventoryReconcile.InvntryRcncleRvrsd When 'RN' Then -1 When 'DY' Then -1 Else 1 End) * ConversionFactor
	End 'Quantity',
	rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr),
	MovementHeader.MvtHdrDte,
	TransactionHeader.XHdrTyp,
	InventoryReconcile.InvntryRcncleClsdAccntngPrdID,
	Child.PrdctOrder 'ChildPrdctOrder',
	rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr + ' at ' + FOB.LcleAbbrvtn) 'Description',
	'Movement Transaction' 'Transaction Desc',
	@i_ExchDiffTransactionGroup1ID 		XchDiffGrpID1,
	@i_ExchDiffTransactionGroup1Name 	XchDiffGrpName1,
	isnull(perunit1.UnitValue, 0.00)	XchUnitValue1,
	@i_ExchDiffTransactionGroup2ID		XchDiffGrpID2,	
	@i_ExchDiffTransactionGroup2Name	XchDiffGrpName2,		
	isnull(perunit2.UnitValue, 0.00)	XchUnitValue2,
	@i_ExchDiffTransactionGroup3ID		XchDiffGrpID3,			
	@i_ExchDiffTransactionGroup3Name	XchDiffGrpName3,	
	isnull(perunit3.UnitValue, 0.00)	XchUnitValue3,
	@i_ExchDiffTransactionGroup4ID		XchDiffGrpID4,		
	@i_ExchDiffTransactionGroup4Name	XchDiffGrpName4,	
	isnull(perunit4.UnitValue, 0.00)	XchUnitValue4,
	@i_ExchDiffTransactionGroup5ID		XchDiffGrpID5,		
	@i_ExchDiffTransactionGroup5Name	XchDiffGrpName5,
	isnull(perunit5.UnitValue, 0.00)	XchUnitValue5,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End LastMonthsBalance,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End ThisMonthsbalance,

	@f_StatementBalance,

/*	IsNull((Select	Sum(	Case 
				When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
				Else	StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
				End)
		From	StatementBalance (NoLock)
			Inner Join	Product (NoLock)			On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
			Inner Join	SalesInvoiceHeader (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
			Inner Join 	v_UOMConversion	 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM			= 3
		Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID),0.00) 'Balance',	*/

	Convert(VarChar,DynamicListBox.DynLstBxDesc) + ':' 'DynLstBxDesc',

	(	Select	IsNull(Sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle),0.00)
			From	SalesInvoiceDetail (NoLock)
				Inner Join 	AccountDetail	 (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
				Inner Join	TransactionDetailLog (NoLock)	On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceId
										And	AccountDetail.AcctDtlSrceTble 			= 'X'
										And	TransactionDetailLog.XDtlLgXDtlXHdrID		= SalesInvoiceStatement.SlsInvceSttmntXHdrID
		Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
	) 'TotalValue', 

	Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',
	UnitOfMeasure.UOMAbbv,
	Case When IsNull(MovementHeaderType. Name, '') = '' then 'None' else rtrim(MovementHeaderType. Name) end 'Movement Type Desc',
	0,
	0,
	ThisMonthBalance.SttmntBlnceAccntngPrdID 'AccountingPeriod',
	SalesInvoiceHeader.SlsInvceHdrBARltnBAID 'ExternalBAID',
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	TransactionHeader.XHdrStat,
	2

From	SalesInvoiceStatement (NoLock)
	Inner Join		TransactionHeader (NoLock)			On	TransactionHeader.XHdrID			= SalesInvoiceStatement.SlsInvceSttmntXHdrID
	Inner Join	DealDetail TransactionDealDetail (NoLock)	On TransactionHeader.DealDetailID = TransactionDealDetail.DealDetailID
	Inner Join	DealHeader TransactionDealHeader (NoLock)	On TransactionDealDetail.DlDtlDlHdrID = TransactionDealHeader.DlHdrID
	Inner Join 	InventoryReconcile (NoLock)			On	InventoryReconcile.InvntryRcncleSrceID		= SalesInvoiceStatement.SlsInvceSttmntXHdrID
										And	InventoryReconcile.InvntryRcncleSrceTble	= 'X'
										And	InventoryReconcile.InvntryRcncleRvrsd		= SalesInvoiceStatement.SlsInvceSttmntRvrsd
	Inner Join 		DealHeader (NoLock)				On	DealHeader.DlHdrID				= InventoryReconcile.DlHdrID
	Inner Join		DealDetail	 (NoLock)			On	DealDetail.DlDtlDlHdrID				= InventoryReconcile.DlHdrID
										And	DealDetail.DlDtlID				= InventoryReconcile.DlDtlID
	Inner Join		DealDetailRegradeRecipe ddrg (NoLock)	On DealDetail.DlDtlDlHdrID = ddrg.DlDtlDlHdrID and DealDetail.DlDtlID = ddrg.DlDtlID
	Inner Join		Chemical	(NoLock)			On ddrg.BaseChmclID = Chemical.ChmclParPrdctID
	Inner Join		Contact		 (NoLock)			On	DealHeader.DlHdrExtrnlCntctID			= Contact.CntctID
	Inner Join		Product	Parent (NoLock)				On	Parent.PrdctID					= Chemical.ChmclParPrdctID
	Inner Join		Product	Child	 (NoLock)			On	Child.PrdctID					= InventoryReconcile.ChildPrdctID
	Inner Join		MovementHeader	 (NoLock)			On	MovementHeader.MvtHdrID				= TransactionHeader.XHdrMvtDtlMvtHdrID
	Left Outer Join 	MovementHeaderType				On 	MovementHeader.MvtHdrTyp			= MovementHeaderType.MvtHdrTyp
	Inner Join		MovementDocument (NoLock)			On	MovementDocument.MvtDcmntID			= TransactionHeader.XHdrMvtDcmntID
	Inner Join		Locale 	Origin		 (NoLock)		On	Origin.LcleID					= MovementHeader.MvtHdrLcleID
	Inner Join		Locale	FOB	 (NoLock)			On	FOB.LcleID					= TransactionHeader.MovementLcleID
	Left Outer Join	Locale	Destination		 (NoLock)		On	Destination.lcleID				= MovementHeader.MvtHdrDstntnLcleID		
	Inner Join		StatementBalance ThisMonthBalance  (NoLock)	On	ThisMonthBalance.SttmntBlnceSlsInvceHdrID	= SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID
										And	ThisMonthBalance.SttmntBlncePrdctID		= InventoryReconcile.ChildPrdctID
	Left Outer Join		StatementBalance LastMonthBalance (NoLock)	On	LastMonthBalance.SttmntBlnceDlHdrID     	= InventoryReconcile.DlHdrID 
										And	LastMonthBalance.SttmntBlncePrdctID    		= InventoryReconcile.ChildPrdctID
										And	LastMonthBalance.SttmntBlnceAccntngPrdID	= InventoryReconcile.InvntryRcncleClsdAccntngPrdID - 1
	Left Outer Join 	DynamicListBox  (NoLock)			On 	DynamicListBox.DynLstBxQlfr 			= 'DealDeliveryTerm'
															And 	DynamicListBox.DynLstBxTyp 			= DealDetail.DeliveryTermID
	Inner Join		SalesInvoiceHeader	 (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID		= SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID
	Inner Join 		v_UOMConversion		 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM		= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM				= 3
	Inner Join		UnitOfMeasure		 (NoLock)		On	UnitOfMeasure.UOM				= SalesInvoiceHeader.SlsInvceHdrUOM

	Left Outer Join		#ExchangeDiffSum as perunit1	(Nolock)		On	TransactionHeader.XHdrID			= perunit1.XHdrID
										And	perunit1.XGroupID				= @i_ExchDiffTransactionGroup1ID
										And	perunit1.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit2	(Nolock)		On	TransactionHeader.XHdrID			= perunit2.XHdrID
										And	perunit2.XGroupID				= @i_ExchDiffTransactionGroup2ID
										And	perunit2.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit3 (Nolock)			On	TransactionHeader.XHdrID			= perunit3.XHdrID
										And	perunit3.XGroupID				= @i_ExchDiffTransactionGroup3ID
										And	perunit3.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit4 (Nolock)			On	TransactionHeader.XHdrID			= perunit4.XHdrID
										And	perunit4.XGroupID				= @i_ExchDiffTransactionGroup4ID
										And	perunit4.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit5 (Nolock)			On	TransactionHeader.XHdrID			= perunit5.XHdrID
										And	perunit5.XGroupID				= @i_ExchDiffTransactionGroup5ID
										And	perunit5.SourceTable				= 'X'
where 	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= @i_SalesInvoiceHeaderID
and TransactionDealHeader.DlHdrTyp = 20


--select * from #Results

--select getdate() 'Get Time Transactions'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Time Transactions
----------------------------------------------------------------------------------------------------------------------
Insert #Type2Results
Select	Distinct 
	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID,
	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty,
	TimeTransactionDetailLog.TmeXDtlLgRvrsd,
	Dealheader.DlHdrExtrnlNbr,
	DealHeader.DlHdrIntrnlNbr,
	Parent.PrdctAbbv,
	Child.PrdctID,
	Child.PrdctAbbv,
	Origin.LcleAbbrvtn,
	Origin.LcleAbbrvtn,
	Origin.LcleAbbrvtn,
	0.00,
	'',
	AccountDetail.AcctDtlTrnsctnDte,
	TimeTransactionDetail.TmeXDtlTyp,
	AccountDetail.AcctDtlAccntngPrdID,
	Child.PrdctOrder,
	rtrim(TimeTransactionDetail.TmeXDtlDesc + ' at ' + Origin.LcleAbbrvtn) Description,
	'Time Transactions',
	@i_ExchDiffTransactionGroup1ID 		XchDiffGrpID1,
	@i_ExchDiffTransactionGroup1Name 	XchDiffGrpName1,
	isnull(perunit1.UnitValue, 0.00)	XchUnitValue1,
	@i_ExchDiffTransactionGroup2ID		XchDiffGrpID2,	
	@i_ExchDiffTransactionGroup2Name	XchDiffGrpName2,		
	isnull(perunit2.UnitValue, 0.00)	XchUnitValue2,
	@i_ExchDiffTransactionGroup3ID		XchDiffGrpID3,			
	@i_ExchDiffTransactionGroup3Name	XchDiffGrpName3,	
	isnull(perunit3.UnitValue, 0.00)	XchUnitValue3,
	@i_ExchDiffTransactionGroup4ID		XchDiffGrpID4,		
	@i_ExchDiffTransactionGroup4Name	XchDiffGrpName4,	
	isnull(perunit4.UnitValue, 0.00)	XchUnitValue4,
	@i_ExchDiffTransactionGroup5ID		XchDiffGrpID5,		
	@i_ExchDiffTransactionGroup5Name	XchDiffGrpName5,
	isnull(perunit5.UnitValue, 0.00)	XchUnitValue5,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End LastMonthsBalance,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End ThisMonthsbalance,

	@f_StatementBalance,
	/*IsNull((Select	Sum(	Case 
				When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
				Else	StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
				End)
		From	StatementBalance (NoLock)
			Inner Join	Product	 (NoLock)		On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
			Inner Join	SalesInvoiceHeader (NoLock)	On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
			Inner Join 	v_UOMConversion (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
								And	v_UOMConversion.FromUOM			= 3
		Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID),0.00),*/

	Convert(VarChar,DynamicListBox.DynLstBxDesc) + ':',

	(	Select	IsNull(Sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle),0.00)
		From	SalesInvoiceDetail (NoLock)
			Inner Join 	AccountDetail (NoLock)		 On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
			Inner Join	TimeTransactionDetailLog (NoLock) On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceId
									 And	AccountDetail.AcctDtlSrceTble 			= 'TT'
									 And	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty	= TimeTransactionDetail.TmeXDtlIdnty	
		Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
	), 

	Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',
	UnitOfMeasure.UOMAbbv,
	Null,
	0,
	0,
	ThisMonthBalance.SttmntBlnceAccntngPrdID 'AccountingPeriod',
	SalesInvoiceHeader.SlsInvceHdrBARltnBAID 'ExternalBAID',
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	TimeTransactionDetail.TmeXDtlStat as 'XHdrStat',
	2

From 	SalesInvoiceDetail (NoLock)
	Inner Join		AccountDetail (NoLock)				On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
	Inner Join		TimeTransactionDetailLog (NoLock)		On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceID
										And	AccountDetail.AcctDtlSrceTble 			= 'TT'
	Inner Join		TimeTransactionDetail (NoLock)			On	TimeTransactionDetail.TmeXDtlIdnty		= TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty	
	Inner Join 		DealHeader (NoLock)				On	DealHeader.DlHdrID				= AccountDetail.AcctDtlDlDtlDlHdrID
	Inner Join		DealDetailRegradeRecipe ddrg (NoLock)	On AccountDetail.AcctDtlDlDtlDlHdrID = ddrg.DlDtlDlHdrID and AccountDetail.AcctDtlDlDtlID = ddrg.DlDtlID
	Inner Join		Chemical	(NoLock)			On ddrg.BaseChmclID = Chemical.ChmclParPrdctID
	Inner Join		Contact (NoLock)				On	DealHeader.DlHdrExtrnlCntctID			= Contact.Cntctid
	Inner Join		Product	Parent (NoLock)				On	Parent.PrdctID					= Chemical.ChmclParPrdctID
	Inner Join		Product	Child (NoLock)				On	Child.PrdctID					= AccountDetail.ChildPrdctID
	Inner Join		Locale 	Origin (NoLock)				On	Origin.LcleID					= AccountDetail.AcctDtlLcleID
	Inner Join		StatementBalance ThisMonthBalance (NoLock)	On	ThisMonthBalance.SttmntBlnceSlsInvceHdrID	= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
										And	ThisMonthBalance.SttmntBlncePrdctID		= AccountDetail.ChildPrdctID
	Left Outer Join		StatementBalance LastMonthBalance (NoLock)	On	LastMonthBalance.SttmntBlnceDlHdrID     	= AccountDetail.AcctDtlDlDtlDlHdrID 
										And	LastMonthBalance.SttmntBlncePrdctID    		= AccountDetail.ChildPrdctID
										And	LastMonthBalance.SttmntBlnceAccntngPrdID	= AccountDetail.AcctDtlAccntngPrdID - 1
	Left Outer Join 	DynamicListBox (NoLock) 			on 	DynamicListBox.DynLstBxQlfr 			= 'DealDeliveryTerm'
															And 	DynamicListBox.DynLstBxTyp 			= SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	Inner Join		SalesInvoiceHeader (NoLock)			On	SalesInvoiceHeader.SlsInvceHdrID		= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
	Inner Join 		v_UOMConversion	 (NoLock)			On 	SalesInvoiceHeader.SlsInvceHdrUOM		= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM				= 3
	Inner Join		UnitOfMeasure	 (NoLock)			On	UnitOfMeasure.UOM				= SalesInvoiceHeader.SlsInvceHdrUOM		

	Left Outer Join		#ExchangeDiffSum as perunit1	(Nolock)		On	TimeTransactionDetail.TmeXDtlIdnty		= perunit1.XHdrID
										And	perunit1.XGroupID				= @i_ExchDiffTransactionGroup1ID
										And	perunit1.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit2	(Nolock)		On	TimeTransactionDetail.TmeXDtlIdnty		= perunit2.XHdrID
										And	perunit2.XGroupID				= @i_ExchDiffTransactionGroup2ID
										And	perunit2.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit3 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit3.XHdrID
										And	perunit3.XGroupID				= @i_ExchDiffTransactionGroup3ID
										And	perunit3.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit4 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit4.XHdrID
										And	perunit4.XGroupID				= @i_ExchDiffTransactionGroup4ID
										And	perunit4.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit5 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit5.XHdrID
										And	perunit5.XGroupID				= @i_ExchDiffTransactionGroup5ID
										And	perunit5.SourceTable				= 'TT'

Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


--select * from #Results

--select getdate() 'Get PPAs'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Prior Period Adjustements
----------------------------------------------------------------------------------------------------------------------
Insert	INTO #Type3Results 
(
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdcAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	--MvtDcmntExtrnlDcmntNbr,
	MvtHdrDte,
	XHdrTyp,
	Description,
	DynLstBxDesc,
	TotalValue,
	Action,
	InterfaceMessage,
	InterfaceFile,
	InterfaceID,
	ImportDate,
	ModifiedDate,
	UserId,
	ProcessedDate,
	IESRowType
)
SELECT Distinct
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdctAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	--MvtDcmntExtrnlDcmntNbr,
	MvtHdrDte,
	XHdrTyp,
	SUBSTRING(RTRIM(ISNULL(OriginLcleAbbrvtn, '') + ' ' 
		+ ISNULL(ChildPrdctAbbv, '') + ' ' 
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Handling Exp' THEN 'HNE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Handling Rev' THEN 'HNR' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Regrade Diff Exp' THEN 'GRE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Regrade Diff Rev' THEN 'GRR' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Location Diff Exp' THEN 'LOE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Location Diff Rev' THEN 'LOR' ELSE '' END
		+ ' ' + ISNULL(XHdrTyp, '') + ' ' 
		+ REPLACE(RTRIM(LTRIM(REPLACE(CAST(ISNULL(SlsInvceDtlPrUntVle, 0) AS varchar), '0', ' '))), ' ', '0') + ' ' 
		+ CAST(SUM(ISNULL(SlsInvceDtlTrnsctnQntty, 0)) AS varchar))
	, 0, 50) Description,
	'Prior Month Movement Transaction',
	SUM(SlsInvceDtlTrnsctnVle),
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	3 'IESRowType'
FROM 
(
	Select	--Distinct 
		@i_SalesInvoiceHeaderID 'SlsInvceSttmntSlsInvceHdrID',
		AccountDetailDealHeader.DlHdrIntrnlNbr,
		AccountDetailDealHeader.DlHdrExtrnlBAID 'ExternalBAID',
		ParentGC.GnrlCnfgMulti 'ParentPrdctAbbv',
		Child.PrdctID 'ChildPrdctID',
		ChildGC.GnrlCnfgMulti 'ChildPrdctAbbv',
		OriginGC.GnrlCnfgMulti 'OriginLcleAbbrvtn',
		FOB.LcleAbbrvtn 'FOBLcleAbbrvtn',
		TransactionType.TrnsctnTypDesc 'TransactionDesc',
		--rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr) 'MvtDcmntExtrnlDcmntNbr',
		CAST(CAST(DATEPART(YYYY, MovementHeader.MvtHdrDte) as varchar) + '-' + CAST(DATEPART(MM, MovementHeader.MvtHdrDte) as varchar) + '-01' AS date) 'MvtHdrDte',	--They wanted it grouped by Month
		TransactionHeader.XHdrTyp,
		SalesInvoiceDetail.SlsInvceDtlTrnsctnVle,
		CAST(SalesInvoiceDetail.SlsInvceDtlPrUntVle AS decimal(18, 5)) 'SlsInvceDtlPrUntVle',
		SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty
	From SalesInvoiceDetail (NoLock)
		Inner Join		AccountDetail AD (NoLock)					On	AD.AcctDtlID = SalesInvoiceDetail.SlsInvceDtlAcctDtlID And	AD.AcctDtlSrceTble IN ('X', 'ML')
		Inner Join		TransactionDetailLog (NoLock)				On	TransactionDetailLog.XDtlLgID = AD.AcctDtlSrceID
		Inner Join		DealHeader AccountDetailDealHeader (NoLock)	On	AccountDetailDealHeader.DlHdrID = AD.AcctDtlDlDtlDlHdrID
		Inner Join		DealDetail AccountDetailDealDetail (NoLock) On	AccountDetailDealDetail.DlDtlDlHdrID =  AD.AcctDtlDlDtlDlHdrID and AccountDetailDealDetail.DlDtlID = AD.AcctDtlDlDtlID
		Inner Join		TransactionHeader (NoLock)					On	TransactionHeader.XHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
		Inner Join		DealDetailRegradeRecipe ddrg (NoLock)		On	AD.AcctDtlDlDtlDlHdrID = ddrg.DlDtlDlHdrID and AD.AcctDtlDlDtlID = ddrg.DlDtlID
		Inner Join		Chemical (NoLock)							On	ddrg.BaseChmclID = Chemical.ChmclParPrdctID
		Inner Join		Product	Parent (NoLock)						On	Parent.PrdctID = Chemical.ChmclParPrdctID
		Left Outer Join GeneralConfiguration ParentGC (NoLock)		On	Parent.PrdctID = ParentGC.GnrlCnfgHdrID and ParentGC.GnrlCnfgQlfr = 'SAPMaterialCode' and ParentGC.GnrlCnfgTblNme = 'Product'
		Inner Join		Product	Child (NoLock)						On	Child.PrdctID = AccountDetailDealDetail.DlDtlPrdctID
		Left Outer Join GeneralConfiguration ChildGC (NoLock)		On	Child.PrdctID = ChildGC.GnrlCnfgHdrID and ChildGC.GnrlCnfgQlfr = 'SAPMaterialCode' and ChildGC.GnrlCnfgTblNme = 'Product'
		Inner Join		MovementHeader (NoLock)						On	MovementHeader.MvtHdrID	= TransactionHeader.XHdrMvtDtlMvtHdrID
		Inner Join		MovementDocument (NoLock)					On	MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
		Inner Join		Locale 	FOB (NoLock)						On	FOB.LcleID = MovementHeader.MvtHdrLcleID
		Inner Join		Locale 	Origin (NoLock)						On	Origin.LcleID = MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration OriginGC (NoLock)		On	Origin.LcleID = OriginGC.GnrlCnfgHdrID and OriginGC.GnrlCnfgQlfr = 'SAPPlantCode' and OriginGC.GnrlCnfgTblNme = 'Locale'
		Inner Join		TransactionType (NoLock)					On	AD.AcctDtlTrnsctnTypID = TransactionType.TrnsctnTypID
	Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
		And	Not Exists 	(
						Select 	''
						From	SalesInvoiceStatement (NoLock)
						Where	SalesInvoiceStatement.SlsInvceSttmntXHdrID		=	TransactionDetailLog.XDtlLgXDtlXHdrID
						And	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID --@i_SalesInvoiceHeaderID
					)
		And AccountDetailDealHeader.DlHdrTyp = 20
) T3s
Group By
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	--MvtDcmntExtrnlDcmntNbr,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdctAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	MvtHdrDte,
	XHdrTyp,
	SlsInvceDtlPrUntVle
Having sum(SlsInvceDtlTrnsctnVle) <> 0


Update 	#Type2Results 
Set 	PerUnitDecimalPlaces = @i_PerUnitDecimalPlaces,
	QuantityDecimalPlaces = @i_QuantityDecimalPlaces

-- CM - Begin Added - 33060 - 2/12/2004 
select @vc_key = 'System\SalesInvoicing\Statements\ExcludeZeroBalanceNoXctn'  
Exec sp_get_registry_value @vc_key, @vc_ExcludeZeroBalanceNoXctn out
-- CM - Begin Added - 33060 - 2/12/2004

Update 	#Type3Results 
Set 	PerUnitDecimalPlaces = @i_PerUnitDecimalPlaces,
	QuantityDecimalPlaces = @i_QuantityDecimalPlaces

-- CM - Begin Added - 33060 - 2/12/2004 
select @vc_key = 'System\SalesInvoicing\Statements\ExcludeZeroBalanceNoXctn'  
Exec sp_get_registry_value @vc_key, @vc_ExcludeZeroBalanceNoXctn out
-- CM - Begin Added - 33060 - 2/12/2004

UPDATE r SET r.ChildPrdcAbbv = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = r.ChildPrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.ParentPrdctAbbv = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.Product p
ON p.PrdctAbbv = r.ParentPrdctAbbv
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = p.PrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.BasePrdctAbbv = gc.GnrlCnfgMulti
FROM  #Type1Results r
INNER JOIN dbo.Product p
ON p.PrdctAbbv = r.BasePrdctAbbv
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = p.PrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.OriginLcleAbbrvtn = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.Locale l
ON l.LcleAbbrvtn = r.OriginLcleAbbrvtn
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = l.LcleID
AND gc.GnrlCnfgTblNme = 'Locale'
AND gc.GnrlCnfgQlfr = 'SAPPlantCode'

--Select *
--from 	#Results
---- CM - Begin Added - 33060 - 2/12/2004 
--Where	(round(Quantity,0)		<> 0
--Or	 round(LastMonthsBalance,0)	<> 0
--Or	 round(ThisMonthsBalance,0)	<> 0 
--Or	 round(TotalValue,0)		<> 0
--Or 	isnull(@vc_ExcludeZeroBalanceNoXctn,'N') <> 'Y')	
-- CM - End Added - 33060 - 2/12/2004

-- This is the Staging table that the report reads Exchange Statements

--delete from MTVIESExchangeStaging where SlsInvceSttmntSlsInvceHdrID in (select distinct(SlsInvceSttmntSlsInvceHdrID) from #Results)

DELETE d
FROM dbo.MTVIESExchangeStaging d
where d.SlsInvceSttmntSlsInvceHdrID = @i_SalesInvoiceHeaderID

INSERT INTO MTVIESExchangeStaging 
(SlsInvceSttmntSlsInvceHdrID,
ExternalBAID,
DlHdrIntrnlNbr,
DlHdrExtrnlNbr,
AccountPeriod,
UOMAbbv,
IESRowType,
Action)
SELECT SlsInvceSttmntSlsInvceHdrID, 
ExtrnlBAID,
DlHdrIntrnlNbr,
DlHdrExtrnlNbr,
AccntngPrdID,
SlsInvceHdrUOM,
IESRowType,
'N'
FROM #Type0Results


INSERT INTO MTVIESExchangeStaging 
(SlsInvceSttmntSlsInvceHdrID,
ExternalBAID,
DlHdrExtrnlNbr,
DlHdrIntrnlNbr,
ParentPrdctAbbv,
LastMonthsBalance,
ThisMonthsbalance,
IESRowType,
Action)
SELECT SlsInvceSttmntSlsInvceHdrID, 
ExtrnlBAID,
DlHdrExtrnlNbr,
DlHdrIntrnlNbr,
BasePrdctAbbv,
LastMonthsBalance,
ThisMonthsBalance,
IESRowType,
'N'
FROM #Type1Results


INSERT INTO MTVIESExchangeStaging 
SELECT * FROM #Type2Results 
UNION SELECT * FROM #Type3Results
ORDER BY SlsInvceSttmntSlsInvceHdrID, DlHdrIntrnlNbr, ParentPrdctAbbv, XHdrStat, FOBLcleAbbrvtn, ChildPrdcAbbv, MvtDcmntExtrnlDcmntNbr, IESRowType
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of TEST_SQL_20170915_Motiva_20170915_1100\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------
--Ending Of Script
------------------------------------------------------------------------------------------------------------------

