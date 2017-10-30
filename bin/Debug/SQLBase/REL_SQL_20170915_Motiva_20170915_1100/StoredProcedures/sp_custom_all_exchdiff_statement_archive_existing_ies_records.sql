/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_all_exchdiff_statement_archive_existing_ies_records WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_custom_all_exchdiff_statement_archive_existing_ies_records]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_all_exchdiff_statement_archive_existing_ies_records.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_all_exchdiff_statement_archive_existing_ies_records]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_custom_all_exchdiff_statement_archive_existing_ies_records] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_custom_all_exchdiff_statement_archive_existing_ies_records >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER Procedure [dbo].[sp_custom_all_exchdiff_statement_archive_existing_ies_records]
As

-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_custom_all_exchdiff_statement_archive_existing_ies_records         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the exchange statements in an open Accounting Period.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Sanjay Kumar
-- History:	11/10/2015 - First Created
--
-- 	Date Modified 	Modified By		Issue#		Modification
-- 	--------------- -------------- 	------		-------------------------------------------------------------------------
--  2016/08/09		DAO							Moved Looping logic into .net code.
--	20161028		rlb				3661		Change logic to pull from SalesInvoiceStatement to insure statements have been created.
--  20170623        ssk             7765        Changed the logic to retrieve Invoices from the last Closed Accounting Period.
--	20170630		MV				7765		Updated the logic to be able to handle accounting period offsets


INSERT INTO MTVIESExchangeStagingArchive (MTVIESExchID
,SlsInvceSttmntSlsInvceHdrID
,SlsInvceSttmntXHdrID
,SlsInvceSttmntRvrsd
,DlHdrExtrnlNbr
,DlHdrIntrnlNbr
,ParentPrdctAbbv
,ChildPrdctID
,ChildPrdcAbbv
,OriginLcleAbbrvtn
,DestinationLcleAbbrvtn
,FOBLcleAbbrvtn
,Quantity
,MvtDcmntExtrnlDcmntNbr
,MvtHdrDte
,XHdrTyp
,InvntryRcncleClsdAccntngPrdID
,ChildPrdctOrder
,Description
,TransactionDesc
,XchDiffGrpID1
,XchDiffGrpName1
,XchUnitValue1
,XchDiffGrpID2
,XchDiffGrpName2
,XchUnitValue2
,XchDiffGrpID3
,XchDiffGrpName3
,XchUnitValue3
,XchDiffGrpID4
,XchDiffGrpName4
,XchUnitValue4
,XchDiffGrpID5
,XchDiffGrpName5
,XchUnitValue5
,LastMonthsBalance
,ThisMonthsbalance
,Balance
,DynLstBxDesc
,TotalValue
,ContractContact
,UOMAbbv
,MovementTypeDesc
,PerUnitDecimalPlaces
,QuantityDecimalPlaces
,AccountPeriod
,ExternalBAID
,Action
,InterfaceMessage
,InterfaceFile
,InterfaceID
,ImportDate
,ModifiedDate
,UserId
,ProcessedDate
,ArchivedDate)
SELECT MTVIESExchID
,SlsInvceSttmntSlsInvceHdrID
,SlsInvceSttmntXHdrID
,SlsInvceSttmntRvrsd
,DlHdrExtrnlNbr
,DlHdrIntrnlNbr
,ParentPrdctAbbv
,ChildPrdctID
,ChildPrdcAbbv
,OriginLcleAbbrvtn
,DestinationLcleAbbrvtn
,FOBLcleAbbrvtn
,Quantity
,MvtDcmntExtrnlDcmntNbr
,MvtHdrDte
,XHdrTyp
,InvntryRcncleClsdAccntngPrdID
,ChildPrdctOrder
,Description
,TransactionDesc
,XchDiffGrpID1
,XchDiffGrpName1
,XchUnitValue1
,XchDiffGrpID2
,XchDiffGrpName2
,XchUnitValue2
,XchDiffGrpID3
,XchDiffGrpName3
,XchUnitValue3
,XchDiffGrpID4
,XchDiffGrpName4
,XchUnitValue4
,XchDiffGrpID5
,XchDiffGrpName5
,XchUnitValue5
,LastMonthsBalance
,ThisMonthsbalance
,Balance
,DynLstBxDesc
,TotalValue
,ContractContact
,UOMAbbv
,MovementTypeDesc
,PerUnitDecimalPlaces
,QuantityDecimalPlaces
,AccountPeriod
,ExternalBAID
,Action
,InterfaceMessage
,InterfaceFile
,InterfaceID
,ImportDate
,ModifiedDate
,UserId
,ProcessedDate
,GETDATE()
FROM MTVIESExchangeStaging


TRUNCATE TABLE MTVIESExchangeStaging

GO


/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_all_exchdiff_statement_archive_existing_ies_records WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_all_exchdiff_statement_archive_existing_ies_records.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_all_exchdiff_statement_archive_existing_ies_records]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_custom_all_exchdiff_statement_archive_existing_ies_records TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_archive_existing_ies_records >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_archive_existing_ies_records >>>'
GO
