IF NOT EXISTS (SELECT 1 FROM sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDealPriceRowArchive' and sc.name = 'EventReference')
BEGIN
	ALTER TABLE MTVDealPriceRowArchive ADD EventReference INT NULL

	CREATE TABLE #temp(ProvisionRowID INT,DeemedDate VARCHAR(80),EventReference VARCHAR(80),MaxRevisionID INT)
	DECLARE @DeemedDate VARCHAR(80),@EventReference INT,@EventSQL VARCHAR(2000)

	/******************************************************************/
	DECLARE @ProvisionRowID INT
	DECLARE cursor_update CURSOR FOR  
	SELECT DISTINCT a.PrvsnRwID
	FROM MTVDealPriceRowArchive a
	INNER JOIN (
		SELECT DISTINCT VrblePrvsnPrvsnID PrvsnID
		FROM dbo.VrblePrvsn
		WHERE VariableDescription IN ('Deemed Date','Event Reference')
	) p
	ON a.PrvsnID = p.PrvsnID

	OPEN cursor_update  
	FETCH NEXT FROM cursor_update INTO  @ProvisionRowID

	WHILE @@FETCH_STATUS = 0  
	BEGIN 
		SELECT @EventSQL = 'SELECT DlDtlPrvsnRwID,' + ISNULL(dd.ColumnName,'NULL') + ',' + ISNULL(er.ColumnName,'NULL') + ' FROM dbo.DealDetailProvisionRow WHERE DlDtlPrvsnRwID = ' + CAST(r.DlDtlPrvsnRwID AS VARCHAR)
		FROM dbo.DealDetailProvisionRow r (NOLOCK)
		INNER JOIN dbo.DealDetailProvision ddp (NOLOCK)
		ON ddp.DlDtlPrvsnID = r.DlDtlPrvsnID
		AND r.DlDtlPrvsnRwID = @ProvisionRowID
		LEFT OUTER JOIN dbo.VrblePrvsn dd ON dd.VrblePrvsnPrvsnID = ddp.DlDtlPrvsnPrvsnID AND dd.VariableDescription = 'Deemed Date'
		LEFT OUTER JOIN dbo.VrblePrvsn er ON er.VrblePrvsnPrvsnID = ddp.DlDtlPrvsnPrvsnID AND er.VariableDescription = 'Event Reference'
		WHERE (dd.ColumnName IS NOT NULL OR er.ColumnName IS NOT NULL)

		IF (@@ROWCOUNT > 0)
		BEGIN
			INSERT INTO #temp (ProvisionRowID,DeemedDate,EventReference) EXEC(@EventSQL)
		END

		FETCH NEXT FROM cursor_update INTO @ProvisionRowID
	END  

	CLOSE cursor_update  
	DEALLOCATE cursor_update
	/******************************************************************/

	UPDATE u SET u.MaxRevisionID = n.RevisionID
	FROM #temp u
	INNER JOIN (
		SELECT a.PrvsnRwID,MAX(a.RevisionID) RevisionID
		FROM #temp t
		INNER JOIN MTVDealPriceRowArchive a
		ON a.PrvsnRwID = t.ProvisionRowID
		GROUP BY a.PrvsnRwID
	) n
	ON n.PrvsnRwID = u.ProvisionRowID

	UPDATE a SET a.EventReference = t.EventReference,
					a.DeemedDates = ISNULL(a.DeemedDates,t.DeemedDate)
	FROM MTVDealPriceRowArchive a
	INNER JOIN #temp t
	ON t.ProvisionRowID = a.PrvsnRwID
	AND t.MaxRevisionID = a.RevisionID
END
GO

UPDATE MTVDealPriceRowArchive SET ColumnCheckSum = CHECKSUM(RowText,HolidayOptionName,SaturdayOptionName,SundayOptionName,DeemedDates,EventReference),
	SecondaryCheckSum = CHECKSUM(PrvsnRwID,PrvsnID,CostType,RowNumber,Differential,PrceTpeIdnty,
		RPHdrID,Actual,FixedValue,RuleName,RuleDescription,HolidayOption,SaturdayOption,
		SundayOption,CurveName,LcleID,CrrncyID,comment)
WHERE ColumnCheckSum != CHECKSUM(RowText,HolidayOptionName,SaturdayOptionName,SundayOptionName,DeemedDates,EventReference)