/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[fn_MTV_GetTaxLocaleStructureFlat]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_GetTaxLocaleStructureFlat.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_GetTaxLocaleStructureFlat]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[fn_MTV_GetTaxLocaleStructureFlat](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function fn_MTV_GetTaxLocaleStructureFlat >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER Function [dbo].[fn_MTV_GetTaxLocaleStructureFlat] (
        @LcleID         int
      , @LcleTpe        varchar (80)
        )
Returns Varchar(120) 
As
--****************************************************************************************************************
-- Name:       fn_MTV_GetTaxLocaleStructureFlat.sql
-- Overview:   
-- Created by: Sanjay Kumar, OpenLink
-- History:    13 July 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
-- 13 July 2016 Sanjay Kumar    Motiva   Initial Creation
------------------------------------------------------------------------------------------------------------------
Begin

    Declare @ls_LcleAbbrvtn     varchar (120)
    
    Select  @ls_LcleAbbrvtn = LcleAbbrvtn_S
    From    (   Select  L.LcleID
                      , LcleAbbrvtn = L.LcleAbbrvtn + ISNULL(L.LcleAbbrvtnExtension,'')
                      , LcleTpeDscrptn = LT_Parent.LcleTpeDscrptn
                      , LcleAbbrvtn_S = Replace(PG.Name,'Tax||','')
                From    Locale L (NoLock)
                Join    P_PositionGroupChemicalLocaleFlat CLFlat
                        On  L.LcleID = CLFlat.LcleID
                Join    Product P (NoLock)
                        On  CLFlat.PrdctID = P.PrdctID
                        And P.PrdctAbbv = 'Global Product'
                Join    P_PositionGroupTemplate PGT (NoLock)
                        On  CLFlat.P_PstnGrpTmplteIDParent = PGT.P_PstnGrpTmplteID
                        And CLFlat.P_PstnGrpTmplteIDChild = PGT.P_PstnGrpTmplteID
                        And PGT.Description = 'Location'
                Join    LocaleType LT (NoLock)
                        On  L.LcleTpeID = LT.LcleTpeID
                        --And LT.LcleTpeIsPhscl = 'Y'	--Removed by MattV 10/29/2016 Defect# 3384, this was filtering out records
														--Which were of types City/County/State, which are non-physical.
														--If we allow them to select Locales of these types on a Movement
														--Then they need to know, and we should interface, the tax information that is available
                Join    P_PositionGroup PG (NoLock)
                        On  CLFlat.PrntP_PstnGrpID = PG.P_PstnGrpID
                        And PG.Name like 'Tax||%'
                Join    P_PositionGroupChemicalLocaleFlat CLFlat_Parent (NoLock)
                        On  CLFlat.PrntP_PstnGrpID = CLFlat_Parent.P_PstnGrpID
                        And CLFlat_Parent.ChldP_PstnGrpID IS NULL
                Join    Locale L_Sub (NoLock)
                        On  L_Sub.LcleID = CLFlat_Parent.LcleID
                Join    LocaleType LT_Parent (NoLock)
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
If OBJECT_ID('fn_MTV_GetTaxLocaleStructureFlat') Is NOT Null
  BEGIN
    PRINT '<<< CREATED FUNCTION fn_MTV_GetTaxLocaleStructureFlat >>>'
    GRANT  EXECUTE  ON dbo.fn_MTV_GetTaxLocaleStructureFlat TO sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating FUNCTION fn_MTV_GetTaxLocaleStructureFlat>>>'
GO


--End of Script: fn_MTV_GetTaxLocaleStructureFlat.sql