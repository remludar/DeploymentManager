/****** Object:  StoredProcedure [dbo].[MTV_SAP_MsgHandler]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_MsgHandler.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_MsgHandler]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAP_MsgHandler] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAP_MsgHandler >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SAP_MsgHandler]
		@c_Table		char(2)			,
		@vc_Type		varchar(100)	,
		@i_BatchID		int				= null,
		@i_CIIMssgQID	int				= null,
		@vc_MultiIDs	varchar(max)	= null,
		@vc_Message		varchar(max)	= null

AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  13JUL2017
-- Description:   Update SAP messages
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
BEGIN TRY
	BEGIN TRANSACTION UpdateSAPTables

		if @vc_Type = 'Sent'
			begin
				if @c_Table = 'AR'
				begin
					Update dbo.MTVSAPARStaging with (ROWLOCK) Set BatchID = @i_BatchID, RightAngleStatus = 'C', MiddlewareStatus = 'N', SAPStatus = null, Message = @vc_Message Where MTVSAPARStaging.CIIMssgQID = @i_CIIMssgQID
				end

				if @c_Table = 'AP'
				begin
					Update dbo.MTVSAPAPStaging with (ROWLOCK) Set BatchID = @i_BatchID, RightAngleStatus = 'C', MiddlewareStatus = 'N', SAPStatus = null, Message = @vc_Message Where MTVSAPAPStaging.CIIMssgQID = @i_CIIMssgQID
				end

				-- we don't handle GL here because of the massive number of updates.  Maybe a MERGE join?
			end

		if @vc_Type = 'ErrorFromExport'
			begin
				if @c_Table = 'AR'
				begin
					Update dbo.MTVSAPARStaging with (ROWLOCK) Set RightAngleStatus = 'E', Message = @vc_Message Where MTVSAPARStaging.CIIMssgQID = @i_CIIMssgQID

					Update  dbo.MTVInvoiceInterfaceStatus
					Set     ARAPExtracted = Convert(Bit, 0)
					Where   MTVInvoiceInterfaceStatus.CIIMssgQID = @i_CIIMssgQID

					Update	dbo.SalesInvoiceHeader with (ROWLOCK)
					Set		SlsInvceHdrFdDte = null
					From	dbo.CustomMessageQueue
							Inner Join dbo.SalesInvoiceHeader
								on	CustomMessageQueue.EntityID	= SalesInvoiceHeader.SlsInvceHdrID
					Where	CustomMessageQueue.ID		= @i_CIIMssgQID
					and     CustomMessageQueue.Entity	= 'SH'
				end

				if @c_Table = 'AP'
				begin
					Update dbo.MTVSAPAPStaging with (ROWLOCK) Set RightAngleStatus = 'E', Message = @vc_Message Where MTVSAPAPStaging.CIIMssgQID = @i_CIIMssgQID

					Update	dbo.MTVInvoiceInterfaceStatus
					Set		ARAPExtracted = Convert(Bit, 0)
					Where	MTVInvoiceInterfaceStatus.CIIMssgQID = @i_CIIMssgQID

					Update	dbo.PayableHeader with (ROWLOCK)
					Set		FedDate = null
					From	dbo.CustomMessageQueue
							Inner Join dbo.PayableHeader
								on	CustomMessageQueue.EntityID	= PayableHeader.PybleHdrID
					Where	CustomMessageQueue.ID		= @i_CIIMssgQID
					and     CustomMessageQueue.Entity	= 'PH'
				end

				if @c_Table = 'GL'
				begin
					exec ('Update MTVSAPGLStaging with (ROWLOCK) Set RightAngleStatus = ''E'', Message = ''' + @vc_Message + ''' Where ID in (' + @vc_MultiIDs + ')')
				end
			end

		if @vc_Type = 'ErrorFromSAP'
			begin
				if @c_Table = 'AR'
				begin
					Update  dbo.MTVSAPARStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'E', Message = left(@vc_Message, 1000) Where BatchID = @i_BatchID

					Update	dbo.SalesInvoiceHeader
					Set		SlsInvceHdrFdDte = NULL
					From	dbo.MTVSAPARStaging
							Inner Join dbo.CustomMessageQueue
								on	CustomMessageQueue.ID		= MTVSAPARStaging.CIIMssgQID
								and	CustomMessageQueue.Entity	= 'SH'
							Inner Join dbo.SalesInvoiceHeader
								on	CustomMessageQueue.EntityID	= SalesInvoiceHeader.SlsInvceHdrID
					Where	MTVSAPARStaging.InvoiceLevel	= 'H'
					And		MTVSAPARStaging.BatchID			= @i_BatchID
				end

				if @c_Table = 'AP'
				begin
					Update  dbo.MTVSAPAPStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'E', Message = left(@vc_Message, 1000) Where BatchID = @i_BatchID
	
					Update	dbo.PayableHeader
					Set		FedDate = NULL
					From	dbo.MTVSAPAPStaging
							Inner Join dbo.CustomMessageQueue
								on	CustomMessageQueue.ID		= MTVSAPAPStaging.CIIMssgQID
								and	CustomMessageQueue.Entity	= 'PH'
							Inner Join dbo.PayableHeader
								on	CustomMessageQueue.EntityID	= PayableHeader.PybleHdrID
					Where	MTVSAPAPStaging.InvoiceLevel	= 'H'
					And		MTVSAPAPStaging.BatchID			= @i_BatchID
				end

				if @c_Table = 'GL'
				begin
					Update  dbo.MTVSAPGLStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'E', Message = left(@vc_Message, 1000) Where BatchID = @i_BatchID
				end
			end

		if @vc_Type = 'SuccessFromSAP'
			begin
				if @c_Table = 'AR'
				begin
					Update dbo.MTVSAPARStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'C' Where BatchID = @i_BatchID
					Update dbo.SalesInvoiceHeader with (ROWLOCK) Set SlsInvceHdrFdDte = getdate() where SlsInvceHdrFdDte is null and exists (select 1 from MTVSAPARStaging Where BatchID = @i_BatchID and DocNumber = SlsInvceHdrNmbr and SAPStatus = 'C')
				end

				if @c_Table = 'AP'
				begin
					Update dbo.MTVSAPAPStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'C' Where BatchID = @i_BatchID
					Update dbo.PayableHeader with (ROWLOCK) Set FedDate = getdate() where FedDate is null and exists (select 1 from MTVSAPAPStaging Where BatchID = @i_BatchID and DocNumber = InvoiceNumber and SAPStatus = 'C')
				end

				if @c_Table = 'GL'
				begin
						Update dbo.MTVSAPGLStaging with (ROWLOCK) Set MiddlewareStatus = 'C', SAPStatus = 'C' Where BatchID = @i_BatchID
				end
			end

	COMMIT TRANSACTION UpdateSAPTables
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION UpdateSAPTables

	declare @i_prcssGrpID int
	declare @vc_Parm varchar(max)

	select	@i_prcssGrpID = PrcssGrpID from ProcessGroup Where PrcssGrpNme = 'MTV SAP Retry Failed Update'

	select @vc_parm = '@c_Table='''+@c_Table+''', @vc_Type=''' + @vc_Type + ''''
	if @i_BatchID is not null
		select @vc_parm = @vc_parm + ',@i_BatchID='+ convert(varchar,@i_BatchID)
	if @i_CIIMssgQID is not null
		select @vc_parm = @vc_parm + ',@i_CIIMssgQID='+ convert(varchar,@i_CIIMssgQID)
	if @vc_MultiIDs is not null
		select @vc_parm = @vc_parm + ',@vc_MultiIDs = '''+ @vc_MultiIDs +''''
	if @vc_Message is not null
		select @vc_parm = @vc_parm + ',@vc_Message = '''+ @vc_Message +''''

	
	exec SP_MTV_Schedule_Single_Process
				@ai_PrcssGrpID  = @i_prcssGrpID,		/* The Proces Group ID to schedule */
				@avc_Prmtr		= @vc_parm				/* The Parameter to pass to the process */
	

END CATCH


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_MsgHandler]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAP_MsgHandler.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAP_MsgHandler >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAP_MsgHandler >>>'
	  END