PRINT 'Start Script=MTVReStageAllFPSContractRecords.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVReStageAllFPSContractRecords]') IS NULL
      BEGIN
                     EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVReStageAllFPSContractRecords] AS SELECT 1'
                     PRINT '<<< CREATED StoredProcedure MTVReStageAllFPSContractRecords >>>'
         END
GO

SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].MTVReStageAllFPSContractRecords 
	@EffectiveDate AS Date,
	@LookBackMonths AS Int
with execute as 'dbo'
AS

-- =============================================
-- Author:        Craig Albright
-- Create date:        01/13/2017
-- Description:   This SP is the "send all" data dump for FPS contracts
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 01/17/2017	Craig			N/A		Filter by Active deals only
-- 05/25/2017	MattV			Defect#7193	Fixed the stored procedure to work the way the functional spec dictated it should
-----------------------------------------------------------------------------

BEGIN

if OBJECT_ID('tempdb..#FPSRetailContractTemp') is not null
	drop table #FPSRetailContractTemp

create table #FPSRetailContractTemp
(
REC_TYPE varchar(20) not null,
COU_CODE varchar(20)  null,
SALES_ORG varchar(20) null,
DISTRIBUTION_CHANNEL varchar(20) null,
DIVISION varchar(20) null,
CUSTOMER_GROUP varchar(20) null,
CONTRACT_NUMBER varchar(20) null,
CONTRACT_TYPE varchar(20) null, 
CUSTOMER_NUMBER varchar(20) null,
PARTNER_CUSTOMER varchar(20) null,
PLANT_CODE varchar(20) null,
PRODUCT_CODE varchar(20) null,
PRO_REF_FLAG varchar(20) null,
PRODUCT_GPC_CODE varchar(20) null,
TARGET varchar(20) null,
UOM_CODE varchar(20) null,
DATE_FROM varchar(20) null,
DATE_TO varchar(20) null,
CONTRACT_ITEM varchar(30) null,
REJECTION_FLAG varchar(30) null, 
HANDLING_TYPE varchar(30) null,
PAYMENT_TERM varchar(30) null, 
SHIPPING_CONDITION varchar(30) null,
PARTNER_FUNCTION varchar(30) null,
SentToFps bit null,
InternalBaid int null,
SentDate smalldatetime null,
interfacerunid int null,
recordinfo varchar(30) null,
UserID int null,
ShipToSoldTo varchar(30) null,
MustSend bit null
)

Begin

insert into #FPSRetailContractTemp  (REC_TYPE,COU_CODE,SALES_ORG,DISTRIBUTION_CHANNEL,DIVISION,CUSTOMER_GROUP,CONTRACT_NUMBER,CONTRACT_TYPE, CUSTOMER_NUMBER,
PARTNER_CUSTOMER,PLANT_CODE,PRODUCT_CODE,PRO_REF_FLAG,PRODUCT_GPC_CODE,TARGET,UOM_CODE,DATE_FROM,DATE_TO,CONTRACT_ITEM,REJECTION_FLAG, HANDLING_TYPE,PAYMENT_TERM, SHIPPING_CONDITION,PARTNER_FUNCTION,
SentToFps,InternalBaid,SentDate,interfacerunid,recordinfo,UserID,ShipToSoldTo,MustSend)

select '619' as REC_TYPE,
'US' as COU_CODE,
'USK7' as SALES_ORG,
'14' as DISTRIBUTION_CHANNEL,
'02' as DIVISION,
'01' as CUSTOMER_GROUP, 
dh.DlHdrIntrnlNbr as CONTRACT_NUMBER,
(Case when (select et.TemplateName from EntityTemplate et where et.EntityTemplateID = dh.EntityTemplateID ) like '%SALE%' then 'SALE' end) CONTRACT_TYPE, 
SoldTo.SoldTo as CUSTOMER_NUMBER,
NULL as PARTNER_CUSTOMER, 
PlantCodeGC.GnrlCnfgMulti as PLANT_CODE,
MaterialCodeGC.GnrlCnfgMulti as PRODUCT_CODE,
'2' as PRO_REF_FLAG, 
'' as PRODUCT_GPC_CODE, 
'' as TARGET,
uom.UOMAbbv as UOM_CODE,
CONCAT(FORMAT(DATEPART(YEAR,dh.DlHdrFrmDte),'0000'),FORMAT(DATEPART(MONTH,dh.DlHdrFrmDte),'00'),FORMAT(DATEPART(DAY,dh.dlhdrfrmdte),'00')) as DATE_FROM, 
(CASE WHEN dh.Term = 'E' THEN '99991231' 
	ELSE CONCAT(FORMAT(DATEPART(YEAR,dh.DlHdrToDte),'0000'),FORMAT(DATEPART(MONTH,dh.DlHdrToDte),'00'),FORMAT(DATEPART(DAY,dh.DlHdrToDte),'00'))
	END) as DATE_TO,
