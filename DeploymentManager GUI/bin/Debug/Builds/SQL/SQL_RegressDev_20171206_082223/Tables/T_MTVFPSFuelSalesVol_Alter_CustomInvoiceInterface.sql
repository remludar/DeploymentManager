
IF  OBJECT_ID(N'[dbo].[CustomInvoiceInterface]') IS NOT NULL
BEGIN

Alter table CustomInvoiceInterface
Add FPSProcessedStatus varchar(1)

END  