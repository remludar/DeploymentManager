/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVCustomInvInterfaceMissingDueDate_DiscTempFix WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVCustomInvInterfaceMissingDueDate_DiscTempFix.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVCustomInvInterfaceMissingDueDate_DiscTempFix >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]
AS

-- =============================================
-- Author:        rlb
-- Create date:	  2017-06-19
-- Description:   Temp Fix to address missing DueDates on Sent invoices
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--exec MTVCustomInvInterfaceMissingDueDate_DiscTempFix
-----------------------------------------------------------------------------
SET NOCount ON

IF  OBJECT_ID(N'tempdb..#DateCalculationTemp') IS NOT NULL
BEGIN
	DROP table #DateCalculationTemp
END

CREATE TABLE #DateCalculationTemp  ( DueDate datetime, DiscountDate datetime, DiscountValue decimal(19,2))

DECLARE	@SlsInvcNmbr	VARCHAR(80)
		,@SlsInvcHdrId	INT
		,@SlsInvceTrmID INT

DECLARE crs_SetMissingDueDate CURSOR FOR  
SELECT DISTINCT SalesInvoiceHeader.SlsInvceHdrNmbr,SalesInvoiceHeader.SlsInvceHdrID, SalesInvoiceHeader.SlsInvceHdrTrmID
from	CustomInvoiceInterface (NoLock)
INNER JOIN	SalesInvoiceHeader (NoLock)
ON	CustomInvoiceInterface.InvoiceNumber = SalesInvoiceHeader.SlsInvceHdrNmbr
AND	SalesInvoiceHeader.SlsInvceHdrStts = 'S'
AND	SalesInvoiceHeader.SlsInvceHdrPstdDte IS NULL
AND	SalesInvoiceHeader.SlsInvceHdrDueDte IS NULL
where	CustomInvoiceInterface.DueDate = '' 
--AND		MTVSalesforceDataLakeInvoicesStaging.TagIdentifier = 'H'
--and		invoicenumber in ('1700000460','1700000910')

OPEN crs_SetMissingDueDate   
FETCH NEXT FROM crs_SetMissingDueDate INTO @SlsInvcNmbr,@SlsInvcHdrId, @SlsInvceTrmID 

WHILE @@FETCH_STATUS = 0   
BEGIN   
    INSERT INTO #DateCalculationTemp (DueDate, DiscountDate, DiscountValue)
	EXEC sp_calculate_due_date @vc_entity ='SalesInvoiceHeader' , @vc_ids = @SlsInvcHdrId , @i_termid = @SlsInvceTrmID , @vc_debug ='N' 

	UPDATE	CustomInvoiceInterface
	SET		CustomInvoiceInterface.DueDate = #DateCalculationTemp.DueDate FROM	#DateCalculationTemp
	WHERE	CustomInvoiceInterface.InvoiceNumber = @SlsInvcNmbr

	IF (SELECT DiscountValue FROM #DateCalculationTemp) <> 0
	BEGIN

		UPDATE	CustomInvoiceInterface
		SET		CustomInvoiceInterface.AbsInvoiceValue = DiscountValue FROM	#DateCalculationTemp
		WHERE	CustomInvoiceInterface.InvoiceNumber = @SlsInvcNmbr
		AND		CustomInvoiceInterface.InvoiceLevel = 'D'
		AND		CustomInvoiceInterface.TransactionType = 'Discount'

	END

    FETCH NEXT FROM crs_SetMissingDueDate INTO @SlsInvcNmbr, @SlsInvcHdrId, @SlsInvceTrmID 
	
	TRUNCATE TABLE #DateCalculationTemp

END   

CLOSE crs_SetMissingDueDate   
DEALLOCATE crs_SetMissingDueDate

SET NOCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVCustomInvInterfaceMissingDueDate_DiscTempFix.sql'
			PRINT '<<< ALTERED StoredProcedure MTVCustomInvInterfaceMissingDueDate_DiscTempFix >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVCustomInvInterfaceMissingDueDate_DiscTempFix >>>'
	  END

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVCustomInvInterfaceMissingDueDate_DiscTempFix WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVCustomInvInterfaceMissingDueDate_DiscTempFix.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCustomInvInterfaceMissingDueDate_DiscTempFix]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVCustomInvInterfaceMissingDueDate_DiscTempFix TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVCustomInvInterfaceMissingDueDate_DiscTempFix >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVCustomInvInterfaceMissingDueDate_DiscTempFix >>>'
