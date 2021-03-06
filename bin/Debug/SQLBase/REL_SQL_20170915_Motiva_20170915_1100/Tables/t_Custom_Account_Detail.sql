-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomAccountDetail       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     18/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetail') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomAccountDetail
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetail') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomAccountDetail
						(ID								int				Identity 
						
						,InterfaceMessageID				int				Null
						
						-- Invoice Information								
						,InterfaceSource				char(2)			Null
						,RAInvoiceID					int				Null
						,InterfaceInvoiceID				int				Null
						
						,InvoiceNumber					varchar(20)		Null 
						,InternalInvoiceNumber			varchar(20)		Null						-- Not Required for all installs
						
						,InvoiceAmount					decimal(19,6)	Null		Default 0.0
						,InvoiceAmountPaid				decimal(19,6)	Null		Default 0.0	
						,InvoiceCrrncyID				int				Null
						,InvoiceCurrency				varchar(3)		Null
						
						,LocalCrrncyID					int				Null
						,LocalCurrency					varchar(3)		Null
						,LocalFXRate					decimal(28,13)	Null		Default 1.0
						
						--,LocalInvoiceAmount			decimal(19,6)	Null		Deafult 0.0
						
						,InvoiceDate					smalldatetime	Null					
						,InterfaceBookingDate			smalldatetime	Null						
						,InterfaceBookingAccntngPrdID	int				Null
						,InvoiceDueDate					smalldatetime	Null
						
						,InvoiceTrmID					int				Null
						,InvoiceTrmAbbrvtn				varchar(20)		Null
						,XRefTrmCode					varchar(20)		Null						-- XRef to financial system's code
												
						,InvoiceIntBAID					int				Null
						,InvoiceIntBANme				varchar(100)	Null
						,XRefIntBACode					varchar(25)		Null						-- XRef to financial system's code
						
						,InvoiceIntUserID				int				Null
						,InvoiceIntUserDBMnkr			varchar(80)		Null
						,XRefIntUserCode				varchar(80)		Null						-- XRef to financial system's code
											
						,InvoiceIntBAOffceLcleID		int				Null
						,XRefIntBAAddressCode			varchar(50)		Null						-- XRef to financial system's code												
						
						,InvoiceIntBATaxCode			varchar(50)		Null
						,InvoiceIntBARegistration		varchar(50)		Null
						
						,InvoiceExtBAID					int				Null
						,InvoiceExtBANme				varchar(100)	Null
						,XRefExtBACode					varchar(25)		Null						-- XRef to financial system's code	
						
						,ExtBAClass						varchar(4)		Null
						
						,InvoiceExtCntctID				int				Null
						
						,InvoiceExtBAOffceLcleID		int				Null
						,XRefExtBAAddressCode			varchar(50)		Null						-- XRef to financial system's code
					
						,InvoiceExtBATaxCode			varchar(50)		Null					
						
						,InvoicePaymentBankID			int				Null
						,InvoicePaymentBank				varchar(50)		Null
						,XRefPaymentBankCode			varchar(50)		Null						-- XRef to financial system's code
						
						,InvoiceType					char(2)			Null
						,XRefDocumentType				varchar(50)		Null						-- XRef to financial system's code
						,InvoiceLineType				varchar(4)		Null				
						
						,InvoicePerUnitDecimal			int				Null
						,InvoiceQuantityDecimal			int				Null
						,InvoiceRprtCnfgID				int				Null
														
						,InvoiceParentInvoiceID			int				Null
						,InvoiceParentInvoiceNumber		varchar(20)		Null
						,InvoiceParentInvoiceValue		decimal(19,6)	Null						
	
						,InvoiceCreationDate			smalldatetime	Null
						,InvoiceCreationUserID			int				Null
	
						-- Account Detail Information
						,AcctDtlID						int				Null
						,AcctDtlPrntID					int				Null
						,AcctDtlSrceID					int				Null
						,AcctDtlSrceTble				char(2)			Null
						,AccntngPrdID					int				Null
						,PriorPeriod					char(1)			Null
						,Reversed						char(1)			Null	
						,PayableMatchingStatus			char(1)			Null
						,WePayTheyPay					char(1)			Null
						,SupplyDemand					char(1)			Null
						,ReceiptRefundFlag				varchar(5)		Null
						,HighestValue					char(1)			Null
						,StrtgyID						int				Null
						,StrtgyNme						varchar(120)	Null
						
						,TaxParentAcctDtlID				int				Null
						,WriteOffParentAcctDtlID		int				Null
						,AdjParentAcctDtlID				int				Null
						
						,InternalBAID					int				Null
						,InternalBANme					varchar(100)	Null					
						
						,ExternalBAID					int				Null
						,ExternalBANme					varchar(100)	Null							
						
						,ParentPrdctID					int				Null
						,ParentPrdctNme					varchar(50)		Null
						,XRefParentPrdctCode			varchar(50)		Null
						
						,ChildPrdctID					int				Null
						,ChildPrdctNme					varchar(50)		Null
						,XRefChildPrdctCode				varchar(50)		Null
						,MaterialGroup					varchar(5)		Null
						
						,CmmdtyID						int				Null
						,CmmdtyName						varchar(80)		Null
										
						,TrnsctnTypID					int				Null
						,TrnsctnTypDesc					varchar(80)		Null
						,XRefTrnsctnTypCode				varchar(80)		Null
						
						,InvoiceLineDescription			varchar(240)	Null							
						
						,NetValue						decimal(19,6)	Not Null	Default 0.0
						,GrossValue						decimal(19,6)	Not Null	Default 0.0
						,LocalValue						decimal(19,6)	Not Null	Default 0.0	
						
						-- Local Value					decimal(19,6)	Not Null	Default 0.0

						,CrrncyID						int				Null
						,Currency						char(3)			Null
						
						,Quantity						decimal(19,6)	Null		Default 0.0
						,SpecificGravity				float			Null	
						
						,BaseQuantity					decimal(19,6)	Null		Default 0.0		-- Base as defined by the financial system
						,BaseUOMID						smallint		Null
						,BaseUOM						varchar(25)		Null
						,XRefUOM						varchar(50)		Null						-- XRef to financial system's code	
						
						,InvoiceQuantity				decimal(19,6)	Null		Default 0.0
						,InvoiceUOMID					smallint		Null
						,InvoiceUOM						varchar(25)		Null
						
						--InvoiceValuationQuantity		decimal(19,6)	Null		Default 0.0								
					
						,TransactionDate				smalldatetime	Null
						
						-- Tax Information
						,VATDscrptnID					int				Null
						,VATDescription					varchar(255)	Null
						,TaxCode						varchar(15)		Null	
						,TaxRate						decimal(19,6)	Null		Default 0.0
						,TaxFXDate						smalldatetime	Null
						,TaxFXConversionRate			decimal(28,13)	Null		Default 1.0
						,TaxFXFromCurrencyID			int				Null
						,TaxFXFromCurrency				char(3)			Null
						,TaxFXToCurrencyID				int				Null						
						,TaxFXToCurrency				char(3)			Null
								
						-- Movement Information								
						,MvtHdrID						int				Null
						,MvtHdrTmplteID					int				Null
						,MvtHdrTyp						char(2)			Null
						,MvtHdrTypName					varchar(50)		Null	
						,MvtHdrLcleID					int				Null
						,MvtHdrLocation					varchar(150)	Null
						,MvtHdrOrgnLcleID				int				Null
						,MvtHdrOrigin					varchar(150)	Null
						,MvtHdrDstntnLcleID				int				Null
						,MvtHdrDestination				varchar(150)	Null
						,BDNNo							varchar(80)		Null
						,VhcleID						int				Null
						,Vhcle							varchar(50)		Null
						,VhcleNumber					varchar(10)		Null
						
						,StorageLocation				varchar(5)		Null
						,Plant							varchar(5)		Null
						
						,MvtDcmntID						int				Null
						,MvtDcmntExtrnlDcmntNbr			varchar(80)		Null
						,MvtDcmntTmplteID				int				Null
						,MvtDcmntEntityTemplateID		int				Null
						,MvtDcmntUserInterfaceTemplateID	int			Null
												
						,Temperature					float			Null
						,TemperatureScale				char(1)			Null
						
						,API							float			Null										

						-- Transaction Header Information						
						,XHdrID							int				Null	

						-- Scheduling Information						
						,ObID							int				Null
						,PlnndTrnsfrID					int				Null 
						,PlnndMvtID						int				Null
						,PlnndMvtNme 					varchar(80)		Null
						,PlnndMvtBtchID					int				Null
						,PlnndMvtBtchNme				varchar(80)		Null
						,TransShipmentID				int				Null
						,TransShipmentNm				varchar(50)		Null
						
						-- Deal Information  						
						,DlHdrID						int				Null
						,DlHdrIntrnlNbr					varchar(20)		Null 
						,DlHdrExtrnlNbr					varchar(20)		Null
						,DlHdrDsplyDte					smalldatetime	Null
						,DlHdrTyp						int				Null
						,DlHdrTmplteID					int				Null
						,DlHdrSubTemplateID				int				Null
						,DlHdrEntityTemplateID			int				Null
						,DlHdrUserInterfaceTemplateID	int				Null
						,ClearingBrokerID				int				Null
						,ClearingBroker					varchar(100)	Null
						,ClearingBrokerAccount			varchar(20)		Null
						,IsClearPort					tinyint			Not Null Default 0
						,MasterAgreementID				int				Null
						,MasterAgreementInternalNumber	varchar(20)		Null
						,MasterAgreementDate			smalldatetime	Null						
						,DlDtlID						smallint		Null
						,DlDtlTmplteID					int				Null
						,DlDtlSubTemplateID				int				Null
						,DlDtlEntityTemplateID			int				Null
						,INCOTerm						varchar(50)		Null
						,DlDtlTpe						varchar(60)		Null	
						,SalesOffice					varchar(25)		Null		 							

						-- Deal Provision Information 
													
						,DlDtlPrvsnID					int				Null
						,DlDtlPrvsnCostType				char(1)			Null
						,DlDtlPrvsnActual				char(1)			Null
						,DlDtlPrvsnDecimalPlaces		int				Null
						,DlDtlPrvsnRwID					int				Null
						,RowText						varchar(5000)	Null
						,PrvsnID						int				Null
						,PrvsnDscrptn					varchar(80)		Null
												
						,IsPrimary						tinyint			Not Null Default 0
						,IsSecondary					tinyint			Not Null Default 0
						,IsPrepayment					tinyint			Not Null Default 0
						,IsProvisional					tinyint			Not Null Default 0
						,IsAdjustment					tinyint			Not Null Default 0
						,IsTax							tinyint			Not Null Default 0
						,IsWriteOff						tinyint			Not Null Default 0
						
						-- Cost Source Pointers												
						,TransactionDetailID			int				Null
						,TmeXDtlIdnty					int				Null
						,MvtExpnseID					int				Null
						,MnlLdgrEntryID					int				Null
						,TxDtlID						int				Null
												
						,FixedFloat						tinyint			Not Null Default 0	
						,IsDeemed						tinyint			Not Null Default 0
						,PriceStartDate					smalldatetime	Null
						,PriceEndDate					smalldatetime	Null
						
						-- Finance Information						
						,FinanceSecurity				varchar(80)		Null
						,FinanceBank					varchar(100)	Null
						,FinanceIssueDate				smalldatetime	Null

						--Chart Information
						,CostCenter						varchar(80)		Null
						,ProfitCenter					varchar(80)		Null					
						,DebitAccount					varchar(80)		Null
						,CreditAccount					varchar(80)		Null
						
						,DebitValue						decimal(19,6)	Null	Default 0	
						,CreditValue					decimal(19,6)	Null	Default 0	
						,LocalDebitValue				decimal(19,6)	Null	Default 0	
						,LocalCreditValue				decimal(19,6)	Null	Default 0
						
						,GLLineType						varchar(4)		Null		

						--GL Batch Information								
						,BatchID						int				Null
						,RiskID							int				Null
						,P_EODEstmtedAccntDtlID			int				Null
						,GLType							char(1)			Null
						,PostingType					char(2)			Null
						,Comments						varchar(2000)	Null
						
						--Misc
						,DefaultPerUnitDecimals			int				Null
						,DefaultQtyDecimals				int				Null
						,CreationDate					smalldatetime	Null
						
						)  On 'Default'
						
						
						
											
		Execute SRA_Index_Check		@s_table 		= 'CustomAccountDetail', 
									@s_index		= 'PK_CustomAccountDetail',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK1_CustomAccountDetail',
									@s_keys           = 'InterfaceSource, RAInvoiceID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 
									
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK2_CustomAccountDetail',
									@s_keys           = 'InterfaceInvoiceID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 									
									
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK3_CustomAccountDetail',
									@s_keys           = 'BatchID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 									
																		 															
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK4_CustomAccountDetail',
									@s_keys           = 'AcctDtlID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  
																		
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK5_CustomAccountDetail',
									@s_keys           = 'DlHdrID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'									
																		
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK6_CustomAccountDetail',
									@s_keys           = 'DlDtlPrvsnID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'	

		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK7_CustomAccountDetail',
									@s_keys           = 'PlnndTrnsfrID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'																		
																		
		Execute SRA_Index_Check		@s_table          = 'CustomAccountDetail', 
									@s_index          = 'AK8_CustomAccountDetail',
									@s_keys           = 'MvtHdrID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'									 																																								

	End

Go
	
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomAccountDetail') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Grant Select On dbo.CustomAccountDetail To RightAngleAccess
		Grant Insert On dbo.CustomAccountDetail To RightAngleAccess
		Grant Update On dbo.CustomAccountDetail To RightAngleAccess
		Grant Delete On dbo.CustomAccountDetail To RightAngleAccess
	End
Go		


