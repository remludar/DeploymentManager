/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVArchiveDeal WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVArchiveDeal]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDeal.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDeal]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVArchiveDeal] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVArchiveDeal >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVArchiveDeal] @DlHdrID INT
AS
SET NOCOUNT ON
-- ==========================================================================================
-- Author:		Alan Oldfield
-- Create date: July 7, 2016
-- Description:	Correct the billing term on erroneous FedTax invoices
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
DECLARE @Versions TABLE (ChangeType CHAR(1),DlDtlID INT,DlHdrRevisionID INT,DlDtlRevisionID INT,PrvsnRowID INT,PrvsnRowRevisionID INT,IsPrimary BIT,RevisionDate DATETIME,RevisionUserID INT,DDChangeType CHAR(1),DDRevisionDate DATETIME,DDRevisionUserID INT,DPChangeType CHAR(1),DPRevisionDate DATETIME,DPRevisionUserID INT)
DECLARE @Revision TABLE (RevisionType CHAR(1),RevisionID INT,ChangeType CHAR(1),RevisionDate DATETIME,RevisionUserID INT,KeyValue INT)

DECLARE @RevisionLevel INT,@KeyValue INT,@Changed BIT,@DlHdrRevisionID INT

SELECT @Changed = 0

INSERT INTO @Versions (ChangeType,DlDtlID,PrvsnRowID,IsPrimary)
SELECT 'N',dd.DlDtlID,dpr.DlDtlPrvsnRwID,CASE ISNULL(ddp.CostType,'P') WHEN 'P' THEN 1 ELSE 0 END
FROM dbo.DealDetail dd (NOLOCK)
LEFT OUTER JOIN dbo.DealDetailProvision ddp (NOLOCK)
INNER JOIN dbo.DealDetailProvisionRow dpr
ON dpr.DlDtlPrvsnID = ddp.DlDtlPrvsnID
ON ddp.DlDtlPrvsnDlDtlDlHdrID = dd.DlDtlDlHdrID
AND ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID
AND ddp.CostType = 'P'
AND dpr.DlDtlPRvsnRwTpe = 'A'
AND ddp.Status = 'A'
WHERE dd.DlDtlDlHdrID = @DlHdrID

INSERT INTO @Revision (RevisionType,RevisionID,ChangeType,RevisionDate,RevisionUserID,KeyValue)
EXECUTE dbo.MTVArchiveDealHeaders @DlHdrID

DECLARE cursor_dealdetail CURSOR FOR SELECT DISTINCT DlDtlID FROM @Versions
OPEN cursor_dealdetail  
FETCH NEXT FROM cursor_dealdetail INTO @KeyValue

WHILE @@FETCH_STATUS = 0  
BEGIN 
	INSERT INTO @Revision (RevisionType,RevisionID,ChangeType,RevisionDate,RevisionUserID,KeyValue)
	EXECUTE dbo.MTVArchiveDealDetails @DlHdrID,@KeyValue
	FETCH NEXT FROM cursor_dealdetail INTO  @KeyValue
END  

CLOSE cursor_dealdetail  
DEALLOCATE cursor_dealdetail

DECLARE cursor_prvsnrows CURSOR FOR SELECT DISTINCT PrvsnRowID FROM @Versions WHERE PrvsnRowID IS NOT NULL
OPEN cursor_prvsnrows  
FETCH NEXT FROM cursor_prvsnrows INTO @KeyValue

WHILE @@FETCH_STATUS = 0  
BEGIN
	INSERT INTO @Revision (RevisionType,RevisionID,ChangeType,RevisionDate,RevisionUserID,KeyValue)
	EXECUTE dbo.MTVArchiveDealPriceRows @KeyValue
	FETCH NEXT FROM cursor_prvsnrows INTO  @KeyValue
END

CLOSE cursor_prvsnrows
DEALLOCATE cursor_prvsnrows

UPDATE v SET v.DlHdrRevisionID = r.RevisionID,v.ChangeType = r.ChangeType,v.RevisionDate = r.RevisionDate,v.RevisionUserID = r.RevisionUserID
FROM @Versions v,@Revision r
WHERE r.RevisionType = 'H'

