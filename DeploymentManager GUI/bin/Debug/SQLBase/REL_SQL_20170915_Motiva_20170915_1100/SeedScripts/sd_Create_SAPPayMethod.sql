if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSAPAPStaging' and sc.name = 'PaymentMethod')
begin
	alter table MTVSAPAPStaging add PaymentMethod char(1)
	print 'Column added'
end

if not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme = 'Term' and GnrlCnfgQlfr = 'SAPPayMethod')
begin
	insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
	Values	('Term', 'SAPPayMethod', 0, 0, 'X')

	print 'Attribute added'
end

-- delete generalconfiguration where gnrlcnfgqlfr = 'sappaymethod'
-- alter table mtvsapapstaging drop column paymentmethod