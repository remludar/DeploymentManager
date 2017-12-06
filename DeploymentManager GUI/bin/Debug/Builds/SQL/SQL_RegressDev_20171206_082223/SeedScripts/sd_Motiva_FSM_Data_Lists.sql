DECLARE

  @i_DataProfileIDFSMShellBranded INT
, @i_DataProfileIDFSMUnBranded    INT
, @i_DataProfileDataListID1       INT
, @i_DataProfileDataListID2       INT
, @i_DataProfileDataListID3       INT
, @i_ID                           INT
, @i_WhileLoopPointer             INT
, @i_WhileLoopLimiter             INT
, @c_ChangeThings                 Char(1) = 'Y'
, @i_FSMInternalBAID              INT

 IF NOT EXISTS(SELECT '' FROM DataProfile WHERE DataProfile.DataProfileName = 'FSM Shell Branded')
   INSERT INTO DataProfile (DataProfileName, IsActive) VALUES ('FSM Shell Branded', 1)
 IF NOT EXISTS(SELECT '' FROM DataProfile WHERE DataProfile.DataProfileName = 'FSM Unbranded')
   INSERT INTO DataProfile (DataProfileName, IsActive) VALUES ('FSM Unbranded', 1)

SELECT @i_DataProfileIDFSMShellBranded = (SELECT DataProfile.DataProfileID FROM DataProfile WHERE DataProfile.DataProfileName = 'FSM Shell Branded')
     , @i_DataProfileIDFSMUnBranded    = (SELECT DataProfile.DataProfileID FROM DataProfile WHERE DataProfile.DataProfileName = 'FSM Unbranded')
     , @i_FSMInternalBAID              = (SELECT BusinessAssociate.BAID FROM BusinessAssociate WHERE BusinessAssociate.BAAbbrvtn = 'MOTIVA-FSM')

 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded and DataProfileDataList.DataListName = 'AlternateProductName')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMShellBranded, 'AlternateProductName', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded and DataProfileDataList.DataListName = 'AlternateProductNameLocation')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMShellBranded, 'AlternateProductNameLocation', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded and DataProfileDataList.DataListName = 'BusinessAssociateInternal')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMShellBranded, 'BusinessAssociateInternal', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded and DataProfileDataList.DataListName = 'MTVSAPMaterialCode')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMShellBranded, 'MTVSAPMaterialCode', 0)

 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded and DataProfileDataList.DataListName = 'AlternateProductName')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMUnBranded, 'AlternateProductName', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded and DataProfileDataList.DataListName = 'AlternateProductNameLocation')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMUnBranded, 'AlternateProductNameLocation', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded and DataProfileDataList.DataListName = 'BusinessAssociateInternal')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMUnBranded, 'BusinessAssociateInternal', 0)
 IF NOT EXISTS(SELECT '' FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded and DataProfileDataList.DataListName = 'MTVSAPMaterialCode')
   INSERT INTO DataProfileDataList (DataProfileID, DataListName, IncludeAllItems) VALUES (@i_DataProfileIDFSMUnBranded, 'MTVSAPMaterialCode', 0)

-- Internal BA
BEGIN
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded AND DataProfileDataList.DataListName = 'BusinessAssociateInternal')
IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_FSMInternalBAID as VarChar(20)))
   INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_FSMInternalBAID as VarChar(20)))
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded AND DataProfileDataList.DataListName = 'BusinessAssociateInternal')
IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_FSMInternalBAID as VarChar(20)))
   INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_FSMInternalBAID as VarChar(20)))
END


-- Alt Prods
IF OBJECT_ID('tempdb..#FSMProducts') IS NOT NULL DROP TABLE #FSMProducts
CREATE TABLE #FSMProducts (PrdctID INT, AlternateProductNameID INT, BrandCatIndicator VarChar(255), ProdLocExists Char(1))
INSERT INTO #FSMProducts (PrdctID, AlternateProductNameID, BrandCatIndicator, ProdLocExists)
(
SELECT
  Product.PrdctID
, AlternateProductNameID
--, RetailProduct.GnrlCnfgMulti
, BrandCatIndicator.GnrlCnfgMulti
, ProdLocExists =
     CASE
        WHEN ProdLocs.PrdctID IS NOT NULL THEN 'Y'
        ELSE 'N'
     END
FROM Product
JOIN AlternateProductName
  ON AlternateProductName.PrdctID = Product.PrdctID
JOIN GeneralConfiguration RetailProduct
  ON RetailProduct.GnrlCnfgTblNme = 'Product'
 AND RetailProduct.GnrlCnfgHdrID = Product.PrdctID
 AND RetailProduct.GnrlCnfgQlfr = 'RetailProduct'
 AND RetailProduct.GnrlCnfgMulti = 'Y'
JOIN GeneralConfiguration BrandCatIndicator
  ON BrandCatIndicator.GnrlCnfgTblNme = 'Product'
 AND BrandCatIndicator.GnrlCnfgHdrID = Product.PrdctID
 AND BrandCatIndicator.GnrlCnfgQlfr = 'BrandCatIndicator'
LEFT OUTER
JOIN (SELECT DISTINCT ProductLocale.PrdctID from ProductLocale) ProdLocs
                                                                ON ProdLocs.PrdctID = Product.PrdctID
 )
-- SELECT * FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell'


--Branded Alt Prods 
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded AND DataProfileDataList.DataListName = 'AlternateProductName')
      ,@i_DataProfileDataListID2 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded AND DataProfileDataList.DataListName = 'AlternateProductNameLocation')

SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell')
     , @i_WhileLoopLimiter = (SELECT MAX(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell')

WHILE @i_WhileLoopPointer <= @i_WhileLoopLimiter --WHILE loop Shell Branded Alt Prods
   BEGIN
     IF @c_ChangeThings = 'Y'
       BEGIN
         IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
           INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_WhileLoopPointer as VarChar(20)))
         IF    NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID2 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
		             AND (SELECT #FSMProducts.ProdLocExists FROM #FSMProducts WHERE #FSMProducts.AlternateProductNameID = @i_WhileLoopPointer AND #FSMProducts.BrandCatIndicator = 'BrandedShell') = 'Y'
              INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID2, CAST(@i_WhileLoopPointer as VarChar(20)))
       END

     IF (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell' AND #FSMProducts.AlternateProductNameID > @i_WhileLoopPointer) IS NOT NULL
	     SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell' AND #FSMProducts.AlternateProductNameID > @i_WhileLoopPointer)
		 ELSE SELECT @i_WhileLoopPointer = @i_WhileLoopPointer + 1

END --WHILE loop Shell Branded Alt Prods

--Unbranded Alt Prods
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded AND DataProfileDataList.DataListName = 'AlternateProductName')
      ,@i_DataProfileDataListID2 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded AND DataProfileDataList.DataListName = 'AlternateProductNameLocation')

SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded')
     , @i_WhileLoopLimiter = (SELECT MAX(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded')

WHILE @i_WhileLoopPointer <= @i_WhileLoopLimiter --WHILE loop Unbranded Alt Prods
   BEGIN
     IF @c_ChangeThings = 'Y'
       BEGIN
         IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
           INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_WhileLoopPointer as VarChar(20)))
         IF    NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID2 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
		             AND (SELECT #FSMProducts.ProdLocExists FROM #FSMProducts WHERE #FSMProducts.AlternateProductNameID = @i_WhileLoopPointer AND #FSMProducts.BrandCatIndicator = 'Unbranded') = 'Y'
              INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID2, CAST(@i_WhileLoopPointer as VarChar(20)))
       END

     IF (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE  #FSMProducts.BrandCatIndicator = 'Unbranded' AND #FSMProducts.AlternateProductNameID > @i_WhileLoopPointer) IS NOT NULL
	     SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.AlternateProductNameID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded' AND #FSMProducts.AlternateProductNameID > @i_WhileLoopPointer)
		 ELSE SELECT @i_WhileLoopPointer = @i_WhileLoopPointer + 1

END --WHILE loop Unbranded Alt Prods


-- SAP Material Codes

--Branded SAP Material Codes
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMShellBranded AND DataProfileDataList.DataListName = 'MTVSAPMaterialCode')

SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell')
     , @i_WhileLoopLimiter = (SELECT MAX(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell')

WHILE @i_WhileLoopPointer <= @i_WhileLoopLimiter --WHILE loop Shell Branded SAP Maaterial Codes
   BEGIN
     IF @c_ChangeThings = 'Y'
       BEGIN
         IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
           INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_WhileLoopPointer as VarChar(20)))
       END

     IF (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell' AND #FSMProducts.PrdctID > @i_WhileLoopPointer) IS NOT NULL
	     SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'BrandedShell' AND #FSMProducts.PrdctID > @i_WhileLoopPointer)
		 ELSE SELECT @i_WhileLoopPointer = @i_WhileLoopPointer + 1

END --WHILE loop Shell Branded SAP Maaterial Codes

--Unbranded SAP Material Codes
SELECT @i_DataProfileDataListID1 = (SELECT DataProfileDataList.DataProfileDataListID FROM DataProfileDataList WHERE DataProfileDataList.DataProfileID = @i_DataProfileIDFSMUnBranded AND DataProfileDataList.DataListName = 'MTVSAPMaterialCode')

SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded')
     , @i_WhileLoopLimiter = (SELECT MAX(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded')

WHILE @i_WhileLoopPointer <= @i_WhileLoopLimiter --WHILE loop Shell Unbranded SAP Maaterial Codes
   BEGIN
     IF @c_ChangeThings = 'Y'
       BEGIN
         IF NOT EXISTS(SELECT '' FROM DataProfileDataListException WHERE DataProfileDataListException.DataProfileDataListID = @i_DataProfileDataListID1 AND DataProfileDataListException.Value = CAST(@i_WhileLoopPointer as VarChar(20)))
           INSERT INTO DataProfileDataListException (DataProfileDataListID, Value) VALUES(@i_DataProfileDataListID1, CAST(@i_WhileLoopPointer as VarChar(20)))
       END

     IF (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded' AND #FSMProducts.PrdctID > @i_WhileLoopPointer) IS NOT NULL
	     SELECT @i_WhileLoopPointer = (SELECT MIN(#FSMProducts.PrdctID) FROM #FSMProducts WHERE #FSMProducts.BrandCatIndicator = 'Unbranded' AND #FSMProducts.PrdctID > @i_WhileLoopPointer)
		 ELSE SELECT @i_WhileLoopPointer = @i_WhileLoopPointer + 1

END --WHILE loop Shell Unbranded SAP Maaterial Codes






/*


SELECT
  DataProfileName
, DataProfileDataList.DataListName
, DataProfile.*, DataProfileDataList.*, DataProfileDataListException.*
FROM DataProfile
JOIN DataProfileDataList ON DataProfileDataList.DataProfileID = DataProfile.DataProfileID
--                        AND DataProfileDataList.DataListName = 'AlternateProductName'
JOIN DataProfileDataListException ON DataProfileDataListException.DataProfileDataListID = DataProfileDataList.DataProfileDataListID
WHERE DataProfile.DataProfileName like 'FSM%' AND DataProfileDataListException.Value = '500'

select distinct GeneralConfiguration.GnrlCnfgQlfr from GeneralConfiguration where GeneralConfiguration.GnrlCnfgTblNme = 'Product'
*/
