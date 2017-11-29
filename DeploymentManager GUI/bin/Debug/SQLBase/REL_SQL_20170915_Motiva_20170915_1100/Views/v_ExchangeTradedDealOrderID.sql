
If exists (select * from sysobjects where name = 'SCS_v_ExchangeTradedDealOrderID')
	exec('Drop View dbo.SCS_v_ExchangeTradedDealOrderID')
GO

Create View dbo.SCS_v_ExchangeTradedDealOrderID
As
select
	 ExchangeTradedDealID	as [ExchangeTradedDealId]
	,DlHdrID				as [DealHeaderId]
	,(Select case	when CHARINDEX('CLORDID="',message) > 0 
					then SUBSTRING(message, CHARINDEX('CLORDID="',message)+ 9,   CHARINDEX('Side=',message) - CHARINDEX('CLORDID="',message) - 11) 
					else null end) 
							as [OrderId]
from ExchangeTradedDeal
where	LEFT(message,11) = '<TrdCaptRpt'
and		CHARINDEX('CLORDID="',message) > 0
Union
select
	 ExchangeTradedDealID	as [ExchangeTradedDealId]
	,DlHdrID				as [DealHeaderId]
	,(Select case	when Left(message,5) = '8=FIX'
					then substring(message,CHARINDEX('11=',message) + 4,CHARINDEX('',message,CHARINDEX('11=',message) + 1) - CHARINDEX('11=',message) - 4)
					else null end) 
							as [OrderId]
from ExchangeTradedDeal
where 
	Left(message,5) = '8=FIX'
union
select
	 ExchangeTradedDealID	as [ExchangeTradedDealId]
	,DlHdrID				as [DealHeaderId]
	,(Select case	when CHARINDEX('CLORDID="',message) > 0 
					then SUBSTRING(message, CHARINDEX('CLORDID="',message)+ 9,   CHARINDEX('Side=',message) - CHARINDEX('CLORDID="',message) - 11) 
					else null end) 
							as [OrderId]
from ExchangeTradedDealAudit
where	LEFT(message,11) = '<TrdCaptRpt'
and		CHARINDEX('CLORDID="',message) > 0
union
select
	 ExchangeTradedDealID	as [ExchangeTradedDealId]
	,DlHdrID				as [DealHeaderId]
	,(Select case	when Left(message,5) = '8=FIX'
					then substring(message,CHARINDEX('11=',message) + 4,CHARINDEX('',message,CHARINDEX('11=',message) + 1) - CHARINDEX('11=',message) - 4)
					else null end) 
							as [OrderId]
from ExchangeTradedDealAudit
where 
	Left(message,5) = '8=FIX'
GO

Grant Select on dbo.SCS_v_ExchangeTradedDealOrderID to RightAngleAccess
GO


Insert Into SCS_ExchangeTradedDealOrder (TransactionID, OrderID, ExchangeTradedDealID, FirstProcessed, LotsAggregated)
select 
	 TransactionID
	,OrderID
	,ETD.ExchangeTradedDealID
	,GETDATE()
	,NULL
from ExchangeTradedDeal ETD
Inner Join SCS_v_ExchangeTradedDealOrderID ETDO on (ETDO.ExchangeTradedDealId = ETD.ExchangeTradedDealID)
GO