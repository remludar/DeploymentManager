-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	##### sd_           Copyright 2008 SolArc
-- Overview:    
-- Created by:	Kyle Smith
-- History:     07/07/2010 - First Created
--
-- 	Date Modified 	Modified By		Issue#	Modification
-- 	--------------- -------------- 	------	----------------------------------------------------------------------------------
--	07/07/2010		EAH						Added DealType 50 - Blended Storage Deal to the Insert into DealTypeProductCostingDefault statement
--	10/28/2011		EAH						Changed the deal type logic from being hard coded to a select statement.
------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier off

If object_id('tempdb..#tmp') Is Not Null
	Drop Table #tmp
Go

Create Table #tmp
(	 DlHdrType			Int Default Null
	,DelValue			Int
	,RecValue			Int
	,GainValue			Int
	,LossValue			Int
	,LongEndBalValue	Int
	,ShortEndBalValue	Int
)
Go

--Start of Section 1 ---------------------------------------------------------------------------------------
-- 1.  Determine which inventory valuation type your client needs.
------------------------------------------------------------------------------------------------------------

-- select * from Productcostingrules
-- select * from DealTypeProductCostingDefault
-- select * from dealtype

------------------------------------------------------------------------------------------------------------
-- Run this select if you want to see all the rules
-- select * from productcostingrules
-- 1 - 4 is a variation of the pool method
-- the rest is a variation of the contract or market methods.  The market method has market in the name.
------------------------------------------------------------------------------------------------------------

-- Here is what each column type means. 
--Insert #tmp values (DealType,DelValueMethod,RecValueMethod,GainValueMethod,LossValueMethod,LongEndBalValueMethod,ShortEndBalValueMethod)		

--Insert #tmp values (null,6,6,6,6,6,6)			-- Sets everything to zero
--Insert #tmp values (null,1,2,3,2,4,9)			-- WACOG By Pool with Market FAllback
--Insert #tmp values (null,1,2,3,2,4,4)			-- WACOG By Pool no Market FAllback
--Insert #tmp values (null,10,10,12,12,11,11)	-- Modified Lifo by Pool
--Insert #tmp values (null,5,7,6,6,8,18)		-- WACOG By Contract (deliveries group by Order) with zero per unit writeoff/on and market fallback
--Insert #tmp values (null,5,7,6,6,8,8)			-- WACOG By Contract (deliveries group by Order) with zero per unit writeoff/on and no market fallback
--Insert #tmp values (null,5,7,6,6,8,9)			-- WACOG By Contract (deliveries group by Order) with zero per unit writeoff/on and current market fallback
--Insert #tmp values (null,5,7,6,6,8,8)			-- WACOG By Contract (deliveries group by Order) with zero per unit writeoff/on and no current market fallback
--Insert #tmp values (null,5,8,6,6,8,8)			-- WACOG By Contract (deliveries group by Order) + Gain/Loss with zero per unit writeoff/on and no current market fallback
--Insert #tmp values (null,5,7,7,7,8,8)			-- WACOG By Contract (deliveries group by Order) with ending per unit writeoff/on with no market fallback
--Insert #tmp values (null,5,7,7,7,8,18)		-- WACOG By Contract (deliveries group by Order) with ending per unit writeoff/on with market fallback
--Insert #tmp values (null,5,7,7,7,8,9)			-- WACOG By Contract (deliveries group by Order) with ending per unit writeoff/on with Current market fallback
--Insert #tmp values (20,5,9,7,7,8,8)			-- WACOG By Contract (deliveries group by Order) with ending per unit writeoff/on and no market fallback
Insert #tmp values (null,18,18,18,18,18,18)		-- Market Values
--Insert #tmp values (20,18,18,18,18,18,18)		-- Market Values
--Insert #tmp values (null,14,7,6,6,8,18)		-- WACOG By Contract (deliveries group by Move Doc) with zero per unit writeoff/on and market fallback
--Insert #tmp values (null,14,7,6,6,8,8)		-- WACOG By Contract (deliveries group by Move Doc) with zero per unit writeoff/on and no market fallback
--Insert #tmp values (null,14,7,7,7,8,8)		-- WACOG By Contract (deliveries group by Move Doc) with ending per unit writeoff/on and no market fallback
  --Insert #tmp values (null,14,7,7,7,8,18)		-- WACOG By Contract (deliveries group by Move Doc) with ending per unit writeoff/on and market fallback
