/****** Object:  StoredProcedure [dbo].[MTV_SAP_GL_CreateIdocs]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_GL_CreateIdocs.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GL_CreateIdocs]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAP_GL_CreateIdocs] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAP_GL_CreateIdocs >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SAP_GL_CreateIdocs]
AS

-- =============================================
-- Author:        Jeremy von Hoff
-- Create date:	  29SEP2016
-- Description:   Create an IDOC for SAP from our staging data
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare	@vc_MANDT varchar(255)
Declare	@vc_SNDPOR varchar(255)
Declare	@vc_RCVPOR varchar(255)
Declare	@vc_RCVPRN varchar(255)
Declare	@vc_OBJ_TYPE varchar(255)
Declare	@vc_USERNAME varchar(255)
Declare	@sdt_DocDate smalldatetime

Select	@vc_MANDT = dbo.GetRegistryValue("Motiva\SAP\Idoc\MANDT")
Select	@vc_SNDPOR = dbo.GetRegistryValue("Motiva\SAP\Idoc\SNDPOR")
Select	@vc_RCVPOR = dbo.GetRegistryValue("Motiva\SAP\Idoc\RCVPOR")
Select	@vc_RCVPRN = dbo.GetRegistryValue("Motiva\SAP\Idoc\RCVPRN")
Select	@vc_OBJ_TYPE = dbo.GetRegistryValue("Motiva\SAP\Idoc\Obj_Type")
Select	@vc_USERNAME = dbo.GetRegistryValue("Motiva\SAP\Idoc\Username")

select @sdt_DocDate = min(AccntngPrdEndDte) from AccountingPeriod (NoLock) where AccntngPrdCmplte = 'N'

Select	*
Into	#WorkingTable
From	MTVSAPGLStaging (NoLock)
Where	(RightAngleStatus in ('M', 'N') or SAPStatus = 'M')
and		DocumentDate = @sdt_DocDate

Create Table #OutputTable
			(
			IDOC			varchar(max),
			IDsToUpdate		varchar(max)
			)

Insert	#OutputTable (IDOC, IDsToUpdate)
Select	'<?xml version="1.0"?>
<ACC_DOCUMENT04 xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <IDOC BEGIN="1">
    <EDI_DC40>
      <TABNAM>EDI_DC40</TABNAM>
      <MANDT>'+@vc_MANDT+'</MANDT>
      <DIRECT>1</DIRECT>
      <IDOCTYP>ACC_DOCUMENT04</IDOCTYP>
      <CIMTYP />
      <MESTYP>ACC_DOCUMENT</MESTYP>
      <SNDPOR>'+@vc_SNDPOR+'</SNDPOR>
      <SNDPRT>LS</SNDPRT>
      <SNDPRN>CAPPDBTS</SNDPRN>
      <RCVPOR>'+@vc_RCVPOR+'</RCVPOR>
      <RCVPRT>LS</RCVPRT>
      <RCVPFC>LS</RCVPFC>
      <RCVPRN>'+@vc_RCVPRN+'</RCVPRN>
      <CREDAT>' + FORMAT(getdate(), 'yyyyMMdd') + '</CREDAT>
      <CRETIM>' + FORMAT(getdate(), 'HHmmss') + '</CRETIM>
      <SERIAL>0</SERIAL>
    </EDI_DC40>
    <E1BPACHE09 SEGMENT="1">
      <OBJ_TYPE>'+@vc_OBJ_TYPE+'</OBJ_TYPE>
      <USERNAME>'+@vc_USERNAME+'</USERNAME>' + '
      <HEADER_TXT>' + min(real.DocumentHeaderText) + '</HEADER_TXT>' + '
      <COMP_CODE>' + min(real.CompanyCode) + '</COMP_CODE>' + '
      <DOC_DATE>' + FORMAT(real.DocumentDate, 'yyyyMMdd') + '</DOC_DATE>' + '
      <PSTNG_DATE>' + FORMAT(real.PostingDate, 'yyyyMMdd') + '</PSTNG_DATE>' + '
      <FISC_YEAR>' + FORMAT(real.PostingDate, 'yyyy') + '</FISC_YEAR>' + '
      <FIS_PERIOD>' + FORMAT(real.PostingDate, 'MM') + '</FIS_PERIOD>' + '
      <DOC_TYPE>' + min(real.DocumentType) + '</DOC_TYPE>' + '
      <REF_DOC_NO>' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(real.ReferenceDocument,'&', '&amp;'),'<', '&lt;'),'>', '&gt;'),'"', '&quot;'),'''', '&#39;') + '</REF_DOC_NO>' + '
    </E1BPACHE09>' +
	
	(Select	1 as "E1BPACGL09/@SEGMENT",
			ROW_NUMBER() OVER (Order By CGLIID) as "E1BPACGL09/ITEMNO_ACC",
			RIGHT(REPLICATE('0', 10) + sub.Account, 10) as "E1BPACGL09/GL_ACCOUNT",
			sub.LineItemText as "E1BPACGL09/ITEM_TEXT",
			sub.ReferenceKey1 as "E1BPACGL09/REF_KEY_1",
			sub.ReferenceKey2 as "E1BPACGL09/REF_KEY_2",
			sub.ReferenceKey3 as "E1BPACGL09/REF_KEY_3",
			Case When sub.Plant = 'NONE' Then NULL Else sub.Plant End as "E1BPACGL09/PLANT",
			RIGHT(REPLICATE('0', 10) + sub.Customer, 10) as "E1BPACGL09/CUSTOMER",
			sub.TaxCode as "E1BPACGL09/TAX_CODE",
			sub.CostCenter as "E1BPACGL09/COSTCENTER",
			RIGHT(REPLICATE('0', 10) + sub.ProfitCenter, 10) as "E1BPACGL09/PROFIT_CTR",
			Case When sub.BaseUnit = 'NON' Then NULL Else FORMAT(sub.Quantity, 'F3') End as "E1BPACGL09/QUANTITY",
			Case When sub.BaseUnit = 'NON' Then NULL Else sub.BaseUnit End as "E1BPACGL09/BASE_UOM",
			Case When sub.Material = 'NONE' Then NULL Else RIGHT(REPLICATE('0', 18) + sub.Material, 18) End as "E1BPACGL09/MATERIAL"
						
	from	MTVSAPGLStaging sub (NoLock)
	Where	IsNull(sub.CostCenter, 'x')			= IsNull(real.CostCenter, 'x')
	and		IsNull(sub.ProfitCenter, 'x')		= IsNull(real.ProfitCenter, 'x')
	and		IsNull(sub.Material, 'x')			= IsNull(real.Material, 'x')
	and		IsNull(sub.Plant, 'x')				= IsNull(real.Plant, 'x')
	and		sub.PostingDate						= real.PostingDate
	and		IsNull(sub.ReferenceDocument, 'x')	= IsNull(real.ReferenceDocument, 'x')
	and		sub.DocumentDate					= real.DocumentDate
	order by ID
	for XML PATH('')) + 


	(Select
			1 as "E1BPACCR09/@SEGMENT",
			ROW_NUMBER() OVER (Order By CGLIID) as "E1BPACCR09/ITEMNO_ACC",
			sub.Currency as "E1BPACCR09/CURRENCY",
			FORMAT(sub.DocumentAmount, 'F2') + Case When sub.PostingKey not in (1, 21, 40) Then '-' Else '' End as "E1BPACCR09/AMT_DOCCUR"


	from	MTVSAPGLStaging sub (NoLock)
	Where	IsNull(sub.CostCenter, 'x')			= IsNull(real.CostCenter, 'x')
	and		IsNull(sub.ProfitCenter, 'x')		= IsNull(real.ProfitCenter, 'x')
	and		IsNull(sub.Material, 'x')			= IsNull(real.Material, 'x')
	and		IsNull(sub.Plant, 'x')				= IsNull(real.Plant, 'x')
	and		sub.PostingDate						= real.PostingDate
	and		IsNull(sub.ReferenceDocument, 'x')	= IsNull(real.ReferenceDocument, 'x')
	and		sub.DocumentDate					= real.DocumentDate
	order by ID
	for XML PATH('')) + '</IDOC></ACC_DOCUMENT04>' as children, 
	
	(Select convert(varchar, ID) + ','
	From	#WorkingTable sub
	Where	IsNull(sub.CostCenter, 'x')			= IsNull(real.CostCenter, 'x')
	and		IsNull(sub.ProfitCenter, 'x')		= IsNull(real.ProfitCenter, 'x')
	and		IsNull(sub.Material, 'x')			= IsNull(real.Material, 'x')
	and		IsNull(sub.Plant, 'x')				= IsNull(real.Plant, 'x')
	and		sub.PostingDate						= real.PostingDate
	and		IsNull(sub.ReferenceDocument, 'x')	= IsNull(real.ReferenceDocument, 'x')
	and		sub.DocumentDate					= real.DocumentDate
	for XML PATH('')) as IDsToUpdate

From	#WorkingTable real
Where	1=1
group by real.CostCenter, real.ProfitCenter, real.Material, real.Plant, real.PostingDate, real.ReferenceDocument, real.DocumentDate


/**********************************
--	Now return our data
**********************************/
Select	cast(IDOC as XML) as IDOC,
		IDsToUpdate
From	#OutputTable
Where	IDOC is not null and IDsToUpdate is not null

Drop Table #WorkingTable
Drop Table #OutputTable

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GL_CreateIdocs]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAP_GL_CreateIdocs.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAP_GL_CreateIdocs >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAP_GL_CreateIdocs >>>'
	  END