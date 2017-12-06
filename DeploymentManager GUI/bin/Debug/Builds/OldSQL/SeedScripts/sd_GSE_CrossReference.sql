
IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'GSE')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'GSE',
	NULL
)


DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'GSE'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Location')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Location','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'UOM')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'UOM',			'dddw.dddw_uom_desc_all.uomdesc.uom')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Product')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Product','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ShippingCondition')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'ShippingCondition','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'MaterialGroup')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'MaterialGroup','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ContractNumber')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'ContractNumber','dddw.dddw_dlhdrintrnlnmbr.dlhdrintrnlnbr.dlhdrid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'InternalBusinessAssociate')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'InternalBusinessAssociate','dddw.dddw_deal_data_internalbanme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'DealType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'DealType','dddw.dddw_deal_type.description.dltypid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'SalesContractType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'SalesContractType','dddw.dddw_deal_type.description.dltypid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'MovementTypeName')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'MovementTypeName','dddw.dddw_mvthdrtyp_nme.name.mvthdrtyp')
END


IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Partner')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Partner','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'DistributionChannel')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'DistributionChannel','dddw.dddw_banme.banme.baid')
END


IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Commodity')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Commodity','dddw.dddw_search_prdctabbrvtn.prdctabbv.prdctid')
END

