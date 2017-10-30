/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTaxDetailInserted WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTVTaxDetailInserted]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_MTVTaxDetailInserted].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTaxDetailInserted]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTVTaxDetailInserted] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_MTVTaxDetailInserted] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_MTVTaxDetailInserted]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER  Procedure [dbo].sp_MTVTaxDetailInserted 
( @vc_RamqMessage VARCHAR(2000) )
As

-- exec sp_mtvtaxdetailinserted 'AccountDetail Inserted:AcctDtlID=27634||AcctDtlSrceID=18934||AcctDtlSrceTble=T ||AcctDtlTrnsctnTypID=2449||Reversed=N||AcctDtlPrntID=27633||AcctDtlTrnsctnDte=Oct  1 2016  1:54:00||AcctDtlAccntngPrdID=||AcctDtlTxStts=N'
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTVTaxDetailInserted txdtlid:xxxxx     
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	
-- History:	
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------
-----------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

-------------------------------------------------------------------------------------------  
-- DECLARE variables for process tracking stored procedure sp_insert_processevent  
-------------------------------------------------------------------------------------------  
DECLARE @avc30_PrcssEvntQlfr     VARCHAR(30)		/* Qualifier used to distinguish process from one another */   
DECLARE @ac2_PrcssEvntCde        CHAR(2)	        /* Code meaningful and controlled by the process */  
DECLARE @avc25_PrcssEvntDscrptn  VARCHAR(200)		/* Description of event code */  
DECLARE @avc55_PrcssEvntLocation VARCHAR(55)
DECLARE @vc_ErrorMessage         VARCHAR(2000)
DECLARE @vc_ErrorEvent           VARCHAR(1000)
DECLARE @i_SQLError              INT
DECLARE @DBID                    INT
DECLARE @DBNAME                  NVARCHAR(128)
DECLARE @c_IsReversed            CHAR(1)
DECLARE @output                  varchar(100)
DECLARE @acctdtlid               int
DECLARE @acctdtlsrceid           int
DECLARE @originalacctdtlid       int

SET @DBID   = DB_ID()
SET @DBNAME = DB_NAME()  


select @avc30_PrcssEvntQlfr = 'sp_MTVTaxDetailInserted'  

      



if @vc_RamqMessage like '%AcctDtlSrceTble=T ||%'
Begin

   if @vc_RamqMessage like '%Reversed=N%'
      set @c_IsReversed = 'N'
   else
      set @c_IsReversed = 'Y'
      
  
  
  select @output = 
   ( select substring(@vc_RamqMessage, charindex('=',@vc_RamqMessage) + 1, LEN( SUBSTRING( @vc_RamqMessage, 1,charindex('||',@vc_RamqMessage))) - charindex('=',@vc_RamqMessage) - 1) )

   if isnumeric(@output) = 1 set @acctdtlid = convert(int,@output)

   if @c_IsReversed = 'N'
      insert into dbo.MTV_AccountDetailTaxRateArchive
      select @acctdtlid, v_MTV_TaxRates.taxrate, getdate()
      From dbo.v_MTV_TaxRates
      where v_MTV_TaxRates.AcctDtlID = @acctdtlid
   else
   begin
      Select @originalacctdtlid = 
      (   Select AD2.AcctDtlID
            From dbo.AccountDetail
                 inner join TaxDetailLog on TaxDetailLog.TxDtlLgID = AccountDetail.AcctDtlSrceID
                                        and TaxDetailLog.TxDtlLgRvrsd = 'Y' 
                 left outer join TaxDetailLog TDL2 on TDL2.TxDtlLgTxDtlID = TaxDetailLog.TxDtlLgTxDtlID
                                             and TDL2.TxDtlLgRvrsd = 'N'
											 and TDL2.TxDtlLgID =( select max(TDL3.TxDtlLgID) 
											                        From TaxDetailLog TDL3
											                        Where TDL3.TxDtlLgTxDtlID =  TaxDetailLog.TxDtlLgTxDtlID
											                          and TDL3.TxDtlLgID < TaxDetailLog.TxDtlLgID )
                 left outer join AccountDetail AD2 on AD2.AcctDtlSrceID = TDL2.TxDtlLgID
                                                  and AD2.AcctDtlSrceTble = 'T'
           Where AccountDetail.AcctDtlID = @AcctDtlID
		     
        )
        
        Insert into MTV_AccountDetailTaxRateArchive
        select @acctDtlId, MTV_AccountDetailTaxRateArchive.TaxRate, getdate()
        From dbo.MTV_AccountDetailTaxRateArchive
        Where dbo.MTV_AccountDetailTaxRateArchive.AcctDtlID = @originalacctdtlid
    end  
      
      
      
End
go

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTaxDetailInserted]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVTaxDetailInserted.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTVTaxDetailInserted >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTVTaxDetailInserted >>>'
	  END