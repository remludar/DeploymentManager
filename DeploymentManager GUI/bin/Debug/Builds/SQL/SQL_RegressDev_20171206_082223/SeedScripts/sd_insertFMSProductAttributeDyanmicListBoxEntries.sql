DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'BrandCatIndicator'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'BrandCategoryInd'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGroup'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGroup'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'
DELETE FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'

Declare @i_ID int

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'BrandCatIndicator' AND DynamicListBox.DynLstBxTyp = 'BrandedShell')      BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'BrandCatIndicator' , 'BrandedShell'   , 'Branded Shell'      , 'Branded Shell'      , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'BrandCatIndicator' AND DynamicListBox.DynLstBxTyp = 'Branded76')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'BrandCatIndicator' , 'Branded76'      , 'Branded 76'         , 'Branded 76'         , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'BrandCatIndicator' AND DynamicListBox.DynLstBxTyp = 'Unbranded')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'BrandCatIndicator' , 'Unbranded'      , 'Unbranded'          , 'Unbranded'          , 30, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGroup'      AND DynamicListBox.DynLstBxTyp = 'Gasoline')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGroup'      , '101 - Gasoline'       , 'Gasoline'           , 'Gasoline'           , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGroup'      AND DynamicListBox.DynLstBxTyp = 'Diesel')            BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGroup'      , '103 - Diesel'         , 'Diesel'             , 'Diesel'             , 20, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'CLEAR')             BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'CLEAR'          , 'CLEAR'              , 'CLEAR'              , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'OXY')               BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'OXY'            , 'OXY'                , 'OXY'                , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'RFG')               BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'RFG'            , 'RFG'                , 'RFG'                , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'HeatingOil')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'HeatingOil'     , 'Heating Oil'        , 'Heating Oil'        , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'ULSD')              BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'ULSD'           , 'ULSD'               , 'ULSD'               , 50, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductClass'      AND DynamicListBox.DynLstBxTyp = 'ULSDBio')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductClass'      , 'ULSDBio'        , 'ULSD Bio'           , 'ULSD Bio'           , 60, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'      AND DynamicListBox.DynLstBxTyp = 'Regular')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGrade'      , 'Regular'        , 'Regular'            , 'Regular'            , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'      AND DynamicListBox.DynLstBxTyp = 'Midgrade')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGrade'      , 'Midgrade'       , 'Midgrade'           , 'Midgrade'           , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'      AND DynamicListBox.DynLstBxTyp = 'Premium')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGrade'      , 'Premium'        , 'Premium'            , 'Premium'            , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'      AND DynamicListBox.DynLstBxTyp = 'Dyed')              BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGrade'      , 'Dyed'           , 'Dyed'               , 'Dyed'               , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGrade'      AND DynamicListBox.DynLstBxTyp = 'Clear')             BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGrade'      , 'Clear'          , 'Clear'              , 'Clear'              , 50, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'E10')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'E10'            , 'E10'                , 'E10'                , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'E15')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'E15'            , 'E15'                , 'E15'                , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'E85')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'E85'            , 'E85'                , 'E85'                , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'Clear')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'Clear'          , 'Clear'              , 'Clear'              , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B0005')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B0005'          , 'B00 05'             , 'B00 05'             , 50, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B01')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B01'            , 'B01'                , 'B01'                , 60, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B02')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B02'            , 'B02'                , 'B02'                , 70, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B0205')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B0205'          , 'B02 05'             , 'B02 05'             , 80, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B02R05')       BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B02R05'         , 'B02 R05'            , 'B02 R05'            , 90, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B03')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B03'            , 'B03'                , 'B03'                ,100, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B04')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B04'            , 'B04'                , 'B04'                ,110, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B05')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B05'            , 'B05'                , 'B05'                ,120, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B05R05')       BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B05R05'         , 'B05 R05'            , 'B05 R05'            ,130, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B20')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B20'            , 'B20'                , 'B20'                ,140, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'B50')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'B50'            , 'B50'                , 'B50'                ,150, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'R05')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'R05'            , 'R05'                , 'R05'                ,160, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductOxyBioFuel'      AND DynamicListBox.DynLstBxTyp = 'NoBio')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductOxyBioFuel' , 'NoBio'          , 'No Bio'             , 'No Bio'             ,170, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '87Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '87Oct'          , '87 Oct'             , '87 Oct'             , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '88Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '88Oct'          , '88 Oct'             , '88 Oct'             , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '89Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '89Oct'          , '89 Oct'             , '89 Oct'             , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '90Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '90Oct'          , '90 Oct'             , '90 Oct'             , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '91Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '91Oct'          , '91 Oct'             , '91 Oct'             , 50, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '92Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '92Oct'          , '92 Oct'             , '92 Oct'             , 60, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '93Oct')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '93Oct'          , '93 Oct'             , '93 Oct'             , 70, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '0to15ppmS')      BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '0to15ppmS'      , '0 to 15ppm S'       , '0 to 15ppm S'       , 80, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '351to500ppmS')   BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '351to500ppmS'   , '351 to 500ppm S'    , '351 to 500ppm S'    , 90, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '501to2000ppmS')  BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '501to2000ppmS'  , '501 to 2000ppm S'   , '501 to 2000ppm S'   ,100, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '2001to3000ppmS') BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '2001to3000ppmS' , '2001 to 3000 ppm S' , '2001 to 3000 ppm S' ,110, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductSubGrade'      AND DynamicListBox.DynLstBxTyp = '3001to5000ppmS') BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductSubGrade'   , '3001to5000ppmS' , '3001 to 5000 ppm S' , '3001 to 5000 ppm S' ,120, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'HVP')            BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'HVP'            , 'HVP'                , 'HVP'                , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'LVP')            BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'LVP'            , 'LVP'                , 'LVP'                , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'NVOC')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'NVOC'           , 'NVOC'               , 'NVOC'               , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'VOC1')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'VOC1'           , 'VOC1'               , 'VOC1'               , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'VOC2')           BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'VOC2'           , 'VOC2'               , 'VOC2'               , 50, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'AreaD')          BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'AreaD'          , 'Area D'             , 'Area D'             , 60, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'TX')             BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'TX'             , 'TX'                 , 'TX'                 , 70, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductRVPGroup'      AND DynamicListBox.DynLstBxTyp = 'Winter')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductRVPGroup'   , 'Winter'         , 'Winter'             , 'Winter'             , 80, 'V', 'A') END

IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULR')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULR'            , 'ULR'                , 'ULR'                , 10, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULM')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULM'            , 'ULM'                , 'ULM'                , 20, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULP')         BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULP'            , 'ULP'                , 'ULP'                , 30, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULRR')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULRR'           , 'ULRR'               , 'ULRR'               , 40, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULMR')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULMR'           , 'ULMR'               , 'ULMR'               , 50, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULPR')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULPR'           , 'ULPR'               , 'ULPR'               , 60, 'V', 'A') END
IF NOT EXISTS( SELECT '' FROM DynamicListBox WHERE DynamicListBox.DynLstBxQlfr = 'ProductGlobalGroup'      AND DynamicListBox.DynLstBxTyp = 'ULSD')        BEGIN EXEC sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_ID OUTPUT insert into DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts) VALUES ( @i_ID, 'ProductGlobalGroup', 'ULSD'           , 'ULSD'               , 'ULSD'               , 70, 'V', 'A') END
