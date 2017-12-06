INSERT	DealTypeRelation
SELECT	DISTINCT 171
		,'T'
		,'O'
		,'Y'
FROM	DealTypeRelation
WHERE	NOT EXISTS (SELECT 'x' FROM DealTypeRelation WHERE DlTpeRltnDlTpe = 171)

GO

INSERT	DealTypeRelation
SELECT	DISTINCT 172
		,'T'
		,'O'
		,'Y'
FROM	DealTypeRelation
WHERE	NOT EXISTS (SELECT 'x' FROM DealTypeRelation WHERE DlTpeRltnDlTpe = 172)
GO

INSERT	DealTypeRelation
SELECT	DISTINCT 173
		,'T'
		,'O'
		,'Y'
FROM	DealTypeRelation
WHERE	NOT EXISTS (SELECT 'x' FROM DealTypeRelation WHERE DlTpeRltnDlTpe = 173)

