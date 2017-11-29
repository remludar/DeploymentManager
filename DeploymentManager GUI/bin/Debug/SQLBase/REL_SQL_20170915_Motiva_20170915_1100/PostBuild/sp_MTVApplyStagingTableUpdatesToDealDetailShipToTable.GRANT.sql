/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVApplyStagingTableUpdatesToDealDetailShipToTable WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVApplyStagingTableUpdatesToDealDetailShipToTable.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVApplyStagingTableUpdatesToDealDetailShipToTable TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>'
GO
