set quoted_identifier off 
go
set ansi_nulls on
go

if object_id('dbo.MTV_InvoicePrevalidation') is not null
	begin
		drop proc dbo.MTV_InvoicePrevalidation
		print '~~~ Dropped procedure MTV_InvoicePrevalidation ~~~'
	end
go

create procedure [dbo].[MTV_InvoicePrevalidation]
(	
	@pvc_RunMthd		varchar(20)
	,@pi_TaxLmt			int				= 0
	,@pi_SatLmt			int				= 0
	,@pi_MovXtrLmt		int				= 0
	,@pi_InvDbgLmt		int				= 0
	,@pc_UseCrntPrd		char(1)			= 'Y'
	,@pdt_DteFrm		smalldatetime	= '01/01/2017'
	,@pdt_DteTo			smalldatetime	= '01/01/2017'
	,@pi_IntrnlBAID		int				= 22
	,@pc_Debug			char(1)			= 'N'
)

/*
Author:		Chris Nettles
Created:	09/08/2017
Purpose:	Procedure is used to determine if the counts from 3 or 4 different reports have breached a specific
			threshold.  If they breach the threshholds the procedure will cause the remaining items in the process
			group to fail
Debug:		exec [MTV_InvoicePrevalidation] 'InvoicePrint', 0,0,0,0, 'Y', '9/1/2017', '9/30/2017', 22, 'Y'	--Debugger report
			exec [MTV_InvoicePrevalidation] 'InvoiceQueue', 0,0,0,0, 'Y', '9/1/2017', '9/30/2017', 22, 'Y'	--Transaction reports
Params:		@pvc_RunMthd:	Should be either 'InvoiceQueue' or 'InvoicePrint'
			@pi_TaxLmt:		Threshold set for results of the Search Tax Transactions Report
			@pi_SatLmt:		Threshold set for results of the Search Accounting Transactions Report
			@pi_MovXtrLmt:	Threshold set for results of the Search Movement Transactions Report
			@pi_InvDbgLmt:	Threshold set for results of the Invoice Debugger nested report
			@pc_UseCrntPrd:	If 'Y' will go back 24 hours from run time.  If 'N', dates below will be used instead.
			@pdt_DteFrm:	From date to use for determining threshold. (converts to start of day specified)
			@pdt_DteTo:		To date to use for determining thresholds. (converts to end of day specified) 
			@pi_IntrnlBAID: Internal BAID to run validation for.  If zero we run it for all BAs
			@pc_Debug:		Use this to turn on various debug messages for troubleshooting.

Date Modified			Modified By			Issue			Modification
-----------------------------------------------------------------------------
*/

as 

