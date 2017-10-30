/****** Object:  StoredProcedure [dbo].[MTV_SAPStaging_Purge]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAPStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAPStaging_Purge]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAPStaging_Purge] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAPStaging_Purge >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
SET NOCOUNT ON
GO

ALTER PROCEDURE [dbo].[MTV_SAPStaging_Purge]
AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  08FEB2017
-- Description:   Purge the MTVSAPXXStaging tables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare	@sdt_CutoffDate		smalldatetime
Declare	@i_CutoffPeriodID	int
Declare @i_SAPPeriodsToKeep	int

select @i_SAPPeriodsToKeep = IsNull(dbo.GetRegistryValue('Motiva\SAP\MonthsOfDataToKeep'), 3)

Select	@sdt_CutoffDate = AccntngPrdEndDte,
		@i_CutoffPeriodID = AccntngPrdID
From	AccountingPeriod (NoLock)
Where	AccntngPrdID = (select	max(AccntngPrdID) - @i_SAPPeriodsToKeep from AccountingPeriod (NoLock) Where AccntngPrdCmplte = 'Y')

/******************************************************/
--	Purge the MTV SAP staging tables
/******************************************************/

Set Rowcount 10000

While exists ( Select 1 From MTVSAPGLStaging Where DocumentDate < @sdt_CutoffDate )
begin
	Delete	MTVSAPGLStaging
	Where	DocumentDate < @sdt_CutoffDate
end


While exists (	Select	1
				From	CustomInvoiceInterface as CII with (NoLock)
						Inner Join CustomAccountDetail CAD with (NoLock)
							on	CAD.AcctDtlID				= CII.AcctDtlID
							and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
							and	CAD.InterfaceSource			= 'SH'
						Inner Join MTVSAPARStaging
							on	MTVSAPARStaging.CIIMssgQID	= CII.MessageQueueID
				Where	CAD.AccntngPrdID		< @i_CutoffPeriodID
			)
begin
	Delete	MTVSAPARStaging			
	From	CustomInvoiceInterface as CII with (NoLock)
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID				= CII.AcctDtlID
				and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
				and	CAD.InterfaceSource			= 'SH'
			Inner Join MTVSAPARStaging
				on	MTVSAPARStaging.CIIMssgQID	= CII.MessageQueueID
	Where	CAD.AccntngPrdID		< @i_CutoffPeriodID
end


While Exists (	Select	1
				From	CustomInvoiceInterface as CII with (NoLock)
						Inner Join CustomAccountDetail CAD with (NoLock)
							on	CAD.AcctDtlID				= CII.AcctDtlID
							and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
							and	CAD.InterfaceSource			= 'PH'
						Inner Join MTVSAPAPStaging
							on	MTVSAPAPStaging.CIIMssgQID	= CII.MessageQueueID
				Where	CAD.AccntngPrdID		< @i_CutoffPeriodID
			)
begin
	Delete	MTVSAPAPStaging			
	From	CustomInvoiceInterface as CII with (NoLock)
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID				= CII.AcctDtlID
				and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
				and	CAD.InterfaceSource			= 'PH'
			Inner Join MTVSAPAPStaging
				on	MTVSAPAPStaging.CIIMssgQID	= CII.MessageQueueID
	Where	CAD.AccntngPrdID		< @i_CutoffPeriodID
End


/******************************************************/
--	Purge the Custom Acct. Framework tables
/******************************************************/
While Exists ( Select 1 From CustomGLInterface Where AccntngPrdID < @i_CutoffPeriodID)
begin
	Delete	CustomGLInterface			
	Where	AccntngPrdID		< @i_CutoffPeriodID
End


While Exists (	Select	1
				From	CustomInvoiceInterface
				Where	Exists	(
								Select	1
								From	CustomMessageQueue (NoLock)
										Inner Join SalesInvoiceHeader (NoLock)
											on	CustomMessageQueue.EntityID			= SalesInvoiceHeader.SlsInvceHdrID
											and	CustomMessageQueue.Entity			= 'SH'
								Where	CustomMessageQueue.ID				= CustomInvoiceInterface.MessageQueueID
								And		SalesInvoiceHeader.SlsInvceHdrFdDte	< @sdt_CutoffDate
								)
				)
