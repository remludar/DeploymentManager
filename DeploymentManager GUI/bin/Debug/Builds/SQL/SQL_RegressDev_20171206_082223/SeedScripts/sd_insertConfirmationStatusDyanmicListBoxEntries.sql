delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'ConfirmationStatus'

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
		'ConfirmationStatus', 
		'N',
		'New',
		'New',
		'10',
		'S',
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
		'ConfirmationStatus', 
		'S',
		'Sent',
		'Sent',
		'20',
		'S',
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
		'ConfirmationStatus', 
		'E',
		'Error',
		'Error',
		'30',
		'S',
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
		'ConfirmationStatus', 
		'C',
		'Confirmed',
		'Confirmed',
		'40',
		'S',
		'A')

