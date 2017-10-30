/*
*****************************************************************************************************
USE FIND AND REPLACE ON ParseTaxRule WITH YOUR Function
*****************************************************************************************************
*/




/****** Object:  UserDefinedFunction [dbo].[ParseTaxRule]    Script Date: 5/26/2016 7:08:13 PM ******/

IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseTaxRule]') IS NOT NULL
BEGIN
	DROP FUNCTION [dbo].[fn_MTV_ParseTaxRule]
	PRINT '<<< FUNCTION [dbo].[fn_MTV_ParseTaxRule] DROPPED >>>'
END



/****** Object:  UserDefinedFunction [dbo].[ParseTaxRule]    Script Date: 5/26/2016 7:08:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION [dbo].[fn_MTV_ParseTaxRule](@TxRleStID INT,@TxRleID INT) RETURNS VARCHAR(MAX)
AS
BEGIN
	IF(@TxRleID = 22) --Transaction Rule
	BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
			SELECT ' | ' + LTRIM(RTRIM(v.TrnsctnTypDesc))
			FROM fnParseList('|',(
			SELECT REPLACE(RuleValue,'||','|')
			FROM dbo.TaxRuleSetRule (NOLOCK)
			WHERE TxRleStID = @TxRleStID
			--WHERE TxRleStID = 35
			AND TxRleID = @TxRleID)) l
			INNER JOIN dbo.TransactionType v (NOLOCK)
			ON v.TrnsctnTypID = l.Data
			ORDER BY v.TrnsctnTypDesc  + ' '
			FOR XML PATH('')) AS l), ''),3, 500000000)
	END
	ELSE IF (@TxRleID = 33) --Deal Type Rule
	BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT ' | ' + LTRIM(RTRIM(v.Description))
										FROM fnParseList('|',(
										SELECT REPLACE(RuleValue,'||','|')
										FROM dbo.TaxRuleSetRule (NOLOCK)
										WHERE TxRleStID = @TxRleStID
										AND TxRleID = 33)) l
										INNER JOIN dbo.DealType v (NOLOCK)
										ON v.DlTypID = l.Data
										ORDER BY v.Description  + ''
										FOR XML PATH('')) AS l), ''),4, 500000000)
	END
	ELSE IF (@TxRleID in (35,44,45)) --License Rule
	BEGIN
		DECLARE @index INT,@rows INT,@ReturnVal VARCHAR(MAX),@groupord VARCHAR(2)
		DECLARE @Temp table (RowID int,groupord VARCHAR(2),compval VARCHAR(30), value VARCHAR(80))
		
			INSERT INTO @Temp
			SELECT RowID,SUBSTRING(Data,0,Comma1),SUBSTRING(Data,Comma1 + 1,Comma2 - Comma1 - 1), SUBSTRING(Data,Comma2+1,length - Comma2)
			FROM (
					SELECT	RowID,
							Data,
							CHARINDEX(',',Data,0) Comma1,
							CHARINDEX(',',Data,CHARINDEX(',',Data,0) + 1) Comma2,
							CHARINDEX(',',Data, LEN(Data) - CHARINDEX(',', REVERSE(Data)) -1) Comma3,
							LEN(Data) length
					FROM fnParseList('|',(
											SELECT REPLACE(RuleValue,'||','|')
											FROM dbo.TaxRuleSetRule (NOLOCK)
											WHERE TxRleStID = @TxRleStID  AND TxRleID = @TxRleID))) l
		

		SELECT @index = 2,@rows = @@ROWCOUNT,@groupord = '1'
		
		if (@rows < 1) RETURN NULL
			
		UPDATE t SET t.value = '''' + License.Name + '''' FROM @Temp t INNER JOIN dbo.License (NOLOCK) ON CAST(LcnseID AS VARCHAR) = t.value
		UPDATE @Temp SET compval = 'BusinessAssociate Doesn''t Have ' WHERE compval = 'not like'
		UPDATE @Temp SET compval = 'BusinessAssociate has ' WHERE compval = 'like'
		
		SELECT @ReturnVal = '(' + compval + value FROM @Temp WHERE RowID = 1

		WHILE (@index <= @rows)
		BEGIN
			SELECT @ReturnVal = @ReturnVal + CASE @groupord WHEN groupord THEN ' And ' ELSE ') - OR - (  ' END + compval + value FROM @Temp WHERE RowID = @index
			SELECT @groupord = groupord FROM @Temp WHERE RowID = @index
			SELECT @index = @index + 1
		END

		RETURN @ReturnVal + ')'
	END
	ELSE IF (@TxRleID in(31, 32)) ---- Tax Commodity Rules
		BEGIN
		RETURN SUBSTRING(ISNULL(  (SELECT(
										SELECT ' | ' + LTRIM(RTRIM(v.Description))
										FROM fnParseList('|',(
															    SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																--WHERE TxRleStID = 72 AND TxRleID = 32
																WHERE TxRleStID = @TxRleStID AND TxRleID = @TxRleID
																)) l
										INNER JOIN dbo.CommoditySubGroup v (NOLOCK)
										ON v.CmmdtySbGrpID = l.Data
										ORDER BY v.Description  + ' ' FOR XML PATH('')) AS l), ''),3, 500000000)
	END
	ELSE IF (@TxRleID = 30) ---- Movement Header Type Rule
		BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT ' | ' + LTRIM(RTRIM(v.Name))
										FROM fnParseList('|',(
															   --SELECT Replace (REPLACE(RuleValue,'||','|'), ' " ', '888888')
															    select REPLACE(REPLACE(RuleValue,'"',''), '||', '|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID AND TxRleID = @TxRleID
																--WHERE TxRleStID = 829 AND TxRleID = 30
																)) l
										INNER JOIN dbo.MovementHeaderType v (NOLOCK)
										ON v.MvtHdrTyp = l.Data
										ORDER BY v.Name  + ' '
										FOR XML PATH('')) AS l), ''),3, 500000000)
	  END
  	ELSE IF (@TxRleID = 40) ---<---- DEAL EXCLUSION RULE
		BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT '''|''' + LTRIM(RTRIM(v.DlHdrExtrnlNbr))
										FROM fnParseList('|',(
																SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID AND TxRleID = @TxRleID
																--WHERE TxRleStID = 829 AND TxRleID = 40
																)) l
																INNER JOIN dbo.DealHeader v (NOLOCK)
																ON v.DlHdrID = l.Data
																ORDER BY v.DlHdrExtrnlNbr  + ''
																FOR XML PATH('')
															  ) AS l), ''),3, 500000000)
	  END
    ELSE IF (@TxRleID = 39) ---<-----	DEAL RULE
		BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT '''|''' + LTRIM(RTRIM(v.DlHdrExtrnlNbr))
										FROM fnParseList('|',(
																SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID	AND TxRleID = @TxRleID
																--WHERE TxRleStID = 829 AND TxRleID = 39
																)) l
																INNER JOIN dbo.DealHeader v (NOLOCK)
																ON v.DlHdrID = l.Data
																ORDER BY v.DlHdrExtrnlNbr  + ' '
																FOR XML PATH('')
															  ) AS l), ''),3, 500000000)
	  END
	  ELSE IF (@TxRleID = 36) or --- Location Exclusion Rule (Destination)
	          (@TxRleID = 37) --- Location Exclusion Rule (Origin)
		BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT ''',''' + LTRIM(RTRIM(v.LcleAbbrvtn))
										FROM fnParseList('|',(
																SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID	AND TxRleID = @TxRleID
																--WHERE TxRleStID = 829 AND TxRleID = 39
																)) l
																INNER JOIN dbo.locale v (NOLOCK)
																ON v.LcleID = l.Data
																ORDER BY v.LcleNme  + ''
																FOR XML PATH('')
															  ) AS l), ''),3, 500000000)
	  END
	  	ELSE IF (@TxRleID IN (50))
		BEGIN 
			--DECLARE @index INT,@rows INT,@ReturnVal VARCHAR(MAX),@groupord VARCHAR(2)
			DECLARE  @TempTable TABLE (RowID int,groupord VARCHAR(2),compval VARCHAR(30), Operator varchar(20), value VARCHAR(80))
			INSERT INTO @TempTable
		    SELECT RowID, SUBSTRING(Data,0,Comma1), SUBSTRING(Data,Comma1 + 1,Comma2 - Comma1 - 1), SUBSTRING(Data,Comma2+1,(Comma3 - Comma2)-1), substring(Data, Comma3+1, length-Comma2)
		    FROM (
				  SELECT	
						RowID,
						Data,
						CHARINDEX(',',Data,0) Comma1,
						CHARINDEX(',',Data,CHARINDEX(',',Data,0) + 1) Comma2,
						CHARINDEX(',',Data, LEN(Data) - CHARINDEX(',', REVERSE(Data)) -1) Comma3,
						LEN(Data) length
				 FROM fnParseList('|',(
										SELECT REPLACE(RuleValue,'||','|')
										FROM dbo.TaxRuleSetRule (NOLOCK)
										WHERE TxRleStID = @TxRleStID  AND TxRleID = @TxRleID))
										--WHERE TxRleStID = 829  AND TxRleID = 44))
										--WHERE TxRleStID = 829  AND TxRleID = 50))
		                         ) l
		--END
		--select * from @TempTable

		SELECT @index = 2,@rows = @@ROWCOUNT,@groupord = '1'
		
		--if (@rows < 1) RETURN NULL
			
		UPDATE t SET t.value = '''' + License.Name + '''' FROM @TempTable t INNER JOIN dbo.License (NOLOCK) ON CAST(LcnseID AS VARCHAR) = t.value
		UPDATE t SET t.Operator = 'Has ' from @TempTable t where Operator = 'like'
		UPDATE t SET t.Operator = 'Doesn''t Have ' from @TempTable t where Operator = 'not like'
		
		SELECT @ReturnVal = '(' + compval + ' ' + Operator + ' '+ value FROM @TempTable WHERE RowID = 1

		WHILE (@index <= @rows)
		BEGIN
			SELECT @ReturnVal = @ReturnVal + CASE @groupord WHEN groupord THEN ' And ' ELSE ') - OR - (' END + compval + ' ' + Operator + ' ' + value FROM @TempTable WHERE RowID = @index
			SELECT @groupord = groupord FROM @TempTable WHERE RowID = @index
			SELECT @index = @index + 1
		END

		--select * from @TempTable

		RETURN @ReturnVal + ')'
	END
	ELSE IF (@TxRleID in(29, 31, 26, 27)) ---<---- BUSINESS ASSOCIATE RULES
	BEGIN
		RETURN SUBSTRING(ISNULL(  (SELECT(
										SELECT '''|''' + LTRIM(RTRIM(v.Name))
										FROM fnParseList('|',(
															    SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID AND TxRleID = @TxRleID
																--WHERE TxRleStID = 32 AND TxRleID = 24
																)) l
										INNER JOIN dbo.BusinessAssociate v (NOLOCK)
										ON v.BAID = l.Data
										ORDER BY v.Name  + ' ' FOR XML PATH('')) AS l), ''),3, 500000000)
	END
	ELSE IF (@TxRleID in (43, 49)) ---<---- WE PAY THEY PAY RULE / SUPPLY DEMAND RULE / MOVEMENT USAGE RULE
	BEGIN
		DECLARE @keyValue varchar(8)

		SELECT @keyValue = REPLACE(RuleValue,'||','|')
								FROM dbo.TaxRuleSetRule (NOLOCK)
								WHERE TxRleStID =  @TxRleStID AND TxRleID = @TxRleID
		IF @TxRleID = 49 
		BEGIN
			RETURN (select DynLstBxDesc from DynamicListBox where DynLstBxQlfr = 'WePayTheyPay' AND DynLstBxTyp = @keyValue)
		END 
		ELSE IF @TxRleID = 43
		BEGIN
			RETURN (select DynLstBxAbbv from DynamicListBox where DynLstBxQlfr = 'Supply/Demand' AND DynLstBxTyp = @keyValue)
		END		
	END
	ELSE IF (@TxRleID = 34) ---<-----	MOVEMENT USAGE RULE
		BEGIN
		RETURN SUBSTRING(ISNULL((SELECT(
										SELECT '''|''' + LTRIM(RTRIM(v.DynLstBxDesc))
										FROM fnParseList('|',(
																SELECT REPLACE(RuleValue,'||','|')
																FROM dbo.TaxRuleSetRule (NOLOCK)
																WHERE TxRleStID = @TxRleStID	AND TxRleID = @TxRleID
																--WHERE TxRleStID = 829 AND TxRleID = 39
																)) l
																INNER JOIN dbo.DynamicListBox v (NOLOCK)
																ON v.DynLstBxID = CAST(l.Data AS INT) + '' 
																--ORDER BY v.DlHdrExtrnlNbr  + ''''
																FOR XML PATH('')
															  ) AS l), ''),3, 500000000)
	  END
	  ELSE IF (@TxRleID in (25, 24)) --	PRODUCT RULE
	  BEGIN
		DECLARE @index1 INT,@rows1 INT,@ReturnVal1 VARCHAR(MAX),@groupord1 VARCHAR(2)
		--DECLARE @Temp1 table (RowID int,groupord VARCHAR(25),compval VARCHAR(30), value VARCHAR(80))
		DECLARE  @Temp1 TABLE (RowID int,compval VARCHAR(30), Operator varchar(20), value VARCHAR(80))

		
			INSERT	INTO @Temp1
			SELECT	RowID, 
					SUBSTRING(Data,0,Comma1), 
					SUBSTRING(Data,Comma1,1),
					SUBSTRING(Data,Comma1+1,Len(Data))

					--SUBSTRING(Data,Comma1 + 1,Comma2 - Comma1 - 1), 
					--SUBSTRING(Data,Comma2+1,(Comma3 - Comma2)-1), 
					--substring(Data, Comma3+1, length-Comma2)

			FROM (
					SELECT	RowID,
							Data,
							CHARINDEX('=',Data,0) Comma1,
							CHARINDEX('=',Data,CHARINDEX('=',Data,0) + 1) Comma2,
							CHARINDEX('=',Data, LEN(Data) - CHARINDEX('=', REVERSE(Data)) -1) Comma3,
							LEN(Data) length
					FROM fnParseList('|',(
											SELECT REPLACE(RuleValue,'||','|')
											FROM dbo.TaxRuleSetRule (NOLOCK)
											WHERE TxRleStID = @TxRleStID  AND TxRleID = @TxRleID
											--WHERE TxRleStID = 32  AND TxRleID = 24
											))) l
		--select * from @Temp1

		SELECT @index1 = 2,@rows1 = @@ROWCOUNT,@groupord1 = '1'
		
		if (@rows1 < 1) RETURN NULL
			
		UPDATE t 
		SET t.value = '''' + TaxProductAttribute.TxPrdctAttrbteDscrptn + '''' 
		FROM @Temp1 t INNER JOIN dbo.TaxProductAttribute (NOLOCK) ON CAST(TxPrdctAttrbteID AS VARCHAR) = t.value
		Where t.compval = 'PrdctAttrbteID'

		UPDATE t 
		SET t.value = '''' + Product.PrdctNme + '''' 
		FROM @Temp1 t INNER JOIN dbo.Product (NOLOCK) ON CAST(PrdctID AS VARCHAR) = t.value
		Where t.compval = 'PrdctID'

		UPDATE @Temp1 
		SET compval = 'Product = '
		WHERE compval = 'PrdctID'
		
		UPDATE @Temp1 
		SET compval = 'Product Attribute = ' 
		WHERE compval = 'PrdctAttrbteID'
		
		SELECT @ReturnVal = '(' + compval + value FROM @Temp1 WHERE RowID = 1 


		SELECT @ReturnVal = @ReturnVal + ' | ' +  compval + value FROM @Temp1 WHERE RowID = 2

		--WHILE (@index1 <= @rows1)
		--BEGIN
		--	SELECT @ReturnVal = @ReturnVal + CASE @groupord WHEN groupord THEN ' And ' ELSE ') - OR - (' END + compval + value FROM @Temp1 WHERE RowID = @index1
		--	SELECT @groupord = groupord FROM @Temp1 WHERE RowID = @index
		--	SELECT @index = @index1 + 1
		--END

		RETURN @ReturnVal + ')'
	END
	ELSE IF (@TxRleID in (23)) ---<---- LOCATION RULE
	BEGIN
			DECLARE @LocationRule VARCHAR (8000) = '', @recordCounter INT = 1, @totalRecords INT  , @rule varchar(8000)
			DECLARE  @Locations TABLE (RowID int Identity, LocationType VARCHAR(50), Operator varchar(20), LocationName VARCHAR(80))
			
			INSERT	 @Locations (LocationType,Operator,LocationName)
			SELECT  TxLctnTpeNme, Operator, LcleNme
			FROM	TaxLocationType TLT 
					INNER JOIN TaxLocation TL ON TL.TxLctnTpeID = TLT.TxLctnTpeID 
					INNER JOIN Locale Loc ON Loc.LcleID = TL.LcleID
			WHERE TL.TxRleStID = @TxRleStID  AND TL.TxRleID = @TxRleID
			
			SELECT @totalRecords = MAX(RowID) FROM @Locations

			WHILE(@recordCounter <= @totalRecords)
			BEGIN
			
			SELECT @LocationRule =  @LocationRule +  (SELECT CONCAT(LocationType , ' ', Operator , ' ', LocationName)
				                                      FROM @Locations WHERE RowID = @recordCounter) 
												  +  (Case WHEN @recordCounter <> @totalRecords THEN ' | ' ELSE '' END)
       
				SET @recordCounter  = @recordCounter  + 1   
			END

		RETURN @LocationRule
	END


	RETURN 'NOT APPLICABLE'
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseTaxRule]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'ParseTaxRule.sql'
			PRINT '<<< ALTERED Function fn_MTV_ParseTaxRule >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function fn_MTV_ParseTaxRule >>>'
	  END