begin
	set nocount on
	
	declare @sql_select varchar(2000), @sql_where varchar(2000)
	declare @i_taxCount int, @i_SatCount int, @i_MovXtrCount int, @i_InvDbgCount int
	declare @bit_dateFlag bit	= 0	-- 0 for accnt period, 1 for from and to date
	declare @dt_PeriodFrom smalldatetime, @dt_PeriodTo smalldatetime, @i_PeriodID int = 0
	declare @sql_Counts table (Results int)

	begin try
		if @pc_Debug = 'Y' select 'Params Prevalidation', @pvc_RunMthd, @pc_UseCrntPrd, @pdt_DteFrm, @pdt_DteTo, @pi_TaxLmt, @pi_SatLmt, @pi_MovXtrLmt, @pi_InvDbgLmt

		--------------------------------------------------
		--Verify input params
		--------------------------------------------------
		if(@pvc_RunMthd <> 'InvoiceQueue' and @pvc_RunMthd <> 'InvoicePrint')
			raiserror ('Run method should be either ''InvoiceQueue'' or ''InvoicePrint''. Please fix parameters. ', 16,1)

		if(@pc_UseCrntPrd = 'N')
			set @bit_dateFlag = 1
		else
			begin
				
				set	@dt_PeriodFrom = dateadd(d, -1, getdate())
				set	@dt_PeriodTo = getdate()
				--Leave in as it may be useful at some point in future if we need to look at the current accounting period
				--set		@i_PeriodID		=	(select Min(AccountingPeriod. AccntngPrdID)
				--							From	AccountingPeriod
				--							where AccountingPeriod. AccntngPrdCmplte 	= 'N')
				--select	@dt_PeriodFrom	=	AccountingPeriod.AccntngPrdBgnDte
				--			,@dt_PeriodTo	=	AccountingPeriod.AccntngPrdEndDte
				--from	AccountingPeriod
				--where	AccntngPrdID	=	@i_PeriodID	
			end

		if (@bit_dateFlag = 1)
			begin
				set @pdt_DteFrm	= (DATEADD(d,DATEDIFF(d,0,@pdt_DteFrm),0))
				set @pdt_DteTo	= (DATEADD(d,DATEDIFF(d,0,@pdt_DteTo),0) + '23:59:59')
				
				if (@pdt_DteFrm > @pdt_DteTo)
					raiserror ( 'From date cannot be before to date.  Please fix parameters.', 16,1)
			end 

		if(@pi_TaxLmt < 0 or @pi_SatLmt < 0 or @pi_MovXtrLmt < 0 or @pi_InvDbgLmt < 0) 	
			raiserror ( 'All limits must be a positive number. Please fix parameters.', 16,1)

		if @pc_Debug = 'Y' select 'Params Post-validation', @pvc_RunMthd, @pc_UseCrntPrd, @pdt_DteFrm, @pdt_DteTo, @pi_TaxLmt, @pi_SatLmt, @pi_MovXtrLmt, @pi_InvDbgLmt, @dt_PeriodFrom, @dt_PeriodTo
		
		--------------------------------------------------
		--Get report threshold amounts
		--------------------------------------------------
		if	(@pvc_RunMthd = 'InvoiceQueue')
			begin
				--Search Tax Transactions
				select		@sql_select =	'
					select Count(*)
					from	TaxDetail with (nolock)
					Left Outer Join TaxDetailLog (NoLock)   
						On	TaxDetailLog. TxDtlLgTxDtlID = TaxDetail. TxDtlID
					Left Outer Join AccountDetail (nolock)  
						On 	(AccountDetail. AcctDtlSrceID = TaxDetailLog. TxDtlLgID
						 And AccountDetail. AcctDtlSrceTble = ''T'')
					Where 	TaxDetail. TxDtlSrceTble in (''A'', ''X'', ''T'') 
						and	TaxDetail. TxDtlStts = ''I''
											'
				if (@pi_IntrnlBAID <> 0)
					select	@sql_where =	'
					and	AccountDetail. InternalBAID =	''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + ' 
					and		TaxDetail. TransactionDate >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		TaxDetail. TransactionDate <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	@sql_where + '
					and		TaxDetail. TransactionDate >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		TaxDetail. TransactionDate <= ''' + convert(varchar(25),@dt_PeriodTo)   + '''				
											'

				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_taxCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_taxCount 'Count' ,  @sql_select + @sql_where 'Query'


				--Search Accounting Transactions
				select		@sql_select =	'
					select Count(*)
					from	AccountDetail with (NoLock)
					left join	DealHeader with (NoLock)
						On	AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
					inner join	AccountingPeriod with (NoLock) 
						On	AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
					Where	(AccountDetail.PayableMatchingStatus  not like ''%D%'')
						and DealHeader.DlHdrTyp			= 2
						and AccountDetail.AcctDtlSlsInvceHdrID is null 
						and Exists (select 1 
									from [TransactionTypeGroup] T1
										left Join [TransactionGroup] T2 on T1.XTpeGrpXGrpID = T2.XGrpID
									where (AccountDetail.AcctDtlTrnsctnTypID = T1.XTpeGrpTrnsctnTypID
										and T2.[XGrpQlfr] like ''Invoicing%''))
						and	AccountDetail.acctdtltxstts = ''N''
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		AccountDetail.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + '
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	@sql_where + '
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <=  ''' + convert(varchar(25),@dt_PeriodTo) + '''				
											'

				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_SatCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_SatCount 'Count' ,  @sql_select + @sql_where 'Query'

				--Search Movement Transaction
				select		@sql_select =	'
					select Count(*)
					from	TransactionHeader with (NoLock)
					Inner Join PlannedTransfer (NoLock) 
						On 	TransactionHeader.XHdrplnndTrnsfrID =PlannedTransfer.PlnndTrnsfrID 
					inner join SchedulingObligation so (NOLOCK) 
						On PlannedTransfer.SchdlngOblgtnID = so.SchdlngOblgtnID
					Where	TransactionHeader.XHdrTxChckd	= ''N''
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		so.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	@sql_where + '
					and		TransactionHeader.MovementDate >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		TransactionHeader.MovementDate <  ''' + convert(varchar(25),@pdt_DteTo)	+ '''				
											'
				else
					select	@sql_where	= @sql_where +	'
					and		TransactionHeader.MovementDate >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		TransactionHeader.MovementDate <= ''' + convert(varchar(25),@dt_PeriodTo)	+ '''
											'
		
				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_MovXtrCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_MovXtrCount 'Count' ,  @sql_select + @sql_where 'Query'

				--Verify if limits have been reached and create error message  
				declare @vc_errorMessage varchar(500) = ''

				if	( @i_taxCount > @pi_TaxLmt )
					set @vc_errorMessage =   'Search Tax Transaction (' + convert(varchar(25),@i_taxCount) + '), '
				if	(@i_SatCount > @pi_SatLmt )
					set @vc_errorMessage =   @vc_errorMessage + 'Search Accounting Transaction (' + convert(varchar(25),@i_SatCount) + '), '  
				if  ( @i_MovXtrCount > @pi_MovXtrLmt )
					set @vc_errorMessage =   @vc_errorMessage + 'Search Movement Transaction (' + convert(varchar(25),@i_MovXtrCount) + '), ' 
				if ( len(@vc_errorMessage) > 1)
					begin
						set @vc_errorMessage =   @vc_errorMessage + 'reports have breached specified limits'
						raiserror (@vc_errorMessage, 16,1)
					end
			end
		else
			begin
				create table #tempResults	(AcctDtlID int)
				create table #debugResults	(ErrorNumber int, ErrorID int, ErrorMessage varchar(255), Errorcount int, Adid int)

				--Invoice Debugger 
				select		@sql_select =	'
					select	Count(*)
					from	AccountDetail with (NoLock)
					left join	DealHeader with (NoLock)
						On	AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
					inner join	AccountingPeriod with (NoLock) 
						On	AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
					Where	(AccountDetail.PayableMatchingStatus  not like ''%D%'')
						and DealHeader.DlHdrTyp			= 2
						and AccountDetail.AcctDtlSlsInvceHdrID is null 
						and Exists (select 1 
									from [TransactionTypeGroup] T1
										left Join [TransactionGroup] T2 on T1.XTpeGrpXGrpID = T2.XGrpID
									where (AccountDetail.AcctDtlTrnsctnTypID = T1.XTpeGrpTrnsctnTypID
										and T2.[XGrpQlfr] like ''Invoicing%''))
											'

				if (@pi_IntrnlBAID <> '0')
					select	@sql_where =	'
					and		AccountDetail.InternalBAID = ''' + convert(varchar(25),@pi_IntrnlBAID) + '''
											'

				if (@bit_dateFlag = 1)
					select	@sql_where	=	'
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@pdt_DteFrm) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <  ''' + convert(varchar(25),@pdt_DteTo) + '''				
											'
				else
					select	@sql_where	=	'
					and		AccountDetail.AcctDtlTrnsctnDte >= ''' + convert(varchar(25),@dt_PeriodFrom) + '''
					and		AccountDetail.AcctDtlTrnsctnDte <=  ''' + convert(varchar(25),@dt_PeriodTo) + '''				
											'
				insert @sql_Counts exec (@sql_select + @sql_where)
				select @i_InvDbgCount = (select Results from @sql_Counts)
				delete from @sql_Counts

				if (@pc_Debug = 'Y')	select @i_InvDbgCount 'Count' ,  @sql_select + @sql_where 'Query'

				if	( @i_InvDbgCount > @pi_InvDbgLmt )
					begin
						set @vc_errorMessage =   'Search Invoice Debugger (' + convert(varchar(25),@i_InvDbgCount) + ') report has breached specified limit'
						raiserror (@vc_errorMessage, 16,1)
					end
				
				/*Commented this out as we don't really care about the invoice debugger counts.
				--if (@pc_Debug = 'Y')	select 'Invoice Debugger Query' ,  @sql_select + @sql_where 'Query'
				--insert #tempResults exec (@sql_select + @sql_where)
				if exists	
				(
					select	count(*)
					from	#tempResults
				)
				begin 
					declare @i_maxID int	= 0
					declare @i_total int	= 0

					--Loop through each of the accounting records and run it against invoice debugger logic
					while(1=1)
					begin
						select top 1 @i_maxID = AcctDtlID from #tempResults where AcctDtlID > @i_maxID order by AcctDtlID

						if	@@ROWCOUNT = 0
							break;

						insert #debugResults exec SP_RAIV_Invoice_Debugger 'N', @i_maxID
						set @i_total = @@ROWCOUNT + @i_total

						if (@i_total > @pi_InvDbgLmt)
						begin
							raiserror (	'Invoice Debugger count has breached limit specified', 16,1)
							break
						end

					end
					
					--clean up and exit.
					drop table #tempResults
					drop table #debugResults

				end
				*/

			end
	end try

begin catch
	begin 
		if OBJECT_ID('tempdb..#tempResults') is not null drop table #tempResults 
		if OBJECT_ID('tempdb..#debugResults') is not null drop table #debugResults 

		declare @error nvarchar(255)
		select	@error = ERROR_MESSAGE()

		raiserror (@error, 16,1)
	end
end catch	

end



go


if object_id('dbo.MTV_InvoicePrevalidation') is not null
	begin
		grant execute on dbo.MTV_InvoicePrevalidation to sysuser, RightAngleAccess
		print '~~~ Successfully created procedure MTV_InvoicePrevalidation and granted permissions ~~~'
	end
else
	print '~~~ Failed created procedure MTV_InvoicePrevalidation and granted permissions ~~~'
	