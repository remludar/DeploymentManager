-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomMessageQueue         Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     28/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomMessageQueue') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomMessageQueue
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomMessageQueue') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomMessageQueue
						(ID							int				Identity
						,Entity						char(2)			Null
						,EntityID					int				Null
						,EntityID2					int				Null
						,EntityID3					varchar(50)		Null
						,EntityDescription			varchar(150)	Null
						,EntityDescription2			varchar(150)	Null
						,EntityAction				varchar(50)		Null
						,CreationDate				smalldatetime	Null
						,RAProcessed				bit				default 0
						,RAProcessedDate			smalldatetime	Null
						,Reprocess					bit				default 0
						,MessageBusProcessed		bit				default 0
						,MessageBusProcessedDate	smalldatetime	Null
						,MessageBusConfirmed		bit				Default 0
						,HasErrored					bit				default 0
						,Error						varchar(2000)	Null)  On 'Default'

		Execute SRA_Index_Check		@s_table 		= 'CustomMessageQueue', 
									@s_index		= 'PK_CustomMessageQueue',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'	

	End
Go 
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomMessageQueue') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		GRANT DELETE ON dbo.CustomMessageQueue TO RightAngleAccess
		GRANT INSERT ON dbo.CustomMessageQueue TO RightAngleAccess
		GRANT SELECT ON dbo.CustomMessageQueue TO RightAngleAccess
		GRANT UPDATE ON dbo.CustomMessageQueue TO RightAngleAccess
	END
Go	