dd.DlDtlID as CONTRACT_ITEM,
'' as REJECTION_FLAG,
'AA' as HANDLING_TYPE,
'' as PAYMENT_TERM,
'10' as SHIPPING_CONDITION, 
NULL as PARTNER_FUNCTION, 
0 as SentToFps, 
dh.DlHdrIntrnlBAID as InternalBaid,
GETDATE() as SentDate,
null as interfacerunid,
'BULK LOAD' as recordinfo,
1 as UserID, 
'SoldTo' as ShipToSoldTo,
0 as MustSend

from DealDetail dd

inner join DealHeader dh 
on dd.DlDtlDlHdrID = dh.dlhdrid

--Exclude non-FSM deals
inner join Registry FSMBAName
on FSMBAName.RgstryKyNme = 'MotivaFSMIntrnlBAName'
inner join BusinessAssociate FSMBA
on FSMBA.Name = FSMBAName.RgstryDtaVle
and dh.DlHdrIntrnlBAID = FSMBA.BAID

--Exclude disallowed deal types
inner join Registry AllowedDealTypes
on AllowedDealTypes.RgstryKyNme = 'MotivaFPSAllowedDealType'
and dh.DlHdrTyp in ( AllowedDealTypes.RgstryDtaVle )

left Join GeneralConfiguration SoldToGC 
on SoldToGC.GnrlCnfgQlfr = 'SAPSoldTo' 
and SoldToGC.GnrlCnfgHdrID = dh.dlhdrid 
and GnrlCnfgHdrID > 0 
and SoldToGC.GnrlCnfgTblNme = 'DealHeader'

left Join MTVSAPBASoldTo SoldTo 
on SoldTo.BAID = dh.DlHdrExtrnlBAID 
and SoldTo.ID = SoldToGC.GnrlCnfgMulti

left join GeneralConfiguration PlantCodeGC 
on PlantCodeGC.GnrlCnfgQlfr = 'SAPPlantCode' 
and PlantCodeGC.GnrlCnfgTblNme = 'Locale' 
and PlantCodeGC.GnrlCnfgHdrID = dd.DlDtlLcleID

left join GeneralConfiguration MaterialCodeGC 
on MaterialCodeGC.GnrlCnfgQlfr = 'SAPMaterialCode' 
and MaterialCodeGC.GnrlCnfgTblNme = 'Product' 
and MaterialCodeGC.GnrlCnfgHdrID = dd.DlDtlPrdctID

left join UnitOfMeasure uom 
on uom.UOM = dd.DlDtlDsplyUOM

WHERE dh.DlHdrStat = 'A' 
and dh.DlHdrToDte >= @EffectiveDate
--and dd.DlDtlToDte >= DATEADD(month, @LookBackMonths, GETDATE())	--619 (SoldTo) records should still get staged. 619_CPF (ShipTo) shouldn't. 

End


Begin
insert into #FPSRetailContractTemp (REC_TYPE,COU_CODE,SALES_ORG,DISTRIBUTION_CHANNEL,DIVISION,CUSTOMER_GROUP,CONTRACT_NUMBER,CONTRACT_TYPE, CUSTOMER_NUMBER,
PARTNER_CUSTOMER,PLANT_CODE,PRODUCT_CODE,PRO_REF_FLAG,PRODUCT_GPC_CODE,TARGET,UOM_CODE,DATE_FROM,DATE_TO,CONTRACT_ITEM,REJECTION_FLAG, HANDLING_TYPE,PAYMENT_TERM, SHIPPING_CONDITION,PARTNER_FUNCTION,
SentToFps,InternalBaid,SentDate,interfacerunid,recordinfo,UserID,ShipToSoldTo,MustSend)

select '619_CPF' as REC_TYPE,
'US' as COU_CODE,
'USK7' as SALES_ORG,
'14' as DISTRIBUTION_CHANNEL,
'02' as DIVISION,
null as CUSTOMER_GROUP, 
dh.DlHdrIntrnlNbr as CONTRACT_NUMBER,
Null as CONTRACT_TYPE, 
SoldTo.SoldTo as CUSTOMER_NUMBER,
ShipTo.ShipTo as PARTNER_CUSTOMER, 
PlantCodeGC.GnrlCnfgMulti as PLANT_CODE,
MaterialCodeGC.GnrlCnfgMulti as PRODUCT_CODE,
'2' as PRO_REF_FLAG, 
NULL as PRODUCT_GPC_CODE, 
NULL as TARGET,
NULL as UOM_CODE,
NULL as DATE_FROM, 
NULL as DATE_TO,dd.DlDtlID as CONTRACT_ITEM,
'' as REJECTION_FLAG,
NULL as HANDLING_TYPE,
NULL as PAYMENT_TERM,
NULL as SHIPPING_CONDITION, 
'WE' as PARTNER_FUNCTION, 
0 as SentToFps, 
NULL as InternalBaid,
GETDATE() as SentDate,
null as interfacerunid,
'BULK LOAD' as recordinfo,
1 as UserID, 
'ShipTo' as ShipToSoldTo,
0 as MustSend

