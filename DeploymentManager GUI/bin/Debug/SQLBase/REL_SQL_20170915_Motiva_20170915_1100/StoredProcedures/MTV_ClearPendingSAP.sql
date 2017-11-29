PRINT 'Start Script=MTV_ClearPendingSAP.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ClearPendingSAP]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ClearPendingSAP] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ClearPendingSAP >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ClearPendingSAP]
	@c_ARorAP char(2) = 'AR'
AS

-- =============================================
-- Author:        Jeremy von Hoff
-- Create date:	  02JUL2017
-- Description:   This SP clears Pending records from the MTVSAPARStaging table, in case they get stuck
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
declare @i_SAPMessageTypeID int
select @i_SAPMessageTypeID = MessageTypeID From MessageType Where MessageTypeDesc = 'MTVSAPRequestMessageHandler'

If @c_ARorAP not in ('AR', 'AP')
		Raiserror (60010,15,-1, 'Parameter must be AR or AP.')

if @c_ARorAP = 'AR'
begin
	-- exit if there are no "P" records
	If not exists (Select 1 From MTVSAPARStaging Where RightAngleStatus = 'P')
		Raiserror (60010,15,-1, 'No Pending records exist in MTVSAPARStaging.')

	-- exit if there are any QueuedRequestMessages to process
	If exists (select 1 from QueuedRequestMessage Where MessageTypeID = @i_SAPMessageTypeID)
		Raiserror (60010,15,-1, 'Cannot clear Pending status while there are Queued Request Messages to process for the SAP interfaces.')

	-- exit if the interface is checked out
	If exists (select 1 from CheckoutProcess Where ProcessName = 'MTVSAPARCheckout' and Running = 1)
		Raiserror (60010,15,-1, 'Cannot clear Pending status while AR Interface is checked out.')


	Update	MTVSAPARStaging
	Set		RightAngleStatus = 'E'
	From	MTVSAPARStaging
	Where	RightAngleStatus = 'P'
	And		Not Exists	(
						Select	1
						From	QueuedRequestMessage
						Where	MessageTypeID = @i_SAPMessageTypeID
						)
	And		Not Exists	(
						Select	1
						From	CheckoutProcess
						Where	ProcessName = 'MTVSAPARCheckout'
						And		Running = 1
						)
end

if @c_ARorAP = 'AP'
begin
	-- exit if there are no "P" records
	If not exists (Select 1 From MTVSAPAPStaging Where RightAngleStatus = 'P')
		Raiserror (60010,15,-1, 'No Pending records exist in MTVSAPAPStaging.')

	-- exit if there are any QueuedRequestMessages to process
	If exists (select 1 from QueuedRequestMessage Where MessageTypeID = @i_SAPMessageTypeID)
		Raiserror (60010,15,-1, 'Cannot clear Pending status while there are Queued Request Messages to process for the SAP interfaces.')

	-- exit if the interface is checked out
	If exists (select 1 from CheckoutProcess Where ProcessName = 'MTVSAPAPCheckout' and Running = 1)
		Raiserror (60010,15,-1, 'Cannot clear Pending status while AP Interface is checked out.')


	Update	MTVSAPAPStaging
	Set		RightAngleStatus = 'E'
	From	MTVSAPAPStaging
	Where	RightAngleStatus = 'P'
	And		Not Exists	(
						Select	1
						From	QueuedRequestMessage
						Where	MessageTypeID = @i_SAPMessageTypeID
						)
	And		Not Exists	(
						Select	1
						From	CheckoutProcess
						Where	ProcessName = 'MTVSAPAPCheckout'
						And		Running = 1
						)
end


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ClearPendingSAP]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ClearPendingSAP.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ClearPendingSAP >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ClearPendingSAP >>>'
	  END