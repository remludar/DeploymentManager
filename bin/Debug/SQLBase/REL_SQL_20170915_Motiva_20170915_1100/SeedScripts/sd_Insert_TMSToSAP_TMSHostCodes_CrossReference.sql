delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'TMSHostCode'

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'04',
		'04 - Other',
		'04 - Other',
		'10',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'02',
		'02 - Wholesale',
		'02 - Wholesale',
		'20',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'03',
		'03 - Commercial',
		'03 - Commercial',
		'30',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'09',
		'09 - Commercial Contract',
		'09 - Commercial Contract',
		'40',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'01',
		'01 - Retail',
		'01 - Retail',
		'50',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'05',
		'05 - Aviation',
		'05 - Aviation',
		'60',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'06',
		'06 - Asphalt',
		'06 - Asphalt',
		'70',
		'V',
		'A')

GO