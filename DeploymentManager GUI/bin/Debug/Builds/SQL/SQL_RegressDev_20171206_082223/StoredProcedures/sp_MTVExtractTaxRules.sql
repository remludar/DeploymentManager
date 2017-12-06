/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVExtractTaxRulesSP WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVExtractTaxRulesSP]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVExtractTaxRulesSP.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVExtractTaxRulesSP]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVExtractTaxRulesSP] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVExtractTaxRulesSP >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVExtractTaxRulesSP]
											@i_TaxRuleSet			varchar(10),
											@vc_TaxGrouping			Int,
											@vc_TaxFolder			Int,
											@c_OnlyShowSQL			char(1)	= 'N'

						
AS

-- ==========================================================================================
-- Author:        JOSEPH MCCLEAN
-- Create date:	  JUNE 6 2016
-- Description:   EXTRACTS TAX RULES FROM VARIOUS TAX TABLES
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier ON
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	   @vc_SQLSelect VarChar(8000)
		  ,@vc_SQLFrom VarChar(8000)
		  ,@vc_SQLWhere VarChar(8000)
		  ,@vc_DynamicSQL varchar(8000)
		  ,@vc_InsertStatement varchar(8000)
		  ,@vc_InsertIntoProvisionsTemp varchar(8000)
		  ,@vc_InsertIntoProperties varchar(8000)
		  ,@vc_InsertIntoTemp varchar(8000)
		  ,@vc_CreateTable varchar(8000)
		  ,@vc_dropTempTableStatement varchar(200)


----------------------------------------------------------------------------------------------------------------------
-- Create tables
----------------------------------------------------------------------------------------------------------------------
	
									
	If @c_OnlyShowSQL = 'Y'
		Begin
		Select 'Create Table #MTVTaxRuleSetExtract
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					EntitySort				int				Null
				)'

				Select 'Create Table #ProvisionsTemp
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					RowNumber				INT				Null
				)'


				Select 'Create Table #PropertiesTemp
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					EntitySort				Null			Null
				)'

				select 'Create Table #TaxRuleTemp
						(
  							Idnty 					Int				IDENTITY,
							TxID					INT				NULL,
							TxRleSetID				INT				NULL,
							DateModified 			smalldatetime	Null,
							UserID 					Int				Null,
							UserDBMnkr 				VarChar(80)		Null,
							TxRleSt 				varchar(200)	Null,
							DlDtlPrvsnID 			Int 			Null,
							Tab						VarChar(20)		Null,
							EvaluationOrder			varchar (13)	null,
							Name					varchar(100)	null,
							[Description]			varchar(80)		null,
							Government				varchar(3)		null,
							Location				varchar(200)	null
						)'

		End
	 Else
		Begin
		Create Table #MTVTaxRuleSetExtract
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					EntitySort				int				Null
				)

		Create Table #PropertiesTemp
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					EntitySort				int				Null
				)
				
		Create Table #ProvisionsTemp
				(
  					Idnty 					Int				IDENTITY,
					TxID					INT				NULL,
					TxRleSetID				INT				NULL,
					DateModified 			smalldatetime	Null,
					UserID 					Int				Null,
					UserDBMnkr 				VarChar(80)		Null,
					TxRleSt 				varchar(200)	Null,
					DlDtlPrvsnID 			Int 			Null,
					Tab						VarChar(20)		Null,
					Entity					VarChar(100)	Null,
					Value 					VarChar(max)	Null,
					RowNumber				INT				Null
				)

		Create Table #TaxRuleTemp
						(
  							Idnty 					Int				IDENTITY,
							TxID					INT				NULL,
							TxRleSetID				INT				NULL,
							DateModified 			smalldatetime	Null,
							UserID 					Int				Null,
							UserDBMnkr 				VarChar(80)		Null,
							TxRleSt 				varchar(100)	Null,
							DlDtlPrvsnID 			Int 			Null,
							Tab						VarChar(20)		Null,
							EvaluationOrder			varchar (13)	null,
							Name					varchar(100)	null,
							[Description]			varchar(80)		null,
							Government				varchar(3)		null,
							Location				varchar(200)	null
						)
		End

---------------------------------------------------------------------------------------------------------------------
--- Establish Search Criteria 
---------------------------------------------------------------------------------------------------------------------
Declare @folderCriteria  varchar (200) 
Declare  @taxGroupCriteria varchar (255)
Declare @taxrulesetcriteria varchar (255)

SET @folderCriteria = 'Select distinct TaxRuleSEt.TxID From Tax 
							Inner Join TaxRuleSEt  ON TaxRuleSEt.TxID = Tax.TxId 
							Inner Join Folder ON Folder.FldrId = Tax.FldrId 
							Where Tax.Fldrid = ' +  CONVERT(varchar, @vc_TaxFolder) 

Set @taxGroupCriteria = 'TaxRuleSet.TxID In (' +  CONVERT(varchar, @vc_TaxGrouping) + ')'

Set @taxrulesetcriteria = 'TaxRuleSet.TxRleStID In (' +  CONVERT(varchar, @i_TaxRuleSet)  +')'


Select @vc_SQLWhere	 = 'Where 1=1 '

--if @vc_TaxFolder IS NULL 


