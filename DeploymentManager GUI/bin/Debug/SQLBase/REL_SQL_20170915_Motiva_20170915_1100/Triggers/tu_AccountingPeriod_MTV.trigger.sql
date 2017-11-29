SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tU_AccountingPeriod_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tU_AccountingPeriod_MTV
    IF OBJECT_ID('dbo.tU_AccountingPeriod_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tU_AccountingPeriod_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tU_AccountingPeriod_MTV >>>'
  END
go


CREATE trigger tU_AccountingPeriod_MTV on dbo.AccountingPeriod AFTER UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       tU_AccountingPeriod_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   
-- Created by: Sanjay Kumar
-- History:    12/09/2016 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- Begin Tool RI Code
-----------------------------------------------------------------------------------------------------

declare	@numrows 	int
		,@nullcnt 	int
		,@validcnt	int
		,@errno   	int
		,@errmsg  	varchar(255)

select @numrows = @@rowcount
if @numrows=0 return

-----------------------------------------------------------------------------------------------------
-- End Tool RI Code
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- Begin Custom RI Code
-----------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
-- Trigger:    	tU_AccountingPeriod        Copyright 2013 OpenLink
-- Overview:    DocumentScriptFunctionality
-- Indexes: 	ListAnyIndexesOrOptimizerHintsUsed
-- SPs:  	ListAnyStoredProcedures
-- Tables:	ListAnyTablesUsed
-- Created by:  tU_AccountingPeriod
-- History:    	8/10/99 - First Created - RAID #12389
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	08/10/1999      Denton Newham	12389	First Created	
-- 	01/28/2002	HMD		24749	Allow updates to ShowInDropDown even if the period is complete
--      02/11/2002      TRB                     Publish Accounting Period Closed message when accounting period is being updated
--	2013-06-18		A.L.Yowell			SQL2012 Syntax change on RAISERROR
---------------------------------------------------------------------------------------------------------------------
Declare	 @i_AccntngPrdID	Int
Declare  @vc_arguments 		VarChar(2000)
----------------------------------------------------------- 
-- Restrict Updates on every column except AccntngPrdCmplte
-- AND ShowInDropDown (Added 01/28/2002 HMD 24749)
-----------------------------------------------------------
If Not Update(AccntngPrdCmplte) and not Update(CloseDate)
Begin
	If Not Update(ShowInDropDown) and Not Update(ArchiveStatus)
	Begin
		----------------------------------------------------------- 
		-- Check to see if an AccountingPeriod that is being updated is complete
		-----------------------------------------------------------
		If Exists (	select 'x'
				from	Deleted
				where	AccntngPrdCmplte = 'Y'	)
		Begin
			----------------------------------------------------------- 
			-- Disallow update of closed AccountingPeriod
			-----------------------------------------------------------
		 	Select @errno = 91000
	            	Select @errmsg = 'You may not update this "AccountingPeriod" because it has been marked complete.'
	            	goto error
		End
		Else If Exists (	select	'x'
					from	Deleted
					inner join BusinessAssociateClosed /*BusinessAssociateClosed(NoLock)???*/ on BAClsdAccntngPrdID = AccntngPrdID	)
		Begin
			----------------------------------------------------------- 
			--  Disallow update if a Business Associate is already closed in the Accounting Period 
			-----------------------------------------------------------
			Select @errno = 92000
	            	Select @errmsg = 'You may not update this "AccountingPeriod" because at least one "BusinessAssociate" is closed in it.'
	            	goto error
		End
		Else
		Begin
			----------------------------------------------------------- 
			-- Null out the AccountingPeriod for any AccountDetail and InventoryReconcile records that have one of the AccntngPrdID's being updated
			-----------------------------------------------------------
			Update 	AccountDetail
	      		Set   	AcctDtlAccntngPrdID = NULL
			From	Deleted
	      		Where	AcctDtlAccntngPrdID = AccntngPrdID
	
			Update 	InventoryReconcile
	      		Set   	InvntryRcncleClsdAccntngPrdID = NULL
			From	Deleted
	      		Where	InvntryRcncleClsdAccntngPrdID = AccntngPrdID
		End
	End
End


If Update(AccntngPrdCmplte)
Begin
	
	If ( 	Select	count(*) 
		From	inserted i
		inner join AccountingPeriod ap /*AccountingPeriod(NoLock)???*/ on ap.AccntngPrdCmplte = 'Y'
		where	i.AccntngPrdID < ap.AccntngPrdID	) > 0 
	Begin
	 	Select @errno = 92000
	    	Select @errmsg = 'You may not update this "AccountingPeriod" because this is not the most recently closed Accounting Period.'
	    	goto error
	End
	
	If (	select 	count(*) 
		from 	inserted i
		inner join deleted d on i.AccntngPrdID = d.AccntngPrdID
		where	i.AccntngPrdCmplte = 'N'
		And		d.AccntngPrdCmplte = 'Y') > 0 
	Begin
		
		Select	@i_AccntngPrdID	= AccntngprdID + 1	From Inserted
		select 	@vc_arguments = 'accntngprdid=' + Convert(VarChar,@i_AccntngPrdID) + ',updatevalue=N,distribute=Y'
		Execute sp_MTV_RAMQ_publish 'AccountingPeriod Closed Motiva',@vc_arguments 

		Update	ap
		Set	CloseDate = Null
		from	inserted i
		Inner Join AccountingPeriod ap on i.AccntngPrdID = ap.AccntngPrdID
		

	End
-- 2013-06-20 A.L.Yowell	converted select statement to ANSI SQL
	Else If (select count(*) 
		from 	inserted i
		inner join deleted d on i.AccntngPrdID = d.AccntngPrdID
		Where	i.AccntngPrdCmplte = 'Y'
		And		d.AccntngPrdCmplte = 'N') > 0 
	Begin
		Select	@i_AccntngPrdID	= AccntngprdID + 1	From Inserted
		select 	@vc_arguments = 'accntngprdid=' + Convert(VarChar,@i_AccntngPrdID) + ',updatevalue=Y,distribute=Y'
	
		Execute sp_MTV_RAMQ_publish 'AccountingPeriod Closed Motiva',@vc_arguments 

		Update	ap
		Set	CloseDate = current_timestamp
		from	inserted i
		Inner Join AccountingPeriod ap on i.AccntngPrdID = ap.AccntngPrdID

	End

End

Execute sp_update_cache_date 'AccountingPeriod'


-----------------------------------------------------------------------------------------------------
-- End Custom RI Code
-----------------------------------------------------------------------------------------------------

noerror:
	return
error:
	RAISERROR (N'%s %d',11,1,@errmsg,@errno)
	rollback transaction
end

