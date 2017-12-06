/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTV_searchSMTWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSMTWithReportState.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSMTWithReportState]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_searchSMTWithReportState] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_searchSMTWithReportState >>>'
	  END
GO


--execute dbo.sp_MTV_searchSMTWithReportState;1 @isnavigation = 'N',@movementheaderstatus = NULL,@fromdate='7-18-2015 0:0:0.000',@todate='7-18-2016 23:59:0.000',@product_multi = '0', @chemicalid_multi = '0',@movementlocation_multi = NULL,@moveposgroup_multi = NULL, @destinationposgroup_multi = NULL, @contractnumber = NULL, @contractnumber_clause = 'contains', @documentname = NULL, @documentname_clause = 'contains', @internalba_multi = NULL, @snapshotinstancedatetime = NULL,@schedulingperiodid=null, @c_showsqlonly = 'y'
--execute dbo.sp_MTV_searchSMTWithReportState;1 @isnavigation = 'N',@movementheaderstatus = NULL,@fromdate='7-18-2015 0:0:0.000',@todate='7-18-2016 23:59:0.000',@product_multi = '0', @chemicalid_multi = '0',@movementlocation_multi = NULL,@moveposgroup_multi = NULL, @destinationposgroup_multi = NULL, @contractnumber = NULL, @contractnumber_clause = 'contains', @documentname = NULL, @documentname_clause = 'contains', @internalba_multi = NULL, @snapshotinstancedatetime = NULL,@schedulingperiodid=null
--execute dbo.sp_MTV_searchSMTWithReportState;1 @isnavigation = 'N',@movementheaderstatus = NULL,@fromdate='7-18-2015 0:0:0.000',@todate='7-25-2016 23:59:0.000',@product_multi = NULL, @chemicalid_multi = NULL,@movementlocation_multi = NULL,@moveposgroup_multi = '29383', @destinationposgroup_multi = NULL, @contractnumber = NULL, @contractnumber_clause = 'contains', @documentname = NULL, @documentname_clause = 'contains', @internalba_multi = NULL, @schedulingperiodid = NULL,@snapshotinstancedatetime = NULL, @c_showsqlonly = 'y'
--execute dbo.sp_MTV_searchSMTWithReportState;1 @isnavigation = 'N',@movementheaderstatus = NULL,@fromdate='7-18-2015 0:0:0.000',@todate='7-25-2016 23:59:0.000',@product_multi = NULL, @chemicalid_multi = NULL,@movementlocation_multi = NULL,@moveposgroup_multi = '29383', @destinationposgroup_multi = NULL, @contractnumber = NULL, @contractnumber_clause = 'contains', @documentname = NULL, @documentname_clause = 'contains', @internalba_multi = NULL, @schedulingperiodid = NULL,@snapshotinstancedatetime = NULL, @c_showsqlonly = 'n'
 alter procedure dbo.sp_MTV_searchSMTWithReportState
(@isNavigation char(1) = 'N',@MovementHeaderStatus VarChar (100)=null,@FromDate DateTime = null,@ToDate DateTime = null,@Product_Multi varchar(1000) = null,@ChemicalID_Multi varchar(1000)=null
,@MovementLocation_Multi varchar(1000) = null
,@MovePosGroup_multi varchar(1000)=null,@DestinationPosGroup_multi varchar(1000)=null
,@ContractNumber VarChar (8000)=null,@ContractNumber_clause varchar(1000)=null
,@DocumentName VarChar (8000) = null,@DocumentName_Clause varchar(1000) = null
,@InternalBA_multi varchar(1000)=null
, @schedulingperiodid int = null 
,@SnapshotInstanceDateTime SmallDateTime=null
 ,@i_RprtCnfgID	Int		= Null
 ,@vc_AdditionalColumns		 VarChar(8000)	= Null
 ,@c_showsqlonly char(1) = 'N')
AS

