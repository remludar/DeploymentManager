/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_PlannedTransferMethodOfTrans WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Get_PlannedTransferMethodOfTrans]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_PlannedTransferMethodOfTrans.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_PlannedTransferMethodOfTrans]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Get_PlannedTransferMethodOfTrans] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Get_PlannedTransferMethodOfTrans]	@i_XHdrID int = NULL

AS

-----------------------------------------------------------------------------------------------------------------------------
-- Name			:MTV_Get_Transportation_Method          
-- Overview		:This Procedure will retrieve the Transportation Method specified on the PlannedTransfer.  Stolen from Bartts SP, 
--				using for PB and Tariff Freight Rates
-- Created by	:rlb
-- History		:02/23/2013 - First Created
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	execute  MTV_Get_PlannedTransferMethodOfTrans 1
declare @c_MthdTrns char(1)
		,@i_PlnndTrnsfrID int

----------------------------------------------------------------------------------------------------------------------
-- Get PlannedTransferID
----------------------------------------------------------------------------------------------------------------------
Select	@i_PlnndTrnsfrID = TransactionHeader.XHdrPlnndTrnsfrID
		--select *
From	dbo.TransactionHeader (NoLock)
Where	TransactionHeader.XHdrID = @i_XHdrID

select @c_MthdTrns =      IsNull((Select PlannedTransfer.MethodTransportation
from  PlannedTransfer
Where PlannedTransfer.PlnndTrnsfrID = @i_PlnndTrnsfrID), '')

Select @c_MthdTrns



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_PlannedTransferMethodOfTrans]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Get_PlannedTransferMethodOfTrans.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>'
	  END