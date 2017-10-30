delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'SupplierNumber'

GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'SupplierNumber','02','Motiva','Motiva','10','S','A')