if @vc_TaxFolder Is Not Null 
Begin
	Select	@vc_SQLWhere	= @vc_SQLWhere + 
	Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND TaxRuleSet.TxId In (' + @folderCriteria + ')' 
	                                        Else ' OR TaxRuleSet.TxId In (' + @folderCriteria + ')' End

	if @vc_TaxGrouping Is Not Null 
	Begin
		Select	@vc_SQLWhere	= @vc_SQLWhere + 
		Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND ' + @taxGroupCriteria Else  ' AND ' + @taxGroupCriteria End
	End


	if @i_TaxRuleSet Is Not Null 
	Begin 
		Select	@vc_SQLWhere	= @vc_SQLWhere + 
		Case When @vc_SQLWhere = 'Where 1=1 ' Then ' AND ' + @taxrulesetcriteria Else ' AND ' +  @taxrulesetcriteria End
	End
End



--if @vc_TaxFolder Is Not Null 
--Begin
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND TaxRuleSet.TxId In (' + @folderCriteria + ')' 
--	                                        Else ' OR TaxRuleSet.TxId In (' + @folderCriteria + ')' End
--End

--if @vc_TaxGrouping Is Not Null 
--Begin
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND ' + @taxGroupCriteria Else  ' AND ' + @taxGroupCriteria End
--End


--if @i_TaxRuleSet Is Not Null 
--Begin 
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 ' Then ' AND ' + @taxrulesetcriteria Else ' AND ' +  @taxrulesetcriteria End
--End


--if @i_TaxRuleSet Is Not Null 
--Begin 
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 ' Then ' AND ' + @taxrulesetcriteria Else ' OR ' +  @taxrulesetcriteria End
--End
--if @vc_TaxGrouping Is Not Null 
--Begin
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND ' + @taxGroupCriteria Else  ' OR ' + @taxGroupCriteria End
--End
--if @vc_TaxFolder Is Not Null 
--Begin
--	Select	@vc_SQLWhere	= @vc_SQLWhere + 
--	Case When @vc_SQLWhere = 'Where 1=1 '	Then ' AND TaxRuleSet.TxId In (' + @folderCriteria + ')' 
--	                                        Else ' OR TaxRuleSet.TxId In (' + @folderCriteria + ')' End
--End


----------------------------------------------------------------------------------------------------------------------
-- Generate Insert Statment
----------------------------------------------------------------------------------------------------------------------

select @vc_InsertStatement = 'INSERT #MTVTaxRuleSetExtract
							 (
								 TxID	
								,TxRleSetID				
								,DateModified			
								,UserID 					
								,UserDBMnkr 				
								,TxRleSt			
								,DlDtlPrvsnID 			
								,Tab						
								,Entity					
								,Value 	
								,EntitySort
							 ) '

select @vc_InsertIntoProvisionsTemp = 'INSERT #ProvisionsTemp
									(
									TxID	
									,TxRleSetID				
									,DateModified			
									,UserID 					
									,UserDBMnkr 				
									,TxRleSt			
									,DlDtlPrvsnID 			
									,Tab						
									,Entity					
									,Value 	
									,RowNumber				
									) '

select @vc_InsertIntoProperties = 'INSERT #PropertiesTemp
									(
									TxID	
									,TxRleSetID				
									,DateModified			
									,UserID 					
									,UserDBMnkr 				
									,TxRleSt			
									,DlDtlPrvsnID 			
									,Tab						
									,Entity					
									,Value 	
									,EntitySort
									) '

