IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'EMPTORIS')
INSERT INTO SourceSystem (Name,SrceSystmObjct) VALUES ('EMPTORIS',NULL)

DECLARE @SourceSystemID INT,@ElementID INT,@KeyID INT
SELECT @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'EMPTORIS'

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ArchiveSendTemplates')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'ArchiveSendTemplates','y/n')
END