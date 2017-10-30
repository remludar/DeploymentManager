Declare	 @vc_SrceSystmNme	varchar(30)
Declare  @i_SrceSystmElmntXrfID  int
Declare  @i_SrceSystmID          int

Set	@vc_SrceSystmNme	= 'IntrnlBAClassOfTrade'  --ONLY CHANGE XXXXX to abbreviation for company being loaded.
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


Select	@i_Key = SrceSystmElmntID
	From	SourceSystemElement (NoLock)
	Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
	And	SourceSystemElement.ElementName = 'InternalBA'

IF (@i_Key Is Null)
BEGIN
	--External BA Name
	execute sp_getkey @vc_TbleNme = 'SourceSystemElement', @i_Ky = @i_Key OUT, @i_increment = 1
	--CompanyID
	Insert	SourceSystemElement
		(
		SourceSystemElement. SrceSystmElmntID,
		SourceSystemElement. SrceSystmID,
		SourceSystemElement. ElementName,
		SourceSystemElement. DisplayStyle
		)
	Select	@i_Key,
		@i_SrceSystmID,
		'InternalBA',
		'dddw.dddw_credit_baname_internal.banme.baid'
	Where	Not Exists
		(
		Select	1
		From	SourceSystemElement (NoLock)
		Where	SourceSystemElement.SrceSystmID = @i_SrceSystmID
		And	SourceSystemElement.ElementName = 'InternalBA'
		)
END


--INSERT SOURCESYSTEM ELEMENT XREFS
Declare @XRef_Key	Int

execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'01',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '01'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'02',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '02'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'03',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '03'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'04',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '04'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'05',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '05'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'06',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '06'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'07',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 'MOTIVA-STL'),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '07'
	)
And Exists
	(
		Select 1
		From BusinessAssociate (NOLOCK)
		Where Name = 'MOTIVA-STL'
	)


execute sp_getkey @vc_TbleNme = 'SourceSystemElementXref', @i_Ky = @XRef_Key OUT, @i_increment = 1

Insert SourceSystemElementXref(
	SrceSystmElmntXrfID,
	SrceSystmElmntID,
	ElementValue,
	InternalValue,
	ElementDirection,
	StartDate,
	EndDate
	)
Select @XRef_Key,
	@i_Key,
	'08',
	(Select Convert(varchar, BAID) from BusinessAssociate where Name = 
		(Select dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'))),
	'I',
	'1970-01-01',
	'2049-12-31 23:59'
Where Not Exists 
	(
		Select 1
		From SourceSystemElementXref (NOLOCK)
		Where SourceSystemElementXref.SrceSystmElmntID = @i_Key
		And	SourceSystemElementXref.ElementValue = '08'
	)