----------------------------------------------------------------------------------------------------------------------
-- Insert tax rule set properties into temp table - 1
----------------------------------------------------------------------------------------------------------------------	

	SELECT @vc_SQLSelect ='	SELECT				[TxId],
												[TxRleStId],						
												[Modified Date],
												[UserID],
												[User],
												[TaxRuleSet Description],
												NULL,
												''Properties'' [Tab],
												Entity,
												Value ,
												1'
												
	SELECT	@vc_SQLFrom	='FROM 
							(
								SELECT
										TaxRuleSet.TxId [TxId],
										TaxRuleSet.TxRleStId [TxRleStId],
										CONVERT(VARCHAR(MAX),TaxRuleSet.RevisionDate) 						[Modified Date],
										CONVERT(VARCHAR(MAX), Users.UserDBMnkr)								[User],
										CONVERT(VARCHAR(MAX),Users.UserID)									[UserID],
										TaxRuleSet.[Description]											[TaxRuleSet Description],
										CONVERT(VARCHAR(MAX),DDP.DlDtlPrvsnID )								[Provision ID],
										CONVERT(VARCHAR(MAX),
										(case when [Type] = ''F'' then ''Financial''
											  when [Type] = ''M'' then ''Movement'' end))					[Type],
										CONVERT(VARCHAR(MAX),FromDate)										[Effective From Date],
										CONVERT(VARCHAR(MAX),ToDate)										[Effective To Date],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Allow Exemption'',AllowExemption))			[Allow Exemption],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'',''Allowed Deferred Billing'', AllowDeferedBilling))		[Allowed Deferred Billing],
										CONVERT(VARCHAR(MAX), InvoicingDescription)		[Invoicing Description],
										CONVERT(VARCHAR(MAX),case when  TaxRuleSet.Status  = ''I'' then ''Inactive''
																   when TaxRuleSet.Status = ''A''  then ''Active'' end      )	as			[Status],
										CONVERT(VARCHAR(MAX),  dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Invoiceable'', Invoiceable))				[Invoiceable],
										CONVERT(VARCHAR(MAX), case when ResponsibleParty = ''B'' then ''Buyer''
											                       when ResponsibleParty = ''S'' then ''Seller'' end)			[Responsible Party],
										CONVERT(VARCHAR(MAX), Description) as													[Description],
										CONVERT(VARCHAR(MAX),  dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Use Position Holder Logic'',UsePositionHolderLogic)) [Use Position Holder Logic],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''No Buyer License Indicates'',NoBuyerLicenseFound))		[No Buyer License Indicates],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Create Remittable'',CreateRemittable))			[Create Remittable],
										CONVERT(VARCHAR(MAX), Term.TrmAbbrvtn)			[Deferred Tax Term],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''No Seller License Indicates'',NoSellerLicenseFound))	[No Seller License Indicates],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Load Fee'',IsLoadFee))				[Load Fee],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''VAT Tax'',IsVATTax))					[VAT Tax],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''VAT Tax'', IsCappedTax))			[Capped Tax],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Embedded Tax'', IsEmbeddedTax))		[Embedded Tax],
										CONVERT(VARCHAR(MAX), dbo.Motiva_fn_LookupTaxExtractValue(''Properties'', ''Use Rack Logic'', UseRackLogic))		[Use Rack Logic]

								 FROM	TaxRuleSet  (nolock)
										LEFT JOIN Term 
										ON Term.TrmID = TaxRuleSet.TrmID
										left JOIN TaxProvision  TP
										on TP.TxRleStID = TaxRuleSet.TxRleStID
										left JOIN DealDetailProvision DDP
										On DDP.DlDtlPrvsnID = TP.DlDtlPrvsnID
										INNER JOIN Users 
										ON Users.UserID = TaxRuleSet.RevisionUserID
								' + @vc_SQLWhere +'						
													)PropertyData UNPIVOT (Value FOR Entity IN(
																						[Description],
																						[Effective From Date],
																						[Effective To Date],
																						[Type],
																						[Status],
																						[Load Fee],
																						[Capped Tax],
																						[VAT Tax],
																						[Embedded Tax],
																						[Responsible Party],
																						[Create Remittable],
																						[Invoiceable],
																						[Allow Exemption],
																						[Allowed Deferred Billing],
																						[Deferred Tax Term],
																						[Invoicing Description],
																						[No Buyer License Indicates],
																						[Use Position Holder Logic],
																						[No Seller License Indicates],
																						[Use Rack Logic]
																					)
									                                         )AS PropertyFields ' 


Select @vc_DynamicSQL = @vc_InsertIntoProperties +  @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)




Select @vc_SQLSelect = 'SELECT  Properties.TxID,					
										Properties.TxRleSetID,				
										Properties.DateModified, 			
										Properties.UserID, 					
										Properties.UserDBMnkr,
										Properties.TxRleSt, 				
										Properties.DlDtlPrvsnID,
										Properties.Tab,			
										Properties.Entity,					
										Properties.Value,
										Properties.EntitySort
										'			
 Select @vc_SQLFrom= 'FROM (SELECT	DISTINCT	TxID,					
												TxRleSetID,				
												DateModified, 			
												UserID, 					
												UserDBMnkr,
												TxRleSt, 				
												DlDtlPrvsnID,
												Tab,			
												Entity,					
												Value,
												EntitySort
							FROM #PropertiesTemp ) Properties
					ORDER BY  
					Properties.TxRleSt,
					CASE		WHEN Entity	=	''Description''					THEN	''A''
								WHEN Entity	=	''Effective From Date''			THEN	''B''
								WHEN Entity	=	''Effective To Date''			THEN	''C''
								WHEN Entity	=	''Type''						THEN	''D''
								WHEN Entity	=	''Status''						THEN	''E''
								WHEN Entity	=	''Load Fee''					THEN	''F''
								WHEN Entity	=	''Capped Tax''					THEN	''D''	
								WHEN Entity	=	''VAT Tax''						THEN	''E''
								WHEN Entity	=	''Embedded Tax''				THEN	''F''
								WHEN Entity	=	''Responsible Party''			THEN	''G''
								WHEN Entity	=	''Create Remittable''			THEN	''H''
								WHEN Entity	=	''Invoiceable''					THEN	''I''
								WHEN Entity	=	''Allow Exemption''				THEN	''J''
								WHEN Entity	=	''Allowed Deferred Billing''	THEN	''K''
								WHEN Entity	=	''Deferred Tax Term''			THEN	''L''
								WHEN Entity	=	''Invoicing Description''		THEN	''M''
								WHEN Entity	=	''No Buyer License Indicates''	THEN	''N''
								WHEN Entity	=	''Use Position Holder Logic''	THEN	''O''
								WHEN Entity	=	''No Seller License Indicates''	THEN	''P''
								WHEN Entity	=	''Use Rack Logic''				THEN	''Q'' END '

Set @vc_dropTempTableStatement = ' DROP TABLE #PropertiesTemp '

Select @vc_DynamicSQL = @vc_InsertStatement +   @vc_SQLSelect + @vc_SQLFrom + @vc_dropTempTableStatement

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Insert tax rules into temp table   - 2
----------------------------------------------------------------------------------------------------------------------

--Set Quoted_Identifier ON


