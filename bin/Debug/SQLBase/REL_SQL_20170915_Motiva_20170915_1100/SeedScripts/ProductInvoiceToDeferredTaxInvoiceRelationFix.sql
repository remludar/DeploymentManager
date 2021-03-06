IF (OBJECT_ID('tempdb..#Invoices') IS NOT NULL)
	DROP TABLE #Invoices
GO 

CREATE TABLE #Invoices (InvoiceID INT,InvoiceNumber VARCHAR(20),RelatedInvoiceID INT,RelatedInvoiceNumber VARCHAR(20))

INSERT INTO #Invoices (InvoiceNumber,RelatedInvoiceNumber)
SELECT '1700081037' InvoiceNumber,'1700081049' RelatedInvoiceNumber UNION SELECT '1700081038','1700081050' UNION SELECT '1700081039','1700081051' UNION SELECT '1700081047','1700081054' UNION SELECT '1700081048','1700081052' UNION SELECT '1700081043','1700081056' UNION SELECT '1700081044','1700081057' UNION SELECT '1700081045','1700081058' UNION SELECT '1700081046','1700081053' UNION SELECT '1700081040','1700081059' UNION SELECT '1700081041','1700081060' UNION SELECT '1700081042','1700081055' UNION SELECT '1700081037','1700081061' UNION SELECT '1700081038','1700081069' UNION SELECT '1700081039','1700081072' UNION SELECT '1700081047','1700081067' UNION SELECT '1700081048','1700081071' UNION SELECT '1700081043','1700081070' UNION SELECT '1700081044','1700081066' UNION SELECT '1700081045','1700081065' UNION SELECT '1700081046','1700081068' UNION SELECT '1700081040','1700081064' UNION SELECT '1700081041','1700081063' UNION SELECT '1700081042','1700081062'

UPDATE i SET i.InvoiceId = sih.SlsInvceHdrID FROM #Invoices i INNER JOIN SalesInvoiceHeader sih ON sih.SlsInvceHdrNmbr = i.InvoiceNumber

UPDATE i SET i.RelatedInvoiceId = sih.SlsInvceHdrID FROM #Invoices i INNER JOIN SalesInvoiceHeader sih ON sih.SlsInvceHdrNmbr = i.RelatedInvoiceNumber

DELETE sihr
FROM #Invoices i
INNER JOIN SalesInvoiceHeaderRelation sihr ON sihr.SlsInvceHdrID = i.InvoiceId

INSERT INTO SalesInvoiceHeaderRelation
SELECT InvoiceID,RelatedInvoiceID FROM #Invoices
