
/****** Object:  View [dbo].[v_MTV_AccountDetailShipToSoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_v_MTV_AccountDetailShipToSoldTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailShipToSoldTo]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_AccountDetailShipToSoldTo] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_AccountDetailShipToSoldTo >>>'
	  END
GO

set ansi_nulls on
go

set quoted_identifier off
go

alter view [dbo].[v_MTV_AccountDetailShipToSoldTo]
as
-- =============================================
-- Author:        CraigAlbright	
-- Create date:	  9/20/2017
-- Description:   Gives you the AcctDtl, ShipTo and the SoldTo
-- =============================================
select (CAD.AcctDtlID)
		,CASE when( CAD.AcctDtlPrntID <> CAD.AcctDtlID) then (select top 1 c2.SAPSoldToCode from CustomAccountDetailAttribute c2 where c2.CADID = 
		(select ID from CustomAccountDetail c3 where c3.AcctDtlID = CAD.AcctDtlPrntID))
		   else CADA.SAPSoldToCode end as SoldTo
		,CASE when( CAD.AcctDtlPrntID <> CAD.AcctDtlID) then (select top 1 c2.SAPShipToCode from CustomAccountDetailAttribute c2 where c2.CADID = 
		(select ID from CustomAccountDetail c3 where c3.AcctDtlID = CAD.AcctDtlPrntID))
		   else CADA.SAPShipToCode end as ShipTo
from CustomAccountDetail CAD (nolock)
inner join CustomAccountDetailAttribute CADA (nolock) on 
CADA.CADID = CAD.ID 
where CADA.SAPShipToCode is not null and CADA.SAPSoldToCode is not null

Go

IF not Exists(select '' from sys.indexes where name = 'idx_CADIDSAPShipToCode')
      BEGIN
			CREATE NONCLUSTERED INDEX idx_CADIDSAPShipToCode
			ON [dbo].[CustomAccountDetailAttribute] ([CADID])
			INCLUDE ([SAPShipToCode])
	  END


