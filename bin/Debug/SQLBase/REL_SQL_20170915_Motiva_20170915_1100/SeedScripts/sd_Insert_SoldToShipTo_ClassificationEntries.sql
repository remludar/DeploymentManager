delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'ShipToClassification'

--Depricated, BASoldTo ClassOfTrade field now dictates this


--DECLARE	@i_id	INT
--exec	sp_getkey 'dynamiclistbox', @i_id OUT
--insert into dynamiclistbox (	DynLstBxID
--				,DynLstBxQlfr
--				,DynLstBxTyp
--				,DynLstBxDesc
--				,DynLstBxAbbv
--				,DynLstBxOrdr
--				,DynLstBxTblTyp
--				,DynLstBxStts )
--	Values (@i_id, 
--		'ShipToClassification', 
--		'BO',
--		'Base Oil',
--		'Base Oil',
--		'10',
--		'S',
--		'A')

--GO

--DECLARE	@i_id	INT
--exec	sp_getkey 'dynamiclistbox', @i_id OUT
--insert into dynamiclistbox (	DynLstBxID
--				,DynLstBxQlfr
--				,DynLstBxTyp
--				,DynLstBxDesc
--				,DynLstBxAbbv
--				,DynLstBxOrdr
--				,DynLstBxTblTyp
--				,DynLstBxStts )
--	Values (@i_id, 
--		'ShipToClassification', 
--		'SU',
--		'Supply',
--		'Supply',
--		'20',
--		'S',
--		'A')

--GO
		
--DECLARE	@i_id	INT
--exec	sp_getkey 'dynamiclistbox', @i_id OUT
--insert into dynamiclistbox (	DynLstBxID
--				,DynLstBxQlfr
--				,DynLstBxTyp
--				,DynLstBxDesc
--				,DynLstBxAbbv
--				,DynLstBxOrdr
--				,DynLstBxTblTyp
--				,DynLstBxStts )
--	Values (@i_id, 
--		'ShipToClassification', 
--		'FSM',
--		'FSM',
--		'FSM',
--		'30',
--		'S',
--		'A')

--GO
		