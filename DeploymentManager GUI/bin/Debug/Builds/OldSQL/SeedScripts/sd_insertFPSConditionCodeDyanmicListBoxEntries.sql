delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'FPSConditionType'

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
		'FPSConditionType', 
		'YP02',
		'YP02',
		'YP02',
		'10',
		'M',
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
		'FPSConditionType', 
		'YP06',
		'YP06',
		'YP06',
		'20',
		'M',
		'A')

GO

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT01')
BEGIN
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
		'FPSConditionType', 
		'YT01',
		'YT01',
		'YT01',
		'35',
		'M',
		'A')
END		
GO

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT02' )
BEGIN
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
		'FPSConditionType', 
		'YT02',
		'YT02',
		'YT02',
		'40',
		'M',
		'A')
END		
GO	

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT03' )
BEGIN
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
		'FPSConditionType', 
		'YT03',
		'YT03',
		'YT03',
		'45',
		'M',
		'A')
END		
GO

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT04')
BEGIN
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
		'FPSConditionType', 
		'YT04',
		'YT04',
		'YT04',
		'50',
		'M',
		'A')
END		
GO	

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT05' )
BEGIN
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
		'FPSConditionType', 
		'YT05',
		'YT05',
		'YT05',
		'55',
		'M',
		'A')
END		
GO	
	
	
IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT06' )
BEGIN
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
		'FPSConditionType', 
		'YT06',
		'YT06',
		'YT06',
		'60',
		'M',
		'A')
END		
GO			

IF NOT EXISTS(SELECT * FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT07' )
BEGIN
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
		'FPSConditionType', 
		'YT07',
		'YT07',
		'YT07',
		'65',
		'M',
		'A')
END		
GO	

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT08')
BEGIN
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
		'FPSConditionType', 
		'YT08',
		'YT08',
		'YT08',
		'70',
		'M',
		'A')
END		
GO	

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT09' )
BEGIN
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
		'FPSConditionType', 
		'YT09',
		'YT09',
		'YT09',
		'75',
		'M',
		'A')
END		
GO	

IF NOT EXISTS(SELECT 1 FROM DynamicListBox AS dlb WHERE dlb.DynLstBxQlfr = 'FPSConditionType' AND dlb.DynLstBxTyp = 'YT10' )
BEGIN
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
		'FPSConditionType', 
		'YT10',
		'YT10',
		'YT10',
		'80',
		'M',
		'A')
END		
GO
