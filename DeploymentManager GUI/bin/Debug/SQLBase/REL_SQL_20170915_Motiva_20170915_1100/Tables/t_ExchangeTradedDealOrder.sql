
if exists (select * from sysobjects where name = 'SCS_ExchangeTradedDealOrder')
begin
	exec('Drop Table dbo.SCS_ExchangeTradedDealOrder')
end
Go

Create Table dbo.SCS_ExchangeTradedDealOrder
(
	 TransactionID			varchar(80)	NOT NULL
	,OrderID				varchar(20)	NOT NULL
	,ExchangeTradedDealID	int			NULL
	,FirstProcessed			datetime	NOT NULL
	,LotsAggregated			float		NULL)
GO

Create Index IF1_SCS_ExchangeTradedDealOrder on dbo.SCS_ExchangeTradedDealOrder (OrderID)
Create Index IF2_SCS_ExchangeTradedDealOrder on dbo.SCS_ExchangeTradedDealOrder (TransactionID)
Create Index IF3_SCS_ExchangeTradedDealOrder on dbo.SCS_ExchangeTradedDealOrder (FirstProcessed)
Create Index IF4_SCS_ExchangeTradedDealOrder on dbo.SCS_ExchangeTradedDealOrder (ExchangeTradedDealID)
GO

--Grant All on SCS_ExchangeTradedDealOrder to RightAngleAccess, Sysuser
Grant Select on SCS_ExchangeTradedDealOrder to RightAngleAccess, Sysuser
Grant Update on SCS_ExchangeTradedDealOrder to RightAngleAccess, Sysuser
Grant Delete on SCS_ExchangeTradedDealOrder to RightAngleAccess, Sysuser
Grant Insert on SCS_ExchangeTradedDealOrder to RightAngleAccess, Sysuser
GO	