/*
*****************************************************************************************************
USE FIND AND REPLACE ON ManualBOLXRef WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_sp_ManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ManualBOLXRef]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ManualBOLXRef] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ManualBOLXRef >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ManualBOLXRef] @RowId INT = NULL
AS

-- =============================================
-- Author:        Ryan Borgman
-- Create date:	  10/16/2014
-- Description:   Xreference and error scrub PetroEx information
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_ManualBOLXRef 18
-----------------------------------------------------------------------------
UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.LoadedDate = GETDATE()
--SELECT	*
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.LoadedDate is null

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.TicketStatus = 'N'
--SELECT	*
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.TicketStatus is null

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.TicketStatus = 'N'
--SELECT	*
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.TicketStatus = 'E'


UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.IssuedById = BusinessAssociate.BAID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	BusinessAssociate (NOLOCK)
ON	MTVManulMovementUpload.IssuedBy = BusinessAssociate.BaAbbrvtn + ISNULL(BusinessAssociate.BaAbbrvtnExtended,'')

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RAOriginID = Locale.LcleID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	Locale (NOLOCK)
ON	MTVManulMovementUpload.MovementLocation = Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,'')

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RATaxOriginID = Locale.LcleID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	Locale (NOLOCK)
ON	MTVManulMovementUpload.TaxOrigin = Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,'')

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RATaxDestID = Locale.LcleID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	Locale (NOLOCK)
ON	MTVManulMovementUpload.TaxDestination = Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,'')

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RAPrdctID = Product.PrdctID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	Product (NOLOCK)
ON	MTVManulMovementUpload.Product = Product.PrdctAbbv

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.MovementTypeID = MovementHeaderType.MvtHdrTyp
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	MovementHeaderType (NOLOCK)
ON	MTVManulMovementUpload.MovementType = MovementHeaderType.Name

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RACarrierID = BusinessAssociate.BAID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	BusinessAssociate (NOLOCK)
ON	MTVManulMovementUpload.Carrier = BusinessAssociate.BaAbbrvtn + ISNULL(BusinessAssociate.BaAbbrvtnExtended,'')

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.RAUOMID = UnitOfMeasure.UOM
--SELECT	*
FROM	MTVManulMovementUpload 
INNER JOIN	UnitOfMeasure (NOLOCK)
ON	MTVManulMovementUpload.UOM = UnitOfMeasure.UOMAbbv

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.ReceiptDlHdrId = DealHeader.DlHdrID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	DealHeader (NOLOCK)
ON	MTVManulMovementUpload.ReceiptDeal = DealHeader.DlHdrIntrnlNbr

UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.DeliveryDlHdrId = DealHeader.DlHdrID
--SELECT	*
FROM	MTVManulMovementUpload
INNER JOIN	DealHeader (NOLOCK)
ON	MTVManulMovementUpload.DeliveryDeal = DealHeader.DlHdrIntrnlNbr

/*
---------------------------------------------------------
Let's Do some Error Checking before we interface the data
---------------------------------------------------------
*/
--RESET MESSAGES IN TABLE
UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.ErrorMessage = NULL
WHERE	MTVManulMovementUpload.ErrorMessage IS NOT NULL
AND		MTVManulMovementUpload.TicketStatus <> 'C'
AND		MTVManulMovementUpload.MMMUID	= CASE WHEN @RowId IS NULL THEN MTVManulMovementUpload.MMMUID ELSE @RowId END

--RESET STATUS IN TABLE
UPDATE	MTVManulMovementUpload
SET		MTVManulMovementUpload.TicketStatus = 'N'
WHERE	MTVManulMovementUpload.TicketStatus = 'E'
AND		MTVManulMovementUpload.MMMUID	= CASE WHEN @RowId IS NULL THEN MTVManulMovementUpload.MMMUID ELSE @RowId END

--NULL LoadDepot
UPDATE	MTVManulMovementUpload
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find IssuedBy|| '
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.IssuedById IS NULL

--NULL ModeofTransport
UPDATE	MTVManulMovementUpload
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ModeofTransport|| '
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.MovementTypeID IS NULL

--NULL RAPrdctID
UPDATE	MTVManulMovementUpload
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find ProductCode|| '
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.RAPrdctID IS NULL

--NULL RAPrdctID
UPDATE	MTVManulMovementUpload
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find Origin|| '
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.RAOriginID IS NULL

--NULL RAPrdctID
UPDATE	MTVManulMovementUpload
SET		TicketStatus	= 'E'
		,ErrorMessage	= ISNULL(ErrorMessage,'') + 'Can not find UOM|| '
FROM	MTVManulMovementUpload
WHERE	MTVManulMovementUpload.RAUOMID IS NULL

--WRAP UP Error Message
UPDATE	MTVManulMovementUpload
SET		ErrorMessage	= ISNULL(ErrorMessage,'') + 'Please verify Cross-Reference setup to correct errors.'
FROM	MTVManulMovementUpload
WHERE	TicketStatus	= 'E'


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ManualBOLXRef]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_ManualBOLXRef.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ManualBOLXRef >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ManualBOLXRef >>>'
	  END