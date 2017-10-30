Declare @i_Key		Int

execute sp_getkey @vc_TbleNme = 'LibraryPath', @i_Ky = @i_Key OUT, @i_increment = 1

INSERT	LibraryPath
SELECT	@i_Key
		,'mtv_customobjects.pbl'
		,200
		,'RightAngle'
WHERE	NOT EXISTS (SELECT * FROM LibraryPath WHERE LbrryPthPBDNme = 'mtv_customobjects.pbl')

GO

Declare @i_Key		Int

execute sp_getkey @vc_TbleNme = 'LibraryPath', @i_Ky = @i_Key OUT, @i_increment = 1

INSERT	LibraryPath
SELECT	@i_Key
		,'mtv_invoices.pbl'
		,300
		,'RightAngle'
WHERE	NOT EXISTS (SELECT * FROM LibraryPath WHERE LbrryPthPBDNme = 'mtv_invoices.pbl')
GO


SELECT	*
FROM	LibraryPath
