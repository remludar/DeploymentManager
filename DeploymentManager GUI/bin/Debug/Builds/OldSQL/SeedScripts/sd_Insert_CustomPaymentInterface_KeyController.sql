-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_Insert_CustomPaymentInterface_KeyController     Copyright 2003 SolArc
-- Overview:    
-- Created by:	Joshua Weber
-- History:     24/11/2011 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier off


Insert	KeyController
Select	'CustomPaymentInterface'
		,0
		,A. KyCntrllrFllr1
		,A. KyCntrllrFllr2
		,A. KyCntrllrFllr3
		,A. KyCntrllrFllr4
		,A. KyCntrllrFllr5
		,A. KyCntrllrFllr6
From	KeyController	A	(NoLock)
Where	A. KyCntrllrTble	= 'Access' 	
And		Not Exists	(	Select	'X'
						From	KeyController	B	(NoLock)
						Where	B.	KyCntrllrTble	= 'CustomPaymentInterface')
						
						
Insert	KeyController
Select	'CustomInboundMessage'
		,0
		,A. KyCntrllrFllr1
		,A. KyCntrllrFllr2
		,A. KyCntrllrFllr3
		,A. KyCntrllrFllr4
		,A. KyCntrllrFllr5
		,A. KyCntrllrFllr6
From	KeyController	A	(NoLock)
Where	A. KyCntrllrTble	= 'Access' 	
And		Not Exists	(	Select	'X'
						From	KeyController	B	(NoLock)
						Where	B.	KyCntrllrTble	= 'CustomInboundMessage')								
						