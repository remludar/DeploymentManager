-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomConfigAccounting      Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     29/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomConfigAccounting') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomConfigAccounting
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomConfigAccounting') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomConfigAccounting
						(ID									int				Identity
						,ConfigurationName					varchar(50)		Null
						,InterfaceDefaultUOMID				smallint		Null
						,InterfaceDefaultUOM				varchar(80)		Null
						,InterfaceDefaultPerUnitDecimals	int				Null
						,InterfaceDefaultQtyDecimals		int				Null
						,InterfaceARFileLocation			varchar(80)		Null
						,InterfaceAPFileLocation			varchar(80)		Null
						,InterfaceGLFileLocation			varchar(80)		Null
						,GenerateFileWithErrors				char(1)			Null)  On 'Default'				

		Execute SRA_Index_Check		@s_table 		= 'CustomConfigAccounting', 
									@s_index		= 'PK_CustomConfigAccounting',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
																													

	End
GO
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomConfigAccounting') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomConfigAccounting To RightAngleAccess
		Grant Insert On dbo.CustomConfigAccounting To RightAngleAccess
		Grant Update On dbo.CustomConfigAccounting To RightAngleAccess
		Grant Delete On dbo.CustomConfigAccounting To RightAngleAccess
	END
Go	

Insert	CustomConfigAccounting
		(ConfigurationName)
Select	'Default'

Go

Update	CustomConfigAccounting
Set		InterfaceDefaultUOMID				= 2	
		,InterfaceDefaultUOM				= 'BBL'	
		,InterfaceDefaultPerUnitDecimals	= 2	
		,InterfaceDefaultQtyDecimals		= 3
		,InterfaceARFileLocation			= 'C:\Program Files (x86)\OpenLink\RightAngle.NET\14.0\Server\ConfigurationData\'
		,InterfaceAPFileLocation			= 'C:\Program Files (x86)\OpenLink\RightAngle.NET\14.0\Server\ConfigurationData\'
		,InterfaceGLFileLocation			= 'C:\Program Files (x86)\OpenLink\RightAngle.NET\14.0\Server\ConfigurationData\'
		,GenerateFileWithErrors				= 'N'	