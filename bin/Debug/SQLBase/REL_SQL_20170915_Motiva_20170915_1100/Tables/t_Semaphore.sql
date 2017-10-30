--Script: t_Semaphore.sql
--Drop table dbo.CustomSemaphore
if (Object_ID('dbo.CustomSemaphore') IS NULL)
exec('
Create Table dbo.CustomSemaphore (
	 Name					varchar(200)	NOT NULL
	,Owner					varchar(200)	NULL
	,AcquiredDate			datetime		NOT NULL Default GetDate()
	,HasLifetime			bit				NOT NULL Default 1
	,Lifetime				int				NOT NULL
	)
')
GO

exec SRA_Index_Check @s_table='dbo.CustomSemaphore'
					,@s_index='PK_CustomSemaphore'
					,@s_keys='[Name]'
					,@c_primarykey='Y'
					,@c_build_index='Y'
					,@vc_domain='SharedServices'
					,@c_unique='Y'
GO

exec SRA_Index_Check @s_table='dbo.CustomSemaphore'
					,@s_index='Idx1_CustomSemaphore'
					,@s_keys='[HasLifetime],[AcquiredDate],[Lifetime]'
					,@c_primarykey='N'
					,@c_build_index='Y'
					,@vc_domain='SharedServices'
					,@c_unique='N'
GO