set nocount on

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



   if ' + '''' + @MovementLocation_multi + '''' + ' is not null
      Select	distinct [Items].[LcleID] into #StateLocaleIds
                                              From	[P_PositionGroup] (NoLock)
	                                                Left Join [P_PositionGroupFlat] [Parent] (NoLock) On [P_PositionGroup].[P_PstnGrpID] = [Parent].[PrntP_PstnGrpID]
                                                                                                     And	[P_PositionGroup].[P_PstnGrpTmplteID] In (6	,8)
                                                 	Join [P_PositionGroupChemicalLocale] [Items] (NoLock) On [Items].[P_PstnGrpID] In (P_PositionGroup.P_PstnGrpID, Parent.PrntP_PstnGrpID, Parent.ChldP_PstnGrpID)
                                             Where	[P_PositionGroup].[P_PstnGrpID] in ( ' + convert(varchar,@MovementLocation_Multi ) + ' )


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

  
   if @MovementLocation_multi is not null
      Select	distinct [Items].[LcleID] into #StateLocaleIds
                                              From	[P_PositionGroup] (NoLock)
	                                                Left Join [P_PositionGroupFlat] [Parent] (NoLock) On [P_PositionGroup].[P_PstnGrpID] = [Parent].[PrntP_PstnGrpID]
                                                                                                     And	[P_PositionGroup].[P_PstnGrpTmplteID] In (6	,8)
                                                 	Join [P_PositionGroupChemicalLocale] [Items] (NoLock) On [Items].[P_PstnGrpID] In (P_PositionGroup.P_PstnGrpID, Parent.PrntP_PstnGrpID, Parent.ChldP_PstnGrpID)
                                             Where	[P_PositionGroup].[P_PstnGrpID] in ( @MovementLocation_Multi ) 



end




if @c_showsqlonly = 'N' or @c_showsqlonly = ''
	Execute (@vc_DynamicSQL_Pre )
else
	Select @vc_DynamicSQL_Pre


select @vc_DynamicSql_Select = '
Select	[TransactionHeader].[XHdrID] XHDRID
	,[TransactionHeader].[xhdrchldxhdrid] ChildID
	,[TransactionHeader].[XHdrTyp] Type
	,[TransactionHeader].[XHdrStat] Status
	,[PlannedTransfer].[PlnndTrnsfrPlnndStPlnndMvtID] OrderID
	,[DealHeader].[DlHdrIntrnlNbr] DealNumber
	,[DealHeader].[DlHdrTyp] DealType
	,[DealHeader].[DlHdrId] DealHeaderID
	,[PlannedTransfer].[PlnndTrnsfrObDlDtlID] DealDetailID
	,[TransactionHeader].[MovementDate] MovementDate
	,[MovementDocument].[MvtDcmntExtrnlDcmntNbr] BillOfLading
	,[MovementHeader].[LineNumber] LineNumber
	,[MovementHeader].[MvtHdrLcleID] MovementLocation
	,[OriginState].[StateLcleId]  OriginState
	,[TransactionHeader].[XHdrMvtDtlChmclParPrdctID] Product
	,[GeneralConfiguration].[GnrlCnfgMulti] FTAProduct
	,[CommoditySubGroup].[Name] TaxCommodity
	,[MovementHeader].[MvtHdrDstntnLcleID] TaxDestination
	,[DestState].[StateLcleId] DestinationState
	,[MovementHeader].[MvtHdrTyp] MovementType
	,case when (TransactionHeader.XHdrTyp = ''D'') then (TransactionHeader.XHdrQty * -1) Else TransactionHeader.XHdrQty End NetSignedQuantity
    ,0.00 SignedQuantity_Display
	,[TransactionHeader].[XHdrTxChckd] TaxChecked
	,[TransactionHeader].[XHdrQty] NetQuantity
	, 0.0 NetQuantity_Display
	,[TransactionHeader].[XHdrGrssQty] GrossQuantity
	, 0.0 GrossQuantity_Display
	,[TransactionHeader].[XHdrDte] CreationDate
	,[MovementDocument].[MvtDcmntIntrnlDcmntNbr] InternalDocumentNumber
	,[PlannedTransfer].[SchdlngPrdID] SchedPrd
	,''''   RowFocusIndicator
	,''''   SelectRowIndicator
	,''Y''   ExpAnded
	,Convert(Int, Null) SortColumn
	'
	

