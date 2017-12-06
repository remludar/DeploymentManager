/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_PortArthur_TransferPrice 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Secondary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_PortArthur_TransferPrice.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_PortArthur_TransferPrice]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_PortArthur_TransferPrice TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_PortArthur_TransferPrice >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_PortArthur_TransferPrice >>>'
GO