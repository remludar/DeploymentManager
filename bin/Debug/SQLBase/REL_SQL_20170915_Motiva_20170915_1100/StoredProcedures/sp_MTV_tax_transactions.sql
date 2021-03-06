/****** Object:  StoredProcedure [dbo].[MTV_tax_transactions.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_tax_transactions.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_tax_transactions] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_tax_transactions >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER  Procedure [dbo].[MTV_tax_transactions] @transactionsFromDate smalldatetime
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	MTV_tax_transactions         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the movement and the accounting transactions with the tax details.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Sanjay Kumar
-- History:	4/14/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------

  select * from MTV_TaxMovementTransactionData(@transactionsFromDate)
  union all
  select * from MTV_TaxAccountingTransactionData(@transactionsFromDate)
  
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_tax_transactions.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_tax_transactions >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_tax_transactions >>>'
	  END

--End of Script: MTV_tax_transactions.sql