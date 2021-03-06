/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/


/****** Object:  StoredProcedure [dbo].[MTV_tax_transactions_stage.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_tax_transactions_stage.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions_stage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_tax_transactions_stage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_tax_transactions_stage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER  Procedure [dbo].[MTV_tax_transactions_stage] 
    @transactionsFromDate smalldatetime
  , @accountingPeriodId int
  ,	@userId int = NULL
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	MTV_tax_transactions_stage         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the movement and the accounting transactions with the tax details and insert to stage table.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Isaac Jacob
-- History:	4/22/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
--  6/7/2016        Sanjay Kumar        Consolidated the seperate functions, to a single stored procedure.
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------

INSERT INTO dbo.MTVDataLakeTaxTransactionStaging 
exec [dbo].[MTV_IncrementalTaxTransactions] @transactionsFromdate, @userId, @accountingPeriodId
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions_stage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_tax_transactions_stage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_tax_transactions_stage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_tax_transactions_stage >>>'
	  END
