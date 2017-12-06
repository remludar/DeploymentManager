If exists(select * from dbo.registry R where R.RgstryFllKyNme = 'Motiva\OAS\StockUpload\')
  delete from  dbo.registry where RgstryFllKyNme = 'Motiva\OAS\StockUpload\'
If exists(select * from dbo.registry R where R.RgstryFllKyNme = 'Motiva\OAS\StockUpload\ImportPath\')
  delete from  dbo.registry where RgstryFllKyNme = 'Motiva\OAS\StockUpload\ImportPath\'
