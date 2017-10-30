
exec sra_Modify_Column	 @s_table	= 'ExchangeTradedDealAudit'
			,@s_column	= 'TraderUserID'
			,@s_type	= 'int NULL'
Go
