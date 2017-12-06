If OBJECT_ID('dbo.Custom_Message_Queue_Processor') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Message_Queue_Processor
    PRINT '<<< DROPPED PROC dbo.Custom_Message_Queue_Processor >>>'
End
Go  

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Message_Queue_Processor]
AS
set NOCOUNT on
-- =============================================
-- Author:        J. von Hoff
-- Create date:	  18NOV2016
-- Description:   Process items from the CustomMessageQueue table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

---------------------------------------------
-- Check the process out
---------------------------------------------
Declare @i_checkoutStatus int
Exec @i_checkoutStatus = dbo.sra_checkout_process 'CustomMessageQueueProcessor'

if @i_checkoutStatus = 0
	return

---------------------------------------------
-- Grab the oldest 500 to process
---------------------------------------------
Select	TOP 500 ID, Entity, Reprocess
into	#CMQtoProcess
From	CustomMessageQueue (NoLock)
Where	RAProcessed = 0 or Reprocess = 1
Order by ID

declare @i_ID int
declare @vc_Type varchar(100)
declare @i_Reprocess int
declare @vc_error varchar(1000)

select @i_ID = min(ID) From #CMQtoProcess

---------------------------------------------
-- While you have one to process try looping
---------------------------------------------
While IsNull(@i_ID, 0) > 0
begin try
	select @vc_Type = Entity, @i_Reprocess = Reprocess From #CMQtoProcess Where ID = @i_ID
	if	@vc_Type = 'PH'
	begin
		select @vc_error = 'execute Custom_Interface_AP_Outbound ' + convert(varchar, @i_ID) + ' ' + convert(varchar, @i_Reprocess)
		--RAISERROR(@vc_error, 10, 1) with nowait
		execute Custom_Interface_AP_Outbound @i_ID, @i_Reprocess
	end
	else if	@vc_Type = 'SH'
	begin
		select @vc_error = 'execute Custom_Interface_AR_Outbound ' + convert(varchar, @i_ID) + ' ' + convert(varchar, @i_Reprocess)
		--RAISERROR(@vc_error, 10, 1) with nowait
		execute Custom_Interface_AR_Outbound @i_ID, @i_Reprocess
	end
	else if	@vc_Type = 'GL'
	begin
		select @vc_error = 'execute Custom_Interface_GL_Outbound ' + convert(varchar, @i_ID) + ' ' + convert(varchar, @i_Reprocess)
		--RAISERROR(@vc_error, 10, 1) with nowait
		execute Custom_Interface_GL_Outbound @i_ID, @i_Reprocess
	end
	else
	begin
		select @vc_error = 'could not determine the entity'
		--RAISERROR(@vc_error, 10, 1) with nowait
	end

	delete #CMQtoProcess Where ID = @i_ID
	select @i_ID = min(ID) From #CMQtoProcess
	select @vc_error = IsNull(@i_ID, 0)
	-- RAISERROR(@vc_error, 10, 1) with nowait

end try

---------------------------------------------
-- Catch any errors
---------------------------------------------
begin catch
	if object_id('tempdb..#CMQtoProcess') is not null
		Drop Table #CMQtoProcess

	exec dbo.sra_checkin_process 'CustomMessageQueueProcessor'
end catch

---------------------------------------------
-- Check the process back in for next time
---------------------------------------------
if object_id('tempdb..#CMQtoProcess') is not null
	Drop Table #CMQtoProcess

exec dbo.sra_checkin_process 'CustomMessageQueueProcessor'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Message_Queue_Processor') Is NOT Null
BEGIN
	PRINT '<<< Granted Rights on PROC dbo.Custom_Message_Queue_Processor >>>'
	Grant Execute on dbo.Custom_Message_Queue_Processor to SYSUSER
	Grant Execute on dbo.Custom_Message_Queue_Processor to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Message_Queue_Processor >>>'
GO