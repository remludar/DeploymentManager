If OBJECT_ID('dbo.Custom_Interface_Message_Inbound') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_Message_Inbound
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_Message_Inbound >>>'
End
Go

Create Procedure dbo.Custom_Interface_Message_Inbound	 @vc_FileName		varchar(80)		=  NULL
														,@vc_StatusFlag		varchar(10)		=  NULL
														,@vc_ErrorMessage	varchar(2000)	=  NULL
														,@vc_ARAPFlag		varchar(2)		=  NULL
														,@vc_Assignment		varchar(50)		=  NULL
														,@vc_MessageDate	varchar(25)		=  NULL
														,@vc_Message		varchar(2000)	=  NULL
														,@c_OnlyShowSQL		char(1) 		= 'N' 
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_Message_Inbound @i_ID = 6, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		13/04/2013 - First Created
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
Declare	 @vc_Error				varchar(255)
		,@sdt_Date				smalldatetime
		,@i_ID					int
		,@i_InvoiceID			int
		,@i_MessageID			int
		,@vc_Entity				varchar(25)
		,@b_IsConfirmed			bit
		,@vc_ReturnMessage		varchar(2000)
		,@vc_Status				char(1)

----------------------------------------------------------------------------------------------------------------------
-- Set the error checking variables
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_Date	= GetDate()	

----------------------------------------------------------------------------------------------------------------------
-- Block 10: Validate Fields 
----------------------------------------------------------------------------------------------------------------------	


----------------------------------------------------------------------------------------------------------------------
-- Block 20: Stage the interface table
----------------------------------------------------------------------------------------------------------------------
Begin Transaction InsertMessage

	----------------------------------------------------------------------------------------------------------------------
	-- Get the next key
	----------------------------------------------------------------------------------------------------------------------			
	Execute dbo.sp_getkey 'CustomInboundMessage', @i_ID out

	----------------------------------------------------------------------------------------------------------------------
	-- If one could not be determined raise an error
	----------------------------------------------------------------------------------------------------------------------			
	If	@i_ID Is Null
		Begin
			Rollback Transaction InsertMessage			
			Select	@vc_Error			= 'The Inbound Message Interface encountered an error generating a key for the CustomInboundMessage table. ' 
			Goto	NoError						
		End	
		
	----------------------------------------------------------------------------------------------------------------------
	-- Stage the record into the CustomInboundMessage table  sp_columnlist CustomInboundMessage
	----------------------------------------------------------------------------------------------------------------------	
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
	Select	@i_ID
			,@vc_FileName			-- InterfaceFileName
			,@vc_StatusFlag			-- StatusFlag
			,@vc_ErrorMessage		-- ErrorMessage
			,@vc_ARAPFlag			-- ARAPFlag
			,@vc_Assignment			-- Assignment
			,@vc_MessageDate		-- MessageDate
			,@vc_Message			-- ReturnMessage
			,'R'					-- InterfaceStatus
			,''						-- InterfaceMessage
			,NULL					-- MessageQueueID
			,NULL					-- InterfaceInvoiceID
			,@sdt_Date				-- CreationDate
	
	---------------------------------------------------------------------------------------------------------------------
	-- Check for Errors on the Insert
	----------------------------------------------------------------------------------------------------------------------
	If	@@error <> 0 
		Begin
			Rollback Transaction InsertMessage
			
			Select	@vc_Error			= 'The Inbound Message Interface encountered an error inserting a record into the CustomInboundMessage table. ' 
			Goto	NoError						
		End						

----------------------------------------------------------------------------------------------------------------------------------
-- Commit the Transaction
----------------------------------------------------------------------------------------------------------------------------------
Commit Transaction InsertMessage			

----------------------------------------------------------------------------------------------------------------------------------
-- Set the InterfaceInvoiceID Value
----------------------------------------------------------------------------------------------------------------------------------
Begin Try													
	Update	CustomInboundMessage
	Set		 InterfaceInvoiceID	= CustomInvoiceInterface. InterfaceInvoiceID
			,MessageQueueID		= CustomInvoiceInterface. MessageQueueID
	From	CustomInboundMessage				(NoLock)
			Inner Join	CustomInvoiceInterface	(NoLock)	On	CustomInboundMessage. Assignment		= dbo.Custom_Format_SAP_Invoice_String(CustomInvoiceInterface. InterfaceInvoiceID)			
															And	CustomInvoiceInterface. InvoiceLevel	= 'H'
	Where	CustomInboundMessage. ID	= @i_ID											 														