UPDATE v SET	v.DlDtlRevisionID = r.RevisionID,
				v.DDChangeType = r.ChangeType,
				v.DDRevisionDate = r.RevisionDate,
				v.DDRevisionUserID = r.RevisionUserID
FROM @Versions v
INNER JOIN @Revision r
ON v.DlDtlID = r.KeyValue
AND r.RevisionType = 'D'

UPDATE v SET	v.PrvsnRowRevisionID = r.RevisionID,
				v.DPChangeType = r.ChangeType,
				v.DPRevisionDate = r.RevisionDate,
				v.DPRevisionUserID = r.RevisionUserID
FROM @Versions v
INNER JOIN @Revision r
ON v.PrvsnRowID = r.KeyValue
AND v.PrvsnRowID IS NOT NULL

UPDATE @Versions SET RevisionUserID = DDRevisionUserID,RevisionDate = DDRevisionDate WHERE RevisionDate < DDRevisionDate AND ChangeType != 'D'
UPDATE @Versions SET RevisionUserID = DPRevisionUserID,RevisionDate = DPRevisionDate WHERE DPRevisionDate IS NOT NULL AND RevisionDate < DPRevisionDate
UPDATE @Versions SET ChangeType = 'M' WHERE DDChangeType = 'M' OR DPChangeType = 'M'
UPDATE @Versions SET ChangeType = 'A' WHERE DDChangeType = 'A' OR DPChangeType = 'A'

SELECT @RevisionLevel = ISNULL(MAX(RevisionLevel),-1) + 1 FROM dbo.MTVArchiveRevisionLevels a (NOLOCK) WHERE DlHdrID = @DlHdrID

IF (@RevisionLevel > 0)
BEGIN
	INSERT INTO @Versions (ChangeType,DlDtlID,DlHdrRevisionID,DlDtlRevisionID,PrvsnRowID,PrvsnRowRevisionID,IsPrimary,RevisionDate,RevisionUserID,DDChangeType,DDRevisionDate,DDRevisionUserID,DPChangeType,DPRevisionDate,DPRevisionUserID)
	SELECT 'D',r.DlDtlID,r.DlHdrRevisionID,r.DlDtlRevisionID,r.PrvsnRowID,r.DlDtlRevisionID,r.PrvsnIsPrimary,GETDATE(),r.RevisionUserID,'D',GETDATE(),r.RevisionUserID,'D',GETDATE(),r.RevisionUserID
	FROM @Versions v
	RIGHT OUTER JOIN (SELECT * FROM dbo.MTVArchiveRevisionLevels (NOLOCK) WHERE DlHdrID = @DlHdrID AND RevisionLevel = @RevisionLevel-1 AND ChangeType != 'D') r
	ON r.DlDtlID = v.DlDtlID
	AND r.PrvsnIsPrimary = v.IsPrimary
	AND ISNULL(r.PrvsnRowID,'') = ISNULL(v.PrvsnRowID,'')
	WHERE v.DlDtlID IS NULL

	DELETE d
	FROM @Versions d
	INNER JOIN @Versions a
	ON d.DlDtlID = a.DlDtlID
	AND d.ChangeType = 'D'
	AND a.ChangeType = 'A'
END

IF EXISTS (SELECT TOP 1 1 FROM @Versions WHERE ChangeType != 'N')
BEGIN
	INSERT INTO MTVArchiveRevisionLevels (RevisionLevel,ChangeType,DlHdrID,DlDtlID,PrvsnRowID,DlHdrRevisionID,DlDtlRevisionID,PrvsnRowRevisionID,PrvsnIsPrimary,RevisionDate,RevisionUserID)
	SELECT @RevisionLevel,ChangeType,@DlHdrID,DlDtlID,PrvsnRowID,DlHdrRevisionID,DlDtlRevisionID,PrvsnRowRevisionID,IsPrimary,RevisionDate,RevisionUserID FROM @Versions
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDeal]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVArchiveDeal.sql'
			PRINT '<<< ALTERED StoredProcedure MTVArchiveDeal >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVArchiveDeal >>>'
	  END