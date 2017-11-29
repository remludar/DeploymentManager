if (Object_Id('dbo.custom_sp_release_semaphore') IS NOT NULL)
Begin
	exec('Drop Procedure dbo.custom_sp_release_semaphore')
End
GO

Create Procedure dbo.custom_sp_release_semaphore 
		 @vc_name			varchar(50)
		,@vc_owner			varchar(80)		=NULL
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		custom_sp_release_semaphore           Copyright 2014 SolArc
-- Overview:	Releases a CustomSemaphore.  
--		Returns 1 if succesfully acquired, and 0 if it was unsuccessful.
--
-- Created by:	Scott Creed
-- History:		8/27/2014 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	
------------------------------------------------------------------------------------------------------------------------------
as

--Clear any processes with a lifetime that has expired
Delete	CustomSemaphore
where	HasLifetime = 1
And		GetDate() > DateAdd(ss,Lifetime, AcquiredDate)

Delete CustomSemaphore where Name = @vc_name and ISNULL(Owner,'') = ISNULL(@vc_Owner,'')
if @@rowcount = 1
begin
	select 1
	return
end
	
if Not Exists (select 1 from CustomSemaphore where Name = @vc_name)
begin
	select 1
	return
end

select 0
return
go

if object_id('dbo.custom_sp_release_semaphore') is null
 	Print 'Error creating Procedure: custom_sp_release_semaphore'
else
	Grant Execute on dbo.custom_sp_release_semaphore to RightAngleAccess,sysuser
go
