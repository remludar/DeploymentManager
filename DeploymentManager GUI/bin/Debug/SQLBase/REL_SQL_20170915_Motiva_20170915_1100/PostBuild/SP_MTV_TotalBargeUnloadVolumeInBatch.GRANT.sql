
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_TotalBargeUnloadVolumeInBatch]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_TotalBargeUnloadVolumeInBatch] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_TotalBargeUnloadVolumeInBatch] to sysuser, RightAngleAccess
End
go
