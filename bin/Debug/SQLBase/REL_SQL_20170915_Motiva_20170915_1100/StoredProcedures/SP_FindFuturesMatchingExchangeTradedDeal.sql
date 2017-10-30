if exists (select * from sysobjects where name = 'SCS_SP_FindFuturesMatchingExchangeTradedDeal')
	exec('drop procedure dbo.SCS_SP_FindFuturesMatchingExchangeTradedDeal')
Go

Create Procedure dbo.SCS_SP_FindFuturesMatchingExchangeTradedDeal (
	@TraderUserId			int
	,@TradeDateFromDate		smalldatetime
	,@TradeDateToDate		smalldatetime
	,@TradePeriodFromDate	smalldatetime
	,@TradePeriodToDate		smalldatetime
	,@BuySell				char
	,@ProductId				int
	,@OrderId				varchar(20)
	,@price                 float
	)
As

select	DlHdrID
From	DealHeader DH (NoLock)
Where	DH.DlHdrTyp = 70
and		DH.DlHdrStat = 'A'
and		DH.DlHdrDsplyDte >= @TradeDateFromDate 
and		DH.DlHdrDsplyDte < @TradeDateToDate
and		DH.DlHdrFrmDte = @TradePeriodFromDate
and		DH.DlHdrToDte = @TradePeriodToDate
and		DH.DlHdrIntrnlUserID = @TraderUserId
and		exists 
		(select * 
		from	DealDetail DD (NoLock)
		Inner Join DealDetailStrategy DDS (NoLock) on (DDS.DlHdrID = DD.DlDtlDlHdrID and DDS.DlDtlID = DD.DlDtlID)
		where	DD.DlDtlDlHdrID = DH.DlHdrID
		and		DD.DlDtlSpplyDmnd = @BuySell
		and		DD.TradingPrdctID = @ProductId
		and		DDS.StrtgyID = DDS.StrtgyID
		and exists 
			(select *
			from SCS_V_FuturesFillPrice FFP (NoLock)
			where	FFP.DlHdrID = DD.DlDtlDlHdrID
			and		FFP.DlDtlID = DD.DlDtlID)
			
			and 1=case when @price is null then 1 else (select 1 from SCS_V_FuturesFillPrice FFP (NoLock)
			where	FFP.DlHdrID = DD.DlDtlDlHdrID
			and		FFP.DlDtlID = DD.DlDtlID 
			and     FFP.FillPrice=@price) end
			)
and		exists
		(select *
		from	SCS_ExchangeTradedDealOrder ETDO (NoLock)
		Inner Join ExchangeTradedDeal ETD (NoLock) on (ETD.ExchangeTradedDealID = ETDO.ExchangeTradedDealID)
		where	ETDO.OrderID = @OrderId
		and		ETD.DlHdrID = DH.DlHdrID)
Go

Grant execute on SCS_SP_FindFuturesMatchingExchangeTradedDeal to RightAngleAccess
Go