from DealDetail dd

inner join DealHeader dh 
on dd.DlDtlDlHdrID = dh.dlhdrid

--Exclude non-FSM deals
inner join Registry FSMBAName
on FSMBAName.RgstryKyNme = 'MotivaFSMIntrnlBAName'
inner join BusinessAssociate FSMBA
on FSMBA.Name = FSMBAName.RgstryDtaVle
and dh.DlHdrIntrnlBAID = FSMBA.BAID

--Exclude disallowed deal types
inner join Registry AllowedDealTypes
on AllowedDealTypes.RgstryKyNme = 'MotivaFPSAllowedDealType'
and dh.DlHdrTyp in ( AllowedDealTypes.RgstryDtaVle )

left Join GeneralConfiguration SoldToGC 
on SoldToGC.GnrlCnfgQlfr = 'SAPSoldTo' 
and SoldToGC.GnrlCnfgHdrID = dh.dlhdrid 
and SoldToGC.GnrlCnfgHdrID > 0
and SoldToGC.GnrlCnfgTblNme = 'DealHeader'

left Join MTVSAPBASoldTo SoldTo 
on SoldTo.BAID = dh.DlHdrExtrnlBAID 
and SoldTo.ID = SoldToGC.GnrlCnfgMulti

left join MTVDealDetailShipTo DealDetailShipTo 
on DealDetailShipTo.DlDtlID = dd.DlDtlID 
and DealDetailShipTo.DlHdrID = dd.DlDtlDlHdrID 

left join MTVSAPSoldToShipTo ShipTo 
on DealDetailShipTo.SoldToShipToID = ShipTo.ID

left join GeneralConfiguration PlantCodeGC 
on PlantCodeGC.GnrlCnfgQlfr = 'SAPPlantCode' 
and PlantCodeGC.GnrlCnfgTblNme = 'Locale' 
and PlantCodeGC.GnrlCnfgHdrID = dd.DlDtlLcleID

left join GeneralConfiguration MaterialCodeGC 
on MaterialCodeGC.GnrlCnfgQlfr = 'SAPMaterialCode' 
and MaterialCodeGC.GnrlCnfgTblNme = 'Product' 
and MaterialCodeGC.GnrlCnfgHdrID = dd.DlDtlPrdctID

WHERE dh.DlHdrStat = 'A' 
and dh.DlHdrToDte >= @EffectiveDate
and dd.DlDtlToDte >= DATEADD(month, @LookBackMonths, GETDATE())
and DealDetailShipTo.ToDate >= @EffectiveDate
and DealDetailShipTo.Status = 'A'

End

Begin

Truncate table MTVRetailContractRAtoFPSStaging

End

Begin

insert INTO MTVRetailContractRAtoFPSStaging (REC_TYPE,COU_CODE,SALES_ORG,DISTRIBUTION_CHANNEL,DIVISION,CUSTOMER_GROUP,CONTRACT_NUMBER,CONTRACT_TYPE, CUSTOMER_NUMBER,
PARTNER_CUSTOMER,PLANT_CODE,PRODUCT_CODE,PRO_REF_FLAG,PRODUCT_GPC_CODE,TARGET,UOM_CODE,DATE_FROM,DATE_TO,CONTRACT_ITEM,REJECTION_FLAG, HANDLING_TYPE,PAYMENT_TERM, SHIPPING_CONDITION,PARTNER_FUNCTION,
SentToFps,InternalBaid,SentDate,interfacerunid,recordinfo,UserID,ShipToSoldTo,MustSend)
Select REC_TYPE,COU_CODE,SALES_ORG,DISTRIBUTION_CHANNEL,DIVISION,CUSTOMER_GROUP,CONTRACT_NUMBER,CONTRACT_TYPE, CUSTOMER_NUMBER,
PARTNER_CUSTOMER,PLANT_CODE,PRODUCT_CODE,PRO_REF_FLAG,PRODUCT_GPC_CODE,TARGET,UOM_CODE,DATE_FROM,DATE_TO,CONTRACT_ITEM,REJECTION_FLAG, HANDLING_TYPE,PAYMENT_TERM, SHIPPING_CONDITION,PARTNER_FUNCTION,
SentToFps,InternalBaid,SentDate,interfacerunid,recordinfo,UserID,ShipToSoldTo,MustSend
from #FPSRetailContractTemp

End

END

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVReStageAllFPSContractRecords]') IS NOT NULL
BEGIN
            EXECUTE       sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVReStageAllFPSContractRecords.sql'
            PRINT '<<< ALTERED StoredProcedure MTVReStageAllFPSContractRecords >>>'
END
ELSE
BEGIN
            PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVReStageAllFPSContractRecords >>>'
END    


/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVReStageAllFPSContractRecords 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVReStageAllFPSContractRecords]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVReStageAllFPSContractRecords.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVReStageAllFPSContractRecords]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVReStageAllFPSContractRecords TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVReStageAllFPSContractRecords >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVReStageAllFPSContractRecords >>>'
