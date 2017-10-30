
IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'T4Nomination')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'T4Nomination',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'T4Nomination'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Supplier')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Supplier','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Consignee')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Consignee','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Tankage')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Tankage','dddw.dddw_banme.banme.baid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Location')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Location','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Shipper')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Shipper','dddw.dddw_banme.banme.baid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Carrier')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Carrier','dddw.dddw_banme.banme.baid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Product')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Product','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'UOM')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'UOM','dddw.dddw_uom_desc_all.uomdesc.uom')
END



