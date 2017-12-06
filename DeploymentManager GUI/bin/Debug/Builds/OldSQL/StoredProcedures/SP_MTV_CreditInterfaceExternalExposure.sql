/****** Object:  StoredProcedure [dbo].[MTVCreditInterfaceExternalExposure]    Script Date: 1/26/2017 12:28:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================================
-- Author:		Craig Albright	
-- Create date: 05/20/2016
-- Description:	This is to get the incremental exposure for the credit interface
-- =======================================================================================================================================
-- 2/6/2017   Joseph McClean		Revised portions of sql to improve readability , accuracy and speed. see comments below.
-- =======================================================================================================================================
Alter PROCEDURE [dbo].[MTVCreditInterfaceExternalExposure] With Execute as 'dbo'

	-- Add the parameters for the stored procedure here
AS
BEGIN

	Declare 
	@FromDate DateTime  = (select MAX(RunDatetime) from MTVCreditExposureInterfaceStats WHERE Success = 1), --<--- Get the date and time of the last successful run. this would typically be the B
	@ToDate DateTime = (select MAX(RunDatetime) from MTVCreditExposureInterfaceStats),
	@Portfolio int = 1,
    @successrunsforday int,
	@currentdate date

	select @currentDate = CONVERT(date, @FromDate)
	select @successrunsforday = count(*) from MTVCreditExposureInterfaceStats MCEIS where MCEIS.Success = 1 and Convert(date, MCEIS.RunDateTime) = @currentDate and RunType = 'I'

	if @successrunsforday = 0 
	begin
	  select @FromDate =  max(SnapshotInstanceDateTime) from MTVCreditInterfaceStaging 
	end
	
	IF OBJECT_ID('dbo.MOTSoldToLookup') IS NOT NULL
	BEGIN 	TRUNCATE TABLE MOTSoldToLookup		END

	IF OBJECT_ID('dbo.MOTContractPrices') IS NOT NULL
	BEGIN TRUNCATE TABLE MOTContractPrices	END

	IF OBJECT_ID('dbo.MOTRackPrices') IS NOT NULL
	BEGIN 	TRUNCATE TABLE MOTRackPrices END

	IF OBJECT_ID('dbo.MOTSoldToLookup') IS NULL
	BEGIN
	 CREATE TABLE [dbo].[MOTSoldToLookup]
	(
			[SoldTo] [varchar](80) NULL,
			[ClassOfTrade] [varchar](40) NOT NULL,
			[BAID] [int] NOT NULL
	) 
	END
	INSERT INTO [dbo].[MOTSoldToLookup]
	SELECT DISTINCT SoldTo, ClassOfTrade, BAID FROM MTVSAPBASoldTo mbst 
	

	IF OBJECT_ID('dbo.MOTMovementHeaderSoldToLookup') IS NULL
	BEGIN
	 CREATE TABLE [dbo].[MOTMovementHeaderSoldToLookup]
	(
			[MvtHdrID] [int] NOT NULL,
			[locale] [varchar](20) NOT NULL,
			[product][varchar](20) NOT NULL,
			[DlHdrID] [int]  NULL,
			[MvtHdrLftngNmbr] [varchar](20) NULL,
			SAPMvtSoldTo [varchar](255) NULL,
			MvtDcmntBAID int NOT NULL ,
			MvtDcmntDte smalldatetime NOT NULL,
			MvtDcmntExtrnlDcmntNbr varchar(80) NOT NULL
	) 
	END

	INSERT INTO [dbo].[MOTMovementHeaderSoldToLookup]
	SELECT 
    			mh.MvtHdrID, 
				LcleAbbrvtn,
				PrdctAbbv,
				mh.DlHdrID,
				mh.MvtHdrLftngNmbr, 
				gcmvthdr.GnrlCnfgMulti as SAPMvtSoldTo, 
				md.MvtDcmntBAID, 
				md.MvtDcmntDte, 
				MvtDcmntExtrnlDcmntNbr 
	FROM		MovementHeader mh 
				inner join MovementDocument md on mh.MvtHdrMvtDcmntID = md.MvtDcmntID --- JACM: Fixed erroneous join. 
				inner join GeneralConfiguration gcmvthdr on gcmvthdr.GnrlCnfgHdrID = mh.MvtHdrID 
				and GnrlCnfgQlfr = 'SAPMvtSoldToNumber' 
				and GnrlCnfgTblNme = 'MovementHeader'
				inner join Locale on Locale.LcleID = mh.MvtHdrDstntnLcleID
				inner join Product on Product.PrdctID = mh.MvtHdrPrdctID
	WHERE		mh.MvtHdrDte > (SELECT MAX(RunDateTime) FROM MTVCreditExposureInterfaceStats WHERE Success = 1)



	IF OBJECT_ID('dbo.MOTContractPrices') IS NULL
	BEGIN
	 CREATE TABLE [dbo].[MOTContractPrices]
	(
				  [CurveName]				[varchar](500)	NOT NULL,
				  RPVle						float			NOT NULL,
				  [RPLcleLcleID]			[int]			NOT NULL,
				  RPLcleChmclParPrdctID		INT				NOT NULL
	) 
	END

	INSERT INTO [dbo].[MOTContractPrices]
	SELECT 
			rpl.CurveName, 
			rp.RPVle, 
			rpl.RPLcleLcleID,
			rpl.RPLcleChmclParPrdctID 
	FROM	RawPriceLocale rpl 
			join RawPriceHeader r on rpl.RPLcleRPHdrID = r.RPHdrID
			join RawPriceDetail rpd on rpd.RPDtlRPLcleRPHdrID = rpl.RPLcleRPHdrID join RawPrice rp on rp.Idnty = rpd.Idnty
			join GeneralConfiguration gc on r.RPHdrID = gc.GnrlCnfgHdrID
	WHERE   gc.GnrlCnfgMulti = 'YP06' 
			and gc.GnrlCnfgTblNme = 'RawPriceHeader' 
			and r.RPHdrStts = 'A' 
			and r.RPHdrTpe = 'T'
			and DateAdd(day,-1, @FromDate) between rpd.RPDtlQteFrmDte and rpd.RPDtlQteToDte


	IF OBJECT_ID('dbo.MOTRackPrices') IS NULL
	BEGIN
	CREATE TABLE [dbo].[MOTRackPrices]
	(				   
				[RPVle]					float			NOT NULL,
				[CurveName]				[varchar](500)	NOT NULL,
				[RPLcleLcleID]			[int]			NOT NULL,
				RPLcleChmclParPrdctID	int				NOT NULL,
				QuoteFromDate			smalldatetime   NULL,
				QuoteToDate				smalldatetime	NULL
	)
	END

	INSERT INTO [dbo].[MOTRackPrices]
	SELECT	Distinct	rp.RPVle, 
				rpl.CurveName, 
				rpl.RPLcleLcleID, 
				rpl.RPLcleChmclParPrdctID,
				rpd.RPDtlQteFrmDte QuoteFromDate,
				rpd.RPDtlQteToDte  QuoteToDate 
	FROM		RawPriceLocale rpl 
				join RawPriceHeader r on rpl.RPLcleRPHdrID = r.RPHdrID
				join RawPriceDetail rpd on rpd.RPDtlRPLcleRPHdrID = rpl.RPLcleRPHdrID 
				join RawPrice rp on rp.Idnty = rpd.Idnty
				join GeneralConfiguration gc on r.RPHdrID = gc.GnrlCnfgHdrID
	WHERE		gc.GnrlCnfgMulti = 'YP02' 
				and gc.GnrlCnfgTblNme = 'RawPriceHeader' 
				and r.RPHdrStts = 'A' 
				and r.RPHdrTpe = 'T'
				and DateAdd(day,-1,@FromDate) between rpd.RPDtlQteFrmDte and rpd.RPDtlQteToDte
				--Group By rpl.CurveName,rpl.RPLcleLcleID,rpl.RPLcleChmclParPrdctID,rp.RPVle,rpd.RPDtlQteFrmDte, rpd.RPDtlQteToDte

         --Note: negative values in the riskid column indicate the acctdtlid is being stored for lookup reasons. the negative differentiates it from the risk ids generated from the basline run.
		insert into MTVCreditInterfaceStaging
		(
				 AccountingPeriodStartDate
				,Agreement
				,AttachedInHouse
				,BaseUOM
				,ChargeType
				,CommDeal
				--,CurveName
				,CustomStatus
				,DealCurrency
				,DeliveryPeriod
				,DeliveryPeriodEndDate
				,DeliveryPeriodStartDate
				,Description 
				,DealDetailId
				,DlvyProductA
				,ExternalBAID
				,Ele
				,Energy
				,EstPmtDate
				,Ile
				,InitialDealVolume
				,InitSysPrice
				,InitSysVolume
				,InvoiceNumber
				,LocaleID
				,MarketValue
				,Portfolio
				,PricingSeq
				,Product
				,PriceProductA
				,SalesInvoiceNumber
				,SoldTo
				,SourceSystem
				,Trader
				,TradeType
				,TransDate
				,userid
				,VolumeUOM
				,ExposureType
				,EstimatedMovementDate
				,AggregationGroupName
				,AgreementType
				,BestAvailableQuantity
				,BuySell
				,ClassOfTrade
				,CloseOfBusiness
				,ConversionCrrncyID
				,CreationDate
				,CurFxRate
				,DealHeaderId
				,DealNotionalValue
				,DealValueFXConversionDate
				,DealValueIsMissing
				,DefaultCurrency
				,DlDtlTmplteID
				,FlatPriceOrBasis
				,InternalBAID
				,MarketValueFXConversionDate
				,MarketPerUnitValue
				,MarketValueIsMissing
				,MaxPeriodStartDate
				,MethodofTransportation
				,MovementStatus
				,PaymentCurrency
				,Position
				,PriceDescription
				,PricedInPercentage
				,PricedInPerUnitValue
				,PricedPnL
				,PriceType
				,ProductID
				,RD
				,RiskID
				,RunDate
				,SettledVolumeA
				,SettledAmountA
				,SourceTable
				,TemplateName
				,TmplteSrceTpe
				,TotalPnL
				,TotalQuantity
				,TotalValueFXRate
				,TradeTag
				,MarketCurrency
				,DlDtlPrvsnID
		)

		SELECT DISTINCT 
				(select AccountingPeriod.AccntngPrdBgnDte from AccountingPeriod where AccntngPrdID = ad.AcctDtlAccntngPrdID) AccountingPeriodStartDate
				,dh.MasterAgreement as Agreement
				,'N' as AttachedInHouse
				,'gal' as BaseUom
				,(select description from DealType where DlTypID = dh.DlHdrTyp) as ChargeType
				,(select concat((PrdctAbbv), ' ',(select description from DealType where DlTypID = dh.DlHdrTyp))) as CommDeal 
				--,COALESCE((select  top 1 cp.CurveName from MOTContractPrices cp where cp.CurveName like '%Contract-'+SoldTo+'%' and cp.CurveName like '%'+p.PrdctNme+'%'),
				--		   (select  top 1 CurveName from MOTRackPrices where MOTRackPrices.RPLcleLcleID = l.LcleID and p.PrdctID = MOTRackPrices.RPLcleChmclParPrdctID and CurveName like '%'+p.PrdctNme+'%')) AS CurveName 
				--,COALESCE((select top 1 MOTContractPrices.CurveName from MOTContractPrices where MOTContractPrices.CurveName like '%'+SoldTo+'%'),
				--			(select top 1 CurveName from RawPriceLocale where RawPriceLocale.RPLcleLcleID = l.LcleID and RawPriceLocale.RPLcleChmclChdPrdctID =p.PrdctID)) AS CurveName 
				--,(select top 1 MOTContractPrices.CurveName from MOTContractPrices where MOTContractPrices.CurveName like '%'+SoldTo+'%') AS CurveName 
				,(select ptt.StatusTypeCd from plannedtransferstatustype ptt where ptt.statustypecd = ptCruiser.Status) CustomStatus
				,(select CrrncySmbl from Currency where CrrncyID = 19) as DealCurrency
				,(select Concat(CAST(Datename(MONTH, mh.MvtHdrDte) as varchar), ' ', CAST(Datepart(YEAR, mh.MvtHdrDte) as varchar) ) ) as DeliveryPeriod
				,(select SchedulingPeriod.ToDate from SchedulingPeriod where SchdlngPrdID = th.SchdlngPrdID)  DeliveryPeriodEndDate
				,(select SchedulingPeriod.FromDate from SchedulingPeriod where SchdlngPrdID = th.SchdlngPrdID)  DeliveryPeriodStartDate
				,dh.DlHdrIntrnlNbr as Description 
				,dd.DlDtlID as DealDetailId
				,(select p.PrdctNme from Product p where p.PrdctID = dd.DlDtlPrdctID) as DlvyProductA
				,dh.DlHdrExtrnlBAID as ExternalBAID
				,extba.BANme Ele
				
				,dd.Energy
				,txd.EstimatedPaymentDate as EstPmtDate
				,intba.BANme Ile
				,mh.MvtHdrQty as InitialDealVolume
				,Cast(19 AS Int) InitSysPrice
				,Cast(3 AS Int) InitSysVolume
				,ph.InvoiceNumber
				,l.LcleID as LocaleID
				,COALESCE(txd.XDtlTtlVal, ad.value) as MarketValue 
				,'Corporate Area Rollup' as Portfolio
				,1 as PricingSeq
				,p.PrdctAbbv as Product
				--,COALESCE((select  top 1 RPVle from MOTContractPrices where MOTContractPrices.CurveName like '%'+SoldTo+'%'), 
				--			(select  top 1 RPVle from MOTRackPrices where MOTRackPrices.RPLcleLcleID = l.LcleID and p.PrdctID = MOTRackPrices.RPLcleChmclParPrdctID)) as PriceProductA
				,txd.XDtlPrUntVal as PriceProductA
				,sh.SlsInvceHdrNmbr
				,(select soldto.SoldTo from GeneralConfiguration gc inner join MTVSAPBASoldTo soldto on try_convert(int, gc.GnrlCnfgMulti) = soldto.ID where gc.GnrlCnfgQlfr='SAPSoldTo' and gc.GnrlCnfgHdrID = dh.DlHdrID) as SoldTo ---Need exact SoldTo tied to deal or movement. 
				,'RightAngle' as SourceSystem
				,(select Concat(CntctFrstNme,' ',CntctLstNme) from contact where contact.CntctID =(select users.UserCntctID from Users where Users.UserID = dh.DlHdrIntrnlUserID)) as Trader
				,(select description from DealType where DlTypID = dh.DlHdrTyp) TradeType
				,dh.DlHdrCrtnDte as TransDate
				,dh.DlHdrIntrnlUserID as userid
				,(select UOMAbbv from UnitOfMeasure where UOM = dd.DlDtlDsplyUOM) as VolumeUOM
				,'I' as ExposureType   
				,mh.MvtHdrDte as EstimatedMovementDate
				,'Corporate Area Rollup' as AggregationGroupName
				,'GT&C' as AgreementType
				,mh.MvtHdrQty as BestAvailableQuantity
				,(select CASE when dd.DlDtlSpplyDmnd = 'D' THEN 'SELL' When dd.DlDtlSpplyDmnd = 'R' THEN 'BUY' END) as BuySell
				,(select top 1 dlb.DynLstBxTyp	as ClassOfTradeDesc
					from BusinessAssociate  (nolock) BA inner join MTVSAPBASoldTo (nolock) BAST on BA.BAID = BAST.BAID
					join dynamiclistbox (nolock) dlb on dlb.dynlstbxqlfr = 'BASoldToClassOfTrade' and dlb.dynlstbxtyp = BAST.ClassOfTrade
					where BAST.SoldTo = SoldTo) as ClassOfTrade
				,mh.mvthdrdte  as CloseOfBusiness
				,(select c.CrrncyID from Currency c where c.CrrncySmbl='USD') as ConversionCrrncyID
				,mh.mvthdrdte as CreationDate
				,'1' as CurFxRate
				,dh.DlHdrID as  DealHeaderId
				,txd.XDtlTtlVal as DealNotionalValue
				,mh.MvtHdrDte as DealValueFXConversionDate
				,0 as DealValueIsMissing
				,'USD' as DefaultCurrency
				,dd.DlDtlTmplteID as  DlDtlTmplteID
				,(select case when (select top 1 (rpl.IsBasisCurve) from RawPriceLocale rpl  (nolock) where rpl.CurveName In (CurveName)) = 0 then 'FlatPrice' else 'Basis' END) FlatPriceOrBasis
				,intba.BAID as InternalBAID
				,mh.MvtHdrDte as MarketValueFXConversionDate
				,(txd.XDtlTtlVal/mh.MvtHdrQty) MarketPerUnitValue
				,0 as MarketValueIsMissing
				,mh.mvthdrdte as MaxPeriodStartDate
				,mh.MvtHdrTyp as MethodofTransportation
				,(select ptt.StatusTypeCd from plannedtransferstatustype ptt where ptt.statustypecd = ptCruiser.Status) as MovementStatus
				,'USD' as PaymentCurrency
				,mh.MvtHdrQty as Position
				--,rpi.Description as PriceDescription
				,Prvsn.PrvsnDscrptn as PriceDescription
				,txd.PricedInPercentage as PricedInPercentage
				,txd.PricedInPerUnitValue as PricedInPerUnitValue
				,txd.XDtlTtlVal as PricedPnL
				,(case when (select top 1 p.PrvsnNme from prvsn p where p.prvsnid = (select top 1 (ddp.DlDtlPrvsnPrvsnID) from DealDetailProvision ddp where ddp.DlDtlPrvsnDlDtlDlHdrID = dh.dlhdrid 
					and ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID)) = 'FixedPrice' then 'Fixed' Else 'Formula' END) as PriceType
				,p.PrdctID as  ProductID
				,dd.DlDtlSpplyDmnd as RD
				,(ad.AcctDtlID * -1 ) as  RiskID --Store acctdtlid.
				,null as RunDate
				,mh.MvtHdrQty as SettledVolumeA
				--, COALESCE(txd.XDtlTtlVal, (mh.MvtHdrQty * RPVle)) as SettledAmountA
				, COALESCE(txd.XDtlTtlVal, ad.Value) as SettledAmountA
				,ad.AcctDtlSrceTble as SourceTable
				,(select description from DealHeaderTemplate dht (nolock) where dht.DlHdrTmplteID = dh.DlHdrTmplteID) as TemplateName
				--,rpi.TmplteSrceTpe as TmplteSrceTpe
				,ddp.TmplteSrceTpe as TmplteSrceTpe
				,txd.XDtlTtlVal as TotalPnL
				,txd.XDtlQntty as TotalQuantity
				,'1' as TotalValueFXRate
				,(select top 1 SH.Name from DealDetailStrategy DSH left join StrategyHeader SH on SH.StrtgyID = DSH.StrtgyID where DSH.DlHdrID = dh.DlHdrID and DSH.DlDtlID = dd.DlDtlID) as TradeTag
				,'USD' as MarketCurrency
				,ddp.DlDtlPrvsnID
		FROM	MovementHeader mh (nolock) 
				inner join MovementDetail (nolock) md on mh.MvtHdrID = md.MvtDtlMvtHdrID
				left  join MOTMovementHeaderSoldToLookup (nolock) mhstl on mhstl.MvtHdrID = mh.MvtHdrID
				inner join MovementDocument (nolock) mdoc on mdoc.MvtDcmntID = mh.MvtHdrMvtDcmntID
				inner join TransactionHeader (nolock) th on th.XHdrMvtDtlMvtHdrID = mh.MvtHdrID
				inner join DealDetail (nolock) dd on dd.DealDetailID = th.DealDetailID
				inner join DealHeader (nolock) dh on dh.dlhdrid = dd.DlDtlDlHdrID
				left  join MOTSoldToLookup (nolock) stl on stl.BAID = dh.DlHdrExtrnlBAID
				inner join Product (nolock) p on p.prdctID = dd.DlDtlPrdctID
				--left  join DealDetailProvision (nolock) ddp on ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID and ddp.DlDtlPrvsnDlDtlDlHdrID = dh.DlHdrID --And ddp.Status = 'A'
				left join TransactionDetailLog (nolock) tdl on tdl.XDtlLgXDtlXHdrID = th.XHdrID
				left join TransactionDetail txd (nolock) on txd.XDtlXHdrID = tdl.XDtlLgXDtlXHdrID and
															txd.XDtlDlDtlPrvsnID = tdl.XDtlLgXDtlDlDtlPrvsnID and
															txd.XDtlID = tdl.XDtlLgXDtlID
				left join AccountDetail ad (nolock) on ad.AcctDtlSrceID = tdl.XDtlLgID		 
			    left join DealDetailProvision (nolock) ddp on ddp.DlDtlPrvsnID = txd.XDtlDlDtlPrvsnID
				left join Prvsn (nolock) on Prvsn.PrvsnID = ddp.DlDtlPrvsnPrvsnID
				------inner join TransactionDetail (nolock) txd on txd.XDtlXHdrID = th.XHdrID
				------inner join TransactionDetailLog (nolock) tdl on tdl.XDtlLgXDtlDlDtlPrvsnID = ddp.DlDtlPrvsnID and tdl.XDtlLgXDtlXHdrID = txd.XDtlXHdrID and tdl.XDtlLgXDtlID = txd.XDtlID
				------inner join AccountDetail (nolock) ad on ad.AcctDtlID = tdl.XDtlLgAcctDtlID 
				left join TransactionType (nolock) transtyp on transtyp.TrnsctnTypID = ad.AcctDtlTrnsctnTypID
				left join AccountDetailEstimatedDate adestdt on adestdt.AcctDtlID = ad.AcctDtlID
				--left join RiskPriceIdentifier rpi on rpi.DlDtlPrvsnID = ddp.DlDtlPrvsnID
				left join PlannedTransfer (nolock) ptCruiser on  ad.AcctDtlPlnndTrnsfrID = ptCruiser.PlnndTrnsfrID 
				left join BusinessAssociate (nolock)  intba on intba.BAID = dh.DlHdrIntrnlBAID
				left join BusinessAssociate (nolock) extba on extba.BAID = dh.DlHdrExtrnlBAID
				left join locale (nolock) l on l.LcleID = dd.DlDtlLcleID
				left Join PayableHeader ph (NoLock) On AD.AcctDtlPrchseInvceHdrID = ph.PybleHdrID 
				left Join SalesInvoiceHeader sh (NoLock) On	ad.AcctDtlSlsInvceHdrID = sh.SlsInvceHdrID
				--left join RawPriceLocale (nolock) rpl on rpl.RPLcleLcleID = l.LcleID and rpl.RPLcleChmclChdPrdctID = p.PrdctID
				--left join RawPriceDetail (nolock) rpd on rpd.RwPrceLcleID = rpl.RwPrceLcleID
				--left join RawPrice (nolock) rp on rp.RPRPDtlIdnty = rpd.Idnty
		WHERE	mh.MvtHdrStat in ('A','P') and mh.MvtHdrMtchngStts in ('D','Y','N','O')
				and (mh.MvtHdrDte > @FromDate and ad.CreatedDate > @FromDate)
				and ad.AcctDtlSrceTble In ('X')  ---- movement transactions
				and txd.XDtlTtlVal > 0        
				and ptCruiser.Status <> 'I'
				and th.XHdrTyp = 'D'  -- sale side of movement transaction.

		IF OBJECT_ID('dbo.MOTSoldToLookup') IS NOT NULL
		BEGIN
			TRUNCATE TABLE MOTSoldToLookup
		END

		IF OBJECT_ID('dbo.MOTContractPrices') IS NOT NULL
		BEGIN
			TRUNCATE TABLE MOTContractPrices
		END

		IF OBJECT_ID('dbo.MOTRackPrices') IS NOT NULL
		BEGIN 
			TRUNCATE TABLE MOTRackPrices
		END
END