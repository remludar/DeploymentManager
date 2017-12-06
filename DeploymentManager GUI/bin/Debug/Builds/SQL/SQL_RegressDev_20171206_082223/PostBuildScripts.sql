/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetUOMConversionFactorSQLAsValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetUOMConversionFactorSQLAsValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function GetUOMConversionFactorSQLAsValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function GetUOMConversionFactorSQLAsValue >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_GetRawPriceValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_GetRawPriceValue.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetRawPriceValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_GetRawPriceValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_GetRawPriceValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_GetRawPriceValue >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_GetRegistryValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_GetRegistryValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetRegistryValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_GetRegistryValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_GetRegistryValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_GetRegistryValue >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_RequiresMTVElemicaXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVElemicaXReferencing.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVElemicaXReferencing]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_RequiresMTVElemicaXReferencing TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_RequiresMTVElemicaXReferencing >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_RequiresMTVElemicaXReferencing >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_RequiresMTVTMSGaugeXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVTMSGaugeXReferencing.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVTMSGaugeXReferencing]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_RequiresMTVTMSGaugeXReferencing TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_RequiresMTVTMSGaugeXReferencing >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_RequiresMTVTMSGaugeXReferencing >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_RequiresMTVTMSXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVTMSXReferencing.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVTMSXReferencing]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_RequiresMTVTMSXReferencing TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_RequiresMTVTMSXReferencing >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_RequiresMTVTMSXReferencing >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  MTV_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GetGeneralConfigValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_GetGeneralConfigValue.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetGeneralConfigValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetGeneralConfigValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_GetGeneralConfigValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_GetGeneralConfigValue >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  CompanyName_FN_ is already set*************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_fn_LookupTaxExtractValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=Motiva_fn_LookupTaxExtractValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_fn_LookupTaxExtractValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_fn_LookupTaxExtractValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_fn_LookupTaxExtractValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_fn_LookupTaxExtractValue >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[fn_MTV_ParseList]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_ParseList.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseList]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.fn_MTV_ParseList TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function fn_MTV_ParseList >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function fn_MTV_ParseList >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON ParseTaxRule WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[FN_ParseTaxRule]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_ParseTaxRule.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseTaxRule]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.fn_MTV_ParseTaxRule TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function fn_MTV_ParseTaxRule >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function fn_MTV_ParseTaxRule >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxAccountingTransactionData WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxAccountingTransactionData]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxAccountingTransactionData.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxAccountingTransactionData]') IS NOT NULL
  BEGIN
    GRANT  SELECT   ON dbo.MTV_TaxAccountingTransactionData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_TaxAccountingTransactionData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_TaxAccountingTransactionData >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxMovementTransactionData WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxMovementTransactionData]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxMovementTransactionData.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxMovementTransactionData]') IS NOT NULL
  BEGIN
    GRANT  SELECT   ON dbo.MTV_TaxMovementTransactionData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_TaxMovementTransactionData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_TaxMovementTransactionData >>>'
PRINT 'Start Script=MOT_Get_Movements_to_Automatch.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Get_Movements_to_Automatch]') IS NOT NULL
BEGIN
    GRANT  EXECUTE  ON dbo.MOT_Get_Movements_to_Automatch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_Get_Movements_to_Automatch >>>' 
END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_Get_Movements_to_Automatch >>>'
GO


