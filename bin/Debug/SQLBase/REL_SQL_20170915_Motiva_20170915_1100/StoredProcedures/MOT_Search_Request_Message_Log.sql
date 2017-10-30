/****** Object:  StoredProcedure [dbo].[MOT_Search_Request_Message_Log]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_Search_Request_Message_Log.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Search_Request_Message_Log]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MOT_Search_Request_Message_Log] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MOT_Search_Request_Message_Log >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER Procedure dbo.MOT_Search_Request_Message_Log		@dt_FromDate		datetime		= Null
														,@dt_ToDate			datetime		= Null
														,@vc_Token			varchar(50)		= Null
														,@i_MessageType		int				= Null	
														,@i_ScheduledTaskId	int				= Null
														,@vc_EventType		varchar(8000)	= Null
														,@c_OnlyShowSQL  	char(1) 		= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		MOT_Search_Request_Message_Log @vc_EventType = 'Error', @c_OnlyShowSQL = 'Y'
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		04/08/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@vc_DynamicSQL		varchar(8000)
		,@i_MessageTypeId	int

----------------------------------------------------------------------------------------------------------------------
-- Set the Scheduled Task Id
----------------------------------------------------------------------------------------------------------------------
Select	@i_MessageTypeId	= MessageTypeId
From	MessageType	(NoLock)
Where	MessageTypeDesc	= 'ScheduledTask'

----------------------------------------------------------------------------------------------------------------------
-- Create the Temp Table
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'
				Create Table	#RequestMessage
								(RequestMessageId		int	
								,MinEventLogId			int				Null
								,MaxEventLogId			int				Null
								,EventType				varchar(25)		Null
								,StartDate				datetime		Null
								,EndDate				datetime		Null
								,MachineName			varchar(50)		Null
								,SecurityIdentity		varchar(100)	Null
								,MessageTypeId			int				Null
								,ScheduledTaskId		int				Null
								,OriginalMessageTxt		varchar(MAX)	Null
								,EventLogMessage		varchar(MAX)	Null
								,TokenCde				varchar(50)		Null
								,EventLogSource			varchar(50)		Null
								,CreateDt				datetime		Null
								,RequiredResponseFlg	bit				Null)
				'
	End
Else
	Begin
				Create Table	#RequestMessage
								(RequestMessageId		int	
								,MinEventLogId			int				Null
								,MaxEventLogId			int				Null
								,EventType				varchar(25)		Null
								,StartDate				datetime		Null
								,EndDate				datetime		Null
								,MachineName			varchar(50)		Null
								,SecurityIdentity		varchar(100)	Null
								,MessageTypeId			int				Null
								,ScheduledTaskId		int				Null
								,OriginalMessageTxt		varchar(MAX)	Null
								,EventLogMessage		varchar(MAX)	Null
								,TokenCde				varchar(50)		Null
								,EventLogSource			varchar(50)		Null
								,CreateDt				datetime		Null
								,RequiredResponseFlg	bit				Null)	
	End		

----------------------------------------------------------------------------------------------------------------------
-- Select the Request Messages with the Min and Max Event Log Ids
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Insert	#RequestMessage
		(RequestMessageId
		,MinEventLogId
		,MaxEventLogId
		,MessageTypeId
		,OriginalMessageTxt
		,TokenCde
		,CreateDt
		,RequiredResponseFlg)
Select	RequestMessage. RequestMessageId
		,Min(EventLog. EventLogId)
		,Max(EventLog. EventLogId)
		,RequestMessage. MessageTypeId
		,RequestMessage. OriginalMessageTxt
		,RequestMessage. TokenCde
		,RequestMessage. CreateDt
		,RequestMessage. RequiredResponseFlg
From	RequestMessage			(NoLock)
		Inner Join	EventLog	(NoLock)	On	RequestMessage. RequestMessageId	= EventLog. RequestMessageId 
Where	1 = 1
'

----------------------------------------------------------------------------------------------------------------------
-- Add the From Date Qualifer
----------------------------------------------------------------------------------------------------------------------
If	@dt_FromDate Is Not Null 
	Select @vc_DynamicSQL = @vc_DynamicSQL + '
And	RequestMessage. CreateDt		>= ' + '''' + convert(varchar,@dt_FromDate) + ''''  

----------------------------------------------------------------------------------------------------------------------
-- Add the To Date Qualifer
----------------------------------------------------------------------------------------------------------------------
If	@dt_ToDate Is Not Null 
	Select @vc_DynamicSQL = @vc_DynamicSQL + '
And	RequestMessage. CreateDt		<= ' + '''' + convert(varchar,@dt_ToDate) + '''' 

----------------------------------------------------------------------------------------------------------------------
-- Add the To Date Qualifer   -- Removed / Operator Handlers are Handled in the SelectSqlStatement method
----------------------------------------------------------------------------------------------------------------------
/*
If	@vc_Token Is Not Null 
	Select @vc_DynamicSQL = @vc_DynamicSQL + '
And	RequestMessage. TokenCde		Like ' + '''' + @vc_Token + ''''   
*/

