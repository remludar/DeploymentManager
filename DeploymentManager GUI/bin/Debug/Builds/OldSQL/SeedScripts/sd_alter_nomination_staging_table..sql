if not exists ( select 'x' from syscolumns c, sysobjects o where o.id = c.id and o.name = 'mtvtmsnominationstaging'  and c.name = 'TMSNominationType'  )
alter table dbo.mtvtmsnominationstaging add  TMSNominationType varchar(100)


if not exists ( select 'x' from syscolumns c, sysobjects o where o.id = c.id and o.name = 'mtvtmsnominationstaging'  and c.name = 'sequence'  )
alter table dbo.mtvtmsnominationstaging add  sequence int null


