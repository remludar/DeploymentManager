/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_ is already set
*****************************************************************************************************
*/
/****** Object:  StoredProcedure [dbo].[sp_MTV_searchSATWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSATWithReportState.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSATWithReportState]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_searchSATWithReportState] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_searchSATWithReportState >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-- execute dbo.sp_MTV_searchSATWithReportState;1 'N', @vc_InternalBAID = NULL,@i_ExternalBAID = 108,@vc_TransactionType = NULL,@i_TransactionGroup = NULL,@dt_FromDate = '7-1-2014 0:0:0.000',@dt_ToDate = '7-15-2016 23:59:0.000',@c_AccountCodeStatus = NULL,@vc_DealNumber = NULL,@vc_DealNumber_clause = NULL,@vc_AccountingPeriodID = NULL,@i_CommodityID = NULL,@vc_SubGroupID = NULL,@PositionGroup = NULL,@i_AccountDetailID = NULL,@SnapshotInstanceDateTime = NULL,@MovementLocation = NULL,@c_showsqlonly = 'Y' 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTV_searchSATWithReportState; 24     
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	debbie keeton
-- History:	purpose of this report is to duplicate a report in .net but must be used in RA for value tax right click functionality
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
alter procedure dbo.sp_MTV_searchSATWithReportState 
(@isNavigation char(1) = 'N',@vc_InternalBAID varchar(8000) = null,@i_ExternalBAID Int = null,@vc_TransactionType varchar(8000) = null,@i_TransactionGroup Int = null
 ,@dt_FromDate DateTime = null,@dt_ToDate DateTime  = null,@c_AccountCodeStatus Char(1) = null,@vc_DealNumber VarChar (8000) = null, @vc_DealNumber_clause varchar(8000) = null
 ,@vc_AccountingPeriodID varchar(8000) = null,@i_CommodityID Int = null,@vc_SubGroupID varchar(1000) = null,@PositionGroup int = null
 ,@i_AccountDetailID Int = null
 ,@SnapshotInstanceDateTime SmallDateTime = null,@MovementLocation varchar(1000)= null, @i_RprtCnfgID	Int		= Null
 ,@vc_AdditionalColumns		 VarChar(8000)	= Null
 ,@c_showsqlonly char(1) = 'N')
AS

Set NoCount ON

DECLARE @vc_DynamicSQL_Select varchar(8000)
DECLARE @vc_DynamicSQL_From varchar(8000)
DECLARE @vc_DynamicSQL_Where varchar(8000)
DECLARE @vc_DynamicSQL_Pre varchar(8000)
Declare @i_StateStructureID int = null

if ( isnull(@c_showsqlonly,'N') = 'Y' )
begin
   select @vc_dynamicSQL_pre = '
          DECLARE @i_statestructureid int  
		  '

    select @vc_DynamicSQL_Pre = @vc_dynamicSQL_pre + '

   Select @i_StateStructureID = (Select convert(int,GnrlCnfgMulti) 
					From	GeneralConfiguration 
					Where	GnrlCnfgQlfr = ''State Structure''
					And	GnrlCnfgTblNme = ''System'')

   select parentLoc.LcleID StateLcleId, childLoc.LcleID ChildLcleId
   Into #ParentLocs
   from P_PositionGroupFlat parent
        Inner Join P_PositionGroupChemicalLocale parentLoc	on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
        Inner Join P_PositionGroupChemicalLocaleFlat childLoc	on parent.ChldP_PstnGrpID = childLoc.PrntP_PstnGrpID
   Where parent.PrntP_PstnGrpID = @i_StateStructureID -- Root State Group
   and parent.ChldLevel = 1
   Union all
   select parentLoc.LcleID StateLcleId, parentLoc.LcleID ChildLcleId
   from P_PositionGroupFlat parent
   Inner Join P_PositionGroupChemicalLocale parentLoc on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
   Where parent.PrntP_PstnGrpID = ' + convert(varchar, isnull(@i_StateStructureID,0)) + ' 
   and parent.ChldLevel = 1
   
   
 if @MovementLocation is not null
    Select distinct [Items].[LcleID] into #statelocales
                                              From	[P_PositionGroup] (NoLock)
	                                                Left Join [P_PositionGroupFlat] [Parent] (NoLock) On [P_PositionGroup].[P_PstnGrpID] = [Parent].[PrntP_PstnGrpID]
                                                                                                     And	[P_PositionGroup].[P_PstnGrpTmplteID] In (6	,8)
                                                 	Join [P_PositionGroupChemicalLocale] [Items] (NoLock) On [Items].[P_PstnGrpID] In (P_PositionGroup.P_PstnGrpID, Parent.PrntP_PstnGrpID, Parent.ChldP_PstnGrpID)
                                             Where	[P_PositionGroup].[P_PstnGrpID] in ( ' + convert(varchar,@MovementLocation ) + ' )
                                             

'
end
else
begin



  Select @i_StateStructureID = (Select convert(int,GnrlCnfgMulti) 
					From	GeneralConfiguration 
					Where	GnrlCnfgQlfr = 'State Structure'
					And	GnrlCnfgTblNme = 'System')



   select parentLoc.LcleID StateLcleId, childLoc.LcleID ChildLcleId
   Into #ParentLocs
   from P_PositionGroupFlat parent
        Inner Join P_PositionGroupChemicalLocale parentLoc	on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
        Inner Join P_PositionGroupChemicalLocaleFlat childLoc	on parent.ChldP_PstnGrpID = childLoc.PrntP_PstnGrpID
   Where parent.PrntP_PstnGrpID = isnull(@i_StateStructureID, parent.PrntP_PstnGrpID) -- Root State Group
   and parent.ChldLevel = 1
   Union all
   select parentLoc.LcleID StateLcleId, parentLoc.LcleID ChildLcleId
   from P_PositionGroupFlat parent
   Inner Join P_PositionGroupChemicalLocale parentLoc on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
   Where parent.PrntP_PstnGrpID = isnull(@i_StateStructureID,parent.PrntP_PstnGrpID)
   and parent.ChldLevel = 1

if @MovementLocation is not null
    Select	distinct [Items].[LcleID] into #statelocales
                                              From	[P_PositionGroup] (NoLock)
	                                                Left Join [P_PositionGroupFlat] [Parent] (NoLock) On [P_PositionGroup].[P_PstnGrpID] = [Parent].[PrntP_PstnGrpID]
                                                                                                     And	[P_PositionGroup].[P_PstnGrpTmplteID] In (6	,8)
                                                 	Join [P_PositionGroupChemicalLocale] [Items] (NoLock) On [Items].[P_PstnGrpID] In (P_PositionGroup.P_PstnGrpID, Parent.PrntP_PstnGrpID, Parent.ChldP_PstnGrpID)
                                             Where	[P_PositionGroup].[P_PstnGrpID] in ( @MovementLocation ) 

  

end



if @c_showsqlonly = 'Y' 
	Select (@vc_DynamicSQL_Pre )



select @vc_DynamicSQL_Select = '
Select	[AccountDetail].[AcctDtlID] as ''Account Detail ID''
	,[AccountDetail].[ExternalBAID] as ''Their Company''
	,[AccountDetail].[SupplyDemand] as ''[Buy/Sell]''
	,[DealHeader].[DlHdrTyp] as ''Deal Type''
	,[DealHeader].[DlHdrIntrnlNbr] as ''Deal''
	,[SalesInvoiceHeader].[SlsInvceHdrNmbr] as ''Sales Invoice Number''
	,[PayableHeader].[InvoiceNumber] as ''Payable Invoice Number''
	,[AccountDetail].[AcctDtlTrnsctnDte] as ''Ticket Date''
	,[MovementDocument].[MvtDcmntExtrnlDcmntNbr] as ''Bill Of Lading''
	,[MovementHeader].[LineNumber] as ''Line #''
	,[AccountDetail].[AcctDtlLcleID] as ''Movement Location''
	,[AccountDetail].[ParentPrdctID] as ''Product''
	,[GeneralConfiguration].[GnrlCnfgMulti] as ''FTA Product''
	,[CommoditySubGroup].[Name] as ''Tax Commodity''
	,[AccountDetail].[AcctDtlTrnsctnTypID] as ''Transaction Type''
	,[MovementHeader].[MvtHdrTyp] as ''Movement Type''
	,[AccountDetail].[Volume] as ''Quantity''
	,0.00 Quantity_Display
	,case when ABS(AccountDetail.Volume)=ABS(AccountDetail.NetQuantity) then ''Net'' else ''Gross'' End  as ''NetGross''
	,Case When AccountDetail.Volume = 0.0 Then AccountDetail.Value Else Case When AccountDetail.Value / AccountDetail.Volume >= 0 
	      Then AccountDetail.Value / AccountDetail.Volume Else AccountDetail.Value / AccountDetail.Volume * -1 End  End as ''Per Unit Value''
	, 0.00 perunit_display
	,[AccountDetail].[Value] as ''Transaction Amount''
	, 0.00 value_display
	,[AccountDetail].[CreatedDate] as ''Created Date''
	,IsNull(MovementHeader.MvtHdrOrgnLcleID,AccountDetail.AcctDtlLcleID) as ''Tax Origin''
	,Isnull(AccountDetail. AcctDtlDestinationLcleID, AccountDetail. AcctDtlLcleID) as ''Tax Destination''
	,[MovLocState].[StateLcleId] as ''Title Transfer''
	,[Term].[TrmVrbge] as ''Billing Term''
	,[AccountDetail].[PayableMatchingStatus] as ''Discarded''
	,[SalesInvoiceHeader].[SlsInvceHdrPstdDte] as ''Distributed''
	,[OriginState].[StateLcleId] as ''Origin State''
	,[DestState].[StateLcleId] ''Destination State''
	,[AccountDetail].[NetQuantity] as ''Net Quantity''
	,0.0 NetQuantity_display
	,[AccountDetail].[GrossQuantity] as ''Gross Quantity''
	, 0.0 GrossQuantity_display
	,[AccountDetail].[AcctDtlAccntngPrdID] as ''Accounting Period''
	,[AccountDetail].[CrrncyID] as ''Currency''
	,0 Currency_Display
	,[TransactionHeader].[XHdrTxChckd] as ''Tax Checked''
	,[AccountDetail].[AcctDtlSrceTble] as ''Source Table''
	,[AccountDetail].[IsNetOut] as ''Is Net Out''
	,[AccountDetail].[InternalBAID] as ''Our Company''
	,Case When IsNull(Product.PrdctSbTyp, ''X'') IN (''C'', ''I'') Then null Else 3 End  as ''SourceUOMID''
	,Coalesce(TransactionHeader.XHdrSpcfcGrvty, MovementHeader.MvtHdrGrvty, DealDetailChemical.Gravity, Product.PrdctSpcfcGrvty) as ''XHdrSpcfcGrvty''
	,Coalesce(TransactionHeader.Energy, DealDetailChemical.Energy, Product.PrdctEnrgy) as ''Energy''
	,Coalesce(AccountDetailEstimatedDate.EstimatedDueDate, AccountingPeriod.AccntngPrdEndDte) as ''EstimatedPaymentDate''
	,[AccountDetailEstimatedDate].[EstimatedDueDate]
	,[AccountDetailEstimatedDate].[EstimatedDiscountDate]
	,[AccountDetailEstimatedDate].[EstimatedDiscountValue]
	,''''   RowFocusIndicator
	,''''   SelectRowIndicator
	,''Y''   ExpAnded
	,Convert(Int, Null) SortColumn
	'

if 	@isNavigation = 'Y'
select @vc_DynamicSQL_From = '	
from 	#AccountDetail 
		Inner Join dbo.AccountDetail (nolock) on AccountDetail.AcctDtlID = #AccountDetail.ID '
else
select @vc_DynamicSQL_From = '	
From	[AccountDetail] (NoLock) 
'

select @vc_DynamicSQL_From = @vc_DynamicSQL_From + '	
	Left Join [SalesInvoiceHeader] (NoLock) On
		[AccountDetail].AcctDtlSlsInvceHdrID = [SalesInvoiceHeader].SlsInvceHdrID
	Left Join [PayableHeader] (NoLock) On
		[AccountDetail].AcctDtlPrchseInvceHdrID = [PayableHeader].PybleHdrID
	Left Join [DealHeader] (NoLock) On
		[AccountDetail].AcctDtlDlDtlDlHdrID = [DealHeader].DlHdrID
	Left Join [MovementHeader] (NoLock) On
		[AccountDetail].AcctDtlMvtHdrID = [MovementHeader].MvtHdrID
	Left Join [TransactionDetailLog] (NoLock) On
		[AccountDetail].AcctDtlSrceID = [TransactionDetailLog].XDtlLgID And [AccountDetail].AcctDtlSrceTble = ''X''
	Left Join [Product] (NoLock) On
		IsNull([AccountDetail].ChildPrdctID, [AccountDetail].ParentPrdctID) = [Product].PrdctID
	Left Join [MovementDocument] (NoLock) On
		[MovementHeader].MvtHdrMvtDcmntID = [MovementDocument].MvtDcmntID
	Left Join [TransactionHeader] (NoLock) On
		[TransactionDetailLog].XDtlLgXDtlXHdrID = [TransactionHeader].XHdrID
	Left Join [#ParentLocs] [MovLocState] (NoLock) On
		MovLocState.ChildLcleID = IsNull(MovementHeader.MvtHdrLcleID,AccountDetail.AcctDtlLcleID)
	Left Join [#ParentLocs] [OriginState] (NoLock) On
		OriginState.ChildLcleID = IsNull(MovementHeader.MvtHdrOrgnLcleID,AccountDetail.AcctDtlLcleID)
	Left Join [#ParentLocs] [DestState] (NoLock) On
		DestState.ChildLcleID  = Isnull(MovementHeader. MvtHdrDstntnLcleID, AccountDetail. AcctDtlLcleID)
	Left Join [DealDetailChemical] (NoLock) On
		DealDetailChemical.DlDtlChmclDlDtlDlHdrID  = AccountDetail. AcctDtlDlDtlDlHdrID and DealDetailChemical.DlDtlChmclDlDtlID  = AccountDetail. AcctDtlDlDtlID and NullIf(DealDetailChemical.DlDtlChmclChmclChldPrdctID,AccountDetail. ChildPrdctID) is null
	Left Join [GeneralConfiguration] (NoLock) On
		ParentPrdctID = GeneralConfiguration.GnrlCnfgHdrID AND GeneralConfiguration.GnrlCnfgQlfr = ''FTAProductCode'' 
		           AND GeneralConfiguration.GnrlCnfgTblNme = ''Product'' AND GeneralConfiguration.GnrlCnfgHdrID <> 0 
	Left Join [CommoditySubGroup] (NoLock) On
			[Product].[TaxCmmdtySbGrpID] = [CommoditySubGroup].[CmmdtySbGrpID]
	Left Join [Term] (NoLock) On
			[SalesInvoiceHeader].[SlsInvceHdrTrmID] = [Term].[TrmID]
	Join [AccountingPeriod] (NoLock) On
		AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
	Left Join [AccountDetailEstimatedDate] (NoLock) On
		[AccountDetail].AcctDtlID = [AccountDetailEstimatedDate].AcctDtlID
		'
		

if isnull(@isNavigation,'N') = 'N'
begin
--if accountdetailid is passed in - then only use that in the where clause
if ( @i_AccountDetailID is not null ) 
begin
   select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
    Where  [AccountDetail].AcctDtlID = ' + convert(varchar, @i_AccountDetailID )
end
else
begin
   select @vc_DynamicSQL_Where = '
   where 1 = 1'
   
   if @dt_FromDate is not null
     select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   and  [AccountDetail].[AcctDtlTrnsctnDte] >=' + '''' + convert(varchar, @dt_FromDate) + ''''

   if @dt_ToDate is not null
     select  @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
   And	[AccountDetail].[AcctDtlTrnsctnDte] <= ' + '''' + convert(varchar,@dt_ToDate) + ''''



   if @vc_AccountingPeriodID is not null
      select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
   And [AccountDetail].[AcctDtlAccntngPrdID] in (' + @vc_AccountingPeriodID + ')'
	


   if @vc_InternalBAID is not null  
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [AccountDetail].[InternalBAID] in (' +  @vc_InternalBAID + ')'

   
   if @i_ExternalBAID is not null  
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [AccountDetail].[ExternalBAID] =' +  convert(varchar,@i_ExternalBaid)
   
   if @vc_TransactionType is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [AccountDetail].[AcctDtlTrnsctnTypID] in (' +  @vc_TransactionType + ')'

   if @vc_SubGroupID is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
      And CommoditySubGroup.CmmdtySbGrpID in (' + @vc_SubGroupID + ')'

   if @i_CommodityID is not null   
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [Product].[CmmdtyID] =' +  convert(varchar,@i_CommodityID)

   if @c_AccountCodeStatus is not null
      select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [AccountDetail].[AcctDtlAcctCdeStts] =' +  '''' + @c_AccountCodeStatus + ''''


   if @vc_DealNumber is not null
   Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [DealHeader].DlHdrIntrnlNbr ' + case  @vc_DealNumber_Clause  when 'contains' then 'like ' + '''' + '%' 
                                                                    when 'is equal to' then ' = '  + ''''
                                                                    when 'begins with' then 'like ' + ''''
                                                                    when 'ends with' then 'like ' + ''''
                                                                    else ' = ' + '''' end
                                     + @vc_DealNumber + 
                                     case  @vc_DealNumber_Clause    when 'contains' then '%'  + ''''
                                                                    when 'is equal to' then ''''  
                                                                    when 'begins with' then '%' + ''''
                                                                    when 'ends with' then '%' + '''' 
                                                                    else '''' end
   
   
   if @i_TransactionGroup is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '   
    And	 Exists (Select	1 [One]
                 From	[TransactionTypeGroup] (NoLock)
	                    Join [TransactionType] (NoLock) On [TransactionTypeGroup].XTpeGrpTrnsctnTypID = [TransactionType].TrnsctnTypID
                 Where	([TransactionTypeGroup].[XTpeGrpXgrpID] = ' + convert(varchar,@i_TransactionGroup) + '
                   And	AccountDetail.AcctDtlTrnsctnTypID = TransactionType.TrnsctnTypID)
                   )'
	
   if @PositionGroup is not null
      Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
      And Exists (Select	1 
                 From	[P_PositionGroupChemicalLocaleFlat] (NoLock)
                 Where	([P_PositionGroupChemicalLocaleFlat].[P_PstnGrpID] =  IsNull( ' + CASE WHEN @PositionGroup Is Null Then 'null' else convert(varchar,@PositionGroup) end + ',[P_PositionGroupChemicalLocaleFlat].[P_PstnGrpID] )
                   And	P_PositionGroupChemicalLocaleFlat.LcleID = AccountDetail.AcctDtlLcleID And P_PositionGroupChemicalLocaleFlat.PrdctID = AccountDetail.ParentPrdctID And Isnull(AccountDetail.ChildPrdctID, P_PositionGroupChemicalLocaleFlat.ChmclChdPrdctID) = P_PositionGroupChemicalLocaleFlat.ChmclChdPrdctID)                  
                 )'
                 
        	 

 if @MovementLocation is not null
      Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '                 
   And	(
           isnull([AccountDetail].[AcctDtlLcleID] ,0) In (select lcleid from #statelocales )
      OR        
	   isnull([MovementHeader].[MvtHdrOrgnLcleID],0) In (select lcleid from #statelocales)
                                             
     OR
           isnull([MovementHeader].[MvtHdrDstntnLcleID],0) In (select lcleid from #statelocales)
       )' 

end
end


if @vc_AdditionalColumns is not null 
   Execute sp_Add_Additional_Columns 	
            @i_RprtCnfgID,
	    	@vc_AdditionalColumns,
		    'Y',
		    @vc_DynamicSQL_Select	Out,
		    @vc_DynamicSQL_From	    Out,
		    @vc_DynamicSQL_Where	Out
	        --	@vc_CriteriaTableToInclude = 'v_DealDetailHedge_BreakOut,v_DealDetailHedge_Info'


if @c_showsqlonly = 'N' or @c_showsqlonly = ''
	Execute (@vc_DynamicSQL_Select + @vc_DynamicSQL_From + @vc_DynamicSQL_Where )
else
	Select @vc_DynamicSQL_Select , @vc_DynamicSQL_From , @vc_DynamicSQL_Where 



GO
