DECLARE @CoreFixed CHAR(1)
SELECT	@CoreFixed = 'N'

IF @CoreFixed = 'N'
BEGIN
	UPDATE	Module
	SET		Module.MdleParentMdleID = 301
	WHERE	Module.MdleParentMdleID IN (298)
END