if @isNavigation = 'Y'
select @vc_DynamicSql_From = '	
   From #TransactionHeader
         inner join TransactionHeader on TransactionHeader.XhdrID = #TransactionHeader.ID
         '
else
select @vc_DynamicSql_From = '	
From	[TransactionHeader] (NoLock)
'
select @vc_DynamicSql_From = @vc_DynamicSql_From + '
	Join [MovementDocumentArchive] (NoLock) On
		[TransactionHeader].MvtDcmntArchveID = [MovementDocumentArchive].MvtDcmntArchveID
	Join [MovementDocument] (NoLock) On
			[TransactionHeader].[XHdrMvtDcmntID] = [MovementDocument].[MvtDcmntID]
	Join [PlannedTransfer] (NoLock) On
			[TransactionHeader].[XHdrPlnndTrnsfrID] = [PlannedTransfer].[PlnndTrnsfrID]
	Join [DealHeader] (NoLock) On
			[PlannedTransfer].[PlnndTrnsfrObDlDtlDlHdrID] = [DealHeader].[DlHdrID]
	Join [MovementHeader] (NoLock) On
			[TransactionHeader].[XHdrMvtDtlMvtHdrID] = [MovementHeader].[MvtHdrID]
	Join [Product] (NoLock) On
			[TransactionHeader].[XHdrMvtDtlChmclParPrdctID] = [Product].[PrdctID]
	Left Join [CommoditySubGroup] (NoLock) On
			[Product].[TaxCmmdtySbGrpID] = [CommoditySubGroup].[CmmdtySbGrpID]
	Left Join [LeaseDealHeader] (NoLock) On
			[TransactionHeader].[LeaseDlHdrID] = [LeaseDealHeader].[DlHdrID]
	Left Join [GeneralConfiguration] (NoLock) On
		[transactionheader].XHdrMvtDtlChmclParPrdctID = GeneralConfiguration.GnrlCnfgHdrID AND GeneralConfiguration.GnrlCnfgQlfr = ''FTAProductCode'' 
		    AND GeneralConfiguration.GnrlCnfgTblNme = ''Product'' AND GeneralConfiguration.GnrlCnfgHdrID <> 0
	Left Join [#ParentLocs] [OriginState] (NoLock) On
		OriginState.ChildLcleID = IsNull(MovementHeader.MvtHdrOrgnLcleID,TransactionHeader.PlnndMvtOrgnLcleID)
	Left Join [#ParentLocs] [DestState] (NoLock) On
		DestState.ChildLcleID  = Isnull(MovementHeader. MvtHdrDstntnLcleID, TransactionHeader. DestinationLcleID)
'


select @vc_DynamicSql_Where = '
Where 1 = 1
'

if @isNavigation = 'N'
begin

select @vc_DynamicSql_Where = @vc_DynamicSql_Where + '
and [TransactionHeader].[MovementDate] between ' +'''' +  convert(varchar,@FromDate) + '''' + '
And ' + '''' + convert(varchar,@ToDate)  + ''''

if @MovePosGroup_multi is not null
   select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
   And	 Exists (Select	*
From	[P_PositionGroupChemicalLocaleFlat] (NoLock)
Where	
	[P_PositionGroupChemicalLocaleFlat].[P_PstnGrpID] in (' + @MovePosGroup_Multi + ')
And	[P_PositionGroupChemicalLocaleFlat].[LcleID] = [TransactionHeader].[MovementLcleID]
And	[P_PositionGroupChemicalLocaleFlat].[PrdctID] = [TransactionHeader].[XHdrMvtDtlChmclParPrdctID]
	)'	
	
	
if @DestinationPosGroup_multi is not null
    select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '
    And	 Exists (Select	*
From	[P_PositionGroupChemicalLocaleFlat] (NoLock)
Where	
	[P_PositionGroupChemicalLocaleFlat].[P_PstnGrpID] in (' + @DestinationPosGroup_Multi + ')
And	[P_PositionGroupChemicalLocaleFlat].[LcleID] = [TransactionHeader].[DestinationLcleID]
And	[P_PositionGroupChemicalLocaleFlat].[PrdctID] = [TransactionHeader].[XHdrMvtDtlChmclParPrdctID]
	)'
		
 if @InternalBA_multi is not null  
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [DealHeader].[DlHdrIntrnlBaid] in (' +  @InternalBA_multi + ')'
   
if @MovementHeaderStatus is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
and [TransactionHeader].[xhdrstat] = ' + '''' + @MovementHeaderStatus + ''''

if @product_multi is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
and [TransactionHeader].[XHdrMvtDtlChmclParPrdctID] in ( ' + @product_multi + ')'
   
if @ChemicalID_Multi is not null
      Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
and [TransactionHeader].[XHdrMvtDtlChmclChdPrdctID] in (' + @ChemicalID_Multi + ')'
   
if @ContractNumber is not null
   Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [DealHeader].DlHdrIntrnlNbr ' + case  @ContractNumber_Clause  when 'contains' then 'like ' + '''' + '%' 
                                                                    when 'is equal to' then ' = '  + ''''
                                                                    when 'begins with' then 'like ' + '''' 
                                                                    when 'ends with' then 'like ' + '''' + '%' 
                                                                    else ' = ' + '''' end
                                     + @ContractNumber + 
                                     case  @ContractNumber_Clause    when 'contains' then '%'  + ''''
                                                                    when 'is equal to' then ''''  
                                                                    when 'begins with' then '%' + ''''
                                                                    when 'ends with' then  '''' 
                                                                    else '''' end

if @DocumentName is not null
   Select @vc_DynamicSQL_Where =  @vc_DynamicSQL_Where + '
   And [MovementDocument].MvtDcmntExtrnlDcmntNbr ' + case  @DocumentName_Clause  when 'contains' then 'like ' + '''' + '%' 
                                                                    when 'is equal to' then ' = '  + ''''
                                                                    when 'begins with' then 'like ' + ''''
                                                                    when 'ends with' then 'like ' + '''' + '%'
                                                                    else ' = ' + '''' end
                                     + @DocumentName + 
                                     case  @DocumentName_Clause    when 'contains' then '%'  + ''''
                                                                    when 'is equal to' then ''''  
                                                                    when 'begins with' then '%' + ''''
                                                                    when 'ends with' then  '''' 
                                                                    else '''' end



   if @MovementLocation_multi is not null
      Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '                 
   And	(
           isnull([MovementHeader].[MvtHdrLcleID],0) In (Select #StateLocaleIds.LcleID From #StateLocaleIds)
      OR                                         
           isnull([MovementHeader].[MvtHdrOrgnLcleID],0) In (Select #StateLocaleIds.LcleID From #StateLocaleIds)
                                             
     OR
           isnull([MovementHeader].[MvtHdrDstntnLcleID],0) In (Select #StateLocaleIds.LcleID From #StateLocaleIds)
         )
'

if @schedulingperiodid is not null
      Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + '                 
       and PlannedTransfer.SchdlngPrdID = ' + convert(varchar, @schedulingperiodid)
end

If @Product_Multi  Is Not Null  
  Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + 'And TransactionHeader. XHdrMvtDtlChmclParPrdctID in ( ' + @Product_Multi  + ') 
  '  
  
 If @ChemicalID_Multi  Is Not Null  
  Select @vc_DynamicSQL_Where = @vc_DynamicSQL_Where + 'And TransactionHeader. XHdrMvtDtlChmclChdPrdctID in (' + @ChemicalID_Multi  + ')
   '  


if @vc_AdditionalColumns is not null 
   Execute sp_Add_Additional_Columns 	
            @i_RprtCnfgID,
	    	@vc_AdditionalColumns,
		    'Y',
		    @vc_DynamicSQL_Select	Out,
		    @vc_DynamicSQL_From	    Out,
		    @vc_DynamicSQL_Where	Out
		    
		    

if @c_showsqlonly = 'N' or @c_showsqlonly = ''
	Execute (@vc_DynamicSQL_Select + @vc_DynamicSQL_From + @vc_DynamicSQL_Where )
else
	Select @vc_DynamicSQL_Select , @vc_DynamicSQL_From , @vc_DynamicSQL_Where 



GO