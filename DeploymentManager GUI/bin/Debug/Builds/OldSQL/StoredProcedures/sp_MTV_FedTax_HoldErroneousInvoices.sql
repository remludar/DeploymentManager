/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_HoldErroneousInvoices WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FedTax_HoldErroneousInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FedTax_HoldErroneousInvoices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_HoldErroneousInvoices]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FedTax_HoldErroneousInvoices] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].MTV_FedTax_HoldErroneousInvoices
AS

-- =======================================================================================================================================
-- Author:		Joseph McClean
-- Create date: June 28, 2016
-- Description:	Place FedTax invoices with erroneous payment term on Hold. Step 1 of FedTax Invoice Correction Process
---				This stored procedure is the first part of a transaction group. 
---				[MTV_FedTax_CorrectBillingTermOnInvoices] and [MTV_FedTax_PlaceInvoicesInActiveStatus] are dependent on this stored procedure.
-- ========================================================================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ----------------------------------------------------------------------------------------------------
-- 8/22/2016	Joseph McClean	1761	Removed gobal temp table and replaced with an actual table.
-- 9/15/2016	Joseph McClean	1768	Wrapped logic in Error Handling Try-Catch Block and Incorporated Transaction management.
-- 1/11/2017	Joseph Mclean   N/A		Refactored logic to remove entries which have already been processed. Created maxid variable to determine the newest invoices to process.
--------------------------------------------------------------------------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
	SET NOCOUNT, XACT_ABORT ON

	BEGIN TRY
		BEGIN TRANSACTION

			IF  OBJECT_ID(N'tempdb..#DateCalculationTemp') IS NOT NULL
			BEGIN
				DROP table #DateCalculationTemp
			END

				DECLARE @vc_id varchar(10)
				DECLARE @trmId int
				DECLARE @i_Idnty int
				DECLARE @calculatedDueDate datetime
				DECLARE @nxtMonthTrmId int
				DECLARE @currMonthTrmId int
				DECLARE @minSlsInvceHdrId int
			
				-- Get the MaxId from FedTaxInvoice processing table. This will establish the last/most recent fedtax invoice that was processed.
				-- If MTVDeferredTaxInvoices is empty then there will be no Id so then 
				-- We establish the minimum Id to the smallest id of the TAXFED invoices from SalesInvoiceHeader table.
				-- This could be replaced with a much simpler ISNULL
				SELECT @minSlsInvceHdrId = MAX(SalesInvoiceHeaderId) FROM MTVDeferredTaxInvoices
				IF (@minSlsInvceHdrId IS NULL)
				BEGIN
				  SELECT @minSlsInvceHdrId =  ISNULL(MIN(SlsInvceHdrID), 1) 
				  FROM   SalesInvoiceHeader SIH INNER JOIN Term ON Term.TrmID = SIH.SlsInvceHdrTrmID 
				  WHERE  Term.TrmAbbrvtn = 'TAXFED' AND SIH.SlsInvceHdrStts IN ('A')
				END
				
				--Delete entries that were successfully corrected in the previous run.
				--DELETE FROM MTVDeferredTaxInvoices WHERE CAST(HasBadDate as INT) = 1 AND CAST(IsCorrected as INT) = 1 AND SalesInvoiceHeaderStatus = 'A'

				--- Delete the majority of entries from the table basically. if an erorr occurs anywhere in this stored proc, 
				--- the rollback will undo this deletion and the process and table will be restored to original state.
				--- The only entries not be deleted will be invoices that had a bad date and and weren't previosuly corrected by the subsquent process due to some error.
				--- Previsouly uncorrected invoices will be kept for reprocessing.
				DELETE FROM MTVDeferredTaxInvoices
			    WHERE ((CAST(HasBadDate as INT) = 1 AND CAST(IsCorrected as INT) = 1 AND SalesInvoiceHeaderStatus = 'A') OR --<--  HasBad date and was corrected.
				        CAST(HasBadDate as INT) = 0  )																		--<--- Never had a bad date

				--- Insert all the new active (i.e. unsent) fedtax invoices for processing.
				MERGE INTO MTVDeferredTaxInvoices as TargetTable
				USING     
						(SELECT DISTINCT
								SIH.SlsInvceHdrID, 
								SIH.SlsInvceHdrNmbr, 
								SIH.SlsInvceHdrStts, 
								SIH.SlsInvceHdrTrmID,
								Term.TrmAbbrvtn, 
								SIH.SlsInvceHdrDueDte,
								[SID].SlsInvceDtlMvtHdrDte,
								--[SID].SlsInvceDtlTrnsctnVle,
								[SID].SlsInvceDtlMvtDcmntExtrnlDcmnt
						FROM	SalesInvoiceHeader  SIH
								INNER JOIN Term ON Term.TrmID = SIH.SlsInvceHdrTrmID 	
								LEFT JOIN SalesInvoiceDetail [SID] on [SID].SlsInvceDtlSlsInvceHdrID = 	SIH.SlsInvceHdrID
						WHERE	Term.TrmAbbrvtn = 'TAXFED' AND SIH.SlsInvceHdrStts IN ('A') AND SIH.SlsInvceHdrID >= @minSlsInvceHdrId) AS SourceTable
    
				ON TargetTable.SalesInvoiceHeaderId = SourceTable.SlsInvceHdrID AND
				   TargetTable.SalesInvoiceHeaderNumber = SourceTable.SlsInvceHdrNmbr AND
				   TargetTable.SalesInvoiceHeaderStatus = SourceTable.SlsInvceHdrStts AND
				   TargetTable.BillingTermID = SourceTable.SlsInvceHdrTrmID AND
				   TargetTable.BillingTerm = SourceTable.TrmAbbrvtn AND
				   TargetTable.MovementDate = SourceTable.SlsInvceDtlMvtHdrDte AND
				   TargetTable.BOL = SourceTable.SlsInvceDtlMvtDcmntExtrnlDcmnt

				WHEN MATCHED THEN
					 --UPDATE part of the 'UPSERT'
					UPDATE SET	
					--TargetTable.InvoiceDueDate = SourceTable.SlsInvceHdrDueDte,
								TargetTable.CalculatedDueDate = null,
								TargetTable.MovementDate = SourceTable.SlsInvceDtlMvtHdrDte,
								TargetTable.HasBadDate = null,
								TargetTable.IsCorrected = null

				WHEN NOT MATCHED THEN
					-- INSERT part of the 'UPSERT'
					INSERT (SalesInvoiceHeaderId,SalesInvoiceHeaderNumber,SalesInvoiceHeaderStatus,BillingTermID,BillingTerm,CalculatedDueDate,MovementDate,BOL,HasBadDate)
					VALUES (SlsInvceHdrID,SlsInvceHdrNmbr,SlsInvceHdrStts,SlsInvceHdrTrmID, TrmAbbrvtn,null,SlsInvceDtlMvtHdrDte,SlsInvceDtlMvtDcmntExtrnlDcmnt, null);

				CREATE TABLE #DateCalculationTemp  ( DueDate datetime, DiscountDate datetime, DiscountValue decimal)
				
				-- calculate the current due date for each FedTax invoice.
				-- only calculate for newly inserted fedtax invoices or those that need to be re-processed.
				Select	@i_Idnty = Min(Id)
				From	MTVDeferredTaxInvoices WITH (nolock)
				Where	((CAST(HasBadDate as INT) IS NULL AND CAST(IsCorrected as INT) IS NULL) OR  ---<------ new table entry (the null value is intended to indicate a value hasn't been set).
						(CAST(HasBadDate as INT) = 1 AND (CAST(IsCorrected as INT) = 0 OR CAST(IsCorrected as INT) IS NULL))) 
						-- OR ----<------- uncorrected entries or entries not explicitly set  
						--(SalesInvoiceHeaderStatus = 'H')) ----<------- uncorrected entries or entries not explicitly set  (invoice that should have been set to active but was not)

				While @i_Idnty IS NOT NULL
				Begin
					SELECT @vc_id = cast(MTVDeferredTaxInvoices.SalesInvoiceHeaderId as varchar(20)), @trmId = MTVDeferredTaxInvoices.BillingTermID FROM MTVDeferredTaxInvoices WHERE MTVDeferredTaxInvoices.Id = @i_Idnty
		
					--declare @DateCalculationTemp  TABLE ( DueDate datetime, DiscountDate datetime, DiscountValue decimal)
	 				-- Yes i know this is ugly but the stored proc returns the duedate, disc value etc but no id's are returned. i need to link the due date to an id for usage.
					INSERT INTO #DateCalculationTemp (DueDate, DiscountDate, DiscountValue)
					EXEC sp_calculate_due_date @vc_entity ='SalesInvoiceHeader' , @vc_ids = @vc_id , @i_termid = @trmId , @vc_debug ='N' 

					SELECT @calculatedDueDate = DueDate from #DateCalculationTemp
					
					-- update the table with the calculated date for the invoices
					UPDATE MTVDeferredTaxInvoices
					SET MTVDeferredTaxInvoices.CalculatedDueDate = @calculatedDueDate
					WHERE MTVDeferredTaxInvoices.Id = @i_Idnty

					TRUNCATE TABLE #DateCalculationTemp

					NETXTRECORD:
					-- Process the next record in table
					SELECT @i_Idnty = Min(Id)
					FROM   MTVDeferredTaxInvoices WITH (nolock) 
					WHERE  Id > @i_Idnty
				End

				-- set bad date bit flag
				UPDATE MTVDeferredTaxInvoices
				SET MTVDeferredTaxInvoices.HasBadDate = CASE WHEN (((DAY(MovementDate) BETWEEN  1 AND 15 )
																	AND (DAY(CalculatedDueDate) < 28 )
																	AND (MONTH(MovementDate) <> MONTH(CalculatedDueDate)))
																	OR (( DAY(MovementDate) BETWEEN 16 AND DAY(EOMONTH(MovementDate)))  AND (DAY(CalculatedDueDate) > 13)))
															THEN 1 ELSE 0 END
				WHERE SalesInvoiceHeaderStatus = 'A'

				 -- set status
				UPDATE	SalesInvoiceHeader
				SET	SlsInvceHdrStts = 'H'
				WHERE	SlsInvceHdrID IN (select distinct SalesInvoiceHeaderId
										from MTVDeferredTaxInvoices
										where CAST(HasBadDate as INT) = 1)

				-- keep custom table in sync with the core SalesInvoiceHeader table
				UPDATE MTVDeferredTaxInvoices 
				SET SalesInvoiceHeaderStatus = 'H'
				WHERE CAST(HasBadDate as INT) = 1


				DROP TABLE #DateCalculationTemp
			COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	   IF @@trancount > 0 ROLLBACK TRANSACTION
	        DECLARE @msg nvarchar(2048) = error_message()  + ' Due To The Error Encountered No Invoices Have Been Placed On Hold.'
			RAISERROR (@msg, 16, 1)
	END CATCH
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_HoldErroneousInvoices]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FedTax_HoldErroneousInvoices.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>'
	  END