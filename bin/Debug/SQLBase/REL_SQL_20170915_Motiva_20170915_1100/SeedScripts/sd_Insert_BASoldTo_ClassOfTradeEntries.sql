delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'BASoldToClassOfTrade'

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
		'BASoldToClassOfTrade', 
		'00',
		'All Other Values',
		'All Other Values',
		'80',
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
		'BASoldToClassOfTrade', 
		'01',
		'Branded Wholesaler',
		'Branded Wholesaler',
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
		'BASoldToClassOfTrade', 
		'02',
		'Unbranded Fuel Rack Reseller',
		'Unbranded Fuel Rack Reseller',
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
		'BASoldToClassOfTrade', 
		'03',
		'Unbranded Fuel Rack Customer/End User',
		'Unbranded Fuel Rack Customer/End User',
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
		'BASoldToClassOfTrade', 
		'05',
		'Unbranded Contract Reseller',
		'Unbranded Contract Reseller',
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
		'BASoldToClassOfTrade', 
		'06',
		'Unbranded Contract End User',
		'Unbranded Contract End User',
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
		'BASoldToClassOfTrade', 
		'07',
		'STL',
		'STL',
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
		'BASoldToClassOfTrade', 
		'08',
		'Base Oils',
		'Base Oils',
		'70',
		'V',
		'A')

GO
