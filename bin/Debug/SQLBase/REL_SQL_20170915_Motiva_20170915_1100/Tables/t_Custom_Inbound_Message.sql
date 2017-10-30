-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomInboundMessage       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     28/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInboundMessage') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
	/*
		Select	*
		Into	#CustomInboundMessage
		From	CustomInboundMessage	
	*/
		Drop Table	CustomInboundMessage
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInboundMessage') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomInboundMessage
						(ID					int				Not Null
						,InterfaceFileName	varchar(80)		Null
						,StatusFlag			varchar(10)		Null		-- Status S or E
						,ErrorMessage		varchar(2000)	Null		-- Error Message
						,ARAPFlag			varchar(2)		Null		-- 
						,Assignment			varchar(50)		Null		-- Assignment Number
						,MessageDate		varchar(25)		Null		-- Message Date
						,ReturnMessage		varchar(2000)	Null
						,InterfaceStatus	char(1)			Null
						,InterfaceMessage	varchar(2000)	Null
						,MessageQueueID		int				Null
						,InterfaceInvoiceID	int				Null
						,CreationDate		smalldatetime	Null)  On 'Default'

		Execute SRA_Index_Check		@s_table 		= 'CustomInboundMessage', 
									@s_index		= 'PK_CustomInboundMessage',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table 		= 'CustomInboundMessage', 
									@s_index		= 'AK1_CustomInboundMessage',
									@s_keys			= 'MessageQueueID',
									@c_unique		= 'N',
									@c_clustered	= 'N',
									@c_primarykey	= 'N',
									@c_uniquekey	= 'N',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'	
									
		Execute SRA_Index_Check		@s_table 		= 'CustomInboundMessage', 
									@s_index		= 'AK2_CustomInboundMessage',
									@s_keys			= 'InterfaceInvoiceID',
									@c_unique		= 'N',
									@c_clustered	= 'N',
									@c_primarykey	= 'N',
									@c_uniquekey	= 'N',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'	
																				
																			

	End
GO
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInboundMessage') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomInboundMessage To RightAngleAccess
		Grant Insert On dbo.CustomInboundMessage To RightAngleAccess
		Grant Update On dbo.CustomInboundMessage To RightAngleAccess
		Grant Delete On dbo.CustomInboundMessage To RightAngleAccess
	END
Go

/*
Insert	CustomInboundMessage
		(ID					
		,InterfaceFileName
		,StatusFlag
		,ErrorMessage
		,ARAPFlag
		,Assignment
		,MessageDate
		,ReturnMessage
		,InterfaceStatus
		,InterfaceMessage
		,MessageQueueID
		,InterfaceInvoiceID
		,CreationDate) 
Select	ID					
		,InterfaceFileName
		,ColumnTwo
		,ColumnThree
		,ARAPFlag
		,ColumnFive
		,ColumnSix
		,ReturnMessage
		,InterfaceStatus
		,InterfaceMessage
		,MessageQueueID
		,InterfaceInvoiceID
		,CreationDate
From	#CustomInboundMessage


Update	KeyController
Set		KyCntrllrMxKy	= 30
Where	KyCntrllrTble	= 'CustomInboundMessage'




Select	*
From	CustomInboundMessage
*/

		