Select	@vc_SQLSelect = 'SELECT 	DISTINCT
									TxID,
									TxRleStID,
									RevisionDate ,
									RevisionUserID,
									UserDBMnkr,
									TxRuleSetDescription,
									NULL,
									''Rules'' ,
									RuleDescription,
									dbo.fn_MTV_ParseTaxRule(TxRleStID, TxRleId),
									2'

select 	@vc_SQLFrom	 ='FROM (SELECT 
										TaxRuleSet.RevisionDate,
										Users.UserDBMnkr,
										TaxRuleSet.RevisionUserID,
										TaxRuleSet.[Description] AS TxRuleSetDescription,
										TaxRuleSetRule.TxID,
										TaxRuleSetRule.TxRleStID,
										TaxRuleSetRule.TxRleId,
										RuleValue,
										TaxRule.Description AS RuleDescription, 
										DealDetailProvision.DlDtlPrvsnID,
										CAST(''<XMLRoot><RowData>'' + REPLACE(ISNULL(RuleValue, '' ''), ''||'',''</RowData><RowData>'') + ''</RowData></XMLRoot>'' AS XML) AS x
								FROM	TaxRuleSetRule (nolock)
										INNER JOIN TaxRule
										ON	TaxRuleSetRule.TxRleID = TaxRule.TxRleID
										INNER JOIN TaxRuleSet
										ON	TaxRuleSetRule.TxRleStID = TaxRuleSet.TxRleStID
										INNER JOIN Users
										ON TaxRuleSet.RevisionUserID = Users.UserID
										INNER JOIN TaxProvision
										ON TaxProvision.TxRleStID = TaxRuleSet.TxRleStID
										INNER JOIN DealDetailProvision 
										ON DealDetailProvision.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID 
										' + @vc_SQLWhere  +		')t
									    CROSS APPLY x.nodes(''/XMLRoot/RowData'')m(n)'			


select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

Set Quoted_Identifier OFF

----------------------------------------------------------------------------------------------------------------------
-- Insert tax provisons into temp table - part 1
----------------------------------------------------------------------------------------------------------------------

SELECT @vc_SQLSelect = 'SELECT 
										TaxID,
										TaxRuleSetID,
										[Modified Date],
										UserId [UserID] ,
										[User],
										TxRuleSetDescription [Tax Rule Set], 
										ProvisionID [Provision ID],
										[Tab],
										Entity, 
										Value,
										null '
