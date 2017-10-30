
/****** Object:  Trigger [ti_DealDetailProvisionRow_MTV]    Script Date: 5/17/2016 8:29:50 AM ******/
IF OBJECT_ID('dbo.ti_DealDetailProvisionRow_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.ti_DealDetailProvisionRow_MTV
    IF OBJECT_ID('dbo.ti_DealDetailProvisionRow_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.ti_DealDetailProvisionRow_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.ti_DealDetailProvisionRow_MTV >>>'
  END
go



/****** Object:  Trigger [dbo].[ti_DealDetailProvisionRow_MTV]    Script Date: 5/17/2016 8:29:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE trigger [dbo].[ti_DealDetailProvisionRow_MTV] on [dbo].[DealDetailProvisionRow] AFTER INSERT as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       ti_DealDetailProvisionRow_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom insert trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of new DealDetailProvisionRow records
-- Created by: Eric Wallerstein
-- History:    06/18/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/18/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
--                                          LoginInformation table, we won't bother to look there for Revision User information;
--                                          instead, we'll check first to see if we can tell if the SPID is attached to a
--                                          RightAngle application (PB or .NET) -- if so, we'll get the Revision User from the
--                                          TaxRuleSet table; otherwise we'll get it from the SYSTEM_USER SQL property
--                                          ** NOTE: if the names of the RightAngle applications change, this check will need to change also **
--  06/25/2012    E.Wallerstein           Because this trigger was relying on the TaxProvision table to be able to determine the
--                                          TxRleStID and the last revision user associated with the TaxRuleSet, and because the TaxProvision
--                                          record isn't created until AFTER this Insert into DealDetailProvision has completed, we will
--                                          need to allow a NULL to be written as the TxRleStID, UserID, and UserDBMnkr; another custom Insert trigger
--                                          on the TaxProvision table will follow behind and update these NULL entries with the correct
--                                          information; for these same reasons, in our looping we will now rely on the TmplteSrceTble being
--                                          'TX' instead of joining to the TaxProvision table
--  07/09/2012    E.Wallerstein           After more analysis, we found that deleted records from the LoginInformation table are archived
--                                          in the LoginInformationArchive table; after determining that the SPID is attached to a RightAngle
--                                          application, we should be able to look in the LoginInformation table for the SPID and then
--                                          look in the LoginInformationArchive table for the latest login date associated with the SPID if the
--                                          record wasn't found in the LoginInformation table
--                                          ** NOTE: this will only work for the PowerBuilder side, since the SPID logged for the .NET side is currently
--                                                   just the UserID * 1000
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON 

Declare @i_DlDtlPrvsnRwID  int
		,@i_PrvsnAttId int
       ,@i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
 ,DlDtlPrvsnID   int
 ,EntityChanged  varchar(200)
 ,OldValue       varchar(max)
 ,NewValue       varchar(max)
)


--
-- Determine the Revision User ID from RightAngle (or from SQL Server if the change is happening outside of RightAngle)
--

-- if the SPID isn't tied to a RightAngle application, get the name of the user currently logged into SQL Server
-- because the update most likely came directly from a SQL Server Management Studio session
-- ** NOTE: if the RightAngle application names change, this check will need to be updated **
if (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) NOT In ('.Net SqlClient Data Provider', 'Right Angle IV')
  Select @vc_User = System_User

-- if the user name is NULL, that measns the update DID come from a RightAngle application, so attempt to get the UserDBMnkr and UserID
-- from the LoginInformation or LoginInformationArchive table (will only work for the PowerBuilder SRA application, since
-- the .NET application does not store an actual SPID in the SPID field -- it stores UserID * 1000)
if @vc_User is NULL and (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) = 'Right Angle IV'
  Begin
    Select @vc_User = LoginInformation.UserDBMnkr
          ,@i_UserID = LoginInformation.UserID
    From   LoginInformation (nolock)
    Where  LoginInformation.SPID = @@SPID

    -- if the user name is still NULL, try looking for the last record associated with the SPID in the LoginInformationArchive table
    if @vc_User is NULL
      Begin
        Select Top 1 @vc_User = LoginInformationArchive.UserDBMnkr
                    ,@i_UserID = LoginInformationArchive.UserID
        From   LoginInformationArchive (nolock)
        Where  LoginInformationArchive.SPID = @@SPID
        Order By LoginInformationArchive.LoginDate desc
      End
  End

-- if the user name is still NULL, that means the lookup in the LoginInformation (or LoginInformationArchive) table failed,
-- so get the the Revision User off the TaxRuleSet record
if @vc_User is NULL
	  Begin
		Select Top 1 @vc_User  = Users.UserDBMnkr
					,@i_UserID = TaxRuleSet.RevisionUserID
		From   Inserted (nolock)
			   left join TaxProvision (nolock)
					on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
			   left join TaxRuleSet (nolock)
					on TaxProvision.TxRleStID = TaxRuleSet.TxRleStID
			   left join Users (nolock)
					on TaxRuleSet.RevisionUserID = Users.UserID
	  End


	  -- Insert a record into the MTV_TaxAudit table for each field on each inserted record

      CREATE TABLE #DealDetailPrvsnAttribute(
					[DlDtlPnAttrDlDtlPnDlDtlDlHdrID] [int] NULL,
					[DlDtlPnAttrDlDtlPnDlDtlID] [int] NULL,
					[DlDtlPnAttrDlDtlPnID] [int] NOT NULL,
					[DlDtlPnAttrPrvsnAttrTpeID] [smallint] NOT NULL,
					[DlDtlPnAttrDta] [varchar](80) NULL,
					[DlDtlPnAttrDtaTpe] [char](1) NOT NULL,
					[RowNumber] [int] NOT NULL
					--[Approved] [char](1) NOT NULL,
					--[LcleID] [int] NULL
					)

	Insert Into #DealDetailPrvsnAttribute 
	( 
		DlDtlPnAttrDlDtlPnDlDtlDlHdrID,
		DlDtlPnAttrDlDtlPnDlDtlID,
		DlDtlPnAttrDlDtlPnID,
		DlDtlPnAttrPrvsnAttrTpeID,
		DlDtlPnAttrdta,
		DlDtlPnAttrDtaTpe,
		RowNumber
		--Approved,
		--LcleID
	)
	(Select ddp.DlDtlPrvsnDlDtlDlHdrID DlDtlPnAttrDlDtlPnDlDtlDlHdrID,
			ddp.DlDtlPrvsnDlDtlID DlDtlPnAttrDlDtlPnDlDtlID,
			Ins.DlDtlPrvsnID DlDtlPnAttrDlDtlPnID,
			rpat.RqrdPrvsnAttrTpePrvsnAttrTpeID DlDtlPnAttrPrvsnAttrTpeID,
	case	rpat.ColumnName when 'PriceAttribute1' then Ins.PriceAttribute1
							when 'PriceAttribute2' then Ins.PriceAttribute2
							when 'PriceAttribute3' then Ins.PriceAttribute3
							when 'PriceAttribute4' then Ins.PriceAttribute4
							when 'PriceAttribute5' then Ins.PriceAttribute5
							when 'PriceAttribute6' then Ins.PriceAttribute6
							when 'PriceAttribute7' then Ins.PriceAttribute7
							when 'PriceAttribute8' then Ins.PriceAttribute8
					end DlDtlPnAttrDta,
		'Z' DlDtlPnAttrDtaTpe,
		Ins.RowNumber
		--Ins.Approved,
		--Ins.LcleID
	From 	DealDetailProvision ddp /*DealDetailProvision(NoLock)???*/ 
			inner join Inserted Ins on Ins.DlDtlPrvsnID = ddp.DlDtlPrvsnID and Ins.DlDtlPRvsnRwTpe = 'A'
			inner join RequiredPrvsnAttributeType rpat on rpat.RqrdPrvsnAttrTpePrvsnID = ddp.DlDtlPrvsnPrvsnID
	Where  DDP.TmplteSrceTpe = 'TX'	
			)


   create table #MTVTemp 
   (
    ID int identity(1,1) 
   ,DlDtlPrvsnId int
   ,TxRleSetId int
   ,EntityChanged varchar(40)
   ,OldData varchar(20)
   ,NewData varchar(20)
   ,DDPARowNumber int
   ,DDPRRowNumber int
   ,PrvsnDateFrom smalldatetime
   ,PrvsnDateTo smalldatetime
   )

	-- Determine the first inserted record to process
	--Select @i_DlDtlPrvsnRwID = Min(Inserted.DlDtlPrvsnRwID)
	--From   Inserted (nolock)
	--       join DealDetailProvision (nolock)
	--            on Inserted.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
	--Where  DealDetailProvision.TmplteSrceTpe = 'TX' -- tax provision
	
	Insert into #MTVTemp (DlDtlPrvsnId, TxRleSetId, EntityChanged, OldData, NewData, DDPARowNumber, DDPRRowNumber,PrvsnDateFrom,PrvsnDateTo)
	Select DDPR.DlDtlPrvsnId, TP.TxRleStID, PAT.PrvsnAttrTpeDscrptn, '<NEW>', DDPA.DlDtlPnAttrDta, DDPA.RowNumber, DDPR.RowNumber, DDP.DlDtlPrvsnFrmDte, DDP.DlDtlPrvsnFrmDte
	From Inserted DDPR 
	inner join DealDetailProvision DDP 
		on DDP.DlDtlPrvsnId = DDPR.DlDtlPrvsnId
	inner join #DealDetailPrvsnAttribute DDPA 
		on DDPA.DlDtlPnAttrDlDtlPnID = DDPR.DlDtlPrvsnId 
	inner join PrvsnAttributeType PAT 
		on PAT.PrvsnAttrTpeID =  DDPA.DlDtlPnAttrPrvsnAttrTpeID 
	Left join TaxProvision TP 
		on TP.DlDtlPrvsnID = DDP.DlDtlPrvsnID
	Where  DDP.TmplteSrceTpe = 'TX'
	--where DDPR.DlDtlPrvsnRwID=@i_DlDtlPrvsnRwID
	--and DDPA.DlDtlPRvsnRwTpe = 'A'
	--inner join RequiredPrvsnAttributeType rpat 
	--	on rpat.RqrdPrvsnAttrTpePrvsnID = ddp.DlDtlPrvsnPrvsnID
	--where DDPA.RowNumber = DDPR.RowNumber

	Select @i_PrvsnAttId = Min(ID)
	From   #MTVTemp (nolock)
	
    While @i_PrvsnAttId IS NOT NULL
	Begin
		declare @entity varchar(40)
		select @entity = EntityChanged from #MTVTemp where ID = @i_PrvsnAttId

		--- Insert Tax Rate Name
		Insert #Audit
		( TxRleStID
		 ,DlDtlPrvsnID
		 ,EntityChanged
		 ,OldValue
		 ,NewValue
		)
		Select TxRleSetId
			  ,DlDtlPrvsnId	
			  ,EntityChanged
			  ,OldData 
			  -- a change needs to be made here to use a left join to get the tax rate name in the event there is a tax rate name that doesn't have a tax rate detail.
			  ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Name from TaxRateName where  TRY_CONVERT(int,  NewData) IS NOT NULL and TaxRateName.TaxRateNameID = CAST( NewData as int)  
																			--AND   (cast(TaxRateDetail.FromDate as date) BETWEEN  cast(#MTVTemp.PrvsnDateFrom as date) AND  cast(#MTVTemp.PrvsnDateTo as date))
																			--AND   (cast(TaxRateDetail.ToDate as date) BETWEEN cast(#MTVTemp.PrvsnDateFrom as date) AND cast(#MTVTemp.PrvsnDateFrom as date))
																 )
					 when EntityChanged like '%Product Group%' then (select top 1 Sort from  P_PositionGroupFlat where TRY_CONVERT(int,  NewData) IS NOT NULL and ChldP_PstnGrpID = NewData)
					 else NewData end)
		From   #MTVTemp (nolock)
		Where  #MTVTemp.ID = @i_PrvsnAttId
	
	--- Insert Tax Rate
		if @entity like '%Tax Rate%' 
		Begin
			  Insert #Audit
			( TxRleStID
			 ,DlDtlPrvsnID
			 ,EntityChanged
			 ,OldValue
			 ,NewValue
			)
			Select TxRleSetId
				  ,DlDtlPrvsnId
				  ,(CASE WHEN EntityChanged like '%Tax Rate%' THEN REPLACE(EntityChanged, 'Name', '') ELSE EntityChanged END)
				  --,'Tax Rate'
				  ,'<NEW>'
				  ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Rate from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
																	where  TRY_CONVERT(int,  NewData) IS NOT NULL and TaxRateDetail.TaxRateNameID = CAST( NewData as int) 
																	AND   (TaxRateDetail.FromDate >=  #MTVTemp.PrvsnDateFrom) 
																	--AND   (CAST(TaxRateDetail.ToDate as date) <= cast(#MTVTemp.PrvsnDateFrom as date) )
																	)
					else NewData end)
			From   #MTVTemp (nolock)
			Where  #MTVTemp.ID = @i_PrvsnAttId
	    End

		NextRecord:

		-- Process the next inserted record
		Select @i_PrvsnAttId = Min(ID)
		From   #MTVTemp (nolock)
		where #MTVTemp.ID > @i_PrvsnAttId
	End

Insert MTV_TaxAudit
(
	DateModified
	,UserID
	,UserDBMnkr
	,TxRleStID
	,DlDtlPrvsnID
	,TabChanged
	,EntityChanged
	,OldValue
	,NewValue
)
Select Current_TimeStamp
      ,@i_UserID
      ,@vc_User
      ,#Audit.TxRleStID
      ,#Audit.DlDtlPrvsnID
      ,'Provisions'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By
 --#Audit.Idnty,
CASE	WHEN EntityChanged = 'Fixed Tax Rate Name'			THEN 'A'
		WHEN EntityChanged = 'Applicable Portion'			THEN 'B'
		WHEN EntityChanged = 'Applicable Percentage'		THEN 'C'
		WHEN EntityChanged = 'Percent Tax Rate Name'		THEN 'D'
		WHEN EntityChanged = 'Max Price Per Gallon'			THEN 'E'
		WHEN EntityChanged = 'Product Group 1'				THEN 'F'
		WHEN EntityChanged = 'From Quantity'				THEN 'G'
		WHEN EntityChanged = 'To Quantity'					THEN 'H'
		WHEN EntityChanged = 'Flat Tax Rate Name'			THEN 'I'
		WHEN EntityChanged = 'Flat Tax Rate'				THEN 'J'
		WHEN EntityChanged = 'Product Group 2'				THEN 'K'
		WHEN EntityChanged = 'From Quantity 2'				THEN 'L'
		WHEN EntityChanged = 'To Quantity 2'				THEN 'M'
		WHEN EntityChanged = 'Flat Tax Rate Name 2'			THEN 'N'
		WHEN EntityChanged = 'Flat Tax Rate  2'				THEN 'O'
		WHEN EntityChanged = 'Flat Fixed Price 2'			THEN 'P'
		ELSE EntityChanged END



Drop Table #Audit
Drop Table #MTVTemp
Drop Table #DealDetailPrvsnAttribute

return

end

GO


IF OBJECT_ID('dbo.ti_DealDetailProvisionRow_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.ti_DealDetailProvisionRow_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.ti_DealDetailProvisionRow_MTV >>>'
 Go