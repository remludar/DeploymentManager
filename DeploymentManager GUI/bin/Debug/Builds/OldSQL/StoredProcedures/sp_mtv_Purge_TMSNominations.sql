/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_Purge_TMSNominations WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[mtv_Purge_TMSNominations]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_Purge_TMSNominations.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSNominations]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[mtv_Purge_TMSNominations] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure mtv_Purge_TMSNominations >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[mtv_Purge_TMSNominations]
AS

-- =============================================
-- Author:        Author:        rlb
-- Create date:	  20170123
-- Description:   Purge script to be run in Purge Maintenance for TMS Nominations
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

create table #recordstopreserve(
PlnndMvtID int,
TmsFileIdnty int)

insert into #recordstopreserve
select distinct PlnndMvtID, max(TmsFileIdnty) TmsFileIdnty
from dbo.MTVTMSAccountToTmsStaging (nolock)
where InterfaceName = 'nomination'
and InterfaceStatus = 'C'
group by PlnndMvtID

insert into #recordstopreserve
select  MTVTMSAccountToTmsStaging.PlnndMvtID , max(MTVTMSAccountToTmsStaging.TmsFileIdnty) TmsFileIdnty
from dbo.MTVTMSAccountToTmsStaging (nolock)
left join #recordstopreserve
on MTVTMSAccountToTmsStaging.PlnndMvtID = #recordstopreserve.PlnndMvtID
where MTVTMSAccountToTmsStaging.InterfaceName = 'nomination'
and MTVTMSAccountToTmsStaging.InterfaceStatus in ('N', 'M', 'E')
and (#recordstopreserve.PlnndMvtID is null or
		(#recordstopreserve.PlnndMvtID is not null AND #recordstopreserve.TmsFileIdnty > MTVTMSAccountToTmsStaging.TmsFileIdnty)
	)
group by MTVTMSAccountToTmsStaging.PlnndMvtID

delete parent 
from MTVTMSNominationStaging parent
left join #recordstopreserve 
on parent.TmsFileIdnty = #recordstopreserve.TmsFileIdnty
where #recordstopreserve.TmsFileIdnty is null

delete parent
from MTVTMSAccountToTmsStaging parent
left join #recordstopreserve 
on parent.TmsFileIdnty = #recordstopreserve.TmsFileIdnty
where parent.InterfaceName = 'nomination'
and #recordstopreserve.TmsFileIdnty is null

drop table #recordstopreserve

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSNominations]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'mtv_Purge_TMSNominations.sql'
			PRINT '<<< ALTERED StoredProcedure mtv_Purge_TMSNominations >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure mtv_Purge_TMSNominations >>>'
	  END