begin
	Delete	CustomInvoiceInterface
	Where	Exists	(
					Select	1
					From	CustomMessageQueue (NoLock)
							Inner Join SalesInvoiceHeader (NoLock)
								on	CustomMessageQueue.EntityID			= SalesInvoiceHeader.SlsInvceHdrID
								and	CustomMessageQueue.Entity			= 'SH'
					Where	CustomMessageQueue.ID				= CustomInvoiceInterface.MessageQueueID
					And		SalesInvoiceHeader.SlsInvceHdrFdDte	< @sdt_CutoffDate
					)
End


While Exists (	Select	1
				From	CustomInvoiceInterface
				Where	Exists	(
								Select	1
								From	CustomMessageQueue (NoLock)
										Inner Join PayableHeader (NoLock)
											on	CustomMessageQueue.EntityID			= PayableHeader.PybleHdrID
											and	CustomMessageQueue.Entity			= 'PH'
								Where	CustomMessageQueue.ID				= CustomInvoiceInterface.MessageQueueID
								And		PayableHeader.FedDate				< @sdt_CutoffDate
								)
				)				
begin
	Delete	CustomInvoiceInterface
	Where	Exists	(
					Select	1
					From	CustomMessageQueue (NoLock)
							Inner Join PayableHeader (NoLock)
								on	CustomMessageQueue.EntityID			= PayableHeader.PybleHdrID
								and	CustomMessageQueue.Entity			= 'PH'
					Where	CustomMessageQueue.ID				= CustomInvoiceInterface.MessageQueueID
					And		PayableHeader.FedDate				< @sdt_CutoffDate
					)
End


While Exists (	Select	1
				From	CustomInvoiceLog
				Where	Not Exists	(
									Select	1
									From	CustomMessageQueue (NoLock)
									Where	CustomMessageQueue.Entity			= CustomInvoiceLog.InvoiceType
									And		CustomMessageQueue.EntityID			= CustomInvoiceLog.InvoiceID
									)
				)
begin
	Delete	CustomInvoiceLog
	Where	Not Exists	(
						Select	1
						From	CustomMessageQueue (NoLock)
						Where	CustomMessageQueue.Entity			= CustomInvoiceLog.InvoiceType
						And		CustomMessageQueue.EntityID			= CustomInvoiceLog.InvoiceID
						)
End


While Exists (	Select	1
				From	CustomMessageQueue
						Inner Join SalesInvoiceHeader (NoLock)
							on	CustomMessageQueue.EntityID			= SalesInvoiceHeader.SlsInvceHdrID
							and	CustomMessageQueue.Entity			= 'SH'
				Where	SalesInvoiceHeader.SlsInvceHdrFdDte	< @sdt_CutoffDate
				)
begin
	Delete	CustomMessageQueue
	From	CustomMessageQueue
			Inner Join SalesInvoiceHeader (NoLock)
				on	CustomMessageQueue.EntityID			= SalesInvoiceHeader.SlsInvceHdrID
				and	CustomMessageQueue.Entity			= 'SH'
	Where	SalesInvoiceHeader.SlsInvceHdrFdDte	< @sdt_CutoffDate
End


While Exists (	Select	1
				From	CustomMessageQueue
						Inner Join PayableHeader (NoLock)
							on	CustomMessageQueue.EntityID			= PayableHeader.PybleHdrID
							and	CustomMessageQueue.Entity			= 'PH'
				Where	PayableHeader.FedDate				< @sdt_CutoffDate
			)
begin
	Delete	CustomMessageQueue
	From	CustomMessageQueue
			Inner Join PayableHeader (NoLock)
				on	CustomMessageQueue.EntityID			= PayableHeader.PybleHdrID
				and	CustomMessageQueue.Entity			= 'PH'
	Where	PayableHeader.FedDate				< @sdt_CutoffDate
End


While Exists (	Select	1
				From	CustomAccountDetail
				Where	CustomAccountDetail.AccntngPrdID	< @i_CutoffPeriodID
			)
begin
	Delete	CustomAccountDetail
	From	CustomAccountDetail
	Where	CustomAccountDetail.AccntngPrdID	< @i_CutoffPeriodID
End

Set Rowcount 0
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAPStaging_Purge]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAPStaging_Purge.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAPStaging_Purge >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAPStaging_Purge >>>'
	  END

