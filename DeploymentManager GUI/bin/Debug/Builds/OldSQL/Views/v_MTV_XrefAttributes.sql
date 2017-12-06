/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_XrefAttributes WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_XrefAttributes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_XrefAttributes.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_XrefAttributes]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_XrefAttributes] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_XrefAttributes >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_XrefAttributes]
AS
--------------------------------------------------------------------------------------------------------------
-- Purpose:  To allow navigation from the Search Event Log report to the Search Event Log Data report  
-- Created By: Pat Newgent  
-- Created:    6/10/2009  
--------------------------------------------------------------------------------------------------------------
Select	TRY_PARSE(SSEX.InternalValue as int)						as	RAKey,
		Convert(Int, NULL)											as	RAKey2,
		Coalesce(BAAbbrvtn + IsNull(BaAbbrvtnExtended, ''),
				LcleAbbrvtn + IsNull(LcleAbbrvtnExtension, ''),
				NULL)												as	RAValue,
		Case
			When BA.BAID is not null		Then 'BusinessAssociate'
			When L.LcleID is not null		Then 'Locale'
			When P.PrdctID is not null		Then 'Product'
			When SH.StrtgyID is not null	Then 'StrategyHeader'
			When Prvsn.PrvsnID is not null	Then 'Prvsn'
			When DT.DlTypID is not null		Then 'DealType'

		End															as	RATable,
		'XRef'														as	Source,
		SSE.ElementName												as	Qualifier,
		ElementValue												as	ExternalValue,
		ElementDirection											as	Direction
From	SourceSystemElementXref SSEX with (NoLock)
		Inner Join SourceSystemElement SSE with (NoLock)
			on	SSE.SrceSystmElmntID = SSEX.SrceSystmElmntID
		Inner join SourceSystem SS with (NoLock)
			on	SS.SrceSystmID		= SSE.SrceSystmID
		Left Outer Join BusinessAssociate BA with (NoLock)
			on	BA.BAID							= InternalValue
			and	SSE.DisplayStyle				like '%baid'
		Left Outer Join Locale L with (NoLock)
			on	L.LcleID						= InternalValue
			and	SSE.DisplayStyle				like '%lcleid'
		Left Outer Join Product P with (NoLock)
			on	P.PrdctID						= InternalValue
			and	SSE.DisplayStyle				like '%prdctid'
		Left Outer Join StrategyHeader SH with (NoLock)
			on	SH.StrtgyID						= InternalValue
			and	SSE.DisplayStyle				like '%strtgyid'
		Left Outer Join Prvsn with (NoLock)
			on	Prvsn.PrvsnID					= InternalValue
			and	SSE.DisplayStyle				like '%prvsnid'
		Left Outer Join DealType DT with (NoLock)
			on	DT.DlTypID						= InternalValue
			and	SSE.DisplayStyle				like '%dltypid'
		Left Outer Join Users with (NoLock)
			on	Users.UserID					= InternalValue
			and SSE.DisplayStyle				like '%userid'
		Left Outer Join MovementHeaderType MHT with (NoLock)
			on	MHT.MvtHdrTyp					= InternalValue
			and SSE.DisplayStyle				like '%MvtHdrTyp'
Where	TRY_PARSE(SSEX.InternalValue as int)	= 1
UNION ALL
Select	SSEX.SrceSystmElmntXrfID									as	RAKey,
		NULL														as	RAKey2,
		SSEX.InternalValue											as	RAValue,
		'SourceSystemElementXref'									as	RATable,
		'XRef'														as	Source,
		SSE.ElementName												as	Qualifier,
		ElementValue												as	ExternalValue,
		ElementDirection											as	Direction
From	SourceSystemElementXref SSEX with (NoLock)
		Inner Join SourceSystemElement SSE with (NoLock)
			on	SSE.SrceSystmElmntID = SSEX.SrceSystmElmntID
		Inner join SourceSystem SS with (NoLock)
			on	SS.SrceSystmID		= SSE.SrceSystmID
Where	IsNumeric(SSEX.InternalValue)	= 0
UNION ALL
Select	GnrlCnfgHdrID,
		GnrlCnfgDtlID,

		Coalesce(BAAbbrvtn + IsNull(BaAbbrvtnExtended, ''),
		LcleAbbrvtn + IsNull(LcleAbbrvtnExtension, ''),
		DlHdrIntrnlNbr + ' || ' + Convert(Varchar, DlDtlID),
		PrvsnNme,
		PrdctAbbv,
		DealType.Description,
		NULL),

		GnrlCnfgTblNme,
		'Attribute',
		GnrlCnfgQlfr,
		GnrlCnfgMulti,
		'X'
From	GeneralConfiguration with (NoLock)
		Left Outer Join BusinessAssociate BA with (NoLock)
			on	BA.BAID			= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	= 'BusinessAssociate'
		Left Outer Join Locale L with (NoLock)
			on	L.LcleID		= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	= 'Locale'
		Left Outer Join DealDetail DD with (NoLock)
			on	DD.DlDtlDlHdrID	= GnrlCnfgHdrID
			and	DD.DlDtlID		= GnrlCnfgDtlID
			and	GnrlCnfgTblNme	= 'DealDetail'
		Left Outer Join DealHeader DH with (NoLock)
			on	DH.DlHdrID		= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	in ('DealDetail', 'DealHeader')
		Left Outer Join Prvsn with (NoLock)
			on	Prvsn.PrvsnID	= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	= 'Prvsn'
		Left Outer Join Product with (NoLock)
			on Product.PrdctID	= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	= 'Product'
		Left Outer Join DealType with (NoLock)
			on DealType.DlTypID	= GnrlCnfgHdrID
			and	GnrlCnfgTblNme	= 'DealType'
Where	GnrlCnfgHdrID <> 0

  


GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_XrefAttributes]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_XrefAttributes.sql'
			PRINT '<<< ALTERED View v_MTV_XrefAttributes >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_XrefAttributes >>>'
	  END