/*
*****************************************************************************************************
USE FIND AND REPLACE ON MOT_Search_Request_Message_Log WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_Search_Request_Message_Log]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_Search_Request_Message_Log.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Search_Request_Message_Log]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_Search_Request_Message_Log TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_Search_Request_Message_Log >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_Search_Request_Message_Log >>>'


/****** Object:  ViewName [dbo].[MTV_DLInvStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_DLInvStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStage >>>'
GO

/****** Object:  ViewName [dbo].[MTV_DLInvStage_Complete]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_DLInvStage_Complete.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage_Complete]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStage_Complete TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStage_Complete >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStage_Complete >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_search_ba_expiring_licenses WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_search_ba_expiring_licenses]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_search_ba_expiring_licenses.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_search_ba_expiring_licenses]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_search_ba_expiring_licenses TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_search_ba_expiring_licenses >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_search_ba_expiring_licenses >>>'
GO
PRINT 'Start Script=MTV_CalcMvtQtySum.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CalcMvtQtySum]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CalcMvtQtySum TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CalcMvtQtySum >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CalcMvtQtySum >>>'
GO
PRINT 'Start Script=MTV_CIRReportSearch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportSearch]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CIRReportSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CIRReportSearch >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CIRReportSearch >>>'
GO
PRINT 'Start Script=MTV_ClearPendingSAP.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ClearPendingSAP]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ClearPendingSAP TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ClearPendingSAP >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ClearPendingSAP >>>'
GO
PRINT 'Start Script=MTV_DLInvStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStaging_Purge]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStaging_Purge TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStaging_Purge >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStaging_Purge >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FN_GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FN_GetUOMConversionFactorSQLAsValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_NewTaxCombinations WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_NewTaxCombinations]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_NewTaxCombinations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_NewTaxCombinations]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_NewTaxCombinations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_NewTaxCombinations >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_NewTaxCombinations >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Market_Delete WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Market_Delete]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Market_Delete.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Delete]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Market_Delete TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Market_Delete >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Market_Delete >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Market_Insert WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Market_Insert]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Market_Insert.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Insert]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Market_Insert TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Market_Insert >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Market_Insert >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Trade_Delete WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Trade_Delete]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Trade_Delete.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Delete]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Trade_Delete TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Trade_Delete >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Trade_Delete >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Trade_Insert WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Trade_Insert]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Trade_Insert.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Insert]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Trade_Insert TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Trade_Insert >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Trade_Insert >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_AccountDetail WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_AccountDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_AccountDetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_AccountDetail]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_AccountDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_AccountDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_AccountDetail >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_A_SnapShot WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_A_SnapShot]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_A_SnapShot.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_A_SnapShot]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_A_SnapShot TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_A_SnapShot >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_A_SnapShot >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_EstimatedAccountDetail WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_EstimatedAccountDetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_EstimatedAccountDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_ExternalColumns WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_ExternalColumns]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_ExternalColumns.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_ExternalColumns]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_ExternalColumns TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_RiskAdjustment WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_RiskAdjustment]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_RiskAdjustment.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_RiskAdjustment]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_RiskAdjustment TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_RiskAdjustment >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_RiskAdjustment >>>'

PRINT 'Start Script=MTV_SAPStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAPStaging_Purge]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAPStaging_Purge TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAPStaging_Purge >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAPStaging_Purge >>>'
GO

/****** Object:  ViewName [dbo].[MTV_SAP_APStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SAP_APStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_APStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_APStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_APStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_APStage >>>'
GO

/****** Object:  ViewName [dbo].[MTV_SAP_ARStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SAP_ARStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_ARStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_ARStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_ARStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_ARStage >>>'
GO

/****** Object:  ViewName [dbo].[MTV_SAP_GLStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SAP_GLStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GLStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_GLStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_GLStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_GLStage >>>'
GO
/****** Object:  ViewName [dbo].[MTV_SAP_GL_CreateIdocs]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_GL_CreateIdocs.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GL_CreateIdocs]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_GL_CreateIdocs TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_GL_CreateIdocs >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_GL_CreateIdocs >>>'


/****** Object:  ViewName [dbo].[MTV_SAP_MsgHandler]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_MsgHandler.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_MsgHandler]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_MsgHandler TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_MsgHandler >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_MsgHandler >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MOT_Get_NewTaxCombinations WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_SearchNewTaxCombinations]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_SearchNewTaxCombinations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_SearchNewTaxCombinations]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_SearchNewTaxCombinations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_SearchNewTaxCombinations  >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_SearchNewTaxCombinations >>>'

/****** Object:  ViewName [dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_UpdateYPPriceCurveUseForRiskFlag.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdateYPPriceCurveUseForRiskFlag TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>'

GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_all_exchdiff_statement_retrieve_details_with_regrades WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_all_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_custom_all_exchdiff_statement_retrieve_details_with_regrades TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_retrieve_details_with_regrades >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_retrieve_details_with_regrades >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_exchdiff_statement_retrieve_details_with_regrades WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_custom_exchdiff_statement_retrieve_details_with_regrades TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_GetDealHeaderTemplateDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDealHeaderTemplateDetails.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetDealHeaderTemplateDetails]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_GetDealHeaderTemplateDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_GetDealHeaderTemplateDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_GetDealHeaderTemplateDetails >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetDeliveryPeriodRollOffBoardDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDeliveryPeriodRollOffBoardDate.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOffBoardDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetDeliveryPeriodRollOffBoardDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetDeliveryPeriodRollOnBoardDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDeliveryPeriodRollOnBoardDate.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOnBoardDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetDeliveryPeriodRollOnBoardDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure (NOTE:  Motiva_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>'
GO

/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv2_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv2_bulk.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_bulk]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv2_bulk TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_bulk >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_bulk >>>'


   /****** Object:  ViewName [dbo].[STOREDPROCEDURENAME]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv2_fsm.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_fsm]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv2_fsm TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_fsm >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_fsm >>>'



/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_bulk_summary.GRANT WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv_bulk_summary.GRANT]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv_bulk_summary.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_bulk_summary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv_bulk_summary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv_bulk_summary.GRANT >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv_bulk_summary.GRANT >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_rins WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv_rins.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_rins]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv_rins TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv_rins >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv_rins >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_footer_terminalstatement WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_footer_terminalstatement]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_footer_terminalstatement.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_footer_terminalstatement]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_footer_terminalstatement TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_footer_terminalstatement >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_footer_terminalstatement >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_header_mtv_rins WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_header_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_header_mtv_rins.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_rins]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_header_mtv_rins TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_header_mtv_rins >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_header_mtv_rins >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_header_mtv_ta WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_header_mtv_ta]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_header_mtv_ta.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_ta]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_header_mtv_ta TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_header_mtv_ta >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_header_mtv_ta >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_Invoice_Template_Instructions_MTV_RINS WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[SP_Invoice_Template_Instructions_MTV_RINS]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions_MTV_RINS.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_Invoice_Template_Instructions_MTV_RINS]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SP_Invoice_Template_Instructions_MTV_RINS TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SP_Invoice_Template_Instructions_MTV_RINS >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SP_Invoice_Template_Instructions_MTV_RINS >>>'
GO
/****** Object:  ViewName [dbo].[SP_Invoice_Template_Instructions_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions_TA.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO
if OBJECT_ID('SP_Invoice_Template_Instructions_TA')is not null begin
   print '<<< Procedure SP_Invoice_Template_Instructions_TA created >>>'
   grant execute on SP_Invoice_Template_Instructions_TA to sysuser, RightAngleAccess
end
else
   print '<<<< Creation of procedure SP_Invoice_Template_Instructions_TA failed >>>'


/****** Object:  ViewName [dbo].[sp_invoice_template_summary_mtv_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv_bulk.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO
if OBJECT_ID('sp_invoice_template_summary_mtv_bulk')is not null begin
   print '<<< Procedure sp_invoice_template_summary_mtv_bulk created >>>'
   grant execute on sp_invoice_template_summary_mtv_bulk to sysuser, RightAngleAccess
end
else
   print '<<<< Creation of procedure sp_invoice_template_summary_mtv_bulk failed >>>'


/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_summary_mtv_rins WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_summary_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv_rins.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_summary_mtv_rins]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_summary_mtv_rins TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_summary_mtv_rins >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_summary_mtv_rins >>>'
GO
   PRINT 'Start Script=sp_invoice_template_tax_summary_mtv_fsm.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_tax_summary_mtv_fsm]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_tax_summary_mtv_fsm TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_tax_summary_mtv_fsm >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_tax_summary_mtv_fsm >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure (NOTE:  Motiva_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_sp_MotivaBuildStatisticsInsertUpdateSQLScripts.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MotivaBuildStatisticsInsertUpdateSQLScripts]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MotivaBuildStatisticsInsertUpdateSQLScripts TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MotivaBuildStatisticsInsertUpdateSQLScripts >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MotivaBuildStatisticsInsertUpdateSQLScripts >>>'
GO
﻿/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchVendorMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_ArchivePlannedTransferHistory.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_ArchivePlannedTransferHistory]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_ArchivePlannedTransferHistory TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_ArchivePlannedTransferHistory >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_ArchivePlannedTransferHistory >>>'

PRINT 'Start Script=MOT_TransferAuditSearch.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_TransferAuditSearch]') IS NOT NULL
BEGIN
    GRANT  EXECUTE  ON dbo.MOT_TransferAuditSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_TransferAuditSearch >>>' 
END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_TransferAuditSearch >>>'
GO


/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MPC_Statement_Detail_Mtv_TA.GRANT WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MPC_Statement_balance_Mtv_TA.GRANT]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MPC_Statement_balance_Mtv_TA.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_balance_Mtv_TA]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MPC_Statement_balance_Mtv_TA TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MPC_Statement_balance_Mtv_TA >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MPC_Statement_balance_Mtv_TA >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MPC_Statement_Detail_Mtv_TA WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MPC_Statement_Detail_Mtv_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MPC_Statement_Detail_Mtv_TA.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MPC_Statement_Detail_Mtv_TA TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVApplyStagingTableUpdatesToDealDetailShipToTable WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVApplyStagingTableUpdatesToDealDetailShipToTable.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVApplyStagingTableUpdatesToDealDetailShipToTable TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>'
GO

/****** Object:  ViewName [dbo].[MTVArchiveDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealDetails.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealDetails]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealDetails >>>'


/****** Object:  ViewName [dbo].[MTVArchiveDealHeaders]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealHeaders.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealHeaders]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealHeaders TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealHeaders >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealHeaders >>>'


/****** Object:  ViewName [dbo].[MTVArchiveDealPriceRows]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealPriceRows.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealPriceRows]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealPriceRows TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealPriceRows >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealPriceRows >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVCheckDealDetailShipTosForOutOfSyncIssues WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVCheckDealDetailShipTosForOutOfSyncIssues.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVCheckDealDetailShipTosForOutOfSyncIssues TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>'
GO

/****** Object:  ViewName [dbo].[MTVDataLakePricesExport]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVDataLakePricesExport.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakePricesExport]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVDataLakePricesExport TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVDataLakePricesExport >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVDataLakePricesExport >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVExtractTaxRulesSP]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVExtractTaxRulesSP.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVExtractTaxRulesSP]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVExtractTaxRulesSP TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVExtractTaxRulesSP >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVExtractTaxRulesSP >>>'
﻿/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchVendorMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchContactMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchContactMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchContactMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchContactMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchContactMasterDataStaging >>>'

﻿/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchCustomerMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSearchCustomerMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchCustomerMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchCustomerMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchCustomerMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchCustomerMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchCustomerMasterDataStaging >>>'

﻿/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchCustomerMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSearchCustomerMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchSoldToMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchSoldToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchSoldToMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchSoldToMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchSoldToMasterDataStaging >>>'

﻿/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchSoldToShipToMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSearchSoldToShipToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchSoldToShipToMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchSoldToShipToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchSoldToShipToMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchSoldToShipToMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchSoldToShipToMasterDataStaging >>>'





/****** Object:  ViewName [dbo].[sp_MTVTaxDetailInserted]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTaxDetailInserted.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTaxDetailInserted]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTaxDetailInserted TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTaxDetailInserted >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTaxDetailInserted >>>'

GO   PRINT 'Start Script=sp_MTVTMSContractCheckForDataChanged.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractCheckForDataChanged]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSContractCheckForDataChanged TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSContractCheckForDataChanged >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSContractCheckForDataChanged >>>'


/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSContractData_Grant WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTVTMSContractData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSContractData.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractData]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSContractData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSContractData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSContractData >>>'

GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTV_TMSNominationData WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTVTMSNominationData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSNominationData.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSNominationData]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSNominationData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSNominationData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSNominationData >>>'

GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateMTVRetailerInvoicePreStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTruncateMTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVTruncateMTVRetailerInvoicePreStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateMTVRetailerInvoicePreStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVTruncateMTVRetailerInvoicePreStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateTaxTransactionStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTruncateTaxTransactionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVTruncateTaxTransactionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateTaxTransactionStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVTruncateTaxTransactionStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVTruncateTaxTransactionStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVTruncateTaxTransactionStaging >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVUpdateDealDetailShipToDealDetailID WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVUpdateDealDetailShipToDealDetailID]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVUpdateDealDetailShipToDealDetailID.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpdateDealDetailShipToDealDetailID]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVUpdateDealDetailShipToDealDetailID TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVUpsertOrionNominationStage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVUpsertOrionNominationStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVUpsertOrionNominationStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpsertOrionNominationStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVUpsertOrionNominationStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVUpsertOrionNominationStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVUpsertOrionNominationStage >>>'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_AllOrdersInBatchComplete]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_AllOrdersInBatchComplete] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_AllOrdersInBatchComplete] to sysuser, RightAngleAccess
End
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_AllOrdersWithTripNumberComplete]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_AllOrdersWithTripNumberComplete] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_AllOrdersWithTripNumberComplete] to sysuser, RightAngleAccess
End
go
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_BaseOilsOrderConfirmation 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_BaseOilsOrderConfirmation]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_BaseOilsOrderConfirmation.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_BaseOilsOrderConfirmation]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_BaseOilsOrderConfirmation TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_BaseOilsOrderConfirmation >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_BaseOilsOrderConfirmation >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CheckMATxns WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CheckMATxns]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_CheckMATxns.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CheckMATxns]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CheckMATxns TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CheckMATxns >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CheckMATxns >>>'
GO



/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CirDetailStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CirDetailStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_CirDetailStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirDetailStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CirDetailStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CirDetailStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CirDetailStage >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CirHeaderStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CirHeaderStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_CirHeaderStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirHeaderStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CirHeaderStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CirHeaderStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CirHeaderStage >>>'

PRINT 'Start Script=MTV_CIRReportDetailSearch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportDetailSearch]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CIRReportDetailSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CIRReportDetailSearch >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CIRReportDetailSearch >>>'
GO
PRINT 'Start Script=MTV_CIRReportSearch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportSearch]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CIRReportSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CIRReportSearch >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CIRReportSearch >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[[MTVCreditInterfaceExternalExposure]]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTVCreditInterfaceExternalExposure].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceExternalExposure]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTVCreditInterfaceExternalExposure] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTVCreditInterfaceExternalExposure] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTVCreditInterfaceExternalExposure] >>>'


/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[[MTVCreditInterfaceStagingArchive]]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTV_Credit_Interface_Archive_Staging].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Interface_Archive_Staging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTV_Credit_Interface_Archive_Staging] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTV_Credit_Interface_Archive_Staging] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTV_Credit_Interface_Archive_Staging] >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Credit_Interface_Extract]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTV_Credit_Interface_Extract].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Interface_Extract]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTV_Credit_Interface_Extract] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTV_Credit_Interface_Extract] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTV_Credit_Interface_Extract] >>>'/****** Object:  ViewName [dbo].[MTV_Delete_NewPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Delete_NewPrices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Delete_NewPrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Delete_NewPrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Delete_NewPrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Delete_NewPrices >>>'

GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON ExcelPriceLoadXRef WITH YOUR stored procedure (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ExcelPriceLoadXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_ExcelPriceLoadXRef.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ExcelPriceLoadXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ExcelPriceLoadXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ExcelPriceLoadXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ExcelPriceLoadXRef >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_CorrectBillingTermOnInvoices WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FedTax_CorrectBillingTermOnInvoices.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_CorrectBillingTermOnInvoices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_HoldErroneousInvoices WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_HoldErroneousInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FedTax_HoldErroneousInvoices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_HoldErroneousInvoices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_HoldErroneousInvoices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_PlaceInvoicesInActiveStatus WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FedTax_PlaceInvoicesInActiveStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_PlaceInvoicesInActiveStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductDiscountSurchargeEvaluator WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSProductDiscountSurchargeEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductDiscountSurchargeEvaluator.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductDiscountSurchargeEvaluator]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSProductDiscountSurchargeEvaluator TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductPriceEvaluator WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSProductPriceEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductPriceEvaluator.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductPriceEvaluator]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSProductPriceEvaluator TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSProductPriceEvaluator >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSProductPriceEvaluator >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSStagePrices WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSStagePrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FPSStagePrices.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSStagePrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSStagePrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSStagePrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSStagePrices >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPS_Price_Recon 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPS_Price_Recon]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FPS_Price_Recon.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPS_Price_Recon]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPS_Price_Recon TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPS_Price_Recon >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPS_Price_Recon >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Freight_Lookup TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Freight_Lookup >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Freight_Lookup >>>'

PRINT 'Start Script=MTV_GetForecastDealsObligation.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetForecastDealsObligation]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetForecastDealsObligation TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetForecastDealsObligation >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetForecastDealsObligation >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetFPSFuelSalesVol WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GetFPSFuelSalesVol]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_GetFPSFuelSalesVol.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetFPSFuelSalesVol]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetFPSFuelSalesVol TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetFPSFuelSalesVol >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetFPSFuelSalesVol >>>'
GO
PRINT 'Start Script=MTV_GetTempMarkToMarket.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetTempMarkToMarket TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetTempMarkToMarket >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetTempMarkToMarket >>>'
GO
PRINT 'Start Script=MTV_GetTempRiskExposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetTempRiskExposure TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetTempRiskExposure >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetTempRiskExposure >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_EventDate_Or_MovementDate WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_EventDate_Or_MovementDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_EventDate_Or_MovementDate.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_EventDate_Or_MovementDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_EventDate_Or_MovementDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_PlannedTransferMethodOfTrans WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_PlannedTransferMethodOfTrans]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_PlannedTransferMethodOfTrans.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_PlannedTransferMethodOfTrans]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_PlannedTransferMethodOfTrans TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_Transportation_Method WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_Transportation_Method]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_Transportation_Method.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_Transportation_Method]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_Transportation_Method TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_Transportation_Method >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_Transportation_Method >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxAccountingTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxAccountingTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxAccountingTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxAccountingTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxAccountingTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxAccountingTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxAccountingTransactions >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxMovementTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxMovementTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxMovementTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxMovementTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxMovementTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxMovementTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxMovementTransactions >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxTransactions >>>'
GO



/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTransferPrices WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTransferPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTransferPrices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTransferPrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTransferPrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTransferPrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTransferPrices >>>'
GO



/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_LoadFPSFuelSalesVolStaging WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_LoadFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_LoadFPSFuelSalesVolStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_LoadFPSFuelSalesVolStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_LoadFPSFuelSalesVolStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON ManualBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_ManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ManualBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ManualBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ManualBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ManualBOLXRef >>>'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber] to sysuser, RightAngleAccess
End
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_MaxBargeUnLoadDateInBatch]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_MaxBargeUnLoadDateInBatch] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_MaxBargeUnLoadDateInBatch] to sysuser, RightAngleAccess
End
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_MinBargeLoadDateForOrderTripNumber]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_MinBargeLoadDateForOrderTripNumber] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_MinBargeLoadDateForOrderTripNumber] to sysuser, RightAngleAccess
End
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_MinBargeLoadDateInBatch]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_MinBargeLoadDateInBatch] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_MinBargeLoadDateInBatch] to sysuser, RightAngleAccess
End
go
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_MTDIncrementalTaxTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_MTDIncrementalTaxTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_MTDIncrementalTaxTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_MTDIncrementalTaxTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_MTDIncrementalTaxTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_MTDIncrementalTaxTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_MTDIncrementalTaxTransactions >>>'
GO



/*
*****************************************************************************************************
USE FIND AND REPLACE ON tax_transactions_stage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_mtd_tax_transactions_stage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_mtd_tax_transactions_stage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_mtd_tax_transactions_stage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_mtd_tax_transactions_stage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_mtd_tax_transactions_stage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_mtd_tax_transactions_stage >>>'
GO



/*
*****************************************************************************************************
USE FIND AND REPLACE ON OASActualXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OASActualXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_OASActualXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OASActualXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_OASActualXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_OASActualXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_OASActualXRef >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVOrionNominationStagingRetrieve WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOrionNominationStagingRetrieve]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVOrionNominationStagingRetrieve.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStagingRetrieve]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVOrionNominationStagingRetrieve TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVOrionNominationStagingRetrieve >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVOrionNominationStagingRetrieve >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON OSPManualBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_OSPManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OSPManualBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_OSPManualBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_OSPManualBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_OSPManualBOLXRef >>>'
GO
PRINT 'Start Script=MTV_ParentInvoiceAttributes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ParentInvoiceAttributes]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ParentInvoiceAttributes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ParentInvoiceAttributes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ParentInvoiceAttributes >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON PetroExBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_PetroExBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_PetroExBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_PetroExBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_PetroExBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_PetroExBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_PetroExBOLXRef >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_PortArthur_TransferPrice 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Secondary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_PortArthur_TransferPrice.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_PortArthur_TransferPrice]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_PortArthur_TransferPrice TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_PortArthur_TransferPrice >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_PortArthur_TransferPrice >>>'
GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_Purge_TMSContracts WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_Purge_TMSContracts]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_Purge_TMSContracts.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSContracts]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_Purge_TMSContracts TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_Purge_TMSContracts >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_Purge_TMSContracts >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_Purge_TMSNominations WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_Purge_TMSNominations]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_Purge_TMSNominations.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSNominations]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_Purge_TMSNominations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_Purge_TMSNominations >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_Purge_TMSNominations >>>'

PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
GO
PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_reset_last_accountcoded_accountdetail WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_reset_last_accountcoded_accountdetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_reset_last_accountcoded_accountdetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_reset_last_accountcoded_accountdetail]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_reset_last_accountcoded_accountdetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>'


/****** Object:  ViewName [dbo].[MTVSalesforceDLInvoicesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVSalesforceDLInvoicesStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSalesforceDLInvoicesStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSalesforceDLInvoicesStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
GO


/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_MTV_Schedule_Single_Process WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[SP_MTV_Schedule_Single_Process]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTV_Schedule_Single_Process.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_MTV_Schedule_Single_Process]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SP_MTV_Schedule_Single_Process TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SP_MTV_Schedule_Single_Process >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SP_MTV_Schedule_Single_Process >>>'

GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SCTExchangeReportExternalColumnSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SCTExchangeReportExternalColumnSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SCTExchangeReportExternalColumnSaved]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SCTExchangeReportExternalColumnSaved TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchAccountingTxnDataExtract WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchAccountingTxnDataExtract]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchAccountingTxnDataExtract.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchAccountingTxnDataExtract]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchAccountingTxnDataExtract TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchAccountingTxnDataExtract >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchAccountingTxnDataExtract >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchInterfaceMessage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchInterfaceMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchInterfaceMessage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchInterfaceMessage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchInterfaceMessage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchInterfaceMessage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchInterfaceMessage >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchMovementTxn WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchMovementTxn]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchMovementTxn.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchMovementTxn]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchMovementTxn TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchMovementTxn >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchMovementTxn >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTV_searchSATWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSATWithReportState.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSATWithReportState]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTV_searchSATWithReportState TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTV_searchSATWithReportState >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTV_searchSATWithReportState >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTV_searchSMTWithReportState 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTV_searchSMTWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSMTWithReportState.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSMTWithReportState]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_searchSMTWithReportState.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_searchSMTWithReportState >>>'
			Grant execute on dbo.sp_MTV_searchSMTWithReportState to  Sysuser
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_searchSMTWithReportState >>>'
	  END/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchVendorMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchVendorMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchVendorMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchVendorMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchVendorMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchVendorMasterDataStaging >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_FSM_TransferPrice_Comparison WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_FSM_TransferPrice_Comparison]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Search_FSM_TransferPrice_Comparison.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_Comparison]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_FSM_TransferPrice_Comparison TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_Comparison >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_Comparison >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_FSM_TransferPrice_UnassignedProdLocs WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Search_FSM_TransferPrice_UnassignedProdLocs.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_FSM_TransferPrice_UnassignedProdLocs TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_UnassignedProdLocs >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_UnassignedProdLocs >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_SupplyToFSM_Primary 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Primary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Primary.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_SupplyToFSM_Primary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_SupplyToFSM_Secondary 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Secondary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Secondary.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Secondary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_SupplyToFSM_Secondary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Secondary >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Secondary >>>'
GO/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_StageDataLakeMaster WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_StageDataLakeMaster]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_StageDataLakeMaster.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StageDataLakeMaster]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_StageDataLakeMaster TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_StageDataLakeMaster >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_StageDataLakeMaster >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_StarMailStage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_StarMailStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_StarMailStage.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StarMailStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_StarMailStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_StarMailStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_StarMailStage >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_T4GetPlannedTransfers]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_T4GetPlannedTransfers.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4GetPlannedTransfers]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_T4GetPlannedTransfers TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_T4GetPlannedTransfers >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_T4GetPlannedTransfers >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_T4ProcessOrderSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_T4ProcessOrderSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4ProcessOrderSaved]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_T4ProcessOrderSaved TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_T4ProcessOrderSaved >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_T4ProcessOrderSaved >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_CarrierEqualsTaxingAuthority WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxRule_CarrierEqualsTaxingAuthority.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_TaxRule_CarrierEqualsTaxingAuthority TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_TaxRule_CarrierEqualsTaxingAuthority >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_TaxRule_CarrierEqualsTaxingAuthority >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_MOTValidForFreightRate WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxRule_MOTValidForFreightRate]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxRule_MOTValidForFreightRate.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxRule_MOTValidForFreightRate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_TaxRule_MOTValidForFreightRate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_TaxRule_MOTValidForFreightRate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_TaxRule_MOTValidForFreightRate >>>'

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationDestination_NotTCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationDestination_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationDestination_NotTCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_NotTCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationDestination_NotTCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationDestination_NotTCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationDestination_NotTCN >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationDestination_TCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationDestination_TCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationDestination_TCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_TCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationDestination_TCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationDestination_TCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationDestination_TCN >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_NotTCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationOrigin_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_NotTCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationOrigin_NotTCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_TCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationOrigin_TCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_TCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_TCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationOrigin_TCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_TCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationOrigin_TCN >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVApplyStagingTableUpdatesToDealDetailShipToTable WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_tax_transactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_tax_transactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_tax_transactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_tax_transactions >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON tax_transactions_stage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_tax_transactions_stage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_tax_transactions_stage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions_stage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_tax_transactions_stage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_tax_transactions_stage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_tax_transactions_stage >>>'
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_TotalBargeUnloadVolumeInBatch]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_TotalBargeUnloadVolumeInBatch] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_TotalBargeUnloadVolumeInBatch] to sysuser, RightAngleAccess
End
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber]') AND type in (N'P', N'PC'))
Begin
	Print 'Granting execute on [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber] to sysuser, RightAngleAccess'
	grant execute on [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber] to sysuser, RightAngleAccess
End
go
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON ExcelPriceLoadXRef WITH YOUR stored procedure (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdateNymexPriceType]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdateNymexPriceType.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateNymexPriceType]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdateNymexPriceType TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdateNymexPriceType >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdateNymexPriceType >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdatePhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdatePhysicalDealArchiveEntries.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdatePhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdatePhysicalDealArchiveEntries TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdatePlannedTransferArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdatePlannedTransferArchiveEntries.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdatePlannedTransferArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdatePlannedTransferArchiveEntries TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdatePlannedTransferArchiveEntries >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdatePlannedTransferArchiveEntries >>>'
GO

/****** Object:  ViewName [dbo].[MTVArchiveDeal]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDeal.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDeal]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDeal TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDeal >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDeal >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON Sequence WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef_CustomerNo]    Script Date: DATECREATED ******/
PRINT 'Start Script=s_MTVTMSContractXRef_CustomerNo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_CustomerNo]') IS NOT NULL
  BEGIN
    GRANT  UPDATE ON [dbo].[MTVTMSContractXRef_CustomerNo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSContractXRef_CustomerNo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSContractXRef_CustomerNo >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON Sequence WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef_SupplierNo]    Script Date: DATECREATED ******/
