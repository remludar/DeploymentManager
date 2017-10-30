delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'SAPIntCoID'

GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'SAPIntCoID','USK7','USK7','USK7','10','S','A')
