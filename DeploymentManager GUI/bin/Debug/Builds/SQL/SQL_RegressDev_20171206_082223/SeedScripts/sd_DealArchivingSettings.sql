UPDATE dt SET LegalTextPrintable = 'Y',AmendmentPrintable = 'Y'
FROM DealType dt
WHERE dt.Description IN ('Purchase Deal','Sale Deal','Rack Sale Deal','Exchange Deal','EFP Deal','Future Inhouse Deal','Swap Inhouse Deal','Option Inhouse Deal','Inhouse Deal','Buy/Sell Deal','Future Deal')

UPDATE DealDetailTemplate SET CriticalColumnList = 'dldtlfrmdte,dldtltodte,tradingprdctid,dldtlqntty,dldtllcleid,dldtltrmtrmid,revisioncomment,dldtlstat,dldtlapprxmteqntty,volumetolerancedirection,volumetolerancequantity' WHERE DlDtlTmplteID = 30000
UPDATE DealDetailTemplate SET CriticalColumnList = 'dldtlfrmdte,dldtltodte,dldtlprdctid,dldtlqntty,dldtllcleid,dldtltrmtrmid,revisioncomment,dldtlstat,dldtlapprxmteqntty,volumetolerancedirection,volumetolerancequantity' WHERE DlDtlTmplteID = 30001