PRINT 'Start Script=s_MTVTMSContractXRef_SupplierNo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_SupplierNo]') IS NOT NULL
  BEGIN
    GRANT  UPDATE ON [dbo].[MTVTMSContractXRef_SupplierNo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSContractXRef_SupplierNo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSContractXRef_SupplierNo >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: Motiva is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MotivaBuildStatistics]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MotivaBuildStatistics.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MotivaBuildStatistics]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MotivaBuildStatistics] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MotivaBuildStatistics >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MotivaBuildStatistics >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_PlannedTransferHistory.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MOT_PlannedTransferHistory.sql.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_PlannedTransferHistory]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MOT_PlannedTransferHistory] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MOT_PlannedTransferHistory >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MOT_PlannedTransferHistory >>>'
/****** Object:  ViewName [dbo].[MTVArchiveRevisionLevels]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVArchiveRevisionLevels.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveRevisionLevels]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVArchiveRevisionLevels TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVArchiveRevisionLevels >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVArchiveRevisionLevels >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVContactMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVContactMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVContactMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVContactMasterDataStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVContactMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVContactMasterDataStaging >>>'
/****** Object: [dbo].[MTVContractChangeStage]    Script Date: 09282015 ******/
PRINT 'Start Script=T_MTVContractChangeStage.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVContractChangeStage]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVContractChangeStage] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVContractChangeStage >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVContractChangeStage >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVCreditCurveStaging 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditCurveStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditCurveStaging.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditCurveStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditCurveStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditCurveStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditCurveStaging >>>'
GO
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON [MTVCreditExposureInterfaceStats] 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditExposureInterfaceStats]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditExposureInterfaceStats.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditExposureInterfaceStats]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditExposureInterfaceStats] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table [MTVCreditExposureInterfaceStats] >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table [MTVCreditExposureInterfaceStats] >>>'
GO
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVCreditInterfaceStaging 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditInterfaceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditInterfaceStaging.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditInterfaceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditInterfaceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditInterfaceStaging >>>'
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStagingArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditInterfaceStagingArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditInterfaceStagingArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditInterfaceStagingArchive >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[CustomerMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVCustomerMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCustomerMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCustomerMasterDataStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCustomerMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCustomerMasterDataStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterSendBA]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMasterSendBA.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterSendBA]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeMasterSendBA] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeMasterSendBA >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeMasterSendBA >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMasterTaxStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterTaxStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeMasterTaxStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeMasterTaxStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeMasterTaxStaging >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMTDTaxTransactionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMTDTaxTransactionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMTDTaxTransactionStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeMTDTaxTransactionStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeMTDTaxTransactionStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeMTDTaxTransactionStaging >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMTDTaxTransactionStagingArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMTDTaxTransactionStagingArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMTDTaxTransactionStagingArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeMTDTaxTransactionStagingArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeMTDTaxTransactionStagingArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeMTDTaxTransactionStagingArchive >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTaxTransactionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTaxTransactionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTaxTransactionStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeTaxTransactionStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeTaxTransactionStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeTaxTransactionStaging >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTaxTransactionStagingArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTaxTransactionStagingArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTaxTransactionStagingArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeTaxTransactionStagingArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeTaxTransactionStagingArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeTaxTransactionStagingArchive >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTransaction.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransaction]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeTransaction] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeTransaction >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeTransaction >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTransferPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTransferPriceStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransferPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeTransferPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeTransferPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeTransferPriceStaging >>>'





