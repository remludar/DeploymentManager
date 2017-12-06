/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_reset_last_accountcoded_accountdetail WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_reset_last_accountcoded_accountdetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_reset_last_accountcoded_accountdetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_reset_last_accountcoded_accountdetail]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_reset_last_accountcoded_accountdetail] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_reset_last_accountcoded_accountdetail]
AS

------------------------------------------------------------------------------------------------------------------
-- Name:        MTV_reset_last_accountcoded_accountdetail
--
-- Overview:    This procedure rest the last account detail ID that has not been accountcoded. The account code 
--              process will then pick up the account detail and account code them.
-- Parameters:  None
-- Issues:
-- Created by:  Sean Brown
-- History:
--****************************************************************************************************************
-- Modified     Modified By     Issue#      Modification
-- -----------  --------------  ----------  --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- EXEC dbo.MTV_reset_last_accountcoded_accountdetail

--Script to reset the last account detail that was account coded.
--There are several account details that didn't account code, so we need
--to reset the ID of the last account detail to account code
--to be the ID of the account detail that is before the first
--account detail that did not account code.

Declare @AcctDtlID                  int

Select  @AcctDtlID = MIN( AD.AcctDtlID )
From    AccountDetail AD
Where   Not Exists (Select  1
                    From    AccountDetailAccountCode ADAC
                    Where   ADAC.AcctDtlAcctCdeAcctDtlID = AD.AcctDtlID )

Set @AcctDtlID = ISNULL(@AcctDtlID,0)

If @AcctDtlID > 0
  Begin
    Update  AccountCodeLastAccountDetail
    Set     AcctDtlID = @AcctDtlID
    Where   AcctDtlID > @AcctDtlID

    Update  ADACS
    Set     Processed = 0
    From    AccountDetailAccountCodeStaging ADACS
    Where   Not Exists (Select  1
                        From    AccountDetailAccountCode ADAC
                        Where   ADAC.AcctDtlAcctCdeAcctDtlID = ADACS.AcctDtlID )
  End

GO


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_reset_last_accountcoded_accountdetail]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_reset_last_accountcoded_accountdetail.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>'
	  END