--Insert #tmp values (null,1,8,3,2,4,4)
/*
Insert #tmp values (null,5,8,6,6,13,13)		
Insert #tmp values (63,5,16,6,6,13,18)		
Insert #tmp values (54,5,15,6,6,13,18)		
Insert #tmp values (55,5,15,6,6,13,18)		
Insert #tmp values (56,5,15,6,6,13,18)		
Insert #tmp values (57,5,15,6,6,13,18)		
Insert #tmp values (58,5,15,6,6,13,18)		
Insert #tmp values (null,1,8,3,2,4,4)
*/

--End 1 ----------------------------------------------------------------------------------------------------


--Start of Section 2 ---------------------------------------------------------------------------------------
-- The DealHeaderPCRule table is a history of your Inventory Valuation performed on certain deals.  When you 
-- change the IV method, the snapshot will insert the new method for the deals and end date the old one.  
-- SnapShot sequence 200 loads this table with the new information.
--
-- Every snapshot that is run will look for changes to the IV method.  If there is a change, snapshot shot
-- sequence 200 will make the appropriate changes to this table.  IV uses this table to get the rules to apply
-- to IV which is sequence 220.

-- For trouble shooting purposes, I could change the settings for a particular snapshot and trouble shoot a 
-- particular snapshot.  Customer Care and Professional services that know how to troubleshoot IV should be
-- the only people taking advantage of this section of code.  Clients really do not need to run this step.

-- By commenting out the assignment of the snapshot id, this step will be skipped.

Declare @snapshot Int
--Select @snapshot = (Select Max(P_EODSnpShtID) From Snapshot Where isvalid = 'Y')
--select @snapshot = 409

If @snapshot Is Not Null
Begin
	Update dhpcr
	Set  dhpcr.DelValueMethod			= #tmp.DelValue
		,dhpcr.RecValueMethod			= #tmp.RecValue
		,dhpcr.GainValueMethod			= #tmp.GainValue
		,dhpcr.LossValueMethod			= #tmp.LossValue
		,dhpcr.LongEndBalValueMethod	= #tmp.LongEndBalValue
		,dhpcr.ShortEndBalValueMethod	= #tmp.ShortEndBalValue
	From DealHeaderPCRule dhpcr, snapshot s, #tmp
	Where InstanceDateTime Between dhpcr.startdate And dhpcr.enddate
	And P_EODSnpShtID = @snapshot
	And #tmp.DlHdrType Is Null

	Update dhpcr
	Set  dhpcr.DelValueMethod			= #tmp.DelValue
		,dhpcr.RecValueMethod			= #tmp.RecValue
		,dhpcr.GainValueMethod			= #tmp.GainValue
		,dhpcr.LossValueMethod			= #tmp.LossValue
		,dhpcr.LongEndBalValueMethod	= #tmp.LongEndBalValue
		,dhpcr.ShortEndBalValueMethod	= #tmp.ShortEndBalValue
	From Snapshot s
	Inner Join DealHeaderPCRule dhpcr
		On s.InstanceDateTime Between dhpcr.startdate And dhpcr.enddate
	Inner Join DealHeader dh
		On dh.DlHdrID = dhpcr.DlHdrID
	Inner Join #Tmp
		On #Tmp.DlHdrType = dh.DlHdrTyp
	Where s.P_EODSnpShtID = @snapshot

End

--End 2 ----------------------------------------------------------------------------------------------------


--Start of Section 3 ---------------------------------------------------------------------------------------
-- Update all the existing deals to reflect the inventory valuation type you selected in section 1 above.

Alter Table DealHeader Disable Trigger All
Go

Update	DealHeader
Set	DelValueMethod			= null,
	RecValueMethod			= null,
	GainValueMethod			= null,
	LossValueMethod			= null,
	LongEndBalValueMethod	= null,
	ShortEndBalValueMethod	= null

Update	DealHeader
Set	DelValueMethod			= DelValue
	,RecValueMethod			= RecValue
	,GainValueMethod		= GainValue
	,LossValueMethod		= LossValue
	,LongEndBalValueMethod	= LongEndBalValue
	,ShortEndBalValueMethod	= ShortEndBalValue
