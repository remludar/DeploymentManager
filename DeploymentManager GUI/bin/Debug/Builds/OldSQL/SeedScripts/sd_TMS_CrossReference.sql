IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'TMS')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'TMS',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'TMS'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Company')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Company','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Product')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Product','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Location')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Location',			'dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid'		)

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'UOM')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'UOM',			'dddw.dddw_uom_desc_all.uomdesc.uom')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'MovementHeaderType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'MovementHeaderType',			'dddw.dddw_mvthdrtyp_nme.Name.MvtHdrTyp')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'TempScale')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'TempScale',			'X')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Carrier')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Carrier',			'dddw.dddw_banme.banme.baid')
END