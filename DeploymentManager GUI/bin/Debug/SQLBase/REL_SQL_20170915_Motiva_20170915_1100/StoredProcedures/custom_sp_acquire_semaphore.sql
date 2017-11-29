if (Object_Id('dbo.custom_sp_acquire_semaphore') IS NOT NULL)
Begin
	exec('Drop Procedure dbo.custom_sp_acquire_semaphore')
End
GO

Create Procedure dbo.custom_sp_acquire_semaphore 
		 @vc_name			varchar(80)
		,@vc_owner			varchar(80)		=NULL
		,@b_HasLifetime		bit				=0
		,@i_Lifetime		int				=0
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		custom_sp_acquire_semaphore           Copyright 2014 SolArc
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
Delete CustomSemaphore
where	HasLifetime = 1
And		GetDate() > DateAdd(ss,Lifetime, AcquiredDate)

MERGE
	dbo.CustomSemaphore as Target
Using (
	Values (@vc_name, @vc_owner, GetDate(), @b_HasLifetime, @i_Lifetime) ) As RequestedProcess (Name, Owner, AcquiredDate, HasLifetime, Lifetime)
On
	Target.Name	= RequestedProcess.Name
When Matched And RequestedProcess.Owner IS NOT NULL And Target.Owner = RequestedProcess.Owner Then
	Update Set Owner = RequestedProcess.Owner, AcquiredDate = RequestedProcess.AcquiredDate, HasLifetime = RequestedProcess.HasLifetime, Lifetime = RequestedProcess.Lifetime
When Not Matched Then
	Insert (Name, Owner, AcquiredDate, HasLifetime, Lifetime)
	Values (RequestedProcess.Name, RequestedProcess.Owner, RequestedProcess.AcquiredDate, RequestedProcess.HasLifetime, RequestedProcess.Lifetime)
	;--Semicolon required for MERGE

select @@rowcount
go

if object_id('dbo.custom_sp_acquire_semaphore') is null
 	Print 'Error creating Procedure: custom_sp_acquire_semaphore'
else
	Grant Execute on dbo.custom_sp_acquire_semaphore to RightAngleAccess,sysuser
go
