
--Insert Base Oils Report Config
--vars
declare @i_Ky int,
@return_value int
--case
IF exists(select 1 from ReportConfig where ConsistentID = 'SalesOrderConfirmation-Motiva')

Begin
  print '<<UPDATECONFIG>>';
  update ReportConfig set ReportOptions = 'ViewSaving=Y||RowSelection=Y||ColumnResizing=Y||DynamicGrouping=Y||Formatting=Y||AggregationService=Y||DropDownCaching=Y||SortType=M||Filter=Y||UOM Conversion=N||Currency Conversion=X||ColumnSelection=Y||PivotTables=Y||CalendarService=N||DragDrop=N||IsLarge=N'
 where ConsistentID = 'SalesOrderConfirmation-Motiva'
End 
 ELSE
 BEGIN
 print '<<InsertConfig>>';
		EXEC	@return_value = [dbo].[sp_getkey]
				@vc_TbleNme = N'ReportConfig',
				@i_Ky = @i_Ky OUTPUT,
				@i_increment = 1,
				@c_resultset = N'N'
		
		insert into ReportConfig (
		RprtCnfgID
		,RprtCnfgNme
		,RprtCnfgDscrptn
		,RprtCnfgDtaObjct
		,RprtCnfgCrtraObjct
		,RprtCnfgShwCrtra
		,RprtCnfgAutoRtrve
		,RprtCnfgFldrID
		,RprtCnfgDsplyObjct
		,RprtCnfgRprtDtbseID
		,RprtCnfgTpe
		,RprtCnfgBlbObjctID
		,RprtCnfgCrtraTpe
		,RprtCnfgCrtraBlbObjctID
		,RprtDcmntTypID
		,ReportOptions
		,HelpID
		,Domain
		,DcmntTypID
		,ApprvlGrpID
		,TmplteRprtCnfgNstdID
		,IsTmplte
		,AdapterObject
		,ApplyRowLevelSecurity
		,AllowsReplication
		,AllowWebAccess
		,IsSupported
		,SbsystmID
		,Cancelable
		,ConsistentID)
		values (
		@i_Ky, 'BaseOilsSalesConfirmation',
		'BaseOilsSalesConfirmation',
		'd_mtv_sales_order_confirmation',
		'u_base_oil_criteria',
		'N',
		'N',
		6,
		'u_search',
		3,
		'R',
		NULL,
		'R',
		NULL,
		1,
		'ViewSaving=Y||RowSelection=Y||ColumnResizing=Y||DynamicGrouping=Y||Formatting=Y||AggregationService=Y||DropDownCaching=Y||SortType=M||Filter=Y||UOM Conversion=N||Currency Conversion=X||ColumnSelection=Y||PivotTables=Y||CalendarService=N||DragDrop=N||IsLarge=N'
		,NULL,NULL,20,NULL,NULL,'Y','u_dynamic_gui_report_adapter',	'N','N','N','N',NULL,	'R',	'SalesOrderConfirmation-Motiva');
END