SELECT @vc_SQLFrom = 'FROM 
								(SELECT DISTINCT
												TaxRuleSet.TxID as TaxID,
												TaxRuleSet.TxRleStID as TaxRuleSetID,
												TaxRuleSet.Description AS TxRuleSetDescription,
												DDP.DlDtlPrvsnID as ProvisionID,
												Prvsn.PrvsnDscrptn,
												TaxRuleSet.TxID
												,TaxRuleSet.TxRleStID
												,''Provisions'' as [Tab]
												,CONVERT(VARCHAR(MAX),Prvsn.PrvsnDscrptn) AS ProvisionType

												
												,CONVERT(VARCHAR(MAX),    case when PAT.PrvsnAttrTpeDscrptn = ''Fixed Tax Rate Name'' then (select top 1 Rate from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
																																			where  TRY_CONVERT(int,  DDPA.DlDtlPnAttrDta) IS NOT NULL and TaxRateDetail.TaxRateNameID = CONVERT(int, DDPA.DlDtlPnAttrDta)  
																																			--AND (TaxRateDetail.FromDate >=  DDP.DlDtlPrvsnFrmDte) 
																																			)  end)  as [Fixed Tax Rate]


												,CONVERT(VARCHAR(MAX),    case when PAT.PrvsnAttrTpeDscrptn = ''Percent Tax Rate Name'' then (select top 1 Rate from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
																																			  where  TRY_CONVERT(int,  DDPA.DlDtlPnAttrDta) IS NOT NULL and TaxRateDetail.TaxRateNameID = CONVERT(int, DDPA.DlDtlPnAttrDta ) 
																																			  --AND (TaxRateDetail.FromDate >=  DDP.DlDtlPrvsnFrmDte) 
																																			  )  end)  as [Percent Tax Rate]

												,CONVERT(VARCHAR(MAX),    case when PAT.PrvsnAttrTpeDscrptn In ( ''Applicable Portion'' ) then (CAST(DDPA.DlDtlPnAttrDta as decimal) * 100.00 )  end)  as [Applicable Portion]

												,CONVERT(VARCHAR(MAX),TransType.TrnsctnTypDesc) as [Transaction Type]
												,CONVERT(VARCHAR(MAX),DlDtlPrvsnFrmDte) AS [From Date]
												,CONVERT(VARCHAR(MAX),DlDtlPrvsnToDte) AS [To Date]
												,CONVERT(VARCHAR(MAX), case when QuantityBasis = ''X'' then ''As Billed''
																			when QuantityBasis = ''G''  then ''Gross''
																			when QuantityBasis = ''N''  then ''Net'' end ) AS QuantityBasis
												--,CONVERT(VARCHAR(MAX),PAT.PrvsnAttrTpeDscrptn) as [VarName]
												,CONVERT(VARCHAR(MAX),DDPR.RowNumber) as DDPRRowNumber
												,Convert(VARCHAR(MAX),DDPA.RowNumber) as DDPARowNumber
												,CONVERT(VARCHAR(MAX),PrvsnID) AS PrvsnID
												,CONVERT(VARCHAR(MAX),DDPR.DlDtlPrvsnID) AS DDPR_DlDtlPrvsnID
						
												--,CONVERT(VARCHAR(MAX),DlDtlPrvsnDlDtlDlHdrID) AS DlDtlPrvsnDlDtlDlHdrID
												--,CONVERT(VARCHAR(MAX),DlDtlPrvsnDlDtlID) AS DlDtlPrvsnDlDtlID
												,CONVERT(VARCHAR(MAX),DDP.DlDtlPrvsnID) AS DDP_DlDtlPrvsnID
												--,CONVERT(VARCHAR(MAX),DlDtlPrvsnRwID) AS DlDtlPrvsnRwID
												,Users.UserDBMnkr as [User]
												,Users.UserID	as [UserId]
												,TaxRuleSet.RevisionDate as [Modified Date]
			
										FROM	TaxProvision TP (NoLock)
												INNER JOIN  DealDetailProvision DDP (NoLock)
												ON	TP.DlDtlPrvsnID = DDP.DlDtlPrvsnID
												INNER JOIN    DealDetailProvisionRow DDPR (NoLock)
												ON	DDP.DlDtlPrvsnID = DDPR.DlDtlPrvsnID
												INNER JOIN Prvsn (NoLock)
												ON	DDP.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID
												INNER JOIN TaxRuleSet (NoLock)
												ON	TP.TxRleStID = TaxRuleSet.TxRleStID
												INNER JOIN Users 
												ON TaxRuleSet.RevisionUserID = Users.UserID
												Left Join DealDetailPrvsnAttribute DDPA
												On DDPA.DlDtlPnAttrDlDtlPnID = DDP.DlDtlPrvsnID
												inner join TransactionType TransType 
												on TransType.TrnsctnTypID = DDP.TrnsctnTypID
												inner join PrvsnAttributeType PAT
												ON PAT.PrvsnAttrTpeID = DDPA.DlDtlPnAttrPrvsnAttrTpeID 
									' +  @vc_SQLWhere + ' AND DDPA.RowNumber = DDPR.RowNumber 
				) p
				UNPIVOT
					(Value FOR Entity IN 
										( 
										 [ProvisionType]
										,[Transaction Type]
										,[From Date]
										,[To Date]
										,QuantityBasis
										--,[Rate]
										,[Fixed Tax Rate]
										,[Percent Tax Rate]
										--,[Applicable Portion]
										--,[Flat Tax Rate]
										--,[Flat Tax Rate 2]
									)	)AS unpvt  
				
				GROUP BY 	unpvt.TxRuleSetDescription, unpvt.ProvisionID, unpvt.Entity, unpvt.TaxID, unpvt.TaxRuleSetID,	unpvt.[Modified Date],	unpvt.UserId ,	unpvt.[User],	unpvt.[Tab],	unpvt.Value

				ORDER BY   [Tax Rule Set] ASC, [ProvisionID], CASE  WHEN Entity = ''ProvisionType''								THEN ''A''
																	WHEN Entity = ''Transaction Type''							THEN ''B''
																	WHEN Entity = ''From Date''									THEN ''C''
																	WHEN Entity = ''To Date''									THEN ''D''
																	WHEN Entity = ''QuantityBasis''								THEN ''E''
																	--WHEN Entity = ''Rate''									THEN ''F''
																    WHEN Entity = ''Fixed Tax Rate Name''						THEN ''G''
																	WHEN Entity = ''Percent Tax Rate Name''						THEN ''H''
																	WHEN Entity = ''Applicable Portion''						THEN ''I''
																	WHEN Entity = ''Applicable Percentage''						THEN ''J''
																	WHEN Entity = ''Max Price Per Gallon''						THEN ''K''
															ELSE Entity		END		'
----order by [Tax Rule Set] asc'
----select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom

select @vc_DynamicSQL = @vc_InsertIntoProvisionsTemp +    @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Insert tax provisons into temp table - part 2
----------------------------------------------------------------------------------------------------------------------
--select @vc_InsertStatement = 'INSERT #ProvisionsTemp
--							 (
--								 TxID	
--								,TxRleSetID				
--								,DateModified			
--								,UserID 					
--								,UserDBMnkr 				
--								,TxRleSt			
--								,DlDtlPrvsnID 			
--								,Tab						
--								,Entity					
--								,Value 
--								,RowNumber
--							 ) '

select @vc_InsertIntoProvisionsTemp = 'INSERT #ProvisionsTemp
									(
									TxID	
									,TxRleSetID				
									,DateModified			
									,UserID 					
									,UserDBMnkr 				
									,TxRleSt			
									,DlDtlPrvsnID 			
									,Tab						
									,Entity					
									,Value 	
									,RowNumber				
									) '

