if exists (select * from sysobjects where name = 'SCS_ExchangeTradedDealOrder')
begin

	if Not Exists(select * from sys.columns where Name = N'ExchangeTradedDealOrderId'   
				and Object_ID = Object_ID(N'SCS_ExchangeTradedDealOrder')) 
 
	begin 
 
		Alter Table SCS_ExchangeTradedDealOrder Add ExchangeTradedDealOrderId int identity(1,1)

		Create Unique Clustered Index IX_SCS_ExchangeTradedDealOrder on SCS_ExchangeTradedDealOrder (ExchangeTradedDealOrderId)
		Create Index IF5_SCS_ExchangeTradedDealOrder on SCS_ExchangeTradedDealOrder (TransactionId, OrderId)

		print 'Column added and indexes created'
	 
	end 
	else
	begin
		print 'WARNING: The identity column ExchangeTradedDealOrder already exists.'
	end
end
else
	print 'ERROR: The table SCS_ExchangeTradedDealOrder does not exist.'

Go