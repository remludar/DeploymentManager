/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_CarrierEqualsTaxingAuthority WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxRule_CarrierEqualsTaxingAuthority.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_TaxRule_CarrierEqualsTaxingAuthority >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]
	(
	@ac_profile char (1)= 'N'
	)
AS

-- =============================================
-- Author:        rlb
-- Create date:	  09/25/2016
-- Description:   used by the tax rule if the carrier on the movement equals the taxing authority BA on the Tax record.
--					Originally written by Matt Perry
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Set NoCount ON

Declare	@vc_sql varchar (8000),
		@i_RuleID int

Select	@i_RuleID = TxRleID
from	TaxRule
Where	[Description] = 'Carrier Equals Taxing Authority'

If @ac_profile = 'N'
Begin
	Delete	#Temp_TaxData
	From	#Temp_TaxData
			Inner Join TaxRuleSetRule (NoLock)	On	TaxRuleSetRule.TxRleStID = #Temp_TaxData.TxRleStID
												And	TaxRuleSetRule.TxRleID = @i_RuleID
			Inner Join Tax (NoLock)				On Tax.TxID = TaxRuleSetRule.TxID
	Where	Not Exists
			(
			Select	1
			From	TransactionHeader (NoLock)
					Inner Join MovementHeader (NoLock)	On	MovementHeader.MvtHDrID = TransactionHeader.XHdrMvtDtlMvtHdrID
														And	MovementHeader.MvtHdrCrrrBAID = Tax.TaxAuthorityBAID
			Where	TransactionHeader.XHdrID = #Temp_TaxData.SourceID	
			)
end 
Else
Begin
	select @vc_sql = 
	'
	Update  #Temp_TaxData
	Set 	DWExpression = """0"""
	From	#Temp_TaxData
			Inner Join TaxRuleSetRule (NoLock)	On	TaxRuleSetRule.TxRleStID = #Temp_TaxData.TxRleStID
												And	TaxRuleSetRule.TxRleID = ' + Convert(Varchar,@i_RuleID) +
'
			Inner Join Tax (NoLock)				On Tax.TxID = TaxRuleSetRule.TxID
	Where	Not Exists
			(
			Select	1
			From	TransactionHeader (NoLock)
					Inner Join MovementHeader (NoLock)	On	MovementHeader.MvtHDrID = TransactionHeader.XHdrMvtDtlMvtHdrID
														And	MovementHeader.MvtHdrCrrrBAID = Tax.TaxAuthorityBAID
			Where	TransactionHeader.XHdrID = #Temp_TaxData.SourceID	
			)
	'
	
	exec(@vc_sql)
End


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_TaxRule_CarrierEqualsTaxingAuthority.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_TaxRule_CarrierEqualsTaxingAuthority >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_TaxRule_CarrierEqualsTaxingAuthority >>>'
	  END