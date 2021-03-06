/****** Object:  Trigger [dbo].[tu_DealDetailProvisionRow_MTV]    Script Date: 5/14/2016 12:41:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


IF OBJECT_ID('dbo.tu_DealDetailProvisionRow_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_DealDetailProvisionRow_MTV
    IF OBJECT_ID('dbo.tu_DealDetailProvisionRow_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_DealDetailProvisionRow_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_DealDetailProvisionRow_MTV >>>'
  END
go

CREATE trigger [dbo].[tu_DealDetailProvisionRow_MTV] on [dbo].[DealDetailProvisionRow] AFTER UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       tu_DealDetailProvisionRow_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom update trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of what changed on a DealDetailProvisionRow record
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
       ,@i_TxRleStID       int
       ,@i_UserID          int
       ,@vc_User           varchar(80)
	   ,@vc_PriceAttribute  varchar(20)
	   ,@i_PrvsnAttId int


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
           join TaxProvision (nolock)
                on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
           join TaxRuleSet (nolock)
                on TaxProvision.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End

-- Insert a record into the MTV_TaxAudit table for each updated field on each changed record

-- Determine the first changed record to process
--Select @i_DlDtlPrvsnRwID = Min(Inserted.DlDtlPrvsnRwID)
--From   Inserted (nolock)
--       join TaxProvision (nolock)
--            on Inserted.DlDtlPrvsnID = TaxProvision.DlDtlPrvsnID
--drop table [dbo].[#MTV_DealDetailPrvsnAttribute]

   CREATE TABLE [dbo].[#MTV_DealDetailPrvsnAttribute](
					[DlDtlPnAttrDlDtlPnDlDtlDlHdrID] [int] NULL,
					[DlDtlPnAttrDlDtlPnDlDtlID] [int] NULL,
					[DlDtlPnAttrDlDtlPnID] [int] NOT NULL,
					[DlDtlPnAttrPrvsnAttrTpeID] [smallint] NOT NULL,
					[OldDlDtlPnAttrdta] [varchar](80) NULL,
					[NewDlDtlPnAttrdta] [varchar](80) NULL,
					[DlDtlPnAttrDtaTpe] [char](1) NOT NULL,
					[RowNumber] [int] NOT NULL
					)

	Insert Into #MTV_DealDetailPrvsnAttribute 
	( 
	DlDtlPnAttrDlDtlPnDlDtlDlHdrID,
	DlDtlPnAttrDlDtlPnDlDtlID,
	DlDtlPnAttrDlDtlPnID,
	DlDtlPnAttrPrvsnAttrTpeID,
	OldDlDtlPnAttrdta,
	NewDlDtlPnAttrdta,
	DlDtlPnAttrDtaTpe,
	RowNumber
	)

	(Select 	ddp.DlDtlPrvsnDlDtlDlHdrID DlDtlPnAttrDlDtlPnDlDtlDlHdrID,
				ddp.DlDtlPrvsnDlDtlID DlDtlPnAttrDlDtlPnDlDtlID,
				Del.DlDtlPrvsnID DlDtlPnAttrDlDtlPnID,
				rpat.RqrdPrvsnAttrTpePrvsnAttrTpeID DlDtlPnAttrPrvsnAttrTpeID,
	case rpat.ColumnName	when 'PriceAttribute1' then Del.PriceAttribute1
							when 'PriceAttribute2' then Del.PriceAttribute2
							when 'PriceAttribute3' then Del.PriceAttribute3
							when 'PriceAttribute4' then Del.PriceAttribute4
							when 'PriceAttribute5' then Del.PriceAttribute5
							when 'PriceAttribute6' then Del.PriceAttribute6
							when 'PriceAttribute7' then Del.PriceAttribute7
							when 'PriceAttribute8' then Del.PriceAttribute8
			end OldDlDtlPnAttrdta,
	case rpat.ColumnName	when 'PriceAttribute1' then Ins.PriceAttribute1
							when 'PriceAttribute2' then Ins.PriceAttribute2
							when 'PriceAttribute3' then Ins.PriceAttribute3
							when 'PriceAttribute4' then Ins.PriceAttribute4
							when 'PriceAttribute5' then Ins.PriceAttribute5
							when 'PriceAttribute6' then Ins.PriceAttribute6
							when 'PriceAttribute7' then Ins.PriceAttribute7
							when 'PriceAttribute8' then Ins.PriceAttribute8
			end NewDlDtlPnAttrdta,
		'Z' DlDtlPnAttrDtaTpe,
		Del.RowNumber
	From 	DealDetailProvision ddp /*DealDetailProvision(NoLock)???*/ 
		inner join Deleted Del on Del.DlDtlPrvsnID = ddp.DlDtlPrvsnID and Del.DlDtlPRvsnRwTpe = 'A'
		inner join Inserted Ins on Ins.DlDtlPrvsnID = ddp.DlDtlPrvsnID and Del.DlDtlPRvsnRwTpe = 'A'
		inner join RequiredPrvsnAttributeType rpat /*RequiredPrvsnAttributeType(NoLock)???*/ on rpat.RqrdPrvsnAttrTpePrvsnID = ddp.DlDtlPrvsnPrvsnID
	Where  DDP.TmplteSrceTpe = 'TX'	) --->  'Tx' is for taxes
		--Where ddp.DlDtlPrvsnDlDtlDlHdrID is null) ---> the null if for taxes

   CREATE TABLE #MTVTemp 
   (
    ID int identity(1,1) 
   ,DlDtlPrvsnId int
   ,TxRleSetId int
   ,EntityChanged varchar(40)
   ,OldData varchar(20)
   ,NewData varchar(20)
   ,HasUpdate bit
    ,PrvsnDateFrom smalldatetime
   ,PrvsnDateTo smalldatetime
   )
   
    Insert into #MTVTemp (DlDtlPrvsnId, TxRleSetId, EntityChanged, OldData, NewData, HasUpdate, PrvsnDateFrom,PrvsnDateTo)
	Select DDPR.DlDtlPrvsnId, TP.TxRleStID, PAT.PrvsnAttrTpeDscrptn, DDPA.OldDlDtlPnAttrdta, DDPA.NewDlDtlPnAttrdta, case when DDPA.OldDlDtlPnAttrdta <> DDPA.NewDlDtlPnAttrdta then 1 else 0 end, DDP.DlDtlPrvsnFrmDte, DDP.DlDtlPrvsnFrmDte
	from Deleted DDPR
	inner join DealDetailProvision DDP 
		on DDP.DlDtlPrvsnId = DDPR.DlDtlPrvsnId
	inner join #MTV_DealDetailPrvsnAttribute DDPA 
		on DDPA.DlDtlPnAttrDlDtlPnID = DDP.DlDtlPrvsnId
	--inner join INSERTED InsDDPR
		--on InsDDPR.DlDtlPrvsnId = DDPA.DlDtlPnAttrDlDtlPnID
	inner join PrvsnAttributeType PAT 
		on PAT.PrvsnAttrTpeID =  DDPA.DlDtlPnAttrPrvsnAttrTpeID 
	inner join TaxProvision TP 
		on TP.DlDtlPrvsnID = DDP.DlDtlPrvsnID
	Where  DDP.TmplteSrceTpe = 'TX' ---> this is for tax provisions
     and   DDPA.OldDlDtlPnAttrdta <> DDPA.NewDlDtlPnAttrdta 


	Select @i_PrvsnAttId = Min(ID)
	From   #MTVTemp (nolock)
	Where HasUpdate = 1
	
   While @i_PrvsnAttId IS NOT NULL
   Begin

	declare @entity varchar(40)
	select @entity = EntityChanged from #MTVTemp where ID = @i_PrvsnAttId

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
		 ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Name from TaxRateName where  TRY_CONVERT(int,  OldData) IS NOT NULL and TaxRateName.TaxRateNameID = CAST( OldData as int)) 
				when EntityChanged like '%Product Group%' then (select top 1 Sort from  P_PositionGroupFlat where TRY_CONVERT(int,  OldData) IS NOT NULL and ChldP_PstnGrpID = OldData)
				else OldData end) 
		  ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Name from TaxRateName where  TRY_CONVERT(int,  NewData) IS NOT NULL and TaxRateName.TaxRateNameID = CAST( NewData as int)) 
				 when EntityChanged like '%Product Group%' then (select top 1 Sort from  P_PositionGroupFlat where TRY_CONVERT(int,  OldData) IS NOT NULL and ChldP_PstnGrpID = NewData)
				 else NewData end)

    From   #MTVTemp (nolock)
    Where  #MTVTemp.ID = @i_PrvsnAttId
	
	if @entity like '%Tax Rate%' 
	begin
	  Insert #Audit
    ( TxRleStID
     ,DlDtlPrvsnID
     ,EntityChanged
     ,OldValue
     ,NewValue
    )
	Select TxRleSetId
          ,DlDtlPrvsnId
		  --,'Tax Rate'
		  ,(CASE WHEN EntityChanged like '%Tax Rate%' THEN REPLACE(EntityChanged, 'Name', '') ELSE EntityChanged END)

		  ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Rate from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
			                                                where  TRY_CONVERT(int,  OldData) IS NOT NULL and TaxRateDetail.TaxRateNameID = CAST( OldData as int)
															AND   (TaxRateDetail.FromDate >=  #MTVTemp.PrvsnDateFrom) 
															--AND   (CAST(TaxRateDetail.FromDate as date) <= cast(#MTVTemp.PrvsnDateFrom as date))
															) 
		     else OldData end)
		  ,(case when EntityChanged like '%Tax Rate%' then (select top 1 Rate from TaxRateDetail inner join TaxRateName on TaxRateName.TaxRateNameID = TaxRateDetail.TaxRateNameID 
			                                                where  TRY_CONVERT(int,  NewData) IS NOT NULL and TaxRateDetail.TaxRateNameID = CAST( NewData as int)
															AND   (TaxRateDetail.FromDate >=  #MTVTemp.PrvsnDateFrom) 
														     --AND   (CAST(TaxRateDetail.ToDate as date) <= cast(#MTVTemp.PrvsnDateTo as date))
															)
		     else NewData end)
    From   #MTVTemp (nolock)
    Where  #MTVTemp.ID = @i_PrvsnAttId
	end

	NextRecord:

    -- Process the next inserted record
		Select @i_PrvsnAttId = Min(ID)
	    From   #MTVTemp (nolock)
		where #MTVTemp.ID > @i_PrvsnAttId and HasUpdate = 1
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
	Order By #Audit.Idnty

	Drop Table #Audit
	Drop table #MTVTemp
	Drop Table #MTV_DealDetailPrvsnAttribute
	return
End
Go

IF OBJECT_ID('dbo.tu_DealDetailProvisionRow_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_DealDetailProvisionRow_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_DealDetailProvisionRow_MTV >>>'

Go