SELECT @vc_SQLSelect = 'SELECT 	
								TaxRuleSet.TxID,
								TaxRuleSet.TxRleStID,
								TaxRuleSet.RevisionDate [Modified Date],
								TaxRuleSet.RevisionUserID as [User ID],
								Users.UserDBMnkr as [User Name],
								TaxRuleSet.Description as [Tax RuleSet Name],  
								DDP.DlDtlPrvsnID,
								''Provisions'',
								PAT.PrvsnAttrTpeDscrptn as [Entity], 
								(case when PAT.PrvsnAttrTpeDscrptn like ''%Tax Rate%'' then (select top 1 Name from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
																							 where  TRY_CONVERT(int,  DDPA.DlDtlPnAttrDta) IS NOT NULL and 
																							 TaxRateDetail.TaxRateNameID = CAST( DDPA.DlDtlPnAttrDta as int)  ) 
									 when PAT.PrvsnAttrTpeDscrptn like ''%Product Group%'' then (select top 1 Sort 
																								 from  P_PositionGroupFlat 
																								 where TRY_CONVERT(int,  DDPA.DlDtlPnAttrDta) IS NOT NULL and 
																										ChldP_PstnGrpID = DDPA.DlDtlPnAttrDta)
									 else DDPA.DlDtlPnAttrDta end) as [Value] ,
									 DDPR.RowNumber			 '

SELECT @vc_SQLFrom	= 'FROM	TaxRuleSet  (nolock)
								inner join TaxProvision TP 
								ON TP.TxRleStID = TaxRuleSet.TxRleStID
								inner join DealDetailProvision DDP 
								On DDP.DlDtlPrvsnID = TP.DlDtlPrvsnID
								left join DealDetailProvisionRow DDPR
								on DDPR.DlDtlPrvsnID = DDP.DlDtlPrvsnID
								inner join DealDetailPrvsnAttribute DDPA
								On DDPA.DlDtlPnAttrDlDtlPnID = DDP.DlDtlPrvsnID  and DDPA.RowNumber = DDPR.RowNumber 
								inner join PrvsnAttributeType PAT
								ON PAT.PrvsnAttrTpeID = DDPA.DlDtlPnAttrPrvsnAttrTpeID
								inner join Users 
								ON Users.UserID  = TaxRuleSet.RevisionUserID ' + @vc_SQLWhere + ' AND DDP.TmplteSrceTpe =''TX'' 
								
								--ORDER BY [Tax RuleSet Name], DDPR.RowNumber DESC,  DDP.DlDtlPrvsnID,
								--CASE  
								--	  --WHEN pat.PrvsnAttrTpeDscrptn = ''Fixed Tax Rate Name''		THEN ''A''
								--	  --WHEN pat.PrvsnAttrTpeDscrptn = ''Applicable Portion''			THEN ''B''
								--	  --WHEN pat.PrvsnAttrTpeDscrptn = ''Applicable Percentage''		THEN ''C''
								--	  --WHEN pat.PrvsnAttrTpeDscrptn = ''Percent Tax Rate Name''		THEN ''D''
								--	  --WHEN pat.PrvsnAttrTpeDscrptn = ''Max Price Per Gallon''		THEN ''E''
								--      WHEN pat.PrvsnAttrTpeDscrptn = ''Product Group 1''			THEN ''F''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''From Quantity''				THEN ''G''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''To Quantity''				THEN ''H''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''Flat Tax Rate Name''			THEN ''I''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''Product Group 2''			THEN ''J''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''From Quantity 2''			THEN ''K''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''To Quantity 2''				THEN ''L''
								--	  WHEN pat.PrvsnAttrTpeDscrptn = ''Flat Tax Rate  2''			THEN ''M''
								--	  ELSE pat.PrvsnAttrTpeDscrptn
								--END 			'
						--ORDER by TRS.Description'


--------select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom

select @vc_DynamicSQL = @vc_InsertIntoProvisionsTemp +    @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

---------------------------------------------------------------------------------------------------------------------
-- INSERT THE TAX FLAT TAX RATES HERE 
----------------------------------------------------------------------------------------------------------------------

--select @vc_InsertStatement = 'INSERT #ProvisionsTemp
--							 (
--								 TxID	
--								,TxRleSetID				
--								,DateModified			
--								,UserID 					
--								,UserDBMnkr 				
--								,TxRleSt			
--								,DlDtlPrvsnID 			
--								,Tab						
--								,Entity					
--								,Value 
--								,RowNumber
--							 ) '

