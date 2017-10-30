delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'TaxpayerIDType'

GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'TaxpayerIDType','F','FEIN','FEIN','10','S','A')
GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'TaxpayerIDType','S','SSN','SSN','20','S','A')
GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'TaxpayerIDType','C','CustomFederalTaxId','CustomFederalTaxId','30','S','A')

