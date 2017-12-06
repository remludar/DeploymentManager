Declare	 @vc_SrceSystmNme	varchar(30)
Declare  @i_SrceSystmElmntXrfID  int
Declare  @i_SrceSystmID          int

Set	@vc_SrceSystmNme	= 'FPS'  --ONLY CHANGE XXXXX to abbreviation for company being loaded.
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

-- DistributionChannel
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
	'DistributionChannel',
	'dddw.dddw_search_rawpriceheaderabbv.RPHdrAbbv.RPHdrID' --select * from SourceSystemElement
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'DistributionChannel'
	)

-- Currency
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
	'Currency',
	'dddw.dddw_crrncy.crrncynme.crrncyid' --select * from SourceSystemElement
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'Currency'
	)

-- Unit of Measure
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
	'UnitofMeasure',
	'dddw.dddw_uom_desc_all.uomdesc.uom' --select * from SourceSystemElement
Where	Not Exists
	(
	Select	1
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'UnitofMeasure'
	)
