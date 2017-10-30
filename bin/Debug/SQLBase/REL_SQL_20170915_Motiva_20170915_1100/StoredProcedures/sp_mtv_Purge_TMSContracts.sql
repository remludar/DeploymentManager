/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_Purge_TMSContracts WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[mtv_Purge_TMSContracts]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_Purge_TMSContracts.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSContracts]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[mtv_Purge_TMSContracts] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure mtv_Purge_TMSContracts >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[mtv_Purge_TMSContracts]
AS

-- =============================================
-- Author:        rlb
-- Create date:	  20170123
-- Description:   Purge script to be run in Purge Maintenance for TMS Contracts
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

create table #recordstopreserve (
dlhdrid int,
TmsFileIdnty int)

insert into #recordstopreserve
select distinct dlhdrid , max(TmsFileIdnty) TmsFileIdnty
from dbo.MTVTMSAccountToTmsStaging (nolock)
where InterfaceName = 'contract'
and InterfaceStatus = 'C'
group by DlHdrID

insert into #recordstopreserve
select distinct MTVTMSAccountToTmsStaging.DlHdrID , max(MTVTMSAccountToTmsStaging.TmsFileIdnty) TmsFileIdnty
from dbo.MTVTMSAccountToTmsStaging (nolock)
left join #recordstopreserve
on MTVTMSAccountToTmsStaging.DlHdrID = #recordstopreserve.DlHdrID
where MTVTMSAccountToTmsStaging.InterfaceName = 'contract'
and MTVTMSAccountToTmsStaging.InterfaceStatus in ('N', 'M', 'E')
and (#recordstopreserve.DlHdrID is null or 
		(#recordstopreserve.DlHdrID is not null AND #recordstopreserve.TmsFileIdnty > MTVTMSAccountToTmsStaging.TmsFileIdnty)
	)
group by MTVTMSAccountToTmsStaging.DlHdrID

delete parent
from dbo.MTVTMSAcctProdStaging parent 
left join #recordstopreserve 
on parent.TmsFileIdnty = #recordstopreserve.TmsFileIdnty
where #recordstopreserve.TmsFileIdnty is null

delete parent
from dbo.MTVTMSAccountStaging parent 
left join #recordstopreserve
on parent.TMSFileIdnty = #recordstopreserve.TmsFileIdnty
where #recordstopreserve.TmsFileIdnty is null

delete parent 
from dbo.MTVTMSCustomerStaging parent
left join #recordstopreserve
on parent.TMSFileIdnty = #recordstopreserve.TmsFileIdnty
where #recordstopreserve.TmsFileIdnty is null

delete parent 
from dbo.MTVTMSAccountToTmsStaging parent
left join #recordstopreserve
on parent.TMSFileIdnty = #recordstopreserve.TmsFileIdnty
where parent.InterfaceName = 'contract'
and #recordstopreserve.TmsFileIdnty is null

drop table #recordstopreserve

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSContracts]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'mtv_Purge_TMSContracts.sql'
			PRINT '<<< ALTERED StoredProcedure mtv_Purge_TMSContracts >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure mtv_Purge_TMSContracts >>>'
	  END