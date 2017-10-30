if exists (select * from sysobjects where name = 'SCS_V_FuturesFillPrice')
       exec('drop view dbo.SCS_V_FuturesFillPrice')
Go

Create View dbo.SCS_V_FuturesFillPrice As
select
      DD.DlDtlDlHdrID [DlHdrID]
      ,DD.DlDtlID [DlDtlID]
      ,case IsNumeric(DDPR.PriceAttribute2)
            when 1 then IsNull(CONVERT(float,PriceAttribute2),0.00)
            else 0.00
      end [FillPrice]
From DealHeader DH
Inner Join DealDetail DD on (DD.DlDtlDlHdrID=DH.DlHdrID)
Inner Join DealDetailProvision DDP on (DDP.DlDtlPrvsnDlDtlDlHdrID=DD.DlDtlDlHdrID and DDP.DlDtlPrvsnDlDtlID=DD.DlDtlID and DDP.CostType='P')
Inner Join DealDetailProvisionRow DDPR on (DDPR.DlDtlPrvsnID=DDP.DlDtlPrvsnID and DDPR.DlDtlPRvsnRwTpe='A')
where DlHdrTyp = 70
GO

Grant select on SCS_V_FuturesFillPrice to RightAngleAccess
Go
