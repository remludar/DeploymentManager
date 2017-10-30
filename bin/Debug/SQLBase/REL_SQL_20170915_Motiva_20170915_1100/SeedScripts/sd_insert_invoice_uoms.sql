--select * from registry where RgstryFllKyNme
if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMQttyDecimals\Ton\' )   
   exec sp_set_registry_value 'System\SalesInvoicing\UOMQttyDecimals\Ton\', '0'

if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMPrceDecimals\Ton\' )
   exec sp_set_registry_value 'System\SalesInvoicing\UOMPrceDecimals\Ton\', '0'




if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMPrceDecimals\RINS\' )
   exec sp_set_registry_value 'System\SalesInvoicing\UOMQttyDecimals\RINS\', '0'
go



if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMPrceDecimals\RINS\' )
   exec sp_set_registry_value 'System\SalesInvoicing\UOMPrceDecimals\RINS\', '5'
go





if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMPrceDecimals\M3\' ) 
   exec sp_set_registry_value 'System\SalesInvoicing\UOMQttyDecimals\M3\', '2'
go



if not exists ( select 'x' from registry where RgstryFllKyNme = 'System\SalesInvoicing\UOMPrceDecimals\M3\' ) 
   exec sp_set_registry_value 'System\SalesInvoicing\UOMPrceDecimals\M3\', '5'
go
