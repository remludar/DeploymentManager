/****** Object:  StoredProcedure [dbo].[CompanyName_sp_STOREDPROCEDURENAME]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTV_StarMailStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StarMailStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_StarMailStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_StarMailStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_StarMailStage]		@c_OnlyShowSQL char(1) = 'N'
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
-- exec MTV_StarMailStage 'y'

DECLARE @vc_DynamicSQL	varchar(8000)

-- Create a temp table to hold our data
if (@c_OnlyShowSQL <> 'N')
	print '
	create table #Stage
	(
		CIIID						Int,
		CIIMssgQID					Int,
		InvoiceLevel				Char(1),
		IntBAID						Int,
		IntBACode					Varchar(11),		-- CompanyCode
		IntBAName					Varchar(80),
		ExtBAID						Int,
		ExtBACode					Varchar(11),
		ExtBAName					Varchar(80),
		ExtBAAddress1				Varchar(80),
		ExtBAAddress2				Varchar(80),
		ExtBAAddress3				Varchar(80),

		PlantCode					Varchar(5),
		DocumentNumber				Varchar(10),
		InvoiceNumber				Varchar(20),		-- Message number
		InvoiceDate					SmallDateTime,		-- Document date
		InvoiceAmount				Decimal(19,6),		-- Document amount
		InvoiceCurrency				Varchar(8),
		InvoiceComments				Varchar(80),
		DueDate						SmallDateTime,
		LineItemDesc				Varchar(80),
		GrossVol					Decimal(19,6),
		NetVol						Decimal(19,6),
		PerUnitValue				Decimal(19,6),
		TotalValue					Decimal(19,6),

		ShipFromAddress1			Varchar(80),
		ShipFromAddress2			Varchar(80),
		ShipFromAddress3			Varchar(80),
		ShipToAddress1				Varchar(80),
		ShipToAddress2				Varchar(80),
		ShipToAddress3				Varchar(80),
		ParentInvoiceNumber			Varchar(80),
		PaymentMethod				Varchar(80),
		PaymentTerms				Varchar(80),
		ProductCode					Varchar(80),
		DebitAccount				Varchar(80),
		CreditAccount				Varchar(80),
		BOLNumber					Varchar(80),
		BOLDate						SmallDateTime,
		DiscountAmount				Decimal(19,6),
		DiscountDate				SmallDateTime,

		ExtractDate					SmallDateTime		DEFAULT GetDate(),
		FileCreationDate			SmallDateTime,
		FileName					Varchar(200),
		InterfaceStatus				Char(1),
		InterfaceMessage			VarChar(500),
		ApprovalUserID				Int,
		ApprovalDate				SmallDateTime,
		SCAC						Varchar(80),
		InvoiceDesc					Varchar(80),
		Remit1						Varchar(200),
		Remit2						Varchar(200),
		Remit3						Varchar(200),
		Remit4						Varchar(200),
		Remit5						Varchar(200),
		Remit6						Varchar(200),
		Remit7						Varchar(200),
		Remit8						Varchar(200)
		)'
else
	create table #Stage
	(
		CIIID						Int,
		CIIMssgQID					Int,
		InvoiceLevel				Char(1),
		IntBAID						Int,
		IntBACode					Varchar(11),		-- CompanyCode
		IntBAName					Varchar(80),
		ExtBAID						Int,
		ExtBACode					Varchar(11),
		ExtBAName					Varchar(80),
		ExtBAAddress1				Varchar(80),
		ExtBAAddress2				Varchar(80),
		ExtBAAddress3				Varchar(80),

		PlantCode					Varchar(5),
		DocumentNumber				Varchar(10),
		InvoiceNumber				Varchar(20),		-- Message number
		InvoiceDate					SmallDateTime,		-- Document date
		InvoiceAmount				Decimal(19,6),		-- Document amount
		InvoiceCurrency				Varchar(8),
		InvoiceComments				Varchar(80),
		DueDate						SmallDateTime,
		LineItemDesc				Varchar(80),
		GrossVol					Decimal(19,6),
		NetVol						Decimal(19,6),
		PerUnitValue				Decimal(19,6),
		TotalValue					Decimal(19,6),

		ShipFromAddress1			Varchar(80),
		ShipFromAddress2			Varchar(80),
		ShipFromAddress3			Varchar(80),
		ShipToAddress1				Varchar(80),
		ShipToAddress2				Varchar(80),
		ShipToAddress3				Varchar(80),
		ParentInvoiceNumber			Varchar(80),
		PaymentMethod				Varchar(80),
		PaymentTerms				Varchar(80),
		ProductCode					Varchar(80),
		DebitAccount				Varchar(80),
		CreditAccount				Varchar(80),
		BOLNumber					Varchar(80),
		BOLDate						SmallDateTime,
		DiscountAmount				Decimal(19,6),
		DiscountDate				SmallDateTime,

		ExtractDate					SmallDateTime		DEFAULT GetDate(),
		FileCreationDate			SmallDateTime,
		FileName					Varchar(200),
		InterfaceStatus				Char(1),
		InterfaceMessage			VarChar(500),
		ApprovalUserID				Int,
		ApprovalDate				SmallDateTime,
		SCAC						Varchar(80),
		InvoiceDesc					Varchar(80),
		Remit1						Varchar(200),
		Remit2						Varchar(200),
		Remit3						Varchar(200),
		Remit4						Varchar(200),
		Remit5						Varchar(200),
		Remit6						Varchar(200),
		Remit7						Varchar(200),
		Remit8						Varchar(200)
		)


Select	@vc_DynamicSQL = '
--	Grab all records from the CustomInvoiceInterface table where the StarMailExtracted column is not 1
Insert	#Stage
		(
		CIIID
		,CIIMssgQID				--
		,InvoiceLevel
		,PlantCode
		,DocumentNumber
		,InvoiceNumber
		,InvoiceDate
		,InvoiceCurrency
		,GrossVol
		,NetVol
		,TotalValue
		,DueDate
		,LineItemDesc
		,PerUnitValue
		,PaymentMethod
		,PaymentTerms
		,ProductCode
		,BOLNumber
		,ExtractDate
		,FileCreationDate
		,ApprovalUserID
		,ApprovalDate
		,InvoiceDesc
		,ShipToAddress1
		,ShipToAddress2
		,ShipToAddress3
		,Remit1
		,Remit2
		,Remit3
		,Remit4
		,Remit5
		,Remit6
		,Remit7
		,Remit8
		)
Select	CII.ID,
		CII.MessageQueueID,
		CII.InvoiceLevel,
		CII.Plant,
		Convert(varchar, 0),														-- DocumentNumber //TODO
		CII.InvoiceNumber,															-- MessageNumber
		CII.InvoiceDate,															-- DocumentDate
		CII.InvoiceCurrency,
		
		CII.Quantity,																-- GrossVol
		CII.Quantity,																-- NetVol
		Case	When CII.InvoiceDebitValue <> 0 Then CII.InvoiceDebitValue
				When CII.InvoiceCreditValue	<> 0 Then CII.InvoiceCreditValue
				End,																-- Total Value
		
		CII.DueDate,
		Case	When CII.InvoiceLevel <> ''T''
				Then CII.ProductCode
				Else CII.TransactionType
		End,
		CII.PerUnitPrice,
		TermType.DynLstBxAbbv,
		Term.TrmVrbge,																	-- PaymentTerms
		CII.ProductCode,
		CII.BL,																			-- BOLNumber
		GetDate(),																		-- ExtractDate
		NULL,																			-- FileCreationDate
		NULL,																			-- ApprovalUserID
		NULL,																			-- ApprovalDate
		SIT.SlsInvceTpeDscrptn,															-- InvoiceDesc
		Substring(CII.Destination, 0, 80),
		Substring(CII.Destination, 80, 80),
		Substring(CII.Destination, 160, 80),
		SIV.SlsInvceVrbgeLne1,															-- Remit1
		SIV.SlsInvceVrbgeLne2,															-- Remit2
		SIV.SlsInvceVrbgeLne3,															-- Remit3
		SIV.SlsInvceVrbgeLne4,															-- Remit4
		SIV.SlsInvceVrbgeLne5,															-- Remit5
		SIV.SlsInvceVrbgeLne6,															-- Remit6
		SIV.SlsInvceVrbgeLne7,															-- Remit7
		SIV.SlsInvceVrbgeLne8															-- Remit8

		-- select *
From	CustomInvoiceInterface CII with (NoLock)
		Inner Join MTVInvoiceInterfaceStatus MTVIIS with (NoLock)
			on	MTVIIS.CIIMssgQID				= CII.MessageQueueID
		Left Outer Join SalesInvoiceHeader SIH with (NoLock)
			on	CII.InvoiceID					= SIH.SlsInvceHdrID
		Left Outer Join SalesInvoiceType SIT with (NoLock)
			on	SIH.SlsInvceHdrSlsInvceTpeID	= SIT.SlsInvceTpeID
		Left Outer Join SalesInvoiceVerbiage SIV with (NoLock)
			on	SIV.SlsInvceVrbgeID				= SIH.RemitSlsInvceVrbgeID
		Left Outer Join Term with (NoLock)
			on	Term.TrmID						= SIH.SlsInvceHdrTrmID
		Left Outer Join DynamicListBox TermType with (NoLock)
			on	TermType.DynLstBxTyp			= Term.TrmPymntMthd
			and	TermType.DynLstBxQlfr			= ''TermType''
Where	MTVIIS.StarMailStaged					<> convert(bit, 1)

'

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	exec(@vc_DynamicSQL)

Select	@vc_DynamicSQL = '
Update	#Stage
Set		IntBAID				= CAD.InvoiceIntBAID,
		IntBACode			= CAD.XRefIntBACode,
		IntBAName			= CAD.InvoiceIntBANme,
		ExtBAID				= CAD.InvoiceExtBAID,
		ExtBACode			= CAD.XRefExtBACode,
		ExtBAName			= CAD.InvoiceExtBANme,
		ExtBAAddress1		= AI.AddressLine1,
		ExtBAAddress2		= AI.AddressLine2,
		ExtBAAddress3		= AI.CityStateZip,
		ShipFromAddress1	= Substring(CAD.MvtHdrLocation, 0, 80),
		ShipFromAddress2	= Substring(CAD.MvtHdrLocation, 80, 80),
		ShipFromAddress3	= Substring(CAD.MvtHdrLocation, 160, 80),
		InvoiceAmount		= CAD.InvoiceAmount,
		InvoiceComments		= CAD.Comments,

		DocumentNumber		= Convert(varchar, 0),								-- DocumentNumber //TODO
		ParentInvoiceNumber	= CAD.InvoiceParentInvoiceNumber,					-- OrigInvoiceNumber,
		DebitAccount		= CAD.DebitAccount,
		CreditAccount		= CAD.CreditAccount,
		BOLDate				= CADA.MovementDate,								-- BOLDate
		DiscountAmount		= CADA.DiscountAmount,
		DiscountDate		= CADA.DiscountDueDate,
		SCAC				= SCAC_ITC.ExternalValue							-- SCAC

		-- select *
From	#Stage
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.InterfaceMessageID			= #Stage.CIIMssgQID
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID						= CAD.ID
		Left Outer Join v_AddressInformation AI
			on	AI.LcleID						= CAD.InvoiceExtBAOffceLcleID
			and	AI.CntctID						= CAD.InvoiceExtCntctID
			and	AI.BAID							= CAD.InvoiceExtBAID
			and	AI.DeliveryMethod				= ''P''
		Left Outer Join v_MTV_XrefAttributes SCAC_ITC
			on	SCAC_ITC.RATable				= ''BusinessAssociate''
			and	SCAC_ITC.Qualifier				= ''SCAC''
			and	SCAC_ITC.RAKey				= CAD.InvoiceExtBAID

'

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	exec(@vc_DynamicSQL)




Select	@vc_DynamicSQL = '
Insert	MTVStarMailStaging
		(
		CIIMssgQID,
		InvoiceLevel,
		IntBAID,
		IntBACode,
		IntBAName,
		ExtBAID,
		ExtBACode,
		ExtBAName,
		ExtBAAddress1,
		ExtBAAddress2,
		ExtBAAddress3,
		PlantCode,
		DocumentNumber,
		InvoiceNumber,
		InvoiceDate,
		InvoiceAmount,
		InvoiceCurrency,
		InvoiceComments,
		DueDate,
		LineItemDesc,
		GrossVol,
		NetVol,
		PerUnitValue,
		TotalValue,
		ShipFromAddress1,
		ShipFromAddress2,
		ShipFromAddress3,
		ShipToAddress1,
		ShipToAddress2,
		ShipToAddress3,
		ParentInvoiceNumber,
		PaymentMethod,
		PaymentTerms,
		ProductCode,
		DebitAccount,
		CreditAccount,
		BOLNumber,
		BOLDate,
		DiscountAmount,
		DiscountDate,
		ExtractDate,
		FileCreationDate,
		FileName,
		InterfaceStatus,
		InterfaceMessage,
		ApprovalUserID,
		ApprovalDate,
		SCAC,
		InvoiceDesc,
		Remit1,
		Remit2,
		Remit3,
		Remit4,
		Remit5,
		Remit6,
		Remit7,
		Remit8
		)
Select	CIIMssgQID,
		InvoiceLevel,
		IntBAID,
		IntBACode,
		IntBAName,
		ExtBAID,
		ExtBACode,
		ExtBAName,
		ExtBAAddress1,
		ExtBAAddress2,
		ExtBAAddress3,
		PlantCode,
		DocumentNumber,
		InvoiceNumber,
		InvoiceDate,
		InvoiceAmount,
		InvoiceCurrency,
		InvoiceComments,
		DueDate,
		LineItemDesc,
		GrossVol,
		NetVol,
		PerUnitValue,
		TotalValue,
		ShipFromAddress1,
		ShipFromAddress2,
		ShipFromAddress3,
		ShipToAddress1,
		ShipToAddress2,
		ShipToAddress3,
		ParentInvoiceNumber,
		PaymentMethod,
		PaymentTerms,
		ProductCode,
		DebitAccount,
		CreditAccount,
		BOLNumber,
		BOLDate,
		DiscountAmount,
		DiscountDate,
		ExtractDate,
		FileCreationDate,
		FileName,
		InterfaceStatus,
		InterfaceMessage,
		ApprovalUserID,
		ApprovalDate,
		SCAC,
		InvoiceDesc,
		Remit1,
		Remit2,
		Remit3,
		Remit4,
		Remit5,
		Remit6,
		Remit7,
		Remit8
From	#Stage'
if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	exec(@vc_DynamicSQL)




Select	@vc_DynamicSQL = '
--	Update MTVInvoiceInterfaceStatus to show that we have staged the data
Update	MTVInvoiceInterfaceStatus
Set		StarMailStaged = Convert(Bit, 1)
From	MTVInvoiceInterfaceStatus
Where	MTVInvoiceInterfaceStatus.StarMailStaged		<> convert(bit, 1)
And		Exists	(
				Select	1
				From	MTVStarMailStaging with (NoLock)
				Where	MTVStarMailStaging.CIIMssgQID		= MTVInvoiceInterfaceStatus.CIIMssgQID
				)

'

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	exec(@vc_DynamicSQL)


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_StarMailStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_StarMailStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_StarMailStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_StarMailStage >>>'
	  END