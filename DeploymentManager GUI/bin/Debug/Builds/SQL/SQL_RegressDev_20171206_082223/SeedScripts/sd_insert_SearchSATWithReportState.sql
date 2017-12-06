
Print 'Start Script=sd_insert_SearchSATWithReportState.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

if not exists ( select 'x' from ReportConfig where RprtCnfgNme = 'Custom Search SAT With Report State' )
 begin

 exec sp_InsertReport 	@vc_foldername	= 'Search Reports',	/* The folder must already exist 		*/
					@vc_reportname	= 'Custom Search SAT With Report State', 	/* The name of the report 			*/
					@vc_reportdescription = 'Search SAT With Report State', 	/* The description of the report 		*/
					@vc_report_dataobject = 'd_mtv_searchsatwithreportstate',	/* The name of the datawindow <d_?> 		*/
					@vc_report_criteria_object = 'u_criteria_search_satwithreportstate',	/* The name of the criteria object <u_?> 	*/
					@vc_report_display_object = 'u_search',	/* The name of the display object <u_search_?> 	*/
					@vc_uniqueregistryvalue 	=	'SATState', 	/* This is a unique name for your report so it can be referenced by name later */
					@vc_RprtDtbseDscrptn			 = 'Production Report Database Connection',	/* This is the description of the database you want the report to run against */
					@vc_ReportDocumentType		 = 'PowerBuilder Datawindow',	/* The ReportDocumentType */

					/* Entity Options */
					@vc_entityname 				 = 'AccountDetail',  	/* Entity.EnttyNme - This must already exist.  If None just use empty string ''	*/
					@c_IsVisibleUnderSmartSearchReports	 = 'N',		/* "Y"es or "N"o - This means that you will see these under SmartSearch in Right Angle Explorer */
					@vc_CanIBeNavigatedTo			 = 'Y',		/* Am I going to set this report up for navigation */
					@c_EnttyRprtCnfgIsDflt		 = 'N',		/* "Y"es or "N"o - This means that when you navigate to this entity, this is the report that will open every time.*/

					/* Reporting Options */
					@c_ShowCriteria 			 = 'N',	/* "Y"es or "N"o - Show the criteria object when you open the report.  This is "Y"es only if they won't be using defaults very often */
					@c_IsDragDropEnabled 				= null,  /* "Y"es or "N"o - You will be able to drag rows from this report to other reports and vice versa */
					@c_IsLargeReport				= null,	/* "Y"es or "N"o - If this report will bring back thousands of rows, it should be Yes */
					@c_AutoRetrieve 			 = 'N',	/* "Y"es or "N"o - This is "Y"es only if there are no retrieval arguments and you want it to retrieve when they open the report*/
					@c_AllowsReplication			 = 'N',  /* "Y"es or "N"o - This is "Y"es if the report can be executed against a replicatable database, reports that update data must be executed against the production database */
					@c_IsSupported				 = 'N',  /* "Y"es or "N"o - This should be "N"o for custom built reports that will not be supported by SolArc support */
					@i_SbSystmID			 = Null,     /* This is the ID of the domain to which the report belongs.  Run this Query:   */

					/* Services Options */
					@c_UseReportViewService				= 'Y',
					@c_UseRowFocusService				= 'Y',
					@c_UseColumnResizingService			= 'Y',
					@c_UseDynamicGroupingService			= 'Y',
					@c_UseFormattingService				= 'Y',
					@c_UseAggregationService			= 'Y',
					@c_UseDropDownCachingService			= 'Y',
					@c_UseSortingService			= 'Y',
					@c_UseFilterService			= 'Y',
					@c_UseConversionService				= 'Y',
					@c_UseColumnSelectionService			= 'Y',
					@c_UsePivotService				= 'Y',
					@c_UseCalendarService			= 'Y',
					@c_UseToolbarService			 = null,
					

					/* Distribution Options */
					@c_UseCustomerDefaultOptions			= 'Y', /* "Y"es or "N"o - This will ignore the next few parameters and use what the customer has set up as default distribution methods */

						@c_AllowPrinting				= 'Y',
						@c_AllowArchiving				= 'Y',
						@c_AllowRightAngleMail				= 'Y',
						@c_AllowEMail					= 'N',
						@c_AllowFTP				= 'N',
						@c_AllowRightFax			= 'N',
						@c_AllowEasyLink		= 'N'




 
   
  

   print '<<< New Report Search SAT With Report State into ReportConfig >>>'


end
else
   print '<<< New Report Search SAT With Report State  already exists >>>'
  
  
  declare @RprtCnfgID int
   
   select @RprtCnfgID = ( select rprtcnfgid from reportconfig where rprtcnfgnme = 'Custom Search SAT With Report State')
   if not exists ( select 'x' from ReportConfigColumnSelectionTable where rprtcnfgid = @rprtcnfgid )
   begin
      insert into ReportConfigColumnSelectionTable 
      select @RprtCnfgID
      , 57,'','','N','N'

     insert into ReportConfigColumnSelectionTable 
     select @RprtCnfgID
     , 72,'','','N','N'
   
   
     insert into ReportConfigColumnSelectionTable 
     select @RprtCnfgID
     , 74,'','','N','N'
     
     
     insert into ReportConfigColumnSelectionTable 
     select @RprtCnfgID
     , 86,'','','N','N'
     
     
     insert into ReportConfigColumnSelectionTable 
     select @RprtCnfgID
     , 102,'Destination','','N','N'
     
     insert into ReportConfigColumnSelectionTable 
     select @RprtCnfgID
     , 102,'Origin','','N','N'
	 end