/****** Object:  ViewName [dbo].[MTVDealDetailArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealDetailArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailArchive >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDealDetailShipTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailShipTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailShipTo >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipToStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipToStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipToStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipToStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDealDetailShipToStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailShipToStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailShipToStaging >>>'

/****** Object:  ViewName [dbo].[MTVDealHeaderArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealHeaderArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealHeaderArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealHeaderArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealHeaderArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealHeaderArchive >>>'


/****** Object:  ViewName [dbo].[MTVDealPriceRowArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealPriceRowArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealPriceRowArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealPriceRowArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealPriceRowArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealPriceRowArchive >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDeferredTaxInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDeferredTaxInvoices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDeferredTaxInvoices]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDeferredTaxInvoices] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDeferredTaxInvoices >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDeferredTaxInvoices >>>'
	/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[T_MTVDemandForecastArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVDemandForecastArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDemandForecastArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDemandForecastArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDemandForecastArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDemandForecastArchive >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[T_MTVDemandForecastStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVDemandForecastStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDemandForecastStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDemandForecastStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDemandForecastStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDemandForecastStaging >>>'

PRINT 'Start Script=t_MTVDLInvBalancesStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvBalancesStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDLInvBalancesStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDLInvBalancesStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDLInvBalancesStaging >>>'
PRINT 'Start Script=t_MTVDLInvInventoryTransactionsStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvInventoryTransactionsStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDLInvInventoryTransactionsStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDLInvInventoryTransactionsStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDLInvInventoryTransactionsStaging >>>'
PRINT 'Start Script=t_MTVDLInvPricesStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvPricesStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDLInvPricesStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDLInvPricesStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDLInvPricesStaging >>>'
PRINT 'Start Script=t_MTVDLInvTransactionsStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvTransactionsStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDLInvTransactionsStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDLInvTransactionsStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDLInvTransactionsStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVElemicaStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVElemicaStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVElemicaStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVElemicaStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVElemicaStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVElemicaStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSContractPriceDates]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSContractPriceDates.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSContractPriceDates]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSContractPriceDates] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSContractPriceDates >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSContractPriceDates >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSDiscountSurcharge]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSDiscountSurcharge.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSDiscountSurcharge]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSDiscountSurcharge] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSDiscountSurcharge >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSDiscountSurcharge >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVFPSFuelSalesVolStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSFuelSalesVolStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSFuelSalesVolStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSFuelSalesVolStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSFuelSalesVolStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSFuelSalesVolStaging >>>'


/****** Object: [dbo].[MTVFPSRackPriceStaging]    Script Date: 09282015 ******/
PRINT 'Start Script=T_MTVFPSRackPriceStaging.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSRackPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSRackPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSRackPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSRackPriceStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSReconPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVFPSReconPriceStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSReconPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSReconPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSReconPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSReconPriceStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVIESExchangeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVIESExchangeStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVIESExchangeStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVIESExchangeStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVIESExchangeStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVIESExchangeStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVInboundCreditBlockStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVInboundCreditBlockStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVInboundCreditBlockStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVInboundCreditBlockStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVInboundCreditBlockStaging >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVInvoiceInterfaceStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVInvoiceInterfaceStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVInvoiceInterfaceStatus]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVInvoiceInterfaceStatus] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVInvoiceInterfaceStatus >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVInvoiceInterfaceStatus >>>'


