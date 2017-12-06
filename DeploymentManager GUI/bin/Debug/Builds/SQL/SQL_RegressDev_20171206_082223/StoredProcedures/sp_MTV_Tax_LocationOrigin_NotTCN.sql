/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationOrigin_NotTCN WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Tax_LocationOrigin_NotTCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationOrigin_NotTCN.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Tax_LocationOrigin_NotTCN] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE dbo.MTV_Tax_LocationOrigin_NotTCN    @ac_profile char (1)= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- SP:              MTV_Tax_LocationOrigin_NotTCN           Copyright 2012 SolArc
-- Arguments:       @ac_profile
-- Tables:          TaxRuleSetRule, GeneralConfiguration
-- Indexes:         None
-- Stored Procs:    None
-- Dynamic Tables:  #Temp_TaxData
-- Overview:        Used for tax rule: Location Origin IS NOT TCN, fails rule if Location Origin has TCN attribute
--
-- Created by:      rlb
-- History:         2017/09/27
-- Modified     Modified By     Modification
-- -----------  --------------  -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_sql         varchar (8000)
      , @i_RuleID       int

Select @i_RuleID = (Select TxRleID from TaxRule Where Description = 'Location Origin IS NOT TCN')

Select @vc_sql = '
    Update  #Temp_TaxData
    Set     TaxOriginLcleID = MH.MvtHdrOrgnLcleID
		  , TaxDestinationLcleID = MH.MvtHdrDstntnLcleID
	From	TransactionHeader TH
	Join	MovementHeader MH
			On  TH.XHdrMvtDtlMvtHdrID = MH.MvtHdrID   
	Where   TH.XHdrID = #Temp_TaxData. SourceID
'
Exec (@vc_sql)


-- right now only check ExternalBa, but I think that supplydemand should affect whether we check internal or external ba
If @ac_profile = 'N'
  Begin
    Select @vc_sql = '
        Delete  #Temp_TaxData
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        and     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        and     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End 
Else
  Begin
    Select @vc_sql = '
        Update  #Temp_TaxData
        Set     DWExpression = """0"""
        From    TaxRuleSetRule (NoLock)
        Where   TaxRuleSetRule. TxRleStID = #Temp_TaxData. TxRleStID
        And     TaxRuleSetRule. TxRleId = '+ Convert(varchar(10), @i_RuleID) +'
        And     EXISTS (Select  1
                        From    GeneralConfiguration (nolock)
                        Where   GeneralConfiguration.GnrlCnfgTblNme = "Locale"
                        And     GeneralConfiguration.GnrlCnfgQlfr = "TCN"
						and		LEN(GeneralConfiguration.GnrlCnfgMulti) <> 0
                        And     GeneralConfiguration.GnrlCnfgHdrID = #Temp_TaxData.TaxOriginLcleID )
    '
  End

Exec (@vc_sql)    

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationOrigin_NotTCN]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Tax_LocationOrigin_NotTCN.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Tax_LocationOrigin_NotTCN >>>'
	  END


