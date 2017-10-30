/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_PlaceInvoicesInActiveStatus WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FedTax_PlaceInvoicesInActiveStatus.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]
AS

-- ==========================================================================================
-- Author:		Joseph McClean
-- Create date: June 28, 2016
-- Description:	Place Corrected FedTax Invoices from Hold Status to Active Status. Step 3 of FedTax Invoice Correction Process
---				This stored procedure will not work in isolation it is directly dependent on the execution of
--              MTV_FedTax_HoldErroneousInvoices and MTV_FedTax_CorrectBillingTermOnInvoices.    
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 9/22/2016	Joseph McClean	1761	Removed gobal temp table and replaced with an actual table
-- 9/15/2016	Joseph McClean	1768	Wrapped logic in Error Handling Try-Catch Block and Incorporated Transaction management 
--------------------------------------------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */

SET NOCOUNT, XACT_ABORT ON

BEGIN TRY
	BEGIN TRANSACTION
	
		--- Set invoice status to active 
		UPDATE SalesInvoiceHeader
		SET	   SlsInvceHdrStts = 'A'  
		WHERE  SalesInvoiceHeader.SlsInvceHdrID IN (select distinct SalesInvoiceHeaderId
													from MTVDeferredTaxInvoices
													where (CAST(HasBadDate as INT) = 1 and CAST(IsCorrected as INT) = 1))

		UPDATE MTVDeferredTaxInvoices
		SET	   SalesInvoiceHeaderStatus = 'A'
		WHERE  MTVDeferredTaxInvoices.SalesInvoiceHeaderId IN (select distinct SalesInvoiceHeaderId
																from MTVDeferredTaxInvoices
																where (CAST(HasBadDate as INT) = 1  and CAST(IsCorrected as INT) = 1))
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
		   IF @@trancount > 0 ROLLBACK TRANSACTION
				DECLARE @msg nvarchar(2048) = error_message()  + ' Due To The Error Encountered No Invoices Have Been Set to Active.'
				RAISERROR (@msg, 16, 1)
END CATCH

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FedTax_PlaceInvoicesInActiveStatus.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>'
	  END