PRINT 'Start Script=t_MTVManualInvoiceCustomerNumber.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVManualInvoiceCustomerNumber]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVManualInvoiceCustomerNumber] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVManualInvoiceCustomerNumber >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVManualInvoiceCustomerNumber >>>'
GO

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVManulMovementUpload]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVManulMovementUpload.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVManulMovementUpload]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVManulMovementUpload] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVManulMovementUpload >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVManulMovementUpload >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOasActualStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOasActualStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOasActualStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOasActualStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOasActualStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOasActualStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOASInventoryStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOASInventoryStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOASInventoryStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOASInventoryStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOASInventoryStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOASInventoryStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOASNominationStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOASNominationStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOASNominationStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOASNominationStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOASNominationStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOASNominationStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOASProductionConsumptionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOASProductionConsumptionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOASProductionConsumptionStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOASProductionConsumptionStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOASProductionConsumptionStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOASProductionConsumptionStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[T_MTVOASTruckTicketStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVOASTruckTicketStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOASTruckTicketStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOASTruckTicketStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOASTruckTicketStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOASTruckTicketStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOrionNominationStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOrionNominationStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOrionNominationStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOrionNominationStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOrionNominationStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOSPManulBOLStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOSPManulBOLStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOSPManulBOLStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOSPManulBOLStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOSPManulBOLStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOSPManulBOLStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOutboundCreditBlockStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOutboundCreditBlockStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVOutboundCreditBlockStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVOutboundCreditBlockStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVOutboundCreditBlockStaging >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPetroExStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPetroExStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPetroExStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPetroExStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPetroExStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPetroExStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPhysicalDealArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPhysicalDealArchiveEntries] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPhysicalDealArchiveEntries >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPhysicalDealArchiveEntries >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPlannedTransferArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPlannedTransferArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPlannedTransferArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPlannedTransferArchiveEntries] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPlannedTransferArchiveEntries >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPlannedTransferArchiveEntries >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPriceLoad]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPriceLoad.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPriceLoad]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPriceLoad] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPriceLoad >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPriceLoad >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVProductSeasonality]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVProductSeasonality.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonality]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVProductSeasonality] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVProductSeasonality >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVProductSeasonality >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVProductSeasonalityMonthDay]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVProductSeasonalityMonthDay.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonalityMonthDay]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVProductSeasonalityMonthDay] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVProductSeasonalityMonthDay >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVProductSeasonalityMonthDay >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVRaToFpsRetailContractInterface 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVRetailContractRAToFPSStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVRaToFpsRetailContractInterface.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractRAToFPSStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailContractRAToFPSStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailContractRAToFPSStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailContractRAToFPSStaging >>>'
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractInterfaceResults]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailContractInterfaceResults] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailContractInterfaceResults >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailContractInterfaceResults >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVRetailerInvoicePreStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailerInvoicePreStage]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailerInvoicePreStage] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailerInvoicePreStage >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailerInvoicePreStage >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSalesforceDataLakeInvoicesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSalesforceDataLakeInvoicesStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDataLakeInvoicesStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSalesforceDataLakeInvoicesStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSalesforceDataLakeInvoicesStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSalesforceDataLakeInvoicesStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPAPStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPAPStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPAPStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPAPStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPAPStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPAPStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPAPStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPARStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPARStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPARStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPARStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPARStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPARStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPARStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPBASoldTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPBASoldTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPBASoldTo >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldToClassOfTrade WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldToClassOfTrade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldToClassOfTrade.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldToClassOfTrade]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPBASoldToClassOfTrade] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPBASoldToClassOfTrade >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPBASoldToClassOfTrade >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPGLStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPGLStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPGLStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPGLStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPGLStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPGLStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPGLStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPSoldToShipTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPSoldToShipTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPSoldToShipTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPSoldToShipTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPSoldToShipTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPSoldToShipTo >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPSoldToShipToClassification WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPSoldToShipToClassification]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPSoldToShipToClassification.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPSoldToShipToClassification]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPSoldToShipToClassification] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPSoldToShipToClassification >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPSoldToShipToClassification >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSCTExchangeReportExternalColumn]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSCTExchangeReportExternalColumn.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSCTExchangeReportExternalColumn]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVSCTExchangeReportExternalColumn] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSCTExchangeReportExternalColumn >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSCTExchangeReportExternalColumn >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVContactMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSoldToMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSoldToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVSoldToMasterDataStaging to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSoldToMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSoldToMasterDataStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSoldToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSoldToShipToMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSoldToShipToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVSoldToShipToMasterDataStaging to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSoldToShipToMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSoldToShipToMasterDataStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVStarMailStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVStarMailStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVStarMailStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVStarMailStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVStarMailStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVStarMailStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4LineItemsStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4LineItemsStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVT4LineItemsStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVT4LineItemsStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVT4LineItemsStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVT4LineItemsStaging >>>'


	/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4NominationHeaderStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4NominationHeaderStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVT4NominationHeaderStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVT4NominationHeaderStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVT4NominationHeaderStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVT4NominationHeaderStaging >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4StagingRAWorkBench]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4StagingRAWorkBench.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVT4StagingRAWorkBench]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVT4StagingRAWorkBench] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVT4StagingRAWorkBench >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVT4StagingRAWorkBench >>>'





