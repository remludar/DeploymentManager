IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'OAS')
INSERT INTO SourceSystem
(
	Name,
	SrceSystmObjct
)
VALUES
(
	'OAS',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'OAS'

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Carrier')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Carrier','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Company')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Company','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Sender')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Sender','dddw.dddw_banme.banme.baid')
END

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
	VALUES (	@KeyID, @SourceSystemID,'UOM','dddw.dddw_uom_desc_all.uomdesc.uom')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'OverridePlantCode')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'OverridePlantCode','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'MethodOfTransportation')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'MethodOfTransportation','dddw.dddw_mvthdrtyp_nme.name.mvthdrtyp')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'TolerancePercentage')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'TolerancePercentage','dddw.dddw_intrnlbamthdtrans.text.value')
END



IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ShipmentType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'ShipmentType','dddw.dddw_deal_transportationtype.DynSnglLstBxDesc.DynSnglLstBxSnglChrTyp')

	DECLARE @SrceSystemElementID INT
	SELECT @SrceSystemElementID = sse.SrceSystmElmntID FROM SourceSystemElement sse INNER JOIN SourceSystem ss ON sse.SrceSystmID = ss.SrceSystmID
		WHERE ss.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ShipmentType'

	Declare  @i_SrceSystmElmntXrfID  int


	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'G', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'V', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'J', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'K', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'P', 'P', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'R', 'T', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'H', 'T', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'I', 'T', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'C', 'R', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'D', 'R', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'E', 'R', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'NodeType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'NodeType','dddw.dddw_deal_transportationtype.DynSnglLstBxDesc.DynSnglLstBxSnglChrTyp')

	SELECT @SrceSystemElementID = sse.SrceSystmElmntID FROM SourceSystemElement sse INNER JOIN SourceSystem ss ON sse.SrceSystmID = ss.SrceSystmID
		WHERE ss.SrceSystmID = @SourceSystemID AND sse.ElementName = 'NodeType'
	

	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'G', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'V', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'J', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'K', 'V', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'P', 'PI', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'R', 'RO', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'H', 'RO', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'I', 'RO', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'C', 'RA', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'D', 'RA', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
	EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out
	INSERT INTO SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, InternalValue, ElementValue, ElementDirection, StartDate, EndDate)
	VALUES (@i_SrceSystmElmntXrfID, @SrceSystemElementID, 'E', 'RA', 'O', '1970-01-01 00:00:00.000', '2049-12-31 23:59:00.000')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'BusinessAssociate')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'BusinessAssociate','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'MovementType')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'MovementType','dddw.dddw_mvthdrtyp_nme.name.mvthdrtyp')
END

/* --OAS Actual
IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'OASActual')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'OASActual',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'OASActual'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Sender')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Sender','dddw.dddw_banme.banme.baid')
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
	VALUES (	@KeyID, @SourceSystemID,'Location','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'UOM')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'UOM','dddw.dddw_uom_desc_all.uomdesc.uom')
END


IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Contact')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Contact','dddw.dddw_banme.banme.baid')
END
*/



/* OAS Inventory

IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'OASInventory')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'OASInventory',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'OASInventory'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Sender')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Sender','dddw.dddw_banme.banme.baid')
END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Location')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Location','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Contact')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Contact','dddw.dddw_banme.banme.baid')
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
*/

/* OAS Production Consumption

IF NOT EXISTS(SELECT 1 from SourceSystem where Name = 'OASProductionConsumption')
INSERT INTO SourceSystem
(
	-- SrceSystmID -- this column value is auto-generated
	Name,
	SrceSystmObjct
)
VALUES
(
	'OASProductionConsumption',
	NULL
)

DECLARE @SourceSystemID INT
	    ,@KeyID INT
select @SourceSystemID = ss.SrceSystmID FROM SourceSystem AS ss WHERE ss.Name = 'OASProductionConsumption'
   

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'LocationBAID')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'LocationBAID','dddw.dddw_banme.banme.baid')
END
IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'ProdConLocation')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'ProdComLocation','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')

END

IF NOT EXISTS (SELECT 1 FROM SourceSystemElement AS sse WHERE sse.SrceSystmID = @SourceSystemID AND sse.ElementName = 'Location')
BEGIN
	exec sp_getkey 'SourceSystemElement', @KeyID OUTPUT	    
	INSERT INTO SourceSystemElement(	SrceSystmElmntID,	SrceSystmID,	ElementName,	DisplayStyle)
	VALUES (	@KeyID, @SourceSystemID,'Location','dddw.dddw_lcleabbrvtn.lcleabbrvtn.lcleid')

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
*/