End Try
Begin Catch
		Select	@vc_Error	= 'The Inbound Message Interface encountered an error setting the InterfaceInvoiceID value. '
		
		Update	CustomInboundMessage
		Set		 InterfaceStatus	= 'E'
				,InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID				
End Catch

----------------------------------------------------------------------------------------------------------------------
-- Block 30: Validation Checks
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Make sure the invoice id exists
----------------------------------------------------------------------------------------------------------------------------------	
Update	CustomInboundMessage
Set		 InterfaceStatus	= 'E'
		,InterfaceMessage	= InterfaceMessage + 'The Inbound Message Interface cannot determine the Invoice ID for the Assignment Number. '
Where	ID	= @i_ID		
And		InterfaceInvoiceID		Is Null

----------------------------------------------------------------------------------------------------------------------------------
-- Make sure the message id exists
----------------------------------------------------------------------------------------------------------------------------------	
Update	CustomInboundMessage
Set		 InterfaceStatus	= 'E'
		,InterfaceMessage	= InterfaceMessage + 'The Inbound Message Interface cannot determine the Message ID for the Assignment Number. '
Where	ID	= @i_ID		
And		MessageQueueID			Is Null

----------------------------------------------------------------------------------------------------------------------------------
-- If there are no errors and we have the requisite IDs carry process the message
----------------------------------------------------------------------------------------------------------------------------------		
If	Exists (Select 'X' From CustomInboundMessage (NoLock) Where InterfaceStatus = 'R' And ID = @i_ID And InterfaceInvoiceID Is Not Null And MessageQueueID Is Not Null)		
	Begin
		----------------------------------------------------------------------------------------------------------------------------------
		-- Set the basic variables will be working with
		----------------------------------------------------------------------------------------------------------------------------------
		Select	@vc_Entity			= ARAPFlag
				,@i_InvoiceID		= InterfaceInvoiceID	
				,@i_MessageID		= MessageQueueID
				,@vc_ReturnMessage	= ReturnMessage	
				,@vc_Status			= StatusFlag 
		From	CustomInboundMessage	(NoLock)
		Where	ID	= @i_ID

		----------------------------------------------------------------------------------------------------------------------------------
		-- Set the confirmed value
		----------------------------------------------------------------------------------------------------------------------------------
		Select	@b_IsConfirmed	= MessageBusConfirmed
		From	CustomMessageQueue	(NoLock)
		Where	ID	= @i_MessageID 		

		----------------------------------------------------------------------------------------------------------------------------------
		-- If the message hasn't been confirmed continue
		----------------------------------------------------------------------------------------------------------------------------------
		If	@b_IsConfirmed = convert(bit,0)
			Begin
				----------------------------------------------------------------------------------------------------------------------------------
				-- If the message is an error log it
				----------------------------------------------------------------------------------------------------------------------------------			
				If	@vc_Status	= 'E'
					Begin					
						----------------------------------------------------------------------------------------------------------------------------------
						-- Open a transaction - if any update fails we want to roll them all back
						----------------------------------------------------------------------------------------------------------------------------------						
						Begin Transaction	ManageConfirmationError
								
							----------------------------------------------------------------------------------------------------------------------------------
							-- Update the Message Queue Table
							----------------------------------------------------------------------------------------------------------------------------------													
							Update	CustomMessageQueue
							Set		 MessageBusProcessed		= convert(bit,1)
									,MessageBusProcessedDate	= @sdt_Date
									,MessageBusConfirmed		= convert(bit,0)
									,HasErrored					= convert(bit,1)
									,Error						= RTrim(LTrim(Substring(IsNull(Error,'') + ' ' + IsNull(@vc_ReturnMessage,''), 0, 2000)))
							Where	ID	= @i_MessageID	
							
							----------------------------------------------------------------------------------------------------------------------------------
							-- If there is an error log it and return out
							----------------------------------------------------------------------------------------------------------------------------------							
							If	@@error <> 0 
								Begin
									Rollback Transaction ManageConfirmationError
									
									Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the CustomMessageQueue table. ' 
									
									Update	CustomInboundMessage
									Set		 InterfaceStatus	= 'E'
											,InterfaceMessage	= InterfaceMessage + @vc_Error
									Where	ID	= @i_ID	
														
									Goto	NoError	
								End	
							
							----------------------------------------------------------------------------------------------------------------------------------
							-- Update the Invoice Interface Table
							----------------------------------------------------------------------------------------------------------------------------------								
							Update	CustomInvoiceInterface
							Set		InterfaceStatus				= 'E'
									,ApprovalUserID				= NULL
									,ApprovalDate				= NULL
									,InterfaceMessage			= RTrim(LTrim(Substring(IsNull(InterfaceMessage,'') + ' ' + IsNull(@vc_ReturnMessage,''), 0, 2000)))
									,MessageBusProcessed		= convert(bit,1)
									,MessageBusProcessedDate	= @sdt_Date
									,MessageBusConfirmed		= convert(bit,0)									
							Where	MessageQueueID	= @i_MessageID								
							
							----------------------------------------------------------------------------------------------------------------------------------
							-- If there is an error log it and return out
							----------------------------------------------------------------------------------------------------------------------------------							
							If	@@error <> 0 
								Begin
									Rollback Transaction ManageConfirmationError
									
									Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the CustomInvoiceInterface table. ' 
									
									Update	CustomInboundMessage
									Set		 InterfaceStatus	= 'E'
											,InterfaceMessage	= InterfaceMessage + @vc_Error
									Where	ID	= @i_ID	
														
									Goto	NoError	
								End								
								
							----------------------------------------------------------------------------------------------------------------------------------
							-- Update the payable header record
							----------------------------------------------------------------------------------------------------------------------------------														
							If	@vc_Entity	= 'AP'
								Begin								
									Update	PayableHeader
									Set		FedDate	= NULL
									From	PayableHeader	(NoLock)
											Inner Join	CustomMessageQueue	On	PayableHeader. PybleHdrID	= CustomMessageQueue. EntityID
																			And	CustomMessageQueue. Entity	= 'PH'
									Where	CustomMessageQueue. ID		= @i_MessageID
									And		PayableHeader. Status	= 'F'	
									And		@vc_Status				= 'E'								
								
									----------------------------------------------------------------------------------------------------------------------------------
									-- If there is an error log it and return out
									----------------------------------------------------------------------------------------------------------------------------------							
									If	@@error <> 0 
										Begin
											Rollback Transaction ManageConfirmationError
											
											Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the PayableHeader table. ' 
											
											Update	CustomInboundMessage
											Set		 InterfaceStatus	= 'E'
													,InterfaceMessage	= InterfaceMessage + @vc_Error
											Where	ID	= @i_ID	
																
											Goto	NoError	
										End									
																																																															
								End 
					
							----------------------------------------------------------------------------------------------------------------------------------
							-- Update the sales invoice header record
							----------------------------------------------------------------------------------------------------------------------------------														
							If	@vc_Entity	= 'AR'
								Begin								
									Update	SalesInvoiceHeader
									Set		SlsInvceHdrFdDte	= NULL
									From	SalesInvoiceHeader	(NoLock)
											Inner Join	CustomMessageQueue	On	SalesInvoiceHeader. SlsInvceHdrID	= CustomMessageQueue. EntityID
																			And	CustomMessageQueue. Entity			= 'SH'
									Where	CustomMessageQueue. ID				= @i_MessageID	
									And		SalesInvoiceHeader. SlsInvceHdrStts = 'S'
									And		@vc_Status							= 'E'								
								
									----------------------------------------------------------------------------------------------------------------------------------
									-- If there is an error log it and return out
									----------------------------------------------------------------------------------------------------------------------------------							
									If	@@error <> 0 
										Begin
											Rollback Transaction ManageConfirmationError
											
											Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the SalesInvoiceHeader table. ' 
											
											Update	CustomInboundMessage
											Set		 InterfaceStatus	= 'E'
													,InterfaceMessage	= InterfaceMessage + @vc_Error
											Where	ID	= @i_ID	
																
											Goto	NoError	
										End									
																																																															
								End 					
					
							----------------------------------------------------------------------------------------------------------------------------------
							-- Mark the inbound message record to complete
							----------------------------------------------------------------------------------------------------------------------------------					
							Update	CustomInboundMessage
							Set		InterfaceStatus	= 'C'
							Where	ID	= @i_ID		
					
						----------------------------------------------------------------------------------------------------------------------------------
						-- Commit the Transaction
						----------------------------------------------------------------------------------------------------------------------------------			
						Commit Transaction	ManageConfirmationError
					
					End
				Else
					Begin						
						----------------------------------------------------------------------------------------------------------------------------------
						-- Open a transaction - if any update fails we want to roll them all back
						----------------------------------------------------------------------------------------------------------------------------------						
						Begin Transaction	ManageConfirmationSuccess
								
							----------------------------------------------------------------------------------------------------------------------------------
							-- Update the Message Queue Table
							----------------------------------------------------------------------------------------------------------------------------------													
							Update	CustomMessageQueue
							Set		 MessageBusProcessed		= convert(bit,1)
									,MessageBusProcessedDate	= @sdt_Date
									,MessageBusConfirmed		= convert(bit,1)
									,HasErrored					= convert(bit,0)
									,Error						= ''
							Where	ID	= @i_MessageID	
							
							----------------------------------------------------------------------------------------------------------------------------------
							-- If there is an error log it and return out
							----------------------------------------------------------------------------------------------------------------------------------							
							If	@@error <> 0 
								Begin
									Rollback Transaction ManageConfirmationSuccess
									
									Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the CustomMessageQueue table. ' 
									
									Update	CustomInboundMessage
									Set		 InterfaceStatus	= 'E'
											,InterfaceMessage	= InterfaceMessage + @vc_Error
									Where	ID	= @i_ID	
														
									Goto	NoError	
								End	
							
							If	@vc_Entity	In ('AR','AP')
								Begin
									----------------------------------------------------------------------------------------------------------------------------------
									-- Update the Invoice Interface Table
									----------------------------------------------------------------------------------------------------------------------------------								
									Update	CustomInvoiceInterface
									Set		 MessageBusProcessed		= convert(bit,1)
											,MessageBusProcessedDate	= @sdt_Date
											,MessageBusConfirmed		= convert(bit,1)
									Where	MessageQueueID		= @i_MessageID								
									
									----------------------------------------------------------------------------------------------------------------------------------
									-- If there is an error log it and return out
									----------------------------------------------------------------------------------------------------------------------------------							
									If	@@error <> 0 
										Begin
											Rollback Transaction ManageConfirmationSuccess
											
											Select	@vc_Error	= 'The Inbound Message Interface encountered an error updating the CustomInvoiceInterface table. ' 
											
											Update	CustomInboundMessage
											Set		 InterfaceStatus	= 'E'
													,InterfaceMessage	= InterfaceMessage + @vc_Error
											Where	ID	= @i_ID	
																
											Goto	NoError	
										End						
								End
									
							----------------------------------------------------------------------------------------------------------------------------------
							-- Mark the inbound message record to complete
							----------------------------------------------------------------------------------------------------------------------------------					
							Update	CustomInboundMessage
							Set		InterfaceStatus	= 'C'
							Where	ID	= @i_ID											
									
							----------------------------------------------------------------------------------------------------------------------------------
							-- Commit the Transaction
							----------------------------------------------------------------------------------------------------------------------------------			
							Commit Transaction	ManageConfirmationSuccess																									
					End					
			End
		Else
			Begin
				----------------------------------------------------------------------------------------------------------------------------------
				-- The record has already been confirmed so just complete it
				----------------------------------------------------------------------------------------------------------------------------------					
				Update	CustomInboundMessage
				Set		InterfaceStatus	= 'C'
				Where	ID	= @i_ID							
			End
	End

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	

----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
	Raiserror (60010,-1,-1, @vc_Error	)


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_Message_Inbound') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_Message_Inbound >>>'
	Grant Execute on dbo.Custom_Interface_Message_Inbound to SYSUSER
	Grant Execute on dbo.Custom_Interface_Message_Inbound to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_Message_Inbound >>>'
GO

 