PRINT 'Start Script=t_MTVTaxNewCombinationDetail.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationDetail]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVTaxNewCombinationDetail to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table dbo.MTVTaxNewCombinationDetail >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table dbo.MTVTaxNewCombinationDetail >>>'



PRINT 'Start Script=t_MTVTaxNewCombinationSummary.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationSummary]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVTaxNewCombinationSummary to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table dbo.MTVTaxNewCombinationSummary >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table dbo.MTVTaxNewCombinationSummary >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [db_datareader].[MTV_GetTempMarkToMarket]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTempMarkToMarket.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[db_datareader].[MTVTempMarkToMarket]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [db_datareader].[MTVTempMarkToMarket] to sysuser, RightAngleAccess
	GRANT SELECT ON [db_datareader].[MTVTempMarkToMarket] to RiskDataUser
	
    PRINT '<<< GRANTED RIGHTS on Table MTVTempMarkToMarket >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTempMarkToMarket >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [db_datareader].[MTVTempRiskExposure]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTempRiskExposure.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[db_datareader].[MTVTempRiskExposure]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [db_datareader].[MTVTempRiskExposure] to sysuser, RightAngleAccess
	GRANT SELECT ON [db_datareader].[MTVTempRiskExposure] to RiskDataUser
    PRINT '<<< GRANTED RIGHTS on Table MTVTempRiskExposure >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTempRiskExposure >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSClassOfTradeXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSClassOfTradeXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSClassOfTradeXRef]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSClassOfTradeXRef] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSClassOfTradeXRef >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSClassOfTradeXRef >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSContractXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSContractXRef] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSContractXRef >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSContractXRef >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSGaugeFreezeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSGaugeFreezeStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSGaugeFreezeStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSGaugeFreezeStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSGaugeFreezeStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSGaugeFreezeStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSGaugeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSGaugeStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSGaugeStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSGaugeStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSGaugeStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSGaugeStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSMovementStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSMovementStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSHeaderRawData]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSHeaderRawData] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSHeaderRawData >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSHeaderRawData >>>'

