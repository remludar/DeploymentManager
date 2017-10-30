Declare	 @vc_SrceSystmNme	varchar(30)
Declare  @i_SrceSystmElmntXrfID  int
Declare  @i_SrceSystmID          int

Set	@vc_SrceSystmNme	= 'OSP'  --ONLY CHANGE XXXXX to abbreviation for company being loaded.
											 --EXAMPLE:  PaybleXML_FloridaRack

Insert	SourceSystem
	(
	SourceSystem. Name,
	SourceSystem. SrceSystmObjct
	)
Select	@vc_SrceSystmNme,
	Null
Where	Not Exists
	(
	Select	1
	From	SourceSystem (NoLock)
	Where	SourceSystem.Name = @vc_SrceSystmNme
	)

-- Get the ID associated with the new record 

Select @i_SrceSystmID = SrceSystmID
From   SourceSystem
Where  Name = @vc_SrceSystmNme

-- Make this SourceSytem available in the dropdown list for Search InterfaceData

EXEC sp_getkey 'SourceSystemElementXRef', @i_SrceSystmElmntXrfID out

IF	(SELECT ElementValue FROM SourceSystemElementXRef WHERE ElementValue = @vc_SrceSystmNme) IS NULL
BEGIN
	INSERT INTO SourceSystemElementXRef
	( SrceSystmElmntXRfID
	, SrceSystmElmntID
	, ElementValue
	, InternalValue
	, ElementDirection
	, StartDate
	, EndDate) 
	VALUES
	( @i_SrceSystmElmntXrfID
	, 65
	, @vc_SrceSystmNme
	, Convert(varchar,@i_SrceSystmID)
	, 'I'
	, '1970-01-01'
	, '2049-12-31 23:59')
END
ELSE
PRINT 'SourceSystemElementXRef Already Exists'  

--INSERT SOURCESYSTEM ELEMENTS
Declare @i_Key		Int

--PartnerFrom
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'PartnerFrom',
	'dddw.dddw_banme.banme.baid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'PartnerFrom'
	)

--PartnerTo
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'PartnerTo',
	'dddw.dddw_banme.banme.baid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'PartnerTo'
	)

--ShipTo
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'ShipTo',
	'dddw.dddw_banme.banme.baid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'ShipTo'
	)

--Vendor
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'Vendor',
	'dddw.dddw_banme.banme.baid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'Vendor'
	)

--Vendor
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'SoldTo',
	'dddw.dddw_banme.banme.baid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'SoldTo'
	)

--DocumentNumber
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1

Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'DocumentNumber',
	'x'
Where	Not Exists
	(
	Select	*
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'DocumentNumber'
	)

--LoadDepot
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'LoadDepot',
	'dddw.dddw_lclenme.lclenme.lcleid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'LoadDepot'
	)

--StLoc
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'StLoc',
	'dddw.dddw_lclenme.lclenme.lcleid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'StLoc'
	)

--ProductCode
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'ProductCode',
	'dddw.dddw_prdctnme_all.prdctnme.prdctid'
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'ProductCode'
	)

--Carrier
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'Carrier',
	'dddw.dddw_carrierbas.banme.baid'
Where	Not Exists
	(
	Select	*
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'Carrier'
	)

--Carrier
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'UnitOfMeasure',
	'dddw.dddw_uom_desc_all.UOMDesc.UOM'
Where	Not Exists
	(
	Select	*
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'UnitOfMeasure'
	)

--Carrier
execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
Insert	SourceSystemElement
	(
	SourceSystemElement. SrceSystmElmntID,
	SourceSystemElement. SrceSystmID,
	SourceSystemElement. ElementName,
	SourceSystemElement. DisplayStyle
	)
Select	@i_Key,
	@i_SrceSystmID,
	'ModeOfTransport',
	'dddw.dddw_mvthdrtyp_nme.Name.MvtHdrTyp'
Where	Not Exists
	(
	SELECT *
	From	SourceSystemElement
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'ModeOfTransport'
	)
