/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[fn_MTV_GetLocaleStructureFlat]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_GetLocaleStructureFlat.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_GetLocaleStructureFlat]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[fn_MTV_GetLocaleStructureFlat](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function fn_MTV_GetLocaleStructureFlat >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER Function [dbo].[fn_MTV_GetLocaleStructureFlat] (
        @LcleID         int
      , @LcleTpe        varchar (80)
        )
Returns Varchar(120) 
As
--****************************************************************************************************************
-- Name:       fn_MTV_GetLocaleStructureFlat.sql
-- Overview:   
-- Created by: Sean Brown, SolArc
-- History:    31 May 2012 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
-- 31 May 2012  Sean Brown      Endeavour   Initial Creation
-- 17 Jul 2012  SABrown         Endeavour   Fix JOIN for Position Group to use P_PositionGroupChemicalLocaleFlat
------------------------------------------------------------------------------------------------------------------
Begin

    Declare @ls_LcleAbbrvtn     varchar (120)
    
    Select  @ls_LcleAbbrvtn = LcleAbbrvtn_S
    From    (   Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LcleTpeDscrptn = LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'Tax||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'Tax||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                UNION ALL
                Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'State||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'State||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                UNION ALL
                Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'Province or Territory||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'Province or Territory||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                UNION ALL
                Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'Country||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'Country||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                UNION ALL
                Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'City||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'City||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                UNION ALL
                Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'County||','')
                From    Locale L
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT
                        On  L.LcleTpeID = LT.LcleTpeID
                        And LT.LcleTpeIsPhscl = 'Y'
                Join    P_PositionGroup PG
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'County||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent
                        On  L_Sub.LcleTpeID = LT_Parent.LcleTpeID
                        And LT_Parent.LcleTpeDscrptn = @LcleTpe
                )       SUB1
    Where   LcleID = @LcleID
    And     LcleTpeDscrptn = @LcleTpe

    Return  @ls_LcleAbbrvtn

End

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser and notify user
--------------------------------------------*/
If OBJECT_ID('fn_MTV_GetLocaleStructureFlat') Is NOT Null
  BEGIN
    PRINT '<<< CREATED FUNCTION fn_MTV_GetLocaleStructureFlat >>>'
    GRANT  EXECUTE  ON dbo.fn_MTV_GetLocaleStructureFlat TO sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating FUNCTION fn_MTV_GetLocaleStructureFlat>>>'
GO


--End of Script: fn_MTV_GetLocaleStructureFlat.sql