SELECT @vc_SQLSelect ='SELECT 	  
    							TaxRuleSet.TxID,
								TaxRuleSet.TxRleStID,
								TaxRuleSet.RevisionDate [Modified Date],
								TaxRuleSet.RevisionUserID as [User ID],
								Users.UserDBMnkr as [User Name],
								TaxRuleSet.Description as [Tax RuleSet Name],  
								DDP.DlDtlPrvsnID as [ProvisionID],
								''Provisions'',
								CONVERT(VARCHAR(MAX),    case when PAT.PrvsnAttrTpeDscrptn  IN (''Flat Tax Rate Name'' , ''Flat Tax Rate Name 2'') then  REPLACE(PAT.PrvsnAttrTpeDscrptn, ''Name'', '''')   end)  as [Entity]

								,(case when PAT.PrvsnAttrTpeDscrptn  IN (''Flat Tax Rate Name'', ''Flat Tax Rate Name 2'') then (select top 1 Name + '' ='' + cast(Rate AS VARCHAR(25))
																															   from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
																															   where  TRY_CONVERT(int,  DDPA.DlDtlPnAttrDta) IS NOT NULL AND 
																															   TaxRateDetail.TaxRateNameID = CAST( DDPA.DlDtlPnAttrDta as int) 
																															   --AND TaxRateDetail.FromDate >= DDP.DlDtlPrvsnFrmDte  
																															   --AND   TaxRateDetail.ToDate = DDP.DlDtlPrvsnToDte
																															   ) end ) [Value]
								  ,DDPR.RowNumber '

 SELECT @vc_SQLFrom	= 'FROM	TaxRuleSet 
						inner join TaxProvision TP 
						ON TP.TxRleStID = TaxRuleSet.TxRleStID
						inner join DealDetailProvision DDP 
						On DDP.DlDtlPrvsnID = TP.DlDtlPrvsnID
						left join DealDetailProvisionRow DDPR
						on DDPR.DlDtlPrvsnID = DDP.DlDtlPrvsnID
						inner join DealDetailPrvsnAttribute DDPA
						On DDPA.DlDtlPnAttrDlDtlPnID = DDP.DlDtlPrvsnID  and DDPA.RowNumber = DDPR.RowNumber 
						inner join PrvsnAttributeType PAT
						ON PAT.PrvsnAttrTpeID = DDPA.DlDtlPnAttrPrvsnAttrTpeID
						inner join Users 
						ON Users.UserID  = TaxRuleSet.RevisionUserID ' + @vc_SQLWhere + 
						' AND DDP.TmplteSrceTpe =''TX'' AND PAT.PrvsnAttrTpeDscrptn in (''Flat Tax Rate Name'', ''Flat Tax Rate Name 2'') '
								
----					   --WHERE DDP.TmplteSrceTpe =''TX'' and PAT.PrvsnAttrTpeDscrptn in (''Flat Tax Rate Name'', ''Flat Tax Rate Name 2'') AND  '
------select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom

select @vc_DynamicSQL = @vc_InsertIntoProvisionsTemp +    @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Insert Sorted Provisions Into Extract Table - 3
----------------------------------------------------------------------------------------------------------------------
SELECT @vc_SQLSelect  = 'SELECT	TxID,
								TxRleSetID,
								DateModified,
								UserID,
								UserDBMnkr,
								TxRleSt,
								DlDtlPrvsnID,
								Tab,
								Entity,
								Value,
								3 '
 SELECT @vc_SQLFrom	= 'FROM #ProvisionsTemp
 											
					   ORDER BY TxRleSt, DlDtlPrvsnID , CASE when RowNumber is NULL then 0 ELSE RowNumber END, CASE																		
																													WHEN Entity = ''ProvisionType''					THEN ''A''
																													WHEN Entity = ''Transaction Type''				THEN ''B''
																													WHEN Entity = ''From Date''						THEN ''C''
																													WHEN Entity = ''To Date''						THEN ''D''
																													WHEN Entity = ''QuantityBasis''					THEN ''E''
																													--WHEN Entity = ''Rate''						THEN ''F''
																													WHEN Entity = ''Fixed Tax Rate''				THEN ''G''
																													WHEN Entity = ''Fixed Tax Rate Name''			THEN ''H''
																													
																													WHEN Entity = ''Percent Tax Rate''				THEN ''I''
																													WHEN Entity = ''Percent Tax Rate Name''			THEN ''J''

																													WHEN Entity = ''Applicable Portion''			THEN ''K''
																													WHEN Entity = ''Applicable Percentage''			THEN ''L''

																													WHEN Entity = ''Max Price Per Gallon''			THEN ''M''
																													WHEN Entity = ''Product Group 1''				THEN ''N''
																													WHEN Entity= ''From Quantity''					THEN ''O''
																													WHEN Entity = ''To Quantity''					THEN ''P''
																													WHEN Entity = ''Flat Tax Rate Name''			THEN ''Q''
																													WHEN Entity = ''Flat Tax Rate''					THEN ''R''
																													WHEN Entity = ''Product Group 2''				THEN ''S''
																													WHEN Entity = ''From Quantity 2''				THEN ''T''
																													WHEN Entity = ''To Quantity 2''					THEN ''U''
																													WHEN Entity = ''Flat Tax Rate Name 2''			THEN ''V''
																													WHEN Entity = ''Flat Tax Rate  2''				THEN ''W''
																											END '

--DECLARE @vc_dropTempTableStatement varchar(200)

SET @vc_dropTempTableStatement = ' DROP TABLE #ProvisionsTemp '

select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom  + @vc_dropTempTableStatement

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Insert tax licenses into temp table - 4
----------------------------------------------------------------------------------------------------------------------
select @vc_InsertIntoTemp = 'INSERT #TaxRuleTemp
								(
									TxID				
									,TxRleSetID			
									,DateModified		
									,UserID				
									,UserDBMnkr 			
									,TxRleSt 			
									,DlDtlPrvsnID			
									,Tab
									,EvaluationOrder				
									,Name
									,[Description]
									,Government
									,Location
									) '
Select @vc_SQLSelect =	'SELECT  
								TaxRuleSet.TxID as TaxID
								,TaxRuleSet.TxRleStID as TaxRuleSetId
								,TaxRuleSet.RevisionDate as ModifiedDate
								,Users.UserID as [UserID]
								,Users.UserDBMnkr as [User]
								,TaxRuleSet.[Description] as [Tax Rule Set]
								,NULL as [Provision ID]
								,''Licenses''
								,Convert(varchar(13), TaxRuleSetLicense.EvaluationOrder) AS [Evaluation Order]
								,License.Name as [Name]
								,License.Description as [Description]
								,(select case when TaxRuleSetLicense.GovernmentLicense = ''N'' then ''No''
										when TaxRuleSetLicense.GovernmentLicense = ''Y''  then ''Yes'' end) as [Government]
								,Locale.LcleNme as [Location]
						FROM
								TaxRuleSetLicense
								INNER JOIN TaxRuleSet
								ON	TaxRuleSetLicense.TxRleStID = TaxRuleSet.TxRleStID
								INNER JOIN License
								ON	TaxRuleSetLicense.LcnseID = License.LcnseID 
								inner join Locale
								ON Locale.LcleID = License.LcleID
								INNER JOIN Users 
								ON Users.UserID = TaxRuleSet.RevisionUserID
								INNER JOIN TaxProvision  TP
								on TP.TxRleStID = TaxRuleSet.TxRleStID
								INNER JOIN DealDetailProvision DDP
								On DDP.DlDtlPrvsnID = TP.DlDtlPrvsnID '
					   + @vc_SQLWhere + '
						GROUP BY TaxRuleSet.[Description], TaxRuleSet.TxID, DDP.DlDtlPrvsnID, TaxRuleSet.TxRleStID, TaxRuleSet.RevisionDate, Users.UserDBMnkr, Users.UserID, TaxRuleSetLicense.EvaluationOrder,License.Name,License.Description, TaxRuleSetLicense.GovernmentLicense,  Locale.LcleNme
						ORDER BY  TaxRuleSet.[Description], TaxRuleSetLicense.EvaluationOrder'


select @vc_DynamicSQL = @vc_InsertIntoTemp +    @vc_SQLSelect 

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


SELECT  @vc_SQLSelect = 'SELECT 
							TxID,					
							TxRleSetID,			
							DateModified,			
							UserID,				
							UserDBMnkr ,				
							TxRleSt ,				
							DlDtlPrvsnID,			
							Tab,
							CrossApplied.Entity,
							CrossApplied.Value , 
							4'
	
	Select @vc_SQLFrom	=' FROM #TaxRuleTemp
						   CROSS APPLY (values												
												(''Evaluation Order'',  [EvaluationOrder]),
												(''Name'',			    [Name]),
												(''Description''	  , [Description]),
												(''Location''	,		[Location]),
												(''Government'',		[Government]))CrossApplied (Entity, Value) '			
		
SET @vc_dropTempTableStatement = ' DROP TABLE #TaxRuleTemp '
																			 
select @vc_DynamicSQL = @vc_InsertStatement +    @vc_SQLSelect + @vc_SQLFrom + @vc_dropTempTableStatement

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Insert tax rule set comments into temp table - 5
----------------------------------------------------------------------------------------------------------------------	

--- ADDED DISTINCT QUALIFIER ON 6/2/2016
Select	@vc_SQLSelect = 'SELECT DISTINCT
								Tax.TxID,
								TaxRuleSet.TxRleStID,
								TaxRuleSet.RevisionDate as [Modified Date],
								TaxRuleSet.RevisionUserID as [User ID],
								Users.UserDBMnkr,
								TaxRuleSet.[Description],
								null [Provision ID],
								''Comments'',
								GnrlCmntQlfr as Entity,
								REPLACE(CAST(GnrlCmntTxt AS VARCHAR(MAX)), ''~r~n'', '' '') as Value,
								5'
Select @vc_SQLFrom ='FROM	GeneralComment GC (nolock)
								INNER JOIN TaxRuleSet  
									ON GC.GnrlCmntHdrID = TaxRuleSet.TxRleStID
								INNER JOIN	Users
									ON Users.UserID = TaxRuleSet.RevisionUserID
								INNER JOIN TaxProvision  TP
									ON TP.TxRleStID = TaxRuleSet.TxRleStID
								INNER JOIN DealDetailProvision DDP
									On DDP.DlDtlPrvsnID = TP.DlDtlPrvsnID
								INNER JOIN Tax 
									ON Tax.TxID = TaxRuleSet.TxID ' + @vc_SQLWhere + 'AND GnrlCmntQlfr =''TaxRuleSetComment''  '

select @vc_DynamicSQL = @vc_InsertStatement +  @vc_SQLSelect + @vc_SQLFrom

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------
-- Final Select
----------------------------------------------------------------------------------------------------------------------	

Select	@vc_DynamicSQL	= 'SELECT 
									#MTVTaxRuleSetExtract.Idnty,
									#MTVTaxRuleSetExtract.TxID,
									#MTVTaxRuleSetExtract.TxRleSetID,
									#MTVTaxRuleSetExtract.DateModified,
									#MTVTaxRuleSetExtract.UserID,
									#MTVTaxRuleSetExtract.UserDBMnkr,
									#MTVTaxRuleSetExtract.TxRleSt,
									#MTVTaxRuleSetExtract.DlDtlPrvsnID,
									#MTVTaxRuleSetExtract.Tab,
									#MTVTaxRuleSetExtract.Entity,
									#MTVTaxRuleSetExtract.Value,
									#MTVTaxRuleSetExtract.EntitySort
							FROM #MTVTaxRuleSetExtract (nolock)
							WHERE 1=1   
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVExtractTaxRulesSP]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVExtractTaxRulesSP.sql'
			PRINT '<<< ALTERED StoredProcedure MTVExtractTaxRulesSP >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVExtractTaxRulesSP >>>'
	  END