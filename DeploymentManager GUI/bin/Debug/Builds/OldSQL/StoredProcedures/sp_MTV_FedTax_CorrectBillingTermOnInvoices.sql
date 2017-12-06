/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_CorrectBillingTermOnInvoices WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FedTax_CorrectBillingTermOnInvoices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FedTax_CorrectBillingTermOnInvoices] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]
AS

-- ================================================================================================================================
-- Author:		Joseph McClean
-- Create date: June 28, 2016
-- Description:	Correct the billing term on erroneous FedTax invoices. Step 2 of FedTax Invoice Correction Process
---				This stored procedure will not work in isolation it is directly dependent on MTV_FedTax_HoldErroneousInvoices.
-- ====================================================================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 9/22/2016	Joseph McClean	1761	Removed gobal temp table and replaced with an actual table
-- 9/15/2016	Joseph McClean	1768	Wrapped logic in Error Handling Try-Catch Block and Incorporated Transaction management  
--------------------------------------------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT, XACT_ABORT ON

BEGIN TRY
   BEGIN TRANSACTION 	
		DECLARE @nxtMonthTrmId int
		DECLARE @currMonthTrmId int

		SELECT @currMonthTrmId = Term.TrmID FROM Term WHERE Term.TrmAbbrvtn = 'TAX-28th CurrentMo'
		SELECT @nxtMonthTrmId =  Term.TrmID FROM Term WHERE Term.TrmAbbrvtn = 'TAX-13th Next Mo'
	
		-- if the billing terms don't exist don't try to update the term id on the tables
		IF (@nxtMonthTrmId IS NOT NULL AND @currMonthTrmId IS NOT NULL)
		BEGIN
			UPDATE SalesInvoiceHeader 
			SET SalesInvoiceHeader.SlsInvceHdrTrmID = (CASE WHEN (DAY(BadDateInvoice.MovementDate) between 1 and 15) THEN @currMonthTrmId
															ELSE @nxtMonthTrmId END)
			FROM SalesInvoiceHeader INNER JOIN (select distinct SalesInvoiceHeaderId, MovementDate
														from	MTVDeferredTaxInvoices
														where	CAST(HasBadDate as INT) = 1
													   ) BadDateInvoice ON BadDateInvoice.SalesInvoiceHeaderId = SalesInvoiceHeader.SlsInvceHdrID

			UPDATE MTVDeferredTaxInvoices 
			SET BillingTermID = (CASE WHEN (DAY(MovementDate) between 1 and 15) THEN @currMonthTrmId
																				ELSE @nxtMonthTrmId END),
				BillingTerm = (CASE WHEN (DAY(MovementDate) between 1 and 15) THEN 'TAX-28th CurrentMo'
																			  ELSE 'TAX-13th Next Mo'	 END),
				IsCorrected = 1
			WHERE CAST(HasBadDate as INT) = 1
		END
		ELSE
		BEGIN
			RAISERROR ('Missing Payment Term ''TAX-28th CurrentMo'' OR  ''TAX-13th Next Mo''.', 16, 1)
		END
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
     IF @@trancount > 0 ROLLBACK TRANSACTION
     DECLARE @msg nvarchar(2048) = error_message() + ' Due To The Error Encountered No Invoices Have Been Corrected. Correct Any Errors and Rerun Process.'
     RAISERROR (@msg, 16, 1)
END CATCH
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FedTax_CorrectBillingTermOnInvoices.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>'
	  END