IF  OBJECT_ID(N'[dbo].[MTVTMSProductRawData]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSProductRawData] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSProductRawData >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSProductRawData >>>'


IF  OBJECT_ID(N'[dbo].[MTVTMSMovementStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSMovementStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSMovementStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSMovementStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSSAPMaterialCodeXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSSAPMaterialCodeXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSSAPMaterialCodeXRef]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSSAPMaterialCodeXRef] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSSAPMaterialCodeXRef >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSSAPMaterialCodeXRef >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTransferPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTransferPriceStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTransferPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTransferPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTransferPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTransferPriceStaging >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_AccountDetailsIncludedToPEGA_DLYProcessing]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_AccountDetailsIncludedToPEGA_DLYProcessing.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_DLYProcessing]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTV_AccountDetailsIncludedToPEGA_DLYProcessing] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_DLYProcessing >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_DLYProcessing >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_AccountDetailsIncludedToPEGA_MTDProcessing.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_MTDProcessing >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_MTDProcessing >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_AccountDetailTaxRateArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_AccountDetailTaxRateArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_AccountDetailTaxRateArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].mtv_AccountDetailTaxRateArchive to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table mtv_AccountDetailTaxRateArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table mtv_AccountDetailTaxRateArchive >>>'


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[CompanyNameTABLENAME]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_GeneralComment.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GeneralComment]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_GeneralComment] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_GeneralComment >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_GeneralComment >>>'
GO

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: Motiva is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_InvoiceDetail_AccountDetail_DeleteLog.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'

/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_RiskOverride]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_RiskOverride.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_RiskOverride] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_RiskOverride >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_RiskOverride >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_RiskOverride_Trade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_RiskOverride_Trade.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride_Trade]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_RiskOverride_Trade] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_RiskOverride_Trade >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_RiskOverride_Trade >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[VendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_VendorMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_VendorMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTV_VendorMasterDataStaging to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_VendorMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_VendorMasterDataStaging >>>'
/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusMessage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[NexusMessage]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[NexusMessage] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table NexusMessage >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table NexusMessage >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusRouterType]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusRouterType.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[NexusRouterType]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[NexusRouterType] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table NexusRouterType >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table NexusRouterType >>>'