From	#tmp
Where	#tmp.DlHdrType is null
And Exists
	(
	Select	1
	From	DealDetailChemical DDC
	Where	DDC. DlDtlChmclDlDtlDlHdrID = DealHeader. DlHdrID
	And	InventoryType In ('I','E')
	)

Update	DealHeader
Set	DelValueMethod			= DelValue
	,RecValueMethod			= RecValue
	,GainValueMethod		= GainValue
	,LossValueMethod		= LossValue
	,LongEndBalValueMethod	= LongEndBalValue
	,ShortEndBalValueMethod	= ShortEndBalValue
From #tmp
Where #tmp.DlHdrType Is Not Null
And DealHeader.DlHdrTyp = #tmp.DlHdrType
And exists
	(
	Select	1
	From	DealDetailChemical DDC
	Where	DDC. DlDtlChmclDlDtlDlHdrID = DealHeader. DlHdrID
	And	InventoryType In ('I','E')
	)

Go

Alter Table DealHeader enable Trigger All
Go

--End 3 ----------------------------------------------------------------------------------------------------


--Start of Section 4 ---------------------------------------------------------------------------------------
-- Remove the existing DealTypeProductCostingDefault and Insert the new inventory valuation types from Section 1.
-- When you create a new deal, the inventory valuation set up tab will default to the settings in this table.

Delete DealTypeProductCostingDefault

Insert	DealTypeProductCostingDefault
	(
	DlTypID,
	BAID,
	DelValueMethod,
	RecValueMethod,
	GainValueMethod,
	LossValueMethod,
	LongEndBalValueMethod,
	ShortEndBalValueMethod
	)
Select	DealType.DlTypID
	,BusinessAssociate.BAID
	,DelValue
	,RecValue
	,GainValue
	,LossValue
	,LongEndBalValue
	,ShortEndBalValue
From BusinessAssociate	(NoLock)
	,DealType			(NoLock)
	,#tmp
Where BusinessAssociate.BAStts 	= "A"
And	BusinessAssociate.BATpe 	= "D"
And	DealType.DlTypID			In ( Select '20' Union All Select '50' Union All Select DlTypID From DealType Where IsLogistics = 'Y' )
and #Tmp.DlHdrType				Is Not Null
and #Tmp.DlHdrType				= DealType.DlTypID


Insert	DealTypeProductCostingDefault
	(
	DlTypID,
	BAID,
	DelValueMethod,
	RecValueMethod,
	GainValueMethod,
	LossValueMethod,
	LongEndBalValueMethod,
	ShortEndBalValueMethod
	)
Select	DealType.DlTypID
	,BusinessAssociate.BAID
	,DelValue
	,RecValue
	,GainValue
	,LossValue
	,LongEndBalValue
	,ShortEndBalValue
From BusinessAssociate	(NoLock)
	,DealType			(NoLock)
	,#tmp
Where BusinessAssociate.BAStts 	= "A"
And	BusinessAssociate.BATpe 	= "D"
And	DealType.DlTypID			In ( Select '20' Union All Select '50' Union All Select DlTypID From DealType Where IsLogistics = 'Y' )
And #Tmp.DlHdrType				Is null
And	Not Exists (
	Select 1 From DealTypeProductCostingDefault
	Where DealTypeProductCostingDefault.BAID	= BusinessAssociate.BAID
	And DealTypeProductCostingDefault.DlTypID	= DealType.DlTypID)


Go

--End 4 ----------------------------------------------------------------------------------------------------

Drop Table #tmp
Go


/*
Select * from DealType                                                                                                                                                                                                             DealType - Logistics.bmp                                                                                                                                                                                                                                        BusinessAssociate() + Date(YY) + (LB) + UniqueNumber(4)                          N        Y           N                  N                        N                  N                   27          N           A              Y
*/

/*
select distinct 
	DelValueMethod		,
	RecValueMethod		,
	GainValueMethod		,
	LossValueMethod		,
	LongEndBalValueMethod	,
	ShortEndBalValueMethod		
from 	DealHeader

select distinct 
	DelValueMethod		,
	RecValueMethod		,
	GainValueMethod		,
	LossValueMethod		,
	LongEndBalValueMethod	,
	ShortEndBalValueMethod		
from DealTypeProductCostingDefault
*/