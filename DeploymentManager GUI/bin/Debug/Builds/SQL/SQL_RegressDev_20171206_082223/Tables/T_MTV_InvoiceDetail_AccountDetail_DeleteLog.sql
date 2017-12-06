/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_InvoiceDetail_AccountDetail_DeleteLog WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  Table [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_InvoiceDetail_AccountDetail_DeleteLog.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]
    PRINT '<<< DROPPED TABLE MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'
END


/****** Object:  Table [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTV_InvoiceDetail_AccountDetail_DeleteLog
(
SIDADId						INT				IDENTITY
,InvoiceHeaderId			INT				NULL
,AccountDetailId			INT				NULL
,InvoiceType				CHAR(2)
,CreatedDate		SMALLDATETIME) 

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_InvoiceDetail_AccountDetail_DeleteLog.sql'
    PRINT '<<< CREATED TABLE MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'

