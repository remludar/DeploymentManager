
/****** Object:  StoredProcedure [dbo].[MTV_ParentInvoiceAttributes]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ParentInvoiceAttributes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ParentInvoiceAttributes]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ParentInvoiceAttributes] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ParentInvoiceAttributes >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ParentInvoiceAttributes]
				@invoiceNumber varchar(20)
AS

-- =============================================
-- Author:        Sanjay Kumar
-- Create date:	  11JUL2017
-- Description:   Retrieve Parent Invoice SoldTo & ShipTo code.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------


select AD.AcctDtlID, SAPShipToCode, SAPSoldToCode, AD.AcctDtlPrntID from CustomAccountDetailAttribute CADA
inner join CustomAccountDetail CAD on CAD.ID = CADA.CADID
inner join AccountDetail AD on AD.AcctDtlPrntID = CAD.AcctDtlID
inner join CustomInvoiceInterface CII on CII.AcctDtlId = AD.AcctDtlId
where CII.InvoiceNumber = @invoiceNumber

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ParentInvoiceAttributes]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_ParentInvoiceAttributes.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ParentInvoiceAttributes >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ParentInvoiceAttributes >>>'
	  END