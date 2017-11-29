delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'OASProdComType'

DECLARE       @i_id  INT
exec   sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (      DynLstBxID
                           ,DynLstBxQlfr
                           ,DynLstBxTyp
                           ,DynLstBxDesc
                           ,DynLstBxAbbv
                           ,DynLstBxOrdr
                           ,DynLstBxTblTyp
                           ,DynLstBxStts )
       Values (@i_id, 
              'OASProdComType', 
              'N',
              'Consumption',
              'Consumption',
              '10',
              'V',
              'A')

GO

DECLARE       @i_id  INT
exec   sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (      DynLstBxID
                           ,DynLstBxQlfr
                           ,DynLstBxTyp
                           ,DynLstBxDesc
                           ,DynLstBxAbbv
                           ,DynLstBxOrdr
                           ,DynLstBxTblTyp
                           ,DynLstBxStts )
       Values (@i_id, 
              'OASProdComType', 
              'A',
              'Production',
              'Production',
              '20',
              'V',
              'A')
