/*
If the Internal BA is "Motiva - Base Oils" on the Receipt Transfer and the deal type is Barge, Vessel, or Rail we need to exclude these from going to TMS Noms. 

If the Internal BA is "Motiva - Base Oils" on the Receipt Transfer and the MOT is equal to "Barge", "Vessel", "Rail", "Rail Delivery" , "Rail Pickup", "Vessel Delivery", or "Vessel Pickup".
select * from movementheadertype
select * from dynamiclistbox where dynlstbxqlfr = 'TransportationMethod'
*/
declare @dynlstbxid int
if not exists ( select 'x' from dynamiclistbox where dynlstbxqlfr = 'ExcludeTMSNomMot' )
begin
--delete from dynamiclistbox where dynlstbxqlfr = 'ExcludeTMSNomMot'
  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','G','Barge','Barge',10,'S','A'

   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','C','Railcar','Railcar',20,'S','A'

   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','D','Rail Delivery','Rail Delivery',30,'S','A'

  
   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','E','Rail Pickup','Rail Pickup',40,'S','A'

  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','A','As Directed','As Directed',50,'S','A'
  
 --  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
 -- insert into dynamiclistbox
 -- select @dynlstbxid, 'ExcludeTMSNomMot','I','Truck Pickup','Truck Pickup',60,'S','A'


   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','V','Vessel','Vessel',70,'S','A'

  
   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','J','Vessel Delivery','Vessel Delivery',80,'S','A'

  
   exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomMot','K','Vessel Pickup','Vessel Pickup',90,'S','A'


end
--select * from dynamiclistbox

if not exists (select 'x' from dynamiclistbox where DynLstBxQlfr = 'ExcludeTMSNomDeal')
begin
  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomDeal','G','Barge Deal','Barge Deal',10,'S','A'

  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomDeal','C','Railcar Deal','Railcar Deal',20,'S','A'

  exec sp_getkey 'dynamiclistbox', @dynlstbxid out
  insert into dynamiclistbox
  select @dynlstbxid, 'ExcludeTMSNomDeal','V','Vessel Deal','Vessel Deal',30,'S','A'

end