----------------------------------------------------------------------------------------------------------------------
-- Add the Message Type Qualifer
----------------------------------------------------------------------------------------------------------------------
If	@i_MessageType Is Not Null 
	Select @vc_DynamicSQL = @vc_DynamicSQL + '
And	RequestMessage. MessageTypeId	= ' + convert(varchar(8000),@i_MessageType)  


Select	@vc_DynamicSQL	= @vc_DynamicSQL +
'				
Group By	RequestMessage. RequestMessageId 
			,RequestMessage. MessageTypeId
			,RequestMessage. OriginalMessageTxt
			,RequestMessage. TokenCde
			,RequestMessage. CreateDt
			,RequestMessage. RequiredResponseFlg
'	

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
			
----------------------------------------------------------------------------------------------------------------------
-- Set the following values from last Event Log entry
----------------------------------------------------------------------------------------------------------------------			
Select	@vc_DynamicSQL	= '	
Update	#RequestMessage
Set		EventType			= EventLog. EventType	
		,EndDate			= EventLog. EventDateTime
		,MachineName		= EventLog. MachineName
		,SecurityIdentity	= EventLog. SecurityIdentity
		,EventLogMessage	= EventLog. Message
		,EventLogSource		= EventLog. Source
From	#RequestMessage			(NoLock)
		Inner Join	EventLog	(NoLock)	On	#RequestMessage. MaxEventLogId	= EventLog. EventLogId 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Add the Event Type Qualifer
----------------------------------------------------------------------------------------------------------------------
If	@vc_EventType Is Not Null 
	Begin
		Select	@vc_DynamicSQL	= '	
		Delete	#RequestMessage
		Where	IsNull(EventType,'''')	<> ''' + convert(varchar,@vc_EventType) + '''
		'
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

-----------------------------------------------------------------------------------------------------------
-- Set the Start Date from the first Event Log entry
----------------------------------------------------------------------------------------------------------------------	

Select	@vc_DynamicSQL	= '	
Update	#RequestMessage
Set		StartDate			= EventLog. EventDateTime	
From	#RequestMessage			(NoLock)
		Inner Join	EventLog	(NoLock)	On	#RequestMessage. MinEventLogId	= EventLog. EventLogId 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Parse out the Scheduled Task Id from the Scheduled Task Messages
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '	
Update	#RequestMessage
Set		ScheduledTaskId			=	Case
										When	CHARINDEX(''<ScheduledTaskId>'',#RequestMessage. OriginalMessageTxt) > 0	Then	Substring(#RequestMessage. OriginalMessageTxt, CHARINDEX(''<ScheduledTaskId>'',#RequestMessage. OriginalMessageTxt) + 17,  CHARINDEX(''</ScheduledTaskId>'',#RequestMessage. OriginalMessageTxt) - ( CHARINDEX(''<ScheduledTaskId>'',#RequestMessage. OriginalMessageTxt) + 17) )
										Else	Null
									End
Where	#RequestMessage. MessageTypeId	= ' + convert(varchar,IsNull(@i_MessageTypeId,-1)) + '
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Add the Scheduled Task Id Qualifer
----------------------------------------------------------------------------------------------------------------------
If	@i_ScheduledTaskId Is Not Null 
	Begin
		Select	@vc_DynamicSQL	= '	
		Delete	#RequestMessage
		Where	IsNull(ScheduledTaskId,-1)	<> ' + convert(varchar,@i_ScheduledTaskId) + '
		'
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Return the result set
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '	
Select	#RequestMessage. RequestMessageId
		,#RequestMessage. EventType
		,#RequestMessage. StartDate
		,#RequestMessage. EndDate
		,DateDiff(ss,#RequestMessage. StartDate,#RequestMessage. EndDate) ''Seconds''
		,#RequestMessage. MachineName
		,#RequestMessage. SecurityIdentity
		,#RequestMessage. MessageTypeId
		,#RequestMessage. ScheduledTaskId
		,SUBSTRING(#RequestMessage.OriginalMessageTxt,0,4000)
		,SUBSTRING(#RequestMessage.EventLogMessage,0,4000)
		,#RequestMessage. TokenCde
		,#RequestMessage. EventLogSource
		,#RequestMessage. CreateDt
		,#RequestMessage. RequiredResponseFlg
From	#RequestMessage					(NoLock)
'


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.MOT_Search_Request_Message_Log') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.MOT_Search_Request_Message_Log >>>'
	Grant Execute on dbo.MOT_Search_Request_Message_Log to SYSUSER
	Grant Execute on dbo.MOT_Search_Request_Message_Log to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.MOT_Search_Request_Message_Log >>>'
GO



