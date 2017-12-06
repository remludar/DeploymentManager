

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'BBL' From UnitOfMeasure Where UOMAbbv = 'bbl'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'BB6' From UnitOfMeasure Where UOMAbbv = 'bbl60'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'FT3' From UnitOfMeasure Where UOMAbbv = 'CuFt'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'UGL' From UnitOfMeasure Where UOMAbbv = 'gal'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'GAL' From UnitOfMeasure Where UOMAbbv = 'gal60'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'KG' From UnitOfMeasure Where UOMAbbv = 'KG'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'LB' From UnitOfMeasure Where UOMAbbv = 'Lbs'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'LTO' From UnitOfMeasure Where UOMAbbv = 'LngTon'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'L' From UnitOfMeasure Where UOMAbbv = 'ltr'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'L15' From UnitOfMeasure Where UOMAbbv = 'Ltr15'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'L30' From UnitOfMeasure Where UOMAbbv = 'Ltr30'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'M15' From UnitOfMeasure Where UOMAbbv = 'M15'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'M3' From UnitOfMeasure Where UOMAbbv = 'M3'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'TO' From UnitOfMeasure Where UOMAbbv = 'MT'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

Insert	GeneralConfiguration (GnrlCnfgTblNme,GnrlCnfgQlfr,GnrlCnfgHdrID,GnrlCnfgDtlID,GnrlCnfgMulti)
Select	'UnitOfMeasure', 'SAPUOMAbbv', UOM, 0, 'TON' From UnitOfMeasure Where UOMAbbv = 'ShrtTon'
		and not exists (select 1 from GeneralConfiguration where GnrlCnfgTblNme='UnitOfMeasure' and GnrlCnfgQlfr='SAPUOMAbbv' and GnrlCnfgHdrID = UOM)