/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[NexusStatus]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[NexusStatus] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table NexusStatus >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table NexusStatus >>>'




/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_BAProdDestLocDealDetails WITH YOUR view 
*****************************************************************************************************
*/

/****** Object:  v_BAProdDestLocDealDetails [dbo].[v_BAProdDestLocDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_BAProdDestLocDealDetails.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdDestLocDealDetails]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_BAProdDestLocDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_BAProdDestLocDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_BAProdDestLocDealDetails >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_BAProdOriginLocDealDetails WITH YOUR view 
*****************************************************************************************************
*/

/****** Object:  v_BAProdOriginLocDealDetails [dbo].[v_BAProdOriginLocDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_BAProdOriginLocDealDetails.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdOriginLocDealDetails]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_BAProdOriginLocDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_BAProdOriginLocDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_BAProdOriginLocDealDetails >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON CurrentNexusStatus WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  CurrentNexusStatus [dbo].[v_CurrentNexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_CurrentNexusStatus.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_CurrentNexusStatus]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_CurrentNexusStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_CurrentNexusStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_CurrentNexusStatus >>>'
GO

/****** Object:   [dbo].[v_MTV_AccountDetailShipToSoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailShipToSoldTo.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailShipToSoldTo]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AccountDetailShipToSoldTo TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AccountDetailShipToSoldTo >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AccountDetailShipToSoldTo >>>'/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVCirDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVCirDetail [dbo].[v_MTVCirDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVCirDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCirDetail]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVCirDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View MTVCirDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View MTVCirDetail >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVCreditBlockStaging.GRANT WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVDataLakeTaxTransaction [dbo].[v_MTVDataLakeTaxTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVCreditBlockStaging.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVCreditBlockStaging]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVCreditBlockStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVCreditBlockStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVCreditBlockStaging >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVDataLakeTaxTransaction WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVDataLakeTaxTransaction [dbo].[v_MTVDataLakeTaxTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVDataLakeTaxTransaction.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVDataLakeTaxTransaction]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVDataLakeTaxTransaction TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVDataLakeTaxTransaction >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVDataLakeTaxTransaction >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON ViewName WITH YOUR view (NOTE:  v_CompanyName_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[V_MTVDealDetailPrvsnAttributeValues]    Script Date: DATECREATED ******/
PRINT 'Start Script=V_MTVDealDetailPrvsnAttributeValues.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[V_MTVDealDetailPrvsnAttributeValues]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.V_MTVDealDetailPrvsnAttributeValues TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View V_MTVDealDetailPrvsnAttributeValues >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View V_MTVDealDetailPrvsnAttributeValues >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVInterfaceTranslationCache WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVInterfaceTranslationCache [dbo].[v_MTVInterfaceTranslationCache]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVInterfaceTranslationCache.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVInterfaceTranslationCache]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVInterfaceTranslationCache TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVInterfaceTranslationCache >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVInterfaceTranslationCache >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVT4Nominations WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVT4Nominations [dbo].[v_MTVT4Nominations]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVT4Nominations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVT4Nominations]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVT4Nominations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVT4Nominations >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVT4Nominations >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVUserBySecurityRole WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVUserBySecurityRole [dbo].[v_MTVUserBySecurityRole]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVUserBySecurityRole.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUserBySecurityRole]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVUserBySecurityRole TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View MTVUserBySecurityRole >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View MTVUserBySecurityRole >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON DealSoldToVendorNumber WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  DealSoldToVendorNumber [dbo].[v_MTV_AccountDetailSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailSoldToVendorNumber]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AccountDetailSoldToVendorNumber TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AccountDetailSoldToVendorNumber >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AccountDetailSoldToVendorNumber >>>'

/****** Object:   [dbo].[v_mtv_AccountDetailStatement]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_mtv_AccountDetailStatement.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_mtv_AccountDetailStatement]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_mtv_AccountDetailStatement TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_mtv_AccountDetailStatement >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_mtv_AccountDetailStatement >>>'

/****** Object:  ViewName [dbo].[v_MTV_AcctDtl_AcctCodes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AcctDtl_AcctCodes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AcctDtl_AcctCodes]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AcctDtl_AcctCodes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AcctDtl_AcctCodes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AcctDtl_AcctCodes >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_DealDetailSoldToShipTo WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_DealDetailSoldToShipTo [dbo].[v_MTV_DealDetailSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_DealDetailSoldToShipTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealDetailSoldToShipTo]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_DealDetailSoldToShipTo TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_DealDetailSoldToShipTo >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_DealDetailSoldToShipTo >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON DealSoldToVendorNumber WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  DealSoldToVendorNumber [dbo].[v_MTV_DealSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_DealSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealSoldToVendorNumber]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_DealSoldToVendorNumber TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_DealSoldToVendorNumber >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_DealSoldToVendorNumber >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_LatestTaxRates WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_LatestTaxRates [dbo].[v_MTV_LatestTaxRates]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_LatestTaxRates.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_LatestTaxRates]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_LatestTaxRates TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_LatestTaxRates >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_LatestTaxRates >>>'
GO
PRINT 'Start Script=v_MTV_SAPARStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPARStatus]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_SAPARStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_SAPARStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_SAPARStatus >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_SAPSoldToShipTo WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_SAPSoldToShipTo [dbo].[v_MTV_v_MTV_SAPSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_v_MTV_SAPSoldToShipTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPSoldToShipTo]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_SAPSoldToShipTo TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_SAPSoldToShipTo >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_SAPSoldToShipTo >>>'

/****** Object:   [dbo].[v_MTV_StorageFeeInvoiceDisplay]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_StorageFeeInvoiceDisplay.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_StorageFeeInvoiceDisplay]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_StorageFeeInvoiceDisplay TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_StorageFeeInvoiceDisplay >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_StorageFeeInvoiceDisplay >>>'
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  MTV_TaxDetail [dbo].[v_MTV_TaxDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxDetail]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxDetail >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_TaxLocaleCountyCityState WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_TaxLocaleCountyCityState [dbo].[v_MTV_TaxLocaleCountyCityState]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxLocaleCountyCityState.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleCountyCityState]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxLocaleCountyCityState TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxLocaleCountyCityState >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxLocaleCountyCityState >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_TaxLocaleStateCounty WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_TaxLocaleStateCounty [dbo].[v_MTV_TaxLocaleStateCounty]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxLocaleStateCounty.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleStateCounty]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxLocaleStateCounty TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxLocaleStateCounty >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxLocaleStateCounty >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_TaxRates WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_TaxRates [dbo].[v_MTV_TaxRates]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxRates.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxRates]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxRates TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxRates >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxRates >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_XrefAttributes WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_XrefAttributes [dbo].[v_MTV_XrefAttributes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_XrefAttributes.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_XrefAttributes]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_XrefAttributes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_XrefAttributes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_XrefAttributes >>>'
GO
/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_RequestMessage WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_RequestMessage [dbo].[v_RequestMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_RequestMessage.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_RequestMessage]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_RequestMessage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_RequestMessage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_RequestMessage >>>'
GO
