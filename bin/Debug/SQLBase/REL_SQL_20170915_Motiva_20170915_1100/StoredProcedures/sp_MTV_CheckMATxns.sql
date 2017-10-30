IF  OBJECT_ID(N'[dbo].[MTV_CheckMATxns]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[MTV_CheckMATxns](@In smalldatetime) AS SELECT 1'
			PRINT '<<< CREATED Procedure MTV_CheckMATxns >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[MTV_CheckMATxns]    Script Date: 6/2/2016 8:20:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER  Procedure [dbo].[MTV_CheckMATxns] @transactionsFromDate smalldatetime
as

select * into #tempTH from TransactionHeader where XHdrDte > @transactionsFromDate

PRINT 'Movement Transactions created after ' + CONVERT(VARCHAR(50), @transactionsFromDate)
select count(*) as NumberofMovementTransactionsAfterTransactionDate from #tempTH

select count(*) as NumberofUpdatedMovementTransactionIdsAfterTransactionDate from MovementDocument
	Left Join [TransactionHeader] (NoLock) On
			MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	Left Outer Join #tempTH (NoLock) On
			#tempTH.XHdrID = TransactionHeader.XHdrID
			where MovementDocument.ChangeDate > @transactionsFromDate
			and TransactionHeader.XHdrID is not null
			and #tempTH.XHdrID is null

PRINT 'Transaction Header status updates that does not exist in Movement Transactions after ' + CONVERT(VARCHAR(50), @transactionsFromDate)
select TransactionHeader.XHdrId from MovementDocument
	Left Join [TransactionHeader] (NoLock) On
			MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	Left Outer Join #tempTH (NoLock) On
			#tempTH.XHdrID = TransactionHeader.XHdrID
			where MovementDocument.ChangeDate > @transactionsFromDate
			and TransactionHeader.XHdrID is not null
			and #tempTH.XHdrID is null
			
-- Accounting 
select * into #tempAD from AccountDetail where CreatedDate > @transactionsFromDate

PRINT 'Account Details created after ' + CONVERT(VARCHAR(50), @transactionsFromDate)
select count(*) as NumberofAccountingTransactionsAfterTransactionDate from #tempAD

PRINT 'Sales Invoice updates after ' + CONVERT(VARCHAR(50), @transactionsFromDate)
select count(*) as NumberofUpdatedAccountingDetailIdsAfterTransactionDate from CustomMessageQueue
Left Join AccountDetail (NoLock) On
			CustomMessageQueue.EntityID = case when (CustomMessageQueue.Entity = 'SH') then AccountDetail.AcctDtlSlsInvceHdrID
												else AccountDetail.AcctDtlPrchseInvceHdrID end
Left Outer Join #tempAD (NoLock) On
			#tempAD.AcctDtlID = AccountDetail.AcctDtlID
			where CustomMessageQueue.CreationDate > @transactionsFromDate
			and #tempAD.AcctDtlID is null
			and AccountDetail.AcctDtlID is not null

PRINT 'Account Details with updates that does not exist in Account Details after ' + CONVERT(VARCHAR(50), @transactionsFromDate)
select AccountDetail.AcctDtlID from CustomMessageQueue
	Left Join AccountDetail (NoLock) On
			CustomMessageQueue.EntityID = case when (CustomMessageQueue.Entity = 'SH') then AccountDetail.AcctDtlSlsInvceHdrID
											   else AccountDetail.AcctDtlPrchseInvceHdrID end
	Left Outer Join #tempAD (NoLock) On
			AccountDetail.AcctDtlID = #tempAD.AcctDtlID 
			where CustomMessageQueue.CreationDate > @transactionsFromDate
			and #tempAD.AcctDtlID is null
			and AccountDetail.AcctDtlID is not null
						
If	Object_ID('TempDB..#tempAD') Is Not Null
BEGIN
	Drop Table #tempAD
	PRINT 'Dropped Temp Table #tempAD'
END
