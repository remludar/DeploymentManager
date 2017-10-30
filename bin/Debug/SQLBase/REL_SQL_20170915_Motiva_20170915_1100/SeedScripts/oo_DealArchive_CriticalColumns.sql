UPDATE DealHeaderTemplate
SET CriticalColumnList = RTRIM(CriticalColumnList) +
CASE WHEN LEN(CriticalColumnList) > 0 THEN
(
	CASE WHEN CriticalColumnList not like '%DlHdrStat%' THEN ',DlHdrStat' ELSE '' END +
	CASE WHEN CriticalColumnList not like '%DlHdrFrmDte%' THEN ',DlHdrFrmDte' ELSE '' END +
	CASE WHEN CriticalColumnList not like '%DlHdrToDte%' THEN ',DlHdrToDte' ELSE '' END
)
ELSE
(
	SUBSTRING(
		CASE WHEN CriticalColumnList not like '%DlHdrStat%' THEN 'DlHdrStat,' ELSE '' END +
		CASE WHEN CriticalColumnList not like '%DlHdrFrmDte%' THEN 'DlHdrFrmDte,' ELSE '' END +
		CASE WHEN CriticalColumnList not like '%DlHdrToDte%' THEN 'DlHdrToDte,' ELSE '' END
		,0
		,LEN(CASE WHEN CriticalColumnList not like '%DlHdrStat%' THEN 'DlHdrStat,' ELSE '' END +
		CASE WHEN CriticalColumnList not like '%DlHdrFrmDte%' THEN 'DlHdrFrmDte,' ELSE '' END +
		CASE WHEN CriticalColumnList not like '%DlHdrToDte%' THEN 'DlHdrToDte,' ELSE '' END)
	)
)
END
FROM DealHeaderTemplate
WHERE DlTypID in (100, 74, 20, 70, 76, 80, 1, 2, 72, 77)

UPDATE DealDetailTemplate
SET CriticalColumnList = REPLACE(RTRIM(DDT.CriticalColumnList), 'revisioncomment,', '')
FROM DealDetailTemplate DDT
INNER JOIN DealHeaderTemplate DHT
ON DDT.DlHdrTmplteID = DHT.DlHdrTmplteID
WHERE DHT.DlTypID in (100, 74, 20, 70, 76, 80, 1, 2, 72, 77)

UPDATE DealDetailTemplate
SET CriticalColumnList = RTRIM(DDT.CriticalColumnList) +
CASE WHEN LEN(DDT.CriticalColumnList) > 0 THEN
(
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlStat%' THEN ',DlDtlStat' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlFrmDte%' THEN ',DlDtlFrmDte' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlToDte%' THEN ',DlDtlToDte' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlQntty%' THEN ',DlDtlQntty' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlDsplyUOM%' THEN ',DlDtlDsplyUOM' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%ToleranceWhoseOption%' THEN ',ToleranceWhoseOption' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlVlmeTrmTpe%' THEN ',DlDtlVlmeTrmTpe' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%SchedulingQuantityTerm%' THEN ',SchedulingQuantityTerm' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlTrmTrmID%' THEN ',DlDtlTrmTrmID' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DeliveryTermID%' THEN ',DeliveryTermID' ELSE '' END +
	CASE WHEN DDT.CriticalColumnList not like '%DlDtlLcleID%' THEN ',DlDtlLcleID' ELSE '' END
)
ELSE 
(
	SUBSTRING(
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlStat%' THEN 'DlDtlStat,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlFrmDte%' THEN 'DlDtlFrmDte,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlToDte%' THEN 'DlDtlToDte,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlQntty%' THEN 'DlDtlQntty,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlDsplyUOM%' THEN 'DlDtlDsplyUOM,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%ToleranceWhoseOption%' THEN 'ToleranceWhoseOption,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlVlmeTrmTpe%' THEN 'DlDtlVlmeTrmTpe,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%SchedulingQuantityTerm%' THEN 'SchedulingQuantityTerm,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlTrmTrmID%' THEN 'DlDtlTrmTrmID,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DeliveryTermID%' THEN 'DeliveryTermID,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlLcleID%' THEN 'DlDtlLcleID,' ELSE '' END
		,0
		,LEN(CASE WHEN DDT.CriticalColumnList not like '%DlDtlStat%' THEN 'DlDtlStat,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlFrmDte%' THEN 'DlDtlFrmDte,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlToDte%' THEN 'DlDtlToDte,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlQntty%' THEN 'DlDtlQntty,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlDsplyUOM%' THEN 'DlDtlDsplyUOM,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%ToleranceWhoseOption%' THEN 'ToleranceWhoseOption,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlVlmeTrmTpe%' THEN 'DlDtlVlmeTrmTpe,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%SchedulingQuantityTerm%' THEN 'SchedulingQuantityTerm,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlTrmTrmID%' THEN 'DlDtlTrmTrmID,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DeliveryTermID%' THEN 'DeliveryTermID,' ELSE '' END +
		CASE WHEN DDT.CriticalColumnList not like '%DlDtlLcleID%' THEN 'DlDtlLcleID,' ELSE '' END)
	)
)
END
FROM DealDetailTemplate DDT
INNER JOIN DealHeaderTemplate DHT
ON DDT.DlHdrTmplteID = DHT.DlHdrTmplteID
WHERE DHT.DlTypID in (100, 74, 20, 70, 76, 80, 1, 2, 72, 77)