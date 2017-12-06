/****** Object:  ViewName [dbo].[SP_Invoice_Template_Instructions_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions_TA.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO
if OBJECT_ID('SP_Invoice_Template_Instructions_TA')is not null begin
   print '<<< Procedure SP_Invoice_Template_Instructions_TA created >>>'
   grant execute on SP_Invoice_Template_Instructions_TA to sysuser, RightAngleAccess
end
else
   print '<<<< Creation of procedure SP_Invoice_Template_Instructions_TA failed >>>'


