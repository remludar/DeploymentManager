-----------------------------------------------------------------------------------------------------------------------------
-- Name			:sd_Close_AccountingPeriods
-- Overview		:
-- Created by	:Phani Durbhakula
-- History		:3/19/2010 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--  09/26/2012		AK						Close thru (inclusive) Dec 2012 (AccntngPrdID=276)
--  2012 11 21      B. Shelton              Set Display flag to 'N' for AcctPds that are already closed.  This script
--                                          assumes that AccntngPrdIDs are arranged in sequential order from earliest to latest
------------------------------------------------------------------------------------------------------------------------------

declare @i_AccntngPrdID int = 299 -- Nov 2014, this AcctPd will be closed
--select * from accountingperiod

-- Obscure Acctg Pds that are already closed
declare @i_DisplayAcctgPd int

select @i_DisplayAcctgPd = (select max(AccntngPrdID)
                            from AccountingPeriod
                            where AccntngPrdCmplte = 'Y'
                              and ShowInDropDown = 'Y')
while (    (select max(AccntngPrdID)
              from AccountingPeriod
             where AccntngPrdCmplte = 'Y'
               and ShowInDropDown = 'Y')                      <= @i_DisplayAcctgPd)
Begin

Update AccountingPeriod
Set ShowInDropDown	= 'N'
where AccntngPrdID in (Select min(AccntngPrdID)
                         from AccountingPeriod
                        where AccntngPrdCmplte = 'Y'
                          and ShowInDropDown = 'Y')
End

-- Close and Obscure Accounting Periods that aren't relevant
while (    (select max(AccntngPrdID)
              from AccountingPeriod
             where AccntngPrdCmplte = 'Y')                      < @i_AccntngPrdID)
Begin

Update AccountingPeriod
Set AccntngPrdCmplte = 'Y', ShowInDropDown	= 'N'
where AccntngPrdID in (Select min(AccntngPrdID)
                         from accountingperiod
                        where AccntngPrdCmplte = 'N')

End