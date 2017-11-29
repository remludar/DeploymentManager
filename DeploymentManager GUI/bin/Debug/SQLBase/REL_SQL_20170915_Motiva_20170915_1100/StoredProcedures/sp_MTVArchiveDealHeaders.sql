/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVArchiveDealHeaders WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVArchiveDealHeaders]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealHeaders.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealHeaders]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVArchiveDealHeaders] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVArchiveDealHeaders >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVArchiveDealHeaders] @DlHdrID INT
AS
SET NOCOUNT ON
-- ==========================================================================================
-- Author:		Alan Oldfield
-- Create date: July 7, 2016
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
DECLARE @MaxRevisionID INT,@Start INT,@CurrentChangeCheckSum INT,@SecondaryChangeCheckSum INT

DECLARE @ChangeRow TABLE (
	DlHdrID INT NOT NULL,
	DlHdrStat CHAR(1) NOT NULL,
	DlHdrIntrnlNbr VARCHAR(20) NOT NULL,
	DlHdrDsplyDte DATETIME NOT NULL,
	DlHdrIntrnlBAID INT,
	DlHdrExtrnlBAID INT,
	DlHdrExtrnlCntctID INT,
	Term CHAR(3),
	DlHdrIntrnlUserID INT,
	MasterAgreement INT,
	Comment VARCHAR(MAX),
	Remarks VARCHAR(MAX),
	DlHdrCrtnDte DATETIME,
	DlHdrTyp INT NOT NULL,
	DlHdrFrmDte DATETIME NOT NULL,
	DlHdrToDte DATETIME NOT NULL,
	RinsGenerator VARCHAR(255),
	RevisionDate DATETIME NOT NULL,
	RevisionUserID INT NOT NULL
)

INSERT INTO @ChangeRow
SELECT	d.DlHdrID,
		d.DlHdrStat,
		d.DlHdrIntrnlNbr,
		d.DlHdrDsplyDte,
		d.DlHdrIntrnlBAID,
		d.DlHdrExtrnlBAID,
		d.DlHdrExtrnlCntctID,
		d.Term,
		d.DlHdrIntrnlUserID,
		d.MasterAgreement,
		d.Comment,
		CAST(ISNULL(d.Remarks,'') AS VARCHAR(MAX)) + '|',
		d.DlHdrCrtnDte,
		d.DlHdrTyp,
		d.DlHdrFrmDte,
		d.DlHdrToDte,
		NULL,
		d.DlHdrRvsnDte,
		d.DlHdrRvsnUserID
FROM dbo.DealHeader d (NOLOCK)
WHERE d.DlHdrID = @DlHdrID

UPDATE c SET c.RinsGenerator = g.GnrlCnfgMulti
FROM @ChangeRow c
INNER JOIN dbo.GeneralConfiguration g (NOLOCK)
ON g.GnrlCnfgHdrID = c.DlHdrID
AND g.GnrlCnfgTblNme = 'DealHeader'
AND g.GnrlCnfgQlfr = 'Generator'
AND g.GnrlCnfgMulti IS NOT NULL

SELECT @Start = CHARINDEX('traderremark|',Remarks,0) + 13 FROM @ChangeRow
IF (@Start = 13)
	UPDATE @ChangeRow SET Remarks = ''
ELSE
	UPDATE @ChangeRow SET Remarks = SUBSTRING(Remarks,@Start,CHARINDEX('|',Remarks,@Start)-@Start)

SELECT	@CurrentChangeCheckSum = CHECKSUM(DlHdrStat,DlHdrIntrnlBAID,DlHdrIntrnlNbr,DlHdrDsplyDte,DlHdrExtrnlCntctID,DlHdrIntrnlUserID,DlHdrFrmDte,DlHdrToDte,DlHdrTyp,DlHdrExtrnlBAID,RinsGenerator),
		@SecondaryChangeCheckSum = CHECKSUM(Remarks,Term,MasterAgreement,Comment,DlHdrCrtnDte)
FROM @ChangeRow

SELECT @MaxRevisionID = MAX(RevisionID) FROM dbo.MTVDealHeaderArchive (NOLOCK) WHERE DlHdrID = @DlHdrID
IF (@MaxRevisionID IS NULL)  --New Row
BEGIN
	INSERT INTO dbo.MTVDealHeaderArchive
	SELECT	0,DlHdrID,DlHdrStat,'A',DlHdrIntrnlNbr,DlHdrDsplyDte,DlHdrIntrnlBAID,DlHdrExtrnlBAID,
		DlHdrExtrnlCntctID,Term,DlHdrIntrnlUserID,MasterAgreement,Comment,Remarks,
		DlHdrCrtnDte,DlHdrTyp,DlHdrFrmDte,DlHdrToDte,RinsGenerator,RevisionDate,RevisionUserID,
		@CurrentChangeCheckSum,@SecondaryChangeCheckSum
	FROM @ChangeRow
	SELECT 'H' RevisionType,0 RevisionID,'A' ChangeType,RevisionDate,RevisionUserID,DlHdrID KeyValue FROM @ChangeRow
END
ELSE
BEGIN --Modified Row
	DECLARE @CurrentCheckSum INT,@SecondaryCheckSum INT

	SELECT @CurrentCheckSum = ColumnCheckSum,@SecondaryCheckSum = SecondaryCheckSum FROM dbo.MTVDealHeaderArchive (NOLOCK) WHERE DlHdrID = @DlHdrID AND RevisionID = @MaxRevisionID

	IF (@CurrentCheckSum = @CurrentChangeCheckSum)
	BEGIN
		IF (@SecondaryCheckSum != @SecondaryChangeCheckSum)
		BEGIN
			UPDATE a SET	a.SecondaryCheckSum = @SecondaryChangeCheckSum,
							a.Term = c.Term,
							a.MasterAgreement = c.MasterAgreement,
							a.Comment = c.Comment,
							a.DlHdrCrtnDte = c.DlHdrCrtnDte,
							a.Remarks = c.Remarks
			FROM dbo.MTVDealHeaderArchive a
			INNER JOIN @ChangeRow c
			ON a.DlHdrID = c.DlHdrID
			AND a.RevisionID = @MaxRevisionID
		END
		SELECT 'H' RevisionType,@MaxRevisionID RevisionID,'N' ChangeType,RevisionDate,RevisionUserID,@DlHdrID DlHdrID FROM @ChangeRow
	END
	ELSE
	BEGIN
		INSERT INTO dbo.MTVDealHeaderArchive
		SELECT @MaxRevisionID + 1,DlHdrID,DlHdrStat,'M',DlHdrIntrnlNbr,DlHdrDsplyDte,DlHdrIntrnlBAID,DlHdrExtrnlBAID,
			DlHdrExtrnlCntctID,Term,DlHdrIntrnlUserID,MasterAgreement,Comment,Remarks,DlHdrCrtnDte,DlHdrTyp,DlHdrFrmDte,DlHdrToDte,
			RinsGenerator,RevisionDate,RevisionUserID,@CurrentChangeCheckSum,@SecondaryChangeCheckSum
		FROM @ChangeRow
		SELECT 'H' RevisionType,@MaxRevisionID+1 RevisionID,'M' ChangeType,RevisionDate,RevisionUserID,@DlHdrID DlHdrID FROM @ChangeRow
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealHeaders]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVArchiveDealHeaders.sql'
			PRINT '<<< ALTERED StoredProcedure MTVArchiveDealHeaders >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVArchiveDealHeaders >>>'
	  END