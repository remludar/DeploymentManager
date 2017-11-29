/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_all_exchdiff_statement_retrieve_details_with_regrades WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_all_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_custom_all_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER Procedure [dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades]
	@AccountingPeriodsBack Int
As

-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_custom_all_exchdiff_statement_retrieve_details_with_regrades         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the exchange statements in an open Accounting Period.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Sanjay Kumar
-- History:	11/10/2015 - First Created
--
-- 	Date Modified 	Modified By		Issue#		Modification
-- 	--------------- -------------- 	------		-------------------------------------------------------------------------
--  2016/08/09		DAO							Moved Looping logic into .net code.
--	20161028		rlb				3661		Change logic to pull from SalesInvoiceStatement to insure statements have been created.
--  20170623        ssk             7765        Changed the logic to retrieve Invoices from the last Closed Accounting Period.
--	20170630		MV				7765		Updated the logic to be able to handle accounting period offsets


SELECT distinct(SttmntBlnceSlsInvceHdrID) 
FROM StatementBalance (NoLock) 
where SttmntBlnceAccntngPrdID in
((select top 1 AccntngPrdID from AccountingPeriod (NoLock) order by CloseDate desc) - @AccountingPeriodsBack)

GO


