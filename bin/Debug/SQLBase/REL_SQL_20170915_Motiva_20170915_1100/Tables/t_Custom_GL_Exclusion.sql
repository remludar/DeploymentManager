-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomGLExclusion      Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     07/05/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLExclusion') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomGLExclusion
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLExclusion') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomGLExclusion
						(ID			int	Identity
						,AcctDtlID	int)  On 'Default'				

		Execute SRA_Index_Check		@s_table 		= 'CustomGLExclusion', 
									@s_index		= 'PK_CustomGLExclusion',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table          = 'CustomGLExclusion', 
									@s_index          = 'AK1_CustomGLExclusion',
									@s_keys           = 'AcctDtlID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 									
																													

	End
GO
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLExclusion') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomGLExclusion To RightAngleAccess
		Grant Insert On dbo.CustomGLExclusion To RightAngleAccess
		Grant Update On dbo.CustomGLExclusion To RightAngleAccess
		Grant Delete On dbo.CustomGLExclusion To RightAngleAccess
	END
Go
