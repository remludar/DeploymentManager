-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomAccountDetailAttribute       Copyright 2003 SolArc
-- Overview:    A secondary, flat table to store customer/client-specific needs around the Custom Accounting Framework
--					This table starts out with a couple of IDs, and columns are added during implementation.
--					The columns should all be populated with the sp_Custom_Interface_AD_Mapping_ClientHook stored procedure
-- Created by:	Jeremy von Hoff
-- History:     15OCT2015 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetailAttribute') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomAccountDetailAttribute
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetailAttribute') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomAccountDetailAttribute
						(ID					int				Identity 
						,CADID				int
						)  On 'Default'
						
						
						
											
		Execute SRA_Index_Check		@s_table 		= 'CustomAccountDetailAttribute', 
									@s_index		= 'PK_CustomAccountDetailAttribute',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetailAttribute', 
									@s_index          = 'AK1_CustomAccountDetailAttribute',
									@s_keys           = 'CADID',
									@c_unique         = 'Y',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'Y',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 
																 																																								

	End

Go
	
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetailAttribute') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Grant Select, Insert, Update, Delete On dbo.CustomAccountDetailAttribute To RightAngleAccess, Sysuser
	End
Go		


