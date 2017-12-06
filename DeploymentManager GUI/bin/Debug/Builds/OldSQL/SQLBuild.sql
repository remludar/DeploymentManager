
------------------------------------------------------------------------------------------------------------------
--Begining Of Script
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\Tables\alter_T_MTVRetailerInvoicePreStage.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVRetailerInvoicePreStage' and sc.name = 'InvoiceComments')
begin
	print 'Adding InvoiceComments Column'
	ALTER table MTVRetailerInvoicePreStage Add InvoiceComments varchar(255) null
end
else
	print 'InvoiceComments Column Exists'

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'InvoiceComments')
begin
	print 'Adding InvoiceComments Column'
	ALTER table MTVSalesforceDataLakeInvoicesStaging Add InvoiceComments varchar(255) null
end
else
	print 'InvoiceComments Column Exists'
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\Tables\alter_T_MTVRetailerInvoicePreStage.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\Tables\t_MTVMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVMovementLifeCycle]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVMovementLifeCycle.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].MTVMovementLifeCycle to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVMovementLifeCycle >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVMovementLifeCycle >>>'


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\Tables\t_MTVMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\Tables\T_MTVTempMarkToMarket.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

create table db_datareader.MTVTempMarkToMarket
(
	deal					varchar(20)			null,
	deal_detail_id			varchar(10)	     	null,
	status					varchar(8)			null,
	end_of_day				smalldatetime		null,
	close_of_business		smalldatetime		null,
	trade_date				smalldatetime		null,
	revision_date			smalldatetime		null,
	creation_date			smalldatetime		null,
	delivery_period			smalldatetime		null,
	delivery_period_group	smalldatetime		null,
	hedge_month				varchar(255)		null,
	accounting_period		smalldatetime		null,
	deal_detail_hedge_month	varchar(255)		null,
	scheduling_period		smalldatetime		null,
	product					varchar(20)			null,
	location				varchar(20)			null,
	our_company				varchar(45)			null,
	their_company			varchar(45)			null,
	trader					varchar(41)			null,
	strategy				varchar(120)		null,
	portfolio_position_group	varchar(300)	null,
	priced_percentage		varchar(21)	     	null,
	position				float				null,
	total_value				float				null,
	uom						varchar(20)			null,
	market_value			float				null,
	profit_loss				float				null,
	priced_profit_loss		float				null,
	float_profit_loss		float				null,
	priced_value			float				null,
	float_value				float				null,
	priced_position			float				null,
	float_position			float				null,
	per_unit_value			float				null,
	market_per_unit_value	float				null,
	detail_template			varchar(80)	     	null,
	attached_inhouse		varchar(3)	     	null,
	chemical				varchar(20)	     	null,
	missing_market_value	varchar(3)	     	null,
	missing_deal_value		varchar(3)	     	null,
	market_fx_rate			decimal(10,2)		null,
	total_value_fx_rate		decimal(10,2)		null,
	priced_value_fx_rate	decimal(10,2)		null,
	market_currency			char(3)		     	null,
	payment_currency		char(3)		     	null,
	base_currency			char(3)		     	null,
	source					varchar(35)	     	null,
	inventory				varchar(3)		  	null,
	deal_detail_template	char(80)	    	null,
	receipt_delivery		char(1)		     	null,
	parcel_no				decimal(10,2)		null,
	accounting_treatment	varchar(255)     	null,
	transaction_type		varchar(80)	     	null,
	method_of_transportation	varchar(40)	    null,
	interface_code			char(100)	     	null,
	transfer_id				varchar(10)	     	null,
	snapshot_id				varchar(10)	     	not null,
	risk_id					varchar(10)	     	null,
	offset					float				null,
	calc_is_primary_cost	varchar(3)	     	null,
	calc_program_month		varchar(80)	     	null,
	calc_delivery_month		varchar(23)	     	null,
	calc_is_inventory		varchar(5)	     	null,
	calc_involves_inventory_book	varchar(1) 	null,
	calc_inventory_buy_sale_build_draw	varchar(13)	null,
	RiskCategory			varchar(1)	     	null,
	calc_future_swap		varchar(6)	     	null
)

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\Tables\T_MTVTempMarkToMarket.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\Tables\T_MTVTempRiskExposure.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

create table db_datareader.MTVTempRiskExposure
(
	deal								varchar(20) null,
	deal_detail_id						varchar(20) null,
	status								varchar(8) null,
	trade_date							smalldatetime null,
	end_of_day							smalldatetime null,
	period_start						smalldatetime null,
	period_end							smalldatetime null,
	revision_date						smalldatetime null,
	creation_date						smalldatetime null,
	period_group_start					smalldatetime null,
	period_group_end					smalldatetime null,
	hedge_month							smalldatetime null,
	deal_detail_hedge_month				smalldatetime null,
	scheduling_period					smalldatetime null,
	inventory_accounting_start_date		smalldatetime null,
	delivery_period_start				smalldatetime null,
	product								varchar(20) null,
	risk_type							varchar(11) null,
	trader								varchar(41) null,
	strategy							varchar(120) null,
	portfolio_position_group			varchar(8000) null,
	our_company							varchar(45) null,
	their_company						varchar(45) null,
	location							varchar(20) null,
	curve_service						varchar(20) null,
	curve_product						varchar(20) null,
	curve_location						varchar(20) null,
	position							float null,
	exposure_quote_date					smalldatetime null,
	priced_percentage					varchar(21) null,
	uom									varchar(20) null,
	child_product						varchar(20) null,
	curve_child_product					varchar(20) null,
	detail_template						varchar(50) null,
	attached_inhouse					varchar(3) null,
	inventory							varchar(3) null,
	is_basis_curve						varchar(3) null,
	source								varchar(35) null,
	receipt_delivery					varchar(8) null,
	calc_program_month					smalldatetime null,
	risk_id								varchar(20) null,
	calc_flat_price_basis				varchar(10) null,
	primary_cost						varchar(3) null,
	transfer_id							varchar(20) null,
	deal_detail_template				varchar(50) null,
	calc_is_inventory					varchar(5) null,
	calc_build_draw						varchar(10) null,
	snapshot_id							varchar(20) not null,
	calc_involves_inventory_book		varchar(1) null,
	calc_risk_category					varchar(51) null,
	calc_order_crosses_strategy			varchar(1) null,
	calc_inventory_buy_sale_build_draw	varchar(13) null,
	calc_order_has_non_inventory		varchar(1) null,
	calc_risk_type						varchar(11) null,
	calc_exposure						float null,
	calc_position						float null
)


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\Tables\T_MTVTempRiskExposure.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\Views\v_MTVAccountDetailSoldToShipToView.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

/****** Object:  View [dbo].[v_MTV_AccountDetailShipToSoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_v_MTV_AccountDetailShipToSoldTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailShipToSoldTo]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_AccountDetailShipToSoldTo] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_AccountDetailShipToSoldTo >>>'
	  END
GO

set ansi_nulls on
go

set quoted_identifier off
go

alter view [dbo].[v_MTV_AccountDetailShipToSoldTo]
as
-- =============================================
-- Author:        CraigAlbright	
-- Create date:	  9/20/2017
-- Description:   Gives you the AcctDtl, ShipTo and the SoldTo
-- =============================================
select (CAD.AcctDtlID)
		,CASE when( CAD.AcctDtlPrntID <> CAD.AcctDtlID) then (select top 1 c2.SAPSoldToCode from CustomAccountDetailAttribute c2 where c2.CADID = 
		(select ID from CustomAccountDetail c3 where c3.AcctDtlID = CAD.AcctDtlPrntID))
		   else CADA.SAPSoldToCode end as SoldTo
		,CASE when( CAD.AcctDtlPrntID <> CAD.AcctDtlID) then (select top 1 c2.SAPShipToCode from CustomAccountDetailAttribute c2 where c2.CADID = 
		(select ID from CustomAccountDetail c3 where c3.AcctDtlID = CAD.AcctDtlPrntID))
		   else CADA.SAPShipToCode end as ShipTo
from CustomAccountDetail CAD (nolock)
inner join CustomAccountDetailAttribute CADA (nolock) on 
CADA.CADID = CAD.ID 
where CADA.SAPShipToCode is not null and CADA.SAPSoldToCode is not null

Go

IF not Exists(select '' from sys.indexes where name = 'idx_CADIDSAPShipToCode')
      BEGIN
			CREATE NONCLUSTERED INDEX idx_CADIDSAPShipToCode
			ON [dbo].[CustomAccountDetailAttribute] ([CADID])
			INCLUDE ([SAPShipToCode])
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\Views\v_MTVAccountDetailSoldToShipToView.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\Custom_Message_Queue_BulkProcessor.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
If OBJECT_ID('dbo.Custom_Message_Queue_BulkProcessor') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Message_Queue_BulkProcessor
    PRINT '<<< DROPPED PROC dbo.Custom_Message_Queue_BulkProcessor >>>'
End
Go  

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Message_Queue_BulkProcessor]
AS
set NOCOUNT on
-- =============================================
-- Author:        J. von Hoff
-- Create date:	  12DEC2016
-- Description:   Process items from the CustomMessageQueue table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

---------------------------------------------
-- Check the process out
---------------------------------------------
Declare @i_checkoutStatus int
Exec @i_checkoutStatus = dbo.sra_checkout_process 'CustomMessageQueueProcessor'

if @i_checkoutStatus = 0
	return

---------------------------------------------
-- Grab the oldest records to process
---------------------------------------------
Select	TOP 10000 ID, Entity, EntityID, Reprocess, convert(varchar(1000), null) Message
into	#CMQtoProcess
From	dbo.CustomMessageQueue (NoLock)
Where	RAProcessed = 0 or Reprocess = 1
Order by ID

Update	#CMQtoProcess
Set		Message = 'The Invoice Interface cannot process Message ID: ' + convert(varchar,#CMQtoProcess.ID) + '. '
From	#CMQtoProcess
Where	Entity in ('SH', 'PH')
and		(
		Not Exists (Select 1 From dbo.CustomMessageQueue (NoLock) Where Id = IsNull(#CMQtoProcess.ID,0) And Entity = #CMQtoProcess.Entity)
or		Exists (Select 1 From dbo.CustomMessageQueue (NoLock) Where Id = IsNull(#CMQtoProcess.ID,0) And RAProcessed = 1 And Reprocess = 0)
		)


Update	CustomMessageQueue
Set		RAProcessed			= 1
		,RAProcessedDate	= GetDate()
		,HasErrored			= 1
		,Error				= Message
		,Reprocess			= 0
From	#CMQtoProcess
		Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #CMQtoProcess.ID
Where	Message like 'The Invoice Interface cannot process Message ID%'

Delete	#CMQtoProcess
Where	Message like 'The Invoice Interface cannot process Message ID%'

---------------------------------------------
-- Sorting hat!
---------------------------------------------
Select	*
Into	#AR_Bulk
From	#CMQtoProcess
Where	Entity = 'SH'

Select	*
Into	#AP_Bulk
From	#CMQtoProcess
Where	Entity = 'PH'

Select	*
Into	#GL_Bulk
From	#CMQtoProcess
Where	Entity = 'GL'

-- 		execute Custom_Interface_GL_Outbound @i_ID, @i_Reprocess
drop table #CMQtoProcess

---------------------------------------------
-- First, work on the AR stuff
---------------------------------------------
if exists (select 1 from #AR_Bulk)
begin

	-- First set any errors where we can't process an invoice
	Update	#AR_Bulk
	Set		Message = case when SlsInvceHdrFdDte is not null
						then 'The invoice cannot be reprocessed because it has already been Fed.'
						when SlsInvceHdrPd = 'Y'
						then 'The invoice cannot be reprocessed because it has already been Paid.'
						end
	From	#AR_Bulk
			Inner Join dbo.SalesInvoiceHeader (NoLock)
				on	#AR_Bulk.EntityID		= SalesInvoiceHeader.SlsInvceHdrID
	Where	#AR_Bulk.Reprocess = 1


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AR_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
	Where	Message is not null

	Delete	#AR_Bulk
	Where	Message is not null

	-- Get rid of any old data when we're going to reprocess
	Delete	dbo.CustomAccountDetail
	From	#AR_Bulk
			Inner Join dbo.CustomAccountDetail
				on	InterfaceMessageID = #AR_Bulk.ID
	Where	#AR_Bulk.Reprocess = 1
		
	Delete	dbo.CustomInvoiceInterface
	From	#AR_Bulk
			Inner Join dbo.CustomInvoiceInterface
				on	MessageQueueID = #AR_Bulk.ID
	Where	#AR_Bulk.Reprocess = 1

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface has excluded SlsInvceHdrID: ' + convert(varchar,EntityID) + ' because its invoice type is not marked Feed to A/R. '
	From	#AR_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.SalesInvoiceHeader (NoLock)
								Inner Join dbo.SalesInvoiceType (NoLock)
									on	SalesInvoiceType.SlsInvceTpeID	= SalesInvoiceHeader.SlsInvceHdrSlsInvceTpeID
						Where	#AR_Bulk.EntityID		= SalesInvoiceHeader.SlsInvceHdrID
						And		SalesInvoiceType.SlsInvceTpeARFd <> 'N'
						)

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface has already processed SlsInvceHdrID: ' + convert(varchar,EntityID) + '. (Does CAD Exist?) '
	From	#AR_Bulk
	Where	Exists	(
					Select	1
					From	dbo.CustomAccountDetail (NoLock)
					Where	RAInvoiceID = #AR_Bulk.EntityID
					And		InterfaceSource = 'SH'
					)

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface cannot process SlsInvceHdrID: ' + convert(varchar,EntityID) + '. (Is it in SENT Status? Has it already FED?) '
	From	#AR_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.SalesInvoiceHeader (NoLock)
						Where	SlsInvceHdrStts = 'S'
						And		SlsInvceHdrFdDte Is Null
						And		SlsInvceHdrID = #AR_Bulk.EntityID
						)


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AR_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
	Where	Message is not null

	Delete	#AR_Bulk
	Where	Message is not null

	-- Now, we call the Custom_Interface_AD_Mapping proc
	if exists (select 1 from #AR_Bulk)
	begin
		Exec dbo.Custom_Interface_AD_Mapping	@i_ID				= -1
												,@i_MessageID		= -1
												,@vc_Source			= 'SH'
												,@c_ReturnToInvoice	= 'N'
												,@c_OnlyShowSQL		= 'N'


	-- Finally, do the aggregation for the CustomInvoiceInterface table
			Create Table	#AR_Interface
					(
						ID								int				Identity 
						,InvoiceLevel					char(1)			Not Null
						,MessageQueueID					int				Not Null
						,InterfaceSource				char(2)			Null
						,InvoiceGLDate					varchar(25)		Null
						,InvoiceDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null				
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0	
						,InterfaceInvoiceID				int				Null
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACode						varchar(25)		Null
						,PaymentMethod					varchar(25)		Null				
						,AcctDtlID						int				Null
						,TransactionDate				varchar(25)		Null
						,DueDate						varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,InvoiceCurrency				varchar(3)		Null
						,InvoiceDebitValue				decimal(19,2)	Null	Default 0	
						,InvoiceCreditValue				decimal(19,2)	Null	Default 0	
						,IntBAID						int				Null							
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,RunningNumber					int				Null					
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,TransactionDescription			varchar(50)		Null										
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null			
						,ParentInvoiceDate				varchar(25)		Null
						,ParentInvoiceNumber			varchar(20)		Null	
						,ReceiptRefundFlag				varchar(5)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0	
						,AbsInvoiceValue				decimal(19,2)	Null	Default 0	
						,LineType						varchar(3)		Null				
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,SalesOffice					varchar(25)		Null				
						,MaterialGroup					varchar(5)		Null				
						,DealType						varchar(60)		Null				
						,DealNumber						varchar(20)		Null		
						,DealDetailID					smallint		Null
						,TransferID						int				Null					
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,Plant							varchar(5)		Null				
						,StorageLocation				varchar(5)		Null				
						,DocumentType					varchar(50)		Null				
						,CustomerClassification			varchar(2)		Null				
						,SaleGroup						varchar(4)		Null
						,HighestValue					char(1)			Null
						,IsTax							tinyint			Null				
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,Reversed						char(1)			Null
						,Currency						char(3)			Null
					)


					
					Insert	#AR_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,Chart
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,AcctDtlID
							,TransactionDate
							,DueDate
							,Quantity
							,PerUnitPrice
							,TaxCode
							,ProductCode
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber		
							,TitleTransfer
							,Destination
							,TransactionType
							,TransactionDescription										
							,Vehicle
							,CarrierMode			
							,ParentInvoiceDate
							,ParentInvoiceNumber	
							,ReceiptRefundFlag
							,BL
							,PaymentTermCode
							,UnitPrice
							,UOM
							,AbsLocalValue
							,AbsInvoiceValue
							,LineType			
							,ProfitCenter
							,CostCenter
							,SalesOffice				
							,MaterialGroup				
							,DealType			
							,DealNumber		
							,DealDetailID
							,TransferID					
							,OrderID
							,OrderBatchID
							,Plant				
							,StorageLocation				
							,DocumentType			
							,CustomerClassification				
							,SaleGroup
							,HighestValue
							,IsTax
							,InterfaceStatus
							,InterfaceMessage
							,Reversed
							,Currency)	
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
							,InterfaceSource																-- InterfaceSource
							,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)						-- InvoiceGLDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDate)									-- InvoiceDate
							,AcctDtlAcctCdeCde																-- Chart
							,LocalCurrency																	-- LocalCurrency			
							,Round(LocalDebitValue, 2)														-- LocalDebitValue	
							,Round(LocalCreditValue, 2)														-- LocalCreditValue
							,InterfaceInvoiceID																-- InterfaceInvoiceID
							,RAInvoiceID																	-- InvoiceID
							,InvoiceExtBAID																	-- ExtBAID
							,XRefExtBACode																	-- ExtBACode
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
							,AcctDtlID																		-- AcctDtlID
							,dbo.Custom_Format_SAP_Date_String(TransactionDate)								-- TransactionDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)								-- DueDate
							,Round(InvoiceQuantity, Coalesce(InvoiceQuantityDecimal, DefaultQtyDecimals, 3))-- Quantity
							,0																				-- PerUnitPrice				NA
							,TaxCode																		-- TaxCode
							,XRefChildPrdctCode																-- ProductCode
							,LocalFXRate 																	-- FXConversionRate			//TaxFXConversionRate
							,InvoiceCurrency																-- InvoiceCurrency
							,Round(DebitValue, 2)															-- InvoiceDebitValue		
							,Round(CreditValue, 2)															-- InvoiceCreditValue		
							,InvoiceIntBAID																	-- IntBAID
							,XRefIntBACode																	-- IntBACode
							,InvoiceNumber																	-- InvoiceNumber		
							,MvtHdrOrigin																	-- TitleTransfer
							,MvtHdrDestination																-- Destination
							,TrnsctnTypDesc																	-- TransactionType
							,Left(TrnsctnTypDesc,50)														-- TransactionDescription										
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble in ('TT', 'I') Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,ProfitCenter																	-- ProfitCenter
							,''																				-- CostCenter
							,SalesOffice																	-- SalesOffice				
							,MaterialGroup																	-- MaterialGroup							
							,DlDtlTpe																		-- DealType							
							,DlHdrIntrnlNbr																	-- DealNumber		
							,DlDtlID																		-- DealDetailID
							,PlnndTrnsfrID																	-- TransferID					
							,PlnndMvtID																		-- OrderID
							,PlnndMvtBtchID																	-- OrderBatchID
							,Plant																			-- Plant									
							,StorageLocation																-- StorageLocation							
							,XRefDocumentType																-- DocumentType			
							,ExtBAClass																		-- CustomerClassification				
							,XRefIntUserCode																-- SaleGroup
							,HighestValue																	-- HighestValue	
							,IsTax																			-- IsTax	
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage	
							,Reversed
							,Currency					
					From	#AR_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AR_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)
					And		Not Exists	(
										Select	1
										From	TransactionTypeGroup (NoLock)
												Inner Join TransactionGroup (NoLock)
													on	XGrpID	= XTpeGrpXGrpID
										Where	XGrpQlfr = 'Invoice Discount'
										and		CustomAccountDetail.TrnsctnTypID		= XTpeGrpTrnsctnTypID
										)

					Insert	#AR_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,Chart
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,AcctDtlID
							,TransactionDate
							,DueDate
							,Quantity
							,PerUnitPrice
							,TaxCode
							,ProductCode
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber		
							,TitleTransfer
							,Destination
							,TransactionType
							,TransactionDescription
							,RunningNumber
							,Vehicle
							,CarrierMode			
							,ParentInvoiceDate
							,ParentInvoiceNumber	
							,ReceiptRefundFlag
							,BL
							,PaymentTermCode
							,UnitPrice
							,UOM
							,AbsLocalValue
							,AbsInvoiceValue
							,LineType			
							,ProfitCenter
							,CostCenter
							,SalesOffice				
							,MaterialGroup				
							,DealType			
							,DealNumber		
							,DealDetailID
							,TransferID					
							,OrderID
							,OrderBatchID
							,Plant				
							,StorageLocation				
							,DocumentType			
							,CustomerClassification				
							,SaleGroup
							,HighestValue
							,IsTax
							,InterfaceStatus
							,InterfaceMessage
							,Reversed
							,Currency)	
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
							,InterfaceSource																-- InterfaceSource
							,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)						-- InvoiceGLDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDate)									-- InvoiceDate
							,AcctDtlAcctCdeCde																-- Chart
							,LocalCurrency																	-- LocalCurrency			
							,Round(LocalDebitValue, 2)														-- LocalDebitValue	
							,Round(LocalCreditValue, 2)														-- LocalCreditValue
							,InterfaceInvoiceID																-- InterfaceInvoiceID
							,RAInvoiceID																	-- InvoiceID
							,InvoiceExtBAID																	-- ExtBAID
							,XRefExtBACode																	-- ExtBACode
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
							,AcctDtlID																		-- AcctDtlID
							,dbo.Custom_Format_SAP_Date_String(TransactionDate)								-- TransactionDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)								-- DueDate
							,Round(InvoiceQuantity, Coalesce(InvoiceQuantityDecimal, DefaultQtyDecimals, 3))-- Quantity
							,0																				-- PerUnitPrice				NA
							,TaxCode																		-- TaxCode
							,XRefChildPrdctCode																-- ProductCode
							,LocalFXRate 																	-- FXConversionRate			//TaxFXConversionRate
							,InvoiceCurrency																-- InvoiceCurrency
							,Round(DebitValue, 2)															-- InvoiceDebitValue		
							,Round(CreditValue, 2)															-- InvoiceCreditValue		
							,InvoiceIntBAID																	-- IntBAID
							,XRefIntBACode																	-- IntBACode
							,InvoiceNumber																	-- InvoiceNumber		
							,MvtHdrOrigin																	-- TitleTransfer
							,MvtHdrDestination																-- Destination
							,'Discount'				-- TransactionType
							,'Discount'				-- TransactionDescription
							,999					-- RunningNumber
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble in ('TT', 'I') Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,ProfitCenter																	-- ProfitCenter
							,''																				-- CostCenter
							,SalesOffice																	-- SalesOffice				
							,MaterialGroup																	-- MaterialGroup							
							,DlDtlTpe																		-- DealType							
							,DlHdrIntrnlNbr																	-- DealNumber		
							,DlDtlID																		-- DealDetailID
							,PlnndTrnsfrID																	-- TransferID					
							,PlnndMvtID																		-- OrderID
							,PlnndMvtBtchID																	-- OrderBatchID
							,Plant																			-- Plant									
							,StorageLocation																-- StorageLocation							
							,XRefDocumentType																-- DocumentType			
							,ExtBAClass																		-- CustomerClassification				
							,XRefIntUserCode																-- SaleGroup
							,HighestValue																	-- HighestValue	
							,IsTax																			-- IsTax	
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage	
							,Reversed
							,Currency					
					From	#AR_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AR_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)
					And		Exists	(
									Select	1
									From	TransactionTypeGroup (NoLock)
											Inner Join TransactionGroup (NoLock)
												on	XGrpID	= XTpeGrpXGrpID
									Where	XGrpQlfr = 'Invoice Discount'
									and		CustomAccountDetail.TrnsctnTypID		= XTpeGrpTrnsctnTypID
									)

					Insert	#AR_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,DueDate
							,Quantity
							,AcctDtlID																		-- AcctDtlID
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber
							,Chart
							,RunningNumber		
							,PaymentTermCode
							,UOM
							,DocumentType
							,InterfaceStatus
							,InterfaceMessage
		
							,TransactionDate
							,ProductCode
							,TitleTransfer
							,Destination
							,TransactionType
							,TransactionDescription
							,CarrierMode
							,ParentInvoiceNumber
							,ReceiptRefundFlag
							,BL
							,LineType
							,DealNumber
							,DealDetailID
							,AbsLocalValue
							,AbsInvoiceValue
							)	
					Select	'D'						-- InvoiceLevel	
							,MessageQueueID			-- MessageQueueID	
							,InterfaceSource		-- InterfaceSource
							,InvoiceGLDate			-- InvoiceGLDate
							,InvoiceDate			-- InvoiceDate
							,LocalCurrency			-- LocalCurrency
							,Case When EstimatedDiscountValue > 0 Then 0 Else EstimatedDiscountValue end	-- LocalDebitValue
							,Case When EstimatedDiscountValue < 0 Then 0 Else EstimatedDiscountValue end	-- LocalCreditValue
							,#AR_Interface.InterfaceInvoiceID		-- InterfaceInvoiceID
							,InvoiceID				-- InvoiceID
							,ExtBAID				-- ExtBAID
							,ExtBACode				-- ExtBACode
							,PaymentMethod			-- PaymentMethod
							,Case	When IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
									Then dbo.Custom_Format_SAP_Date_String(SalesInvoiceHeader.SlsInvceHdrDscntDte)
									Else DueDate End		-- DueDate
							,Quantity				-- Quantity
							,#AR_Interface.AcctDtlID				-- AcctDtlID
							,FXConversionRate		-- FXConversionRate
							,InvoiceCurrency		-- InvoiceCurrency
							,Case When EstimatedDiscountValue > 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceDebitValue  
							,Case When EstimatedDiscountValue < 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceCreditValue
							,IntBAID				-- IntBAID
							,IntBACode				-- IntBACode
							,InvoiceNumber			-- InvoiceNumber
							,GCDiscount.GnrlCnfgMulti			-- Chart
							,999					-- RunningNumber
							,PaymentTermCode		-- PaymentTermCode	
							,UOM					-- UOM
							,DocumentType			-- DocumentType
							,InterfaceStatus		-- InterfaceStatus
							,InterfaceMessage		-- InterfaceMessage

							,TransactionDate		-- TransactionDate
							,ProductCode			-- ProductCode
							,TitleTransfer			-- TitleTransfer
							,Destination			-- Destination
							,'Discount'				-- TransactionType
							,'Discount'				-- TransactionDescription
							,CarrierMode			-- CarrierMode
							,ParentInvoiceNumber	-- ParentInvoiceNumber
							,Case	When #AR_Interface.ReceiptRefundFlag = 'AP'
									Then 'AR' Else 'AP' End					-- ReceiptRefundFlag
							,BL						-- BL
							,Case	When #AR_Interface.LineType = 40
									Then 50 Else 40 End							-- LineType
							,DealNumber				-- DealNumber
							,DealDetailID			-- DealDetailID

							,Abs(EstimatedDiscountValue)	-- AbsLocalValue
							,Abs(EstimatedDiscountValue)	-- AbsInvoiceValue

					-- select *
					From	#AR_Interface	(NoLock)
							Inner Join AccountDetail (NoLock)
								on	AccountDetail.AcctDtlID		= #AR_Interface.AcctDtlID
							Inner Join SalesInvoiceHeader (NoLock)
								on	AccountDetail.AcctDtlSlsInvceHdrID	= SalesInvoiceHeader.SlsInvceHdrID
							Left Outer Join GeneralConfiguration GCTerm (NoLock)
								on	GCTerm.GnrlCnfgTblNme		= 'Term'
								and	GCTerm.GnrlCnfgQlfr			= 'BaseOilDirectDebit'
								and	GCTerm.GnrlCnfgHdrID		= SalesInvoiceHeader.SlsInvceHdrTrmID
							Left Outer Join GeneralConfiguration GCDiscount (NoLock)
								on	GCDiscount.GnrlCnfgTblNme	= 'BusinessAssociate'
								and	GCDiscount.GnrlCnfgQlfr		= 'DiscountGLAccount'
								and	GCDiscount.GnrlCnfgHdrID	= #AR_Interface.IntBAID
							Inner Join AccountDetailEstimatedDate (NoLock)
								on	AccountDetailEstimatedDate.AcctDtlID					= #AR_Interface.AcctDtlID
								and	AccountDetailEstimatedDate.EstimatedDiscountValue		<> 0.0
					Where	#AR_Interface.InvoiceLevel			= 'D'
					And		(
							IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
							or
							not exists	( -- excluding these 2 invoice types per defect 7924, unless GCTerm="Y"
										Select	1
										From	SalesInvoiceType (NoLock)
										Where	SalesInvoiceType.SlsInvceTpeID		= SalesInvoiceHeader.SlsInvceHdrSlsInvceTpeID
										And		SalesInvoiceType.SlsInvceTpeDscrptn	in ('3rd Party Product Sales Invoice', '3rd Party Product Bulk  Email')
										)
							)


					Update	#AR_Interface
					Set		DueDate = dbo.Custom_Format_SAP_Date_String(SalesInvoiceHeader.SlsInvceHdrDscntDte)
					From	#AR_Interface
							Inner Join SalesInvoiceHeader (NoLock)
								on	#AR_Interface.InvoiceID		= SalesInvoiceHeader.SlsInvceHdrID
					Where	Exists	(
									Select	1
									From	#AR_Interface Sub
											Inner Join SalesInvoiceHeader SIHSub (NoLock)
												on	Sub.InvoiceID											= SIHSub.SlsInvceHdrID
											Inner Join GeneralConfiguration GCTerm (NoLock)
												on	GCTerm.GnrlCnfgTblNme									= 'Term'
												and	GCTerm.GnrlCnfgQlfr										= 'BaseOilDirectDebit'
												and	GCTerm.GnrlCnfgHdrID									= SIHSub.SlsInvceHdrTrmID
											Inner Join AccountDetailEstimatedDate (NoLock)
												on	AccountDetailEstimatedDate.AcctDtlID					= Sub.AcctDtlID
												and	AccountDetailEstimatedDate.EstimatedDiscountValue		<> 0.0
									Where	Sub.MessageQueueID				= #AR_Interface.MessageQueueID
									And		(
											IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
											or
											not exists	( -- excluding these 2 invoice types per defect 7924, unless GCTerm="Y"
														Select	1
														From	SalesInvoiceType (NoLock)
														Where	SalesInvoiceType.SlsInvceTpeID		= SIHSub.SlsInvceHdrSlsInvceTpeID
														And		SalesInvoiceType.SlsInvceTpeDscrptn	in ('3rd Party Product Sales Invoice', '3rd Party Product Bulk  Email')
														)
											)
									)



					Insert	#AR_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,DueDate
							,Quantity
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber
							,RunningNumber		
							,PaymentTermCode
							,UOM
							,DocumentType
							,InterfaceStatus
							,InterfaceMessage)	
					Select	'H'						-- InvoiceLevel
							,MessageQueueID			-- MessageQueueID
							,InterfaceSource		-- InterfaceSource
							,InvoiceGLDate			-- InvoiceGLDate
							,min(InvoiceDate)		-- InvoiceDate
							,LocalCurrency			-- LocalCurrency
							,Sum(LocalCreditValue)	-- LocalDebitValue
							,Sum(LocalDebitValue)	-- LocalCreditValue
							,InterfaceInvoiceID		-- InterfaceInvoiceID
							,InvoiceID				-- InvoiceID
							,ExtBAID				-- ExtBAID
							,ExtBACode				-- ExtBACode
							,PaymentMethod			-- PaymentMethod
							,DueDate				-- DueDate
							,Sum(Quantity)			-- Quantity
							,FXConversionRate		-- FXConversionRate
							,InvoiceCurrency		-- InvoiceCurrency
							,Sum(InvoiceCreditValue)-- InvoiceDebitValue
							,Sum(InvoiceDebitValue)	-- InvoiceCreditValue
							,IntBAID				-- IntBAID
							,IntBACode				-- IntBACode
							,InvoiceNumber			-- InvoiceNumber
							,1						-- RunningNumber
							,PaymentTermCode		-- PaymentTermCode
							,UOM					-- UOM
							,DocumentType			-- DocumentType
							,InterfaceStatus		-- InterfaceStatus
							,InterfaceMessage		-- InterfaceMessage
					From	#AR_Interface	(NoLock)
					Group By	 MessageQueueID
								,InterfaceSource
								,InvoiceGLDate
								,LocalCurrency
								,InterfaceInvoiceID
								,InvoiceID
								,ExtBAID
								,ExtBACode
								,PaymentMethod
								,DueDate
								,FXConversionRate
								,InvoiceCurrency
								,IntBAID
								,IntBACode
								,InvoiceNumber
								,PaymentTermCode
								,UOM
								,DocumentType
								,InterfaceStatus
								,InterfaceMessage


					Update	#AR_Interface
					Set		LineType			=	CustomAccountDetail. InvoiceLineType
							,ReceiptRefundFlag	=	Case
														When	CustomAccountDetail. InvoiceAmount	>= 0	Then 'AR'	
														Else	'AP'
													End
					From	#AR_Interface					(NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
					Where	#AR_Interface. InvoiceLevel				= 'H'


					Update	#AR_Interface
					Set		Chart = AcctDtlAcctCdeCde
					From	#AR_Interface (NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
							Inner Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= AcctDtlAcctCdeAcctCdeID
									and		AccountCode.AcctCdeTpe	= 'O'
									)
					And		#AR_Interface. InvoiceLevel				= 'H'


					
					Update	Header
					Set		 Header. TransactionDate		= Detail. TransactionDate
							,Header. ProductCode			= Detail. ProductCode
							,Header. TitleTransfer			= Detail. TitleTransfer	
							,Header. Destination			= Detail. Destination
							,Header. TransactionType		= Detail. TransactionType
							,Header. Vehicle				= Detail. Vehicle		
							,Header. CarrierMode			= Detail. CarrierMode
							,Header. BL						= Detail. BL
							,Header. ProfitCenter			= Detail. ProfitCenter
							,Header. CostCenter				= Detail. CostCenter
							,Header. SalesOffice			= Detail. SalesOffice
							,Header. MaterialGroup			= Detail. MaterialGroup
							,Header. DealType				= Detail. DealType
							,Header. DealNumber				= Detail. DealNumber
							,Header. DealDetailID			= Detail. DealDetailID
							,Header. TransferID				= Detail. TransferID
							,Header. OrderID				= Detail. OrderID
							,Header. OrderBatchID			= Detail. OrderBatchID
							,Header. Plant					= Detail. Plant
							,Header. StorageLocation		= Detail. StorageLocation
							,Header. CustomerClassification	= Detail. CustomerClassification
							,Header. SaleGroup				= Detail. SaleGroup
					From	#AR_Interface				Header	(NoLock)
							Inner Join	#AR_Interface	Detail	(NoLock)
								On	Header. InterfaceInvoiceID	= Detail. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Detail. InvoiceLevel	= 'D'
					And		Detail. HighestValue	= 'Y'



					
					Update	Tax
					Set		 Tax. TransactionDate		= Header. TransactionDate
							,Tax. ProductCode			= Header. ProductCode
							,Tax. TitleTransfer			= Header. TitleTransfer	
							,Tax. Destination			= Header. Destination
							--,Tax. TransactionType		= Header. TransactionType
							,Tax. Vehicle				= Header. Vehicle		
							,Tax. CarrierMode			= Header. CarrierMode
							-- ,Tax. BL					= Header. BL
							-- ,Tax. ProfitCenter		= Header. ProfitCenter
							-- ,Tax. CostCenter			= Header. CostCenter
							,Tax. SalesOffice			= Header. SalesOffice
							,Tax. MaterialGroup			= Header. MaterialGroup
							,Tax. DealType				= Header. DealType
							-- ,Tax. DealNumber			= Header. DealNumber
							,Tax. DealDetailID			= Header. DealDetailID
							,Tax. TransferID			= Header. TransferID
							,Tax. OrderID				= Header. OrderID
							,Tax. OrderBatchID			= Header. OrderBatchID
							,Tax. Plant					= Header. Plant
							,Tax. StorageLocation		= Header. StorageLocation
							,Tax. DocumentType			= Header. DocumentType
							,Tax. CustomerClassification	= Header. CustomerClassification
							,Tax. SaleGroup				= Header. SaleGroup		
					From	#AR_Interface				Header	(NoLock)
							Inner Join	#AR_Interface	Tax		(NoLock)
								On	Header. InterfaceInvoiceID	= Tax. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Tax. InvoiceLevel		= 'T'

					Update	#AR_Interface
					Set		PerUnitPrice	=	Abs(Case When Quantity <> 0
												Then ( (IsNull(InvoiceDebitValue,0) + IsNull(InvoiceCreditValue,0)) / Quantity )
												Else	0.0
												End)



					Update	#AR_Interface							
					Set		AbsLocalValue		= Abs(LocalDebitValue + LocalCreditValue)
							,AbsInvoiceValue	= Abs(InvoiceDebitValue + InvoiceCreditValue)
					Where	#AR_Interface. InvoiceLevel	In ('H','T')


					Update	#AR_Interface
					Set		TransactionDescription	= Substring(IsNull((Select	(	Select	Distinct '; ' +  CustomAccountDetail. TrnsctnTypDesc
																				From	CustomAccountDetail	(NoLock)
																				Where	CustomAccountDetail. InterfaceInvoiceID	= #AR_Interface.InterfaceInvoiceID
																				And		IsNull(CustomAccountDetail. TrnsctnTypDesc, '')	<> ''
																				FOR XML PATH('') ) As Details), ''), 3, 50) 						
					Where	#AR_Interface. InvoiceLevel	= 'H'



					Begin Transaction InsertAR

						----------------------------------------------------------------------------------------------------------------------
						-- Stage the record into the CustomInvoiceInterface table
						----------------------------------------------------------------------------------------------------------------------	
						Insert	CustomInvoiceInterface
								(InvoiceLevel
								,MessageQueueID
								,InterfaceSource
								,InvoiceGLDate
								,InvoiceDate
								,Chart
								,LocalCurrency				
								,LocalDebitValue	
								,LocalCreditValue
								,InterfaceInvoiceID
								,InvoiceID
								,ExtBAID
								,ExtBACode
								,PaymentMethod				
								,AcctDtlID
								,TransactionDate
								,DueDate
								,Quantity
								,PerUnitPrice
								,TaxCode
								,ProductCode	
								,FXConversionRate
								,InvoiceCurrency
								,InvoiceDebitValue
								,InvoiceCreditValue
								,IntBAID						
								,IntBACode
								,InvoiceNumber
								,RunningNumber					
								,TitleTransfer
								,Destination
								,TransactionType
								,TransactionDescription										
								,Vehicle
								,CarrierMode			
								,ParentInvoiceDate
								,ParentInvoiceNumber	
								,ReceiptRefundFlag
								,BL	
								,PaymentTermCode
								,UnitPrice
								,UOM
								,AbsLocalValue
								,AbsInvoiceValue	
								,LineType			
								,ProfitCenter
								,CostCenter
								,SalesOffice				
								,MaterialGroup			
								,DealType			
								,DealNumber		
								,DealDetailID
								,TransferID					
								,OrderID
								,OrderBatchID
								,Plant				
								,StorageLocation				
								,DocumentType				
								,CustomerClassification				
								,SaleGroup				
								,InterfaceStatus
								,InterfaceMessage
								,ApprovalUserID
								,ApprovalDate
								,CreationDate
								,MessageBusConfirmed)	
						Select	InvoiceLevel								-- InvoiceLevel
								,MessageQueueID								-- MessageQueueID
								,InterfaceSource							-- InterfaceSource
								,IsNull(InvoiceGLDate,'')					-- InvoiceGLDate
								,IsNull(InvoiceDate,'')						-- InvoiceDate
								,IsNull(Chart,'')							-- Chart
								,IsNull(LocalCurrency,'')					-- LocalCurrency				
								,LocalDebitValue							-- LocalDebitValue	
								,LocalCreditValue							-- LocalCreditValue
								,InterfaceInvoiceID							-- InterfaceInvoiceID
								,InvoiceID									-- InvoiceID
								,ExtBAID									-- ExtBAID
								,IsNull(ExtBACode,'')						-- ExtBACode
								,IsNull(PaymentMethod,'')					-- PaymentMethod				
								,AcctDtlID									-- AcctDtlID
								,IsNull(TransactionDate,'')					-- TransactionDate
								,IsNull(DueDate,'')							-- DueDate
								,Quantity									-- Quantity
								,PerUnitPrice								-- PerUnitPrice
								,IsNull(TaxCode,'')							-- TaxCode
								,IsNull(ProductCode,'')						-- ProductCode	
								,FXConversionRate							-- FXConversionRate
								,IsNull(InvoiceCurrency,'')					-- InvoiceCurrency
								,InvoiceDebitValue							-- InvoiceDebitValue
								,InvoiceCreditValue							-- InvoiceCreditValue
								,IntBAID									-- IntBAID						
								,IsNull(IntBACode,'')						-- IntBACode
								,IsNull(InvoiceNumber,'')					-- InvoiceNumber
								,RunningNumber								-- RunningNumber					
								,IsNull(TitleTransfer,'')					-- TitleTransfer
								,IsNull(Destination,'')						-- Destination
								,IsNull(TransactionType,'')					-- TransactionType
								,IsNull(TransactionDescription,'')			-- TransactionDescription										
								,IsNull(Vehicle,'')							-- Vehicle
								,IsNull(CarrierMode,'')						-- CarrierMode			
								,IsNull(ParentInvoiceDate,'')				-- ParentInvoiceDate
								,IsNull(ParentInvoiceNumber,'')				-- ParentInvoiceNumber	
								,IsNull(ReceiptRefundFlag,'')				-- ReceiptRefundFlag
								,IsNull(BL,'')								-- BL	
								,IsNull(PaymentTermCode,'')					-- PaymentTermCode
								,UnitPrice									-- UnitPrice
								,IsNull(UOM,'')								-- UOM
								,AbsLocalValue								-- AbsLocalValue
								,AbsInvoiceValue							-- AbsInvoiceValue	
								,IsNull(LineType,'')						-- LineType			
								,IsNull(ProfitCenter,'')					-- ProfitCenter
								,IsNull(CostCenter,'')						-- CostCenter
								,IsNull(SalesOffice,'')						-- SalesOffice				
								,IsNull(MaterialGroup,'')					-- MaterialGroup			
								,IsNull(DealType,'')						-- DealType			
								,IsNull(DealNumber,'')						-- DealNumber		
								,DealDetailID								-- DealDetailID
								,TransferID									-- TransferID					
								,OrderID									-- OrderID
								,OrderBatchID								-- OrderBatchID
								,IsNull(Plant,'')							-- Plant				
								,IsNull(StorageLocation,'')					-- StorageLocation				
								,IsNull(DocumentType,'')					-- DocumentType				
								,IsNull(CustomerClassification,'')			-- CustomerClassification				
								,IsNull(SaleGroup,'')						-- SaleGroup				
								,InterfaceStatus							-- InterfaceStatus
								,RTrim(LTrim(IsNull(InterfaceMessage,'')))	-- InterfaceMessage
								,NULL										-- ApprovalUserID
								,NULL										-- ApprovalDate
								,getdate()									-- CreationDate
								,0											-- MessageBusConfirmed	 
						From	#AR_Interface	(NoLock)
						Order By MessageQueueID Asc, AbsInvoiceValue Desc
			
						---------------------------------------------------------------------------------------------------------------------
						-- Check for Errors on the Insert
						----------------------------------------------------------------------------------------------------------------------
						If	@@error <> 0
							Begin
								Rollback Transaction InsertAR

									Update	CustomMessageQueue
									Set		RAProcessed			= 1
											,RAProcessedDate	= GetDate()
											,HasErrored			= 1
											,Error				= 'The AR Interface encountered an error inserting a record into the CustomInvoiceInterface table.' 
											,Reprocess			= 0
									From	#AR_Bulk
											Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
							End						

						----------------------------------------------------------------------------------------------------------------------------------
						-- Commit the Transaction
						----------------------------------------------------------------------------------------------------------------------------------
						Commit Transaction InsertAR

						Update	CustomMessageQueue
						Set		RAProcessed			= 1
								,RAProcessedDate	= GetDate()
								,HasErrored			= 0
								,Error				= NULL
								,Reprocess			= 0
						From	#AR_Bulk
								Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID

						If	Object_ID('TempDB..#AR_Interface') Is Not Null
							Drop Table #AR_Interface
						If	Object_ID('TempDB..#AR_Bulk') Is Not Null
							Drop Table #AR_Bulk
		end
END


---------------------------------------------
-- Now, do the same for AP invoices
---------------------------------------------
if exists (select 1 from #AP_Bulk)
begin

	-- First set any errors where we can't process an invoice
	Update	#AP_Bulk
	Set		Message = case when PayableHeader.FedDate is not null
						then 'The invoice cannot be reprocessed because it has already been Fed.'
						when PayableHeader.Status = 'P'
						then 'The invoice cannot be reprocessed because it has already been Paid.'
						end
	From	#AP_Bulk
			Inner Join dbo.PayableHeader (NoLock)
				on	#AP_Bulk.EntityID		= PayableHeader.PybleHdrID
	Where	#AP_Bulk.Reprocess = 1


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AP_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
	Where	Message is not null

	Delete	#AP_Bulk
	Where	Message is not null

	-- Get rid of any old data when we're going to reprocess
	Delete	dbo.CustomAccountDetail
	From	#AP_Bulk
			Inner Join dbo.CustomAccountDetail
				on	InterfaceMessageID = #AP_Bulk.ID
	Where	#AP_Bulk.Reprocess = 1
		
	Delete	dbo.CustomInvoiceInterface
	From	#AP_Bulk
			Inner Join dbo.CustomInvoiceInterface
				on	MessageQueueID = #AP_Bulk.ID
	Where	#AP_Bulk.Reprocess = 1


	Update	#AP_Bulk
	Set		Message = 'The Invoice Interface has already processed PybleHdrID: ' + convert(varchar,EntityID) + '. (Does CAD Exist?) '
	From	#AP_Bulk
	Where	Exists	(
					Select	1
					From	dbo.CustomAccountDetail (NoLock)
					Where	RAInvoiceID		= #AP_Bulk.EntityID
					And		InterfaceSource	= 'PH'
					)

	Update	#AP_Bulk
	Set		Message = 'The Invoice Interface cannot process PybleHdrID: ' + convert(varchar,EntityID) + '. (Is status FEED? Has FedDate already set?) '
	From	#AP_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.PayableHeader (NoLock)
						Where	Status		= 'F'
						And		FedDate		Is Null
						And		PybleHdrID	= #AP_Bulk.EntityID
						)


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AP_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
	Where	Message is not null

	Delete	#AP_Bulk
	Where	Message is not null


	if exists (select 1 from #AP_Bulk)
	begin
		-- Call out to the AD_Mapping proc (-2 for bulk AP)
		Exec dbo.Custom_Interface_AD_Mapping	@i_ID				= -2
												,@i_MessageID		= -2
												,@vc_Source			= 'PH'
												,@c_ReturnToInvoice	= 'N'
												,@c_OnlyShowSQL		= 'N'


		-- Finally, do the aggregation for the CustomInvoiceInterface table
			Create Table	#AP_Interface
							(ID								int				Identity 
							,InvoiceLevel					char(1)			Not Null
							,MessageQueueID					int				Not Null
							,InterfaceSource				char(2)			Null
							,InvoiceGLDate					varchar(25)		Null
							,InvoiceDate					varchar(25)		Null
							,Chart							varchar(80)		Null
							,LocalCurrency					char(3)			Null				
							,LocalDebitValue				decimal(19,2)	Null	Default 0	
							,LocalCreditValue				decimal(19,2)	Null	Default 0	
							,InterfaceInvoiceID				int				Null
							,InvoiceID						int				Null
							,ExtBAID						int				Null
							,ExtBACode						varchar(25)		Null
							,PaymentMethod					varchar(25)		Null				
							,AcctDtlID						int				Null
							,TransactionDate				varchar(25)		Null
							,DueDate						varchar(25)		Null
							,Quantity						decimal(19,6)	Null
							,PerUnitPrice					decimal(19,6)	Null	Default 0	
							,TaxCode						varchar(15)		Null
							,ProductCode					varchar(50)		Null	
							,FXConversionRate				decimal(28,13)	Null	Default 1.0	
							,InvoiceCurrency				varchar(3)		Null
							,InvoiceDebitValue				decimal(19,2)	Null	Default 0	
							,InvoiceCreditValue				decimal(19,2)	Null	Default 0	
							,IntBAID						int				Null							
							,IntBACode						varchar(25)		Null
							,InvoiceNumber					varchar(20)		Null 
							,RunningNumber					int				Null					
							,TitleTransfer					varchar(150)	Null
							,Destination					varchar(150)	Null
							,TransactionType				varchar(80)		Null
							,TransactionDescription			varchar(50)		Null										
							,Vehicle						varchar(50)		Null
							,CarrierMode					varchar(50)		Null			
							,ParentInvoiceDate				varchar(25)		Null
							,ParentInvoiceNumber			varchar(20)		Null	
							,ReceiptRefundFlag				varchar(5)		Null
							,BL								varchar(80)		Null
							,PaymentTermCode				varchar(20)		Null
							,UnitPrice						decimal(19,6)	Null	Default 0
							,UOM							varchar(20)		Null
							,AbsLocalValue					decimal(19,2)	Null	Default 0	
							,AbsInvoiceValue				decimal(19,2)	Null	Default 0	
							,LineType						varchar(3)		Null				
							,ProfitCenter					varchar(80)		Null
							,CostCenter						varchar(80)		Null
							,SalesOffice					varchar(25)		Null				
							,MaterialGroup					varchar(5)		Null				
							,DealType						varchar(60)		Null				
							,DealNumber						varchar(20)		Null		
							,DealDetailID					smallint		Null
							,TransferID						int				Null					
							,OrderID						int				Null
							,OrderBatchID					int				Null
							,Plant							varchar(5)		Null				
							,StorageLocation				varchar(5)		Null				
							,HighestValue					char(1)			Null	
							,IsTax							tinyint			Null			
							,InterfaceStatus				char(1)			Null
							,InterfaceMessage				varchar(2000)	Null
							,Reversed						char(1)			Null
							,Currency						char(3)			Null)

							Insert	#AP_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,Chart
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,AcctDtlID
							,TransactionDate
							,DueDate
							,Quantity
							,PerUnitPrice
							,TaxCode
							,ProductCode
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber		
							,TitleTransfer
							,Destination
							,TransactionType
							,TransactionDescription										
							,Vehicle
							,CarrierMode			
							,ParentInvoiceDate
							,ParentInvoiceNumber	
							,ReceiptRefundFlag
							,BL
							,PaymentTermCode
							,UnitPrice
							,UOM
							,AbsLocalValue
							,AbsInvoiceValue
							,LineType			
							,ProfitCenter
							,CostCenter
							,SalesOffice				
							,MaterialGroup				
							,DealType			
							,DealNumber		
							,DealDetailID
							,TransferID					
							,OrderID
							,OrderBatchID
							,Plant				
							,StorageLocation				
							,HighestValue
							,IsTax
							,InterfaceStatus
							,InterfaceMessage
							,Reversed
							,Currency)	
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
							,InterfaceSource																-- InterfaceSource
							,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)						-- InvoiceGLDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDate)									-- InvoiceDate
							,AcctDtlAcctCdeCde																-- Chart
							,LocalCurrency																	-- LocalCurrency			
							,Round(LocalDebitValue, 2)														-- LocalDebitValue	
							,Round(LocalCreditValue, 2)														-- LocalCreditValue
							,InterfaceInvoiceID																-- InterfaceInvoiceID
							,RAInvoiceID																	-- InvoiceID
							,InvoiceExtBAID																	-- ExtBAID
							,XRefExtBACode																	-- ExtBACode
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
							,AcctDtlID																		-- AcctDtlID
							,dbo.Custom_Format_SAP_Date_String(TransactionDate)								-- TransactionDate
							,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)								-- DueDate
							,Round(InvoiceQuantity, Coalesce(InvoiceQuantityDecimal, DefaultQtyDecimals, 3))-- Quantity
							,0																				-- PerUnitPrice				NA
							,TaxCode																		-- TaxCode
							,XRefChildPrdctCode																-- ProductCode
							,LocalFXRate 																	-- FXConversionRate			//TaxFXConversionRate
							,InvoiceCurrency																-- InvoiceCurrency
							,Round(DebitValue, 2)															-- InvoiceDebitValue		
							,Round(CreditValue, 2)															-- InvoiceCreditValue		
							,InvoiceIntBAID																	-- IntBAID
							,XRefIntBACode																	-- IntBACode
							,InvoiceNumber																	-- InvoiceNumber		
							,MvtHdrOrigin																	-- TitleTransfer
							,MvtHdrDestination																-- Destination
							,TrnsctnTypDesc																	-- TransactionType
							,Left(TrnsctnTypDesc,50)														-- TransactionDescription										
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble = 'TT' Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,''																				-- ProfitCenter
							,CostCenter																		-- CostCenter
							,SalesOffice																	-- SalesOffice				
							,MaterialGroup																	-- MaterialGroup							
							,DlDtlTpe																		-- DealType							
							,DlHdrIntrnlNbr																	-- DealNumber		
							,DlDtlID																		-- DealDetailID
							,PlnndTrnsfrID																	-- TransferID					
							,PlnndMvtID																		-- OrderID
							,PlnndMvtBtchID																	-- OrderBatchID
							,Plant																			-- Plant									
							,StorageLocation																-- StorageLocation							
							,HighestValue																	-- HighestValue
							,IsTax																			-- IsTax		
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage
							,Reversed																		-- Reversed	
							,Currency		
					From	#AP_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AP_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)




					Insert	#AP_Interface
							(InvoiceLevel
							,MessageQueueID
							,InterfaceSource
							,InvoiceGLDate
							,InvoiceDate
							,LocalCurrency
							,LocalDebitValue
							,LocalCreditValue
							,InterfaceInvoiceID
							,InvoiceID
							,ExtBAID
							,ExtBACode
							,PaymentMethod
							,DueDate
							,Quantity
							,FXConversionRate
							,InvoiceCurrency
							,InvoiceDebitValue
							,InvoiceCreditValue
							,IntBAID
							,IntBACode
							,InvoiceNumber
							,RunningNumber		
							,PaymentTermCode
							,UOM
							,InterfaceStatus
							,InterfaceMessage)	
					Select	'H'						-- InvoiceLevel	
							,MessageQueueID			-- MessageQueueID	
							,InterfaceSource		-- InterfaceSource
							,InvoiceGLDate			-- InvoiceGLDate
							,InvoiceDate			-- InvoiceDate
							,LocalCurrency			-- LocalCurrency
							,Sum(LocalCreditValue)	-- LocalDebitValue
							,Sum(LocalDebitValue)	-- LocalCreditValue
							,InterfaceInvoiceID		-- InterfaceInvoiceID
							,InvoiceID				-- InvoiceID
							,ExtBAID				-- ExtBAID
							,ExtBACode				-- ExtBACode
							,PaymentMethod			-- PaymentMethod
							,DueDate				-- DueDate
							,Sum(Quantity)			-- Quantity
							,FXConversionRate		-- FXConversionRate
							,InvoiceCurrency		-- InvoiceCurrency
							,Sum(InvoiceCreditValue)-- InvoiceDebitValue  
							,Sum(InvoiceDebitValue)	-- InvoiceCreditValue
							,IntBAID				-- IntBAID
							,IntBACode				-- IntBACode
							,InvoiceNumber			-- InvoiceNumber
							,1						-- RunningNumber
							,PaymentTermCode		-- PaymentTermCode	
							,min(UOM)				-- UOM
							,InterfaceStatus		-- InterfaceStatus
							,InterfaceMessage		-- InterfaceMessage
					From	#AP_Interface	(NoLock)
					Group By	 MessageQueueID
								,InterfaceSource
								,InvoiceGLDate
								,InvoiceDate
								,LocalCurrency
								,InterfaceInvoiceID
								,InvoiceID
								,ExtBAID
								,ExtBACode
								,PaymentMethod
								,DueDate
								,FXConversionRate
								,InvoiceCurrency
								,IntBAID
								,IntBACode
								,InvoiceNumber
								,PaymentTermCode
								,InterfaceStatus
								,InterfaceMessage


					Update	#AP_Interface
					Set		LineType			=	CustomAccountDetail. InvoiceLineType
							,ReceiptRefundFlag	=	Case
														When	CustomAccountDetail. InvoiceAmount	>= 0	Then 'AP'	
														Else	'AR'
													End
					From	#AP_Interface					(NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AP_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID 	
					Where	#AP_Interface. InvoiceLevel				= 'H'


					Update	#AP_Interface
					Set		Chart = AcctDtlAcctCdeCde
					From	#AP_Interface (NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AP_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
							Inner Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= AcctDtlAcctCdeAcctCdeID
									and		AccountCode.AcctCdeTpe	= 'O'
									)
					And		#AP_Interface. InvoiceLevel				= 'H'


					Update	Header
					Set		 Header. TransactionDate		= Detail. TransactionDate
							,Header. ProductCode			= Detail. ProductCode
							,Header. TitleTransfer			= Detail. TitleTransfer	
							,Header. Destination			= Detail. Destination
							,Header. TransactionType		= Detail. TransactionType
							,Header. Vehicle				= Detail. Vehicle		
							,Header. CarrierMode			= Detail. CarrierMode
							,Header. BL						= Detail. BL
							,Header. ProfitCenter			= Detail. ProfitCenter
							,Header. CostCenter				= Detail. CostCenter
							,Header. SalesOffice			= Detail. SalesOffice
							,Header. MaterialGroup			= Detail. MaterialGroup
							,Header. DealType				= Detail. DealType
							,Header. DealNumber				= Detail. DealNumber
							,Header. DealDetailID			= Detail. DealDetailID
							,Header. TransferID				= Detail. TransferID
							,Header. OrderID				= Detail. OrderID
							,Header. OrderBatchID			= Detail. OrderBatchID
							,Header. Plant					= Detail. Plant
							,Header. StorageLocation		= Detail. StorageLocation
					From	#AP_Interface				Header	(NoLock)
							Inner Join	#AP_Interface	Detail	(NoLock)
								On	Header. InterfaceInvoiceID	= Detail. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Detail. InvoiceLevel	= 'D'
					And		Detail. HighestValue	= 'Y'			 	


					Update	Tax
					Set		 Tax. TransactionDate		= Header. TransactionDate
							,Tax. ProductCode			= Header. ProductCode
							,Tax. TitleTransfer			= Header. TitleTransfer	
							,Tax. Destination			= Header. Destination
							--,Tax. TransactionType		= Header. TransactionType
							,Tax. Vehicle				= Header. Vehicle		
							,Tax. CarrierMode			= Header. CarrierMode
							-- ,Tax. BL					= Header. BL
							-- ,Tax. ProfitCenter		= Header. ProfitCenter
							-- ,Tax. CostCenter			= Header. CostCenter
							,Tax. SalesOffice			= Header. SalesOffice
							,Tax. MaterialGroup			= Header. MaterialGroup
							,Tax. DealType				= Header. DealType
							-- ,Tax. DealNumber			= Header. DealNumber
							,Tax. DealDetailID			= Header. DealDetailID
							,Tax. TransferID			= Header. TransferID
							,Tax. OrderID				= Header. OrderID
							,Tax. OrderBatchID			= Header. OrderBatchID
							,Tax. Plant					= Header. Plant
							,Tax. StorageLocation		= Header. StorageLocation
					From	#AP_Interface				Header	(NoLock)
							Inner Join	#AP_Interface	Tax		(NoLock)	On	Header. InterfaceInvoiceID	= Tax. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Tax. InvoiceLevel		= 'T'		 	



					Update	#AP_Interface
					Set		PerUnitPrice	=	Abs(Case When Quantity <> 0
													Then ( (IsNull(InvoiceDebitValue,0) + IsNull(InvoiceCreditValue,0)) / Quantity )
													Else	0.0
												End)


					Update	#AP_Interface							
					Set		AbsLocalValue		= Abs(LocalDebitValue + LocalCreditValue)
							,AbsInvoiceValue	= Abs(InvoiceDebitValue + InvoiceCreditValue)
					Where	#AP_Interface. InvoiceLevel	In ('H','T')


					Update	#AP_Interface							
					Set		TransactionDescription	= Substring(IsNull((Select	(	Select	Distinct '; ' +  CustomAccountDetail. TrnsctnTypDesc
																				From	CustomAccountDetail	(NoLock)
																				Where	CustomAccountDetail. InterfaceInvoiceID	=  #AP_Interface.InterfaceInvoiceID
																				And		IsNull(CustomAccountDetail. TrnsctnTypDesc, '')	<> ''
																				FOR XML PATH('') ) As Details), ''), 3, 50) 						
					Where	#AP_Interface. InvoiceLevel	= 'H'



			Begin Transaction InsertAP

				----------------------------------------------------------------------------------------------------------------------
				-- Stage the record into the CustomInvoiceInterface table
				----------------------------------------------------------------------------------------------------------------------	
				Insert	CustomInvoiceInterface
						(InvoiceLevel
						,MessageQueueID
						,InterfaceSource
						,InvoiceGLDate
						,InvoiceDate
						,Chart
						,LocalCurrency				
						,LocalDebitValue	
						,LocalCreditValue
						,InterfaceInvoiceID
						,InvoiceID
						,ExtBAID
						,ExtBACode
						,PaymentMethod				
						,AcctDtlID
						,TransactionDate
						,DueDate
						,Quantity
						,PerUnitPrice
						,TaxCode
						,ProductCode	
						,FXConversionRate
						,InvoiceCurrency
						,InvoiceDebitValue
						,InvoiceCreditValue
						,IntBAID						
						,IntBACode
						,InvoiceNumber
						,RunningNumber					
						,TitleTransfer
						,Destination
						,TransactionType
						,TransactionDescription										
						,Vehicle
						,CarrierMode			
						,ParentInvoiceDate
						,ParentInvoiceNumber	
						,ReceiptRefundFlag
						,BL	
						,PaymentTermCode
						,UnitPrice
						,UOM
						,AbsLocalValue
						,AbsInvoiceValue	
						,LineType			
						,ProfitCenter
						,CostCenter				
						,MaterialGroup			
						,DealType			
						,DealNumber		
						,DealDetailID
						,TransferID					
						,OrderID
						,OrderBatchID
						,Plant				
						,StorageLocation								
						,InterfaceStatus
						,InterfaceMessage
						,ApprovalUserID
						,ApprovalDate
						,CreationDate
						,MessageBusConfirmed)	
				Select	InvoiceLevel								-- InvoiceLevel
						,MessageQueueID								-- MessageQueueID
						,InterfaceSource							-- InterfaceSource
						,IsNull(InvoiceGLDate,'')					-- InvoiceGLDate
						,IsNull(InvoiceDate,'')						-- InvoiceDate
						,IsNull(Chart,'')							-- Chart
						,IsNull(LocalCurrency,'')					-- LocalCurrency				
						,LocalDebitValue							-- LocalDebitValue	
						,LocalCreditValue							-- LocalCreditValue
						,InterfaceInvoiceID							-- InterfaceInvoiceID
						,InvoiceID									-- InvoiceID
						,ExtBAID									-- ExtBAID
						,IsNull(ExtBACode,'')						-- ExtBACode
						,IsNull(PaymentMethod,'')					-- PaymentMethod				
						,AcctDtlID									-- AcctDtlID
						,IsNull(TransactionDate,'')					-- TransactionDate
						,IsNull(DueDate,'')							-- DueDate
						,Quantity									-- Quantity
						,PerUnitPrice								-- PerUnitPrice
						,IsNull(TaxCode,'')							-- TaxCode
						,IsNull(ProductCode,'')						-- ProductCode	
						,FXConversionRate							-- FXConversionRate
						,IsNull(InvoiceCurrency,'')					-- InvoiceCurrency
						,InvoiceDebitValue							-- InvoiceDebitValue
						,InvoiceCreditValue							-- InvoiceCreditValue
						,IntBAID									-- IntBAID						
						,IsNull(IntBACode,'')						-- IntBACode
						,IsNull(InvoiceNumber,'')					-- InvoiceNumber
						,RunningNumber								-- RunningNumber					
						,IsNull(TitleTransfer,'')					-- TitleTransfer
						,IsNull(Destination,'')						-- Destination
						,IsNull(TransactionType,'')					-- TransactionType
						,IsNull(TransactionDescription,'')			-- TransactionDescription										
						,IsNull(Vehicle,'')							-- Vehicle
						,IsNull(CarrierMode,'')						-- CarrierMode			
						,IsNull(ParentInvoiceDate,'')				-- ParentInvoiceDate
						,IsNull(ParentInvoiceNumber,'')				-- ParentInvoiceNumber	
						,IsNull(ReceiptRefundFlag,'')				-- ReceiptRefundFlag
						,IsNull(BL,'')								-- BL	
						,IsNull(PaymentTermCode,'')					-- PaymentTermCode
						,UnitPrice									-- UnitPrice
						,IsNull(UOM,'')								-- UOM
						,AbsLocalValue								-- AbsLocalValue
						,AbsInvoiceValue							-- AbsInvoiceValue	
						,IsNull(LineType,'')						-- LineType			
						,IsNull(ProfitCenter,'')					-- ProfitCenter
						,IsNull(CostCenter,'')						-- CostCenter			
						,IsNull(MaterialGroup,'')					-- MaterialGroup			
						,IsNull(DealType,'')						-- DealType			
						,IsNull(DealNumber,'')						-- DealNumber		
						,DealDetailID								-- DealDetailID
						,TransferID									-- TransferID					
						,OrderID									-- OrderID
						,OrderBatchID								-- OrderBatchID
						,IsNull(Plant,'')							-- Plant				
						,IsNull(StorageLocation,'')					-- StorageLocation							
						,InterfaceStatus							-- InterfaceStatus
						,RTrim(LTrim(IsNull(InterfaceMessage,'')))	-- InterfaceMessage
						,NULL										-- ApprovalUserID
						,NULL										-- ApprovalDate
						,getdate()									-- CreationDate
						,0											-- MessageBusConfirmed	 
				From	#AP_Interface	(NoLock)
				Order By MessageQueueID Asc, AbsInvoiceValue Desc
			
				---------------------------------------------------------------------------------------------------------------------
				-- Check for Errors on the Insert
				----------------------------------------------------------------------------------------------------------------------
				If	@@error <> 0 
					Begin
						Rollback Transaction InsertAP
					
						Update	CustomMessageQueue
						Set		RAProcessed			= 1
								,RAProcessedDate	= GetDate()
								,HasErrored			= 1
								,Error				= 'The AP Interface encountered an error inserting a record into the CustomInvoiceInterface table.' 
								,Reprocess			= 0
						From	#AP_Bulk
								Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
					End						

				----------------------------------------------------------------------------------------------------------------------------------
				-- Commit the Transaction
				----------------------------------------------------------------------------------------------------------------------------------
				Commit Transaction InsertAP

				Update	CustomMessageQueue
				Set		RAProcessed			= 1
						,RAProcessedDate	= GetDate()
						,HasErrored			= 0
						,Error				= NULL
						,Reprocess			= 0
				From	#AP_Bulk
						Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID


				If	Object_ID('TempDB..#AP_Interface') Is Not Null
					Drop Table #AP_Interface
				If	Object_ID('TempDB..#AP_Bulk') Is Not Null
					Drop Table #AP_Bulk

		end			
end													 														




if exists (select 1 from #GL_Bulk)
begin
	declare @i_ID int
	declare @i_Reprocess int
	select @i_ID = min(ID) From #GL_Bulk

	---------------------------------------------
	-- While you have one to process try looping
	---------------------------------------------
	While IsNull(@i_ID, 0) > 0
	begin
		select @i_Reprocess = Reprocess From #GL_Bulk Where ID = @i_ID
		execute Custom_Interface_GL_Outbound @i_ID, @i_Reprocess

		delete #GL_Bulk Where ID = @i_ID
		select @i_ID = min(ID) From #GL_Bulk
	end
end

---------------------------------------------
-- Check the process back in for next time
---------------------------------------------
if object_id('tempdb..#CMQtoProcess') is not null
	Drop Table #CMQtoProcess
if object_id('tempdb..#AR_Bulk') is not null
	Drop Table #AR_Bulk
if object_id('tempdb..#AP_Bulk') is not null
	Drop Table #AP_Bulk
if object_id('tempdb..#GL_Bulk') is not null
	Drop Table #GL_Bulk

exec dbo.sra_checkin_process 'CustomMessageQueueProcessor'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Message_Queue_BulkProcessor') Is NOT Null
BEGIN
	PRINT '<<< Granted Rights on PROC dbo.Custom_Message_Queue_BulkProcessor >>>'
	Grant Execute on dbo.Custom_Message_Queue_BulkProcessor to SYSUSER
	Grant Execute on dbo.Custom_Message_Queue_BulkProcessor to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Message_Queue_BulkProcessor >>>'
GO
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\Custom_Message_Queue_BulkProcessor.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\MTVDLInvStage.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=SP_MTV_DLInvStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_DLInvStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_DLInvStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_DLInvStage]		@i_AccntngPrdID int = null
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
-- exec MTV_DLInvStage 0
/*

select * from MTVDLInvTransactionsStaging
select * from MTVDLInvBalancesStaging
select * from MTVDLInvPricesStaging
*/

DECLARE	@vc_ErrorString				Varchar(1000),
		@vc_AcctMonth				Varchar(20),
		@i_VETradePeriodID			Int,
		@sdt_InsertDate				SmallDateTime

/*******************************************
Can't do much without our Period
********************************************/
--if @i_AccntngPrdID is null
--	select	@i_AccntngPrdID = min(AccountingPeriod.AccntngPrdID)
--	From	AccountingPeriod
--	Where	AccountingPeriod.AccntngPrdCmplte = 'N'

if IsNull(@i_AccntngPrdID, -1) = -1
begin
	set @vc_ErrorString = 'No accounting period was provided.';
	THROW 51000, @vc_ErrorString, 1
end

if @i_AccntngPrdID = 0 -- pick the current open period
	select @i_AccntngPrdID = min(AccountingPeriod.AccntngPrdID) from AccountingPeriod with (NoLock) where AccntngPrdCmplte = 'N'

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
else -- We don't have any Complete records, so we'll purge everything for this Accounting Period and start over
begin
	Delete	MTVDLInvInventoryTransactionsStaging
	Where	MTVDLInvInventoryTransactionsStaging.AccountingPeriod		= @vc_AcctMonth

	Delete	MTVDLInvTransactionsStaging
	Where	MTVDLInvTransactionsStaging.AccountingMonth					= @vc_AcctMonth

	Delete	MTVDLInvBalancesStaging
	Where	MTVDLInvBalancesStaging.AccountingMonth						= @vc_AcctMonth

	Delete	MTVDLInvPricesStaging
	Where	MTVDLInvPricesStaging.AccountingMonth						= @vc_AcctMonth
end

select	@i_VETradePeriodID = VETradePeriodID
From	PeriodTranslation
Where	AccntngPrdID = @i_AccntngPrdID

if @i_VETradePeriodID is null
	return

select @sdt_InsertDate = GetDate()

Create Table #InvBalance
			(
			AccountingMonth							Varchar(20),
			ISDID									Int,
			DlHdrID									Int,
			BalanceDlDtlID							Int,
			DealNumber								Varchar(20),
			DetailNumber							Int,
			BlendProduct							Char(3),
			ThirdPartyFlag							Varchar(255),
			EquityTerminalIndicator					Varchar(255),
			DealType								Varchar(80),
			StorageLocation							Varchar(255),
			ProductName								Varchar(150),
			RegradeProductName						Varchar(150),
			ProductGroup							Varchar(150),
			Subgroup								Varchar(150),
			MSAPPlantNumber							Varchar(255),
			MSAPMaterialNumber						Varchar(255),
			TradingBook								Varchar(120),
			ProfitCenter							Varchar(255),
			BegInvVolume							Decimal(19,6),
			EndingInvVolume							Decimal(19,6),
			UOM										Char(20),
			PerUnitValue							Decimal(19,6),
			EndingInvValue							Decimal(19,6),
			LocationCity							Varchar(255),
			LocationState							Varchar(255),
			LocationAddress							Varchar(255),
			LocationTCN								Varchar(255),
			LocationZip								Varchar(255),
			LocationType							Varchar(80),
			TerminalOperator						Varchar(255),
			PositionHolderName						Varchar(70),
			PositionHolderFEIN						Varchar(255),
			PositionHolderNameControl				Varchar(255),
			PositionHolderID						Varchar(255),
			LocationID								Int,
			FTAProductCode							Varchar(255),
			RATaxCommodity							Varchar(80),
			RegradeProductFTACode					Varchar(255),
			RegradeProductTaxCommodity				Varchar(80),
			TotalReceipts							Decimal(19,6),
			TotalDisbursement						Decimal(19,6),
			TotalBlend								Decimal(19,6),
			GainLoss								Decimal(19,6),
			BookAdjReason							Varchar(255),
			EndingPhysicalBalance					Decimal(19,6),
			GradeOfProduct							Varchar(255),
			StagingTableLoadDate					Smalldatetime,
			Status									Char(1)
			)

/*******************************************
Get the Inventory Transactions
********************************************/
Insert	MTVDLInvInventoryTransactionsStaging
		(
		AccountingPeriod,
		LogicalAccountingPeriod,
		Location,
		OriginLocale,
		DestinationLocation,
		Product,
		MaterialNumber,
		PlantCode,
		Quantity,
		UOM,
		MovementDate,
		MovementDocumentExternalNumber,
		ExternalBatch,
		DealNumber,
		DealTemplate,
		OurCompany,
		TheirCompany,
		SourceTable,
		ReasonCode,
		Direction,
		Reversal,
		OriginBaseProduct,
		OriginBaseLocation,
		OriginMaterialNumber,
		OriginPlantCode,
		SourceDealTemplate,
		StagingTableLoadDate,
		Status
		)
Select	ClosedAP.AccntngPrdYr + '-' + format(ClosedAP.AccntngPrdPrd, 'd2')				as	AccountingPeriod,
		LogicalAP.AccntngPrdYr + '-' + format(LogicalAP.AccntngPrdPrd, 'd2')			as	LogicalAccountingPeriod,
		TitleXfer.LcleAbbrvtn + IsNull(TitleXfer.LcleAbbrvtnExtension, '')				as	Location,
		Origin.LcleAbbrvtn + IsNull(Origin.LcleAbbrvtnExtension, '')					as	OriginLocale,
		Destination.LcleAbbrvtn + IsNull(Destination.LcleAbbrvtnExtension, '')			as	DestinationLocation,
		Product.PrdctAbbv																as	Product,
		GCMaterialNumber.GnrlCnfgMulti													as	MaterialNumber,
		GCPlantCode.GnrlCnfgMulti														as	PlantCode,
		InventoryReconcile.XhdrQty / 42.0
			* Case InventoryReconcile.XHdrTyp
				When 'R' Then -1.0
				When 'D' Then 1.0
				End
			* Case InventoryReconcile.InvntryRcncleRvrsd
				When 'Y' Then -1.0
				When 'N' Then 1.0
				End																		as	Quantity,
		'BBL'																			as	UOM,
		InventoryReconcile.MovementDate													as	MovementDate,
		MovementDocument.MvtDcmntExtrnlDcmntNbr											as	MovementDocumentExternalNumber,
		MovementHeader.ExternalBatch													as	ExternalBatch,
		DealHeader.DlHdrIntrnlNbr														as	DealNumber,
		DealHeaderTemplate.Description													as	DealTemplate,
		IntBA.Abbreviation																as	OurCompany,
		ExtBA.Abbreviation																as	TheirCompany,
		Case InventoryReconcile.InvntryRcncleSrceTble
			When 'X' Then 'Movement'
			When 'U' Then 'Missing'
			When 'R' Then 'Regrade'
			When 'V' Then 'ValueOnly'
		End																				as	SourceTable,
		AccountingReasonCode.Abbreviation												as	ReasonCode,
		InventoryReconcile.XHdrTyp														as	Direction,
		InventoryReconcile.InvntryRcncleRvrsd											as	Reversal,
		PrdctOrigin.PrdctAbbv															as	OriginBaseProduct,
		LcleOrigin.LcleAbbrvtn + IsNull(LcleOrigin.LcleAbbrvtnExtension, '')			as	OriginBaseLocation,
		GCOrigMaterialNumber.GnrlCnfgMulti												as	OriginMaterialNumber,
		GCOrigPlantCode.GnrlCnfgMulti													as	OriginPlantCode,
		DTRec.Description																as	SourceDealTemplate,
		@sdt_InsertDate																	as	StagingTableLoadDate,
		'N'																				as	Status



-- select XHDeliv.*, XHRec.*, IRRec.*, *
From	InventoryReconcile with (NoLock)
		Inner Join AccountingPeriod ClosedAP with (NoLock)
			on	ClosedAP.AccntngPrdID						= InventoryReconcile.InvntryRcncleClsdAccntngPrdID
		Inner Join AccountingPeriod LogicalAP with (NoLock)
			on	LogicalAP.AccntngPrdID						= InventoryReconcile.LogicalAccntngPrdID
        Left Outer Join TransactionHeader XHDeliv with (NoLock)
                on	InventoryReconcile.InvntryRcncleSrceID			= XHDeliv.XHdrID
                and	InventoryReconcile.InvntryRcncleSrceTble		= 'X'
                and	InventoryReconcile.XHdrTyp						= 'D' -- delivery into storage
        Left Outer Join TransactionHeader XHRec with (NoLock)
                on	XHRec.XHdrMvtDtlMvtHdrID						= XHDeliv.XHdrMvtDtlMvtHdrID
				and	XHRec.MvtHdrTyp									= XHDeliv.MvtHdrTyp
				and	XHRec.XHdrStat									= XHDeliv.XHdrStat
				and	XHRec.MvtHdrArchveID							= XHDeliv.MvtHdrArchveID
				and	XHRec.XHdrDte									= XHDeliv.XHdrDte
				and	XHRec.XHdrTyp									= 'R'
				and	exists	(
							Select	1
							From	PlannedTransfer PTRec with (NoLock)
									Inner Join PlannedTransfer PTDeliv with (NoLock)
										on	PTDeliv.PlnndTrnsfrPlnndStPlnndMvtID	= PTRec.PlnndTrnsfrPlnndStPlnndMvtID
										and	PTDeliv.PlnndTrnsfrID					= XHDeliv.XHdrPlnndTrnsfrID
										and	PTDeliv.PTReceiptDelivery				= 'D'
							Where	PTRec.PlnndTrnsfrID					= XHRec.XHdrPlnndTrnsfrID
							and		PTRec.PTReceiptDelivery				= 'R'
							And		PTRec.PlnndTrnsfrPlnndStSqnceNmbr	= PTDeliv.PlnndTrnsfrPlnndStSqnceNmbr
							)
        Left Outer Join InventoryReconcile IRRec with (NoLock)
                on	IRRec.InvntryRcncleSrceID						= XHRec.XHdrID
				and	IRRec.InvntryRcncleRvrsd						= Case When XHRec.XHdrStat = 'R' then 'Y' Else 'N' end
                and	IRRec.InvntryRcncleSrceTble						= 'X'
                and	IRRec.XHdrTyp									= 'R' -- receipt from inventory
        Left Outer Join InventoryChange ICOrigin with (NoLock)
                on	ICOrigin.SourceType								= 'I'
                and	ICOrigin.SourceID								= IRRec.InvntryRcncleID
        Left Outer Join Product PrdctOrigin with (NoLock)
                on	PrdctOrigin.PrdctID								= ICOrigin.BalancePrdctID
        Left Outer Join Locale LcleOrigin with (NoLock)
                on	LcleOrigin.LcleID								= ICOrigin.BalanceLcleID
		Left Outer Join DealDetail DDRec with (NoLock)
				on	XHRec.DealDetailID								= DDRec.DealDetailID
		Left Outer Join DealHeader DHRec with (NoLock)
			on	DHRec.DlHdrID										= DDRec.DlDtlDlHdrID
		Left Outer Join DealType DTRec with (NoLock)
			on	DTRec.DlTypID										= DHRec.DlHdrTyp
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID						= InventoryReconcile.DlHdrID
			and	DealDetail.DlDtlID							= InventoryReconcile.DlDtlID
		Inner Join DealDetailTemplate with (NoLock)
			on	DealDetailTemplate.DlDtlTmplteID			= DealDetail.DlDtlTmplteID
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID							= DealDetail.DlDtlDlHdrID
		Inner Join DealHeaderTemplate with (NoLock)
			on	DealHeaderTemplate.DlHdrTmplteID			= DealHeader.DlHdrTmplteID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID							= DealHeader.DlHdrTyp
		Left Outer Join TransactionHeader with (NoLock)
			on	InventoryReconcile.InvntryRcncleSrceID		= TransactionHeader.XHdrID
			and	InventoryReconcile.InvntryRcncleSrceTble	= 'X'
		Left Outer Join MovementDocument with (NoLock)
			on	MovementDocument.MvtDcmntID					= TransactionHeader.XHdrMvtDcmntID
		Left Outer Join MovementHeader with (NoLock)
			on	MovementHeader.MvtHdrID						= TransactionHeader.XHdrMvtDtlMvtHdrID
		Inner Join Product with (NoLock)
			on	Product.PrdctID								= InventoryReconcile.ChildprdctID
		Left Outer Join Locale Origin with (NoLock)
			on	Origin.LcleID								= MovementHeader.MvtHdrOrgnLcleID
		Left Outer Join Locale Destination with (NoLock)
			on	Destination.LcleID							= MovementHeader.MvtHdrDstntnLcleID
		Left Outer Join Locale TitleXfer with (NoLock)
			on	TitleXfer.LcleID							= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme				= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr				= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID				= InventoryReconcile.ChildprdctID
		Left Outer Join GeneralConfiguration GCPlantCode with (NoLock)
			on	GCPlantCode.GnrlCnfgTblNme					= 'Locale'
			and	GCPlantCode.GnrlCnfgQlfr					= 'SAPPlantCode'
			and	GCPlantCode.GnrlCnfgHdrID					= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCOrigMaterialNumber with (NoLock)
			on	GCOrigMaterialNumber.GnrlCnfgTblNme			= 'Product'
			and	GCOrigMaterialNumber.GnrlCnfgQlfr			= 'SAPMaterialCode'
			and	GCOrigMaterialNumber.GnrlCnfgHdrID			= ICOrigin.BalancePrdctID
		Left Outer Join GeneralConfiguration GCOrigPlantCode with (NoLock)
			on	GCOrigPlantCode.GnrlCnfgTblNme				= 'Locale'
			and	GCOrigPlantCode.GnrlCnfgQlfr				= 'SAPPlantCode'
			and	GCOrigPlantCode.GnrlCnfgHdrID				= ICOrigin.BalanceLcleID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID									= DealHeader.DlHdrIntrnlBAID
		Inner Join BusinessAssociate ExtBA with (NoLock)
			on	ExtBA.BAID									= DealHeader.DlHdrExtrnlBAID
		Left Outer Join AccountingReasonCode with (NoLock)
			on	AccountingReasonCode.Code					= InventoryReconcile.InvntryRcncleRsnCde
Where	InventoryReconcile.InvntryRcncleClsdAccntngPrdID	= @i_AccntngPrdID
And		DealType.Description not like '3rd%'
And		InventoryReconcile.InvntryRcncleSrceTble		<> 'U'
And		DealDetailTemplate.Description in (
											'Consumption Delivery', 'Production Receipt', 'Blending Delivery',
											'Blended Storage Delivery', 'Processing Delivery', 'Storage Delivery',
											'Terminaling Delivery', 'Pipeline Deal Segment', 'Truck Deal Segment', 'Railcar Deal Segment',
											'Location Railcar Segment', 'Location Truck Segment', 'Location Pipeline Segment'
											)
And		(InventoryReconcile.XHdrTyp		= 'D'
		or DealDetailTemplate.Description not in ('Pipeline Deal Segment', 'Truck Deal Segment', 'Railcar Deal Segment',
											'Location Railcar Segment', 'Location Truck Segment', 'Location Pipeline Segment')
		)
And		(		(IntBA.Abbreviation	<> 'MOTIVA-STL' or ExtBA.Abbreviation	<> 'MOTIVA-STL')
			or	DealDetailTemplate.Description not in ('Consumption Delivery', 'Production Receipt')
		)

/*******************************************
Get the Accounting Transactions
********************************************/
Insert	MTVDLInvTransactionsStaging 
		(	
			AccountingMonth,
			CompanyCode,
			MaterialNumber,
			ProductGroup,
			Subgroup,
			Product,
			Location,
			MaterialDesc,
			FTAProductCode,
			PlantNumber,
			RATaxCommodity,
			DealNumber,
			DetailNumber,
			Strategy,
			MaterialDocument,
			PostingDateInDoc,
			ReceiptQuantity,
			ThirdPartyFlag,
			PositionHolderName,
			PositionHolderFEIN,
			PositionHolderNameControl,
			PositionHolderID,
			Value,
			UOM,
			TransactionType,
			MovementDate,
			MovementType,
			VendorNumber,
			OriginLocale,
			OriginCity,
			OriginState,
			OriginTCN,
			DestinationLocale,
			DestinationCity,
			DestinationState,
			DestinationTCN,
			TitleTransferLocale,
			CostType,
			DealType,
			StagingTableLoadDate,
			Status
		)
Select	AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')								as AccountingMonth,
		GCCompanyCode.GnrlCnfgMulti														as CompanyCode,
		GCMaterialNumber.GnrlCnfgMulti													as MaterialNumber,
		RTRIM(Commodity.Name)															as ProductGroup,
		RTRIM(CommoditySubGroup.Name)													as Subgroup,
		Product.PrdctAbbv																as Product,
		Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')					as Location,
		GCMaterialNumber.GnrlCnfgMulti													as MaterialDesc,
		GCFTAProduct.GnrlCnfgMulti														as FTAProductCode,
		GCPlantNumber.GnrlCnfgMulti														as PlantNumber,
		RTRIM(TaxCommodity.Name)														as RATaxCommodity,

		DealHeader.DlHdrIntrnlNbr														as DealNumber,
		AccountDetail.AcctDtlDlDtlID													as DetailNumber,
		StrategyHeader.Name																as Strategy,

		MovementDocument.MvtDcmntExtrnlDcmntNbr											as MaterialDocument,
		MovementDocument.MvtDcmntDte													as PostingDateInDoc,
		AccountDetail.Volume															as ReceiptQuantity,

		Case When DealType.Description like '3rd%' Then 'Y' Else 'N' End				as ThirdPartyFlag,
		Case When DealType.Description like '3rd%'
				then BusinessAssociate.Abbreviation
				else IntBA.Abbreviation end												as PositionHolderName,
		GCPosHolderFEIN.GnrlCnfgMulti													as PositionHolderFEIN,
		GCPosHolderNmeCntrl.GnrlCnfgMulti												as PositionHolderNameControl,
		Case When DealType.Description like '3rd%'
				then BusinessAssociate.BAID
				else IntBA.BAID end														as PositionHolderID,

		AccountDetail.Value	* -1.0														as Value, --Defect 4023: multiply by -1.0
		UnitOfMeasure.UOMAbbv															as UOM,
		TransactionType.TrnsctnTypDesc													as TransactionType,
		AccountDetail.AcctDtlTrnsctnDte													as MovementDate,
		DLMoveType.DynLstBxAbbv															as MovementType,
		case when DealType.Description = 'Purchase Deal'
			then vVendor.VendorNumber else vVendor.SoldTo end							as VendorNumber,
		Origin.LcleAbbrvtn + IsNull(Origin.LcleAbbrvtnExtension, '')					as OriginLocale,
		GCOriginCity.GnrlCnfgMulti														as OriginCity,
		GCOriginState.GnrlCnfgMulti														as OriginState,
		GCOriginTCN.GnrlCnfgMulti														as OriginTCN,
		Destination.LcleAbbrvtn + IsNull(Destination.LcleAbbrvtnExtension, '')			as DestinationLocale,
		GCDestCity.GnrlCnfgMulti														as DestinationCity,
		GCDestState.GnrlCnfgMulti														as DestinationState,
		GCDestTCN.GnrlCnfgMulti															as DestinationTCN,

		TitleXfer.LcleAbbrvtn + IsNull(TitleXfer.LcleAbbrvtnExtension, '')				as TitleTransferLocale,
		EAD.CostType																	as CostType,
		RTRIM(DealType.Description)														as DealType,
		@sdt_InsertDate																	as StagingTableLoadDate,
		'N'																				as Status
-- select EAD.SourceTable, *
From	AccountDetail with (NoLock)
		Inner Join EstimatedAccountDetail EAD with (NoLock)
			on	EAD.AcctDtlID						= AccountDetail.AcctDtlID
			and	not exists (select 1 from EstimatedAccountDetail Sub with (NoLock) where sub.AcctDtlID = EAD.AcctDtlID and sub.EndDate > EAD.EndDate)
		Inner Join StrategyHeader
			on	StrategyHeader.StrtgyID				= AccountDetail.AcctDtlStrtgyID
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID		= AccountDetail.AcctDtlAccntngPrdID
		Inner Join Product with (NoLock)
			on	Product.PrdctID						= AccountDetail.ChildPrdctID
		Inner Join Locale with (NoLock)
			on	Locale.LcleID						= AccountDetail.AcctDtlLcleID
		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID					= Product.CmmdtyID
		Inner Join UnitOfMeasure with (NoLock)
			on	UnitOfMeasure.UOM					= 3 -- show everything in gallons
		Left Outer Join CommoditySubGroup with (NoLock)
			on	CommoditySubGroup.CmmdtySbGrpID		= Product.CmmdtySbGrpID
		Left Outer Join CommoditySubGroup TaxCommodity with (NoLock)
			on	TaxCommodity.CmmdtySbGrpID			= IsNull(Product.TaxCmmdtySbGrpID, -1)
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= AccountDetail.AcctDtlDlDtlDlHdrID
		Inner Join MovementHeader with (NoLock)
			on	MovementHeader.MvtHdrID				= AccountDetail.AcctDtlMvtHdrID
		Inner Join BusinessAssociate with (NoLock)
			on	BusinessAssociate.BAID				= DealHeader.DlHdrExtrnlBAID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID							= DealHeader.DlHdrIntrnlBAID
		Inner Join MovementDocument with (NoLock)
			on	MovementDocument.MvtDcmntID			= MovementHeader.MvtHdrMvtDcmntID
		Inner Join TransactionType with (NoLock)
			on	TransactionType.TrnsctnTypID		= AccountDetail.AcctDtlTrnsctnTypID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID					= DealHeader.DlHdrTyp
		Left Outer Join Locale Origin with (NoLock)
			on	Origin.LcleID						= MovementHeader.MvtHdrOrgnLcleID
		Left Outer Join Locale Destination with (NoLock)
			on	Destination.LcleID					= MovementHeader.MvtHdrDstntnLcleID
		Left Outer Join Locale TitleXfer with (NoLock)
			on	TitleXfer.LcleID					= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCCompanyCode with (NoLock)
			on	GCCompanyCode.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCCompanyCode.GnrlCnfgQlfr			= 'SAPCompanyCode'
			and	GCCompanyCode.GnrlCnfgHdrID			= DealHeader.DlHdrExtrnlBAID
		Left Outer Join v_MTV_DealDetailSoldToShipTo vVendor with (NoLock)
			on	vVendor.DlDtlDlHdrID				= AccountDetail.AcctDtlDlDtlDlHdrID
			and	vVendor.DlDtlID						= AccountDetail.AcctDtlDlDtlID
			and	getdate()							between vVendor.EffectiveFromDate and vVendor.EffectiveToDate
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr		= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID		= Product.PrdctID
		Left Outer Join GeneralConfiguration GCFTAProduct with (NoLock)
			on	GCFTAProduct.GnrlCnfgTblNme			= 'Product'
			and	GCFTAProduct.GnrlCnfgQlfr			= 'FTAProductCode'
			and	GCFTAProduct.GnrlCnfgHdrID			= Product.PrdctID
		Left Outer Join GeneralConfiguration GCPlantNumber with (NoLock)
			on	GCPlantNumber.GnrlCnfgTblNme		= 'Locale'
			and	GCPlantNumber.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantNumber.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCEquityTerminal with (NoLock)
			on	GCEquityTerminal.GnrlCnfgTblNme		= 'Locale'
			and	GCEquityTerminal.GnrlCnfgQlfr		= 'EquityTerminal'
			and	GCEquityTerminal.GnrlCnfgHdrID		= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginCity with (NoLock)
			on	GCOriginCity.GnrlCnfgTblNme			= 'Locale'
			and	GCOriginCity.GnrlCnfgQlfr			= 'CityName'
			and	GCOriginCity.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginState with (NoLock)
			on	GCOriginState.GnrlCnfgTblNme		= 'Locale'
			and	GCOriginState.GnrlCnfgQlfr			= 'StateAbbreviation'
			and	GCOriginState.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginTCN with (NoLock)
			on	GCOriginTCN.GnrlCnfgTblNme			= 'Locale'
			and	GCOriginTCN.GnrlCnfgQlfr			= 'TCN'
			and	GCOriginTCN.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCDestCity with (NoLock)
			on	GCDestCity.GnrlCnfgTblNme			= 'Locale'
			and	GCDestCity.GnrlCnfgQlfr				= 'CityName'
			and	GCDestCity.GnrlCnfgHdrID			= Destination.LcleID
		Left Outer Join GeneralConfiguration GCDestState with (NoLock)
			on	GCDestState.GnrlCnfgTblNme			= 'Locale'
			and	GCDestState.GnrlCnfgQlfr			= 'StateAbbreviation'
			and	GCDestState.GnrlCnfgHdrID			= Destination.LcleID
		Left Outer Join GeneralConfiguration GCDestTCN with (NoLock)
			on	GCDestTCN.GnrlCnfgTblNme			= 'Locale'
			and	GCDestTCN.GnrlCnfgQlfr				= 'TCN'
			and	GCDestTCN.GnrlCnfgHdrID				= Destination.LcleID
		Left Outer Join DynamicListBox DLMoveType with (NoLock)
			on	DLMoveType.DynLstBxQlfr				= 'MovementType'
			and	DLMoveType.DynLstBxStts				= 'A'
			and	DLMoveType.DynLstBxTyp				= MovementHeader.MvtHdrTyp
		Left Outer Join GeneralConfiguration GCPosHolderNmeCntrl with (NoLock)
			on	GCPosHolderNmeCntrl.GnrlCnfgTblNme	= 'BusinessAssociate'
			and	GCPosHolderNmeCntrl.GnrlCnfgQlfr	= 'SCAC'
			and	GCPosHolderNmeCntrl.GnrlCnfgHdrID	= Case When DealType.Description like '3rd%'
														then BusinessAssociate.BAID
														else IntBA.BAID end
		Left Outer Join GeneralConfiguration GCPosHolderFEIN with (NoLock)
			on	GCPosHolderFEIN.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCPosHolderFEIN.GnrlCnfgQlfr		= 'FederalTaxID'
			and	GCPosHolderFEIN.GnrlCnfgHdrID		= Case When DealType.Description like '3rd%'
														then BusinessAssociate.BAID
														else IntBA.BAID end
Where	AccountDetail.AcctDtlAccntngPrdID = @i_AccntngPrdID
and		exists	(
				Select	1
				From	TransactionTypeGroup with (NoLock)
						Inner Join TransactionGroup with (NoLock)
							on	TransactionTypeGroup.XTpeGrpXGrpID		= TransactionGroup.XGrpID
				Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID		= TransactionType.TrnsctnTypID
				and		TransactionGroup.XGrpName						= 'PurchaseTransactions'
				and		TransactionGroup.XGrpQlfr						= 'DataLake'
				)


/*******************************************
Get the Inventory Prices
********************************************/
Insert	MTVDLInvPricesStaging
		(
		AccountingMonth,
		Product,
		MaterialCode,
		Location,
		PlantCode,
		ProductGroup,
		PriceService,
		Subgroup,
		Currency,
		QuoteFromDate,
		QuoteToDate,
		MinEndOfDay,
		MaxEndOfDay,
		DeliveryPeriod,
		Price,
		UOM,
		PricePerGallon,
		StagingTableLoadDate,
		Status
		)
Select	AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')												as AccountingMonth,
		Product.PrdctAbbv																				as Product,
		GCMaterialCode.GnrlCnfgMulti																	as MaterialCode,
		Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')									as Location,
		GCPlantCode.GnrlCnfgMulti																		as PlantCode,
		RTRIM(Commodity.Name)																			as ProductGroup,
		RawPriceHeader.RPHdrAbbv																		as PriceService,
		RTRIM(CommoditySubGroup.Name)																	as Subgroup,
		Currency.CrrncySmbl																				as Currency,
		RiskCurveValue.StartDate																		as QuoteFromDate,
		RiskCurveValue.EndDate																			as QuoteToDate,
		MinSS.EndOfDay																					as MinEndOfDay,
		MaxSS.EndOfDay																					as MaxEndOfDay,
		DatePart(Month, VETradePeriod.StartDate) * 10000 + DatePart(Year, VETradePeriod.StartDate)		as DeliveryPeriod,
		RiskCurveValue.BaseValue																		as Price,
		UnitOfMeasure.UOMAbbv																			as UOM,
		RiskCurveValue.BaseValue / ( v_UOMConversion.ConversionFactor / 
									Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
											When	'WV'
											Then	Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											When	'VW'
											Then	1.0 / Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											When	'EV'
											Then	Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'VE'
											Then	1.0 / Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'WE'
											Then	convert(float,RiskCurveValue.SpecificGravity) / Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'EW'
											Then	convert(float,RiskCurveValue.Energy) / Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											Else	1.0
									End)																as PricePerGallon,

		@sdt_InsertDate																					as StagingTableLoadDate,
		'N'																								as Status
-- select * 
From	RiskCurve with (NoLock)
		Inner Join RiskCurveValue with (NoLock)
			on	RiskCurveValue.RiskCurveID				= RiskCurve.RiskCurveID
		Inner Join RawPriceHeader with (NoLock)
			on	RawPriceHeader.RPHdrID					= RiskCurve.RPHdrID
		Inner Join PeriodTranslation with (NoLock)
			on	PeriodTranslation.VETradePeriodID		= RiskCurve.VETradePeriodID
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID			= PeriodTranslation.AccntngPrdID
		Inner Join VETradePeriod with (NoLock)
			on	VETradePeriod.VETradePeriodID			= RiskCurve.VETradePeriodID
		Inner Join Product with (NoLock)
			on	Product.PrdctID							= RiskCurve.ChmclID
		Inner Join Locale with (NoLock)
			on	Locale.LcleID							= RiskCurve.LcleID

		Left Outer Join GeneralConfiguration GCMaterialCode with (NoLock)
			on	GCMaterialCode.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialCode.GnrlCnfgQlfr			= 'SAPMaterialCode'
			and	GCMaterialCode.GnrlCnfgHdrID		= Product.PrdctID
		Left Outer Join GeneralConfiguration GCPlantCode with (NoLock)
			on	GCPlantCode.GnrlCnfgTblNme			= 'Locale'
			and	GCPlantCode.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantCode.GnrlCnfgHdrID			= Locale.LcleID

		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID						= Product.CmmdtyID
		Left Outer Join CommoditySubGroup with (NoLock)
			on	CommoditySubGroup.CmmdtySbGrpID			= Product.CmmdtySbGrpID
		Inner Join Currency with (NoLock)
			on	Currency.CrrncyID						= RiskCurve.CrrncyID
		Inner Join UnitOfMeasure with (NoLock)
			on	UnitOfMeasure.UOM						= RiskCurve.UOMID
		Left Outer Join v_UOMConversion	(Nolock)
			On	v_UOMConversion. FromUOM				= RiskCurve.UOMID
			And	v_UOMConversion. ToUOM					= 3
		Inner Join Snapshot MinSS (NoLock)
			on	MinSS.InstanceDateTime					= RiskCurveValue.StartDate
		Inner Join (
					Select	IsNull(Next.EndOfDay, Latest.EndOfDay) as EndOfDay,
							IsNull(DateAdd(minute, -1, Next.InstanceDateTime), '6/6/2079 23:59') EndingDateTime
					From	Snapshot (NoLock)
							Inner Join Snapshot Latest (NoLock)
								on	not exists (
												Select	1
												From	Snapshot sub (NoLock)
												Where	Sub.IsValid = 'Y'
												And		Sub.P_EODSnpshtID	> Latest.P_EODSnpshtID
												)
							Left Outer Join Snapshot Next (NoLock)
								on	Next.P_EODSnpshtID	> Snapshot.P_EODSnpshtID
								and	Next.IsValid		= 'Y'
								and not exists (
												Select	1
												From	Snapshot Sub (NoLock)
												Where	Sub.IsValid = 'Y'
												And		Sub.P_EODSnpshtID		> Snapshot.P_EODSnpshtID
												And		Sub.P_EODSnpshtID		< Next.P_EODSnpshtID
												)
					Where	Snapshot.IsValid	= 'Y'
					) MaxSS
			on	MaxSS.EndingDateTime					= RiskCurveValue.EndDate
Where	RiskCurve.VETradePeriodID		= @i_VETradePeriodID
And		RawPriceHeader.RPHdrAbbv		in ('Market', 'Transfer Price')
And		(
		RiskCurve.IsMarketCurve			= 1
		or	exists	(
					Select	1
					From	GeneralConfiguration with (NoLock)
					Where	GnrlCnfgTblNme	= 'RawPriceLocale'
					And		GnrlCnfgQlfr	= 'TransferPriceType'
					And		GnrlCnfgMulti	in ('YT02', 'YT04', 'YT06')
					And		GnrlCnfgHdrID	= RiskCurve.RwPrceLcleID
					)
		)



/*******************************************
Now get the Inventory Balances
********************************************/
Insert #InvBalance
			(
			AccountingMonth,
			DealNumber,
			DlHdrID,
			DetailNumber,
			BalanceDlDtlID,
			-- Location Stuff
			StorageLocation,
			LocationCity,
			LocationState,
			LocationAddress,
			LocationTCN,
			LocationZip,
			LocationType,
			LocationID,
			EquityTerminalIndicator,
			-- Base Product
			ProductName,
			ProductGroup,
			Subgroup,
			RATaxCommodity,

			FTAProductCode,
			GradeOfProduct,
			MSAPPlantNumber,
			MSAPMaterialNumber,

			-- Real Product
			BlendProduct,
			RegradeProductName,
			RegradeProductFTACode,
			RegradeProductTaxCommodity,
			
			TerminalOperator,
			PositionHolderName,
			PositionHolderFEIN,
			PositionHolderNameControl,
			PositionHolderID,

			ThirdPartyFlag,
			DealType,
			UOM,
			StagingTableLoadDate,
			Status
			)
Select		DISTINCT
			@vc_AcctMonth																	as AccountingMonth,
			-- Deal
			DealHeader.DlHdrIntrnlNbr														as DealNumber,
			DDRR.DlDtlDlHdrID																as DlHdrID,
			DDRR.BaseDlDtlID																as DetailNumber,
			DDRR.BaseDlDtlID																as BalanceDlDtlID,
			-- Location
			Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')					as StorageLocation,
			GCLocationCity.GnrlCnfgMulti													as LocationCity,
			GCLocationState.GnrlCnfgMulti													as LocationState,
			GCLocationAddy.GnrlCnfgMulti													as LocationAddress,
			GCTCNNumber.GnrlCnfgMulti														as LocationTCN,
			GCLocationZip.GnrlCnfgMulti														as LocationZip,
			LocaleType.LcleTpeDscrptn														as LocationType,
			Locale.LcleID																	as LocationID,
			Case when GCEquityTerminal.GnrlCnfgMulti = 'Y' Then 'Y' Else 'N' End			as EquityTerminalIndicator,
			-- Base Product
			Chemical.PrdctAbbv																as ProductName,
			RTRIM(Commodity.Name)															as ProductGroup,
			RTRIM(Subgroup.Name)															as Subgroup,
			RTRIM(TaxCommodity.Name)														as RATaxCommodity,
			GCFTABase.GnrlCnfgMulti															as FTAProductCode,
			GCBasePrdctGrade.GnrlCnfgMulti													as GradeOfProduct,
			GCPlantNumber.GnrlCnfgMulti														as MSAPPlantNumber,
			GCMaterialNumber.GnrlCnfgMulti													as MSAPMaterialNumber,
			-- Real Product
			Case When BaseChmclID <> ChmclID Then 'Y' Else 'N' End								as BlendProduct,
			Case When BaseChmclID <> ChmclID Then Chemical.PrdctNme Else Null End				as RegradeProductName,
			Case When BaseChmclID <> ChmclID Then GCFTAChemical.GnrlCnfgMulti Else Null End		as RegradeProductFTACode,
			Case When BaseChmclID <> ChmclID Then RTRIM(ChemTaxCommodity.Name) Else Null End	as RegradeProductTaxCommodity,
			-- BA Stuff
			TermOperator.Abbreviation														as TerminalOperator,
			Case When DealType.Description like '3rd%'
				then BusinessAssociate.Abbreviation
				else IntBA.Abbreviation end													as PositionHolderName,
			GCPosHolderFEIN.GnrlCnfgMulti													as PositionHolderFEIN,
			GCPosHolderNmeCntrl.GnrlCnfgMulti												as PositionHolderNameControl,
			Case When DealType.Description like '3rd%'
				then BusinessAssociate.BAID
				else IntBA.BAID end															as PositionHolderID,
			Case When DealType.Description like '3rd%' Then 'Y' Else 'N' End				as ThirdPartyFlag,
			RTRIM(DealType.Description)														as DealType,

			'GAL'																			as UOM,
			GetDate()																		as StagingTableLoadDate,
			'N'																				as Status
From	DealDetailRegradeRecipe DDRR with (NoLock)
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= DDRR.DlDtlDlHdrID
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID				= DDRR.DlDtlDlHdrID
			and	DealDetail.DlDtlID					= DDRR.BaseDlDtlID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID					= DealHeader.DlHdrTyp

		-- Location Stuff
		Inner Join Locale with (NoLock)
			on	Locale.LcleID						= DealDetail.DlDtlLcleID
		Inner Join LocaleType with (NoLock)
			on	LocaleType.LcleTpeID				= Locale.LcleTpeID
		Left Outer Join GeneralConfiguration GCLocationCity with (NoLock)
			on	GCLocationCity.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationCity.GnrlCnfgQlfr			= 'CityName'
			and	GCLocationCity.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationState with (NoLock)
			on	GCLocationState.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationState.GnrlCnfgQlfr		= 'StateAbbreviation'
			and	GCLocationState.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationAddy with (NoLock)
			on	GCLocationAddy.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationAddy.GnrlCnfgQlfr			= 'AddrLine1'
			and	GCLocationAddy.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationZip with (NoLock)
			on	GCLocationZip.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationZip.GnrlCnfgQlfr			= 'PostalCode'
			and	GCLocationZip.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCTCNNumber with (NoLock)
			on	GCTCNNumber.GnrlCnfgTblNme			= 'Locale'
			and	GCTCNNumber.GnrlCnfgQlfr			= 'TCN'
			and	GCTCNNumber.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationOperator with (NoLock)
			on	GCLocationOperator.GnrlCnfgTblNme	= 'Locale'
			and	GCLocationOperator.GnrlCnfgQlfr		= 'TerminalOperator'
			and	GCLocationOperator.GnrlCnfgHdrID	= Locale.LcleID

		-- Chemical
		Left Outer Join Product Chemical with (NoLock)
			on	Chemical.PrdctID					= DDRR.ChmclID
		Left Outer Join GeneralConfiguration GCFTAChemical with (NoLock)
			on	GCFTAChemical.GnrlCnfgTblNme		= 'Product'
			and	GCFTAChemical.GnrlCnfgQlfr			= 'FTAProductCode'
			and	GCFTAChemical.GnrlCnfgHdrID			= DDRR.ChmclID
		Left Outer Join CommoditySubGroup ChemTaxCommodity with (NoLock)
			on	ChemTaxCommodity.CmmdtySbGrpID		= IsNull(Chemical.TaxCmmdtySbGrpID, -1)
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr		= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID		= Chemical.PrdctID

		-- Base Chemical
		Inner Join Product BaseChemical with (NoLock)
			on	BaseChemical.PrdctID				= DDRR.BaseChmclID
		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID					= BaseChemical.CmmdtyID
		Left Outer Join CommoditySubGroup Subgroup with (NoLock)
			on	Subgroup.CmmdtySbGrpID				= IsNull(BaseChemical.CmmdtySbGrpID, -1)
		Left Outer Join CommoditySubGroup TaxCommodity with (NoLock)
			on	TaxCommodity.CmmdtySbGrpID			= IsNull(BaseChemical.TaxCmmdtySbGrpID, -1)
		Left Outer Join GeneralConfiguration GCFTABase with (NoLock)
			on	GCFTABase.GnrlCnfgTblNme			= 'Product'
			and	GCFTABase.GnrlCnfgQlfr				= 'FTAProductCode'
			and	GCFTABase.GnrlCnfgHdrID				= DDRR.BaseChmclID
		Left Outer Join GeneralConfiguration GCBasePrdctGrade with (NoLock)
			on	GCBasePrdctGrade.GnrlCnfgTblNme		= 'Product'
			and	GCBasePrdctGrade.GnrlCnfgQlfr		= 'ProductGrade'
			and	GCBasePrdctGrade.GnrlCnfgHdrID		= DDRR.BaseChmclID


		-- BA stuff
		Left Outer Join BusinessAssociate TermOperator with (NoLock)
			on	convert(varchar, TermOperator.BAID)	= GCLocationOperator.GnrlCnfgMulti
		Inner Join BusinessAssociate with (NoLock)
			on	BusinessAssociate.BAID				= DealHeader.DlHdrExtrnlBAID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID							= DealHeader.DlHdrIntrnlBAID
		Left Outer Join GeneralConfiguration GCEquityTerminal with (NoLock)
			on	GCEquityTerminal.GnrlCnfgTblNme		= 'Locale'
			and	GCEquityTerminal.GnrlCnfgQlfr		= 'EquityTerminal'
			and	GCEquityTerminal.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCPlantNumber with (NoLock)
			on	GCPlantNumber.GnrlCnfgTblNme		= 'Locale'
			and	GCPlantNumber.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantNumber.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCPosHolderFEIN with (NoLock)
			on	GCPosHolderFEIN.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCPosHolderFEIN.GnrlCnfgQlfr		= 'FederalTaxID'
			and	GCPosHolderFEIN.GnrlCnfgHdrID		= Case When DealType.Description like '3rd%' then BusinessAssociate.BAID else IntBA.BAID end
		Left Outer Join GeneralConfiguration GCPosHolderNmeCntrl with (NoLock)
			on	GCPosHolderNmeCntrl.GnrlCnfgTblNme	= 'BusinessAssociate'
			and	GCPosHolderNmeCntrl.GnrlCnfgQlfr	= 'SCAC'
			and	GCPosHolderNmeCntrl.GnrlCnfgHdrID	= Case When DealType.Description like '3rd%' then BusinessAssociate.BAID else IntBA.BAID end

Where	Exists	(
				Select	1
				From	AccountingPeriod (NoLock)
						Inner Join Calendar (NoLock)
							on	Calendar.Name			= 'US Bank Calendar'
						Inner Join CalendarDate (NoLock)
							on	Calendar.CalendarID		= CalendarDate.CalendarID
							and	CalendarDate.Date		between DDRR.FromDate and DDRR.ToDate
				Where	AccntngPrdID = @i_AccntngPrdID
				)



Update	#InvBalance
Set		ISDID						= ISD.InvntrySbldgrDtlID,
		TradingBook					= StrategyHeader.Name,
		ProfitCenter				= GCProfitCtr.GnrlCnfgMulti,
		BegInvVolume				= IsNull(ISDBegin.BeginningVolume, 0.0),
		EndingInvVolume				= ISD.BeginningVolume,
		PerUnitValue				= Case	when ISD.BeginningVolume <> 0
											then ISD.BeginningValue / ISD.BeginningVolume
											else 0.0 end,
		EndingInvValue				= ISD.BeginningValue,
		EndingPhysicalBalance		= EndInv.EndngInvntryExtrnlBlnce
-- select *
From	#InvBalance
		Inner Join InventorySubledgerDetail ISD with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= #InvBalance.DlHdrID
			and	ISD.DlDtlChmclDlDtlID				= #InvBalance.BalanceDlDtlID
		Inner Join StrategyHeader with (NoLock)
			on	StrategyHeader.StrtgyID				= ISD.StrtgyID
		Left Outer Join GeneralConfiguration GCProfitCtr with (NoLock)
			on	GCProfitCtr.GnrlCnfgTblNme			= 'StrategyHeader'
			and	GCProfitCtr.GnrlCnfgQlfr			= 'ProfitCenter'
			and	GCProfitCtr.GnrlCnfgHdrID			= StrategyHeader.StrtgyID
		Left Outer Join InventorySubledgerDetail ISDBegin with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= ISDBegin.DlDtlChmclDlDtlDlHdrID
			and	ISD.DlDtlChmclDlDtlID				= ISDBegin.DlDtlChmclDlDtlID
			and	ISD.DlDtlChmclChmclPrntPrdctID		= ISDBegin.DlDtlChmclChmclPrntPrdctID
			and	ISD.DlDtlChmclChmclChldPrdctID		= ISDBegin.DlDtlChmclChmclChldPrdctID
			and	ISD.StrtgyID						= ISDBegin.StrtgyID
			and	ISD.AccntngPrdID - 1				= ISDBegin.AccntngPrdID
		Left Outer Join ReconcileGroupDetail RGDetail with (NoLock)
			on	RGDetail.RcncleGrpDtlDlHdrID		= ISD.DlDtlChmclDlDtlDlHdrID
			and	RGDetail.DlDtlID					= ISD.DlDtlChmclDlDtlID
			and	RGDetail.PrdctID					= ISD.DlDtlChmclChmclChldPrdctID
		Left Outer Join EndingInventory EndInv with (NoLock)
			on	EndInv.EndngInvntryRcncleGrpID		= RGDetail.RcncleGrpDtlRcncleGrpID
			and	EndInv.AccntngPrdID					= ISD.AccntngPrdID
Where	ISD.AccntngPrdID	= @i_AccntngPrdID +1



Update	#InvBalance
Set		TotalReceipts				= ICSub.Build,
		TotalDisbursement			= ICSub.Draw,
		GainLoss					= ICSub.GainLoss,
		TotalBlend					= ICSub.BlendQty,
		BookAdjReason				= ICSub.Description
From	#InvBalance
		Inner Join (
					Select	DealHeader.DlHdrIntrnlNbr										as DealNumber,
							InventoryChange.BalanceDldtlID									as BalanceDlDtlID,
							ICChemical.PrdctNme												as Chem,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')				as AccountingMonth,
							Sum(Case	When TransactionHeader.XHdrTyp = 'R'
										Then VolumeQty * -1.0 Else 0 End)					as Draw,
							Sum(Case	When TransactionHeader.XHdrTyp = 'D'
										Then VolumeQty Else 0 End)							as Build,
							Sum(Case When IsAdjustment = 'Y'
									Then VolumeQty Else 0 End)								as GainLoss,
							Sum(Case When BalanceChemid <> ChemID
									Then VolumeQty Else 0 End)								as BlendQty,
							AccountingReasonCode.Description								as Description

					From	InventoryChange with (NoLock)
							Inner Join AccountingPeriod with (NoLock)
								on	AccountingPeriod.AccntngPrdID					= InventoryChange.BookAccntngPrdID
							Inner Join DealHeader with (NoLock)
								on	DealHeader.DlHdrID								= InventoryChange.DlHdrID
							Inner Join Product ICChemical with (NoLock)
								on	ICChemical.PrdctID								= InventoryChange.ChemID
							Inner Join InventoryReconcile with (NoLock)
								on	InventoryReconcile.InvntryRcncleID				= InventoryChange.SourceID
							Inner Join TransactionHeader with (NoLock)
								on	TransactionHeader.XHdrID						= InventoryReconcile.InvntryRcncleSrceID
								and	InventoryReconcile.InvntryRcncleSrceTble		= 'X'
							Left Outer Join AccountingReasonCode with (NoLock)
								on	AccountingReasonCode.Code						= InventoryReconcile.InvntryRcncleRsnCde
					Where	InventoryChange.SourceType			= 'I'
					And		InventoryChange.QuantityType		= 'M'
					And		IsNull(AccountingReasonCode.Description, '')	<> 'Beg Balance'

					Group By DealHeader.DlHdrIntrnlNbr,
							InventoryChange.BalanceDldtlID,
							ICChemical.PrdctNme,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2'),
							AccountingReasonCode.Description			) ICSub
			on	ICSub.DealNumber			= #InvBalance.DealNumber
			and	ICSub.BalanceDlDtlID		= #InvBalance.BalanceDlDtlID
			and	ICSub.Chem					= IsNull(#InvBalance.RegradeProductName, #InvBalance.ProductName)
			and	ICSub.AccountingMonth		= #InvBalance.AccountingMonth


/*******************************************
Now, insert them into the real staging tables
********************************************/
Insert MTVDLInvBalancesStaging
		(
		AccountingMonth,
		DealNumber,
		DetailNumber,
		BlendProduct,
		ThirdPartyFlag,
		EquityTerminalIndicator,
		DealType,
		StorageLocation,
		ProductName,
		RegradeProductName,
		ProductGroup,
		Subgroup,
		MSAPPlantNumber,
		MSAPMaterialNumber,
		TradingBook,
		ProfitCenter,
		BegInvVolume,
		EndingInvVolume,
		UOM,
		PerUnitValue,
		EndingInvValue,
		LocationCity,
		LocationState,
		LocationAddress,
		LocationTCN,
		LocationZip,
		LocationType,
		TerminalOperator,
		PositionHolderName,
		PositionHolderFEIN,
		PositionHolderNameControl,
		PositionHolderID,
		LocationID,
		FTAProductCode,
		RATaxCommodity,
		RegradeProductFTACode,
		RegradeProductTaxCommodity,
		TotalReceipts,
		TotalDisbursement,
		TotalBlend,
		GainLoss,
		BookAdjReason,
		EndingPhysicalBalance,
		GradeOfProduct,
		StagingTableLoadDate,
		Status
		)
Select	AccountingMonth,
		DealNumber,
		DetailNumber,
		BlendProduct,
		ThirdPartyFlag,
		EquityTerminalIndicator,
		DealType,
		StorageLocation,
		ProductName,
		RegradeProductName,
		ProductGroup,
		Subgroup,
		MSAPPlantNumber,
		MSAPMaterialNumber,
		TradingBook,
		ProfitCenter,
		BegInvVolume,
		EndingInvVolume,
		UOM,
		PerUnitValue,
		EndingInvValue,
		LocationCity,
		LocationState,
		LocationAddress,
		LocationTCN,
		LocationZip,
		LocationType,
		TerminalOperator,
		PositionHolderName,
		PositionHolderFEIN,
		PositionHolderNameControl,
		PositionHolderID,
		LocationID,
		FTAProductCode,
		RATaxCommodity,
		RegradeProductFTACode,
		RegradeProductTaxCommodity,
		TotalReceipts,
		TotalDisbursement,
		TotalBlend,
		GainLoss,
		BookAdjReason,
		EndingPhysicalBalance,
		GradeOfProduct,
		StagingTableLoadDate,
		Status
From	#InvBalance

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NOT NULL
    BEGIN
		EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_DLInvStage.sql'
		PRINT '<<< ALTERED StoredProcedure MTV_DLInvStage >>>'
	END
ELSE
	BEGIN
		PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_DLInvStage >>>'
	END
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\MTVDLInvStage.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\MTV_CalcMvtQtySum.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
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
		Inner Join MovementHeaderType MoveTyp (NoLock)
			on	MoveTyp.MvtHdrTyp				= MovementHeader.MvtHdrTyp
Where	MovementHeader.MvtHdrStat				= ''A''
and		MovementHeader.MvtHdrDte				>= DateAdd(dd, day(dateadd(d, datediff(d, 0, DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')), 0)) * -1 + 1, dateadd(d, datediff(d, 0, DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')), 0))
and		MovementHeader.MvtHdrDte				<= DateAdd(minute, -1, DateAdd(mm, 1, DateAdd(dd, day(dateadd(d, datediff(d, 0, '''+Convert(varchar, @sdt_AppDate)+'''), 0)) * -1 + 1, dateadd(d, datediff(d, 0, '''+Convert(varchar, @sdt_AppDate)+'''), 0))))

-- And		DatePart(Year, MovementHeader.MvtHdrDte)	>= DateAdd(month, -1 * '+Convert(Varchar, @i_MonthsBack)+', '''+Convert(varchar, @sdt_AppDate)+''')

And		'',''+DLBMove.DynLstBxAbbv+'','' not like ''%,''+ rtrim(ltrim(MoveTyp.Name)) +'',%''

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
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\MTV_CalcMvtQtySum.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\MTV_InvoicePrevalidation.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
set quoted_identifier off 
go
set ansi_nulls on
go

if object_id('dbo.MTV_InvoicePrevalidation') is not null
	begin
		drop proc dbo.MTV_InvoicePrevalidation
		print '~~~ Dropped procedure MTV_InvoicePrevalidation ~~~'
	end
go

create procedure [dbo].[MTV_InvoicePrevalidation]
(	
	@pvc_RunMthd		varchar(20)
	,@pi_TaxLmt			int				= 0
	,@pi_SatLmt			int				= 0
	,@pi_MovXtrLmt		int				= 0
	,@pi_InvDbgLmt		int				= 0
	,@pc_UseCrntPrd		char(1)			= 'Y'
	,@pdt_DteFrm		smalldatetime	= '01/01/2017'
	,@pdt_DteTo			smalldatetime	= '01/01/2017'
	,@pi_IntrnlBAID		int				= 22
	,@pc_Debug			char(1)			= 'N'
)

/*
Author:		Chris Nettles
Created:	09/08/2017
Purpose:	Procedure is used to determine if the counts from 3 or 4 different reports have breached a specific
			threshold.  If they breach the threshholds the procedure will cause the remaining items in the process
			group to fail
Debug:		exec [MTV_InvoicePrevalidation] 'InvoicePrint', 0,0,0,0, 'Y', '9/1/2017', '9/30/2017', 22, 'Y'	--Debugger report
			exec [MTV_InvoicePrevalidation] 'InvoiceQueue', 0,0,0,0, 'Y', '9/1/2017', '9/30/2017', 22, 'Y'	--Transaction reports
Params:		@pvc_RunMthd:	Should be either 'InvoiceQueue' or 'InvoicePrint'
			@pi_TaxLmt:		Threshold set for results of the Search Tax Transactions Report
			@pi_SatLmt:		Threshold set for results of the Search Accounting Transactions Report
			@pi_MovXtrLmt:	Threshold set for results of the Search Movement Transactions Report
			@pi_InvDbgLmt:	Threshold set for results of the Invoice Debugger nested report
			@pc_UseCrntPrd:	If 'Y' will go back 24 hours from run time.  If 'N', dates below will be used instead.
			@pdt_DteFrm:	From date to use for determining threshold. (converts to start of day specified)
			@pdt_DteTo:		To date to use for determining thresholds. (converts to end of day specified) 
			@pi_IntrnlBAID: Internal BAID to run validation for.  If zero we run it for all BAs
			@pc_Debug:		Use this to turn on various debug messages for troubleshooting.

Date Modified			Modified By			Issue			Modification
-----------------------------------------------------------------------------
*/

as 

begin
	set nocount on
	
	declare @sql_select varchar(2000), @sql_where varchar(2000)
	declare @i_taxCount int, @i_SatCount int, @i_MovXtrCount int, @i_InvDbgCount int
	declare @bit_dateFlag bit	= 0	-- 0 for accnt period, 1 for from and to date
	declare @dt_PeriodFrom smalldatetime, @dt_PeriodTo smalldatetime, @i_PeriodID int = 0
	declare @sql_Counts table (Results int)

	begin try
		if @pc_Debug = 'Y' select 'Params Prevalidation', @pvc_RunMthd, @pc_UseCrntPrd, @pdt_DteFrm, @pdt_DteTo, @pi_TaxLmt, @pi_SatLmt, @pi_MovXtrLmt, @pi_InvDbgLmt

		--------------------------------------------------
		--Verify input params
		--------------------------------------------------
		if(@pvc_RunMthd <> 'InvoiceQueue' and @pvc_RunMthd <> 'InvoicePrint')
			raiserror ('Run method should be either ''InvoiceQueue'' or ''InvoicePrint''. Please fix parameters. ', 16,1)

		if(@pc_UseCrntPrd = 'N')
			set @bit_dateFlag = 1
		else
			begin
				
				set	@dt_PeriodFrom = dateadd(d, -1, getdate())
				set	@dt_PeriodTo = getdate()
				--Leave in as it may be useful at some point in future if we need to look at the current accounting period
				--set		@i_PeriodID		=	(select Min(AccountingPeriod. AccntngPrdID)
				--							From	AccountingPeriod
				--							where AccountingPeriod. AccntngPrdCmplte 	= 'N')
				--select	@dt_PeriodFrom	=	AccountingPeriod.AccntngPrdBgnDte
				--			,@dt_PeriodTo	=	AccountingPeriod.AccntngPrdEndDte
				--from	AccountingPeriod
				--where	AccntngPrdID	=	@i_PeriodID	
			end

		if (@bit_dateFlag = 1)
			begin
				set @pdt_DteFrm	= (DATEADD(d,DATEDIFF(d,0,@pdt_DteFrm),0))
				set @pdt_DteTo	= (DATEADD(d,DATEDIFF(d,0,@pdt_DteTo),0) + '23:59:59')
				
				if (@pdt_DteFrm > @pdt_DteTo)
					raiserror ( 'From date cannot be before to date.  Please fix parameters.', 16,1)
			end 

		if(@pi_TaxLmt < 0 or @pi_SatLmt < 0 or @pi_MovXtrLmt < 0 or @pi_InvDbgLmt < 0) 	
			raiserror ( 'All limits must be a positive number. Please fix parameters.', 16,1)

		if @pc_Debug = 'Y' select 'Params Post-validation', @pvc_RunMthd, @pc_UseCrntPrd, @pdt_DteFrm, @pdt_DteTo, @pi_TaxLmt, @pi_SatLmt, @pi_MovXtrLmt, @pi_InvDbgLmt, @dt_PeriodFrom, @dt_PeriodTo
		
		--------------------------------------------------
		--Get report threshold amounts
		--------------------------------------------------
		if	(@pvc_RunMthd = 'InvoiceQueue')
			begin
				--Search Tax Transactions
				select		@sql_select =	'
					select Count(*)
					from	TaxDetail with (nolock)
					Left Outer Join TaxDetailLog (NoLock)   
						On	TaxDetailLog. TxDtlLgTxDtlID = TaxDetail. TxDtlID
					Left Outer Join AccountDetail (nolock)  
						On 	(AccountDetail. AcctDtlSrceID = TaxDetailLog. TxDtlLgID
						 And AccountDetail. AcctDtlSrceTble = ''T'')
					Where 	TaxDetail. TxDtlSrceTble in (''A'', ''X'', ''T'') 
						and	TaxDetail. TxDtlStts = ''I''
											'
				if (@pi_IntrnlBAID <> 0)
					select	@sql_where =	'
					and	AccountDetail. InternalBAID =	''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + ' 
					and		TaxDetail. TransactionDate >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		TaxDetail. TransactionDate <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	@sql_where + '
					and		TaxDetail. TransactionDate >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		TaxDetail. TransactionDate <= ''' + convert(varchar(25),@dt_PeriodTo)   + '''				
											'

				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_taxCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_taxCount 'Count' ,  @sql_select + @sql_where 'Query'


				--Search Accounting Transactions
				select		@sql_select =	'
					select Count(*)
					from	AccountDetail with (NoLock)
					left join	DealHeader with (NoLock)
						On	AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
					inner join	AccountingPeriod with (NoLock) 
						On	AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
					Where	(AccountDetail.PayableMatchingStatus  not like ''%D%'')
						and DealHeader.DlHdrTyp			= 2
						and AccountDetail.AcctDtlSlsInvceHdrID is null 
						and Exists (select 1 
									from [TransactionTypeGroup] T1
										left Join [TransactionGroup] T2 on T1.XTpeGrpXGrpID = T2.XGrpID
									where (AccountDetail.AcctDtlTrnsctnTypID = T1.XTpeGrpTrnsctnTypID
										and T2.[XGrpQlfr] like ''Invoicing%''))
						and	AccountDetail.acctdtltxstts = ''N''
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		AccountDetail.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + '
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	@sql_where + '
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <=  ''' + convert(varchar(25),@dt_PeriodTo) + '''				
											'

				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_SatCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_SatCount 'Count' ,  @sql_select + @sql_where 'Query'

				--Search Movement Transaction
				select		@sql_select =	'
					select Count(*)
					from	TransactionHeader with (NoLock)
					Inner Join PlannedTransfer (NoLock) 
						On 	TransactionHeader.XHdrplnndTrnsfrID =PlannedTransfer.PlnndTrnsfrID 
					inner join SchedulingObligation so (NOLOCK) 
						On PlannedTransfer.SchdlngOblgtnID = so.SchdlngOblgtnID
					Where	TransactionHeader.XHdrTxChckd	= ''N''
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		so.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + '
					and		TransactionHeader.MovementDate >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		TransactionHeader.MovementDate <  ''' + convert(varchar(25),@pdt_DteTo)	+ '''				
											'
				else
					select	@sql_where	= @sql_where +	'
					and		TransactionHeader.MovementDate >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		TransactionHeader.MovementDate <= ''' + convert(varchar(25),@dt_PeriodTo)	+ '''
											'
		
				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_MovXtrCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_MovXtrCount 'Count' ,  @sql_select + @sql_where 'Query'

				--Verify if limits have been reached and create error message  
				declare @vc_errorMessage varchar(500) = ''

				if	( @i_taxCount > @pi_TaxLmt )
					set @vc_errorMessage =   'Search Tax Transaction (' + convert(varchar(25),@i_taxCount) + '), '
				if	(@i_SatCount > @pi_SatLmt )
					set @vc_errorMessage =   @vc_errorMessage + 'Search Accounting Transaction (' + convert(varchar(25),@i_SatCount) + '), '  
				if  ( @i_MovXtrCount > @pi_MovXtrLmt )
					set @vc_errorMessage =   @vc_errorMessage + 'Search Movement Transaction (' + convert(varchar(25),@i_MovXtrCount) + '), ' 
				if ( len(@vc_errorMessage) > 1)
					begin
						set @vc_errorMessage =   @vc_errorMessage + 'reports have breached specified limits'
						raiserror (@vc_errorMessage, 16,1)
					end
			end
		else
			begin
				create table #tempResults	(AcctDtlID int)
				create table #debugResults	(ErrorNumber int, ErrorID int, ErrorMessage varchar(255), Errorcount int, Adid int)

				--Invoice Debugger 
				select		@sql_select =	'
					select	Count(*)
					from	AccountDetail with (NoLock)
					left join	DealHeader with (NoLock)
						On	AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
					inner join	AccountingPeriod with (NoLock) 
						On	AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
					Where	(AccountDetail.PayableMatchingStatus  not like ''%D%'')
						and DealHeader.DlHdrTyp			= 2
						and AccountDetail.AcctDtlSlsInvceHdrID is null 
						and Exists (select 1 
									from [TransactionTypeGroup] T1
										left Join [TransactionGroup] T2 on T1.XTpeGrpXGrpID = T2.XGrpID
									where (AccountDetail.AcctDtlTrnsctnTypID = T1.XTpeGrpTrnsctnTypID
										and T2.[XGrpQlfr] like ''Invoicing%''))
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		AccountDetail.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	'
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	'
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <=  ''' + convert(varchar(25),@dt_PeriodTo) + '''				
											'
				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_InvDbgCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_InvDbgCount 'Count' ,  @sql_select + @sql_where 'Query'

				if	( @i_InvDbgCount > @pi_InvDbgLmt )
					begin
						set @vc_errorMessage =   'Search Invoice Debugger (' + convert(varchar(25),@i_InvDbgCount) + ') report has breached specified limit'
						raiserror (@vc_errorMessage, 16,1)
					end
				
				/*Commented this out as we don't really care about the invoice debugger counts.
				--if (@pc_Debug = 'Y')	select 'Invoice Debugger Query' ,  @sql_select + @sql_where 'Query'
				--insert #tempResults exec (@sql_select + @sql_where)
				if exists	
				(
					select	count(*)
					from	#tempResults
				)
				begin 
					declare @i_maxID int	= 0
					declare @i_total int	= 0

					--Loop through each of the accounting records and run it against invoice debugger logic
					while(1=1)
					begin
						select top 1 @i_maxID = AcctDtlID from #tempResults where AcctDtlID > @i_maxID order by AcctDtlID

						if	@@ROWCOUNT = 0
							break;

						insert #debugResults exec SP_RAIV_Invoice_Debugger 'N', @i_maxID
						set @i_total = @@ROWCOUNT + @i_total

						if (@i_total > @pi_InvDbgLmt)
						begin
							raiserror (	'Invoice Debugger count has breached limit specified', 16,1)
							break
						end

					end
					
					--clean up and exit.
					drop table #tempResults
					drop table #debugResults

				end
				*/

			end
	end try

begin catch
	begin 
		if OBJECT_ID('tempdb..#tempResults') is not null drop table #tempResults 
		if OBJECT_ID('tempdb..#debugResults') is not null drop table #debugResults 

		declare @error nvarchar(255)
		select	@error = ERROR_MESSAGE()

		raiserror (@error, 16,1)
	end
end catch	

end



go


if object_id('dbo.MTV_InvoicePrevalidation') is not null
	begin
		grant execute on dbo.MTV_InvoicePrevalidation to sysuser, RightAngleAccess
		print '~~~ Successfully created procedure MTV_InvoicePrevalidation and granted permissions ~~~'
	end
else
	print '~~~ Failed created procedure MTV_InvoicePrevalidation and granted permissions ~~~'
	
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\MTV_InvoicePrevalidation.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
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

-- 2017-01-02	RMM		8359	Modified Type-3 Description to display 0 correctly.
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
		
		+ rtrim(ltrim(str(SUM(ISNULL(SlsInvceDtlTrnsctnQntty, 0)), 20, @i_QuantityDecimalPlaces))))

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




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql'
			PRINT '<<< ALTERED StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_Custom_Interface_GL_AD_Load.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
If OBJECT_ID('dbo.Custom_Interface_GL_AD_Load') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Interface_GL_AD_Load
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_GL_AD_Load >>>'
End
Go  

Create Procedure dbo.Custom_Interface_GL_AD_Load	@i_ID				int		= NULL
													,@i_AccntngPrdID	int		= NULL
													,@i_P_EODSnpShtID	int		= NULL
													,@c_GLType			char(2)	= NULL
													,@i_AcctDtlID		int		= NULL
													,@b_GLReprocess		bit		= 0
													,@c_OnlyShowSQL  	char(1) = 'N' 
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Interface_GL_AD_Load @i_ID = 6, @i_AccntngPrdID = 291, @c_GLType = 'M', @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		06/05/2013 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	 @vc_DynamicSQL				varchar(8000)
		,@vc_Error					varchar(255)
		,@sdt_AccntngPrdEndDte		smalldatetime
		,@i_Inv_Val_TrnsctnTypID	int
		,@i_Swap_TrnsctnTypID		int
		,@i_IH_TrnsctnTypID			int
		,@i_VAT_XGrpID				int
		,@i_NightlyGL_XGrpID		int
		,@i_MonthlyGL_XGrpID		int
		,@vc_UnrealizedString		varchar(50)
		,@vc_KeepSignString			varchar(50)
		,@i_DefaultUOMID			int
		,@i_DefaultUOM				varchar(80)
		,@i_DefaultPerUnitDecimals	int
		,@i_DefaultQtyDecimals		int
		,@i_CustomGLExclusionCount	int
		
----------------------------------------------------------------------------------------------------------------------
-- Set the Transaction Type Values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@i_Inv_Val_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Inventory Valuation'	

Select	@i_Swap_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Swaps'

Select	@i_VAT_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Tax'

select	@i_CustomGLExclusionCount = count(1)
From	dbo.CustomGLExclusion

/*
Select	@i_NightlyGL_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Include in Nightly GL'
*/

Select	@i_MonthlyGL_XGrpID = XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Exclude From Monthly GL'

Select	@i_IH_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Inhouse Transactions'

Select	@vc_KeepSignString	= '2061'

Select	@vc_UnrealizedString	= '2027,2028,2029,2030'

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\SalesAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\PurchaseAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\IncompletePricingAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)


Select	@i_DefaultUOMID				= InterfaceDefaultUOMID
		,@i_DefaultUOM				= InterfaceDefaultUOM
		,@i_DefaultPerUnitDecimals	= InterfaceDefaultPerUnitDecimals
		,@i_DefaultQtyDecimals		= InterfaceDefaultQtyDecimals		
From	CustomConfigAccounting	(NoLock)
Where	ConfigurationName	= 'Default'

/*
Include in Monthly GL
Include in Nightly GL
*/

----------------------------------------------------------------------------------------------------------------------
-- If we are running a monthly GL the accounting period id needs to be present
----------------------------------------------------------------------------------------------------------------------	
If	@i_AccntngPrdID Is Null Or @i_ID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin 
				Select	@vc_Error	= 'A GL Batch requires an Accounting Period and Batch ID.'
				GoTo	Error
			End					
	End 

----------------------------------------------------------------------------------------------------------------------
-- Set the Accounting Period values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_AccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod	(NoLock)
Where	AccountingPeriod. AccntngPrdID	= IsNull(@i_AccntngPrdID, 720)

----------------------------------------------------------------------------------------------------------------------
-- Collect the Monthly GL Data
----------------------------------------------------------------------------------------------------------------------
If	@c_GLType	= 'M' And @b_GLReprocess = 0
	Begin
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Realized records that have not been invoiced yet
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value	
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume	
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''AD''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail				(NoLock)
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1 
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'', ''P'')
		And		TransactionType. TrnsctnTypMvt			<> ''I''																				-- Exclude Accrual Transaction Types
		And		AccountDetail. Value 					<> 0.0

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once

		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Get rid of the Clearport Swaps - they are fed in the Nightly Run
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Delete	tmp_CustomAccountDetail
		Where	TrnsctnTypID	= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,0)) + ' 	
		And		Exists	(	Select	''X''
							From	GeneralConfiguration	(NoLock)
							Where	GeneralConfiguration. GnrlCnfgTblNme				= ''DealHeader''
							And		GeneralConfiguration. GnrlCnfgQlfr					= ''ExchangeTraded''
							And		tmp_CustomAccountDetail. DlHdrID						= GeneralConfiguration. GnrlCnfgHdrID	
							And		GeneralConfiguration. GnrlCnfgHdrID					<> 0
							And		IsNull(GeneralConfiguration. GnrlCnfgMulti,'''')	Not In (''None'',''''))
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DlDtlPrvsnID value - Pass 1 Movement Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID			= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
		From	tmp_CustomAccountDetail				(NoLock)
				Inner Join	TransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID	= TransactionDetailLog. XDtlLgAcctDtlID
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''X''	
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 2 Time Transaction Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= TimeTransactionDetail. TmeXDtlDlDtlPrvsnID
				,DlDtlPrvsnRwID		= TimeTransactionDetail. TmeXDtlDlDtlPrvsnRwID
		From	tmp_CustomAccountDetail						(NoLock)
				Inner Join	TimeTransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID					= TimeTransactionDetailLog. TmeXDtlLgAcctDtlID
				Inner Join	TimeTransactionDetail		(NoLock)	On	TimeTransactionDetailLog. TmeXDtlLgTmeXDtlIdnty	= TimeTransactionDetail. TmeXDtlIdnty
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''TT''	
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 3 Movement Expense Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= MovementExpenseLog. MvtExpnseLgMvtExpnseID
		From	tmp_CustomAccountDetail					(NoLock)
				Inner Join	MovementExpenseLog		(NoLock)	On	tmp_CustomAccountDetail. AcctDtlSrceID		= MovementExpenseLog. MvtExpnseLgID
																And	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''M''	
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 3 Movement Expense Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= NULL
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''M''	
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)																			
		
		----------------------------------------------------------------------------------------------------------------------
		-- Remove any Discards
		----------------------------------------------------------------------------------------------------------------------			
		Select	@vc_DynamicSQL	= '		
		Delete	tmp_CustomAccountDetail 
		Where	PayableMatchingStatus	= ''D''			
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Invoice Accruals
		----------------------------------------------------------------------------------------------------------------------				
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with Details Attached to a Sales Invoice that has an Active or Held Status - Step 1
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)							
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				 
				,AccountDetail. AcctDtlSlsInvceHdrID
				,SalesInvoiceHeader. SlsInvceHdrNmbr																																									 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID													
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value																				
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AR''	
				,' + convert(varchar,@i_ID) + '	
				,''SlsInvceHdrID:'' + convert(varchar,SalesInvoiceHeader. SlsInvceHdrID) + ''||InvoiceNumber:'' + SalesInvoiceHeader. SlsInvceHdrNmbr  + ''||Status:'' + SalesInvoiceHeader. SlsInvceHdrStts + ''||Reason:Invoice has not been distributed.''
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '				
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc

		From	AccountDetail					(NoLock)
				Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		SalesInvoiceHeader. SlsInvceHdrStts		In (''A'', ''H'')
		And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with Details Attached to a Sales Invoice that has a Sent Status but Not Fed - Step 2
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																	
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 													
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																		
				,AccountDetail. AcctDtlSlsInvceHdrID
				,SalesInvoiceHeader. SlsInvceHdrNmbr																																								 	
				,AccountDetail. InternalBAID														
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value																			
				,AccountDetail. CrrncyID														
				,AccountDetail. Volume															
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																			
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AR''	
				,' + convert(varchar,@i_ID) + '	
				,''SlsInvceHdrID:'' + convert(varchar,SalesInvoiceHeader. SlsInvceHdrID) + ''||InvoiceNumber:'' + SalesInvoiceHeader. SlsInvceHdrNmbr + ''||Status:'' + SalesInvoiceHeader. SlsInvceHdrStts + ''||Reason:Invoice is Fed but has no Fed Date.''		
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail					(NoLock)
				Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		SalesInvoiceHeader. SlsInvceHdrStts		= ''S''
		And		SalesInvoiceHeader.	SlsInvceHdrFdDte	Is Null
		And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Do We Need a Step Checking Posted Dates?
		----------------------------------------------------------------------------------------------------------------------				
			
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with records that are on Active or Held Purchase Invoices - Step 1
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail.	AcctDtlPrchseInvceHdrID	
				,PayableHeader. InvoiceNumber																																		 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value																					
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																	 
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AP''	
				,' + convert(varchar,@i_ID) + '
				,''PybleHdrID:'' + convert(varchar,PayableHeader. PybleHdrID) + ''||SupplierInvoiceNumber:'' + PayableHeader. InvoiceNumber + ''||Status:'' + PayableHeader. Status + ''||Reason:Invoice is on Hold.''										
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail							(NoLock)
				Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		PayableHeader. Status			= ''H''
		And		PayableHeader. InvoiceAmount	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with records that are on Fed Purchase Invoices but Have Not Fed - Step 2
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals

				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''											
				,AccountDetail. Reversed															
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																				
				,AccountDetail.	AcctDtlPrchseInvceHdrID													
				,PayableHeader. InvoiceNumber																						 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID														
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID													
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value																				
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																			
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AP''	
				,' + convert(varchar,@i_ID) + '	
				,''PybleHdrID:'' + convert(varchar,PayableHeader. PybleHdrID) + ''||SupplierInvoiceNumber:'' + PayableHeader. InvoiceNumber + ''||Status:'' + PayableHeader. Status + ''||Reason:Invoice is Fed but has no Fed Date.''
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail							(NoLock)
				Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')	

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)																
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		PayableHeader. Status			= ''F''
		And		PayableHeader. FedDate			Is Null
		And		PayableHeader. InvoiceAmount	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')		
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Do We Need a Step Checking Posted Dates?
		----------------------------------------------------------------------------------------------------------------------						

		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Physical Forward records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																			
				,AccountDetail. AcctDtlSrceID																
				,AccountDetail. AcctDtlSrceTble 															
				,AccountDetail. AcctDtlAccntngPrdID
				,''N''															
				,AccountDetail. Reversed																	
				,AccountDetail. AcctDtlPrntID																
				,AccountDetail. PayableMatchingStatus														
				,''GL'' 																					 																						 	
				,AccountDetail. InternalBAID																
				,AccountDetail. ExternalBAID																	
				,AccountDetail. ParentPrdctID																
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID																
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value
				,AccountDetail. CrrncyID																	
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte															
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''PF''	
				,' + convert(varchar,@i_ID) + '	
				,convert(varchar(max),ManualLedgerEntry. Comment)
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail						(NoLock)
				Inner Join	ManualLedgerEntryLog	(NoLock)	On	AccountDetail. AcctDtlSrceID			= ManualLedgerEntryLog. MnlLdgrEntryLgID
																And	AccountDetail. AcctDtlSrceTble			= ''ML''
				Inner Join	ManualLedgerEntry		(NoLock)	On	ManualLedgerEntryLog. MnlLdgrEntryID	= ManualLedgerEntry. MnlLdgrEntryID 		
				Inner Join	TransactionType			(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID		= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID				= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID			Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID				Is Null	
		And		AccountDetail. AcctDtlTrnsctnTypID				In ('+@vc_UnrealizedString+')
		And		AccountDetail. Value 							<> 0.0
		And		AccountDetail. Reversed							= ''N''

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)							
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End +	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')				
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Strip out the Risk ID from the ML Comments 
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		RiskID	=	Case	
								When	IsNumeric(RTrim(LTrim(Replace(Substring(Comments, 0, CharIndex(''|'', Comments)),''RiskID: '',''''))))	= 1 Then	convert(int,RTrim(LTrim(Replace(Substring(Comments, 0, CharIndex(''|'', Comments)),''RiskID: '',''''))))
								Else	NULL
							End
		From	tmp_CustomAccountDetail					(NoLock)
		Where	tmp_CustomAccountDetail. PostingType	= ''PF''
		And		tmp_CustomAccountDetail. Comments		Like ''Risk%''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Inventory Change records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID
				,AccountDetail. AcctDtlSrceID														
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID														
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																																									 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''IV''		
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail				(NoLock)															
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			= ''IV''
		-- And		AccountDetail. Reversed					= ''N''  -- we need both originals & reversals to get change in inventory

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'					
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)		
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End +  Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for ML records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''												
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				 																						 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AM''	
				,' + convert(varchar,@i_ID) + '	
				,ManualLedgerEntry. P_EODEstmtedAccntDtlID
				,convert(varchar(max),ManualLedgerEntry. Comment)	
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail						(NoLock)
				Inner Join	ManualLedgerEntryLog	(NoLock)	On	AccountDetail. AcctDtlSrceID			= ManualLedgerEntryLog. MnlLdgrEntryLgID
																And	AccountDetail. AcctDtlSrceTble			= ''ML''
				Inner Join	ManualLedgerEntry		(NoLock)	On	ManualLedgerEntryLog. MnlLdgrEntryID	= ManualLedgerEntry. MnlLdgrEntryID 
				Inner Join	TransactionType			(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID		= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID				= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID			Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID				Is Null	
		And		AccountDetail. AcctDtlTrnsctnTypID				Not In ('+@vc_UnrealizedString+')
		And		ManualLedgerEntry. DerivativeAccountingEntry	= 0
		And		AccountDetail. Value 							<> 0.0
		-- And		AccountDetail. Reversed							= ''N''

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)				
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + 
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		
	End
	
----------------------------------------------------------------------------------------------------------------------
-- Collect the Nightly GL Data
----------------------------------------------------------------------------------------------------------------------
If	@c_GLType	In ('N')  And @b_GLReprocess = 0
	Begin
	
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for any recors in the Feed in Nightly GL Group
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals)
		Select	 AccountDetail. AcctDtlID																
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,Case When AcctDtlTrnsctnTypID Not In (' + @vc_KeepSignString + ') Then Case When WePayTheyPay = ''R'' Then -1 Else 1 End * AccountDetail. Value Else AccountDetail. Value End
				,AccountDetail. CrrncyID																
				,Case When AcctDtlTrnsctnTypID Not In (' + @vc_KeepSignString + ') Then Case When SupplyDemand = ''D'' Then -1 Else 1 End * AccountDetail. Volume Else AccountDetail. Volume End
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''RA''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '						
		From	AccountDetail				(NoLock)															
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null		
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')	
		And		AccountDetail. AcctDtlTrnsctnTypID		<> ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '	
		And		AccountDetail. Value 					<> 0.0								
		And		Exists		(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_NightlyGL_XGrpID,0)) + ')	-- Include Transactions that are Fed in the Nightly GL Run
		' + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + 
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomGLInterface	(NoLock)
								Where	CustomGLInterface. AcctDtlID	= AccountDetail. AcctDtlID 
								And		CustomGLInterface. GLType		= ''N'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
					
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for any exchange traded swaps
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''											
				,AccountDetail. Reversed															
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																																								 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID																
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)					
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand																
				,AccountDetail. Value																					
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																	
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''SW''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '						
		From	AccountDetail				(NoLock)															
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			= ''TT''	
		And		AccountDetail. AcctDtlTrnsctnTypID		= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '
		And		AccountDetail. Value 					<> 0.0		
		And		Exists	(	Select	''X''
							From	GeneralConfiguration	(NoLock)
							Where	GeneralConfiguration. GnrlCnfgTblNme				= ''DealHeader''
							And		GeneralConfiguration. GnrlCnfgQlfr					= ''ExchangeTraded''
							And		AccountDetail. AcctDtlDlDtlDlHdrID					= GeneralConfiguration. GnrlCnfgHdrID	
							And		GeneralConfiguration. GnrlCnfgHdrID					<> 0
							And		IsNull(GeneralConfiguration. GnrlCnfgMulti,'''')	Not In (''None'',''''))	
		' + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)																								
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomGLInterface	(NoLock)
								Where	CustomGLInterface. AcctDtlID	= AccountDetail. AcctDtlID 
								And		CustomGLInterface. GLType		= ''N'')			
		'	
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Set the PostingType value
		----------------------------------------------------------------------------------------------------------------------					
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		PostingType	=	Case
									When	TransactionGroup. XGrpName = ''Nightly GL - Futures''			Then ''FT''
									When	TransactionGroup. XGrpName = ''Nightly GL - Inhouse''			Then ''IH''
									When	TransactionGroup. XGrpName = ''Nightly GL - Swaps''				Then ''SW''
									Else	''RA''
								End
		From	tmp_CustomAccountDetail				(NoLock)
				Inner Join	TransactionTypeGroup	(NoLock)	On	tmp_CustomAccountDetail. TrnsctnTypID	= TransactionTypeGroup. XTpeGrpTrnsctnTypID										
				Inner Join	TransactionGroup		(NoLock)	On	TransactionTypeGroup. XTpeGrpXGrpID	= TransactionGroup. XGrpID
																And	TransactionGroup. XGrpQlfr			= ''GL Posting Type''					
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Correct the Sign on Futures and Inhouses - We Pays Need to be + and They Pays need to be -
		----------------------------------------------------------------------------------------------------------------------		
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		NetValue	= AccountDetail. Value	* -1	
				,Quantity	= AccountDetail. Volume * -1
		From	tmp_CustomAccountDetail		(NoLock)
				Inner Join	AccountDetail	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID 					
		Where	PostingType	In (''FT'',''IH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
			
	End

----------------------------------------------------------------------------------------------------------------------
-- If we are reprocessing just reload the information from CustomAccountDetail - account detail properties can't change
----------------------------------------------------------------------------------------------------------------------	
If	@b_GLReprocess = 1
	Begin	
	
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,RiskID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
				)	
		Select	Distinct AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,RiskID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
		From	CustomAccountDetail	(NoLock)
		Where	BatchID		= ' + convert(varchar,@i_ID) + '
		And		GLType		= ''' + @c_GLType + '''
		And		AcctDtlID	= ' + convert(varchar,@i_AcctDtlID) + '
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
			
	End												

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	
		
----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
Raiserror (60010,15,-1, @vc_Error	)



GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_GL_AD_Load') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_GL_AD_Load >>>'
	Grant Execute on dbo.Custom_Interface_GL_AD_Load to SYSUSER
	Grant Execute on dbo.Custom_Interface_GL_AD_Load to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_GL_AD_Load >>>'
GO

 
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_Custom_Interface_GL_AD_Load.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTVNonDuplicateBOLsMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=sp_MTVNonDuplicateBOLsForMovementLifeCycle.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVNonDuplicateBOLsForMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVNonDuplicateBOLsForMovementLifeCycle TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>'
GO
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTVNonDuplicateBOLsMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\SP_MTV_Freight_Lookup.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Freight_Lookup] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Freight_Lookup >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Freight_Lookup]
	(
	@i_TxRleStID		Int,
	@i_DlDtlPrvsnID		Int,
	@i_XHdrID			Int,
	@i_PriceType		VARCHAR(50) = 'Posting',-- Posting--pricetype
	@vc_RPHdrCde		Varchar(5), --Frt, Fuel, Miles
	@i_PricingPrdctID	Int = NULL
	)
AS

-- =============================================
-- Author:        rlb
-- Create date:	  09/22/2016
-- Description:   This SP will look up freight costs to be used in variables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_BAID					Int
Declare @i_RPHdrID				Int

Declare	@i_FromLcleID			Int
Declare	@i_ToLcleID				Int
Declare @i_PrdctID				Int
Declare @i_RwPrceLcleID			Int
Declare @i_PriceTypeID			Int
Declare @GlblPrdctID			INT

Declare @flt_Rate				Float

Declare @sdt_MovementDate		SmallDateTime

SELECT	@GlblPrdctID = prdctid from product where product.PrdctNme = 'Global Product'

----------------------------------------------------------------------------------------------------------------------
-- Find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

If @i_PriceTypeID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price type.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Look up the BA on the Tax as this will be the carrier
----------------------------------------------------------------------------------------------------------------------
Select	@i_BAID = Tax.TaxAuthorityBAID
--select *
From	dbo.TaxRuleSet (NoLock)
		Inner Join Tax (NoLock) on Tax.TxID = TaxRuleSet.TxID
Where	TaxRuleSet.TxRleStID = @i_TxRleStID

----------------------------------------------------------------------------------------------------------------------
-- Get Movement Data off of the transaction
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_MovementDate = TransactionHeader.MovementDate,
		@i_FromLcleID = MovementHeader.MvtHdrOrgnLcleID,
		@i_ToLcleID = MovementHeader.MvtHdrDstntnLcleID,
		@i_PrdctID = MovementHeader.MvtHdrPrdctID
		--select *
From	dbo.TransactionHeader (NoLock)
		Inner Join dbo.MovementHeader (NoLock) On  MovementHeader.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
Where	TransactionHeader.XHdrID = @i_XHdrID

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find origin
----------------------------------------------------------------------------------------------------------------------
If @i_FromLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the origin location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find Destination
----------------------------------------------------------------------------------------------------------------------
If @i_ToLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the destination location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- If not passed in a pricing product then use the one on the movement
----------------------------------------------------------------------------------------------------------------------
If @i_PricingPrdctID is Null
Begin
	Select	@i_PricingPrdctID = @i_PrdctID
End

----------------------------------------------------------------------------------------------------------------------
-- Get the price service
----------------------------------------------------------------------------------------------------------------------
Select	Top 1
		@i_RPHdrID = RPHdrID
From	dbo.RawPriceHeader
Where	RPHdrBAID = @i_BAID
And		RPHdrCde = @vc_RPHdrCde
And		RPHdrStts = 'A'

If @i_RPHdrID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price service.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get price curve based on type of freight
----------------------------------------------------------------------------------------------------------------------
IF	@vc_RPHdrCde IN ('Frt', 'Miles')
BEGIN

		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @i_PricingPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID

		If @i_RwPrceLcleID is Null
	BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID
	END
END
IF @vc_RPHdrCde IN ('Fuel')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END
IF @vc_RPHdrCde IN ('Clean','Misc')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleLcleID = @i_FromLcleID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END

If @i_RwPrceLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price curve.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get freight price
----------------------------------------------------------------------------------------------------------------------
Select	@flt_Rate = RawPrice.RPVle
From	RawPriceDetail
		Inner Join RawPrice		On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
								And	RawPrice.RPPrceTpeIdnty = @i_PriceTypeID
Where	RawPriceDetail.RwPrceLcleID = @i_RwPrceLcleID
And		@sdt_MovementDate Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte

If @flt_Rate is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to a freight rate for the movement date.',61000)
	Select 0.0
	Return
End


Select @flt_Rate

GO


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Freight_Lookup.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Freight_Lookup >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Freight_Lookup >>>'
	  END/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Freight_Lookup] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Freight_Lookup >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Freight_Lookup]
	(
	@i_TxRleStID		Int,
	@i_DlDtlPrvsnID		Int,
	@i_XHdrID			Int,
	@i_PriceType		VARCHAR(50) = 'Posting',-- Posting--pricetype
	@vc_RPHdrCde		Varchar(5), --Frt, Fuel, Miles
	@i_PricingPrdctID	Int = NULL
	)
AS

-- =============================================
-- Author:        rlb
-- Create date:	  09/22/2016
-- Description:   This SP will look up freight costs to be used in variables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_BAID					Int
Declare @i_RPHdrID				Int

Declare	@i_FromLcleID			Int
Declare	@i_ToLcleID				Int
Declare @i_PrdctID				Int
Declare @i_RwPrceLcleID			Int
Declare @i_PriceTypeID			Int
Declare @GlblPrdctID			INT

Declare @flt_Rate				Float

Declare @sdt_MovementDate		SmallDateTime

SELECT	@GlblPrdctID = prdctid from product where product.PrdctNme = 'Global Product'

----------------------------------------------------------------------------------------------------------------------
-- Find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

If @i_PriceTypeID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price type.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Look up the BA on the Tax as this will be the carrier
----------------------------------------------------------------------------------------------------------------------
Select	@i_BAID = Tax.TaxAuthorityBAID
--select *
From	dbo.TaxRuleSet (NoLock)
		Inner Join Tax (NoLock) on Tax.TxID = TaxRuleSet.TxID
Where	TaxRuleSet.TxRleStID = @i_TxRleStID

----------------------------------------------------------------------------------------------------------------------
-- Get Movement Data off of the transaction
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_MovementDate = TransactionHeader.MovementDate,
		@i_FromLcleID = MovementHeader.MvtHdrOrgnLcleID,
		@i_ToLcleID = MovementHeader.MvtHdrDstntnLcleID,
		@i_PrdctID = MovementHeader.MvtHdrPrdctID
		--select *
From	dbo.TransactionHeader (NoLock)
		Inner Join dbo.MovementHeader (NoLock) On  MovementHeader.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
Where	TransactionHeader.XHdrID = @i_XHdrID

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find origin
----------------------------------------------------------------------------------------------------------------------
If @i_FromLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the origin location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find Destination
----------------------------------------------------------------------------------------------------------------------
If @i_ToLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the destination location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- If not passed in a pricing product then use the one on the movement
----------------------------------------------------------------------------------------------------------------------
If @i_PricingPrdctID is Null
Begin
	Select	@i_PricingPrdctID = @i_PrdctID
End

----------------------------------------------------------------------------------------------------------------------
-- Get the price service
----------------------------------------------------------------------------------------------------------------------
Select	Top 1
		@i_RPHdrID = RPHdrID
From	dbo.RawPriceHeader
Where	RPHdrBAID = @i_BAID
And		RPHdrCde = @vc_RPHdrCde
And		RPHdrStts = 'A'

If @i_RPHdrID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price service.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get price curve based on type of freight
----------------------------------------------------------------------------------------------------------------------
IF	@vc_RPHdrCde IN ('Frt', 'Miles')
BEGIN

		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @i_PricingPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID

		If @i_RwPrceLcleID is Null
	BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID
	END
END
IF @vc_RPHdrCde IN ('Fuel')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END
IF @vc_RPHdrCde IN ('Clean','Misc')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleLcleID = @i_FromLcleID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END

If @i_RwPrceLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price curve.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get freight price
----------------------------------------------------------------------------------------------------------------------
Select	@flt_Rate = RawPrice.RPVle
From	RawPriceDetail
		Inner Join RawPrice		On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
								And	RawPrice.RPPrceTpeIdnty = @i_PriceTypeID
Where	RawPriceDetail.RwPrceLcleID = @i_RwPrceLcleID
And		@sdt_MovementDate Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte

If @flt_Rate is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to a freight rate for the movement date.',61000)
	Select 0.0
	Return
End


Select @flt_Rate

GO


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Freight_Lookup.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Freight_Lookup >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Freight_Lookup >>>'
	  END
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\SP_MTV_Freight_Lookup.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetPhysicalDealArchiveEntries.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
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
	@DlDtlIntrnlUserID varchar(100),
	@ContractNumber varchar(80),
	@DealRevisionDate DATE,
	@StrtgyID varchar(100)
AS
-- =============================================
-- Author:        Alec Aquino
-- Create date:	  1/27/2016
-- Description:   Update Deal Detail IO GSAP Attributes from Maintenance Report
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 2016-09-19	DAO						Modifed procedure to store archive data in table for later retrieval so history would be retatained.
-- 2016-09-19	Reed Mattingly			Converted userId and strtgyId parameters into varchar so a comma-delimited list of ids can be provided
--										allowing multi-selection in the report criteria.
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
IF (@DlDtlIntrnlUserID IS NOT NULL) SELECT @sql = @sql + ' AND Orig.DlDtlIntrnlUserID in (' + CAST(@DlDtlIntrnlUserID AS VARCHAR) + ')'
IF (@ContractNumber IS NOT NULL) SELECT @sql = @sql + ' AND Orig.DlHdrIntrnlNbr LIKE ''%' + CAST(@ContractNumber AS VARCHAR) + '%'''
IF (@DealRevisionDate IS NOT NULL) SELECT @sql = @sql + ' AND CAST(CAST(Orig.DlHdrRvsnDte AS DATE) AS VARCHAR) = ''' + CAST(CAST(@DealRevisionDate AS DATE) AS VARCHAR) + ''''
IF (@StrtgyID IS NOT NULL) SELECT @sql = @sql + ' AND Orig.StrtgyID in (' + CAST(@StrtgyID AS VARCHAR) + ')'


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
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetPhysicalDealArchiveEntries.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetTempMarkToMarket.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetTempMarkToMarket WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_GetTempMarkToMarket]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetTempMarkToMarket.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetTempMarkToMarket] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_GetTempMarkToMarket]
-- =============================================
-- Author:		Amar Kenguva
-- Create date: 09/27/2018
-- Description:	Load latest snapshot Mark to Market data into Custom Table [db_datareader].[MTVTempMarkToMarket]
-- =============================================

	
AS
BEGIN
	
	
IF NOT EXISTS (SELECT TOP 1 1 FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'N' AND Purged = 'N')
BEGIN




SET NOCOUNT ON; 

DECLARE @i_P_EODSnpShtID Int,@SnapshotId Int, @StartedFromVETradePeriodID Int,@SnapshotInstanceDateTime SmallDateTime,@CompareSnapshotInstanceDateTime SmallDateTime,@SnapshotEndOfDay SmallDateTime
,@CompareSnapshotEndOfDay SmallDateTime,@CompareWithAnotherSnapshot Bit,@ComparisonSnapshotId Int,@1DayInstanceDateTime SmallDateTime,@5DayInstanceDateTime SmallDateTime
,@WklyInstanceDateTime SmallDateTime,@MtDInstanceDateTime SmallDateTime,@QtDInstanceDateTime SmallDateTime,@YtDInstanceDateTime SmallDateTime,@RiskReportCriteriaRetrievalOption VarChar (8000)
,@PositionGroupId VarChar (8000),@ProductLocationChemicalId VarChar (8000),@PortfolioId VarChar (8000),@StrategyId VarChar (8000),@InternalBa VarChar (8000),@StartingVeTradePeriodId SmallInt
,@NumberOfPeriods VarChar (8000),@AggregateRecordsOutsideOfDateRange Bit,@AppendWhatIfScenarios Bit,@WhatIfScenarioId Int,@RiskReportInventoryRetrievalOption VarChar (8000)
,@TradePeriodStartDate SmallDateTime,@MaxTradePeriodStartDate SmallDateTime,@MaxTradePeriodEndDate SmallDateTime,@EndOfTimePeriodStartDate SmallDateTime,@EndOfTimePeriodEndDate SmallDateTime
,@InventoryTradePeriodStart SmallDateTime,@InventoryTradePeriodEnd SmallDateTime,@BegInvSourceTable Char,@RetrievalOptions Int,@35@RiskDealDetail@DlDtlIntrnlUserID Int,@36@Risk@StrtgyID Int


SELECT @i_P_EODSnpShtID='-1',@CompareWithAnotherSnapshot='False',@ComparisonSnapshotId='-2',@1DayInstanceDateTime='1990-01-01 00:00:00'
,@WklyInstanceDateTime='1990-01-01 00:00:00',@MtDInstanceDateTime='1990-01-01 00:00:00',@QtDInstanceDateTime='1990-01-01 00:00:00'
,@YtDInstanceDateTime='1990-01-01 00:00:00',@RiskReportCriteriaRetrievalOption='P',@PositionGroupId= NULL 
,@ProductLocationChemicalId= NULL ,@PortfolioId='53',@StrategyId= NULL ,@InternalBa='20',@StartingVeTradePeriodId='0'
,@NumberOfPeriods='-1',@AggregateRecordsOutsideOfDateRange='False',@AppendWhatIfScenarios='False',@WhatIfScenarioId= NULL 
,@RiskReportInventoryRetrievalOption='I',@MaxTradePeriodStartDate='2076-05-01 00:00:00',@MaxTradePeriodEndDate='2076-05-31 23:59:00'
,@EndOfTimePeriodStartDate='2050-12-01 00:00:00',@EndOfTimePeriodEndDate='2050-12-01 23:59:00', @BegInvSourceTable='S',@RetrievalOptions='265',@35@RiskDealDetail@DlDtlIntrnlUserID= NULL 
,@36@Risk@StrtgyID= NULL 



SELECT @SnapshotId =  P_EODSnpShtID ,@SnapshotInstanceDateTime = InstanceDateTime, @StartedFromVETradePeriodID = StartedFromVETradePeriodID
,@CompareSnapshotInstanceDateTime = InstanceDateTime, @SnapshotEndOfDay = EndOfDay, @CompareSnapshotEndOfDay = EndOfDay
,@5DayInstanceDateTime=InstanceDateTime,
@TradePeriodStartDate = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodStart = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodEnd = (SELECT [EndDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
FROM Snapshot(NOLOCK)
WHERE P_EODSnpShtID = (SELECT max(P_EODSnpShtID) FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'Y' AND Purged = 'N')


IF NOT EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempMarkToMarket]
WHERE snapshot_id = @SnapshotId AND end_of_day = @SnapshotEndOfDay)

BEGIN

IF EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempMarkToMarket])
	TRUNCATE TABLE [db_datareader].[MTVTempMarkToMarket]

Create Table #StrategyReportCriteria
(
	StrtgyID 		Int Not Null
)

Insert Into [#StrategyReportCriteria] ([StrtgyID])
 (Select	[P_PortfolioStrategyFlat].[StrtgyID]
From	[P_PortfolioStrategyFlat] (NoLock)

Where	(
	[P_PortfolioStrategyFlat].[P_PrtflioID] In (53)
	))

Create Table #RiskResults
(
	Idnty 		Int identity  Not Null,
	RiskSourceValueID 		Int Null default 0,
	RiskID 		Int Not Null,
	SourceTable 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null,
	IsPrimaryCost 		Bit Not Null,
	DlDtlTmplteID 		Int Null,
	TmplteSrceTpe 		VarChar(2) COLLATE DATABASE_DEFAULT  Null,
	RiskExposureTableIdnty 		Int Null,
	Percentage 		Float Null,
	RiskCurveID 		Int Null,
	DeliveryPeriodStartDate 		SmallDateTime Not Null,
	DeliveryPeriodEndDate 		SmallDateTime Not Null,
	AccountingPeriodStartDate 		SmallDateTime Not Null,
	AccountingPeriodEndDate 		SmallDateTime Not Null,
	Position 		Decimal(38,15) Null default 0.0,
	ValuationPosition 		Decimal(38,15) Null default 0.0,
	SpecificGravity 		Decimal(38,15) Null default 0.0,
	Energy 		Decimal(38,15) Null default 0.0,
	TotalPnL 		Float Null default 0.0,
	PricedPnL 		Float Null default 0.0,
	TotalValue 		Float Null default 0.0,
	PricedValue 		Float Null default 0.0,
	MarketValue 		Float Null default 0.0,
	PricedInPercentage 		Decimal(28,13) Null default 1.0,
	MarketValueIsMissing 		Bit Not Null default 0,
	DealValueIsMissing 		Bit Not Null default 0,
	MarketCrrncyID 		SmallInt Null,
	PaymentCrrncyID 		SmallInt Null,
	MarketValueFXRate 		Float Not Null default 1.0,
	TotalValueFXRate 		Float Not Null default 1.0,
	PricedValueFXRate 		Float Not Null default 1.0,
	DiscountFactor 		Float Not Null default 1.0,
	DiscountFactorID 		Int Null,
	MarketDiscountFactor 		Float Not Null default 1.0,
	MarketDiscountFactorID 		Int Null,
	SplitType 		VarChar(10) COLLATE DATABASE_DEFAULT  Null,
	DefaultCurrencyID 		Int Null,
	InstanceDateTime 		SmallDateTime Not Null,
	IsPPA 		Bit Not Null default 0,
	IsPriorMonthTransaction 		Bit Not Null default 0,
	IsEstMovementWithFuturePricing 		Bit Not Null default 0,
	FloatingPerUnitValue 		Float Null default 0.0,
	PricedInPerUnitValue 		Float Null default 0.0,
	CloseOfBusiness 		SmallDateTime Null,
	Snapshot 		Int Null,
	SnapshotDateTime 		SmallDateTime Null,
	SnapshotAccountingPeriod 		SmallDateTime Null,
	SnapshotTradePeriod 		SmallDateTime Null,
	SnapshotIsArchived 		Bit Not Null default 0,
	HistoricalPnLExists 		Bit Not Null default 0,
	ShowZeroPosition 		Bit Not Null default 0,
	ShowZeroMarketValue 		Bit Not Null default 0,
	IsInventoryMove 		VarChar(3) COLLATE DATABASE_DEFAULT  Null default 'No',
	Account 		VarChar(9) COLLATE DATABASE_DEFAULT  Null default 'Trading',
	IsEstMovementWithFuturePricing_Balance 		Bit Not Null default 0,
	ReplaceTotalValuewithMarket 		Bit Not Null default 0,
	AttachedInHouse 		Char(1) COLLATE DATABASE_DEFAULT  Not Null default 'N',
	EstimatedPaymentDate 		SmallDateTime Null,
	UnAdjustedPosition 		Float Not Null default 0.0,
	RelatedSwapRiskID 		Int Null,
	IsFlatFee 		Bit Not Null default 0,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	TotalQuotePercentage 		Float Not Null default 0.0,
	TotalPricedPercentage 		Float Not Null default 0.0,
	SellSwapPricedValue 		Float Null default 0,
	LeaseDealDetailID 		Int Null,
	IsOption 		Bit Not Null default 0,
	CombineSwap 		Bit Not Null default 1,
	ConversionCrrncyID 		Int Null,
	RelatedDealNumber 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	MoveExternalDealID 		Int Null,
	ApplyDiscount 		Bit Not Null default 0,
	MarketValueFXConversionDate 		SmallDateTime Null,
	DealValueFXConversionDate 		SmallDateTime Null,
	CurrencyPairID 		SmallInt Null,
	IsReciprocal 		Bit Null,
	FxForwardRate 		Float Null,
	CurrencyPairFxRate 		Float Null,
	CurrencyPairFxRateErrors 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null
)

Create NonClustered Index IE_RiskID_DlDtlTmplteID on #RiskResults (RiskID,DlDtlTmplteID)

Create NonClustered Index ID_RiskID_InstanceDateTime_IsPriorMonthTransaction on #RiskResults (RiskID, InstanceDateTime,IsPriorMonthTransaction )

Create Table #RiskResultsOptions
(
	RiskID 		Int Not Null,
	RiskDealDetailOptionID 		Int Not Null,
	RiskResultsTableIdnty 		Int Null,
	DeliveryPeriodStart 		SmallDateTime Not Null,
	DeliveryPeriodEnd 		SmallDateTime Not Null,
	IsOTC 		Bit Not Null default 0,
	DlHdrID 		Int Not Null,
	DlDtlID 		Int Not Null,
	ExpirationDate 		SmallDateTime Null,
	ExercisedDate 		SmallDateTime Null,
	Exercised 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	ExercisedQuantity 		Float Null,
	PutCall 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	Flavor 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	StrikePrice 		Float Null,
	StrikePriceUOM 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	PriceService 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCSettlementTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCPremiumTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	EffectiveStartDate 		SmallDateTime Null,
	EffectiveEndDate 		SmallDateTime Null,
	Premium 		Float Null,
	OTCQuantity 		Float Null,
	BuySell 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	Period 		SmallDateTime Null,
	OTCBuySell1 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod1 		SmallDateTime Null,
	OTCWeight 		Float Null,
	OTCRow 		Int Null,
	OTCPriceType 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID 		Int Null,
	OTCBuySell2 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod2 		SmallDateTime Null,
	OTCWeight2 		Float Null,
	OTCRow2 		Int Null,
	OTCPriceType2 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID2 		Int Null,
	OTCBuySell3 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod3 		SmallDateTime Null,
	OTCWeight3 		Float Null,
	OTCRow3 		Int Null,
	OTCPriceType3 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID3 		Int Null,
	PayOut 		Float Null,
	BarrierPrice 		Float Null,
	KnockOutStatus 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	BarrierType 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OptionRiskID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskResultsOptions (RiskID)

Create Table #RiskResultsMtI
(
	Idnty 		Int identity ,
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskDealDetailMarketOverrideID 		Int Null,
	DealDetailMarketOverrideID 		Int Null,
	Percentage 		Float Null default 1.0,
	DealDetailID 		Int Null,
	RwPrceLcleID 		Int Null,
	RiskCurveID 		Int Null,
	MarketIndicator 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null default 'MtM',
	Position 		Decimal(38,15) Not Null default 0.0,
	Volume 		Decimal(38,15) Not Null default 0.0,
	Offset 		Float Not Null default 0.0,
	IntentType 		VarChar(13) COLLATE DATABASE_DEFAULT  Null,
	PriceTypeID 		SmallInt Null,
	CurveVETradePeriodID 		SmallInt Null,
	FromDate 		SmallDateTime Null,
	ToDate 		SmallDateTime Null,
	MtIMarketValue 		Float Null,
	MtMMarketValue 		Float Null,
	UserReviewRequired 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null default 'No',
	DlHdrID 		Int Null,
	DlDtlID 		Int Null,
	PlnndTrnsfrID 		Int Null,
	InstanceDateTime 		SmallDateTime Not Null,
	MtIPerUnitValue 		Float Not Null default 0.0,
	TotalTransferPositionForIntent 		Float Null,
	TotalIntentPosition 		Float Null,
	TotalTransferCount 		Int Null,
	TotalIntentCount 		Int Null,
	FXRate 		Float Not Null default 1.0,
	MarketInfoMissing 		Bit Not Null default 0,
	MarketCurrencyID 		Int Null,
	Description 		VarChar(1000) COLLATE DATABASE_DEFAULT  Null,
	ReferenceDate 		SmallDateTime Null
 	Primary Key(Idnty)
)

Create NonClustered Index IE_#RiskResultsMtI_RiskID on #RiskResultsMtI (RiskID)

Create Table #RiskResultsPL
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	SourceTable 		Char(3) COLLATE DATABASE_DEFAULT  Not Null,
	Yesterday_TotalValue 		Float Not Null default 0.0,
	Yesterday_MarketValue 		Float Not Null default 0.0,
	Yesterday_MarketFXRate 		Float Not Null default 1.0,
	FiveDay_TotalValue 		Float Not Null default 0.0,
	FiveDay_MarketValue 		Float Not Null default 0.0,
	FiveDay_MarketFXRate 		Float Not Null default 1.0,
	LastWeek_TotalValue 		Float Not Null default 0.0,
	LastWeek_MarketValue 		Float Not Null default 0.0,
	LastWeek_MarketFXRate 		Float Not Null default 1.0,
	LastMonth_TotalValue 		Float Not Null default 0.0,
	LastMonth_MarketValue 		Float Not Null default 0.0,
	LastMonth_MarketFXRate 		Float Not Null default 1.0,
	LastQuarter_TotalValue 		Float Not Null default 0.0,
	LastQuarter_MarketValue 		Float Not Null default 0.0,
	LastQuarter_MarketFXRate 		Float Not Null default 1.0,
	LastYear_TotalValue 		Float Not Null default 0.0,
	LastYear_MarketValue 		Float Not Null default 0.0,
	LastYear_MarketFXRate 		Float Not Null default 1.0,
	CurrentPnL 		Float Not Null default 0.0,
	ReferencePnL 		Float Not Null default 0.0,
	PreviousDayPnL 		Float Null default 0.0,
	DayToDayProfitLoss 		Float Not Null default 0.0,
	FiveDaysToDateProfitLoss 		Float Not Null default 0.0,
	WeekToDateProfitLoss 		Float Not Null default 0.0,
	MonthToDateProfitLoss 		Float Not Null default 0.0,
	QuarterToDateProfitLoss 		Float Not Null default 0.0,
	YearToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayMonthToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayQuarterToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayYearToDateProfitLoss 		Float Not Null default 0.0,
	HistoricalPnLExists 		Bit Not Null default 0,
	Percentage 		Float Not Null default 1.0,
	IsEstMovementWithFuturePricing_Balance 		Bit Not Null default 0,
	IsPriorMonthTransaction 		Bit Not Null default 0,
	Ref_ConversionCrrncyID 		Int Null,
	Ref_MarketCrrncyID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskResultsPL (RiskID)

Create Table #RiskResultsSnapshot
(
	RetrievedSnapshot 		Int Null,
	RetrievedCreationDate 		SmallDateTime Null,
	RetrievedDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	RetrievedAccountingStartDate 		SmallDateTime Null,
	RetrievedTradeStartDate 		SmallDateTime Null,
	RetrievedCloseOfBusiness 		SmallDateTime Null,
	DayToDaySnapshot 		Int Null,
	DayToDayCreationDate 		SmallDateTime Null,
	DayToDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	DayToDayCloseOfBus 		SmallDateTime Null,
	FiveDaySnapshot 		Int Null,
	FiveDayCreationDate 		SmallDateTime Null,
	FiveDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	FiveDayCloseOfBus 		SmallDateTime Null,
	WeekToDateSnapshot 		Int Null,
	WeekToDateCreationDate 		SmallDateTime Null,
	WeekToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	WeekToDateCloseOfBus 		SmallDateTime Null,
	MonthToDateSnapshot 		Int Null,
	MonthToDateCreationDate 		SmallDateTime Null,
	MonthToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	MonthToDateCloseOfBus 		SmallDateTime Null,
	QtrToDateSnapshot 		Int Null,
	QtrToDateCreationDate 		SmallDateTime Null,
	QtrToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	QtrToDateCloseOfBus 		SmallDateTime Null,
	YearToDateSnapshot 		Int Null,
	YearToDateCreationDate 		SmallDateTime Null,
	YearToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	YearToDateCloseOfBus 		SmallDateTime Null
)

Create Index RiskRetrievedSnapshot on #RiskResultsSnapshot (RetrievedSnapshot)

Create Table #RiskResultsSwap
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RelatedSwapRiskID 		Int Null,
	RiskSourceValueId 		Int Null,
	BuySell 		Char(4) COLLATE DATABASE_DEFAULT  Null,
	Product 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	Location 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	Period 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	BuyProvision 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	SellProvision 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	SwapBuySellPosition 		Float Not Null default 0.0,
	BuyProduct 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellProduct 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyLocale 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellLocale 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyPeriod 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellPeriod 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyIsFixed 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	SellIsFixed 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwIds 		VarChar(500) COLLATE DATABASE_DEFAULT  Null,
	PricedInPercentage 		Float Null,
	RiskBuySell 		Char(4) COLLATE DATABASE_DEFAULT  Null,
	CombineSwap 		Bit Not Null default 1,
	DeleteRow 		Bit Not Null default 0,
	InstanceDateTime 		SmallDateTime Null,
	ExpiredRiskRow 		Bit Null default 0
)

Create NonClustered Index IE_#RiskResultsSwap_RiskID on #RiskResultsSwap (RiskID)

Create Table #RiskResultsValue
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	OneDayAgoDealValue 		Float Null default 0.0,
	OneDayAgoMarketValue 		Float Null default 0.0,
	OneDayAgoFX 		Float Null default 1.0,
	OneDayAgoDealFX 		Float Null default 1.0,
	FiveDaysAgoDealValue 		Float Null default 0.0,
	FiveDaysAgoMarketValue 		Float Null default 0.0,
	FiveDaysAgoFX 		Float Null default 1.0,
	FiveDaysAgoDealFX 		Float Null default 1.0,
	LastWeekDealValue 		Float Null default 0.0,
	LastWeekMarketValue 		Float Null default 0.0,
	LastWeekFX 		Float Null default 1.0,
	LastWeekDealFX 		Float Null default 1.0,
	LastMonthDealValue 		Float Null default 0.0,
	LastMonthMarketValue 		Float Null default 0.0,
	LastMonthFX 		Float Null default 1.0,
	LastMonthDealFX 		Float Null default 1.0,
	LastQuarterDealValue 		Float Null default 0.0,
	LastQuarterMarketValue 		Float Null default 0.0,
	LastQuarterFX 		Float Null default 1.0,
	LastQuarterDealFX 		Float Null default 1.0,
	LastYearDealValue 		Float Null default 0.0,
	LastYearMarketValue 		Float Null default 0.0,
	LastYearFX 		Float Null default 1.0,
	LastYearDealFX 		Float Null default 1.0
)

Create NonClustered Index RiskIndex on #RiskResultsValue (RiskID)

Create Table #RiskResultsPosition
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	OneDayAgoPosition 		Decimal(38,15) Null default 0.0,
	OneDayAgoSpecificGravity 		Decimal(38,15) Null default 1.0,
	OneDayAgoEnergy 		Decimal(38,15) Null default 1.0,
	FiveDaysAgoPosition 		Decimal(38,15) Null default 0.0,
	FiveDaysAgoSpecificGravity 		Decimal(38,15) Null default 1.0,
	FiveDaysAgoEnergy 		Decimal(38,15) Null default 1.0,
	LastWeekPosition 		Decimal(38,15) Null default 0.0,
	LastWeekSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastWeekEnergy 		Decimal(38,15) Null default 1.0,
	LastMonthPosition 		Decimal(38,15) Null default 0.0,
	LastMonthSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastMonthEnergy 		Decimal(38,15) Null default 1.0,
	LastQuarterPosition 		Decimal(38,15) Null default 0.0,
	LastQuarterSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastQuarterEnergy 		Decimal(38,15) Null default 1.0,
	LastYearPosition 		Decimal(38,15) Null default 0.0,
	LastYearSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastYearEnergy 		Decimal(38,15) Null default 1.0,
	OptionExercisedEndOfDay 		SmallDateTime Null,
	OptionExercisedIDT 		SmallDateTime Null
)

Create NonClustered Index RiskIndex on #RiskResultsPosition (RiskID)

Create Table #RiskMtMExposure
(
	RiskID 		Int Null,
	RiskResultsTableIdnty 		Int Null,
	DisaggregateRiskType 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	FormulaExists 		Bit Not Null default 1,
	BasisExposureRiskCurveID 		Int Null,
	BasisExposureRwPrceLcleID 		Int Null,
	BasisExposureDlDtlPrvsnRwID 		Int Null,
	BasisExposurePeriodStartDate 		SmallDateTime Null,
	BasisExposurePeriodEndDate 		SmallDateTime Null,
	BasisExposureQuoteCount 		Int Null,
	BasisExposureQuoteStart 		SmallDateTime Null,
	BasisExposureQuoteEnd 		SmallDateTime Null,
	FlatExposureRiskCurveID 		Int Null,
	FlatExposureRwPrceLcleID 		Int Null,
	FlatExposureDlDtlPrvsnRwID 		Int Null,
	FlatExposurePeriodStartDate 		SmallDateTime Null,
	FlatExposurePeriodEndDate 		SmallDateTime Null,
	FlatExposurePricedInPercentage 		Int Null,
	FlatExposureQuoteCount 		Int Null,
	FlatExposureQuoteStart 		SmallDateTime Null,
	FlatExposureQuoteEnd 		SmallDateTime Null,
	FlatExposureRollOnDate 		SmallDateTime Null,
	FlatExposureRollOffDate 		SmallDateTime Null,
	GradeDiffExpRiskCurveID 		Int Null,
	GradeDiffExpRwPrceLcleID 		Int Null,
	GradeDiffExpDlDtlPrvsnRwID 		Int Null,
	GradeDiffExpPeriodStartDate 		SmallDateTime Null,
	GradeDiffExpPeriodEndDate 		SmallDateTime Null,
	GradeDiffExpQuoteCount 		Int Null,
	GradeDiffExpQuoteStart 		SmallDateTime Null,
	GradeDiffExpQuoteEnd 		SmallDateTime Null,
	RollOnDate 		SmallDateTime Null,
	RollOffDate 		SmallDateTime Null
)

Create Table #FinalResultsMtM
(
	RiskResultsIdnty 		Int Null,
	RiskID 		Int Null,
	Description 		VarChar(2000) COLLATE DATABASE_DEFAULT  Null,
	DlDtlID 		Int Null,
	InternalBAID 		Int Null,
	ExternalBAID 		Int Null,
	UserID 		Int Null,
	DlDtlCrtnDte 		SmallDateTime Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	DeliveryPeriodStartDate 		SmallDateTime Null,
	DeliveryPeriodEndDate 		SmallDateTime Null,
	AccountingPeriodStartDate 		SmallDateTime Null,
	CloseOfBusiness 		SmallDateTime Null,
	StrtgyID 		Int Null,
	PricedInPercentage 		Float Null,
	Position 		Float Null,
	PricedPosition 		Float Null,
	FloatPosition 		Float Null,
	PricedPnL 		Float Null,
	TotalPnL 		Float Null,
	FloatPnl 		Float Null,
	FloatValue 		Float Null,
	SpecificGravity 		Float Null,
	Energy 		Float Null,
	DefaultCurrencyID 		Int Null,
	AggregationGroupName 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	AttachedInHouse 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	TotalValue 		Float Null,
	PricedValue 		Float Null,
	MarketValue 		Float Null,
	MaxPeriodStartDate 		SmallDateTime Null,
	MarketValueIsMissing 		Bit Null,
	DealValueIsMissing 		Bit Null,
	DlDtlTmplteID 		Int Null,
	PerUnitValue 		Float Null,
	MarketPerUnitValue 		Float Null,
	MarketCrrncyID 		Int Null,
	PaymentCrrncyID 		Int Null,
	MarketValueFXRate 		Float Null,
	TotalValueFXRate 		Float Null,
	PricedValueFXRate 		Float Null,
	IsSwap 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	InstanceDateTime 		SmallDateTime Null,
	ConversionCrrncyID 		Int Null,
	RiskResultsMtIIdnty 		Int Null,
	RiskAdjustmentID 		Int Null,
	ConversionDeliveryPeriodID 		SmallInt Null,
	MarketValueFXConversionDate 		SmallDateTime Null,
	DealValueFXConversionDate 		SmallDateTime Null
)

Create NonClustered Index IE_#FinalResultsMtM_RiskID_DlDtlTmplteID on #FinalResultsMtM (RiskID,DlDtlTmplteID)

Create NonClustered Index ID_#FinalResultsMtM_RiskID_InstanceDateTime_IsPriorMonthTransaction on #FinalResultsMtM (RiskID, InstanceDateTime )

-- Physical Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsRemittable] = 0
And	[Risk].[SourceTable] <> 'B'
And	[Risk].[SourceTable] <> 'S'
And	[Risk].[SourceTable] <> 'ES'
And	[Risk].[SourceTable] <> 'EB'
And	[Risk].[CostSourceTable] <> 'IV'
And	[Risk].[CostSourceTable] <> 'S'
And	(Risk.IsWriteOnWriteOff = Convert(Bit, 0) or Risk. SourceTable In('EIX','EIP','I'))
And	( IsNull(Risk.DlDtlTmplteId, 0) Not In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103)Or Not (IsNull(Risk. DlDtlTmplteID, 0) In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103) And Risk.SourceTable = 'A'And Risk.AccountingPeriodStartDate < @TradePeriodStartDate

))
And	[Risk].[CostSourceTable] <> 'ML'
And	 (IsNull(Risk. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or Risk.SourceTable In ('EIX','EIP') )
And	1 = Case When Risk.SourceTable = 'P' And Risk.DeliveryPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00'

 Then 1 

 When IsNull(Risk. InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate)	Between @TradePeriodStartDate and '2076-05-31 23:59:00'

 Then 1 Else 0 End


And	((

( Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' Or Risk.AccountingPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' )

And ( Risk. AccountingPeriodStartDate >= @TradePeriodStartDate )

)

)


And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- PPA Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsRemittable] = 0
And	[Risk].[SourceTable] <> 'B'
And	[Risk].[SourceTable] <> 'S'
And	[Risk].[SourceTable] <> 'ES'
And	[Risk].[SourceTable] <> 'EB'
And	[Risk].[CostSourceTable] <> 'IV'
And	[Risk].[CostSourceTable] <> 'S'
And	(Risk.IsWriteOnWriteOff = Convert(Bit, 0) or Risk. SourceTable In('EIX','EIP','I'))
And	Risk.SourceTable <> 'T'
And	IsNull(Risk. InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate)	< @TradePeriodStartDate
And	( Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' Or Risk. AccountingPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00')
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- Balances Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsInventory] = 1
And	Risk.SourceTable In('S','EB')
And	( Risk.DeliveryPeriodStartDate Between @TradePeriodStartDate and @InventoryTradePeriodEnd)
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- Select * From #RiskResults

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = 'Select	Top 1 ''Y''
From	RiskDealIdentifier(NoLock) OtherDealSide
	inner Join Risk(NoLock) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NoLock) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk.IsInventory,Risk.DlDtlTmplteID,Risk Transfer.SchdlngPrdID,Risk Deal Detail.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.PlannedTransfer.PTParcelNumber,Risk Deal Link.PlannedTransfer.PTReceiptDelivery,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,Risk.TrnsctnTypID,Risk Transfer.PlnndTrnsfrID,{Calculated Columns}.CloseOfBusiness,{Calculated Columns}.Snapshot,Risk Deal Detail.DlDtlCrtnDte,Risk Deal Price.(First Row) RiskDealDetailProvisionRow.FormulaOffset,Risk Deal Detail.DlHdrStat,Risk Deal Detail.DlDtlDsplyUOM,Risk Deal Detail.NegotiatedDate,{Calculated Columns}.IsPrimaryCost,Risk Deal Price Source.RiskDealDetailProvision.(First Row) RiskDealDetailProvisionRow.RawPriceLocale.RPLcleIntrfceCde,Risk Deal Link.DealHeader.GeneralConfiguration.AccountingTreatment,Risk Deal Detail.DealDetail.DlDtlMthdTrnsprttn',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = @StartedFromVETradePeriodID,@vc_InternalBAID = '20',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_DeleteZeroPnLRows = True

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = 'Select	Top 1 ''Y''
From	RiskDealIdentifier(NoLock) OtherDealSide
	inner Join Risk(NoLock) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NoLock) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk.IsInventory,Risk.DlDtlTmplteID,Risk Transfer.SchdlngPrdID,Risk Deal Detail.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.PlannedTransfer.PTParcelNumber,Risk Deal Link.PlannedTransfer.PTReceiptDelivery,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,Risk.TrnsctnTypID,Risk Transfer.PlnndTrnsfrID,{Calculated Columns}.CloseOfBusiness,{Calculated Columns}.Snapshot,Risk Deal Detail.DlDtlCrtnDte,Risk Deal Price.(First Row) RiskDealDetailProvisionRow.FormulaOffset,Risk Deal Detail.DlHdrStat,Risk Deal Detail.DlDtlDsplyUOM,Risk Deal Detail.NegotiatedDate,{Calculated Columns}.IsPrimaryCost,Risk Deal Price Source.RiskDealDetailProvision.(First Row) RiskDealDetailProvisionRow.RawPriceLocale.RPLcleIntrfceCde,Risk Deal Link.DealHeader.GeneralConfiguration.AccountingTreatment,Risk Deal Detail.DealDetail.DlDtlMthdTrnsprttn',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = @StartedFromVETradePeriodID,@vc_InternalBAID = '20',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_IsFinalSelect = True,@b_DeleteZeroPnLRows = True

Select	[Risk].[RiskID]
	,[#FinalResultsMtM].[Description]
	,[#FinalResultsMtM].[DlDtlID]
	,[#FinalResultsMtM].[PrdctID]
	,[#FinalResultsMtM].[LcleID]
	,[#FinalResultsMtM].[DeliveryPeriodStartDate]
	,[#FinalResultsMtM].[AccountingPeriodStartDate]
	,[#FinalResultsMtM].[InternalBAID]
	,[#FinalResultsMtM].[ExternalBAID]
	,[#FinalResultsMtM].[UserID]
	,[#FinalResultsMtM].[StrtgyID]
	,[#FinalResultsMtM].[PricedInPercentage]
	,[#FinalResultsMtM].[Position]
	,[#FinalResultsMtM].[TotalValue]
	,[#FinalResultsMtM].[MarketValue]
	,[#FinalResultsMtM].[TotalPnL]
	,[#FinalResultsMtM].[PricedPnL]
	,[#FinalResultsMtM].[FloatPnl]
	,[#FinalResultsMtM].[PricedValue]
	,[#FinalResultsMtM].[FloatValue]
	,[#FinalResultsMtM].[PricedPosition]
	,[#FinalResultsMtM].[FloatPosition]
	,[#FinalResultsMtM].[PerUnitValue]
	,[#FinalResultsMtM].[MarketPerUnitValue]
	,[#FinalResultsMtM].[DlDtlTmplteID]
	,[#FinalResultsMtM].[AggregationGroupName]
	,[#FinalResultsMtM].[CloseOfBusiness]
	,[#FinalResultsMtM].[AttachedInHouse]
	,[#FinalResultsMtM].[ChmclID]
	,[#FinalResultsMtM].[MaxPeriodStartDate]
	,[#FinalResultsMtM].[MarketValueIsMissing]
	,[#FinalResultsMtM].[DealValueIsMissing]
	,[#FinalResultsMtM].[MarketCrrncyID]
	,[#FinalResultsMtM].[MarketValueFXRate]
	,[#FinalResultsMtM].[PaymentCrrncyID]
	,[#FinalResultsMtM].[TotalValueFXRate]
	,[#FinalResultsMtM].[PricedValueFXRate]
	,[#FinalResultsMtM].[DefaultCurrencyID]
	,[#FinalResultsMtM].[SpecificGravity]
	,[#FinalResultsMtM].[Energy]
	,[#FinalResultsMtM].[DeliveryPeriodEndDate]
	,[#FinalResultsMtM].[ConversionCrrncyID]
	,[#FinalResultsMtM].[RiskAdjustmentID]
	,[#FinalResultsMtM].[ConversionDeliveryPeriodID]
	,[#FinalResultsMtM].[MarketValueFXConversionDate]
	,[#FinalResultsMtM].[DealValueFXConversionDate]
	,[{Calculated Columns}].[SourceTable]
	,SnapshotIsArchived
	,Convert(DateTime, @SnapshotInstanceDateTime) [SnapshotInstanceDateTime]
	,1540 [SnapshotID]
	,(Select	Top 1 'Y'
From	RiskDealIdentifier OtherDealSide
	inner Join Risk OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID) [Subselect_Dyn52]
	,[Risk].[IsInventory] [IsInventory_Dyn54]
	,[Risk].[DlDtlTmplteID] [DlDtlTmplteID_Dyn56]
	,[Risk Transfer].[SchdlngPrdID] [SchdlngPrdID_Dyn57]
	,[GC19_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn58]
	,[GC21_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn60]
	,[PT22_Dyn].[PTParcelNumber] [PTParcelNumber_Dyn59]
	,[PT22_Dyn].[PTReceiptDelivery] [PTReceiptDelivery_Dyn60]
	,[Risk].[InventoryAccountingPeriodStartDate] [InventoryAccountingPeriodStartDate_Dyn61]
	,[Risk Deal Detail].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn62]
	,[Risk].[TrnsctnTypID] [TrnsctnTypID_Dyn63]
	,[Risk Transfer].[PlnndTrnsfrID] [PlnndTrnsfrID_Dyn64]
	,[{Calculated Columns}].[CloseOfBusiness] [CloseOfBusiness_Dyn65]
	,[{Calculated Columns}].[Snapshot] [Snapshot_Dyn66]
	,[Risk Deal Detail].[DlDtlCrtnDte] [DlDtlCrtnDte_Dyn67]
	,[RDPR23_Dyn].[FormulaOffset] [FormulaOffset_Dyn75]
	,[Risk Deal Detail].[DlHdrStat] [DlHdrStat_Dyn71]
	,[Risk Deal Detail].[DlDtlDsplyUOM] [DlDtlDsplyUOM_Dyn72]
	,[Risk Deal Detail].[NegotiatedDate] [NegotiatedDate_Dyn73]
	,[{Calculated Columns}].[IsPrimaryCost] [IsPrimaryCost_Dyn74]
	,[RPL26_Dyn].[RPLcleIntrfceCde] [RPLcleIntrfceCde_Dyn73]
	,[GC27_Dyn].[GnrlCnfgMulti] [AccountingTreatment_Dyn74]
	,[DD18_Dyn].[DlDtlMthdTrnsprttn] [DlDtlMthdTrnsprttn_Dyn75]
	,Cast(3 AS SmallInt) [AutoGeneratedBaseUOM]
	,Cast(19 AS Int) [AutoGeneratedBaseCurrency]
INTO #temp_MTM
From	[#FinalResultsMtM] (NoLock)
	Join [#RiskResults] [{Calculated Columns}] (NoLock) On
		[{Calculated Columns}]. Idnty = #FinalResultsMtM. RiskResultsIdnty
	Join [Risk] (NoLock) On
			[{Calculated Columns}].[RiskID] = [Risk].[RiskID]
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link]. DlHdrID = [Risk Deal Detail]. DlHdrID and [Risk Deal Link]. DlDtlID = [Risk Deal Detail]. DlDtlID And	[{Calculated Columns}]. InstanceDateTime	Between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate And	[Risk Deal Detail]. SrceSystmID	= [Risk Deal Link].ExternalType
	Left Join [LeaseDealDetail] [Lease Deal Detail] (NoLock) On
			[{Calculated Columns}].[LeaseDealDetailID] = [Lease Deal Detail].[LeaseDealDetailID]
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source]. DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
	Left Join [RiskPlannedTransfer] [Risk Transfer] (NoLock) On
		[Risk Deal Link]. PlnndTrnsfrID = [Risk Transfer]. PlnndTrnsfrID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Transfer].StartDate and [Risk Transfer].EndDate and ([Risk]. ChmclID = [Risk Transfer]. ChmclChdPrdctID Or [Risk Transfer]. ChmclChdPrdctID = [Risk Transfer].ChmclParPrdctID)
	Left Join [#RiskResultsPL] [{Calculated P/L Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated P/L Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsOptions] [{Option Information Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Option Information Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsPosition] [{Calculated Position Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Position Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsValue] [{Calculated Value Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Value Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSwap] [{Calculated Swap Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Swap Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsMtI] [{Mark to Intent Columns}] (NoLock) On
			[#FinalResultsMtM].[RiskResultsMtIIdnty] = [{Mark to Intent Columns}].[Idnty]
	Left Join [#RiskMtMExposure] [{Calculated Exposure Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Exposure Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSnapshot] [{Snapshot Information Columns}] (NoLock) On
		1 = 1
	Left Join [DealDetail] [DD18_Dyn] (NoLock) On
		[Risk Deal Detail].DealDetailID = [DD18_Dyn].DealDetailID
	Left Join [GeneralConfiguration] [GC19_Dyn] (NoLock) On
		[DD18_Dyn].DlDtlDlHdrID = [GC19_Dyn].GnrlCnfgHdrID And [DD18_Dyn].DlDtlID = [GC19_Dyn].GnrlCnfgDtlID And [GC19_Dyn].GnrlCnfgTblNme = 'DealDetail' And [GC19_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC19_Dyn].GnrlCnfgHdrID <> 0
	Left Join [DealHeader] [DH20_Dyn] (NoLock) On
		[Risk Deal Link].DlHdrID = [DH20_Dyn].DlHdrID and [Risk Deal Link].DealDetailID is not null
	Left Join [GeneralConfiguration] [GC21_Dyn] (NoLock) On
		[DH20_Dyn].DlHdrID = [GC21_Dyn].GnrlCnfgHdrID And [GC21_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC21_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC21_Dyn].GnrlCnfgHdrID <> 0
	Left Join [PlannedTransfer] [PT22_Dyn] (NoLock) On
		[Risk Deal Link].PlnndTrnsfrID = [PT22_Dyn].PlnndTrnsfrID
	Left Join [RiskDealDetailProvisionRow] [RDPR23_Dyn] (NoLock) On
		[Risk Deal Price].FirstRowFormulaDlDtlPrvsnRwID = [RDPR23_Dyn].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [RDPR23_Dyn].StartDate and [RDPR23_Dyn].EndDate
	Left Join [RiskDealDetailProvision] [RDPV24_Dyn] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [RDPV24_Dyn]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [RDPV24_Dyn].StartDate and [RDPV24_Dyn].EndDate
	Left Join [RiskDealDetailProvisionRow] [RDPR25_Dyn] (NoLock) On
		[RDPV24_Dyn].FirstRowFormulaDlDtlPrvsnRwID = [RDPR25_Dyn].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [RDPR25_Dyn].StartDate and [RDPR25_Dyn].EndDate
	Left Join [RawPriceLocale] [RPL26_Dyn] (NoLock) On
		[RDPR25_Dyn].FormulaRwPrceLcleID = [RPL26_Dyn].RwPrceLcleID
	Left Join [GeneralConfiguration] [GC27_Dyn] (NoLock) On
		[DH20_Dyn].DlHdrID = [GC27_Dyn].GnrlCnfgHdrID And [GC27_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC27_Dyn].GnrlCnfgQlfr = 'AccountingTreatment' And [GC27_Dyn].GnrlCnfgHdrID <> 0




---Join Respective tables to get respective columns values and computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_MTM_Join') IS NOT NULL
    DROP TABLE #temp_MTM_Join


SELECT 
CONVERT(Varchar(20), [Description]) AS deal 
,CONVERT(Varchar(10), DlDtlID) AS deal_detail_id 
,CASE WHEN [DlHdrStat_Dyn71] = 'A' THEN 'Active'
		WHEN [DlHdrStat_Dyn71] = 'C' THEN 'Canceled' END status  
,CloseofBusiness  AS end_of_day
,CloseofBusiness  AS close_of_business
,[NegotiatedDate_Dyn73]  AS trade_date 
,[DlDtlRvsnDte_Dyn62]  AS revision_date  
,[DlDtlCrtnDte_Dyn67]  AS creation_date 
,[DeliveryPeriodStartDate]  AS delivery_period  
,[DeliveryPeriodStartDate]  AS delivery_period_group  
,HedgeMonth_Dyn60 AS hedge_month 
,[AccountingPeriodStartDate]  AS accounting_period 
, [HedgeMonth_Dyn58] AS deal_detail_hedge_month    
,(SELECT [FromDate] FROM [dbo].[SchedulingPeriod](NOLOCK) WHERE [SchdlngPrdID] = [SchdlngPrdID_Dyn57]) AS scheduling_period
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS product
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = t.LcleID) AS location
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.InternalBAID) AS our_company
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.ExternalBAID) AS their_company
,(SELECT CntctFrstNme + ' ' +CntctLstNme FROM [dbo].Users(NOLOCK) U 
	INNER JOIN Contact(NOLOCK) C ON U.UserCntctID = C.CntCtID 
	WHERE U.UserID = t.UserID) AS trader
,(SELECT [Name] FROM [dbo].[StrategyHeader](NOLOCK) SH WHERE SH.StrtgyID = t.StrtgyID) AS strategy
,[AggregationGroupName] AS portfolio_position_group
,Convert(Varchar(20), (Round(PricedInPercentage*100,2))) + '%' AS priced_percentage
,Position AS position
,[TotalValue] AS total_value
,(SELECT UOMAbbv FROM UnitOfMeasure(NOLOCK) UOM WHERE UOM.UOM = t.DlDtlDsplyUOM_Dyn72) AS uom
,[MarketValue] AS market_value
,[TotalPnL] AS profit_loss
,[PricedPnL] AS priced_profit_loss
,[FloatPnl] AS float_profit_loss
,[PricedValue] AS priced_value
,[FloatValue] AS float_value
,[PricedPosition] AS priced_position
,[FloatPosition] AS float_position
,[PerUnitValue] AS per_unit_value
,[MarketPerUnitValue] AS market_per_unit_value
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) AS detail_template
,CASE WHEN [AttachedInHouse] = 'N' THEN 'No'
	ELSE 'Yes' END AS attached_inhouse
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS chemical
,CASE WHEN [MarketValueIsMissing] = 0 THEN 'No'
		ELSE 'Yes' END AS missing_market_value
,CASE WHEN [DealValueIsMissing] = 0 THEN 'No'
		ELSE 'Yes' END AS missing_deal_value
, CONVERT(DECIMAL(10,2),[MarketValueFXRate])  AS market_fx_rate
,CONVERT(DECIMAL(10,2),[TotalValueFXRate]) AS total_value_fx_rate
,CONVERT(DECIMAL(10,2),[PricedValueFXRate]) AS priced_value_fx_rate
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.[MarketCrrncyID]) AS market_currency
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.[PaymentCrrncyID]) AS payment_currency
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.DefaultCurrencyID) AS base_currency
,CASE WHEN t.SourceTable = 'P' THEN 'Planned Transfer'
	WHEN t.SourceTable = 'A' THEN 'Accounting Transaction'
	WHEN t.SourceTable = 'I' THEN 'Inventory Change'
	WHEN t.SourceTable = 'X' THEN 'Movement Transaction'
	WHEN t.SourceTable = 'O' THEN 'Obligation'
	WHEN t.SourceTable = 'E' THEN 'External Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'N' THEN 'NA'
	WHEN t.SourceTable = 'B' THEN 'Estimated Balance'
	WHEN t.SourceTable = 'L' THEN 'Planned Expense'
	WHEN t.SourceTable = 'T' THEN 'Time Based Estimated Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'EP' THEN 'External Estimated Movement'
	WHEN t.SourceTable = 'EX' THEN 'External Movement'
	WHEN t.SourceTable = 'EA' THEN 'External Actual'
	WHEN t.SourceTable = 'EIP' THEN 'External Estimated Inventory Change'
	WHEN t.SourceTable = 'EIX' THEN 'External Actual Inventory Change'
	WHEN t.SourceTable = 'H' THEN 'Hedging Detail'
	END source
,CASE WHEN [IsInventory_Dyn54] = 1 THEN 'Yes' 
		ELSE 'No' END inventory
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT1 WHERE DDT1.[DlDtlTmplteID] = T.[DlDtlTmplteID_Dyn56]) AS deal_detail_template 
,t.[PTReceiptDelivery_Dyn60] AS receipt_delivery
,CAST(CASE WHEN t.[PTParcelNumber_Dyn59] = '' THEN NULL ELSE t.[PTParcelNumber_Dyn59] END AS DECIMAL(10,2)) AS parcel_no
,t.[AccountingTreatment_Dyn74] AS accounting_treatment
,(SELECT [TrnsctnTypDesc] FROM [dbo].[TransactionType](NOLOCK) TTY WHERE TTY.[TrnsctnTypID] = t.[TrnsctnTypID_Dyn63]) AS transaction_type
,(SELECT [DynLstBxAbbv] 
	FROM [DynamicListBox](NOLOCK) DLB WHERE T.DlDtlMthdTrnsprttn_Dyn75 = DLB.DynLstBxTyp 
		AND DynLstBxQlfr = 'TransportationMethod' ) AS method_of_transportation
, t.[RPLcleIntrfceCde_Dyn73] AS interface_code
,CONVERT(VARCHAR(10), t.[PlnndTrnsfrID_Dyn64]) AS transfer_id 
,CONVERT(VARCHAR(10),t.[Snapshot_Dyn66]) AS snapshot_id
,CONVERT(VARCHAR(10), t.[RiskID]) AS risk_id
,t.[FormulaOffset_Dyn75] AS offset
,CASE WHEN t.[IsPrimaryCost_Dyn74] = 1 THEN 'Yes'
	ELSE 'No' END calc_is_primary_cost
,Iif(t.[PTParcelNumber_Dyn59] Is Null Or t.[PTParcelNumber_Dyn59] = '(Empty)' Or t.[PTParcelNumber_Dyn59] = '', 
	Iif(CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) Is Null Or CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) = '(Empty)' Or CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) = '', 
		Iif(CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) Is Null Or CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) = '(Empty)' Or CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) = '', 
		Iif(CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) Is Null Or CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) = '(Empty)' Or CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) = '', CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101), CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101)), 
		CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61],101)) 
	,CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101))
, t.[PTParcelNumber_Dyn59])
AS calc_program_month
,CAST(DATEPART(MM,[DeliveryPeriodStartDate]) AS VARCHAR(10))+'/1/'+CAST(DATEPART(YYYY,[DeliveryPeriodStartDate]) AS VARCHAR(10)) AS calc_delivery_month
,Iif([AttachedInHouse] = 'N' And [IsInventory_Dyn54] = '1', 'True', 'False') AS calc_is_inventory
,(
Select	Top 1 'Y'
From	RiskDealIdentifier(NOLOCK) AS OtherDealSide
	inner Join Risk(NOLOCK) AS OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	t.DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = (SELECT DlHdrID FROM DealHeader(NOLOCK) WHERE DlHdrIntrnlNbr = t.[Description])
) AS calc_involves_inventory_book
,'' AS [InventoryBuySaleBuildDraw]
,'' AS [RiskCategory]
,Iif((SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%Fut%' 
	Or (SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%EFP Paper%', 'Future', 
		Iif((SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%Swap%', 'Swap', 'Error'))
AS calc_future_swap
INTO #temp_MTM_Join
FROM #temp_MTM t



---Final load into temp tables with calculated columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_MTM_Final') IS NOT NULL
    DROP TABLE #temp_MTM_Final

SELECT 
deal
,deal_detail_id
,status
,end_of_day
,close_of_business
,trade_date
,revision_date
,creation_date
,delivery_period
,delivery_period_group
,hedge_month
,accounting_period
,deal_detail_hedge_month
,scheduling_period
,product
,location
,our_company
,their_company
,trader
,strategy
,portfolio_position_group
,priced_percentage
,position
,total_value
,uom
,market_value
,profit_loss
,priced_profit_loss
,float_profit_loss
,priced_value
,float_value
,priced_position
,float_position
,per_unit_value
,market_per_unit_value
,detail_template
,attached_inhouse
,chemical
,missing_market_value
,missing_deal_value
,market_fx_rate
,total_value_fx_rate
,priced_value_fx_rate
,market_currency
,payment_currency
,base_currency
,source
,inventory
,deal_detail_template
,receipt_delivery
,parcel_no
,accounting_treatment
,transaction_type
,method_of_transportation
,interface_code
,transfer_id
,snapshot_id
,risk_id
,offset
,calc_is_primary_cost
,calc_program_month
,calc_delivery_month
,calc_is_inventory
,calc_involves_inventory_book
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory'
  , Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', Iif(attached_inhouse = 'Y' And receipt_delivery = 'D', 'Buy-Internal'
    , Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', Iif(deal_detail_template In ('Inhouse Delivery'), 'Sale-Internal'
       , Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party'
           ,Iif(receipt_delivery = 'R' And inventory = 'True', 'Draw', Iif(receipt_delivery = 'D' And inventory = 'True', 'Build'
		     , Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt', 'Future Detail'), 'Paper', 'UNKNOWN')))))))))
AS
calc_inventory_buy_sale_build_draw
,[RiskCategory]
,calc_future_swap
INTO #temp_MTM_Final
FROM #temp_MTM_Join(NOLOCK)

---Insert Data into Custom Tables



SET NOCOUNT ON;
SET ansi_warnings OFF;

INSERT INTO [db_datareader].[MTVTempMarkToMarket] with (tablockx)
(
[deal]
      ,[deal_detail_id]
      ,[status]
      ,[end_of_day]
      ,[close_of_business]
      ,[trade_date]
      ,[revision_date]
      ,[creation_date]
      ,[delivery_period]
      ,[delivery_period_group]
      ,[hedge_month]
      ,[accounting_period]
      ,[deal_detail_hedge_month]
      ,[scheduling_period]
      ,[product]
      ,[location]
      ,[our_company]
      ,[their_company]
      ,[trader]
      ,[strategy]
      ,[portfolio_position_group]
      ,[priced_percentage]
      ,[position]
      ,[total_value]
      ,[uom]
      ,[market_value]
      ,[profit_loss]
      ,[priced_profit_loss]
      ,[float_profit_loss]
      ,[priced_value]
      ,[float_value]
      ,[priced_position]
      ,[float_position]
      ,[per_unit_value]
      ,[market_per_unit_value]
      ,[detail_template]
      ,[attached_inhouse]
      ,[chemical]
      ,[missing_market_value]
      ,[missing_deal_value]
      ,[market_fx_rate]
      ,[total_value_fx_rate]
      ,[priced_value_fx_rate]
      ,[market_currency]
      ,[payment_currency]
      ,[base_currency]
      ,[source]
      ,[inventory]
      ,[deal_detail_template]
      ,[receipt_delivery]
      ,[parcel_no]
      ,[accounting_treatment]
      ,[transaction_type]
      ,[method_of_transportation]
      ,[interface_code]
      ,[transfer_id]
      ,[snapshot_id]
      ,[risk_id]
      ,[offset]
      ,[calc_is_primary_cost]
      ,[calc_program_month]
      ,[calc_delivery_month]
      ,[calc_is_inventory]
      ,[calc_involves_inventory_book]
      ,[calc_inventory_buy_sale_build_draw]
      ,[RiskCategory]
      ,[calc_future_swap]

)
SELECT 
deal
,deal_detail_id
,status
,end_of_day
,close_of_business
,trade_date
,revision_date
,creation_date
,delivery_period
,delivery_period_group
,hedge_month
,accounting_period
,deal_detail_hedge_month
,scheduling_period
,product
,location
,our_company
,REPLACE(their_company, ',', '') AS their_company
,trader
,strategy
,portfolio_position_group
,priced_percentage
,position
,total_value
,uom
,market_value
,profit_loss
,priced_profit_loss
,float_profit_loss
,priced_value
,float_value
,priced_position
,float_position
,per_unit_value
,market_per_unit_value
,CONVERT(VARCHAR(50), detail_template) AS detail_template
,attached_inhouse
,chemical
,missing_market_value
,missing_deal_value
,market_fx_rate
,total_value_fx_rate
,priced_value_fx_rate
,market_currency
,payment_currency
,base_currency
,source
,inventory
,CONVERT(VARCHAR(50),deal_detail_template) AS deal_detail_template
,receipt_delivery
,parcel_no
,accounting_treatment
,transaction_type
,method_of_transportation
,interface_code
,transfer_id
,snapshot_id
,risk_id
,offset
,calc_is_primary_cost
,calc_program_month
,calc_delivery_month
,calc_is_inventory
,calc_involves_inventory_book
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory'
  , Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', Iif(attached_inhouse = 'Y' And receipt_delivery = 'D', 'Buy-Internal'
    , Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', Iif(deal_detail_template In ('Inhouse Delivery'), 'Sale-Internal'
       , Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party'
           ,Iif(receipt_delivery = 'R' And inventory = 'True', 'Draw', Iif(receipt_delivery = 'D' And inventory = 'True', 'Build'
		     , Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt', 'Future Detail'), 'Paper', 'UNKNOWN')))))))))
AS
calc_inventory_buy_sale_build_draw
, Iif(calc_inventory_buy_sale_build_draw In ('Inventory', 'Build', 'Draw'), '1-Beg Inv', '') 
	+ Iif(calc_inventory_buy_sale_build_draw In ('Sale-Internal'), '3-Demand', '') + Iif(calc_inventory_buy_sale_build_draw In ('3rd Party'), '4-3rd Party', '') 
	+ Iif(calc_inventory_buy_sale_build_draw In ('Paper'), '5-Paper', '') + Iif(calc_inventory_buy_sale_build_draw In ('Buy-Internal'), '2-Supply', '') 
	+ Iif(deal = 'MOA17TP0003', '3-Demand', '') 
AS calc_risk_category
,calc_future_swap
FROM #temp_MTM_Final(NOLOCK)

END

END

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_GetTempMarkToMarket.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetTempMarkToMarket.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetTempRiskExposure.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetTempRiskExposure WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_GetTempRiskExposure]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetTempRiskExposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetTempRiskExposure] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetTempRiskExposure >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_GetTempRiskExposure]
	
-- =============================================
-- Author:		Amar Kenguva
-- Create date: 09/27/2018
-- Description:	Load latest snapshot Risk Exposure Report data into Custom Table [db_datareader].[MTVTempRiskExposure]
-- =============================================

AS
BEGIN
	
IF NOT EXISTS (SELECT TOP 1 1 FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'N' AND Purged = 'N')
BEGIN


SET NOCOUNT ON; 
	
DECLARE @i_P_EODSnpShtID Int,@SnapshotId Int, @StartedFromVETradePeriodID Int,@SnapshotInstanceDateTime SmallDateTime,@CompareSnapshotInstanceDateTime SmallDateTime,@SnapshotEndOfDay SmallDateTime
,@CompareSnapshotEndOfDay SmallDateTime,@CompareWithAnotherSnapshot Bit,@ComparisonSnapshotId Int,@1DayInstanceDateTime SmallDateTime,@5DayInstanceDateTime SmallDateTime,@WklyInstanceDateTime SmallDateTime,@MtDInstanceDateTime SmallDateTime
,@QtDInstanceDateTime SmallDateTime,@YtDInstanceDateTime SmallDateTime,@RiskReportCriteriaRetrievalOption VarChar (8000),@PositionGroupId VarChar (8000),@ProductLocationChemicalId VarChar (8000),@PortfolioId VarChar (8000),@StrategyId VarChar (8000),@InternalBa VarChar (8000)
,@StartingVeTradePeriodId SmallInt,@NumberOfPeriods VarChar (8000),@AggregateRecordsOutsideOfDateRange Bit,@AppendWhatIfScenarios Bit,@WhatIfScenarioId Int,@RiskReportInventoryRetrievalOption VarChar (8000)
,@TradePeriodStartDate SmallDateTime,@MaxTradePeriodStartDate SmallDateTime,@MaxTradePeriodEndDate SmallDateTime,@EndOfTimePeriodStartDate SmallDateTime,@EndOfTimePeriodEndDate SmallDateTime
,@InventoryTradePeriodStart SmallDateTime,@InventoryTradePeriodEnd SmallDateTime,@BegInvSourceTable Char,@RetrievalOptions Int,@35@RiskDealDetail@DlDtlIntrnlUserID Int,@36@Risk@StrtgyID int



--Get Latest successful snapshot ID

SELECT @i_P_EODSnpShtID='-1',@CompareWithAnotherSnapshot='False',@ComparisonSnapshotId='-2',@1DayInstanceDateTime='1990-01-01 00:00:00'
,@WklyInstanceDateTime='1990-01-01 00:00:00',@MtDInstanceDateTime='1990-01-01 00:00:00',@QtDInstanceDateTime='1990-01-01 00:00:00'
,@YtDInstanceDateTime='1990-01-01 00:00:00',@RiskReportCriteriaRetrievalOption='P',@PositionGroupId= NULL 
,@ProductLocationChemicalId= NULL ,@PortfolioId='53',@StrategyId= NULL ,@InternalBa='20',@StartingVeTradePeriodId='0'
,@NumberOfPeriods='-1',@AggregateRecordsOutsideOfDateRange='False',@AppendWhatIfScenarios='False',@WhatIfScenarioId= NULL 
,@RiskReportInventoryRetrievalOption='I',@MaxTradePeriodStartDate='2076-05-01 00:00:00',@MaxTradePeriodEndDate='2076-05-31 23:59:00'
,@EndOfTimePeriodStartDate='2050-12-01 00:00:00',@EndOfTimePeriodEndDate='2050-12-01 23:59:00', @BegInvSourceTable='S',@RetrievalOptions='265',@35@RiskDealDetail@DlDtlIntrnlUserID= NULL ,@36@Risk@StrtgyID= NULL--'23,25,26,27,20,18,17,16'



SELECT @SnapshotId =  P_EODSnpShtID ,@SnapshotInstanceDateTime = InstanceDateTime, @StartedFromVETradePeriodID = StartedFromVETradePeriodID
,@CompareSnapshotInstanceDateTime = InstanceDateTime, @SnapshotEndOfDay = EndOfDay, @CompareSnapshotEndOfDay = EndOfDay
,@5DayInstanceDateTime=InstanceDateTime,
@TradePeriodStartDate = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodStart = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodEnd = (SELECT [EndDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
FROM Snapshot(NOLOCK)
WHERE P_EODSnpShtID = (SELECT max(P_EODSnpShtID) FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'Y' AND Purged = 'N')


IF NOT EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempRiskExposure]
WHERE snapshot_id = @SnapshotId AND end_of_day = @SnapshotEndOfDay)

BEGIN

IF EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempRiskExposure])
	TRUNCATE TABLE [db_datareader].[MTVTempRiskExposure]


Create Table #StrategyReportCriteria
(
	StrtgyID 		Int Not Null
)

Insert Into [#StrategyReportCriteria] ([StrtgyID])
 (Select	[P_PortfolioStrategyFlat].[StrtgyID]
From	[P_PortfolioStrategyFlat] (NoLock)

Where	(
	[P_PortfolioStrategyFlat].[P_PrtflioID] In (53)
	))

Create Table #RiskExposureResults
(
	Idnty 		Int identity  Not Null,
	RiskExposureTableIdnty 		Int Null,
	ExposureID 		Int Null,
	RiskSourceID 		Int Null,
	DlHdrID 		Int Null,
	DlDtlID 		Int Null,
	DlDtlPrvsnID 		Int Null,
	DlDtlPrvsnRwID 		Int Null,
	FormulaEvaluationID 		Int Null,
	SourceTable 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	SourceID 		Int Null default 0,
	DlDtlTmplteID 		Int Null,
	RiskType 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	StrtgyID 		Int Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	IsPrimaryCost 		Bit Not Null default 0,
	IsQuotational 		Bit Not Null default 0,
	IsInventory 		Bit Not Null default 0,
	RiskCurveID 		Int Null,
	PrceTpeIdnty 		SmallInt Null,
	RwPrceLcleID 		Int Null,
	VETradePeriodID 		SmallInt Null,
	CurveServiceID 		Int Null,
	CurveProductID 		Int Null,
	CurveChemProductID 		Int Null,
	CurveLcleID 		Int Null,
	IsBasisCurve 		Bit Not Null default 0,
	CurveLevel 		TinyInt Null,
	PeriodStartDate 		SmallDateTime Null,
	PeriodEndDate 		SmallDateTime Null,
	ExposureStartDate 		SmallDateTime Null,
	ExposureQuoteStartDate 		SmallDateTime Null,
	ExposureQuoteEndDate 		SmallDateTime Null,
	NumberOfQuotesForPeriod 		Int Null,
	Position 		Decimal(38,15) Null default 0.0,
	OriginalPhysicalPosition 		Decimal(38,15) Not Null default 0.0,
	SpecificGravity 		Float Null default 0.0,
	Energy 		Float Null default 0.0,
	PricedInPercentage 		Float Null default 1.0,
	Percentage 		Decimal(38,15) Null default 0.0,
	TotalPercentage 		Float Null default 1.0,
	QuotePercentage 		Float Null,
	IsDailyPricingRow 		Bit Not Null default 0,
	EndOfDay 		SmallDateTime Null,
	DiscountFactor 		Float Null default 1.0,
	DiscountFactorID 		Int Null,
	EstimatedPaymentDate 		SmallDateTime Null,
	EstimatedPaymentDateIsMissing 		Char(1) COLLATE DATABASE_DEFAULT  Null default 'N',
	CrrncyID 		Int Null,
	DuplicateAsQuotational 		Bit Not Null default 0,
	Argument 		VarChar(1000) COLLATE DATABASE_DEFAULT  Null,
	LeaseDealDetailID 		Int Null,
	AttachedInHouse 		Char COLLATE DATABASE_DEFAULT  Null default 'N',
	PricingPeriodCategoryVETradePeriodID 		Int Null,
	CurveRiskType 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	PeriodName 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	PeriodAbbv 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	RelatedInventoryChangeId 		Int Null,
	PlnndTrnsfrID 		Int Null,
	PrimaryPlnndTrnsfrID 		Int Null,
	SrceSystmID 		Int Null,
	Weight 		Float Not Null default 0.0,
	IsCashSettledFuture 		Bit Not Null default 0,
	ValueID 		Int Null,
	ReferenceDate 		SmallDateTime Null,
	LogicalVETradePeriodID 		Int Null,
	InternalBAID 		Int Null,
	RiskID 		Int Null,
	Snapshot 		Int Null,
	SnapshotAccountingPeriod 		SmallDateTime Null,
	SnapshotTradePeriod 		SmallDateTime Null,
	InstanceDateTime 		SmallDateTime Null,
	RiskDealDetailOptionOTCId 		Int Null,
	RelatedDealNumber 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	MoveExternalDealID 		Int Null,
	CurveStructureDescription 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null
)

Create Clustered Index IE_RiskExposureResultsRiskID On #RiskExposureResults (RiskID)

Create Unique Index IE_RiskExposureResultsIdnty On #RiskExposureResults (Idnty)

Create Table #RiskExposureResultsOptions
(
	RiskID 		Int Not Null,
	RiskExposureTableIdnty 		Int Not Null,
	RiskResultsTableIdnty 		Int Null,
	RwPrceLcleID 		Int Null,
	IsOTC 		Bit Not Null default 0,
	RiskDealDetailOptionOTCID 		Int Null,
	RiskDealDetailOptionID 		Int Not Null,
	DlHdrID 		Int Not Null,
	DlDtlID 		Int Not Null,
	RowNumber 		Int Null,
	ExpirationDate 		SmallDateTime Null,
	ExercisedDate 		SmallDateTime Null,
	Exercised 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	ExercisedQuantity 		Float Null,
	PutCall 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	Flavor 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	StrikePrice 		Float Null,
	StrikePriceUOM 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	PriceService 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCSettlementTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCPremiumTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	EffectiveStartDate 		SmallDateTime Null,
	EffectiveEndDate 		SmallDateTime Null,
	Premium 		Float Null,
	BuySell 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID 		Int Null,
	Delta 		Float Not Null default 1.0,
	Gamma 		Float Not Null default 0.0,
	Theta 		Float Not Null default 0.0,
	Rho 		Float Not Null default 0.0,
	Volatility 		Float Not Null default 0.0,
	Weight 		Float Not Null default 1.0,
	Vega 		Float Not Null default 0.0,
	BarrierPrice 		Float Null,
	KnockOutStatus 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	BarrierType 		VarChar(8) COLLATE DATABASE_DEFAULT  Null,
	PayOut 		Float Null,
	OptionRiskID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskExposureResultsOptions (RiskID, RiskExposureTableIdnty)

Create Table #RiskExposureResultsHedge
(
	RiskResultsTableIdnty 		Int Not Null,
	RiskID 		Int Not Null,
	HedgeDlHdrID 		Int Null,
	HedgeSrceSystmID 		Int Null,
	HedgeContract 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	HedgeDetail 		Int Null,
	HedgingDlHdrID 		Int Null,
	HedgingSrceSystmID 		Int Null,
	HedgingContract 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	HedgingDetail 		Int Null,
	HedgingFromDate 		SmallDateTime Null,
	HedgingToDate 		SmallDateTime Null,
	HedgingPercentage 		Float Null,
	HedgePosition 		Float Null default 0.0,
	HedgeGroup 		VarChar(50) COLLATE DATABASE_DEFAULT  Null
)

Create NonClustered Index RiskIndex on #RiskExposureResultsHedge (RiskID)

Create Table #RiskResultsSnapshot
(
	RetrievedSnapshot 		Int Null,
	RetrievedCreationDate 		SmallDateTime Null,
	RetrievedDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	RetrievedAccountingStartDate 		SmallDateTime Null,
	RetrievedTradeStartDate 		SmallDateTime Null,
	RetrievedCloseOfBusiness 		SmallDateTime Null,
	DayToDaySnapshot 		Int Null,
	DayToDayCreationDate 		SmallDateTime Null,
	DayToDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	DayToDayCloseOfBus 		SmallDateTime Null,
	FiveDaySnapshot 		Int Null,
	FiveDayCreationDate 		SmallDateTime Null,
	FiveDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	FiveDayCloseOfBus 		SmallDateTime Null,
	WeekToDateSnapshot 		Int Null,
	WeekToDateCreationDate 		SmallDateTime Null,
	WeekToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	WeekToDateCloseOfBus 		SmallDateTime Null,
	MonthToDateSnapshot 		Int Null,
	MonthToDateCreationDate 		SmallDateTime Null,
	MonthToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	MonthToDateCloseOfBus 		SmallDateTime Null,
	QtrToDateSnapshot 		Int Null,
	QtrToDateCreationDate 		SmallDateTime Null,
	QtrToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	QtrToDateCloseOfBus 		SmallDateTime Null,
	YearToDateSnapshot 		Int Null,
	YearToDateCreationDate 		SmallDateTime Null,
	YearToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	YearToDateCloseOfBus 		SmallDateTime Null
)

Create Index RiskRetrievedSnapshot on #RiskResultsSnapshot (RetrievedSnapshot)

Create Table #RiskExposureFinalResults
(
	RiskID 		Int Null,
	RiskExposureResultsIdnty 		Int Null,
	Description 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	DlDtlID 		Int Null,
	RiskType 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	PeriodStartDate 		SmallDateTime Null,
	PeriodEndDate 		SmallDateTime Null,
	PeriodGroupStartDate 		SmallDateTime Null,
	PeriodGroupEndDate 		SmallDateTime Null,
	Position 		Float Null,
	StrtgyID 		Int Null,
	PricedInPercentage 		Float Null,
	PortfolioOrPositionGroup 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	ExposureQuoteDate 		SmallDateTime Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	CurveStructureDescription 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	RelatedDealNumber 		VarChar(4000) COLLATE DATABASE_DEFAULT  Null
)

Create Clustered Index ID_#RiskExposureFinalResults_RiskID on #RiskExposureFinalResults (RiskID)

Create NonClustered Index IE_#RiskExposureFinalResults_RiskExposureResultsIdnty on #RiskExposureFinalResults (RiskExposureResultsIdnty)

-- Physicals

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 1
And	[Risk].SourceTable In ('X', 'P', 'O', 'E', 'EP', 'EX', 'T','I','EIX','EIP')
And	

                        ( -- Show Os for Futures. OTCs need to show Ts for each leg

	                    [Risk].SourceTable			<> 'O'

                    Or	[Risk].DlDtlTmplteID			Not In (23100,23101,23102,23103,23000,23100,23101,23102,23103)

	                    )

                    And	(  -- Show Os for ETOs

	                    [Risk]. SourceTable			<> 'T'

                    Or	[Risk].DlDtlTmplteID			in (23100,23101,23102,23103,23000,23100,23101,23102,23103) 

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

                    Or	[Risk]. DeliveryPeriodStartDate	Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	                    )

                    And	Not ( -- Show Quotation T for Asian ETOs

		                    [Risk].DlDtlTmplteID			in (21000,35000,310000) 

                    And	Exists		( 

				                    Select 1

				                    From	dbo.[RiskDealDetailOption]	(NoLock)

				                    Where	[RiskDealDetailOption]. DlHdrID	= [Risk Deal Link]. DlHdrID

				                    And	[RiskDealDetailOption]. DlDtlID	= [Risk Deal Link]. DlDtlID

				                    And	@SnapshotInstanceDateTime		Between	[RiskDealDetailOption]. StartDate and [RiskDealDetailOption]. EndDate

				                    And	[RiskDealDetailOption]. Flavor	= 'O'

				                    )

	                        )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Physical Inhouse

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 0
And	[Risk].RiskPriceIdentifierID		Is Not Null

                    And	(

	                    IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

                    Or	[Risk].IsPrimaryCost			= 0

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And  Convert(SmallDateTime, '2076-05-31 23:59:00')

                    Or	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	                    )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- PPA

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 1
And	[Risk].SourceTable In ('X', 'P', 'E', 'EP', 'EX', 'T','I','EIX','EIP')
And	(

	                    [Risk]. DeliveryPeriodEndDate								< @TradePeriodStartDate

                    And	IsNull([Risk].InventoryAccountingPeriodStartDate, [Risk].AccountingPeriodStartDate)	>= @TradePeriodStartDate

	                )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- PPA InHouse Rules

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 0
And	[Risk].RiskPriceIdentifierID		Is Not Null

                    And	(

	                    IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

                    Or	[Risk].IsPrimaryCost			= 0

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		< @TradePeriodStartDate

                    And	IsNull([Risk]. InventoryAccountingPeriodStartDate, [Risk]. AccountingPeriodStartDate)		>= @TradePeriodStartDate

	                    )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Balances

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	[Risk].[IsVolumeOnly] = 1
And	Risk.SourceTable In('S','EB')
And	[Risk].[IsInventory] = 1
And	[Risk]. DeliveryPeriodStartDate	Between @InventoryTradePeriodStart And @InventoryTradePeriodEnd
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Non Options Quotational

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,[Risk Quotational Exposure].[RiskQuotationalExposureID] [RiskExposureTableIdnty]
	,[Risk Quotational Exposure].[FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,Convert(Int, Null) [RiskCurveID]
	,[Price Curve].[RwPrceLcleID]
	,[Formula Evaluation Percentage].[VETradePeriodID]
	,[Risk Deal Price Row Formula].[FormulaPrceTpeIdnty]
	,Case 	When 	[Risk].SourceTable 			= 'A' 

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		Then 	'H' -- Inhouse

		Else	'Q' -- Quotational

	End [RiskType]
	,Convert(Bit, 1) [IsQuotational]
	,[Risk Deal Price Row Formula].[DlDtlPrvsnID]
	,[Risk Quotational Exposure].[DlDtlPrvsnRwID]
	,[Formula Evaluation Percentage].[PricedInPercentage]
	,[Formula Evaluation Percentage].PricedInPercentage * [Risk Quotational Exposure].FormulaPercentage [PricedInPercentage]
	,[Formula Evaluation Percentage].TotalPercentage * [Risk Quotational Exposure].FormulaPercentage [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,Convert(SmallDateTime, Null) [ExposureStartDate]
	,[Formula Evaluation Percentage].[QuoteRangeBeginDate]
	,[Formula Evaluation Percentage].[QuoteRangeEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[Risk].RiskID = [Risk Quotational Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Quotational Exposure].StartDate and [Risk Quotational Exposure].EndDate
	Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].DlDtlPrvsnRwID = [Risk Quotational Exposure].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [Risk Deal Price Row Formula].StartDate and [Risk Deal Price Row Formula].EndDate
	Join [FormulaEvaluationPercentage] [Formula Evaluation Percentage] (NoLock) On
		[Formula Evaluation Percentage].FormulaEvaluationID = [Risk Quotational Exposure].FormulaEvaluationID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Delivery Period].VETradePeriodID = [Formula Evaluation Percentage].VETradePeriodID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Deal Price Row Formula].FormulaRwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	[Formula Evaluation Percentage]. TotalPercentage		<> 0.0
And	[Risk Quotational Exposure]. PercentageOfProvision		<> 0.0
And	 @SnapshotEndOfDay Between [Formula Evaluation Percentage]. EndOfDayStartDate And [Formula Evaluation Percentage].EndOfDayEndDate
And	(

	[Risk]. DlDtlTmplteID			Not In (21000,35000,310000) -- ETOs

Or	( -- Show Quotation T for Asian ETOs so we can show daily exposure

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailOption] RDDO	(NoLock)

				Where	RDDO. DlHdrID	= [Risk Deal Link]. DlHdrID

				and	RDDO. DlDtlID	= [Risk Deal Link]. DlDtlID

				And	@SnapshotInstanceDateTime		Between	RDDO.StartDate and RDDO.EndDate

				and	RDDO. Flavor	= 'O'

				)

	)

	Or	( -- Show Quotational for spreads

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailProvision] RDDP (NoLock)

				Where	RDDP.DlDtlPrvsnID		= [Risk Deal Price Row Formula]. DlDtlPrvsnID

				And	@SnapshotInstanceDateTime		Between RDDP.StartDate and RDDP.EndDate

				And	RDDP. DlDtlPrvsnPrvsnID	= 90

				)

	))
And	

        (

	        [Risk].DlDtlTmplteID NOT IN (9080, 9090)

        OR	[Risk].SourceTable IN ('EIX', 'EIP')

	        )

        
And	(

	IsNull([Risk Deal Price Source].TmplteSrceTpe, 'XX')	Not Like 'D%'

Or	[Risk].SourceTable			= 'A'

	)

And	(

	(

	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

Or	(

	[Delivery Period]. StartDate		    Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Delivery Period]. EndDate			Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

	)
And	(   [Risk]. DlDtlTmplteID Not In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103)Or ( [Risk].DlDtlTmplteID In(23100,23101,23102,23103,23000,23100,23101,23102,23103)    And IsNull([Price Curve].IsSpotPrice, 1) = Convert(Bit, 0)  ))
And	Abs([Formula Evaluation Percentage]. PricedInPercentage)	< Abs([Formula Evaluation Percentage]. TotalPercentage)
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	))

-- Options Quotational

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,[Risk Quotational Exposure].[RiskQuotationalExposureID] [RiskExposureTableIdnty]
	,[Risk Quotational Exposure].[FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,Convert(Int, Null) [RiskCurveID]
	,[Price Curve].[RwPrceLcleID]
	,Max([Delivery Period].VETradePeriodID) [VETradePeriodID]
	,[Risk Deal Price Row Formula].[FormulaPrceTpeIdnty]
	,Case 	When 	[Risk].SourceTable 			= 'A' 

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		Then 	'H' -- Inhouse

		Else	'Q' -- Quotational

	End [RiskType]
	,Convert(Bit, 1) [IsQuotational]
	,[Risk Deal Price Row Formula].[DlDtlPrvsnID]
	,[Risk Quotational Exposure].[DlDtlPrvsnRwID]
	,Sum([Formula Evaluation Percentage].PricedInPercentage) [Percentage]
	,Sum([Formula Evaluation Percentage].PricedInPercentage * [Risk Quotational Exposure].FormulaPercentage) [PricedInPercentage]
	,Sum([Formula Evaluation Percentage].TotalPercentage * [Risk Quotational Exposure].FormulaPercentage) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,Convert(SmallDateTime, Null) [ExposureStartDate]
	,Min([Formula Evaluation Percentage].QuoteRangeBeginDate) [QuoteRangeBeginDate]
	,Max([Formula Evaluation Percentage].QuoteRangeEndDate) [QuoteRangeEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[Risk].RiskID = [Risk Quotational Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Quotational Exposure].StartDate and [Risk Quotational Exposure].EndDate
	Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].DlDtlPrvsnRwID = [Risk Quotational Exposure].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [Risk Deal Price Row Formula].StartDate and [Risk Deal Price Row Formula].EndDate
	Join [FormulaEvaluationPercentage] [Formula Evaluation Percentage] (NoLock) On
		[Formula Evaluation Percentage].FormulaEvaluationID = [Risk Quotational Exposure].FormulaEvaluationID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Delivery Period].VETradePeriodID = [Formula Evaluation Percentage].VETradePeriodID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Deal Price Row Formula].FormulaRwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	[Formula Evaluation Percentage]. TotalPercentage		<> 0.0
And	[Risk Quotational Exposure]. PercentageOfProvision		<> 0.0
And	 @SnapshotEndOfDay Between [Formula Evaluation Percentage]. EndOfDayStartDate And [Formula Evaluation Percentage].EndOfDayEndDate
And	(

	[Risk]. DlDtlTmplteID			Not In (21000,35000,310000) -- ETOs

Or	( -- Show Quotation T for Asian ETOs so we can show daily exposure

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailOption] RDDO	(NoLock)

				Where	RDDO. DlHdrID	= [Risk Deal Link]. DlHdrID

				and	RDDO. DlDtlID	= [Risk Deal Link]. DlDtlID

				And	@SnapshotInstanceDateTime		Between	RDDO.StartDate and RDDO.EndDate

				and	RDDO. Flavor	= 'O'

				)

	)

	Or	( -- Show Quotational for spreads

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailProvision] RDDP (NoLock)

				Where	RDDP.DlDtlPrvsnID		= [Risk Deal Price Row Formula]. DlDtlPrvsnID

				And	@SnapshotInstanceDateTime		Between RDDP.StartDate and RDDP.EndDate

				And	RDDP. DlDtlPrvsnPrvsnID	= 90

				)

	))
And	

        (

	        [Risk].DlDtlTmplteID NOT IN (9080, 9090)

        OR	[Risk].SourceTable IN ('EIX', 'EIP')

	        )

        
And	(

	IsNull([Risk Deal Price Source].TmplteSrceTpe, 'XX')	Not Like 'D%'

Or	[Risk].SourceTable			= 'A'

	)

And	(

	(

	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

Or	(

	[Delivery Period]. StartDate		    Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Delivery Period]. EndDate			Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

	)
And	[Risk]. DlDtlTmplteID In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103) And Not ( [Risk].DlDtlTmplteID In(23100,23101,23102,23103,23000,23100,23101,23102,23103)and IsNull([Price Curve].IsSpotPrice, 1)	= Convert(Bit, 0))
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk Quotational Exposure].[RiskQuotationalExposureID], [Risk Quotational Exposure].[FormulaEvaluationID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Price Curve].[RwPrceLcleID], [Risk Deal Price Row Formula].[FormulaPrceTpeIdnty], Case 	When 	[Risk].SourceTable 			= 'A'

		                                        And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		                                        And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		                                        Then 	'H' -- Inhouse

		                                        Else	'Q' 	-- Quotational

	                                        End, [Risk Deal Price Row Formula].[DlDtlPrvsnID], [Risk Quotational Exposure].[DlDtlPrvsnRwID], Case When 	[Risk].DlDtlTmplteID In(21000,35000,310000) Then [Delivery Period].StartDate Else [Risk Deal Detail].DlDtlFrmDte End, Case When 	[Risk].DlDtlTmplteID In(21000,35000,310000) Then [Delivery Period].EndDate Else [Risk Deal Detail].DlDtlToDte End)

-- Select * From #RiskExposureResults

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'Updates',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'DecompositionAndUpdates',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer] OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'LoadFinalResults',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK)	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Select	[Risk].[RiskID]
	,[#RiskExposureFinalResults].[Description]
	,[#RiskExposureFinalResults].[DlDtlID]
	,[Risk].[InternalBAID]
	,IsNull([Risk Deal Price].[ExternalBAID], [Risk]. [ExternalBAID]) [ExternalBAID]
	,[#RiskExposureFinalResults].[RiskType]
	,IsNull([{Calculated Columns}].[PrdctID], [Risk]. [PrdctID]) [PrdctID]
	,IsNull([{Calculated Columns}].[LcleID], [Risk]. [LcleID]) [LcleID]
	,[{Calculated Columns}].[CurveServiceID]
	,[{Calculated Columns}].[CurveProductID]
	,[{Calculated Columns}].[CurveLcleID]
	,[#RiskExposureFinalResults].[PeriodStartDate]
	,[#RiskExposureFinalResults].[PeriodEndDate]
	,[#RiskExposureFinalResults].[StrtgyID]
	,[#RiskExposureFinalResults].[Position]
	,[#RiskExposureFinalResults].[PricedInPercentage]
	,[#RiskExposureFinalResults].[PortfolioOrPositionGroup]
	,IsNull([{Calculated Columns}].[ChmclID], [Risk]. [ChmclID]) [ChmclID]
	,[{Calculated Columns}].[CurveChemProductID]
	,[#RiskExposureFinalResults].[PeriodGroupStartDate]
	,[#RiskExposureFinalResults].[PeriodGroupEndDate]
	,[{Calculated Columns}].[EndOfDay]
	,[#RiskExposureFinalResults].[ExposureQuoteDate]
	,[Risk].[SourceTable]
	,[{Calculated Columns}].[SpecificGravity]
	,[{Calculated Columns}].[Energy]
	,[GC19_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn29]
	,[GC21_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn30]
	,[DD20_Dyn].[DlDtlTmplteID] [DlDtlTmplteID_Dyn31]
	,[{Calculated Columns}].[AttachedInHouse] [AttachedInHouse_Dyn32]
	,[Risk].[IsInventory] [IsInventory_Dyn33]
	,[RPT22_Dyn].[SchdlngPrdID] [SchdlngPrdID_Dyn34]
	,[RPL23_Dyn].[IsBasisCurve] [IsBasisCurve_Dyn35]
	,(Select	Top 1 'Y'
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID) [Subselect_Dyn36]
	,[DD24_Dyn].[DlDtlSpplyDmnd] [DlDtlSpplyDmnd_Dyn39]
	,(Select	Top 1 'Y'
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID) [Subselect_Dyn38]
	,(Select	Top 1 'Y'

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate) [Subselect_Dyn40]
	,[Risk].[DlDtlTmplteID] [DlDtlTmplteID_Dyn40]
	,[Risk].[DeliveryPeriodStartDate] [DeliveryPeriodStartDate_Dyn41]
	,[Risk].[InventoryAccountingPeriodStartDate] [InventoryAccountingPeriodStartDate_Dyn42]
	,[Risk Deal Detail].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn43]
	,[{Calculated Columns}].[Snapshot] [Snapshot_Dyn44]
	,[DD20_Dyn].[DlDtlCrtnDte] [DlDtlCrtnDte_Dyn45]
	,[DD20_Dyn].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn46]
	,[DD20_Dyn].[DlDtlStat] [DlDtlStat_Dyn47]
	,[DD20_Dyn].[DlDtlDsplyUOM] [DlDtlDsplyUOM_Dyn48]
	,[DH18_Dyn].[DlHdrIntrnlUserID] [DlHdrIntrnlUserID_Dyn49]
	,[Risk Deal Link].[PlnndTrnsfrID] [PlnndTrnsfrID_Dyn49]
	,[Risk Deal Detail].[NegotiatedDate] [NegotiatedDate_Dyn50]
	,[Risk].[IsPrimaryCost] [IsPrimaryCost_Dyn51]
	,Cast(3 AS SmallInt) [AutoGeneratedBaseUOM]
	,Cast(19 AS Int) [AutoGeneratedBaseCurrency]
	,[{Calculated Columns}].InstanceDateTime AS CCInstanceDateTime
	,[Risk Transfer].PlnndMvtID
	,[Risk Transfer].StrtgyID AS RTStrtgyID
INTO #temp_RER
From	[#RiskExposureFinalResults] (NoLock)
	Join [#RiskExposureResults] [{Calculated Columns}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Calculated Columns}].[Idnty]
	Join [Risk] (NoLock) On
			[{Calculated Columns}].[RiskID] = [Risk].[RiskID]
	Left Join [#RiskExposureResultsOptions] [{Option Columns}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Option Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskExposureResultsHedge] [{Hedging Information}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Hedging Information}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSnapshot] [{Snapshot Information Columns}] (NoLock) On
		1 = 1
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
			[{Calculated Columns}].[RiskCurveID] = [Risk Curve].[RiskCurveID]
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [LeaseDealDetail] [Lease Deal Detail] (NoLock) On
		[{Calculated Columns}].[LeaseDealDetailID] = [Lease Deal Detail].[LeaseDealDetailID]
	Left Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[{Calculated Columns}].[RiskExposureTableIdnty] = [Risk Physical Exposure].[RiskPhysicalExposureID] And [{Calculated Columns}].[RiskType] <> 'Q'
	Left Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[{Calculated Columns}].[RiskExposureTableIdnty] = [Risk Quotational Exposure].[RiskQuotationalExposureID] And [{Calculated Columns}].[RiskType] = 'Q'
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].[DlDtlPrvsnRwID] = [{Calculated Columns}].[DlDtlPrvsnRwID] And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Price Row Formula].StartDate And [Risk Deal Price Row Formula].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Row Formula].[DlDtlPrvsnID] = [Risk Deal Price].[DlDtlPrvsnID] And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Price].StartDate And [Risk Deal Price].EndDate
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Detail].StartDate And [Risk Deal Detail].EndDate And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPlannedTransfer] [Risk Transfer] (NoLock) On
		[Risk Deal Link]. PlnndTrnsfrID = [Risk Transfer]. PlnndTrnsfrID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Transfer].StartDate and [Risk Transfer].EndDate and [Risk]. ChmclID = [Risk Transfer]. ChmclChdPrdctID
	Left Join [DealHeader] [DH18_Dyn] (NoLock) On
		[Risk Deal Link].DlHdrID = [DH18_Dyn].DlHdrID and [Risk Deal Link].DealDetailID is not null
	Left Join [GeneralConfiguration] [GC19_Dyn] (NoLock) On
		[DH18_Dyn].DlHdrID = [GC19_Dyn].GnrlCnfgHdrID And [GC19_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC19_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC19_Dyn].GnrlCnfgHdrID <> 0
	Left Join [DealDetail] [DD20_Dyn] (NoLock) On
		[Risk Deal Link].DealDetailID = [DD20_Dyn].DealDetailID
	Left Join [GeneralConfiguration] [GC21_Dyn] (NoLock) On
		[DD20_Dyn].DlDtlDlHdrID = [GC21_Dyn].GnrlCnfgHdrID And [DD20_Dyn].DlDtlID = [GC21_Dyn].GnrlCnfgDtlID And [GC21_Dyn].GnrlCnfgTblNme = 'DealDetail' And [GC21_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC21_Dyn].GnrlCnfgHdrID <> 0
	Left Join [RiskPlannedTransfer] [RPT22_Dyn] (NoLock) On
		[Risk Deal Link].PlnndTrnsfrID = [RPT22_Dyn].PlnndTrnsfrID and @SnapshotInstanceDateTime between [RPT22_Dyn].StartDate and [RPT22_Dyn].EndDate
	Left Join [RawPriceLocale] [RPL23_Dyn] (NoLock) On
		[Risk Curve].RwPrceLcleID = [RPL23_Dyn].RwPrceLcleID
	Left Join [DealDetail] [DD24_Dyn] (NoLock) On
		[Risk Deal Detail].DealDetailID = [DD24_Dyn].DealDetailID
Where	(
	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)


---Join Respective tables to get respective columns values and computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_RER_Join') IS NOT NULL
    DROP TABLE #temp_RER_Join


SELECT 
CONVERT(Varchar(20), [Description]) AS deal  
,CONVERT(Varchar(20),DlDtlID) AS deal_detail_id 
,CASE WHEN [DlDtlStat_Dyn47] = 'A' THEN 'Active'
		WHEN [DlDtlStat_Dyn47] = 'C' THEN 'Canceled' END status  
,[NegotiatedDate_Dyn50] AS trade_date
,[EndOfDay] AS end_of_day
,[PeriodStartDate] AS period_start
,[PeriodEndDate] AS period_end
,[DlDtlRvsnDte_Dyn46] AS revision_date
, [DlDtlCrtnDte_Dyn45] AS creation_date
,[PeriodGroupStartDate] AS period_group_start
,[PeriodGroupEndDate] AS period_group_end
,Convert(smalldatetime, [HedgeMonth_Dyn29]) AS hedge_month
,Convert(smalldatetime, [HedgeMonth_Dyn30]) AS deal_detail_hedge_month
,(SELECT [FromDate] FROM [dbo].[SchedulingPeriod](NOLOCK) WHERE [SchdlngPrdID] = t.[SchdlngPrdID_Dyn34]) AS scheduling_period
,[InventoryAccountingPeriodStartDate_Dyn42] AS inventory_accounting_start_date
,[DeliveryPeriodStartDate_Dyn41] AS delivery_period_start
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS product
,CASE WHEN [RiskType] = 'M' THEN 'Market'
	WHEN [RiskType] = 'P' THEN 'Physical'
	WHEN [RiskType] = 'Q' THEN 'Quotational'
	WHEN [RiskType] = 'I' THEN 'Inventory'
	END AS risk_type
,(SELECT CntctFrstNme + ' ' +CntctLstNme FROM [dbo].Users(NOLOCK) U 
	INNER JOIN Contact(NOLOCK) C ON U.UserCntctID = C.CntCtID 
	WHERE U.UserID = t.[DlHdrIntrnlUserID_Dyn49]) AS trader
,(SELECT [Name] FROM [dbo].[StrategyHeader](NOLOCK) SH WHERE SH.StrtgyID = t.StrtgyID) AS strategy
,[PortfolioOrPositionGroup] AS portfolio_position_group
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.InternalBAID) AS our_company
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.ExternalBAID) AS their_company
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = t.LcleID) AS location
,(SELECT [RPHdrAbbv] FROM [RawPriceHeader](NOLOCK) WHERE [RPHdrID] = [CurveServiceID]) AS curve_service
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[CurveProductID]) AS curve_product
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = [CurveLcleID]) AS curve_location
,[Position] AS position
,[ExposureQuoteDate] AS exposure_quote_date
,Convert(Varchar(20), (Round(PricedInPercentage*100,2))) + '%' AS priced_percentage
,(SELECT UOMAbbv FROM UnitOfMeasure(NOLOCK) UOM WHERE UOM.UOM = t.DlDtlDsplyUOM_Dyn48) AS uom 
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[ChmclID]) AS child_product
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[CurveChemProductID]) AS curve_child_product
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.[DlDtlTmplteID_Dyn40]) AS detail_template
,CASE WHEN [AttachedInHouse_Dyn32] = 'N' THEN 'No'
	ELSE 'Yes' END AS attached_inhouse
,CASE WHEN [IsInventory_Dyn33] = 1 THEN 'Yes' 
		ELSE 'No' END inventory
,CASE WHEN [IsBasisCurve_Dyn35] = 1 THEN 'Yes'
	ELSE 'No' END AS is_basis_curve
,CASE WHEN t.SourceTable = 'P' THEN 'Planned Transfer'
	WHEN t.SourceTable = 'A' THEN 'Accounting Transaction'
	WHEN t.SourceTable = 'I' THEN 'Inventory Change'
	WHEN t.SourceTable = 'X' THEN 'Movement Transaction'
	WHEN t.SourceTable = 'O' THEN 'Obligation'
	WHEN t.SourceTable = 'E' THEN 'External Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'N' THEN 'NA'
	WHEN t.SourceTable = 'B' THEN 'Estimated Balance'
	WHEN t.SourceTable = 'L' THEN 'Planned Expense'
	WHEN t.SourceTable = 'T' THEN 'Time Based Estimated Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'EP' THEN 'External Estimated Movement'
	WHEN t.SourceTable = 'EX' THEN 'External Movement'
	WHEN t.SourceTable = 'EA' THEN 'External Actual'
	WHEN t.SourceTable = 'EIP' THEN 'External Estimated Inventory Change'
	WHEN t.SourceTable = 'EIX' THEN 'External Actual Inventory Change'
	WHEN t.SourceTable = 'H' THEN 'Hedging Detail'
	END source
,CASE WHEN (SELECT PTReceiptDelivery FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) = 'R' THEN 'Receipt'
	WHEN (SELECT PTReceiptDelivery FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) = 'D' THEN 'Delivery'
	END AS receipt_delivery
,(SELECT PTParcelNumber FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) AS [PlannedTransfer_PTParcelNumber_Dyn28]
,[RiskID] AS risk_id
,'' AS [Flat Price/Basis]
,CASE WHEN [IsPrimaryCost_Dyn51] = 0 THEN 'No'
	ELSE 'Yes' END AS primary_cost
,PlnndTrnsfrID_Dyn49 AS transfer_id
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID_Dyn31 ) AS deal_detail_template
,Iif([AttachedInHouse_Dyn32] = 'No' And [IsInventory_Dyn33] = 'Yes', 'True', 'False') AS calc_is_inventory
,'' AS [Build/Draw]
,[Snapshot_Dyn44] AS snapshot_id
,(Select	Top 1 'Y'
From	RiskDealIdentifier OtherDealSide
	inner Join Risk OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	t.[DlDtlTmplteID_Dyn40] in (30000,30001)
And	OtherDealSide.DlHdrID = (SELECT DlHdrID FROM DealHeader(NOLOCK) WHERE DlHdrIntrnlNbr = t.[Description]))
AS calc_involves_inventory_book
,'' AS [Risk Category]
,(Select	Top 1 'Y'
From	[RiskPlannedTransfer] OtherTransfer
Where	OtherTransfer.PlnndMvtID = t.PlnndMvtID
And	t.CCInstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> t.StrtgyID)
AS calc_order_crosses_strategy
,'' AS InventoryBuySalelBuildDraw
,(Select	Top 1 'Y'
From	[RiskPlannedTransfer] OtherTransfer

	Inner Join [RiskDealIdentifier] OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk] OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	t.[IsInventory_Dyn33] = 0
Where	OtherTransfer.PlnndMvtID = t.PlnndMvtID
And	t.CCInstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
) AS calc_order_has_non_inventory
,'' AS [RiskType]
,[Position] AS calc_exposure
,'' [*Position]
INTO #temp_RER_Join
FROM #temp_RER t


---Final load into temp tables with computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_RER_Final') IS NOT NULL
    DROP TABLE #temp_RER_Final

SELECT 
deal
,deal_detail_id
,status
,trade_date
,end_of_day
,period_start
,period_end
,revision_date
,creation_date
,period_group_start
,period_group_end
,hedge_month
,deal_detail_hedge_month
,scheduling_period
,inventory_accounting_start_date
,delivery_period_start
,product
,risk_type
,trader
,strategy
,portfolio_position_group
,our_company
,their_company
,location
,curve_service
,curve_product
,curve_location
,position
,exposure_quote_date
,priced_percentage
,uom
,child_product
,curve_child_product
,detail_template
,attached_inhouse
,inventory
,is_basis_curve
,source
,receipt_delivery
,Iif([PlannedTransfer_PTParcelNumber_Dyn28] Is Null Or [PlannedTransfer_PTParcelNumber_Dyn28] = '(Empty)' Or [PlannedTransfer_PTParcelNumber_Dyn28] = '', 
 Iif(CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) Is Null Or CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) = '(Empty)' Or CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) = '', 
  Iif(CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) Is Null Or CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) = '(Empty)' Or CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) = '', 
   Iif(CONVERT(VARCHAR(10),hedge_month, 101) Is Null Or CONVERT(VARCHAR(10),hedge_month, 101) = '(Empty)' Or CONVERT(VARCHAR(10),hedge_month, 101) = '', inventory_accounting_start_date, hedge_month), inventory_accounting_start_date), deal_detail_hedge_month), [PlannedTransfer_PTParcelNumber_Dyn28])
AS calc_program_month
,risk_id
,Iif(is_basis_curve = 'No', 'Flat Price', 'Basis') AS calc_flat_price_basis
,primary_cost
,transfer_id
,deal_detail_template
,calc_is_inventory
,Iif((source = 'Planned Transfer' Or source = 'Movement Transaction') And calc_is_inventory = 'True', 'Build/Draw', '') AS calc_build_draw
,snapshot_id
,calc_involves_inventory_book
,Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
)In ('Inventory', 'Build', 'Draw'), '1-Beg Inv', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Sale-Internal'), '3-Demand', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('3rd Party'), '4-3rd Party', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Paper'), '5-Paper', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Buy-Internal'), '2-Supply', '') + Iif(deal = 'MOA17TP0003', '3-Demand', '') AS calc_risk_category
,calc_order_crosses_strategy
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))

AS calc_inventory_buy_sale_build_draw
,calc_order_has_non_inventory
,RiskType
,calc_exposure
,[*Position]
INTO #temp_RER_Final
FROM #temp_RER_Join




--Load Data into Custom RER table


INSERT INTO [db_datareader].[MTVTempRiskExposure] with (tablockx)
([deal]
      ,[deal_detail_id]
      ,[status]
      ,[trade_date]
      ,[end_of_day]
      ,[period_start]
      ,[period_end]
      ,[revision_date]
      ,[creation_date]
      ,[period_group_start]
      ,[period_group_end]
      ,[hedge_month]
      ,[deal_detail_hedge_month]
      ,[scheduling_period]
      ,[inventory_accounting_start_date]
      ,[delivery_period_start]
      ,[product]
      ,[risk_type]
      ,[trader]
      ,[strategy]
      ,[portfolio_position_group]
      ,[our_company]
      ,[their_company]
      ,[location]
      ,[curve_service]
      ,[curve_product]
      ,[curve_location]
      ,[position]
      ,[exposure_quote_date]
      ,[priced_percentage]
      ,[uom]
      ,[child_product]
      ,[curve_child_product]
      ,[detail_template]
      ,[attached_inhouse]
      ,[inventory]
      ,[is_basis_curve]
      ,[source]
      ,[receipt_delivery]
      ,[calc_program_month]
      ,[risk_id]
      ,[calc_flat_price_basis]
      ,[primary_cost]
      ,[transfer_id]
      ,[deal_detail_template]
      ,[calc_is_inventory]
      ,[calc_build_draw]
      ,[snapshot_id]
      ,[calc_involves_inventory_book]
      ,[calc_risk_category]
      ,[calc_order_crosses_strategy]
      ,[calc_inventory_buy_sale_build_draw]
      ,[calc_order_has_non_inventory]
      ,[calc_risk_type]
      ,[calc_exposure]
      ,[calc_position]
	  )
SELECT 
deal
,deal_detail_id
,status
,trade_date
,end_of_day
,period_start
,period_end
,revision_date
,creation_date
,period_group_start
,period_group_end
,hedge_month
,deal_detail_hedge_month
,scheduling_period
,inventory_accounting_start_date
,delivery_period_start
,product
,risk_type
,trader
,strategy
,portfolio_position_group
,our_company
,REPLACE(their_company, ',', '') AS their_company
,location
,curve_service
,curve_product
,curve_location
,position
,exposure_quote_date
,priced_percentage
,uom
,child_product
,curve_child_product
,CONVERT(Varchar(50), detail_template) AS detail_template
,attached_inhouse
,inventory
,is_basis_curve
,source
,receipt_delivery
,calc_program_month
,CONVERT(Varchar(20), risk_id) AS risk_id
,calc_flat_price_basis
,primary_cost
,CONVERT(Varchar(20),transfer_id) AS transfer_id
,CONVERT(Varchar(50), deal_detail_template) AS deal_detail_template
,calc_is_inventory
,calc_build_draw
,CONVERT(Varchar(20),snapshot_id) AS snapshot_id
,calc_involves_inventory_book
,calc_risk_category
,calc_order_crosses_strategy
,calc_inventory_buy_sale_build_draw
,calc_order_has_non_inventory
,Iif(calc_risk_category Like '%Paper%', 'Quotational', Iif(risk_type = 'Inventory', 'Physical', risk_type)) calc_risk_type
,calc_exposure
,Iif((Iif(calc_risk_category Like '%Paper%', 'Quotational', Iif(risk_type = 'Inventory', 'Physical', risk_type))) = 'Physical', position, 0) calc_position
FROM #temp_RER_Final

END

END

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_GetTempRiskExposure.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetTempRiskExposure >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetTempRiskExposure >>>'
	  END

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_GetTempRiskExposure.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_MTVProcessMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=sp_MTV_MTVProcessMovementLifeCycle.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProcessMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVProcessMovementLifeCycle TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVProcessMovementLifeCycle >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVProcessMovementLifeCycle >>>'
GO
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_MTVProcessMovementLifeCycle.GRANT.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure] 	@i_P_EODSnpShtID	Int		= Null
								,@i_P_EODSnpShtLgID	Int		= Null
								,@i_Compare_P_EODSnpShtID Int		= Null
								,@c_ShowDailyExposure	char(1)		= Null
								,@b_IsCurrentExposure	char(1)		= 'N'
								,@b_ShowRiskDecomposed	Bit		= 1
								,@c_InventoryType	Char(1)		= 'B'
								,@b_IsReport		Bit 		= 1
								,@vc_AdditionalColumns 	VarChar(8000)	= Null
								,@vc_TempTableName	VarChar(128)	= '#RiskResults'
								,@c_OnlyShowSQL		Char(1)		= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure, taken from Original SP  SRA_Risk_Reports_Decompose_Exposure. 
			--Due to performance issue at #Exposure temp table in while loop. Inserting data at curve level 2 or 3 causing query 
			--to run very slow. So after each loop, dropping indexes of temp table #Exposure and creating them increase performance of insert       
-- Overview:	
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Amar Kenguva

------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier OFF
Set NoCount ON

----------------------------------------------------------- 
-- Check that we at least have a curve to load
-----------------------------------------------------------
--If	@i_PriceCurveId Is Null
--Or	@i_PriceTypeID	Is Null
--	Return

/*----------------------------------------------------------- 
-- Declare Local Variables
-----------------------------------------------------------*/
Declare @errno 				Int
Declare @dt_CurrentTime			DateTime
Declare	@errmsg 			VarChar(255)
Declare	@i_CurveLevel			TinyInt
Declare	@i_rowcount			Int

Select	@errno 				= '60000'
Select	@i_CurveLevel			= 0
Select	@i_rowcount			= 1
If @dt_CurrentTime Is Null
	Select @dt_CurrentTime = Current_TimeStamp

----------------------------------------------------------------------------------------------------
-- SQL Variables
----------------------------------------------------------------------------------------------------
Declare @vc_DynamicSQL			VarChar(8000)
Declare @vc_DynamicSQL_InsertTemplate	VarChar(8000)
Declare @vc_DynamicSQL_CurveDescription	VarChar(8000)
Declare @vc_DynamicSQL_Insert		VarChar(8000)
Declare @vc_DynamicSQL_GroupBy		VarChar(8000)
Declare @vc_DynamicSQL_GroupByTemplate	VarChar(8000)
Declare @vc_DynamicSQL_UpdateCurveStructureDescription	VarChar(8000)

----------------------------------------------------------------------------------------------------
-- Performance Variables
----------------------------------------------------------------------------------------------------
Declare	@b_RiskCurveExposure_Table_HasNonMonthlyRows	Bit
Declare	@b_RiskCurveExposureQuote_Table_HasRows		Bit

Select	@b_RiskCurveExposure_Table_HasNonMonthlyRows	= Case When Exists ( Select 1 From RiskCurveExposure Where QuoteStartDate Is Not Null ) Then 1 Else 0 End
Select	@b_RiskCurveExposureQuote_Table_HasRows		= Case When Exists ( Select 1 From RiskCurveExposureQuote) Then 1 Else 0 End


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete quotational rows that shouldn't show exposure based on the Prvsn.ExposureStatus
-----------------------------------------------------------------------------------------------------------------------------------------------------
if @b_IsCurrentExposure = 'N'
begin

    Select @vc_DynamicSQL = '
    Delete	#RiskResults
    From	' + @vc_TempTableName + ' #RiskResults
    Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
    And	Exists	(
			    Select	""
			    From	dbo.RiskDealDetailProvision	(NoLock)
				    Inner Join dbo.Prvsn	(NoLock)	On	Prvsn. PrvsnID		= RiskDealDetailProvision. DlDtlPrvsnPrvsnID
			    Where	RiskDealDetailProvision. DlDtlPrvsnID	= #RiskResults. DlDtlPrvsnID
			    And	#RiskResults. InstanceDateTime		Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
			    And	Prvsn. ExposureStatus	<> RiskDealDetailProvision. CostType
			    And	Prvsn. ExposureStatus	<>''B''
			    )'


    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)



	select  @vc_DynamicSQL = '
    Update  #RiskResults
    Set	    PrdctID	=   Risk. PrdctID
    From	' + @vc_TempTableName + ' #RiskResults
	    Inner Join	Risk (NoLock) on    #RiskResults.RiskID	=   Risk.RiskID'
	    
	   
    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


    -----------------------------------------------------------------------------------------------------------------------------------------------------
    -- Delete Futures that have rolled off ( Need this since some futures are quotational which means the end date of RiskCurveLink won't work
    -----------------------------------------------------------------------------------------------------------------------------------------------------
    Select @vc_DynamicSQL = '
    Delete	#RiskResults
    From	' + @vc_TempTableName + ' #RiskResults
    Where	#RiskResults. DlDtlTmplteID In( ' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
    And	Not Exists	(
			    Select	""
			    From	RawPriceLocalePricingPeriodCategory	(NoLock)
				    Inner Join PricingPeriodCategoryVETradePeriod (NoLock)
									    On	PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID	= RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID
									    And	#RiskResults.EndOfDay						<= DateAdd(day, -1, PricingPeriodCategoryVETradePeriod.RollOffBoardDate)
									    And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= #RiskResults. VETradePeriodID
			    Where	RawPriceLocalePricingPeriodCategory.RwPrceLcleID		= #RiskResults. RwPrceLcleID
			    And	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement		= Convert(Bit, 1)
			    )
	And	Not Exists	(
		Select	1
		From	dbo.ProductInstrument
		Where	ProductInstrument. PrdctID				= #RiskResults. PrdctID
		And	ProductInstrument. InstrumentType			= ''F''	-- Future
		And	IsNull(ProductInstrument. DefaultSettlementType, ''Z'')	= ''P'' -- Physically Settled
		And	ProductInstrument. PhysicalRwPrceLcleID			Is Not Null
		And	ProductInstrument. PhysicalPriceTypeID			Is Not Null
		)'


    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end	    
	    
----------------------------------------------------------------------------------------------
-- Delete relative period exposure (both Current Exposure and Risk Exposure)
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	Exists	(
	Select	1 
	From	dbo.VETradePeriod	(NoLock)
	Where	VETradePeriod.VETradePeriodID	= #RiskResults. VETradePeriodID
	And	VETradePeriod.Type		= ''R'' 
		)'
    	    
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)    	    

----------------------------------------------------------------------------------------------
-- Delete the quotational exposures that have rolled off
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
And	Not Exists	(
		Select	1
		From	dbo.FormulaEvaluationPercentage	(NoLock)
		Where	FormulaEvaluationPercentage. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
		And	#RiskResults. EndOfDay < FormulaEvaluationPercentage. QuoteRangeEndDate
		)'

If @c_ShowDailyExposure in ('N', 'Y')
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- If it's a physically settled future, then update the curve prod/loc to the underlying physical
-----------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Update	#RiskResults
Set	RiskCurveID		= RiskCurve. RiskCurveID
	,CurveProductID		= RawPriceLocale. RPLcleChmclParPrdctID
	,CurveChemProductID	= RawPriceLocale. RPLcleChmclChdPrdctID
	,CurveLcleID		= RawPriceLocale. RPLcleLcleID
	,CurveServiceID		= RawPriceLocale. RPLcleRPHdrID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.ProductInstrument (NoLock)	On	ProductInstrument. PrdctID			= #RiskResults. PrdctID
							And	ProductInstrument. InstrumentType		= ''F''
							And	ProductInstrument. DefaultSettlementType	= ''P''
	Inner Join dbo.RawPriceLocale (NoLock)		On	RawPriceLocale. RwPrceLcleID			= ProductInstrument. PhysicalRwPrceLcleID
	Left Outer Join dbo.RiskCurve (NoLock)		On	RiskCurve. RwPrceLcleID				= ProductInstrument. PhysicalRwPrceLcleID
							And	RiskCurve. PrceTpeIdnty				= ProductInstrument. PhysicalPriceTypeID
							And	RiskCurve. VETradePeriodID			= #RiskResults. VETradePeriodID -- BMM: this may not work if periods dont match
Where	#RiskResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ')
And	ProductInstrument. PhysicalRwPrceLcleID	Is Not Null
And	ProductInstrument. PhysicalPriceTypeID	Is Not Null'

If  IsNull(dbo.GetRegistryValue('\System\PortfolioAnalysis\Mark Physically Delivered Futures after Rolloff to Underlying Physical'), 'N') = 'Y'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- If we're showing historical exposure, we're going to keep the non-daily quotational around, so update the percentage columns.
-----------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure = 'H'
Begin
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	PricedInPercentage	= FormulaEvaluationPercentage.PricedInPercentage * FormulaEvaluationPercentage.TotalPercentage * RiskQuotationalExposure.FormulaPercentage
		,Percentage		= 1.0--FormulaEvaluationPercentage.PricedInPercentage
	From	' + @vc_TempTableName + ' #RiskResults
		Inner Join dbo.RiskQuotationalExposure		(NoLock)	On	RiskQuotationalExposure. RiskID				= #RiskResults. RiskID
		Inner Join dbo.FormulaEvaluationPercentage	(NoLock)	On	FormulaEvaluationPercentage. FormulaEvaluationID	= RiskQuotationalExposure. FormulaEvaluationID
		And	FormulaEvaluationPercentage. TotalPercentage		<>	0.0
		And	FormulaEvaluationPercentage.VETradePeriodID		=	#RiskResults.VETradePeriodID
		And	#RiskResults.EndOfDay					Between FormulaEvaluationPercentage. EndOfDayStartDate		And FormulaEvaluationPercentage. EndOfDayEndDate 		
	Where	#RiskResults.RiskType = "Q"
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End

----------------------------------------------------------------------------------------------
-- Delete the physical exposrue BALMO & Monthly Average Futures since we're tracking it on quotational records
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	NumberOfQuotesForPeriod	= IsNull(
				( 
				Select	Count(1)
				From	dbo.FormulaEvaluationQuote
				Where	FormulaEvaluationQuote. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
				And	FormulaEvaluationQuote. VETradePeriodID		= #RiskResults. VETradePeriodID
				), 0)
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
'
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------
-- Create Temp Tables
-------------------------------------------------------------
Create	Table	#Exposure
(
	Idnty				Int		Not Null Identity
	,ParentIdnty			Int		Not Null
	,RiskResultsIdnty		Int		Not Null
	,RiskExposureTableIdnty		Int		Null
	,SourceTable			Varchar(3)	Not Null
	,DlDtlPrvsnRwID			Int		Null
	,IsQuotational			Bit		Not Null
	,CurveLevel			SmallInt	Not Null
	,ParentRiskCurveID		Int		Null		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
	,RiskCurveID			Int		Null 		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
	,QuoteDate			SmallDateTime	Not Null
	,AdjustedQuoteDate		SmallDateTime	Not Null
	,Position			Float		Null
	,Percentage			Float		Null
	,IsBottomLevel			Bit		Not Null Default 1
	,InstanceDateTime		SmallDateTime	Not Null
	,EndOfDay			SmallDateTime	Not Null
	,CalendarId			SmallInt	Null
	,ExposurePercentage		Float		Null
	,QuoteDateIsDefault		Bit		Not Null Default 0	-- Used for Physical exposure since the quote date defaults to today.  Needed so decomposed daily physical exposure isn't excluded
	,PromptVETradePeriodID		SmallInt	Null			-- Used for provisions that are set to roll to prompt for expired periods (Platts WTI)
	,CurveStructure			Varchar(100)	Null
	,CurveStructureDescription	Varchar(1000)	Null
	,UseCurrentActual			Varchar(75)	Null
	,RPRPDtlIdnty				Int		Null
	,IsExpiredCurve			Bit Not Null Default 0
	,IsPromptCurve			Bit		Not Null	Default 0	-- This is obsolete
	,IsMonthlyDecomposedPhysical	Bit	Not Null Default 1	-- Is it normal monthly exposure.  Needed for showing daily exposure for physical curves that decompose.  HK & Balmo would be 0
	,RiskCurveExposureID		Int	Not Null
	,CashSettledFuturesOverrideEndOfDay	SmallDateTime	Null
	,IsRiskCurveExposureQuote	Bit		Not Null Default 0
)
Create Clustered Index PK_#Exposure on #Exposure (Idnty)
Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)

If @c_OnlyShowSQL = 'Y'
	Select '
	Create	Table	#Exposure
	(
		Idnty				Int		Not Null Identity
		,ParentIdnty			Int		Not Null
		,RiskResultsIdnty		Int		Not Null
		,RiskExposureTableIdnty		Int		 Null
		,SourceTable			Varchar(3)	Not Null
		,DlDtlPrvsnRwID			Int		Null
		,IsQuotational			Bit		Not Null
		,CurveLevel			SmallInt	Not Null
		,ParentRiskCurveID		Int		Null		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
		,RiskCurveID			Int		Null 		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
		,QuoteDate			SmallDateTime	Not Null
		,AdjustedQuoteDate		SmallDateTime	Not Null
		,Position			Float		Null
		,Percentage			Float		Null
		,IsBottomLevel			Bit		Not Null Default 1
		,InstanceDateTime		SmallDateTime	Not Null
		,CalendarId			SmallInt	Null
		,EndOfDay			SmallDateTime	Not Null
		,ExposurePercentage		Float		Null
		,QuoteDateIsDefault		Bit		Not Null Default 0 
		,PromptVETradePeriodID		SmallInt	Null			-- Used for provisions that are set to roll to prompt for expired periods (Platts WTI)
		,CurveStructure			Varchar(100)	Null
		,CurveStructureDescription	Varchar(1000)	Null
		,UseCurrentActual			Varchar(75)	Null
		,RPRPDtlIdnty				Int		Null
		,IsExpiredCurve			Bit Not Null Default 0
		,IsPromptCurve			Bit		Not Null	Default 0		-- This is obsolete
		,IsMonthlyDecomposedPhysical	Bit	Not Null Default 1	-- Is it normal monthly exposure.  Needed for showing daily exposure for physical curves that decompose.  HK & Balmo would be 0
		,RiskCurveExposureID		Int	Not Null
		,CashSettledFuturesOverrideEndOfDay	SmallDateTime	Null
		,IsRiskCurveExposureQuote	Bit		Not Null Default 0
	)
	Create Clustered Index PK_#Exposure on #Exposure (Idnty)
	Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
	Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
	Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)
	'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Results Temp Table
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if @c_OnlyShowSQL = 'Y'
	Select	'
	Create Table #ExposureResults
		(
		Idnty			Int	Not Null 	Identity
		,RiskResultsIdnty	Int	Not Null
		,RiskExposureTableIdnty Int	 Null
		,RiskCurveID			Int		Null
		,CurveLevel			SmallInt	Not Null
		,Percentage			Float		Null
		,TotalPercentage		Float		Null
		,Position			Float		Null
		,PricedInPercentage		Float		Null
		,QuoteDate			SmallDateTime	Null	-- Daily Exposure Only
		,QuoteStartDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,QuoteEndDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,IsBasisCurve			Bit		Not Null 	Default 0
		,IsDailyPricingRow		Bit		Not Null	Default 0
		,MonthlyRatioPercentage		Float		Null
		,CurveStructureDescription	Varchar(1000)	Null
		)
	Create NonClustered Index IE_#ExposureResults_RiskResultsIdnty on #ExposureResults (RiskResultsIdnty)
	'

If dbo.GetTableColumns('#ExposureResults') Not like '%RiskResultsIdnty%'
Begin
	Create Table #ExposureResults
		(
		Idnty			Int	Not Null	Identity
		,RiskResultsIdnty	Int	Not Null
		,RiskExposureTableIdnty Int	 Null
		,RiskCurveID			Int		Null
		,CurveLevel			SmallInt	Not Null
		,Percentage			Float		Null
		,TotalPercentage		Float		Null
		,Position			Float		Null
		,PricedInPercentage		Float		Null
		,QuoteDate			SmallDateTime	Null	-- Daily Exposure Only
		,QuoteStartDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,QuoteEndDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,IsBasisCurve			Bit		Not Null 	Default 0
		,IsDailyPricingRow		Bit		Not Null	Default 0
		,MonthlyRatioPercentage		Float		Null
		,CurveStructureDescription	Varchar(1000)	Null
		)
		
	Create NonClustered Index IE_#ExposureResults_RiskResultsIdnty on #ExposureResults (RiskResultsIdnty)
End

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Add CurveStructureDescription Column if it's been added to the report
--------------------------------------------------------------------------------------------------------------------------------------------------
If	dbo.GetTableColumns(@vc_TempTableName)	Not like '%CurveStructureDescription%'
And	(
	@c_OnlyShowSQL = 'Y' 
Or	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
	)
Begin
	Select @vc_DynamicSQL = '
	Alter Table ' + @vc_TempTableName + '	Add	CurveStructureDescription	Varchar(1000)	Null
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL  + Case When @c_OnlyShowSQL = 'Y' Then Char(10) + Char(13) + 'G' + 'o' Else '' End
	Execute(@vc_DynamicSQL)
End

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for Physical Exposure for CurveLevel 0
------------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Insert	#Exposure
(
	RiskResultsIdnty
	,ParentIdnty
	,RiskExposureTableIdnty
	,SourceTable
	,DlDtlPrvsnRwID
	,IsQuotational
	,Position
	,Percentage
	,CurveLevel
	,ParentRiskCurveID
	,RiskCurveID
	,InstanceDateTime
	,EndOfDay
	,QuoteDate
	,AdjustedQuoteDate
	,IsBottomLevel
	,QuoteDateIsDefault
	,IsMonthlyDecomposedPhysical
	,CurveStructure
	,RiskCurveExposureID
)
Select	#RiskResults. Idnty
	,0	ParentIdnty
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlPrvsnRwID
	,#RiskResults. IsQuotational
	,#RiskResults. Position
	,#RiskResults. TotalPercentage
	,0 CurveLevel
	,#RiskResults. RiskCurveID	ParentRiskCurveID	-- Calculated
	,#RiskResults. RiskCurveID	RiskCurveID		-- Calculated
	,IsNull(#RiskResults. InstanceDateTime, getdate()) InstanceDateTime
	,#RiskResults. EndOfDay
	,Case	When #RiskResults. DlDtlTmplteID Not In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Then IsNull(RiskPhysicalExposure. QuoteDate, #RiskResults. EndOfDay)
		Else #RiskResults. EndOfDay
	End QuoteDate
	,Case	When #RiskResults. DlDtlTmplteID Not In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Then IsNull(RiskPhysicalExposure. QuoteDate, #RiskResults. EndOfDay)
		Else #RiskResults. EndOfDay
	End	 AdjustedQuoteDate
	,Case	When RawPriceLocale. DecomposePhysicalExposure = 0 
		And Not Exists (
				Select	1
				From	dbo.ProductInstrument	(NoLock)
				Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
				And	ProductInstrument. InstrumentType	= ''F''
				And	ProductInstrument. DefaultSettlementType = ''C''
				)
		And #RiskResults.IsQuotational = 0 Then 1
		When RawPriceLocale. DecomposeQuotationalExposure = 0 And #RiskResults.IsQuotational = 1 Then 1 Else 0 End	IsBottomLevel
	,Case	When	#RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Or	RiskPhysicalExposure. QuoteDate Is Null
		Then 1 Else 0
	End QuoteDateIsDefault
	,1 IsMonthlyDecomposedPhysical
	,#RiskResults. RiskCurveID	-- CurveStructure
	,0	RiskCurveExposureID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RawPriceLocale			On	RawPriceLocale. RwPrceLcleID			= #RiskResults. RwPrceLcleID
	Left Outer Join dbo.RiskPhysicalExposure	On	RiskPhysicalExposure. RiskPhysicalExposureID	= #RiskResults. RiskExposureTableIdnty
											' + Case When @b_IsCurrentExposure = 'Y' Then ' And  1 = 2 ' Else ' ' End + '
Where	#RiskResults. RiskCurveID			Is Not Null
And	#RiskResults. IsQuotational			= Convert(Bit, 0)
And	RawPriceLocale. DecomposePhysicalExposure	= Convert(Bit, 1)
And	Not (IsCashSettledFuture = 1 And #RiskResults.PricedInPercentage = 1)'

if @b_ShowRiskDecomposed= 1
begin
    if @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for Quotational Exposure for CurveLevel 0 - Daily
-- Curves with Calculated Price Types will be Split into Seperate rows with the noncalculated RiskCurveIDs
------------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Insert	#Exposure
(
	RiskResultsIdnty
	,ParentIdnty
	,RiskExposureTableIdnty
	,SourceTable
	,DlDtlPrvsnRwID
	,IsQuotational
	,Position
	,Percentage
	,CurveLevel
	,ParentRiskCurveID	-- Calculated
	,RiskCurveID		-- Calculated
	,InstanceDateTime
	,EndOfDay
	,QuoteDate
	,AdjustedQuoteDate
	,IsBottomLevel
	,IsMonthlyDecomposedPhysical
	,CurveStructure
	,RiskCurveExposureID
)
Select	#RiskResults. Idnty
	,0		ParentIdnty
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlPrvsnRwID
	,#RiskResults. IsQuotational
	,#RiskResults. Position * Case When NumberOfQuotesForPeriod = 0.0 Then 1.0 Else (Convert(Float, Convert(Float, 1.0) / NumberOfQuotesForPeriod )) End--(DateDiff(Day, FormulaEvaluationPercentage. QuoteRangeBeginDate, FormulaEvaluationPercentage. QuoteRangeEndDate) + 1)))-- * #RiskResults. TotalPercentage) -- Convert(Float,(Convert(Float, 1.0) / #RiskResults. TotalPercentage)))
	,Convert(Float, Convert(Float, 1.0) / FormulaEvaluation. NumberOfQuotes) Percentage
	,0 CurveLevel
	,#RiskResults. RiskCurveID	ParentRiskCurveID
	,#RiskResults. RiskCurveID	RiskCurveID 
	,IsNull(#RiskResults. InstanceDateTime, getdate()) InstanceDateTime
	,#RiskResults. EndOfDay
	,Case When #RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ') Then #RiskResults. EndOfDay Else FormulaEvaluationQuote. QuoteDate End
	,Case When #RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ') Then #RiskResults. EndOfDay Else FormulaEvaluationQuote. QuoteDate End
	,Case When RawPriceLocale. DecomposeQuotationalExposure = 0 Then 1 Else 0 End IsBottomLevel
	,0 IsMonthlyDecomposedPhysical
	,#RiskResults. RiskCurveID	-- CurveStructure
	,0	RiskCurveExposureID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RawPriceLocale		On	RawPriceLocale. RwPrceLcleID			= #RiskResults. RwPrceLcleID
	Inner Join dbo.FormulaEvaluationPercentage	On	FormulaEvaluationPercentage. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
							And	FormulaEvaluationPercentage. VETradePeriodID		= #RiskResults. VETradePeriodID
							And	#RiskResults. EndOfDay	Between FormulaEvaluationPercentage. EndOfDayStartDate and FormulaEvaluationPercentage. EndOfDayEndDate
	Inner Join dbo.FormulaEvaluationQuote	On	FormulaEvaluationQuote. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
						And	FormulaEvaluationQuote. VETradePeriodID		= #RiskResults. VETradePeriodID
	Inner Join dbo.FormulaEvaluation	On	FormulaEvaluation. FormulaEvaluationID		= #RiskResults. FormulaEvaluationID
Where	(
	#RiskResults. RiskCurveID		Is Not Null
Or	#RiskResults. VETradePeriodID		= 0
	)
And	#RiskResults. IsQuotational		= Convert(Bit, 1)
' + Case 
	-- If we're not showing daily exposure, then don't insert quotes since the original row in #RiskResults is all that's needed
	When @c_ShowDailyExposure = 'N' Then '
And	RawPriceLocale. DecomposeQuotationalExposure = Convert(Bit, 1)'
	When @c_ShowDailyExposure <> 'H' Then '
And	Convert(SmallDateTime, Convert(VarChar(12), FormulaEvaluationQuote. QuoteDate))	> #RiskResults. EndOfDay
' Else '' End
 -- JGV - No need to filter out "IsCashSettledFuture" because it'll fall out of the join to FormulaEvaluation
 -- BMM - Can't add the filter for FormulaEvaluationQuote > EOD, because the priced in % will not calculate correctly.


if @b_ShowRiskDecomposed= 1  Or @c_ShowDailyExposure <> 'N'
begin
    if @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- If we're not showing daily, then delete rows that don't have any rows in RiskCurveExposure.  Hopefully this helps performance
------------------------------------------------------------------------------------------------------------------------------------------------
If  @c_ShowDailyExposure = 'N'
Begin
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	From	#Exposure
		Inner Join dbo.RiskCurveRelation (NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
	Where	Not Exists	(
		Select 1
		From	dbo.RiskCurveExposure (NoLock)
		Where	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
		and	RiskCurveExposure. Percentage		<> 0.0
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-- Update the position for priced in % if there's no Exposure records.  This needs to be done here since it's handled after decomposition
	Select	@vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	= Position  * (1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else #RiskResults. PricedInPercentage / #RiskResults. TotalPercentage End)
	From	' + @vc_TempTableName + ' #RiskResults
	Where	#RiskResults. IsQuotational = Convert(Bit, 1)
	And	#RiskResults. DlDtlTmplteID	Not In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
	And	Not Exists	(
		Select 1
		From	dbo.#Exposure
		Where	#Exposure. RiskResultsIdnty	= #RiskResults. Idnty
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
End
------------------------------------------------------------------------------------------------------------------------------------------------
-- If we are showing daily exposure, then update is bottom level if there's no rows in RiskCurveExposure
------------------------------------------------------------------------------------------------------------------------------------------------
Else
Begin
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	IsBottomLevel	= Convert(Bit, 1)
	From	#Exposure
		Inner Join dbo.RiskCurveRelation (NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
	Where	Not Exists	(
		Select 1
		From	dbo.RiskCurveExposure (NoLock)
		Where	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
		and	RiskCurveExposure. Percentage		<> 0.0
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--Skip decompose logic for historical days.
	If @c_ShowDailyExposure = 'H'
	Begin
		Select	@vc_DynamicSQL = '
		Update	#Exposure
		Set	IsBottomLevel	= Convert(Bit, 1)
		From	#Exposure			
		Where	#Exposure.QuoteDate	< #Exposure.EndOfDay
		And	#Exposure.IsQuotational	= Convert(Bit, 1)'
	
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End	
End



If @c_OnlyShowSQL = 'Y'
	Select '
	-- Delete #Exposure Where QuoteDate <> ''2005-06-01''
	'
------------------------------------------------
-- Update CurveStructureDescription
------------------------------------------------
Select	@vc_DynamicSQL_CurveDescription = 'Case 
        When IsNull(ParentExposure. CurveStructureDescription, '''') = '''' 
        Then Convert(Varchar, Convert(Decimal(6,2), 
		Case When IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 > 9999.99 Then 9999.99
                When IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 < -9999.99 Then -9999.99
		Else IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 End
	))  + "%-"
        Else IsNull(ParentExposure. CurveStructureDescription, '''') 
                + ''|||Level:@@CurveLevel@@=>|||'' 
                + Convert(Varchar, Convert(Decimal(6,2), 
                        Case When IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 > 9999.99 Then 9999.99
                        When IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 < 9999.99 Then -9999.99
		        Else IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 End 
        )) + "%-" 
        End 
	+ Convert(Varchar(66), Coalesce(Null, Convert(Varchar, RiskCurve. RiskCurveID) + "-" + RawPriceHeader. RPHdrAbbv + "-" + Product. PrdctAbbv + "@" + Locale. LcleAbbrvtn, "Unknown Curve") + "-" + IsNull(PriceType.PrceTpeNme, "N/A") + "-" + IsNull(VETradePeriod. Name, "N/A"))'
				
Select	@vc_DynamicSQL_UpdateCurveStructureDescription = '
Update	#Exposure
Set	CurveStructureDescription =	' + @vc_DynamicSQL_CurveDescription + '
From	#Exposure
	Inner Join RiskCurve		(NoLock)	On RiskCurve. RiskCurveID	= #Exposure. RiskCurveID
	Inner Join RawPriceLocale	(NoLock)	On RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Inner Join Product		(NoLock)	On RiskCurve.PrdctID		= Product.PrdctID
	Inner Join Locale		(NoLock)	On RiskCurve.LcleID		= Locale.LcleID
	Inner Join RawPriceHeader	(NoLock)	On RiskCurve.RPHdrID		= RawPriceheader.RPHdrID
	Inner Join VETradePeriod	(NoLock)	On RiskCurve.TradePeriodFromDate = VETradePeriod.StartDate
							And RiskCurve.TradePeriodToDate = VETradePeriod.EndDate
	Inner Join PriceType		(NoLock)	On RiskCurve.PrceTpeIdnty	= PriceType. Idnty
	Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty		= #Exposure. RiskResultsIdnty
	Left Outer Join #Exposure ParentExposure	On ParentExposure. Idnty = #Exposure. ParentIdnty
Where	#Exposure. CurveLevel	= @@CurveLevel@@
'

If	@c_OnlyShowSQL = 'Y' 
Or	dbo.GetTableColumns('#Exposure')	like '%CurveStructureDescription%'
Begin
	Select @vc_DynamicSQL = Replace(@vc_DynamicSQL_UpdateCurveStructureDescription, '@@CurveLevel@@', '0')
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End

------------------------------------------------
-- Create Temp table to hold distinct riskcurves
------------------------------------------------
While	@i_CurveLevel	< 10
And	@i_rowcount	> 0
------------------------------------------------------------------------------------------------------------------------------------------------
-- If we are showing daily exposure, but not showing decomposed, then don't allow for decomposition
------------------------------------------------------------------------------------------------------------------------------------------------
And	@b_ShowRiskDecomposed= 1 
Begin
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Calculated Price Type Riskcurves will use RiskCurveRelation to join RiskCurveExposure.RiskCurveID (Not Calculated).
	-- RiskCurveExposure.ChildRiskCurveID can be calculated and will save to #Exposure.RiskCurveID.
	-- Decomposing through multiple layers of average will result in calculated price type riskcurves in #Exposure.RiskCurveID & #Exposure.ParentRiskCurveID
	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	-------------------------------------------
	-- Increment Curve Level
	-------------------------------------------
	Select	@i_CurveLevel		= @i_CurveLevel + 1
		,@i_rowcount	= 0


	Select @vc_DynamicSQL = '
	Update	#Exposure
	Set	CashSettledFuturesOverrideEndOfDay	=	(
								Select	Min(RiskCurveExposure.EndOfDayStartDate)
								From	dbo.RiskCurveRelation	(NoLock)
									Inner Join dbo.RiskCurveExposure (NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
															And	RiskCurveExposure. QuoteStartDate	Is Null
															And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
								Where	RiskCurveRelation. RiskCurveID	= #Exposure. RiskCurveID
								And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
								And	RiskCurveExposure. Percentage	<> 0.0
								And Exists (select 1 from RiskCurveExposureQuote with (NoLock) where RiskCurveExposureQuote.RiskCurveExposureID	=	RiskCurveExposure.RiskCurveExposureID)
								)
	From	' + @vc_TempTableName + ' #RiskResults
		Inner Join #Exposure	On	#Exposure.RiskResultsIdnty	= #RiskResults.Idnty
	Where	#Exposure. CurveLevel			= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel		= Convert(Bit, 0)
	And	Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	Select @vc_DynamicSQL = '
	Update	#Exposure
	Set	CashSettledFuturesOverrideEndOfDay = NULL
	--select *
	From	#Exposure
	Inner Join dbo.' + @vc_TempTableName + '  #RiskResults
		On	#Exposure.RiskResultsIdnty					= #RiskResults.Idnty
	Inner Join dbo.RiskCurve (NoLock)
		On	#Exposure.RiskCurveID						= RiskCurve.RiskCurveID	
	Inner Join dbo.RawPriceLocalePricingPeriodCategory (NoLock)
		On	RiskCurve.RwPrceLcleID						= RawPriceLocalePricingPeriodCategory.RwPrceLcleID
	Inner Join dbo.PricingPeriodCategoryVETradePeriod
		On	RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID	= PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID
		And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= RiskCurve.VETradePeriodID
	Where	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement			= Convert(Bit, 1)
	And	#RiskResults.IsCashSettledFuture					= Convert(Bit, 1)
	And	#Exposure.CashSettledFuturesOverrideEndOfDay				< PricingPeriodCategoryVETradePeriod.RollOffBoardDate
	And	#Exposure.EndOfDay							>  #Exposure.CashSettledFuturesOverrideEndOfDay	
	'
	--BMM Commented this out since it appears like it will always undo the update from above since the bottom two filters will always be true.
	--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	
    DROP INDEX PK_#Exposure ON #Exposure;
	DROP INDEX IE_#Exposure ON #Exposure;
	DROP INDEX IE2_#Exposure ON #Exposure;
	DROP INDEX IE3_#Exposure ON #Exposure;

	Create Clustered Index PK_#Exposure on #Exposure (Idnty)
	Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
	Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
	Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)
	
	
	Select @vc_DynamicSQL_InsertTemplate = '
	Insert	#Exposure
	(
		ParentIdnty
		,RiskResultsIdnty
		,RiskExposureTableIdnty
		,SourceTable
		,DlDtlPrvsnRwID
		,IsQuotational
		,Position
		,Percentage
		,CurveLevel
		,ParentRiskCurveID	-- Calculated RiskCurveID
		,RiskCurveID		-- Calculated RiskCurveID
		,InstanceDateTime
		,EndOfDay
		,QuoteDate
		,AdjustedQuoteDate
		,ExposurePercentage
		,QuoteDateIsDefault
		,IsExpiredCurve
		,IsMonthlyDecomposedPhysical
		,CurveStructure
		,RiskCurveExposureID
		,IsRiskCurveExposureQuote
	)
	Select	#Exposure. Idnty
		,#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. SourceTable
		,RiskCurveExposure. DlDtlPrvsnRwID
		,#Exposure. IsQuotational
		,#Exposure. Position * @@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End Position
		,#Exposure. Percentage * @@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End Percentage
		,@@CurveLevel@@ CurveLevel
		,#Exposure. RiskCurveID		ParentRiskCurveID
		,RiskCurveExposure. ChildRiskCurveID		RiskCurveID
		,#Exposure. InstanceDateTime
		,#Exposure. EndOfDay
		,@@QuoteStartDate@@
		,@@QuoteStartDate@@
		,@@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End ExposurePercentage
		,@@QuoteDateIsDefault@@		QuoteDateIsDefault
		,@@IsExpiredCurve@@ IsExpiredCurve
		,@@IsMonthlyDecomposedPhysical@@ IsMonthlyDecomposedPhysical
		,#Exposure.CurveStructure + '','' + Convert(VarChar, RiskCurveExposure.ChildRiskCurveID)
		,RiskCurveExposure.RiskCurveExposureID
		,@@IsRiskCurveExposureQuote@@ IsRiskCurveExposureQuote'
		--,#Exposure. CurveStructure + ''-'' + Case	When	Min(RiskCurveRelation. RiskCurveID) = Min(RiskCurveRelation. NonCalculatedRiskCurveID)
		--							Then	Convert(Varchar, Min(RiskCurveExposure. RiskCurveExposureID) )
		--							Else	Convert(Varchar, Min(RiskCurveExposure. RiskCurveExposureID)) + '','' + Convert(Varchar, Max(RiskCurveExposure. RiskCurveExposureID))
		--							End	CurveStructure

	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Simple Curves (No Exposure Quotes or Nonmonthly Quote Ranges)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	RiskCurveExposure. QuoteStartDate	Is Null
									And	IsNull(#Exposure.CashSettledFuturesOverrideEndOfDay, #Exposure. EndOfDay)	Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
									' + Case When @i_CurveLevel > 1 Then '
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
									' Else '' End + '
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0'
				
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', '#Exposure. AdjustedQuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposure')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '#Exposure. QuoteDateIsDefault')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 0)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', 'Case When #Exposure. IsQuotational = 1 Then 0 Else 1 End ')

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
	Select @i_rowcount = @i_rowcount  + @@RowCount
	
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + '
	And	Exists		(
				Select	1
				From	dbo.RiskCurveExposureQuote	(NoLock)
				Where	RiskCurveExposureQuote. RiskCurveExposureID	= #Exposure. RiskCurveExposureID
				)'
				
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL  Else Execute (@vc_DynamicSQL)
	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Curves with Exposure Quotes (HK)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	RiskCurveExposure. QuoteStartDate	Is Null
									And	IsNull(#Exposure.CashSettledFuturesOverrideEndOfDay, #Exposure. EndOfDay)		Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
									-- BMM Changed to use EOD along with other refactoring work
									--And	#Exposure. AdjustedQuoteDate	Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
		Inner Join dbo.RiskCurveExposureQuote	(NoLock)	On	RiskCurveExposureQuote. RiskCurveExposureID	= RiskCurveExposure. RiskCurveExposureID
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0
	And	Not Exists	( -- Dont insert if theres already a quote with the same curve higher up.  This prevents performance problems with Monthly Averages decomposing into Monthly Averages multiple times
			Select	1
			From	#Exposure	Sub
			Where	Sub.RiskResultsIdnty		= #Exposure. RiskResultsIdnty
			And	Sub.RiskExposureTableIdnty	= #Exposure. RiskExposureTableIdnty
			And	Sub. CurveLevel			< ' + Convert(varchar, @i_CurveLevel) + '
			And	Sub.ParentRiskCurveID		= RiskCurveExposure. ChildRiskCurveID
			And	Sub.AdjustedQuoteDate		= RiskCurveExposureQuote. QuoteDate
				)
	'

	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', 'RiskCurveExposureQuote. QuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposureQuote')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 1)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', '0')

	If @b_RiskCurveExposureQuote_Table_HasRows = Convert(bit, 1)
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
		Select @i_rowcount = @i_rowcount  + @@RowCount
	End

	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Curves with Exposure Quotes (Nonmonthly Quote Ranges)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	#Exposure. EndOfDay			Between RiskCurveExposure. EndOfDayStartDate And RiskCurveExposure. EndOfDayEndDate
									And	#Exposure. AdjustedQuoteDate		Between	RiskCurveExposure. QuoteStartDate and RiskCurveExposure. QuoteEndDate
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0
	'

	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', '#Exposure. AdjustedQuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposure')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '#Exposure. QuoteDateIsDefault')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 0)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', 'Case When #Exposure. IsQuotational = 1 Then 0 Else 1 End ')

	If @b_RiskCurveExposure_Table_HasNonMonthlyRows = Convert(bit, 1)
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
		Select @i_rowcount = @i_rowcount  + @@RowCount
	End
	
	-- Update the CurveLevelDescription Column
	If	@c_OnlyShowSQL = 'Y' 
	Or	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
	Begin
		Select @vc_DynamicSQL = Replace(@vc_DynamicSQL_UpdateCurveStructureDescription, '@@CurveLevel@@', Convert(Varchar, @i_CurveLevel))
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete for UseForRisk
	---------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	From	#Exposure
		Inner Join dbo.RiskCurve	(NoLock)	On	RiskCurve. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RawPriceLocale	(NoLock)	On	RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Where	RawPriceLocale. UseForRisk	= ''N''
	And	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel)
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Update Period/RiskCurve for curves that need to roll to prompt period
	---------------------------------------------------------------------------------------------------------------------------------------------
	Exec dbo.SRA_Risk_Exposure_UpdateExpiredPeriods 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
								,@i_P_EODSnpShtLgID	= @i_P_EODSnpShtLgID
								,@i_Compare_P_EODSnpShtID = @i_Compare_P_EODSnpShtID
								,@b_IsReport		= @b_IsReport
								,@i_CurveLevel 		= @i_CurveLevel
								,@c_OnlyShowSQL		= @c_OnlyShowSQL
								
	-------------------------------------------------------------------------------------------------------------------------------------
	-- Determine if Use Latest Actuals, Propogate Latest Actuals, & Use Actual for Curve Detail is used
	-------------------------------------------------------------------------------------------------------------------------------------
	Exec dbo.SRA_Risk_Exposure_UseLatestActuals_Delete		@i_CurveLevel 		= @i_CurveLevel
									,@c_OnlyShowSQL		= @c_OnlyShowSQL
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Update IsBottomLevel & Calendar
	---------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	CalendarID	= RawPriceLocale. CalendarID
		,IsBottomLevel	= Case When	(
						RawPriceLocale. DecomposePhysicalExposure	= Convert(Bit, 0)
					And	#Exposure. IsQuotational			= Convert(Bit, 0)
						)
					Or	(
						RawPriceLocale. DecomposeQuotationalExposure	= Convert(Bit, 0)
					And	#Exposure. IsQuotational			= Convert(Bit, 1)
						)
						Then 1 Else 0 End
	From	#Exposure
		Inner Join dbo.RiskCurve	(NoLock)	On	RiskCurve. RiskCurveID			= #Exposure. RiskCurveID
		Inner Join dbo.RawPriceLocale	(NoLock)	On	RawPriceLocale. RwPrceLcleID		= RiskCurve. RwPrceLcleID
	Where	#Exposure. CurveLevel	= ' + Convert(varchar, @i_CurveLevel) + '
	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------------------------
	-- Adjust the quote date for First Before (Exclude & First After aren't supported).
	------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	AdjustedQuoteDate	=	(
						Select	Max(FirstBefore. Date)
						From	dbo.CalendarDate FirstBefore	(NoLock)
						Where	FirstBefore. CalendarID		= #Exposure. CalendarID
						And	FirstBefore. BusinessDay	= Convert(Bit, 1)
						And	FirstBefore. Date		< #Exposure. AdjustedQuoteDate
						)
	From	#Exposure
	Where	#Exposure. CurveLevel	= ' + Convert(varchar, @i_CurveLevel) + '
	And	Exists	(
			Select 1
			From	dbo.CalendarDate	(NoLock)
			Where	CalendarDate. CalendarID	= #Exposure. CalendarID
			And	CalendarDate. Date		= #Exposure. AdjustedQuoteDate
			And	CalendarDate. BusinessDay	= Convert(Bit, 0)
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	-- Exit if we're debugging
	If @c_OnlyShowSQL = 'Y' and @i_CurveLevel = 3
	Begin
		Select @i_CurveLevel = 10
		Select '-- END LOOP'	
	End
End


---------------------------------------------------------------------------------------------------------------------------------------------
-- Now Update IsBottomLevel for curves whos curve is set to decompose, but there's not any forward curves setup to decompose into
-- BMM Added this because HK futures initially insert with a quotedate of EOD, but then they decompose using Delivery Start to End/RiskCurveExposureQuote which causes the quote dates to not match
---------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Update #Exposure
Set    IsBottomLevel              = Convert(Bit, 1)
From   #Exposure
Where  #Exposure. IsBottomLevel   = Convert(Bit, 0)
And    Not Exists    (
                     Select 1
                     From   dbo.#Exposure HigherLevelExposure
                     Where  HigherLevelExposure. RiskExposureTableIdnty     = #Exposure. RiskExposureTableIdnty
                     And    HigherLevelExposure. SourceTable         = #Exposure. SourceTable
                     And    HigherLevelExposure. IsQuotational       = #Exposure. IsQuotational
                     And    (
                                  HigherLevelExposure. IsRiskCurveExposureQuote = Convert(Bit, 1)
                           Or     HigherLevelExposure. QuoteDate                  = #Exposure. QuoteDate
                           )
                     And    HigherLevelExposure. CurveLevel                 > #Exposure. CurveLevel
                     And    HigherLevelExposure. ParentRiskCurveID          = #Exposure. RiskCurveID
                     )'


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

---------------------------------------------------------------------------------------------------------------------------------------------
-- Update Records that weren't caught from above update
-- BMM Added this because HK futures initially insert with a quotedate of EOD, but then they decompose using Delivery Start to End/RiskCurveExposureQuote which causes the quote dates to not match
---------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Update	#Exposure
Set	IsBottomLevel		= Convert(Bit, 0)
--Select *
From	#Exposure
Where	#Exposure. IsBottomLevel = Convert(Bit, 1)
And	Exists	(
		Select	1
		From	dbo.#Exposure HigherLevelExposure
		Where	HigherLevelExposure. RiskExposureTableIdnty	= #Exposure. RiskExposureTableIdnty
		And	HigherLevelExposure. SourceTable		= #Exposure. SourceTable
		And	HigherLevelExposure. IsQuotational		= #Exposure. IsQuotational
		--And	HigherLevelExposure. QuoteDate			= #Exposure. QuoteDate  -- Cant do this for exposures that use RiskCurveExposureQuote
		And	HigherLevelExposure. CurveLevel			> #Exposure. CurveLevel
		And	HigherLevelExposure. ParentIdnty		= #Exposure. Idnty
		And	HigherLevelExposure. IsBottomLevel		= Convert(Bit, 1)
		)'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Period Exposure by summing the daily.
-------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure Not In('H', 'Y')
Begin
	
	
	Select @vc_DynamicSQL = '
	Insert	#ExposureResults
	(
		RiskResultsIdnty
		,RiskExposureTableIdnty
		,CurveLevel
		,RiskCurveID
		,Position
		,Percentage
		,QuoteStartDate
		,QuoteEndDate
		,PricedInPercentage
		--,CurveStructure
		' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,CurveStructureDescription' Else '' End + '
	)
	Select	#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		,#Exposure. RiskCurveID
		,Sum(#Exposure. Position) Position
		,Sum(#Exposure. Percentage) Percentage
		,Min(#Exposure. AdjustedQuoteDate) QuoteStartDate
		,Max(#Exposure. AdjustedQuoteDate) QuoteEndDate
		,Case When Count(1) = 0 Then 1.0 Else Sum(Convert(Float, Case When  #Exposure. AdjustedQuoteDate <= #Exposure. EndOfDay Then 1.0 Else 0.0 End)) / Convert(Float, Count(1)) End	PricedInPercentage
		--,Convert(Varchar(30), #Exposure. CurveStructure) CurveStructure
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	From	#Exposure
		--Inner Join #RiskResults			On	#RiskResults. Idnty			= #Exposure. RiskResultsIdnty
		--Inner Join dbo.FormulaEvaluation	On	FormulaEvaluation. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
	Where	#Exposure. IsBottomLevel	= Convert(Bit, 1)
	Group By #Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		--,#Exposure. ParentRiskCurveID
		,#Exposure. RiskCurveID
		--,#Exposure. Percentage
		--,Convert(Varchar(30), #Exposure. CurveStructure)
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	---------------------------------------------------------------------------------------------------------
	-- Update the MonthlyRatioPercentage column
	---------------------------------------------------------------------------------------------------------
	if	Exists (
			Select	1 
			From	dbo.DealDetailProvisionRow (NoLock)
			Where	IsNull(DealDetailProvisionRow. MonthlyRatioRule, 'N') <> 'N'
			)
		Exec dbo.SRA_Risk_Reports_Decompose_Exposure_MonthlyRatio 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
										,@c_OnlyShowSQL		= @c_OnlyShowSQL
	
	---------------------------------------------------------------------------------------------------------
	-- Override the PricedInPercentage for Quotational Exposure for EFP Futures that must show
	-- Without this, the PricedInPercentage is 1.0 after the update above since QuoteDaet = EOD
	---------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	PricedInPercentage = #RiskResults. PricedInPercentage -- Should be 0.0
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty = #ExposureResults. RiskResultsIdnty
	Where	#ExposureResults. PricedInPercentage	<> #RiskResults. PricedInPercentage
	And	#RiskResults. IsQuotational		= 1
	And	#ExposureResults. CurveLevel		= 0
	And	#ExposureResults. QuoteStartDate	= #ExposureResults. QuoteEndDate
	And	#RiskResults. EndOfDay			= #ExposureResults. QuoteEndDate
	And	#RiskResults. DlDtlTmplteID		= 26000 -- EFP Future
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update the position based on priced in %.  Need to do this since we update non decomposed positions to: position * (1.0 - PricedInPercentage/TotalPercentage)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	Position		= #ExposureResults. Position 
						* Case	-- If Quotational or Physical exposure that decomposes into daily, i.e. HK
							When	#RiskResults. IsQuotational = Convert(bit, 1) 
							Or	Abs(DateDiff(day, #ExposureResults. QuoteStartDate, #ExposureResults. QuoteEndDate)) > 0
							Then	(1.0 - IsNull(#ExposureResults. PricedInPercentage, 0.0)) 
							Else	1.0 
						End * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
		--Position		= #ExposureResults. Position * (1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else IsNull(#ExposureResults. PricedInPercentage, 0.0) / #RiskResults. TotalPercentage End)
		,Percentage		= #ExposureResults. PricedInPercentage
		,TotalPercentage	= #RiskResults. TotalPercentage
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty'
	
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update the position based on priced in %.  Need to do this since we update non decomposed positions to: position * (1.0 - PricedInPercentage/TotalPercentage)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	PricedInPercentage	=  #RiskResults. PricedInPercentage * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0) -- Abs(#ExposureResults. Percentage * #RiskResults. TotalPercentage)
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty
	where Not Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)
	-- If a parent curve exists with the same price curve, do not do this logic for the child curve
	And	Not Exists	(
					select	1
					From	RiskCurve with (NoLock) 
					where	RiskCurve.RiskCurveID			= #ExposureResults.RiskCurveID
					and		#RiskResults.RwPrceLcleID		= RiskCurve.RwprceLcleID
					and		#ExposureResults.CurveLevel	>	#RiskResults.CurveLevel
					)	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	

End

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Daily Exposure
-------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure <> 'N'	-- Insert Daily Exposure
begin
	Select @vc_DynamicSQL = '
	Insert	#ExposureResults
	(
		RiskResultsIdnty
		,RiskExposureTableIdnty
		,CurveLevel
		,RiskCurveID
		,Position
		,Percentage
		,PricedInPercentage
		,TotalPercentage
		,QuoteDate
		--,CurveStructure
		,IsDailyPricingRow
		' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,CurveStructureDescription' Else '' End + '
	)
	Select	#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		,#Exposure. RiskCurveID
		,Sum(#Exposure. Position) Position
		,Sum(#Exposure. Percentage) Percentage
		,Sum(Abs(#Exposure. Percentage * #RiskResults. TotalPercentage))	PricedInPercentage
		,Min(#RiskResults. TotalPercentage) TotalPercentage
		,#Exposure. AdjustedQuoteDate -- QuoteDate
		--,Convert(Varchar(30), #Exposure. CurveStructure) CurveStructure
		,Case When #Exposure.QuoteDate is not null and "' + @c_ShowDailyExposure + '" in( "P" , "H" ) Then 1 Else 0 End
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	From	#Exposure
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #Exposure. RiskResultsIdnty
	Where	#Exposure. IsBottomLevel	= Convert(Bit, 1)
	' + Case When @c_ShowDailyExposure In("P", "H") Then '
	And	(
		#RiskResults. IsQuotational	= Convert(Bit, 1)
	Or	(	-- Dont show the Daily Pricing Event Row
			#RiskResults. IsQuotational	= Convert(Bit, 0)
		And	#RiskResults. IsDailyPricingRow	= Convert(Bit, 1)
		)) ' 
		-- If were not showing pricing events, then we need to allow the quote to decompose
		-- Commented the exists below since it was preventing NG physical decomposition.  The only issue that may be left is BALMO and HK decomposition
		Else "" End + '
	' + Case When @c_ShowDailyExposure <> 'H' Then '
	And	(
		#Exposure. AdjustedQuoteDate		> #RiskResults. EndOfDay
	Or	#Exposure. QuoteDateIsDefault		= Convert(Bit, 1)
--	Or	#Exposure. IsMonthlyDecomposedPhysical	= Convert(Bit, 1)
		)
	' Else '' End + '	
	Group By	#Exposure. RiskResultsIdnty
			,#Exposure. RiskExposureTableIdnty
			,#Exposure. CurveLevel
			,#Exposure. RiskCurveID
			,#Exposure. AdjustedQuoteDate -- QuoteDate
			,Case When #Exposure.QuoteDate is not null and "' + @c_ShowDailyExposure + '" in( "P" , "H" ) Then 1 Else 0 End
			' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
			,#Exposure. CurveStructureDescription' Else '' End + '
	'
	-- Need to do a group by since Adjusted QuoteDates, i.e. first befores, need to be grouped

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	---------------------------------------------------------------------------------------------------------
	-- Update the MonthlyRatioPercentage column
	---------------------------------------------------------------------------------------------------------
	if	Exists (
			Select	1 
			From	dbo.DealDetailProvisionRow (NoLock)
			Where	IsNull(DealDetailProvisionRow. MonthlyRatioRule, 'N') <> 'N'
			)
		Exec dbo.SRA_Risk_Reports_Decompose_Exposure_MonthlyRatio 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
										,@c_OnlyShowSQL		= @c_OnlyShowSQL

	--------------------------------------------------
	-- Update the position based on Monthly Ratio %.  
	--------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	Position		= #ExposureResults. Position * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
		,PricedInPercentage	=  #ExposureResults. PricedInPercentage * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty
	where Not Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

End


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Decomposed Curve back into #RiskResults
-------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Insert	' + @vc_TempTableName + '
(
	RiskID
	,ExposureID
	,RiskExposureTableIdnty
	,FormulaEvaluationID
	,SourceTable
	,DlDtlTmplteID
	,IsInventory
	,IsPrimaryCost
	,RiskCurveID
	,RwPrceLcleID
	,VETradePeriodID
	,PeriodStartDate
	,PeriodEndDate
	,PrceTpeIdnty
	,CrrncyID
	,RiskType
	,IsQuotational
	,DlDtlPrvsnID
	,DlDtlPrvsnRwID
	,Percentage
	,PricedInPercentage
	,TotalPercentage
	,InstanceDateTime
	,EndOfDay
	,CurveLevel
	,ExposureStartDate
	,ExposureQuoteStartDate
	,ExposureQuoteEndDate
	,OriginalPhysicalPosition
	,Position
	,IsDailyPricingRow
	,SpecificGravity
	,Energy
	,CurveServiceID
	,CurveProductID
	,CurveChemProductID
	,CurveLcleID
	--,CurveStructure
	' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
	,CurveStructureDescription' Else '' End + '
	,DlHdrID
	,DlDtlId
	,PrdctID
	,ChmclID
	,LcleID
	,StrtgyID
	' + Case When @b_IsCurrentExposure = 'Y' Then '
	,ValueID
	,SourceID' Else '' End + '
)
Select	#RiskResults. RiskID
	,#RiskResults. ExposureID
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. FormulaEvaluationID
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlTmplteID
	,#RiskResults. IsInventory
	,#RiskResults. IsPrimaryCost
	,RiskCurve. RiskCurveID -- #RiskResults. RiskCurveID  TFS: 51712
	,IsNull(RiskCurve. RwPrceLcleID, #RiskResults. RwPrceLcleID)
	,IsNull(RiskCurve. VETradePeriodID, #RiskResults. VETradePeriodID)
	,IsNull(RiskCurve. TradePeriodFromDate, #RiskResults. PeriodStartDate)
	,IsNull(RiskCurve. TradePeriodToDate, #RiskResults. PeriodEndDate)
	,IsNull(RiskCurve. PrceTpeIdnty, #RiskResults. PrceTpeIdnty)
	,IsNull(RiskCurve. CrrncyID, #RiskResults. CrrncyID)
	,#RiskResults. RiskType
	,#RiskResults. IsQuotational
	,#RiskResults. DlDtlPrvsnID
	,#RiskResults. DlDtlPrvsnRwID
	,#ExposureResults. Percentage
	,#ExposureResults. PricedInPercentage
	,#ExposureResults. TotalPercentage
	,IsNull(#RiskResults. InstanceDateTime, getdate())
	,#RiskResults. EndOfDay
	,#ExposureResults. CurveLevel
	,#ExposureResults.QuoteDate	ExposureStartDate
	,#ExposureResults.QuoteStartDate
	,#ExposureResults.QuoteEndDate
	,#RiskResults.OriginalPhysicalPosition
	,#ExposureResults. Position
	,#ExposureResults. IsDailyPricingRow
	,#RiskResults.SpecificGravity
	,#RiskResults.Energy
	,IsNull(RiskCurve.RPHdrID, #RiskResults. CurveServiceID)
	,IsNull(RiskCurve.PrdctID, #RiskResults. CurveProductID)
	,IsNull(RiskCurve.ChmclID, #RiskResults. CurveChemProductID)
	,IsNull(RiskCurve.LcleID, #RiskResults. CurveLcleID)
	--,#ExposureResults. CurveStructure
	' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
	,#ExposureResults. CurveStructureDescription' Else '' End + '
	,#RiskResults.DlHdrID
	,#RiskResults.DlDtlId
	,#RiskResults.PrdctID
	,#RiskResults.ChmclID
	,#RiskResults.LcleID
	,#RiskResults.StrtgyID
	' + Case When @b_IsCurrentExposure = 'Y'  /* or @c_OnlyShowSQL = 'Y' */ Then '
	,#RiskResults. ValueID
	,#RiskResults. SourceID' Else '' End + '
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join #ExposureResults			On #ExposureResults. RiskResultsIdnty	= #RiskResults. Idnty
	Left Outer Join dbo.RiskCurve	(NoLock)	On RiskCurve. RiskCurveID		= #ExposureResults. RiskCurveID

'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------
-- Delete the original records that were inserted into #RiskResults (CurveLevel 0)
-------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	Exists	(
	Select	1
	From	#ExposureResults
	Where	#ExposureResults. RiskResultsIdnty	= #RiskResults. Idnty
		)
' + Case	When	@c_ShowDailyExposure = 'H' 
		Then	'And	#RiskResults.RiskType	<> "Q"'
		Else	'' 
		End


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Futures that have rolled off ( Need this since some futures are quotational which means the end date of RiskCurveLink won't work
-----------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Create Table #ExposuresToExpire
(
	RiskResultsIdnty	Int Not Null
	,EndOfDay		SmallDateTime	Not Null
	,InstanceDateTime	SmallDateTime	Not Null
	,CalendarID		SmallInt	Null
	,CurveRollOffDate	SmallDateTime	Null
	,EarlyRollOffDays	Int		Null
	,AdjustedRollOffDate	SmallDateTime	Null
	,DlDtlPrvsnID		Int		Null
)
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL

Create Table #ExposuresToExpire
(
	RiskResultsIdnty	Int Not Null
	,EndOfDay		SmallDateTime	Not Null
	,InstanceDateTime	SmallDateTime	Not Null
	,CalendarID		SmallInt	Null
	,CurveRollOffDate	SmallDateTime	Null
	,EarlyRollOffDays	Int		Null
	,AdjustedRollOffDate	SmallDateTime	Null
	,DlDtlPrvsnID		Int		Null
)

Select @vc_DynamicSQL = '
Insert	#ExposuresToExpire
(
	RiskResultsIdnty
	,InstanceDateTime
	,EndOfDay
	,CurveRollOffDate
	,CalendarID
	,DlDtlPrvsnID
)
Select	#RiskResults. Idnty
	,IsNull(#RiskResults. InstanceDateTime, Current_timestamp)
	,#RiskResults. EndOfDay
	,DateAdd(day, -1, DateAdd(minute, 1, (
		Select	Max(PricingPeriodCategoryVETradePeriod. RollOffBoardDate)
		From	RawPriceLocalePricingPeriodCategory	(NoLock)
			Inner Join PricingPeriodCategoryVETradePeriod (NoLock)
								On	PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID	= RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID
								And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= RiskCurve. VETradePeriodID
		Where	RawPriceLocalePricingPeriodCategory.RwPrceLcleID		= RiskCurve. RwPrceLcleID
		And	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement		= Convert(Bit, 1)
		)))	RollOffBoardDate
	,RawPriceLocale. CalendarID
' + Case When @b_IsCurrentExposure = 'N' Then '	
	,(
		Select Max(DlDtlPrvsnID)
		From	dbo.Risk			(NoLock)	
			Inner Join dbo.RiskDealIdentifier	(NoLock)	On RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
			Inner Join dbo.RiskDealDetailProvision	(NoLock)	On RiskDealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= RiskDealIdentifier. DlHdrID
										And RiskDealDetailProvision. DlDtlPrvsnDlDtlID		= RiskDealIdentifier. DlDtlID
		Where	Risk. RiskID					= #RiskResults. RiskID	
		And	RiskDealDetailProvision. Status			= ''A''
		And	RiskDealDetailProvision. CostType		= ''P''
		and	#RiskResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision.EndDate
	)
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RiskCurve		(NoLock)	On RiskCurve. RiskCurveID			= #RiskResults. RiskCurveID
' Else '
,(
		Select	Max(DlDtlPrvsnID)
		From	dbo.DealDetailProvision	(NoLock)
		Where	DealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= #RiskResults. DlHdrID
		And	DealDetailProvision. DlDtlPrvsnDlDtlID	= #RiskResults. DlDtlID	
		And	DealDetailProvision. Status		= ''A''
		And	DealDetailProvision. CostType		= ''P''
	)
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RiskCurve		(NoLock)	On RiskCurve. RiskCurveID			= #RiskResults. RiskCurveID
								And #RiskResults. CurveLevel			= 0
' End + '
	Inner Join dbo.RawPriceLocale		(NoLock)	On RawPriceLocale. RwPrceLcleID			= RiskCurve. RwPrceLcleID
Where	#RiskResults. DlDtlTmplteID	In( ' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
And	#RiskResults. IsQuotational	= Convert(Bit, 0)
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

Select @vc_DynamicSQL = '	
Update	#ExposuresToExpire
Set	AdjustedRollOffDate	= DateAdd(day, IsNull(Formula. EarlyRollOffDays, 0), 
					 Case	When	CalendarDate. BusinessDay	= 1
						Then	CurveRollOffDate
						When	CalendarDate. DayofWeek		= 7 -- Saturday
						Then	Case When IsNull(Formula. SaturdayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. SaturdayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
						When	CalendarDate. DayofWeek		= 1 -- Sunday
						Then	Case When IsNull(Formula. SundayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. SundayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
						Else	Case When IsNull(Formula. HolidayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. HolidayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
					End)
-- Select *
From	#ExposuresToExpire
	Inner Join dbo.CalendarDate		(NoLock)	On CalendarDate. CalendarID				= #ExposuresToExpire. CalendarID
									And CalendarDate. Date				= #ExposuresToExpire. CurveRollOffDate
	Inner Join dbo.CalendarDate	FirstBefore	(NoLock)	On FirstBefore. CalendarID			= #ExposuresToExpire. CalendarID
									And FirstBefore. Date				= (	Select	Max(FB.Date) 
																From	CalendarDate FB  (NoLock) 
																Where	FB. CalendarID	= #ExposuresToExpire. CalendarID
																And	FB. Date	< #ExposuresToExpire. CurveRollOffDate
																And	FB. BusinessDay	= 1
																)
	Inner Join dbo.CalendarDate	FirstAfter	(NoLock)	On FirstAfter. CalendarID			= #ExposuresToExpire. CalendarID
									And FirstAfter. Date				= (	Select	Min(FA.Date) 
																From	CalendarDate FA  (NoLock) 
																Where	FA. CalendarID	= #ExposuresToExpire. CalendarID
																And	FA. Date	> #ExposuresToExpire. CurveRollOffDate
																And	FA. BusinessDay	= 1
																)
	Left Outer Join	(
			Select	#ExposuresToExpire.RiskResultsIdnty
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute14, 0))	HolidayRule
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute15, 0))	SaturdayRule
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute16, 0))	SundayRule
				,Convert(tinyint, IsNull(DealDetailProvisionRow. PriceAttribute34, ''0''))	EarlyRollOffDays
			From	#ExposuresToExpire
				Inner Join dbo.DealDetailProvisionRow	(NoLock)	On DealDetailProvisionRow. DlDtlPrvsnID	= #ExposuresToExpire. DlDtlPrvsnID
			Where	DealDetailProvisionRow. DlDtlPRvsnRwTpe		= ''F''
			)	Formula	On Formula. RiskResultsIdnty	= #ExposuresToExpire. RiskResultsIdnty
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
			
Select @vc_DynamicSQL = '
    Delete	#RiskResults
    -- Select *
    From	' + @vc_TempTableName + ' #RiskResults
    Where	Exists	(
		Select	1 
		From	dbo.#ExposuresToExpire
		Where	#ExposuresToExpire. RiskResultsIdnty	= #RiskResults. Idnty
		And	#ExposuresToExpire. AdjustedRollOffDate	<= #RiskResults. EndOfDay
				)
	And Not Exists	(
			Select	1
			From	dbo.ProductInstrument
			Where	ProductInstrument. PrdctID				= #RiskResults. PrdctID
			And	ProductInstrument. InstrumentType			= ''F''	-- Future
			And	IsNull(ProductInstrument. DefaultSettlementType, ''Z'')	= ''P'' -- Physically Settled
			And	ProductInstrument. PhysicalRwPrceLcleID			Is Not Null
			And	ProductInstrument. PhysicalPriceTypeID			Is Not Null
			)'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------
-- Update Period Info
-------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	PricingPeriodCategoryVETradePeriodID	= PricingPeriodCategoryVETradePeriod. Idnty
	,PeriodName 				= Coalesce(PricingPeriodCategoryVETradePeriod. PricingPeriodName, VETradePeriod. Name, RiskCurvePeriod. Name)
	,PeriodAbbv				= Coalesce(PricingPeriodCategoryVETradePeriod. PricingPeriodAbbv, VETradePeriod. Name, RiskCurvePeriod. Name)
	,CurveRiskType				= RawPriceLocale.CurveType
	,IsBasisCurve				= RawPriceLocale. IsBasisCurve
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join RawPriceLocale			(NoLock)	On	RawPriceLocale. RwPrceLcleID 		= #RiskResults. RwPrceLcleID
	Left Outer Join RawPriceLocalePricingPeriodCategory (NoLock)	On	RawPriceLocalePricingPeriodCategory. RwPrceLcleID 		= #RiskResults. RwPrceLcleID
	Left Outer Join PricingPeriodCategoryVETradePeriod (NoLock)	On	RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID 	= PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID
									And	PricingPeriodCategoryVETradePeriod. VETradePeriodID 		= #RiskResults. VETradePeriodID
									And	#RiskResults.EndOfDay						Between PricingPeriodCategoryVETradePeriod. RollOnBoardDate and PricingPeriodCategoryVETradePeriod. RollOffBoardDate
	Left Outer Join VETradePeriod			(NoLock)	On	PricingPeriodCategoryVETradePeriod. VETradePeriodID		= VETradePeriod. VETradePeriodID
	Left Outer Join VETradePeriod RiskCurvePeriod (NoLock) 		On	RiskCurvePeriod. VETradePeriodID				= #RiskResults. VETradePeriodID'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------
-- Update Quote Date to End Of Day for Futures & ETO's.  Exclude BALMO & Monthly Ave Futures
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	ExposureStartDate	= #RiskResults. EndOfDay
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Futures All Types,Exchange Traded Options All Types') + ')
And	#RiskResults. IsQuotational	= Convert(Bit, 0)
And	Not Exists	(
		Select	1
		From	dbo.ProductInstrument	(NoLock)
		Where	ProductInstrument. PrdctID	= #RiskResults. PrdctID
		And	ProductInstrument. InstrumentType	= ''F''
		And	ProductInstrument. SettlementRule	In(''PB'', ''PA'')	-- Monthly Average or BALMO
		)'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the CurveDescription Column if we didn't insert into #Exposure (non daily only)
------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Update	#RiskResults
Set	CurveStructureDescription	= ' + @vc_DynamicSQL_CurveDescription + '
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join RiskCurve		(NoLock)	On RiskCurve. RiskCurveID	= #RiskResults. RiskCurveID
	Inner Join RawPriceLocale	(NoLock)	On RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Inner Join Product		(NoLock)	On RiskCurve.PrdctID		= Product.PrdctID
	Inner Join Locale		(NoLock)	On RiskCurve.LcleID		= Locale.LcleID
	Inner Join RawPriceHeader	(NoLock)	On RiskCurve.RPHdrID		= RawPriceheader.RPHdrID
	Inner Join VETradePeriod	(NoLock)	On RiskCurve.TradePeriodFromDate = VETradePeriod.StartDate
							And RiskCurve.TradePeriodToDate = VETradePeriod.EndDate
	Inner Join PriceType		(NoLock)	On RiskCurve.PrceTpeIdnty	= PriceType. Idnty
	Left Outer Join #Exposure ParentExposure	On 1 = 2  -- Need this since Im sharing the update
	Left Outer Join #Exposure			On 1 = 2
Where	IsNull(#RiskResults. CurveStructureDescription, '''') = ''''
'
If	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
Or	@c_OnlyShowSQL = 'Y' 
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------
-- Error Reporting
----------------------------------------------------------------------------------------------------------------------
noerror:
	Return
error:
	RAISERROR (N'%s %d',11,1,@errmsg,@errno) --48187



GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]
	@vc_StatementGrouping			VarChar(255)	= Null
	,@i_P_EODSnpShtID			Int 		= Null				-- The snapshotid of the data to get.  If it is null then get current "live" data
	,@i_Compare_P_EODSnpShtID		Int 		= Null				-- The snapshotid of the data to be compared.  It it is null then no compare is taking place
	,@i_id					Int		= 3				-- ID of the entity at the below level in the tree.  PrtflioID or StrtgyID
	,@vc_type				VarChar(100)	= 'PositionGroup'		-- Level in the tree valid values are 'Portfolio' or 'StrategyHeader' or 'UnassignedStrategies'
	,@i_TradePeriodFromID			Int		= 364				-- The VETradePeriodID that represents the from date to start in
	,@dt_maximumtradeperiodstartdate	SmallDateTime	= '2-1-2050 0:0:0.000'	-- The start date of the ending trade period to go to
	,@b_DiscountPositions			Bit		= 0
	,@vc_InventoryTypeCode			Char(1)		= 'B'
	,@c_Beg_Inv_SourceTable			Char(1)		= 'B'
	,@c_ExposureType			Char(1)		= 'N'	-- 'Y' or 'D' is Show Daily. ( Y was used in PB but isn't in .NET).  H - Historical with Pricing Events, P - Pricing Events
	,@c_ShowRiskType			Char(1)		= 'A'  --"F"lat, "B"asis, "A"ll
	,@b_ShowRiskDecomposed			Bit		= 1
	,@vc_AdditionalColumns			VarChar(Max)	= Null
	,@vc_TempTable				VarChar(200)	= '#RiskExposureResults'	-- .NET:  #RiskExposureResults		PB:  #RiskResults
	,@c_OnlyShowSQL				Char(1)		= 'N'
	
	-- PB & VC Parameters
	,@b_ShowZeroQuotational			Bit		= 0
	,@b_IsReport				Bit		= 1
	,@b_ShowCurrencyExposure		Bit		= 0
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables           
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Blake Doerr
-- History:	9/13/2010 - First Created
--
-- 	Date Modified 	Modified By		Issue#		Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	3.24.14			BMM				55889	Don't use precalculated sign logic for spreads on Position when determining exposure position signage when the deltas are signed properly.
--  5.2.14			JAK				55909	If #RiskExposureResults.CurveLevel is 0 we want to join directly to RawPriceLocale instead of joining through RiskOption.
-----------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
set Quoted_Identifier OFF

----------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------
Declare	@vc_DynamicSQL				VarChar(8000)
Declare	@sdt_VETPStartDate			SmallDateTime
Declare	@sdt_VETPEndDate			SmallDateTime

-- Get Report Reporting Period Info
Select	@sdt_VETPStartDate			= VETradePeriod. StartDate,
	@sdt_VETPEndDate			= VETradePeriod. EndDate
From	VETradePeriod (NoLock)
Where	VETradePeriod. VETradePeriodID	= @i_TradePeriodFromID

If @vc_StatementGrouping = 'Updates'
Begin

	----------------------------------------------------------------------------------------------------------------------
	-- Add Snapshot Information
	----------------------------------------------------------------------------------------------------------------------
	Execute dbo.SRA_Risk_Reports_Snapshot_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@c_OnlyShowSQL			= @c_OnlyShowSQL

	------------------------------------------------------
	-- Update the period for BALMO time physical exposure
	----------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	VETradePeriodID	=	 VETradePeriod.VETradePeriodID
	From	' + @vc_TempTable + '	#RiskExposureResults	
		Inner Join RiskPhysicalExposure	(NoLock)	On	#RiskExposureResults.RiskExposureTableIdnty	 =	RiskPhysicalExposure.RiskPhysicalExposureID
		Inner Join Risk (NoLock)			on	RiskPhysicalExposure.RiskID		 =	Risk.RiskID
		Inner Join RiskDealIdentifier (NoLock)		on	Risk.RiskDealIdentifierID	    = RiskDealIdentifier.RiskDealIdentifierID
		Inner Join RiskDealDetail (NoLock)		on	RiskDealIdentifier.DlHdrID  =	RiskDealDetail.DlHdrID
								and	RiskDealIdentifier.DlDtlID  =	RiskDealDetail.DlDtlID
		Inner Join VETradePeriod (NoLock)		on	RiskDealDetail.DlDtlFrmDte	=   VETradePeriod.StartDate
								and	RiskDealDetail.DlDtlToDte	=   VETradePeriod.EndDate						
	where	#RiskExposureResults.IsQuotational = 0
	and	#RiskExposureResults.SourceTable = ''O''
	and	#RiskExposureResults.InstanceDateTime between RiskDealDetail.StartDate and RiskDealDetail.EndDate
	And	RiskDealDetail. SrceSystmID			= RiskDealIdentifier.ExternalType
	and	exists (
			select	1
			from	ProductInstrument (NoLock) 
			where	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			And	ProductInstrument. PrdctId		= RiskDealDetail.DlDtlPrdctID
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	------------------------------------------------------------------------------------------------------------------------------
	-- Update RiskCurve Id for Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskCurveID		= RiskCurve. RiskCurveID
		,PeriodStartDate	= RiskCurve. TradePeriodFromDate
		,PeriodEndDate		= RiskCurve. TradePeriodToDate
		,CrrncyID		= RiskCurve. CrrncyID
		,CurveProductID		= RiskCurve. PrdctID
		,CurveChemProductID	= RiskCurve. ChmclID
		,CurveLcleID		= RiskCurve. LcleID
		--,CurveLcle		= RiskCurve. LcleID
		,CurveServiceID		= RiskCurve. RPHdrID
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskCurve	On	RiskCurve. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
					And	RiskCurve. PrceTpeIdnty		= #RiskExposureResults. PrceTpeIdnty
					And	RiskCurve. VETradePeriodID	= #RiskExposureResults. VETradePeriodID
	Where	Exists	(
		Select	1 
		From	dbo.RawPriceLocaleCurrencyUOM	(NoLock)
		Where	RawPriceLocaleCurrencyUOM. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
		And	RawPriceLocaleCurrencyUOM. CrrncyID		= RiskCurve. CrrncyID
		And	IsNull(RawPriceLocaleCurrencyUOM. UOM, -1)	= IsNull(RiskCurve. UOMID, -1)
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete RiskCurves that have incorrect UOM/Currencies
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskCurve		(NoLock)	On	RiskCurve. RiskCurveID		= #RiskExposureResults. RiskCurveID
	Where	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	Not Exists	(
		Select	1 
		From	dbo.RawPriceLocaleCurrencyUOM	(NoLock)
		Where	RawPriceLocaleCurrencyUOM. RwPrceLcleID		= RiskCurve. RwPrceLcleID
		And	RawPriceLocaleCurrencyUOM. CrrncyID		= RiskCurve. CrrncyID
		And	IsNull(RawPriceLocaleCurrencyUOM. UOM, -1)	= IsNull(RiskCurve. UOMID, -1)
			)'
		
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Update RiskCurve Id for Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	VETradePeriodID		= Case When IsNull(#RiskExposureResults. VETradePeriodID, -1) <> 0 Then Coalesce(VETradePeriod. VETradePeriodID, VETP.VETradePeriodID) Else #RiskExposureResults. VETradePeriodID End
		,PeriodStartDate	= Risk. DeliveryPeriodStartDate
		,PeriodEndDate		= Risk. DeliveryPeriodEndDate
		,CrrncyID		= RawPriceLocaleCurrencyUOM. CrrncyID
		,CurveProductID		= RawPriceLocale. RPLcleChmclParPrdctID
		,CurveChemProductID	= RawPriceLocale. RPLcleChmclChdPrdctID
		,CurveLcleID		= RawPriceLocale. RPLcleLcleID
		,CurveServiceID		= RawPriceLocale. RPLcleRPHdrID
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.RawPriceLocale		(NoLock)	On	RawPriceLocale. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
		Inner Join dbo.RawPriceLocaleCurrencyUOM (NoLock)	On	RawPriceLocaleCurrencyUOM. RwPrceLcleID	= #RiskExposureResults. RwPrceLcleID
		Inner Join dbo.Risk			(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
		Left Outer Join dbo.VETradePeriod	(NoLock)	On	VETradePeriod. StartDate		= Risk. DeliveryPeriodStartDate
									And	VETradePeriod. EndDate			= Risk. DeliveryPeriodEndDate
		Left Outer Join dbo.VETradePeriod VETP	(NoLock)	On	Risk. DeliveryPeriodEndDate		Between VETradePeriod. StartDate And VETradePeriod. EndDate
									And	VETP.Type				= "M"
									And	VETradePeriod.VETradePeriodID		Is Null
	Where	#RiskExposureResults. RiskCurveID	Is Null'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Interim Billing records
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	Exists	(
			Select	''''
			From	DealDetailProvision
			Where	DealDetailProvision. DlDtlPrvsnID		= #RiskExposureResults. DlDtlPrvsnID
			And	DealDetailProvision. Actual	= ''I''
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Physical side of Spread Options since we're brining in the quotational
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults. SourceTable	= ''O''
	And	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ') 
	And	Exists	(
			Select	1 
			From	dbo.Risk	(NoLock)
				Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
				Inner Join dbo.RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= RiskDealIdentifier. DlHdrID
											And	RiskDealDetailProvision. DlDtlPrvsnDlDtlID	= RiskDealIdentifier. DlDtlID
											And	#RiskExposureResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
			Where	Risk. RiskID					= #RiskExposureResults. RiskID
			And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	= ' + dbo.GetConfigurationValue('ProvisionOTCSpread') + '
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Now Update Position 
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	OriginalPhysicalPosition	= RiskPosition.Position
		,Position			= Case	When #RiskExposureResults.IsQuotational	= Convert(Bit, 1)
							Then IsNull(RiskQuotationalExposure.TotalPercentage, 1.0) 
								* IsNull(FormulaEvaluationPercentage.TotalPercentage, 1.0) 
								* RiskPosition.Position
							Else #RiskExposureResults. TotalPercentage * RiskPosition.Position
						End
		,SpecificGravity		= Abs(RiskPosition.SpecificGravity)
		,Energy				= Abs(RiskPosition.Energy)
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskPosition (NoLock)	On	RiskPosition.RiskID		= #RiskExposureResults.RiskID
							And	#RiskExposureResults.InstanceDateTime	Between	RiskPosition.StartDate And RiskPosition.EndDate
							And	RiskPosition. Position		<> 0.0
		Left Outer Join RiskQuotationalExposure On	RiskQuotationalExposure.RiskQuotationalExposureID	= #RiskExposureResults.RiskExposureTableIdnty
							And	#RiskExposureResults.IsQuotational			= Convert(Bit, 1)
		Left Outer Join FormulaEvaluationPercentage	On FormulaEvaluationPercentage.FormulaEvaluationID		= #RiskExposureResults.FormulaEvaluationID
							And	#RiskExposureResults.EndOfDay	Between FormulaEvaluationPercentage.EndOfDayStartDate and FormulaEvaluationPercentage.EndOfDayEndDate
							And	FormulaEvaluationPercentage.VETradePeriodID			= #RiskExposureResults.VETradePeriodID

	'	

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Now Update Position for backward Pay/Receive
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Position			= #RiskExposureResults.Position  * Case RiskDealDetail.DlDtlSpplyDmnd + RiskDealDetailProvision.DlDtlPrvsnMntryDrctn
										When ''RD'' Then -1.0 When ''DR'' Then -1.0  Else 1.0 End
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			On	Risk.RiskID			= #RiskExposureResults.RiskID
		Inner Join RiskDealDetailProvision	On	RiskDealDetailProvision.DlDtlPrvsnID			= #RiskExposureResults.DlDtlPrvsnID
							And	#RiskExposureResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
		Inner Join dbo.RiskDealIdentifier	On	RiskDealIdentifier.RiskDealIdentifierID			= Risk. RiskDealIdentifierID
		Inner Join dbo.RiskDealDetail	On	RiskDealDetail.DealDetailID				= RiskDealIdentifier.DealDetailID
							And	#RiskExposureResults. InstanceDateTime Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
	Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)
	And	IsNull(RiskDealDetailProvision.TmplteSrceTpe , ''Z'') = ''DD''
	And	#RiskExposureResults.DlDtlTmplteId	Not In(' + dbo.GetDlDtlTmplteIds('Over the Counter Options All Types, Exchange Traded Options All Types, Swaps All Types, Futures All Types') + ')
	'	
	-- Add sign logic to multiply quotational times a negative for cases when customer sets provision to Receive for Purchase or Pay for Sales which is opposite of typical deal setup.
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Clearported OTC & Swap Deals - Can't do this in snapshot since they're needed for MtM (premium)
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On Risk. RiskID			= #RiskExposureResults. RiskID
	Where	#RiskExposureResults.DlDtlTmplteID 	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Swaps All Types') + ')
	And	Exists	(
		Select	1
		From	dbo.RiskDealIdentifier		(NoLock)
			Inner Join dbo.DealHeaderLink	(NoLock)	On	DealHeaderLink. DlHdrID			= RiskDealIdentifier. DlHdrID
									And	DealHeaderLink. LinkType		= ''C''
			Inner Join dbo.RiskDealDetail	(NoLock)	On	RiskDealDetail. DlHdrID			= DealHeaderLink. RelatedDlHdrID
									And	#RiskExposureResults. InstanceDateTime		Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID		= ' + convert(varchar, dbo.GetRASourceSystemID()) + ' -- T-19256
		Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
		And	RiskDealDetail. NegotiatedDate			<= DateAdd(Minute, -1, DateAdd(Day, 1, #RiskExposureResults. EndOfDay))
		And	RiskDealDetail. DlHdrStat			= ''A''
			)
	Option (Force Order, Loop Join)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	--Set	Position	= 0.0
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.RiskDealDetailProvisionRow	(NoLock)	On	RiskDealDetailProvisionRow.DlDtlPrvsnRwID	= #RiskExposureResults.DlDtlPrvsnRwID
								     		And	RiskDealDetailProvisionRow.StartDate		<= #RiskExposureResults.InstanceDateTime
	     									And	RiskDealDetailProvisionRow.EndDate		>= #RiskExposureResults.InstanceDateTime
	Where	#RiskExposureResults. IsQuotational						= Convert(Bit, 1)
	And	IsNull(RiskDealDetailProvisionRow.FormulaUseForRisk, Convert(Bit, 1)) 	<> Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- If Not Showing Daily Exposure, we need to get the priced in % for the quotational records since there's nothing triggering that calculation in the snapshot
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	If @c_ExposureType Not in( 'Y', 'P', 'H', 'D')
		Execute dbo.SRA_Risk_Reports_Exposure_UpdateHK_ExposurePercentage 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID--TODO:  This has to work on the comparison snapshot too
											,@vc_TempTableName	= @vc_TempTable --'#RiskExposureResults'
											,@c_OnlyShowSQL		= @c_OnlyShowSQL
End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Update for Client External Columns
------------------------------------------------------------------------------------------------------------------------------
--If @vc_AdditionalColumns Like '%v_Risk_Reports_Exposure_Client_ExternalColumns%' And Object_ID('sp_Risk_Report_PriceRisk_Pre_Load_ClientColumns') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_Pre_Load_ClientColumns	
--                                                                 @c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@b_DiscountPositions		= @b_DiscountPositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@c_ExposureType		= @c_ExposureType
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--                                                                ,@c_Beg_Inv_SourceTable		= @c_Beg_Inv_SourceTable
--                                                                ,@i_P_EODSnpShtLgID             = @i_P_EODSnpShtLgID
--End
	
If @vc_StatementGrouping = 'DecompositionAndUpdates'
Begin
	--------------------------------------------------------------------------------------------------------------------------------
	---- Call Procedure to Decompose
	--------------------------------------------------------------------------------------------------------------------------------
			 
	Exec dbo.sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
							,@c_ShowDailyExposure		= @c_ExposureType
							,@c_InventoryType		= @vc_InventoryTypeCode
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@vc_TempTableName		= @vc_TempTable -- '#RiskExposureResults'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL
							,@b_ShowRiskDecomposed		= @b_ShowRiskDecomposed

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Snapshot Information
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Snapshot			= Snapshot.P_EODSnpShtID
		,SnapshotAccountingPeriod 	= AcctPeriod. StartDate
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join Snapshot (NoLock)			On	Snapshot. InstanceDateTime 		= #RiskExposureResults.InstanceDateTime
		Inner Join VETradePeriod AcctPeriod (NoLock)	On	Snapshot. StartedFromVETradePeriodID	= AcctPeriod. VETradePeriodID
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Snapshot Information 2 (Split query to perform better)
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	SnapshotTradePeriod		= TradePeriod. StartDate
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join VETradePeriod TradePeriod (NoLock)	On	#RiskExposureResults.EndOfDay			Between TradePeriod. StartDate and TradePeriod. EndDate
								And	TradePeriod.Type			= ''M'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete for Criteria - IsBasisCurve
	------------------------------------------------------------------------------------------------------------------------------
	If @c_ShowRiskType In( 'F', 'B' )
	Begin
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	#RiskExposureResults. IsBasisCurve = ' + Case When @c_ShowRiskType = 'F' -- Flat Risk
								Then 'Convert(Bit, 1)'
								When @c_ShowRiskType = 'B' -- Basis Risk
								Then 'Convert(Bit, 0)'
							End
							
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)				
	End

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Period for Ending Inventory Report
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	PeriodStartDate		= "'+ Convert(VarChar, @sdt_VETPStartDate) +'"
		,PeriodEndDate		= "'+ Convert(VarChar, @sdt_VETPEndDate) +'"
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk		On Risk. RiskID			= #RiskExposureResults. RiskID
	Where	Risk. SourceTable	= ''' + @c_Beg_Inv_SourceTable + ''''

	If @vc_InventoryTypeCode = 'E'
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
	------------------------------------------------------------------------------------------------------------------------------
	-- Update ExposureStartDate for Pricing Events w/ Historical Exposure
	------------------------------------------------------------------------------------------------------------------------------
	if @c_ExposureType = 'H'
	Begin
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	ExposureStartDate			= Case 	When 	"' + Convert(VarChar, @sdt_VETPStartDate) + '" > RiskDealDetail. NegotiatedDate
								Then 	"' + Convert(VarChar, @sdt_VETPStartDate) + '"	-- Report Starting Period
								Else	RiskDealDetail. NegotiatedDate
							End
		From	' + @vc_TempTable + '	#RiskExposureResults
			Inner Join Risk			(NoLock)	On	#RiskExposureResults. RiskID				= Risk. RiskID
			Left Outer Join RiskDealIdentifier (NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
			Left Outer Join RiskDealDetail	(NoLock)	On	RiskDealDetail. DlHdrID				= RiskDealIdentifier. DlHdrID
									And	RiskDealDetail. DlDtlID				= RiskDealIdentifier. DlDtlID
									And	#RiskExposureResults.InstanceDateTime			Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID			= RiskDealIdentifier. ExternalType -- T-19256
		Where	#RiskExposureResults. IsDailyPricingRow = 0'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	----------------------------------------------------------------------------------------------------------------------
	-- RiskCurve should get everything, but we'll look on provion & BA as last resort
	----------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	CrrncyID 	= Coalesce(RiskDealDetailProvision.CrrncyID, BusinessAssociateCurrency.BACrrncyCrrncyID,' + dbo.GetConfigurationValue('DefaultCurrency') + ')
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On 	Risk. RiskID	= #RiskExposureResults. RiskID
		Left Outer Join RiskDealDetailProvision (NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskExposureResults.DlDtlPrvsnID
									And	#RiskExposureResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Left Outer Join dbo.BusinessAssociateCurrency 	(NoLock)	On	BusinessAssociateCurrency.BACrrncyBAID		= Risk.InternalBAID
										And	BusinessAssociateCurrency.BACrrncyDflt		= ''Y''
	Where	#RiskExposureResults.CrrncyID	Is Null
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update Quotational Position for Sign
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if @vc_TempTable = '#RiskExposureResults' -- .NET
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	Position		=	----------------------------------------------------------------------------------------------------------------------
							-- When we are showing Pricing Events, we need to reverse the sign of the daily quotes
							----------------------------------------------------------------------------------------------------------------------
							Case 	When	IsDailyPricingRow = 1
								And	"' + @c_ExposureType + '" <> "Y"
								Then	-1.0 
								Else 	1.0
							End * /*IsNull(#RiskExposureResults. Percentage, 1.0) * BMM*/

							----------------------------------------------------------------------------------------------------------------------
							-- For Daily Rows, the quote percentage handles it.  For non-daily, we want to show the whole percentage when
							--   showing historical rows, but only the floating percentage for all others
							----------------------------------------------------------------------------------------------------------------------
							/* BMM Doesnt need to run since position is already determined
							Case	When	(("' + @c_ExposureType + '" In( "Y", "D")
								Or	#RiskExposureResults. IsDailyPricingRow	= 1)'
									+ Case when len(dbo.GetConfigurationValue('ProvisionTriggerAndFormula')) = 0 then '' else '
								And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	not in (' + dbo.GetConfigurationValue('ProvisionTriggerAndFormula') + ')' end + '
									)
								Then	1.0
								When	"' + @c_ExposureType + '" = "H"
								And	#RiskExposureResults. IsDailyPricingRow	= 0
								Then	#RiskExposureResults. TotalPercentage
								Else	#RiskExposureResults. TotalPercentage - #RiskExposureResults. Percentage
				      			End * 
							*/
							----------------------------------------------------------------------------------------------------------------------
							-- For physical risk that is represented as quotational risk, we just need to apply a -1.0, for others
							--   we need to look at the We Pay/They Pay flag in combination with the sign of the position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID		Is Null -- Clearport
								And	#RiskExposureResults. IsDailyPricingRow			= 0
								And	RiskPriceIdentifier.RiskPriceIdentifierID	Is Null -- Clearport
								Then	1.0
								When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								And	#RiskExposureResults. IsDailyPricingRow		= 0
								And	"' + @c_ExposureType + '" 		<> "Y"
								Then	-1.0
 								When	IsNull(RiskPriceIdentifier.TmplteSrceTpe, "ED")	= "ED"
								And	#RiskExposureResults.DlDtlPrvsnRwID		Is Null
 								Then	1.0
								When	#RiskExposureResults.DlDtlTmplteID				In (' + dbo.GetDlDtlTmplteIDs('Swaps All Types') + ')
								And	IsNull(RiskDealDetailProvision.CostType, ''P'')		= ''P''
								And	(
										(
										RiskPosition. ValuationPosition 		< 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "R")
									Or 	(
										RiskPosition.ValuationPosition 			> 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "D"
										)
									)
								Then	1.0
								--Options really represent a physical exposure, so leave sign alone
								When	#RiskExposureResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
								Then	1.0
								Else	-1.0
							End 
							* #RiskExposureResults. Position
							/** BMM
							----------------------------------------------------------------------------------------------------------------------
							-- If the source of the volume is physical, we need to use the net position, otherwise the valuation position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								Then	RiskPosition.Position
								Else	RiskPosition.ValuationPosition
							End */,
			SpecificGravity		= Abs(RiskPosition.SpecificGravity)
			,Energy			= Abs(RiskPosition.Energy)
		From	#RiskExposureResults
			Left Outer Join Risk			(NoLock)	On 	#RiskExposureResults. RiskID 			= Risk. RiskID
			Left Outer Join  RiskPriceIdentifier	(NoLock)	On 	Risk. RiskPriceIdentifierId 		= RiskPriceIdentifier. RiskPriceIdentifierID
			Inner Join RiskPosition			(NoLock)	On	RiskPosition.RiskID			= #RiskExposureResults.RiskID
										And	#RiskExposureResults.InstanceDateTime		Between	RiskPosition.StartDate And RiskPosition.EndDate
			Left Outer Join RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskExposureResults. DlDtlPrvsnID
										And	#RiskExposureResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)'
	Else	-- PB Report or VC
		select @vc_DynamicSQL = '
		Update	#RiskResults
		Set	Position		=	----------------------------------------------------------------------------------------------------------------------
							-- When we are showing Pricing Events, we need to reverse the sign of the daily quotes
							----------------------------------------------------------------------------------------------------------------------
							Case 	When	IsDailyPricingRow = 1
								And	"' + @c_ExposureType + '" <> "Y"
								Then	-1.0 
								Else 	1.0
							End * /*IsNull(#RiskResults. Percentage, 1.0) * BMM*/

							----------------------------------------------------------------------------------------------------------------------
							-- For Daily Rows, the quote percentage handles it.  For non-daily, we want to show the whole percentage when
							--   showing historical rows, but only the floating percentage for all others
							----------------------------------------------------------------------------------------------------------------------
							/* BMM Doesnt need to run since position is already determined
							Case	When	(("' + @c_ExposureType + '" = "Y"
								Or	#RiskResults. IsDailyPricingRow	= 1)'
									+ Case when len(dbo.GetConfigurationValue('ProvisionTriggerAndFormula')) = 0 then '' else '
								And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	not in (' + dbo.GetConfigurationValue('ProvisionTriggerAndFormula') + ')' end + '
									)
								Then	1.0
								When	"' + @c_ExposureType + '" = "H"
								And	#RiskResults. IsDailyPricingRow	= 0
								Then	#RiskResults. TotalPercentage
								Else	#RiskResults. TotalPercentage - #RiskResults. Percentage
				      			End * 
							*/
							----------------------------------------------------------------------------------------------------------------------
							-- For physical risk that is represented as quotational risk, we just need to apply a -1.0, for others
							--   we need to look at the We Pay/They Pay flag in combination with the sign of the position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID		Is Null -- Clearport
								And	#RiskResults. IsDailyPricingRow			= 0
								And	RiskPriceIdentifier.RiskPriceIdentifierID	Is Null -- Clearport
								Then	1.0
								When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								And	#RiskResults. IsDailyPricingRow		= 0
								And	"' + @c_ExposureType + '" 		<> "Y"
								Then	-1.0
 								When	IsNull(RiskPriceIdentifier.TmplteSrceTpe, "ED")	= "ED"
								And	#RiskResults.DlDtlPrvsnRwID		Is Null
 								Then	1.0
								When	#RiskResults.DlDtlTmplteID				In (' + dbo.GetDlDtlTmplteIDs('Swaps All Types') + ')
								And	IsNull(RiskDealDetailProvision.CostType, ''P'')		= ''P''
								And	(
										(
										RiskPosition. ValuationPosition 		< 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "R")
									Or 	(
										RiskPosition.ValuationPosition 			> 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "D"
										)
									)
								Then	1.0
								--Options really represent a physical exposure, so leave sign alone
								When	#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
								Then	1.0
								Else	-1.0
							End 
							* #RiskResults. Position
							/** BMM
							----------------------------------------------------------------------------------------------------------------------
							-- If the source of the volume is physical, we need to use the net position, otherwise the valuation position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								Then	RiskPosition.Position
								Else	RiskPosition.ValuationPosition
							End */,
			SpecificGravity		= Abs(RiskPosition.SpecificGravity)
			,Energy			= Abs(RiskPosition.Energy)
		From	#RiskResults
			Left Outer Join Risk			(NoLock)	On 	#RiskResults. RiskID 			= Risk. RiskID
			Left Outer Join  RiskPriceIdentifier	(NoLock)	On 	Risk. RiskPriceIdentifierId 		= RiskPriceIdentifier. RiskPriceIdentifierID
			Inner Join RiskPosition			(NoLock)	On	RiskPosition.RiskID			= #RiskResults.RiskID
										And	#RiskResults.InstanceDateTime		Between	RiskPosition.StartDate And RiskPosition.EndDate
			Left Outer Join RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskResults. DlDtlPrvsnID
										And	#RiskResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Where	#RiskResults.IsQuotational	= Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	-- Update for daily physical pricing rows (Monthly Average Futures)
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Position	= -1.0 * Position
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults.IsDailyPricingRow	= Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-----------------------------------------------------------------------------------------------------------------------------
	-- Delete 0 Position Records from #RiskExposureResults if no formula evaluation quotes exist
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults.Position		= 0.0
	And	IsNull(#RiskExposureResults. Argument, "")	not like  "%,IsCashSettleFuture,%"
	And	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)
	And	Not Exists	(
				Select	''''
				From	FormulaEvaluationQuote (NoLock)
				Where	FormulaEvaluationQuote.FormulaEvaluationID	= #RiskExposureResults.FormulaEvaluationID
				And	FormulaEvaluationQuote.VETradePeriodID		= #RiskExposureResults.VETradePeriodID
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete 0 Position Records from #RiskExposureResults for zero valuationposition
	------------------------------------------------------------------------------------------------------------------------------
	If @b_ShowZeroQuotational = 0 or @b_IsReport = 0 or @vc_TempTable = '#RiskExposureResults'
	Begin
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	#RiskExposureResults.Position		= 0.0
		And	#RiskExposureResults.IsQuotational 	= Convert(Bit, 1)
		And	Not Exists	(
					Select	''''
					From	RiskPosition (NoLock)
					Where	RiskPosition. RiskID		= #RiskExposureResults.RiskID
		     			And	#RiskExposureResults.InstanceDateTime	Between RiskPosition. StartDate	And RiskPosition. EndDate
					And	RiskPosition. ValuationPosition	<> 0.0
					)'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		-- Delete for zero position records
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	Convert(Decimal(38, 6), #RiskExposureResults.Position)		=  0.0'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
	
	----------------------------------------------------------------------------------------------------------------------
	-- If we're discounting, then get the discount factor and discount the reference columns
	----------------------------------------------------------------------------------------------------------------------
	If @b_DiscountPositions = 1 Or @b_ShowCurrencyExposure = 1
		Execute SRA_Risk_Reports_DiscountFactor 	@c_RetrieveAtSourceLevel	= 'N'
								,@vc_entity			= 'Exposure'
								,@vc_TempTableName		= @vc_TempTable --'#RiskExposureResults'
								,@c_OnlyShowSQL			= @c_OnlyShowSQL

					
	------------------------------------------------------------------------------------------------------------------------------
	-- Insert Option External Column Information
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskDealDetailOptionOTCID 	= RiskDealDetailOptionOTC. RiskDealDetailOptionOTCID		-- Needed for SRA_Risk_Reports_Option_Columns
	-- Select *
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On	Risk. RiskID					= #RiskExposureResults. RiskID
		Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
		Inner Join dbo.RiskDealDetailOption	(NoLock)	On 	RiskDealDetailOption. DlHdrID			= RiskDealIdentifier. DlHdrID
									And	RiskDealDetailOption. DlDtlID			= RiskDealIdentifier. DlDtlID
									And	#RiskExposureResults.InstanceDateTime Between RiskDealDetailOption. StartDate and RiskDealDetailOption. EndDate
		Inner Join dbo.RiskCurve		(NoLock)	On	RiskCurve. RiskCurveID				= #RiskExposureResults. RiskCurveId
		Inner Join dbo.RiskDealDetailOptionOTC	(NoLock)	On	RiskDealDetailOptionOTC. RiskDealDetailOptionID	= RiskDealDetailOption. RiskDealDetailOptionID
									And	#RiskExposureResults.InstanceDateTime Between RiskDealDetailOptionOTC. StartDate and RiskDealDetailOptionOTC. EndDate
									And	RiskDealDetailOptionOTC. RwPrceLcleID		= RiskCurve. RwPrceLcleID
									And	RiskDealDetailOptionOTC. PrceTpeIdnty		= RiskCurve. PrceTpeIdnty
	Where 	#RiskExposureResults. DlDtlTmplteID in(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ')'

	If @c_onlyshowsql <> 'Y' Execute (@vc_DynamicSQL) Else Select @vc_DynamicSQL

	Declare @vc_OptionsTempTable Varchar(200)
	Select	@vc_OptionsTempTable = Case When @vc_TempTable = '#RiskExposureResults' Then '#RiskExposureResultsOptions' Else '#RiskResultsOptions' End

	Execute SRA_Risk_Reports_Option_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@vc_Entity 			= 'Exposure'
							,@vc_TempTableName		= @vc_OptionsTempTable	-- '#RiskExposureResultsOptions'
							,@vc_RiskResultsTempTableName	= @vc_TempTable		-- '#RiskExposureResults'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL


	-----------------------------------------------------------------------------------------------------------------------------
	-- We have to reduce the quantity of the "O" records since they could have partially exercised
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	 = Sign(Position) * (Abs(Position) - Abs(#RiskResultsOptions.ExercisedQuantity))
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + ' #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	#RiskResultsOptions.ExercisedQuantity	Is Not Null
	And	#RiskResultsOptions.ExercisedQuantity	<> 0.0'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete ones that are fully exercised
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskResults
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '  #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	#RiskResultsOptions.ExercisedQuantity	Is Not Null
	And	#RiskResultsOptions.ExercisedQuantity	<> 0.0
	And	#RiskResults.Position			= 0.0'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete knocked out options
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskResults
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '  #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	IsNull(#RiskResultsOptions.KnockOutStatus, ''N'') = ''Y'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Because postings and spot price formulas go from a real period to zero as they price in, we need to add the percentages
	--   to the earliest remaining period.  This will make the report look as if the spot prices are priced in as the earliest period.
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	PricedInPercentage	= #RiskResults.PricedInPercentage + (FormulaEvaluationPercentage.PricedInPercentage * RiskDealDetailProvisionRow.FormulaPercent/100.0),
		TotalPercentage		= #RiskResults.TotalPercentage + (FormulaEvaluationPercentage.TotalPercentage * RiskDealDetailProvisionRow.FormulaPercent/100.0)
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join dbo.FormulaEvaluationPercentage (NoLock)
					On	FormulaEvaluationPercentage.FormulaEvaluationID	= #RiskResults.FormulaEvaluationID
					And	#RiskResults.EndOfDay				Between FormulaEvaluationPercentage.EndOfDayStartDate And FormulaEvaluationPercentage.EndOfDayEndDate
					--We are only interested in 100% priced in posting/spot exposure
					And	FormulaEvaluationPercentage.VETradePeriodID	= 0
					And	FormulaEvaluationPercentage.PricedInPercentage	= FormulaEvaluationPercentage.TotalPercentage
		Inner Join dbo.RiskDealDetailProvisionRow (NoLock)
			On RiskDealDetailProvisionRow.DlDtlPrvsnRwID = #RiskResults.DlDtlPrvsnRwID
			And #RiskResults.InstanceDateTime between RiskDealDetailProvisionRow.StartDate and RiskDealDetailProvisionRow.EndDate
	Where	#RiskResults.VETradePeriodID	<> 0
	--This will guarantee that the earliest quoting period is the one that accumulates the spot/posting percentage
	And	(
		Select	Top 1 FEP.VETradePeriodID
		From	dbo.FormulaEvaluationPercentage FEP (NoLock)
		Where	FEP.FormulaEvaluationID	= #RiskResults.FormulaEvaluationID
		And	#RiskResults.EndOfDay	Between FEP.EndOfDayStartDate And FEP.EndOfDayEndDate
		And	FEP.VETradePeriodID	<> 0
		Order By FEP.QuoteRangeBeginDate, FEP.FormulaEvaluationPercentageID
		) = #RiskResults.VETradePeriodID'
		
	If @b_IsReport = 1 And @c_ExposureType = 'N'
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--BLD - I'm removing position calculation using Put/Call and Buy/Sell because the following logic is the correct way to determine the sign:
			--Buy/Sell is embedded in RiskPosition.Position
			--Put/Call is embedded in the delta position, puts are always negative
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*
	Signage for Delta (only dependent on Put/Call):
	Put - Negative Delta
	Call - Positive Delta

	Position Signage:
	Buy Call - Positive position
	Buy Put - Negative position
	Sell Call - Negative position
	Sell Put - Positive position
	*/
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Apply Delta for ETO Options
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	= #RiskResultsOptions.Delta * ABS(#RiskResultsOptions.Weight)
				* Abs(#RiskResults.Position) * Case When RiskDealDetail. DlDtlSpplyDmnd = ''R'' Then 1.0 Else -1.0 End
				-- For Monthly Average Asian options, we need to not apply the delta to percentage
		,PricedInPercentage	= Case	When	''' + @c_ExposureType + '''	<> ''N'' -- Show Daily Exposure
						--And	Risk.DlDtlTmplteID			in(  ' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types') + ') 
						And	#RiskResultsOptions. Flavor		= ''Asian''
						Then	PricedInPercentage
						When	IsNull(RiskDealDetailProvision.DlDtlPrvsnPrvsnID, 0) = ' + dbo.GetConfigurationValue('ProvisionOTCSpread') + ' -- Spread
						Then	#RiskResultsOptions.Delta
						Else	Abs(#RiskResultsOptions.Delta)	-- Else Show Priced % as Delta
							-- Delta for non spreads should be negative for puts and positive for calls.  We cant rely on the sign that currently exists since it can be different depending on the option model used.
							* Case		When #RiskResultsOptions.PutCall = ''Put'' 
									Then -1.0 Else 1.0 End 
					End
		,TotalPercentage	= Case	When	''' + @c_ExposureType + '''	<> ''N'' -- Show Daily Exposure
						And	Risk.DlDtlTmplteID			in(  ' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types') + ') 
						And	#RiskResultsOptions. Flavor		= ''Asian''
						Then	TotalPercentage
						Else	1.0	-- Otherwise we end up applying negatives or partial percentages screwing up the delta
					End
	From	' + @vc_TempTable + '	  #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '   #RiskResultsOptions		On	#RiskResultsOptions. RiskID			= #RiskResults.RiskID
											And	#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
		Inner Join RiskDealDetail	(NoLock) On	RiskDealDetail. DlHdrID			= #RiskResultsOptions. DlHdrID
							And	RiskDealDetail. DlDtlID			= #RiskResultsOptions. DlDtlID
							And	#RiskResults.InstanceDateTime	Between RiskDealDetail. StartDate	And RiskDealDetail. EndDate
		Inner Join dbo.Risk	(NoLock)					On	Risk. RiskID					= #RiskResults.RiskID
		Left Outer Join dbo.DealDetailProvisionRow (NoLock)
								On	DealDetailProvisionRow.DlDtlPrvsnRwID	= IsNull(#RiskResults.DlDtlPrvsnRwID, #RiskResultsOptions.DlDtlPrvsnRwID)
		Left Outer Join dbo.RiskDealDetailProvision (NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID		= DealDetailProvisionRow.DlDtlPrvsnID
								And	#RiskResults. InstanceDateTime			Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Left Outer Join dbo.RiskOption (NoLock)		On	RiskOption.RiskID				= #RiskResults.RiskID
								And	#RiskResults. InstanceDateTime			Between RiskOption.StartDate And RiskOption.EndDate
	'
	
	If @b_IsReport = 1
	Begin
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	-----------------------------------------------------------------------------------------------------------------------------
	-- Additional Adjustment For Asian Options
	-- NonDaily Calculation = Total Quantity * [(Individual Unpriced Quantity) / (Individual Unpriced Total Quantity)]
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	select		(
				select	Sum( RERSub.Position)
				From	' + @vc_TempTable + ' RERSub
				Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
				And		RERSub.IsQuotational 	= 1
				) *
				(1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else #RiskResults. PricedInPercentage / #RiskResults. TotalPercentage End)
				/
				(
				select	Sum((1.0 - Case When RERSub. TotalPercentage = 0.0 Then 1.0 Else RERSub. PricedInPercentage / RERSub. TotalPercentage End))
				From	' + @vc_TempTable + '  RERSub
				Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
				And		RERSub.IsQuotational 	= 1
				)	Position,		
				#RiskResults.Idnty	
	Into	#RiskExposureResultsAsian											
	From	' + @vc_TempTable + ' #RiskResults
	Where	Exists (
					select	1
					From '	 + @vc_OptionsTempTable + ' #RiskResultsOptions
					Where	#RiskResultsOptions. RiskID					= #RiskResults.RiskID
					And		#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
					And		#RiskResultsOptions. Flavor	= ''Asian''
					)
	And		#RiskResults.IsQuotational 	= 1
	And		#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Exchange Traded Options All Types') + ') -- All Options
	And		(
			select	Sum((1.0 - Case When RERSub. TotalPercentage = 0.0 Then 1.0 Else RERSub. PricedInPercentage / RERSub. TotalPercentage End))
			From	' + @vc_TempTable + ' RERSub
			Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
			And		RERSub.IsQuotational 	= 1
			) <> 0
	And		''' + @c_ExposureType + '''	= ''N''

	Update	#RiskResults
	Set		Position = #RiskExposureResultsAsian.Position
	From	' + @vc_TempTable + ' #RiskResults
			Inner Join #RiskExposureResultsAsian on #RiskExposureResultsAsian.Idnty = #RiskResults.Idnty
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-------------------------------------------------------------------------------------------------------------------------------------------------
	-- Additional Adjustment For Asian Options
	-- Daily Calculation = Adjust to get individual weight by multiplying by 1/Percentage to get Original Position and then / number of unpriced quotes
	--------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set		Position = #RiskResults.Position * ((1/#RiskResults.Percentage) /
						(
						select count(1) 
						from ' + @vc_TempTable + '  #RiskResultsSub 
						Where  #RiskResultsSub.RiskExposureTableIdnty = #RiskResults.RiskExposureTableIdnty
						And		#RiskResultsSub.IsQuotational 	= 1
						))
	From	' + @vc_TempTable + ' #RiskResults
	Where	Exists (
					select	1
					From '	 + @vc_OptionsTempTable + ' #RiskResultsOptions
					Where	#RiskResultsOptions. RiskID					= #RiskResults.RiskID
					And		#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
					And		#RiskResultsOptions. Flavor	= ''Asian''
					)
	And		#RiskResults.IsQuotational 	= 1
	And		#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Exchange Traded Options All Types') + ') -- All Options
	And		#RiskResults.Percentage <> 0
	And		'''  + @c_ExposureType + '''	<> ''N'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	-----------------------------------------------------------------------------------------------------------------------------
	-- Delete Expired/Exercised Options
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete #RiskExposureResults
	-- Select *
	From	' + @vc_TempTable + '	  #RiskExposureResults
	Where	Exists	(
			Select 1
			From	' + @vc_OptionsTempTable + '   #RiskExposureResultsOptions
			Where	#RiskExposureResultsOptions. RiskId		= #RiskExposureResults. RiskId
			And	DATEADD(dd, 0, DATEDIFF(dd, 0, #RiskExposureResultsOptions. ExpirationDate)) <= #RiskExposureResults.EndOfDay
			And	#RiskExposureResultsOptions. ExpirationDate	Is Not Null
			)

	Delete #RiskExposureResults
	-- Select *
	From	' + @vc_TempTable + '	  #RiskExposureResults
	Where	Exists	(
			Select 1
			From	' + @vc_OptionsTempTable + '   #RiskExposureResultsOptions
			Where	#RiskExposureResultsOptions. RiskId		= #RiskExposureResults. RiskId
			And	DATEADD(dd, 0, DATEDIFF(dd, 0, #RiskExposureResultsOptions. ExercisedDate)) <= #RiskExposureResults.EndOfDay
			And	#RiskExposureResultsOptions. ExercisedDate	Is Not Null
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Quotational for Cash Settled Futures.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= ''M''
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join Risk (NoLock)    on	Risk. RiskID	= #RiskExposureResults. RiskID
	Where	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults. DlDtlTmplteId	In(' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
	And	Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= Risk. PrdctID-- Coalesce( #RiskExposureResults. CurveProductID, Risk. PrdctID) --Risk. PrdctID
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Quotational for Cash Settled Options.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= Case When ProductInstrument. DefaultSettlementType = ''C'' Then ''M'' Else ''P'' End
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.Risk		(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
		Inner Join dbo.ExchangeOption	 (NoLock)	On	Risk. PrdctID				= ExchangeOption.PrdctID
		Inner Join dbo.ProductInstrument (NoLock)	On	ExchangeOption.ProductDerivativeID	= ProductInstrument.ProductDerivativeID
	Where	#RiskExposureResults. DlDtlTmplteId		In(' + dbo.GetDlDtlTmplteIds('Exchange Traded Options All Types') + ')	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Physical for Physically Settled OTCs.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= Case	When	Exists	(	-- Not Cash Settled
								Select	1
								From	RiskDealIdentifier (NoLock)
									Inner Join dbo.RiskDealDetailOption (NoLock)		On	RiskDealDetailOption. DlHdrID			= RiskDealIdentifier. DlHdrID
																And	RiskDealDetailOption. DlDtlID			= RiskDealIdentifier. DlDtlID
																And	#RiskExposureResults. InstanceDateTime 			Between RiskDealDetailOption. StartDate and RiskDealDetailOption. EndDate
									Inner Join dbo.RiskDealDetailOptionOTCStrip (NoLock)	On	RiskDealDetailOptionOTCStrip. RiskDealDetailOptionID = RiskDealDetailOption. RiskDealDetailOptionID
																And	#RiskExposureResults. InstanceDateTime 			Between RiskDealDetailOptionOTCStrip. StartDate and RiskDealDetailOptionOTCStrip. EndDate
								Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
								And	RiskDealDetailOptionOTCStrip. SettlementType	<> ''C''
								)
						And	Not Exists (
								Select	1
								From	RiskDealIdentifier (NoLock)
									Inner Join dbo.DealDetail	with (NoLock)	On DealDetail.DealDetailID	= RiskDealIdentifier.DealDetailID
								Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
								And	Exists (
										Select	1 
										From	dbo.EntityTemplate	with (NoLock)
										where	EntityTemplate.EntityTemplateID	= DealDetail.EntityTemplateID
										And	EntityTemplate.TemplateName like ''swaption%''
										)
								)
						Then	''P''
						Else	''Q''
					End
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.Risk		(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
	Where	#RiskExposureResults. DlDtlTmplteId		In(' + dbo.GetDlDtlTmplteIds('Over the Counter Options All Types') + ')'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------
	--Show underlying (curve) prod/loc for OTC Options
	------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update #RiskExposureResults
	Set	PrdctID = RawPriceLocale.RPLcleChmclParPrdctID,
		ChmclID = RawPriceLocale.RPLcleChmclChdPrdctID,
		LcleID	= RawPriceLocale.RPLcleLcleID
	From ' + @vc_TempTable + ' #RiskExposureResults
		Inner Join dbo.RawPriceLocale ON (#RiskExposureResults.RwPrceLcleID = RawPriceLocale.RwPrceLcleID)
	Where #RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ') 
	And #RiskExposureResults.CurveLevel = 0 
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	Select @vc_DynamicSQL = '
	Update #RiskExposureResults
	Set	PrdctID = RawPriceLocale.RPLcleChmclParPrdctID,
		ChmclID = RawPriceLocale.RPLcleChmclChdPrdctID,
		LcleID	= RawPriceLocale.RPLcleLcleID
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.RiskOption (NoLock)	On (#RiskExposureResults.RiskID = RiskOption.RiskID)
							And #RiskExposureResults.InstanceDateTime between RiskOption.StartDate and RiskOption.EndDate
		Inner Join dbo.RawPriceLocale (NoLock)	On (RiskOption.UnderlyingRwPrceLcleID = RawPriceLocale.RwPrceLcleID)
	Where #RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ') 
	And #RiskExposureResults.CurveLevel <> 0
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	----------------------------------------------------------------------------------------------------------------------------------------------------
	--  Lease Center Exposure 
	----------------------------------------------------------------------------------------------------------------------------------------------------
	Execute dbo.SRA_Risk_Report_LeaseCenter_Exposure	@vc_TempTableName	= @vc_TempTable	--'#RiskExposureResults'
								,@c_onlyshowsql		= @c_onlyshowsql

	------------------------------------------------------------------------------------------------------------------------------
	-- Insert Hedging External Column Information
	------------------------------------------------------------------------------------------------------------------------------
	Declare @vc_HedingTempTable Varchar(200)
	Select	@vc_HedingTempTable = Case When @vc_TempTable = '#RiskExposureResults' Then '#RiskExposureResultsHedge' Else '#RiskResultsHedging' End
	
	Execute dbo.SRA_Risk_Reports_Hedging_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
	--						,@vc_report			= 'PLShift'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL
							,@vc_ResultsTempTableName	= @vc_TempTable	-- '#RiskExposureResults'
							,@vc_HedgingTempTableName	= @vc_HedingTempTable --'#RiskExposureResultsHedge'

	------------------------------------------------------------------------------------------------------------------------------
	---- Update for Misc External Columns
	--------------------------------------------------------------------------------------------------------------------------------
	--If @vc_AdditionalColumns Like '%CurveRiskType%'
	--Begin
	--	select @vc_DynamicSQL = '
	--	Update	#RiskExposureResults
	--	Set	CurveRiskType = RiskDealDetailProvisionDisaggregate.RiskType
	--	From	#RiskExposureResults
	--		Inner Join Risk (NoLock)		On	#RiskExposureResults.RiskID				= Risk.RiskID
	--		Inner Join RiskPriceIdentifier (NoLock)	On	RiskPriceIdentifier.RiskPriceIdentifierID		= Risk.RiskPriceIdentifierID
	--							And	RiskPriceIdentifier.TmplteSrceTpe			= "ED"
	--		Inner Join RiskDealDetailProvisionDisaggregate (NoLock)
	--							On	RiskDealDetailProvisionDisaggregate.DisaggregateDlDtlPrvsnID	= RiskPriceIdentifier.DlDtlPrvsnID
	--							And	IsNull(RiskDealDetailProvisionDisaggregate.RiskType, "")	<> ""
	--							And	#RiskExposureResults.InstanceDateTime				Between RiskDealDetailProvisionDisaggregate.StartDate And RiskDealDetailProvisionDisaggregate.EndDate'
		
	--	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	--End

	If @vc_AdditionalColumns Like '%AttachedInHouse%'
	Begin
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	AttachedInHouse = "Y"
		From	' + @vc_TempTable + '	#RiskExposureResults
			Inner Join Risk (NoLock)		On	#RiskExposureResults.RiskID				= Risk.RiskID
			Inner Join RiskPriceIdentifier (NoLock)	On	RiskPriceIdentifier.RiskPriceIdentifierID		= Risk.RiskPriceIdentifierID
								And	RiskPriceIdentifier.TmplteSrceTpe			Not Like "D%"'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
	
	If	(
		IsNull(@vc_AdditionalColumns,'') Like '%RelatedDealNumber%'
	Or	IsNull(@vc_AdditionalColumns,'') Like '%MoveExternalDealID%'
		)
	Begin
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	RelatedDealNumber	= Case	When Risk. SourceTable In(''EIX'', ''EIP'') 
						Then RiskDealDetail. DlHdrIntrnlNbr
						Else RiskDealIdentifier. Description
					End	
		,MoveExternalDealID	= IsNull(RiskDealDetail. DlDtlID, RiskDealIdentifier. DlDtlID)
	From	' + @vc_TempTable + '		#RiskResults
		Inner Join dbo.Risk			(NoLock)	On	Risk.RiskID				= #RiskResults. RiskID
		Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID = Risk. RiskDealIdentifierID
		Left Outer Join dbo.RiskDealDetail		(NoLock)	
									On	RiskDealDetail. SourceID		= RiskDealIdentifier.ExternalID
									And	#RiskResults.InstanceDateTime		Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID		= RiskDealIdentifier. ExternalType
	Where	RiskDealIdentifier. ExternalType	<> ' + Convert(Varchar, dbo.GetRASourceSystemID()) + ' -- RA
	And	Risk. SourceTable			In(''EX'', ''EP'', ''EIX'', ''EIP'')
	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End
End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Execute the Client Extension Stored Procedure
------------------------------------------------------------------------------------------------------------------------------
--If Object_ID('sp_Risk_Report_PriceRisk_ClientExtension') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_ClientExtension	@c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@i_WhatIf_ID			= @i_WhatIf_ID
--								,@i_WhatIf_Compare_ID		= @i_WhatIf_Compare_ID
--								,@b_discountpositions		= @b_discountpositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotBeginDate_1	= @sdt_SnapshotBeginDate_1
--								,@sdt_SnapshotBeginDate_2	= @sdt_SnapshotBeginDate_2
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@sdt_SnapshotEndofDay_2	= @sdt_SnapshotEndofDay_2
--								,@c_ShowDailyExposure		= @c_ShowDailyExposure
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--								,@c_InventoryType		= @c_InventoryType
--End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Update for Client External Columns
------------------------------------------------------------------------------------------------------------------------------
--If @vc_AdditionalColumns Like '%v_Risk_Reports_Exposure_Client_ExternalColumns%' And Object_ID('sp_Risk_Report_PriceRisk_Load_ClientColumns') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_Load_ClientColumns	@c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@i_WhatIf_ID			= @i_WhatIf_ID
--								,@i_WhatIf_Compare_ID		= @i_WhatIf_Compare_ID
--								,@b_discountpositions		= @b_discountpositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotBeginDate_1	= @sdt_SnapshotBeginDate_1
--								,@sdt_SnapshotBeginDate_2	= @sdt_SnapshotBeginDate_2
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@sdt_SnapshotEndofDay_2	= @sdt_SnapshotEndofDay_2
--								,@c_ShowDailyExposure		= @c_ShowDailyExposure
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--								,@vc_InventoryTypeCode		= @vc_InventoryTypeCode
--End

-- Fill the final temp table to return the results
/*
Create Table #RiskExposureFinalResults
		(
		RiskID				Int		Not Null
		,RiskExposureResultsIdnty	Int		Not Null
		,Description			Varchar(8000)	Null
		,DlDtlID			Int		Null
		,RiskType			Char(1)		Null
		,PeriodStartDate		SmallDateTime	Null
		,PeriodEndDate			SmallDateTime	Null
		,PeriodGroupStartDate		SmallDateTime	Null
		,PeriodGroupEndDate		SmallDateTime	Null
		,Position			Float		Null
		,StrtgyID			Int		Null
		,PricedInPercentage		Float		Null
		,PortfolioOrPositionGroup	VarChar(8000)	Null
		,ExposureQuoteDate		SmallDateTime	Null
		)

	Create NonClustered Index ID_#FinalResultsExposure_RiskID on #FinalResultsExposure (RiskID)
end
*/
If @vc_StatementGrouping = 'LoadFinalResults'
Begin
	Declare @vc_positionsql  varchar(8000)

	Select	@vc_positionsql  = 	Case	When	@b_DiscountPositions = 1
						Then	
		'Case	When	#RiskExposureResults.IsQuotational = 1
			Then	#RiskExposureResults.Position
			Else	#RiskExposureResults.Position * IsNull(#RiskExposureResults.DiscountFactor, 1.0)
		End'
						Else	'#RiskExposureResults.Position'
					End

	select	@vc_DynamicSQL  = '
	Insert	#RiskExposureFinalResults
		(
		RiskID
		,RiskExposureResultsIdnty
		,Description
		,DlDtlID
		,RiskType
		,PeriodStartDate
		,PeriodEndDate
		,PeriodGroupStartDate
		,PeriodGroupEndDate
		,Position
		,StrtgyID
		,PricedInPercentage
		,PortfolioOrPositionGroup
		,ExposureQuoteDate
		)
	Select	#RiskExposureResults.RiskID
		,#RiskExposureResults.Idnty
		,RiskDealIdentifier.Description
		,RiskDealIdentifier.DlDtlID
		,#RiskExposureResults.RiskType
		,#RiskExposureResults.PeriodStartDate
		,#RiskExposureResults.PeriodEndDate
		,Case When #RiskExposureResults.PeriodStartDate > ''' + convert(varchar(20), DateAdd(minute, -1, DateAdd(day, 1, @dt_maximumtradeperiodstartdate)) ,20) + ''' Then ''12/31/2050'' Else #RiskExposureResults.PeriodStartDate End
		,Case When #RiskExposureResults.PeriodStartDate > ''' + convert(varchar(20), DateAdd(minute, -1, DateAdd(day, 1, @dt_maximumtradeperiodstartdate)) ,20) + ''' Then ''12/31/2050'' Else #RiskExposureResults.PeriodEndDate End
		,' + @vc_positionsql + '
		,Coalesce(#RiskExposureResults.StrtgyID, Risk.StrtgyID)
		,Case	When	#RiskExposureResults. TotalPercentage = 0.0 
			Then	0.0 
			Else	IsNull(#RiskExposureResults.PricedInPercentage, 1.0) / #RiskExposureResults. TotalPercentage 
		End	--Priced In %
		,' + IsNull(dbo.RiskColumnPortfolioOrPositionGroup(@vc_type, @i_id, 'Y', 'N', 'N', 'Coalesce(#RiskExposureResults.StrtgyID, Risk.StrtgyID)', 'Risk.PrdctID', 'Risk.ChmclID', 'Risk.LcleID'), 'Null') + '
		,' + Case When @c_ExposureType in('P', 'Y', 'H', 'D' ) Then 'IsNull(#RiskExposureResults.ExposureStartDate, #RiskExposureResults.EndOfDay)' Else 'Convert(SmallDateTime, Null)' End + '
	From	#RiskExposureResults
		Left Outer Join dbo.Risk (NoLock)		On	#RiskExposureResults.RiskID	= Risk.RiskID
		Left Outer Join dbo.RiskDealIdentifier (NoLock)	On	Risk.RiskDealIdentifierID	= RiskDealIdentifier.RiskDealIdentifierID'

	------------------------------------------------------------------------------------------------------------------------------
	-- Return the data
	------------------------------------------------------------------------------------------------------------------------------
	if @c_OnlyShowSQL = 'Y'
		select	@vc_DynamicSQL
	Else
		Execute	(@vc_DynamicSQL)
End

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\SP_MTV_SalesForceDLInvoicesStaging.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSalesforceDLInvoicesStaging WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_MTVSalesforceDLInvoicesStaging.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTVSalesforceDLInvoicesStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging]
		@n_NumRecordsToBeStaged int,
		@c_OnlyShowSQL char(1) = 'N'
AS

-- =========================================================================
-- Author:        Sanjay Kumar
-- Create date:	  9MAY2016
-- Description:   This SP pulls data from the CustomInvoiceInterface table,
--				  pushes it into MTVSalesforceDLInvoicesStaging, ready for 
--				  the user to run the SalesforceDLInvoicesExtract job
-- =========================================================================
-- Date         Modified By     Issue#  Modification
-- 12/12/2016   Sanjay Kumar            Added the TaxRate type to be populated in the Staging table.
-- -----------  --------------  ------  -------------------------------------
-- exec MTVSalesforceDLInvoicesStaging 100, 'y'
--Latest Version
-----------------------------------------------------------------------------

DECLARE @vc_DynamicSQL	varchar(max)

set @vc_DynamicSQL = 'MTVTruncateMTVRetailerInvoicePreStage'
exec(@vc_DynamicSQL)

-- Create a temp table to hold our data
if (@c_OnlyShowSQL <> 'N')
	print '
	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		MotivaFEIN						Varchar(255),
		CompanyName						Varchar(255),
		MotivaARContactName				Varchar(40),
		ARContactEmail					Varchar(50),
		ARContactPhone					Varchar(25),
		BillToSoldToName				Varchar(100),
		BillToAddress					Varchar(255),
		BillToContact					Varchar(40),
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		DealNumber						Varchar(20),
		RemitTo							Varchar(1000),
		ShipFromTerminalAddress			Varchar(255),
		ShipToNumber					Varchar(255),
		ShipToAddress					Varchar(255),
		CustomerCharges					Varchar(80),
		ProductNumber					Varchar(255),
		ProductName						Varchar(50),
		OriginTerminal					Varchar(50),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		MovementType					Varchar(50),
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		BillingBasisIndicator			Varchar(10),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		TaxCode							Varchar(255),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		DeferredTaxInvoiceDueDate		SmallDateTime,
		IsDeferred						char(1),
		RegulatoryText					Varchar(8000),
		EPAID							Varchar(255),
		DistributionChannel				Varchar(255),
		Division						Varchar(255),
		SalesOrg						Varchar(255),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		PaymentMethod					Varchar(100),
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)'
else
	create table #tempMessageQueueIds (MessageQueueId int)
	insert #tempMessageQueueIds
	select distinct top (@n_NumRecordsToBeStaged) CII.MessageQueueID from CustomInvoiceInterface CII 
								Inner Join MTVInvoiceInterfaceStatus MTVIIS (NoLock) on 
								MTVIIS.CIIMssgQID = CII.MessageQueueID 
								where CII.IntBAID = 22 and MTVIIS.SalesForceDataLakeStaged	<> convert(bit, 1)
								order by CII.MessageQueueID asc

	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		MotivaFEIN						Varchar(255),
		CompanyName						Varchar(255),
		MotivaARContactName				Varchar(40),
		ARContactEmail					Varchar(50),
		ARContactPhone					Varchar(25),
		BillToSoldToName				Varchar(100),
		BillToAddress					Varchar(255),
		BillToContact					Varchar(40),
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		DealNumber						Varchar(20),
		RemitTo							Varchar(1000),
		ShipFromTerminalAddress			Varchar(255),
		ShipToNumber					Varchar(255),
		ShipToAddress					Varchar(255),
		CustomerCharges					Varchar(80),
		ProductNumber					Varchar(255),
		ProductName						Varchar(50),
		OriginTerminal					Varchar(50),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		MovementType					Varchar(50),
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		BillingBasisIndicator			Varchar(10),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		TaxCode							Varchar(255),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		DeferredTaxInvoiceDueDate		SmallDateTime,
		IsDeferred						char(1),
		RegulatoryText					Varchar(8000),
		EPAID							Varchar(255),
		DistributionChannel				Varchar(255),
		Division						Varchar(255),
		SalesOrg						Varchar(255),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		PaymentMethod					Varchar(100),
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)

--	Grab all records from the CustomInvoiceInterface table where the SalesForceDataLakeStaged column is not 1
if (@c_OnlyShowSQL <> 'N')
	print N'Insert	
	#Stage ( 	Id,
				TagIdentifier, 
				MsgQID , 
				MotivaFEIN, 
				CompanyName, 
				MotivaARContactName, 
				ARContactEmail, 
				ARContactPhone, 
				BillToSoldToName, 
				BillToAddress, 
				BillToContact, 
				BillToSoldToNumber, 
				InvoiceNumber, 
				InvoiceDateTime,
				PaymentTerms, 
				DealNumber, 
				RemitTo, 
				ShipFromTerminalAddress, 
				ShipToNumber, 
				ShipToAddress, 
				CustomerCharges, 
				ProductNumber, 
				ProductName, 
				OriginTerminal, 
				TerminalCode, 
				StandardCarrier, 
				CarrierName,
				BOLNumber, 
				LoadDateTime, 
				MovementType, 
				NetVolume, 
				GrossVolume, 
				BillingBasisIndicator, 
				UOM, 
				PerGallonBillingRate, 
				TotalProductCost, 
				TaxName, 
				TaxCode, 
				RelatedSalesInvoiceNumber,
				InvoiceDueDate, 
				DiscountedTotalAmount,
				InvoiceType,
				CorrectingInvoiceNumber, 
				DeferredTaxInvoiceNumber, 
				DeferredTaxInvoiceDueDate, 
				IsDeferred, 
				RegulatoryText, 
				EPAID, 
				DistributionChannel, 
				Division, 
				SalesOrg, 
				InvoiceTotalAmount, 
				TotalTax,
				NetAmount,
				CreationDate,
				PaymentMethod,
				InvoiceId,
				MvtHdrId,
				AcctDtlId,
				TransactionType)
Select	CII.Id,
		case when (CII.InvoiceLevel != ''H'' and CAD.DlDtlPrvsnCostType = ''S'') then ''F'' else CII.InvoiceLevel end, 
		CII.MessageQueueID, 
		'',
		'', 
		'',
		'',
		'',
		'', 
		'',
		'',	
		CADA.SAPSoldToCode, 
		CII.InvoiceNumber, 
		CII.InvoiceDate, 
		case when (CII.InvoiceLevel = ''H'') then Term.TrmVrbge else '''' end,
		'',	
		'',
		'',	
		CADA.SAPShipToCode,
		'', 
		CAD.TrnsctnTypDesc, 
		SAPMC.GnrlCnfgMulti, 
		'', 
		'', 
		CADA.SAPPlantCode, 
		case when (CII.InvoiceLevel = ''D'') then CADA.ShipperSCAC else '''' end, 
		case when (CII.InvoiceLevel = ''D'') then Carrier.BANme else '''' end, 
		case when (CII.BL = '''') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end,
		case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then MH.MvtHdrDte else '''' end,
		'', 
		case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then ISNULL(AD.NetQuantity, 0.0) else '''' end, 
		case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then ISNULL(AD.GrossQuantity, 0.0) else '''' end,  
		'', 
		case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'' or CII.InvoiceLevel = ''T'')then CII.UOM else '''' end, 
		case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end,
		case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
			 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end,
		case when (CII.InvoiceLevel = ''T'') then TRS.InvoicingDescription else '''' end, 
		'', 
		case when (CII.InvoiceLevel = ''H'') (select stuff((select ''~ '' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
			Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
				SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
			Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
				RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
		where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('')),1,1,'')) else '' end,
		case when (CII.InvoiceLevel = ''H'') then CII.DueDate else '' end,	
		case when (CII.InvoiceLevel = ''H'') then CADA.DiscountAmount else null end, 
		case when (SIH.DeferredInvoice = ''Y'' ) then ''Deferred''
			 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then ''Original'' 
			 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then ''Cancellation'' 
			 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then ''Rebill'' end,
		case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end,
		case when (CII.InvoiceLevel = ''H'') then (select stuff((
					select ''~'' + RDI.SlsInvceHdrNmbr
						from SalesInvoiceHeader SIH1
						Left Join SalesInvoiceHeaderRelation SIHR on 
							SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
						Left Join SalesInvoiceHeader RDI On
							SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = ''Y'' 
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
							order by SIH1.SlsInvceHdrID
							for xml path('')),1,1,'')) else '' end,
						null, 
						'', 
		case when (CII.InvoiceLevel = ''H'') (select stuff((
					select ''~ '' + SIA1.Mssge from SalesInvoiceHeader SIH1
							inner join SalesInvoiceAddendum SIA1 
							on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
							where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
							order by SIH1.SlsInvceHdrID
							for xml path('')),1,1,'')) else '' end,	
						'', 
						'', 
						'', 
						'', 
		case when (CII.InvoiceLevel = ''H'') then SIH.SlsInvceHdrTtlVle else null end,
		0,
		case when (CII.InvoiceLevel = ''H'') then SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount else null end,
		getdate(),
		'' As PaymentMethod,
		CII.InvoiceId,
		CAD.MvtHdrID,
		CAD.AcctDtlID,
		CII.TransactionType
		From	CustomInvoiceInterface CII with (NoLock)
		inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
						Left Outer Join SalesInvoiceHeader SIH (NoLock) on	
								CII.InvoiceID = SIH.SlsInvceHdrID
						Left Join DealHeader As DH (NoLock) On 
								DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'') WHEN '' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
						Left Outer Join Term with (NoLock) on 
								Term.TrmID = SIH.SlsInvceHdrTrmID
						Left Join StrategyHeader SH (NoLock) on
								SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
						Left Join AccountDetail As AD (NoLock) On 
								AD.AcctDtlID = CII.AcctDtlID
						Left Join TransactionDetailLog (NoLock) On
								TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
						Left Join TransactionDetail (NoLock) On
								TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
								and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
								and TransactionDetailLog.XDtlLgXDtlID = TransactionDetail. XDtlID
						Left Join CustomAccountDetail CAD (NoLock) On 
								CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
						Left Join CustomAccountDetailAttribute CADA (NoLock) On	
								CADA.CADID = CAD.ID
						Left Join Product (NoLock) On 
								Product.PrdctID = AD.ChildPrdctID
						Left Join SalesInvoiceHeader CIH (NoLock) On 
								CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
						Left Join TaxDetailLog (NoLock) On
							AD.AcctDtlSrceID = TaxDetailLog.TxDtlLgID And (AD.AcctDtlSrceTble = ''T'' or AD.AcctDtlSrceTble = ''I'')
						Left Join TaxDetail (NoLock) On
							TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
						Left Join TaxRuleSet TRS (NoLock) On 
								TRS.TxRleStID = TaxDetail.TxRleStID
						Left Join MovementDocument As BillOfLading (NoLock) On
								BillOfLading.MvtDcmntID =  (select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)
						Left Join MovementHeader MH (NoLock) On	
								MH.MvtHdrID = CAD.MvtHdrID
						Left Join BusinessAssociate Carrier (NoLock) On	
								Carrier.BAID = MH.MvtHdrCrrrBAID
						Left Join GeneralConfiguration As SAPMC (NoLock) On
								SAPMC.GnrlCnfgQlfr = ''SAPMaterialCode''
								And SAPMC.GnrlCnfgTblNme = ''Product''
								And SAPMC.GnrlCnfgHdrID = Product.PrdctID'
else
		Insert #Stage (	Id,
						TagIdentifier, 
						MsgQID, 
						MotivaFEIN, 
						CompanyName, 
						MotivaARContactName, 
						ARContactEmail, 
						ARContactPhone, 
						BillToSoldToName, 
						BillToAddress, 
						BillToContact, 
						BillToSoldToNumber, 
						InvoiceNumber, 
						InvoiceDateTime,
						PaymentTerms, 
						DealNumber, 
						RemitTo, 
						ShipFromTerminalAddress, 
						ShipToNumber, 
						ShipToAddress, 
						CustomerCharges, 
						ProductNumber, 
						ProductName, 
						OriginTerminal, 
						TerminalCode, 
						StandardCarrier, 
						CarrierName,
						BOLNumber, 
						LoadDateTime, 
						MovementType, 
						NetVolume, 
						GrossVolume, 
						BillingBasisIndicator, 
						UOM, 
						PerGallonBillingRate, 
						TotalProductCost, 
						TaxName, 
						TaxCode, 
						RelatedSalesInvoiceNumber,
						InvoiceDueDate, 
						DiscountedTotalAmount,
						InvoiceType,
						CorrectingInvoiceNumber, 
						DeferredTaxInvoiceNumber, 
						DeferredTaxInvoiceDueDate, 
						IsDeferred, 
						RegulatoryText, 
						EPAID, 
						DistributionChannel, 
						Division, 
						SalesOrg, 
						InvoiceTotalAmount, 
						TotalTax,
						NetAmount,
						CreationDate,
						PaymentMethod,
						InvoiceId,
						MvtHdrId,
						AcctDtlId,
						TransactionType)
				Select	CII.Id,
						case when (CII.InvoiceLevel != 'H' and CAD.DlDtlPrvsnCostType = 'S') then 'F' else CII.InvoiceLevel end, 
						CII.MessageQueueID, 
						'',
						'', 
						'',
						'', 
						'', 
						'', 
						'',
						'',	
						CADA.SAPSoldToCode, 
						CII.InvoiceNumber, 
						CII.InvoiceDate, 
						case when (CII.InvoiceLevel = 'H') then Term.TrmVrbge else '' end,
						'',	
						'',
						'',
						case when (CII.InvoiceLevel = 'D') then CADA.SAPShipToCode else '' end,
						'', 
						CAD.TrnsctnTypDesc, 
						SAPMC.GnrlCnfgMulti, -- Will need to tweak the Staging code to display at the Fee & Detail Level.
						'', 
						'', 
						CADA.SAPPlantCode, 
						CADA.ShipperSCAC, 
						case when (CII.InvoiceLevel = 'D') then Carrier.BANme else '' end, 
						case when (CII.BL = '') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end, -- Will need to tweak the Staging code to display at the Tax & Detail Level.
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then MH.MvtHdrDte else '' end,
						'', 
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then AD.NetQuantity else null end, 
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then AD.GrossQuantity else null end,  
						'', 
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H' or CII.InvoiceLevel = 'T')then CII.UOM else '' end, 
						case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end, -- D, T & F
						case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
							 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end, -- H, D & F
						case when (CII.InvoiceLevel = 'T') then TRS.InvoicingDescription else '' end, 
						'', 
						case when (CII.InvoiceLevel = 'H') then (select stuff((select '~ ' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
							Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
							SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
							Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
							RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('')),1,1,''))
						else '' end,
						case when (CII.InvoiceLevel = 'H') then CII.DueDate else '' end,	
						case when (CII.InvoiceLevel = 'H') then CADA.DiscountAmount else null end, 
						case when (SIH.DeferredInvoice = 'Y' ) then 'RA-Deferred Tax' 
							 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then 'RA-Original' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then 'RA-Cancellation' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then 'RA-Rebill' end, -- H only
						case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end, -- H only
						case when (CII.InvoiceLevel = 'H') then (select stuff((
							select '~' + RDI.SlsInvceHdrNmbr
								from SalesInvoiceHeader SIH1
								Left Join SalesInvoiceHeaderRelation SIHR on 
									SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
								Left Join SalesInvoiceHeader RDI On
									SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = 'Y' 
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')) else '' end,
						null, 
						'', 
						case when (CII.InvoiceLevel = 'H') then (select stuff((
							select '~ ' + SIA1.Mssge from SalesInvoiceHeader SIH1
								inner join SalesInvoiceAddendum SIA1 
									on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')) else '' end,	
						'', 
						'', 
						'', 
						'', 
						case when (CII.InvoiceLevel = 'H') then SIH.SlsInvceHdrTtlVle else null end,
						0,
						case when (CII.InvoiceLevel = 'H') then SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount else null end,
						getdate(),
						'',
						CII.InvoiceId,
						CAD.MvtHdrID,
						CAD.AcctDtlID,
						CII.TransactionType
				From	CustomInvoiceInterface CII with (NoLock)
				inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
						Left Outer Join SalesInvoiceHeader SIH (NoLock) on	
								CII.InvoiceID = SIH.SlsInvceHdrID
						Left Join DealHeader As DH (NoLock) On 
								DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'') WHEN '' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
						Left Outer Join Term with (NoLock) on 
								Term.TrmID = SIH.SlsInvceHdrTrmID
						Left Join StrategyHeader SH (NoLock) on
								SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
						Left Join AccountDetail As AD (NoLock) On 
								AD.AcctDtlID = CII.AcctDtlID
						Left Join TransactionDetailLog (NoLock) On
								TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
						Left Join TransactionDetail (NoLock) On
								TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
								and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
								and TransactionDetailLog.XDtlLgXDtlID = TransactionDetail. XDtlID
						Left Join CustomAccountDetail CAD (NoLock) On 
								CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
						Left Join CustomAccountDetailAttribute CADA (NoLock) On	
								CADA.CADID = CAD.ID
						Left Join Product (NoLock) On 
								Product.PrdctID = AD.ChildPrdctID
						Left Join SalesInvoiceHeader CIH (NoLock) On 
								CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
						Left Join TaxDetailLog (NoLock) On
							AD.AcctDtlSrceID = TaxDetailLog.TxDtlLgID And (AD.AcctDtlSrceTble = 'T' or AD.AcctDtlSrceTble = 'I')
						Left Join TaxDetail (NoLock) On
							TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
						Left Join TaxRuleSet TRS (NoLock) On 
								TRS.TxRleStID = TaxDetail.TxRleStID
						Left Join MovementDocument As BillOfLading (NoLock) On
								BillOfLading.MvtDcmntID =  (select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)
						Left Join MovementHeader MH (NoLock) On	
								MH.MvtHdrID = CAD.MvtHdrID
						Left Join BusinessAssociate Carrier (NoLock) On	
								Carrier.BAID = MH.MvtHdrCrrrBAID
						Left Join GeneralConfiguration As SAPMC (NoLock) On
								SAPMC.GnrlCnfgQlfr = 'SAPMaterialCode'
								And SAPMC.GnrlCnfgTblNme = 'Product'
								And SAPMC.GnrlCnfgHdrID = Product.PrdctID
						/*RLB - Removed due to Headers that have transactionstype of Discount when only reversal due to highestvalue flag on CAD*/

/*RLB - Added to remove any discounts due to logic above being commented out*/
DELETE FROM #Stage WHERE #Stage.TransactionType = 'Discount' and #Stage.TagIdentifier <> 'H'

--New Logic to fill in missing Header level stuff
UPDATE	#Stage
SET		LoadDateTime = MH.MvtHdrDte
FROM	#Stage
INNER JOIN	MovementHeader MH (NoLock) 
ON	(SELECT top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
							(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = #Stage.InvoiceId)) =  MH.MvtHdrID
WHERE	#Stage.MvtHdrId IS NULL

Select	@vc_DynamicSQL = '
Insert	MTVRetailerInvoicePreStage (
		TagIdentifier,
		CIIMssgQID,
		MotivaFEIN,
		CompanyName,
		MotivaARContactName,
		ARContactEmail,
		ARContactPhone,
		BillToSoldToName,
		BillToAddress,
		BillToContact,
		BillToSoldToNumber,
		InvoiceNumber,
		InvoiceDateTime,
		PaymentTerms,
		DealNumber,
		RemitTo,
		ShipFromTerminalAddress,
		ShipToNumber,
		ShipToAddress,
		CustomerCharges,
		ProductNumber,
		ProductName,
		OriginTerminal,
		TerminalCode,
		StandardCarrier,
		CarrierName,
		BOLNumber,
		LoadDateTime,
		MovementType,
		NetVolume,
		GrossVolume,
		BillingBasisIndicator,
		UOM,
		PerGallonBillingRate,
		TotalProductCost,
		TaxName,
		TaxCode,
		RelatedInvoiceNumber,
		InvoiceDueDate,
		CashDiscountAmount,
		InvoiceType,
		CorrectingInvoiceNumber,
		DeferredTaxInvoiceNumber,
		DeferredTaxInvoiceDueDate,
		IsDeferred,
		RegulatoryText,
		EPAID,
		DistributionChannel,
		Division,
		SalesOrg,
		InvoiceTotalAmount,
		TotalTax,
		TransactionType,
		TaxRate,
		TaxableQuantity,
		TaxAmount,
		PaymentMethod,
		ReportingGroups,
		NexusMessageId,
		NetAmount,
		AcctDtlId,
		CreationDate)
   select ST.TagIdentifier
		, ST.MsgQID
		, ST.MotivaFEIN
		, ST.CompanyName
		, ST.MotivaARContactName
		, ST.ARContactEmail
		, ST.ARContactPhone
		, ST.BillToSoldToName
		, ST.BillToAddress
		, ST.BillToContact
		, ST.BillToSoldToNumber
		, ST.InvoiceNumber
		, ST.InvoiceDateTime
		, ST.PaymentTerms
		, ST.DealNumber
		, ST.RemitTo
		, ST.ShipFromTerminalAddress
		, ST.ShipToNumber
		, ST.ShipToAddress
		, ST.CustomerCharges
		, ST.ProductNumber
		, ST.ProductName
		, ST.OriginTerminal					
		, ST.TerminalCode					
		, ST.StandardCarrier					
		, ST.CarrierName						
		, ST.BOLNumber						
		, ST.LoadDateTime					
		, ST.MovementType					
		, ST.NetVolume						
		, ST.GrossVolume						
		, ST.BillingBasisIndicator
		, ST.UOM								
		, ST.PerGallonBillingRate			
		, ST.TotalProductCost
		, ST.TaxName
		, ST.TaxCode
		, ST.RelatedSalesInvoiceNumber						
		, ST.InvoiceDueDate					
		, ST.DiscountedTotalAmount	
		, ST.InvoiceType			
		, ST.CorrectingInvoiceNumber			
		, ST.DeferredTaxInvoiceNumber		
		, ST.DeferredTaxInvoiceDueDate		
		, ST.IsDeferred						
		, ST.RegulatoryText					
		, ST.EPAID							
		, ST.DistributionChannel				
		, ST.Division						
		, ST.SalesOrg						
		, ST.InvoiceTotalAmount				
		, ST.TotalTax
		, ST.CustomerCharges
		, 0
		, 0
		, 0
		, ST.PaymentMethod
		, null
		, 0
		, ST.NetAmount
		, ST.AcctDtlId
		, ST.CreationDate
		from #Stage ST'

		if (@c_OnlyShowSQL <> 'N')
			print @vc_DynamicSQL
		else
			exec(@vc_DynamicSQL)

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	UPDATE t SET t.BillingBasisIndicator = 'Net' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Net'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL

	UPDATE t SET t.BillingBasisIndicator = 'Gross' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Gross'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\SP_MTV_SalesForceDLInvoicesStaging.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Search_SupplyToFSM_Primary.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Primary.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Search_SupplyToFSM_Primary] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
execute MTV_Search_SupplyToFSM_Primary @sdt_DateTime = '2015-03-31 00:00'
*/

ALTER PROCEDURE [dbo].[MTV_Search_SupplyToFSM_Primary]
								(
								@sdt_DateTime			SmallDateTime = Null,
								@vc_LocaleIds			Varchar(8000)	= NULL,
								@vc_ProductIds			Varchar(8000)	= NULL,
								@i_FromBAId				Varchar(8000)   = NULL,
								@i_ToBAId				Varchar(8000)	= NULL

								)

AS

DECLARE @vc_ProvisionRuleIDs	Varchar(8000)	= NULL,
	@vc_TransferPriceTypes	Varchar(8000)	= 'YT01'
	
If @sdt_DateTime = Null select @sdt_DateTime = getdate()

SET @sdt_DateTime = dateadd(DAY, -1, @sdt_DateTime)

   
Create Table #ProvisionRuleIds
(
	ID	Int
)

Create Table #BAIdsFrom 
(
	 ID INT, 
 )

Create Table #BAIdsTo
(
	 ID INT, 
 )

 Create Table #AllBAs
 (
  ID INT
 )
 
 --DECLARE @i_FromBAID Int,
--@i_ToBAID int 
--Select @i_FromBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name =  dbo.GetRegistryValue('MotivaSTLIntrnlBAName')
--Select @i_ToBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name = dbo.GetRegistryValue('MotivaFSMIntrnlBAName')

INSERT INTO #AllBAs
SELECT BAID
FROM BusinessAssociate AS ba 
WHERE ba.BAStts = 'A' AND
ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))

IF IsNull(LTrim(RTrim(@i_FromBAId)),'') = '' AND IsNull(LTrim(RTrim(@i_ToBAId)),'') = ''
	BEGIN
		INSERT #BAIdsFrom(ID)
		SELECT ID FROM #AllBAs

		----SELECT BAID
		----FROM BusinessAssociate AS ba 
		----WHERE ba.BAStts = 'A' AND
		----ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))

		INSERT #BAIdsTo(ID)
		SELECT ID FROM #AllBAs

		--SELECT BAID
		--FROM BusinessAssociate AS ba 
		--WHERE ba.BAStts = 'A' AND
		--ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))
	END
ELSE
	BEGIN
		IF (@i_FromBAId IS NOT NULL)
			BEGIN
				INSERT #BAIdsFrom(ID)
				SELECT BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND	ba.BAID = Convert(int, @i_FromBAId)
			END
		ELSE
			BEGIN
				INSERT #BAIdsFrom(ID)
				SELECT ID FROM #AllBAs
			END
					

		IF (@i_ToBAId IS NOT NULL)
			BEGIN
				INSERT #BAIdsTo(ID)
				SELECT BAID	FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND	ba.BAID = Convert(int, @i_ToBAId)
			END
		ELSE
			BEGIN
				INSERT #BAIdsTo(ID)
				SELECT ID FROM #AllBAs
			END
	END
	

If	IsNull(LTrim(RTrim(@vc_ProvisionRuleIDs)),'') = ''
Begin
	Insert	#ProvisionRuleIds
	Select	ProvisionRuleID
	From	dbo.ProvisionRule
	Where	[Status] = 'A'
	And		Exists
			(
			Select	1
			From	dbo.ProvisionRuleCondition
			Where	ProvisionRuleCondition.ProvisionRuleID = ProvisionRule.ProvisionRuleID
			And		ProvisionRuleCondition.FromBAID IN (select Id from #BAIdsFrom)--- STL
			And		ProvisionRuleCondition.ToBAID IN (select Id From #BAIdsTo) ---FSM
			And		ProvisionRuleCondition.Exclude = 'N'
			)		
End
Else
Begin
	Insert	#ProvisionRuleIds
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_ProvisionRuleIDs) Ids
	Where	IsNumeric(Ids.Value) = 1

	Delete	#ProvisionRuleIds
	Where	Not Exists
			(
			Select	1
			From	ProvisionRule
			Where	ProvisionRule.ProvisionRuleID = #ProvisionRuleIds.ID
			And		ProvisionRule.[Status] = 'A'
			)
	And		Not Exists
			(
			Select	1
			From	dbo.ProvisionRuleCondition
			Where	ProvisionRuleCondition.ProvisionRuleID = #ProvisionRuleIds.ID
			And		ProvisionRuleCondition.FromBAID IN (select Id from #BAIdsFrom)--- STL
			And		ProvisionRuleCondition.ToBAID IN (select Id From #BAIdsTo) ---FSM
			And		ProvisionRuleCondition.Exclude = 'N'
			)
End

   
Create Table #Locales
(
	ID Int
)

If	IsNull(LTrim(RTrim(@vc_LocaleIds)),'') = ''
Begin
	Insert	#Locales
	Select	Distinct 
			ProvisionRuleProdLoc.LcleID
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Locales
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_LocaleIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End

Create Table #Products
(
	ID Int
)

If	IsNull(LTrim(RTrim(@vc_ProductIds)),'') = ''
Begin
	Insert	#Products
	Select	Distinct 
			ProvisionRuleProdLoc.PrdctID
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Products
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_ProductIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End

Create Table #TransferPriceTypes
(
	ID Varchar(4)
)

----------------------------------------------------------------------------------------------------
-- Not sure what the attribute will be named that is going to be on the RawPriceLocale to specify
-- YT2 to YT10, or if it will be in dynamic list box.  I put it in dynamic list box.
----------------------------------------------------------------------------------------------------

If	IsNull(LTrim(RTrim(@vc_TransferPriceTypes)),'') = ''
Begin
	Insert	#TransferPriceTypes
	Select	DynLstBxTyp
	From	dbo.DynamicListBox
	Where	DynLstBxQlfr = 'TransferPriceType' AND DynLstBxTblTyp IN ('YT01')
End
Else
Begin
	Insert	#TransferPriceTypes
	Select	Convert(Varchar(4),Value)
	From	dbo.CreateTableList(@vc_TransferPriceTypes) Ids
End

------------------------------------------------------------------------------------------------
-- Get the provision rule product locations
------------------------------------------------------------------------------------------------
Create Table #ProvisionRuleProdLocs
(
	ProvisionRuleProdLocID	Int,
	ProvisionRuleID			Int,
	PrdctID					Int,
	LcleID					Int
)

Insert	#ProvisionRuleProdLocs
		(
		ProvisionRuleProdLocID,
		ProvisionRuleID,
		PrdctID,
		LcleID
		)
Select	ProvisionRuleProdLocID,
		ProvisionRuleID,
		PrdctID,
		LcleID
From	dbo.ProvisionRuleProdLoc
Where	Exists
		(
		Select	1
		From	#ProvisionRuleIds
		Where	#ProvisionRuleIds.ID = ProvisionRuleProdLoc.ProvisionRuleID
		)
And		Exists
		(
		Select	1
		From	#Locales
		Where	#Locales.ID = ProvisionRuleProdLoc.LcleID
		)
And		Exists
		(
		Select	1
		From	#Products
		Where	#Products.ID = ProvisionRuleProdLoc.PrdctID
		)


--------------------------------------------------------------------------------------------
-- Get all the provision rows are secondary costs
--------------------------------------------------------------------------------------------
Create Table #DealDetailProvisionRows
(
	ProvisionRuleProdLocID Int,
	DlDtlPrvsnID	Int,
	DlDtlPrvsnRwID	Int,
	Percentage		Float,
	RwPrceLcleID	Int,
	PricetypeID		SMALLINT,
	ProvisionName	Varchar(80)
)

--------------------------------------------------------------------------------------------
-- First insert the ones that apply to all prod/locs on the rule
-- I chose not to dbo.V_FormulaTablet for performance reasons, but it could be used
----------------------------------------------------------------------------------------------
Insert	#DealDetailProvisionRows
		(
		ProvisionRuleProdLocID,
		DlDtlPrvsnID,
		DlDtlPrvsnRwID,
		Percentage,
		RwPrceLcleID,
		PricetypeID
		)
Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(Int, PriceAttribute3),
		Convert(Int, PriceAttribute7)
From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleDlDtlPrvsn	On	ProvisionRuleDlDtlPrvsn.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
												And	@sdt_DateTime Between ProvisionRuleDlDtlPrvsn.StartDate And ProvisionRuleDlDtlPrvsn.EndDate
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	DealDetailProvision.CostType = 'P'
												And	@sdt_DateTime Between DealDetailProvision.DlDtlPrvsnFrmDte And DealDetailProvision.DlDtlPrvsnToDte
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute7) = 1
												AND DealDetailProvisionRow.DlDtlPRvsnRwTpe = 'F'



--------------------------------------------------------------------------------------------
-- Insert ones that only apply to specific product location combinations
----------------------------------------------------------------------------------------------
Insert	#DealDetailProvisionRows
		(
		ProvisionRuleProdLocID,
		DlDtlPrvsnID,
		DlDtlPrvsnRwID,
		Percentage,
		RwPrceLcleID,
		PricetypeID
		)
Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(Int, DealDetailProvisionRow.PriceAttribute3),
		Convert(Int, DealDetailProvisionRow.PriceAttribute7)
From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleProdLocDlDtlPrvsn
												On	ProvisionRuleProdLocDlDtlPrvsn.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
												And	@sdt_DateTime Between ProvisionRuleProdLocDlDtlPrvsn.StartDate And ProvisionRuleProdLocDlDtlPrvsn.EndDate
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	DealDetailProvision.CostType = 'P'
												And	@sdt_DateTime Between DealDetailProvision.DlDtlPrvsnFrmDte And DealDetailProvision.DlDtlPrvsnToDte
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute7) = 1
												AND DealDetailProvisionRow.DlDtlPRvsnRwTpe = 'F'

UPDATE #DealDetailProvisionRows
 SET ProvisionName = Prvsn.PrvsnDscrptn
FROM #DealDetailProvisionRows INNER JOIN DealDetailProvision ON DealDetailProvision.DlDtlPrvsnID = #DealDetailProvisionRows.DlDtlPrvsnID
INNER JOIN Prvsn ON DealDetailProvision.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID


--------------------------------------------------------------------------------------------
-- Get the distinct RwPrceLcleID and PriceTypeIDs to look up the prices and the categories
-- as there will be many provisions referencing the same ones
----------------------------------------------------------------------------------------------
Create Table #DistinctPrices
(
	ProvisionRuleProdLocID Int,
	RwPrceLcleID	Int,
	PriceTypeID		Int,
	RwPrceDtlID		INT NULL,
	RPDtlTpe		char(1) NULL,
	TransferPriceType	Varchar(40) NUll,
	Price			Float NULL,
	AllInPrice		FLOAT NULL
)

Insert	#DistinctPrices
		(
		ProvisionRuleProdLocID,
		RwPrceLcleID,
		PriceTypeID,
		RwPrceDtlID,
		TransferPriceType,
		Price
		)
Select	Distinct
		ProvisionRuleProdLocID,
		RwPrceLcleID,
		PriceTypeID,
		NULL,
		Null,
		NULL
From	#DealDetailProvisionRows

---------------------------------------------------------------------------------------------------
-- Update the TransferPriceType
---------------------------------------------------------------------------------------------------
Update	#DistinctPrices
Set		TransferPriceType = GeneralConfiguration.GnrlCnfgMulti
From	#DistinctPrices
		Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
										And	GeneralConfiguration.GnrlCnfgQlfr = 'TransferPriceType'
										And	GeneralConfiguration.GnrlCnfgHdrID = #DistinctPrices.RwPrceLcleID
										And	GeneralConfiguration.GnrlCnfgDtlID = 0
										And	Exists
											(
											Select	1
											From	#TransferPriceTypes
											Where	#TransferPriceTypes.ID = GeneralConfiguration.GnrlCnfgMulti
											)

------------------------------------------------------------------------------------------------------
-- If running with all cost categories then don't delete out ones you we could not find
------------------------------------------------------------------------------------------------------
If	IsNull(LTrim(RTrim(@vc_TransferPriceTypes)),'') = ''
Begin
	Update	#DistinctPrices
	Set		TransferPriceType = 'Unknown'
	Where	TransferPriceType is Null
End
Else
Begin
	---------------------------------------------------------------------------------------------------
	-- Delete #DistinctPrices where category is null
	---------------------------------------------------------------------------------------------------
	Delete	#DistinctPrices
	Where	TransferPriceType is Null

	Delete	#DealDetailProvisionRows
	Where	Not Exists
			(
			Select	1
			From	#DistinctPrices
			Where	#DistinctPrices.RwPrceLcleID = #DealDetailProvisionRows.RwPrceLcleID
			And		#DistinctPrices.PriceTypeID = #DealDetailProvisionRows.PriceTypeID
			)

End

Update	#DistinctPrices
Set		RwPrceDtlID = A.RwPrceDtlID
		,RPDtlTpe = A.RPDtlTpe
		,Price = A.RPVle
From	#DistinctPrices
			CROSS apply (select * from dbo.Motiva_FN_GetRawPriceValue(#DistinctPrices.RwPrceLcleID, #DistinctPrices.PriceTypeID,@sdt_DateTime,null,1)) A 
		
WHERE #DistinctPrices.RwPrceLcleID = A.RwPrceLcleID and #DistinctPrices.RwPrceDtlID IS null			
			
UPDATE #DistinctPrices
SET AllInPrice = A.RPVle
--SELECT  * --rp.RPVle, rp.RPPrceTpeIdnty
FROM #DistinctPrices 
INNER JOIN #ProvisionRuleProdLocs AS prpl ON prpl.ProvisionRuleProdLocID = #DistinctPrices.ProvisionRuleProdLocID
INNER JOIN RawPriceLocale AS rpl ON rpl.RPLcleChmclParPrdctID = prpl.PrdctID AND rpl.RPLcleLcleID = prpl.LcleID 
INNER JOIN RawPriceHeader AS rph ON rph.RPHdrID = rpl.RPLcleRPHdrID 
AND rph.RPHdrNme = dbo.GetRegistryValue('STLFSM_TransferPriceServiceName')
CROSS apply (SELECT top 1 rpd.Idnty, rpd.RwPrceLcleID, rp.RPVle, rp.RPPrceTpeIdnty 
             from RawPriceDetail AS rpd
             INNER JOIN RawPrice rp ON rp.RPRPDtlIdnty = rpd.Idnty AND rp.[Status] = 'A'
               where rpd.RwPrceLcleID = rpl.RwPrceLcleID AND rpd.RPDtlStts = 'A' AND
	( @sdt_DateTime BETWEEN rpd.RPDtlQteFrmDte and rpd.RPDtlQteToDte OR rpd.RPDtlTrdeFrmDte < @sdt_DateTime)
             ORDER BY rpd.RPDtlQteFrmDte DESC) A where A.RwPrceLcleID = rpl.RwPrceLcleID 




SELECT distinct #DealDetailProvisionRows.ProvisionName,	
		ProvisionRule.[Description],
		Product.PrdctAbbv,
		Locale.LcleAbbrvtn,
		#DealDetailProvisionRows.Percentage,
		RawPriceHeader.RPHdrAbbv,
		RawPriceLocale.CurveName,
		GC1.GnrlCnfgMulti SAPMaterialCode,
		GC2.GnrlCnfgMulti SAPPlantCode,
		RawPriceLocale.RPLcleIntrfceCde PlattsCode,
		PriceType.PrceTpeNme,
		#DistinctPrices.TransferPriceType CurveType,
		#DistinctPrices.Price FullPrice,
		#DistinctPrices.Price * #DealDetailProvisionRows.Percentage * .01 FactoredPrice,
		#DistinctPrices.AllInPrice,
		#ProvisionRuleProdLocs.ProvisionRuleID,
		#ProvisionRuleProdLocs.PrdctID,
		#ProvisionRuleProdLocs.LcleID,
		#DistinctPrices.RwPrceLcleID PriceCurveID,
		#DistinctPrices.PriceTypeID,
		RawPriceHeader.RPHdrID,
		RawPriceDetail.RPDtlQteFrmDte StartDate, 
		RawPriceDetail.RPDtlQteToDte EndDate,
		RawPriceDetail.RPDtlTrdeFrmDte TradePeriodFromDate, 
		RawPriceDetail.RPDtlTrdeToDte TradePeriodToDate,
		RawPriceDetail.RPDtlUOM UOMID,
		PRC.FromBAID,
		PRC.ToBAID

		
From	#ProvisionRuleProdLocs
		Inner Join	#DealDetailProvisionRows	On	#DealDetailProvisionRows.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
		Inner Join	#DistinctPrices				On	#DistinctPrices.RwPrceLcleID = #DealDetailProvisionRows.RwPrceLcleID
												And	#DistinctPrices.PriceTypeID = #DealDetailProvisionRows.PriceTypeID 
												AND #DistinctPrices.ProvisionRuleProdLocID = #DealDetailProvisionRows.ProvisionRuleProdLocID
		Inner Join	ProvisionRule				On	ProvisionRule.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
		Inner Join	Product						On	Product.PrdctID = #ProvisionRuleProdLocs.PrdctId
		left  join	GeneralConfiguration GC1	On	GC1.GnrlCnfgTblNme	=	'Product'
												and	GC1.GnrlCnfgQlfr	=	'SAPMaterialCode'
												and	GC1.GnrlCnfgHdrID	=	#ProvisionRuleProdLocs.PrdctID
		Inner Join	Locale						On	Locale.LcleID = #ProvisionRuleProdLocs.LcleID
		left  join	GeneralConfiguration GC2	On	GC2.GnrlCnfgTblNme	=	'Locale'
												and	GC2.GnrlCnfgQlfr	=	'SAPPlantCode'
												and	GC2.GnrlCnfgHdrID	=	#ProvisionRuleProdLocs.LcleID
		INNER JOIN  RawPriceDetail				ON  RawPriceDetail.Idnty = #DistinctPrices.RwPrceDtlID
		Inner Join	RawPriceLocale				On	RawPriceLocale.RwPrceLcleID = #DistinctPrices.RwPrceLcleID
		Inner Join	RawPriceHeader				On	RawPriceHeader.RPHdrID = RawPriceLocale.RPLcleRPHdrID
		Inner Join	PriceType					On	PriceType.Idnty = #DistinctPrices.PriceTypeID
		Inner Join  ProvisionRuleCondition PRC  On PRC.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
WHERE PRC.FromBAID IN (select Id from #BAIdsFrom) AND PRC.ToBAID IN (select Id from #BAIdsTo)
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_Search_SupplyToFSM_Primary.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END    
GO	  


--EXEC [MTV_Search_SupplyToFSM_Primary]

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Search_SupplyToFSM_Primary.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationDestination_NotTCN.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationDestination_NotTCN WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Tax_LocationDestination_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationDestination_NotTCN.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_NotTCN]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Tax_LocationDestination_NotTCN] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Tax_LocationDestination_NotTCN >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE  dbo.MTV_Tax_LocationDestination_NotTCN    @ac_profile char (1)= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- SP:              MTV_Tax_LocationDestination_NotTCN           Copyright 2012 SolArc
-- Arguments:       @ac_profile
-- Tables:          TaxRuleSetRule, GeneralConfiguration
-- Indexes:         None
-- Stored Procs:    None
-- Dynamic Tables:  #Temp_TaxData
-- Overview:        Used for tax rule: Location Origin IS NOT TCN, fails rule if Location Origin has TCN attribute
--
-- Created by:      rlb
-- History:         2017/09/27
-- Modified     Modified By     Modification
-- -----------  --------------  -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_sql         varchar (8000)
      , @i_RuleID       int

Select @i_RuleID = (Select TxRleID from TaxRule Where Description = 'Location Destination IS NOT TCN')

Select @vc_sql = '
    Update  #Temp_TaxData
    Set     TaxOriginLcleID = MH.MvtHdrOrgnLcleID
		  , TaxDestinationLcleID = MH.MvtHdrDstntnLcleID
	From	TransactionHeader TH
	Join	MovementHeader MH
			On  TH.XHdrMvtDtlMvtHdrID = MH.MvtHdrID   
	Where   TH.XHdrID = #Temp_TaxData. SourceID
'
Exec (@vc_sql)


-- right now only check ExternalBa, but I think that supplydemand should affect whether we check internal or external ba
If @ac_profile = 'N'
  Begin
    Select @vc_sql = '
        Delete  #Temp_TaxData
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        and     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        and     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxDestinationLcleID )
    '
  End 
Else
  Begin
    Select @vc_sql = '
        Update  #Temp_TaxData
        Set     DWExpression = """0"""
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        And     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        And     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxDestinationLcleID )
    '
  End

Exec (@vc_sql)    

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_NotTCN]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Tax_LocationDestination_NotTCN.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Tax_LocationDestination_NotTCN >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Tax_LocationDestination_NotTCN >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationDestination_NotTCN.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationDestination_TCN.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationDestination_TCN WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Tax_LocationDestination_TCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationDestination_TCN.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_TCN]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Tax_LocationDestination_TCN] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Tax_LocationDestination_TCN >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE  dbo.MTV_Tax_LocationDestination_TCN    @ac_profile char (1)= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- SP:              MTV_Tax_LocationDestination_TCN           Copyright 2012 SolArc
-- Arguments:       @ac_profile
-- Tables:          TaxRuleSetRule, GeneralConfiguration
-- Indexes:         None
-- Stored Procs:    None
-- Dynamic Tables:  #Temp_TaxData
-- Overview:        Used for tax rule: Location Origin IS NOT TCN, fails rule if Location Origin has TCN attribute
--
-- Created by:      rlb
-- History:         2017/09/27
-- Modified     Modified By     Modification
-- -----------  --------------  -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_sql         varchar (8000)
      , @i_RuleID       int

Select @i_RuleID = (Select TxRleID from TaxRule Where Description = 'Location Destination IS TCN')

Select @vc_sql = '
    Update  #Temp_TaxData
    Set     TaxOriginLcleID = MH.MvtHdrOrgnLcleID
		  , TaxDestinationLcleID = MH.MvtHdrDstntnLcleID
	From	TransactionHeader TH
	Join	MovementHeader MH
			On  TH.XHdrMvtDtlMvtHdrID = MH.MvtHdrID   
	Where   TH.XHdrID = #Temp_TaxData. SourceID
'
Exec (@vc_sql)


-- right now only check ExternalBa, but I think that supplydemand should affect whether we check internal or external ba
If @ac_profile = 'N'
  Begin
    Select @vc_sql = '
        Delete  #Temp_TaxData
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     NOT EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        and     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        and     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxDestinationLcleID )
    '
  End 
Else
  Begin
    Select @vc_sql = '
        Update  #Temp_TaxData
        Set     DWExpression = """0"""
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     NOT EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        And     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        And     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxDestinationLcleID )
    '
  End

Exec (@vc_sql)    

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_TCN]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Tax_LocationDestination_TCN.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Tax_LocationDestination_TCN >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Tax_LocationDestination_TCN >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationDestination_TCN.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationOrigin_NotTCN.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_NotTCN WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Tax_LocationOrigin_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_NotTCN.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Tax_LocationOrigin_NotTCN] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE dbo.MTV_Tax_LocationOrigin_NotTCN    @ac_profile char (1)= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- SP:              MTV_Tax_LocationOrigin_NotTCN           Copyright 2012 SolArc
-- Arguments:       @ac_profile
-- Tables:          TaxRuleSetRule, GeneralConfiguration
-- Indexes:         None
-- Stored Procs:    None
-- Dynamic Tables:  #Temp_TaxData
-- Overview:        Used for tax rule: Location Origin IS NOT TCN, fails rule if Location Origin has TCN attribute
--
-- Created by:      rlb
-- History:         2017/09/27
-- Modified     Modified By     Modification
-- -----------  --------------  -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_sql         varchar (8000)
      , @i_RuleID       int

Select @i_RuleID = (Select TxRleID from TaxRule Where Description = 'Location Origin IS NOT TCN')

Select @vc_sql = '
    Update  #Temp_TaxData
    Set     TaxOriginLcleID = MH.MvtHdrOrgnLcleID
		  , TaxDestinationLcleID = MH.MvtHdrDstntnLcleID
	From	TransactionHeader TH
	Join	MovementHeader MH
			On  TH.XHdrMvtDtlMvtHdrID = MH.MvtHdrID   
	Where   TH.XHdrID = #Temp_TaxData. SourceID
'
Exec (@vc_sql)


-- right now only check ExternalBa, but I think that supplydemand should affect whether we check internal or external ba
If @ac_profile = 'N'
  Begin
    Select @vc_sql = '
        Delete  #Temp_TaxData
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        and     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        and     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End 
Else
  Begin
    Select @vc_sql = '
        Update  #Temp_TaxData
        Set     DWExpression = """0"""
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        And     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        And     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End

Exec (@vc_sql)    

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Tax_LocationOrigin_NotTCN.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationOrigin_NotTCN.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationOrigin_TCN.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_TCN WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Tax_LocationOrigin_TCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_TCN.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_TCN]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Tax_LocationOrigin_TCN] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Tax_LocationOrigin_TCN >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE dbo.MTV_Tax_LocationOrigin_TCN    @ac_profile char (1)= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- SP:              MTV_Tax_LocationOrigin_TCN           Copyright 2012 SolArc
-- Arguments:       @ac_profile
-- Tables:          TaxRuleSetRule, GeneralConfiguration
-- Indexes:         None
-- Stored Procs:    None
-- Dynamic Tables:  #Temp_TaxData
-- Overview:        Used for tax rule: Location Origin IS NOT TCN, fails rule if Location Origin has TCN attribute
--
-- Created by:      rlb
-- History:         2017/09/27
-- Modified     Modified By     Modification
-- -----------  --------------  -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_sql         varchar (8000)
      , @i_RuleID       int

Select @i_RuleID = (Select TxRleID from TaxRule Where Description = 'Location Origin IS TCN')

Select @vc_sql = '
    Update  #Temp_TaxData
    Set     TaxOriginLcleID = MH.MvtHdrOrgnLcleID
		  , TaxDestinationLcleID = MH.MvtHdrDstntnLcleID
	From	TransactionHeader TH
	Join	MovementHeader MH
			On  TH.XHdrMvtDtlMvtHdrID = MH.MvtHdrID   
	Where   TH.XHdrID = #Temp_TaxData. SourceID
'
Exec (@vc_sql)


-- right now only check ExternalBa, but I think that supplydemand should affect whether we check internal or external ba
If @ac_profile = 'N'
  Begin
    Select @vc_sql = '
        Delete  #Temp_TaxData
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     NOT EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        and     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        and     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End 
Else
  Begin
    Select @vc_sql = '
        Update  #Temp_TaxData
        Set     DWExpression = """0"""
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     NOT EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        And     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        And     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End

Exec (@vc_sql)    

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_TCN]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Tax_LocationOrigin_TCN.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Tax_LocationOrigin_TCN >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Tax_LocationOrigin_TCN >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\sp_MTV_Tax_LocationOrigin_TCN.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\StoredProcedures\tI_MTVTMSMovementStaging.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT OBJECT_ID('tI_MTVTMSMovementStaging'))
	DROP TRIGGER tI_MTVTMSMovementStaging

/****** Object:  Trigger [dbo].[tI_MTVMovementLifeCycle]    Script Date: 4/14/2017 11:00:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE TRIGGER [dbo].[tI_MTVTMSMovementStaging] ON [dbo].[MTVTMSMovementStaging] FOR INSERT AS
BEGIN
-----------------------------------------------------------------------------------------------------
-- Copyright OpenLink Financial LLC 2013
--
-- Disabling, Deleting, or Modifying any portion of the following 
-- code without the expressed written consent of OpenLink Financial LLC is strictly
-- prohibited, such acts are in violation of the Client Support Contract.
--
-----------------------------------------------------------------------------------------------------
INSERT MTVMovementLifeCycle (MESID,MovementProcessComplete,BOLNumber,TMSLoadStartDateTime,TMSSoldTo,TMSProdID,TMSTerminal,TMSIntefaceStatus,TMSInterfaceImportDate)
SELECT MESID,0,doc_no,load_start_date,cust_no,prod_id,term_id,TicketStatus,ImportDate FROM inserted

END
GO


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\StoredProcedures\tI_MTVTMSMovementStaging.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\Defect_8183_MakeVrblesAvailabeInPB.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightCleaning' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightCleaning' AND VrbleDtTyp = 'N' AND Type = 'S')


Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightMisc' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightMisc' AND VrbleDtTyp = 'N' AND Type = 'S')

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\Defect_8183_MakeVrblesAvailabeInPB.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\oo_Create_RiskDataUser.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
CREATE LOGIN RiskDataUser WITH PASSWORD = 'Risktadpole1';
GO 

CREATE USER RiskDataUser FOR LOGIN RiskDataUser
GO

EXEC sp_addrolemember 'db_datareader', 'RiskDataUser'; 
GO

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\oo_Create_RiskDataUser.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\sd_8235_Enable_GLStaging_Audit.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
declare @vc_scriptname varchar(100) = 'sd_8235_Enable_GLStaging_Audit'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end

insert EntityAuditType (AuditEnabled, Name, ServiceName, PrimaryTable, DescriptionColumn)
select 1, 'SAP GL Staging', 'MTVSAPGLStagingService', 'MTVSAPGLStaging', 'DocumentHeaderText'

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\sd_8235_Enable_GLStaging_Audit.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\sd_8271_MTV_Invoice_PrevalidationSetup.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*Author:	Chris Nettles
Date:		9/8/2017
Purpose:	This script will create a new PB process item that is to be used with the 
			invoice from queue process.  
*/

declare @i_Key				int
declare @i_processGroupID	int
declare @vc_processName		varchar(50) = 'MTV Invoice Prevalidation'

--Create new PB Process Item
if not exists
(
	select	1 
	from	ProcessItem
	where	ProcessItem.PrcssItmNme	=	@vc_processName
)
begin
	exec sp_getkey 'ProcessItem', @i_Key out

	insert ProcessItem
	(
		PrcssItmID
		,PrcssItmNme
		,PrcssItmDscrptn
		,PrcssItmCmmndLne
		,PrcssItmCmmndTpe
		,PrcssItmPrmtrDscrptn
		,PrcssItmStts
	)
	select	@i_Key
			,@vc_processName
			,'Sets thresholds for results of various reports to prevent invoicing jobs from running if limit breached. Run type should either be InvoiceQueue or InvoicePrint'
			,'MTV_InvoicePrevalidation'
			,'S'
			,'Run type, Tax Limit, Sat Limit, Move Xtr Limit, Inv Debug Limit.  Example: ''InvoiceQueue'', 100, 200, 300, 400'
			,'A'
end

--Create new process group that process item will be associated with
if not exists
(
	select	1 
	from	ProcessGroup
	where	ProcessGroup.PrcssGrpNme	=	@vc_processName
)
begin
	exec sp_getkey 'ProcessGroup', @i_Key out

	insert	ProcessGroup
	(
		PrcssGrpID
		,PrcssGrpNme
		,PrcssGrpDscrptn
		,PrcssGrpSnglePrcss
		,PrcssGrpStts
		,TotalSeconds
		,RunCount
		,CanRunAsService
	)
	select	@i_Key
			,@vc_processName
			,'Sets thresholds for results of various reports to prevent invoicing jobs from running if over. Will go back 24 hours from time task is run.  Reference technical documentation for additional params.'
			,'Y'
			,'A'
			,0
			,0
			,'Y'
end

--Associate the process item with the process group
if not exists
(
	select	1
	from	ProcessGroupRelation PGR
		inner join ProcessGroup PG	on		PG.PrcssGrpNme	=	@vc_processName 
		inner join ProcessItem PRI	on		PRI.PrcssItmNme =	@vc_processName
	where	PGR.PrcssGrpRltnPrcssGrpID	=	PG.PrcssGrpID
		and	PGR.PrcssGrpRltnPrcssItmID	=	PRI.PrcssItmID
)
begin
	exec sp_getkey 'ProcessGroupRelation', @i_Key out

	insert ProcessGroupRelation
	(
		PrcssGrpRltnID
		,PrcssGrpRltnOrdr
		,PrcssGrpRltnPrcssGrpID
		,PrcssGrpRltnPrcssItmID
	)
	select	@i_Key
			,1
			,(select PrcssGrpID		from ProcessGroup	where PrcssGrpNme	=	@vc_processName)
			,(select PrcssItmID		from ProcessItem	where PrcssItmNme	=	@vc_processName)

end	

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\sd_8271_MTV_Invoice_PrevalidationSetup.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\sd_Custom_TCN_TaxRule.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--
--  This section will insert the necessary record to register the tax rule in the RightAngle application
--
------------------------------------------------------------------------------------------------------------------------------

If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Origin IS NOT TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Origin IS NOT TCN '
          , 'Text=This rule set validates that the Origin location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_NotTCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Origin location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_NotTCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS NOT TCN'
  End


GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Origin IS TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Origin IS TCN '
          , 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_TCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_TCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS TCN'
  End

GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Destination IS NOT TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Destination IS NOT TCN '
          , 'Text=This rule set validates that the Destination location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_NotTCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Destination location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_NotTCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Destination IS NOT TCN'
  End


GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Destination IS TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Destination IS TCN '
          , 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_TCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Destination location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_TCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS TCN'
  End


GO
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\sd_Custom_TCN_TaxRule.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_Prod_20171020_173538\SeedScripts\sd_InsertColumnSelectJoinForV_MTV_AccountDetailSoldToShipTo.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

Declare @accountDetailTableId int, @vAcctDtlStStID int, @CustomAccountDetailAttributeTableId int  

set @accountDetailTableId = (select Idnty from ColumnSelectionTable where TableName = 'AccountDetail')


if not exists(select '' from ColumnSelectionTable c where c.TableName = 'v_MTV_AccountDetailShipToSoldTo')
insert into ColumnSelectionTable (
TableName
,TableAbbreviation
,TableDescription
,EnttyID
,Datawindow
,SecurityColumns)
values
('v_MTV_AccountDetailShipToSoldTo','VAST','AccountDetailSoldToShipToView',null,'',null)

--Get the Idnty for each of the new rows
set @vAcctDtlStStID = (select Idnty from ColumnSelectionTable where TableName = 'v_MTV_AccountDetailShipToSoldTo')

--insert join syntax
if not exists(select '' from ColumnSelectionTableJoin cstj where cstj.FromClmnSlctnTbleIdnty = @vAcctDtlStStID and cstj.ToClmnSlctnTbleIdnty = @accountDetailTableId)
insert into ColumnSelectionTableJoin (
FromClmnSlctnTbleIdnty
,ToClmnSlctnTbleIdnty
,JoinType
,LeftOuterJoin
,RelationshipPrefix
,JoinSyntax
,Bidirectional)
values
(@vAcctDtlStStID,@accountDetailTableId,'ManyToOne','Y','','[v_MTV_AccountDetailShipToSoldTo].AcctDtlID = [AccountDetail].AcctDtlID','Y')
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_Prod_20171020_173538\SeedScripts\sd_InsertColumnSelectJoinForV_MTV_AccountDetailSoldToShipTo.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Ending Of Script
------------------------------------------------------------------------------------------------------------------

