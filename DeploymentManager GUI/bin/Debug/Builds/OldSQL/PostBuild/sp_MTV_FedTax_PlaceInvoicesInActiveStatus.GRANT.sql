/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_PlaceInvoicesInActiveStatus WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FedTax_PlaceInvoicesInActiveStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_PlaceInvoicesInActiveStatus]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_PlaceInvoicesInActiveStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_PlaceInvoicesInActiveStatus >>>'

