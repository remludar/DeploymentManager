
if exists (Select 1 from sysobjects where name = 'SCS_ReprocessExchangeIntegrationErrors')
Begin
	exec('Drop Procedure dbo.SCS_ReprocessExchangeIntegrationErrors')
End
GO

Create Procedure dbo.SCS_ReprocessExchangeIntegrationErrors
	(
		 @ProcessCalendarSpreads		char(1)			= 'Y'
		,@ErrorMatchingString			varchar(MAX)	= '%timeout%'
		,@StartDateTime						smalldatetime	= null
		,@EndDateTime						smalldatetime	= null
		,@Suffix						varchar(10)		= 'x'
	)
As
/*	The custom stored procedure will resubmit exchange traded errors for reprocessing using the message based
	exchange integration code.
	exec dbo.SCS_ReprocessExchangeIntegrationErrors @ProcessCalendarSpreads='N',@ErrorMatchingString='%Timeout%',@StartDateTime='2013-01-03'
*/
Begin
	
	if (@StartDateTime is Null)
	begin
		--If startdate is null, truncate the time so that midnight of current day is used
		select @StartDateTime = CAST(getdate() as DATE)
	end
	
	if (@EndDateTime is Null)
	begin
		--If enddate is null, use current date time
		select @EndDateTime = GETDATE()
	end

	Create Table #ErrorTransactionIDs (TransactionID varchar(80), CalendarSpread char)
		
	--Insert all errors matching the error message except those that have a leg in exchange traded deal (calendar spreads)
	Insert Into #ErrorTransactionIDs
	Select	TransactionID, 'N'
	from	ExchangeIntegrationError EIE
	where	ErrorMessage like @ErrorMatchingString
	and		Not Exists (Select 1 from ExchangeTradedDeal ETD where ETD.TransactionID like EIE.TransactionID + ' -%')
	and		ErrorDate between @StartDateTime and @EndDateTime

	--Udpate existing legs to add an x to the TransactionId.  This will allow the reprocessing of the error to succeed
	if (@ProcessCalendarSpreads = 'Y')
	begin
		--Find errors for legs of calendar spread where only one leg is in ExchangeTradedDeal (staging)
		Insert Into #ErrorTransactionIDs
		Select	EIE.TransactionID, 'Y'
		from	ExchangeTradedDeal ETD
		Inner Join ExchangeIntegrationError EIE on (ETD.TransactionId like EIE.TransactionID + ' -%')
		where	EIE.ErrorDate between @StartDateTime and @EndDateTime
		and		EIE.ErrorMessage like @ErrorMatchingString
		Group by EIE.TransactionID
		having COUNT(*) < 2 

		Update  ExchangeTradedDeal
		Set		TransactionID = ExchangeTradedDeal.TransactionID + @Suffix
		From	#ErrorTransactionIDs EIE
		where	ExchangeTradedDeal.TransactionID like EIE.TransactionId + ' -%'
		and		EIE.CalendarSpread = 'Y'
	end
	
	--Now loop through all the errors to reprocess
	declare @TransactionId varchar(80) = null
	declare @Message varchar(max) = null
	declare @SourceSystemID int = null
	declare @MessageType varchar(80) = null
	
	--Get the first transactionid
	select @TransactionId = min(TransactionId)
	From	#ErrorTransactionIDs
	
	while (ISNULL(@TransactionId,'') > '')
	Begin
		--Get the message (ErrorRecord) and source system
		select	 @Message = EIE.ErrorRecord
				,@SourceSystemID = EIE.SrceSystmID
		From	ExchangeIntegrationError EIE
		where	EIE.TransactionID = @TransactionId
		and		ErrorDate > @StartDateTime
		
		if (@SourceSystemID = 9)
			select @MessageType = 'ICETradeCaptureReport'
		else
			select @MessageType = 'NYMEXTradeCaptureReport'

		--First delete the ExchangeTradedDealOrder tokens for the parent or any matching legs
		delete	SCS_ExchangeTradedDealOrder
		where	TransactionID like @TransactionId + '%'

		--Delete the existing error record
		delete	ExchangeIntegrationError
		where	TransactionID = @TransactionId
		
		--Publish the message to the message queue				
		exec sra_EnqueueRequestMessage @MessageType=@MessageType, @Message=@Message
		
		--Get the next transactionid
		select	@TransactionId = min(TransactionId)
		From	#ErrorTransactionIDs
		where	TransactionID > @TransactionId
	end

	Drop Table #ErrorTransactionIDs
		
End
GO

Grant EXECUTE on dbo.SCS_ReprocessExchangeIntegrationErrors to sysuser, RightAngleAccess
GO