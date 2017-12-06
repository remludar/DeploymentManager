
GO
/****** Object:  StoredProcedure [dbo].[MTV_Order_To_DataLake_Staging]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_Order_To_DataLake_Staging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Order_To_DataLake_Staging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Order_To_DataLake_Staging >>>'
	  END
GO

-- =======================================================================================================================================
-- Author:		Craig Albright	
-- Create date: 12/19/2016
-- Description:	Put Orders in Datalake
-- =======================================================================================================================================
ALTER PROCEDURE [dbo].[MTV_Order_To_DataLake_Staging] WITH EXECUTE AS 'dbo'

AS
Begin
Begin
create table #TraderNames
(
ContactID int,
DealHeaderID int,
Negotiator varchar(128)
)
insert #TraderNames
(
ContactID,
DealHeaderID,
Negotiator
)
select 
c.CntctID,
dh.DlHdrID,
Concat(c.CntctLstNme,', ',c.CntctFrstNme)
from Contact C
join Users u on u.UserCntctID = c.CntctID
join DealHeader dh 
on dh.DlHdrIntrnlUserID = u.UserID
End
Begin
create table #StagedCriticalValues
(
PlnndTrnsfrID int not null,
LastChanged smalldatetime not null,
PlnndTrnsfrActlQty float not null,
Quantity float not null
)
End
Begin
insert #StagedCriticalValues (
PlnndTrnsfrID,
LastChanged,
PlnndTrnsfrActlQty,
Quantity
)
select PlnndTrnsfrID, LastChanged, PlnndTrnsfrActlQty, Quantity from MTVTransferToDataLakeStaging
End

Begin
Insert MTVTransferToDataLakeStaging
(
PlnndTrnsfrID,
SchdlngOblgtnID,
EstimatedMovementDate, 
PlnndTrnsfrActlQty,
Quantity,
Negotiator, 
PipelineCycleID,
PipelineCycleName,
LastChanged
)
select distinct pt.PlnndTrnsfrID,pt.SchdlngOblgtnID,pt.EstimatedMovementDate,pt.PlnndTrnsfrActlQty,so.Quantity ,tn.Negotiator, pt.PipelineCycleID, 
(select CONCAT (p.PipelineName,' ',p.CycleName) from PipelineCycle p where p.PipelineCycleID = pt.PipelineCycleID), pt.ChangeDate
from PlannedTransfer pt
join SchedulingObligation so on pt.SchdlngOblgtnID = so.SchdlngOblgtnID
join #TraderNames tn on tn.DealHeaderID = pt.PlnndTrnsfrObDlDtlDlHdrID
where pt.PlnndTrnsfrID not in
(Select m.PlnndTrnsfrID from #StagedCriticalValues m where m.LastChanged = pt.ChangeDate)
order by pt.PlnndTrnsfrID
End
Begin
Select
PlnndTrnsfrID,
SchdlngOblgtnID,
EstimatedMovementDate, 
PlnndTrnsfrActlQty,
Quantity,
Negotiator, 
PipelineCycleName
From
MTVTransferToDataLakeStaging where Sent is null or Sent = 0
End

End