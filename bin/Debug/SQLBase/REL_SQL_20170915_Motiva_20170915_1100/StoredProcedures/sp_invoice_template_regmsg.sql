/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_regmsg WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_regmsg]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_regmsg.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_regmsg]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_regmsg] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_regmsg >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].[sp_invoice_template_regmsg] @i_SlsInvceHdrID int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_regmsg  151         Copyright 1997,1998,1999,2000,2001,2002 SolArc
-- Overview:	Returns Invoicing Messages for a givne invoice
-- Created by:	Pat Newgent
-- History:	05/16/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Select 	distinct Convert(varchar(max),Mssge)
From	SalesInvoiceAddendum
Where	SlsInvceHdrID = @i_SlsInvceHdrID




GO


if OBJECT_ID('sp_invoice_template_regmsg')is not null begin
   EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_regmsg.sql'
   grant execute on sp_invoice_template_regmsg to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_regmsg failed >>>"