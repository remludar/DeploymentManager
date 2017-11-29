
exec sra_Modify_Column	 @s_table	= 'ConfigIntegrationExchange'
			,@s_column	= 'SenderSubId'
			,@s_type	= 'varchar(50) NULL'
Go

exec sra_Modify_Column	 @s_table	= 'ConfigIntegrationExchange'
			,@s_column	= 'SenderCompId'
			,@s_type	= 'varchar(50) NULL'
Go
						
exec sra_Modify_Column	 @s_table	= 'ConfigIntegrationExchange'
			,@s_column	= 'Username'
			,@s_type	= 'varchar(50) NULL'
Go
			