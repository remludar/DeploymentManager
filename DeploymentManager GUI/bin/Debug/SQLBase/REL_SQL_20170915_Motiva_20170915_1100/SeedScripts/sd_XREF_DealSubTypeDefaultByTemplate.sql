IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'MOTIVA')
INSERT INTO SourceSystem (Name,SrceSystmObjct) VALUES ('MOTIVA',NULL)

DECLARE @SourceSystemID INT,@KeyID INT
SELECT @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'MOTIVA'

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'DealSubTypeDefault')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'DealSubTypeDefault','dddw.dddw_deal_subtypes.Name.DynLstBxTyp')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'DefaultUOM')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (@KeyID, @SourceSystemID,'DefaultUOM','dddw.dddw_uom_desc_all.uomdesc.uom')
END