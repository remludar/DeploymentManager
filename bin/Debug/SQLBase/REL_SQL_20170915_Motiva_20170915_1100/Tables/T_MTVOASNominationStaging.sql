---Start of Script: T_MTVOASNominationStaging.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

BEGIN TRANSACTION

Print 'Start Script=T_MTVOASNominationStaging.sql  Domain=MPC  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

		Create Table	dbo.tmp_MTVOASNominationStaging
						(ID						int			Identity 
						,PlnndMvtID				int			not null
						,PlnndTrnsfrID			int			not null
						,OrderName				varchar(80)	not null
						,DlHdrID				int			not null
						,DlDtlID				int			not null
						,DealDetailID			int			not null
						,DealNumber				varchar(20)	not null
						,DealTypeID				int			null
						,Status					char(1)		not null
						,ErrorMessage			varchar(max)	null
						,Action					char(1)		not null
						,RDIndicator			char(1)		not null
						,ERPScheduleItemType	char(1)		null
						,RAShipmentType			char(1)		null
						,ShipmentType			varchar(2)		null
						,NodeType				varchar(2)	null
						,ExternalBatch			varchar(25)	null
						,TransportID			varchar(40)	null
						,CompanyID				varchar(50)	null
						,ETA					DateTime	null
						,LaycanStart			Datetime	null
						,LaycanEnd				datetime	null
						,RASiteLcleID			int			null
						,Site					varchar(50)	null
						,RALoadPortLcleID		int			null
						,LoadingPortCode		varchar(50)	null
						,RAReceivingPortLcleID	int			null
						,ReceivingPortCode		varchar(50)	null
						,InternalBA				int			null
						,ExternalBA				int			null
						,Consignee				varchar(50)	null
						,Consignor				varchar(50) null
						,TransactionCode		varchar(10)	null
						,LoadFromDate			datetime	null
						,LoadToDate				datetime	null
						,DischargeFromDate		datetime	null
						,DischargeToDate		datetime	null
						,RAProductID			int			not null
						,CommercialGradeID		varchar(50)	null
						,NomQty					float		null
						,RAUOMID				int			null
						,UOM					varchar(20)	null
						,MinQty					float		null
						,MaxQty					float		null
						,CreateDate				datetime	not null
						,ModifiedDate			datetime	null
						,UserID					int			null
						,ProcessedDate			datetime	null
						)	On 'Default'

						
SET IDENTITY_INSERT dbo.tmp_MTVOASNominationStaging ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASNominationStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVOASNominationStaging)
        EXEC('
            INSERT  dbo.tmp_MTVOASNominationStaging (
                    ID						
					,PlnndMvtID				
					,PlnndTrnsfrID			
					,OrderName				
					,DlHdrID				
					,DlDtlID				
					,DealDetailID			
					,DealNumber				
					,DealTypeID				
					,Status					
					,ErrorMessage			
					,Action					
					,RDIndicator			
					,ERPScheduleItemType	
					,RAShipmentType			
					,ShipmentType			
					,NodeType				
					,ExternalBatch			
					,TransportID			
					,CompanyID				
					,ETA					
					,LaycanStart			
					,LaycanEnd				
					,RASiteLcleID			
					,Site					
					,RALoadPortLcleID		
					,LoadingPortCode		
					,RAReceivingPortLcleID	
					,ReceivingPortCode		
					,InternalBA				
					,ExternalBA				
					,Consignee				
					,Consignor				
					,TransactionCode		
					,LoadFromDate			
					,LoadToDate				
					,DischargeFromDate		
					,DischargeToDate		
					,RAProductID			
					,CommercialGradeID		
					,NomQty					
					,RAUOMID				
					,UOM					
					,MinQty					
					,MaxQty					
					,CreateDate				
					,ModifiedDate			
					,UserID					
					,ProcessedDate			
                    )
            Select  ID						
					,PlnndMvtID				
					,PlnndTrnsfrID			
					,OrderName				
					,DlHdrID				
					,DlDtlID				
					,DealDetailID			
					,DealNumber				
					,DealTypeID				
					,Status					
					,ErrorMessage			
					,Action					
					,RDIndicator			
					,ERPScheduleItemType	
					,RAShipmentType			
					,ShipmentType			
					,NodeType				
					,ExternalBatch			
					,TransportID			
					,CompanyID				
					,ETA					
					,LaycanStart			
					,LaycanEnd				
					,RASiteLcleID			
					,Site					
					,RALoadPortLcleID		
					,LoadingPortCode		
					,RAReceivingPortLcleID	
					,ReceivingPortCode		
					,InternalBA				
					,ExternalBA				
					,Consignee				
					,Consignor				
					,TransactionCode		
					,LoadFromDate			
					,LoadToDate				
					,DischargeFromDate		
					,DischargeToDate		
					,RAProductID			
					,CommercialGradeID		
					,NomQty					
					,RAUOMID				
					,UOM					
					,MinQty					
					,MaxQty					
					,CreateDate				
					,ModifiedDate			
					,UserID					
					,ProcessedDate
            FROM    MTVOASNominationStaging
            WITH    (HOLDLOCK TABLOCKX)')
            
    IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End
GO
SET IDENTITY_INSERT dbo.tmp_MTVOASNominationStaging OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASNominationStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVOASNominationStaging
    PRINT '<<< DROPPED TABLE MTVOASNominationStaging >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVOASNominationStaging', N'MTVOASNominationStaging', 'OBJECT' 
GO

ALTER TABLE dbo.MTVOASNominationStaging WITH NOCHECK ADD
CONSTRAINT [PK_MTVOASNominationStaging] PRIMARY KEY CLUSTERED (ID)
GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVOASNominationStaging') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVOASNominationStaging >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVOASNominationStaging to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVOASNominationStaging>>>'
GO


COMMIT TRANSACTION