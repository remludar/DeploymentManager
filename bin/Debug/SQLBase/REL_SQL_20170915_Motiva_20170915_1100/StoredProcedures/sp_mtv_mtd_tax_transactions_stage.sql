/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/


/****** Object:  StoredProcedure [dbo].[MTV_mtd_tax_transactions_stage.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_mtd_tax_transactions_stage.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_mtd_tax_transactions_stage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_mtd_tax_transactions_stage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_mtd_tax_transactions_stage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER  Procedure [dbo].[MTV_mtd_tax_transactions_stage] 
	@vc255_arg varchar(255)
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	MTV_mtd_tax_transactions_stage         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the movement and the accounting transactions with the tax details and insert to stage table.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Sanjay Kumar
-- History:	8/22/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------

DECLARE @AcctPrdId    INT
DECLARE @transactionFromDate smalldatetime
DECLARE @ai_PrcssGrpID INT 
DECLARE @avc_Prmtr	Varchar(MAX)
DECLARE @EmailAddress VARCHAR(MAX)
---------------------------------------------------------------------------------------------
---- SET Processing Variables
---------------------------------------------------------------------------------------------
SELECT @AcctPrdId = LTRIM(SUBSTRING(@vc255_arg,CHARINDEX('=', @vc255_arg, 0)+1
                                        ,CHARINDEX(',', @vc255_arg, 0) - CHARINDEX('=', @vc255_arg, 0)-1))

-- The accounting period that comes in the message is the current open period.
SET @AcctPrdId = @AcctPrdId - 1;

select @transactionFromDate = AccntngPrdBgnDte from AccountingPeriod where AccntngPrdID = @AcctPrdId

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Month To Date Tax Transaction Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Month To Date Tax Transaction Interface'

INSERT INTO dbo.MTVDataLakeMTDTaxTransactionStaging 
exec [dbo].[MTV_MTDIncrementalTaxTransactions] @transactionFromdate, NULL, @AcctPrdId

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Month To Date Tax Transaction Interface'	,GETDATE(),'Stop','SQL','Sysuser',db_name(),'Complete','Month To Date Tax Transaction Interface'

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Month To Date Tax Transaction Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Send Email'

Select @EmailAddress = COALESCE(@EmailAddress +'; ', '') + UserEMlAddrss
From dbo.Users Where UserEMlAddrss IS NOT NULL AND UserID IN
(select UserRoleUserID from UserRole where UserRoleRoleID = (select RoleID from Roles where RoleDesc = 'Tax'))

SELECT        @ai_PrcssGrpID = PrcssGrpID from  processgroup where   ProcessGroup.PrcssGrpNme = 'Batch E-Mail'
SELECT        @avc_Prmtr = 'Batch Email:sender=RightAngleUser@motivaent.com||sendername=RightAngle||emailrecipient=' + ISNULL(@EmailAddress, '') + '||subject=Month To Date Tax Transactons Staging Complete||priority=N'

EXECUTE  DBO.SP_MTV_Schedule_Single_Process @ai_PrcssGrpID, @avc_Prmtr, @avc_Hst = 'Document Generation'

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Month To Date Tax Transaction Interface'	,GETDATE(),'Stop','SQL','Sysuser',db_name(),'Complete','Send Email'

GO

IF  OBJECT_ID(N'[dbo].[MTV_mtd_tax_transactions_stage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_mtd_tax_transactions_stage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_mtd_tax_transactions_stage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_mtd_tax_transactions_stage >>>'
	  END
