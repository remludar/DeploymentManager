/****** Object:  ViewName [dbo].[MTVPetroExStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVElemicaStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVElemicaStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		exec SRA_Drop_Table @s_table='MTVElemicaStaging',@onlySQL='N',@verbose='Y';
	End
GO
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVElemicaStaging',
@s_sql=' (
MESID				int				Identity,
RAMvtDcmntBAID		int				NULL,
RAMvtDcmntDte		datetime	NULL,
RALcleID			int				NULL,
RAPrdctID			int				NULL,
RAMvtHdrDte			datetime	NULL,
RAMvtHdrQty			float			NULL,
RAMvtHdrGrssQty		float			NULL,
RAMvtHdrDsplyUOM	smallint		NULL,
RAMvtHdrGrvty		float			NULL,
RAMvtHdrTemp		float			NULL,
RAMvtHdrTempScale	char(1)		NULL,
RAMvtHdrOrgnLcleID	int				NULL,
RAMvtHdrDstntnLcleID	int			NULL,
RAMvtHdrTyp			char(1)			NULL,
RAMvtHdrEstmte		char(1)			NULL,
RAMvtHdrMtchngStts	char(1)			NULL,
RATemplateName			varchar(80)		NULL,
RAMvtHdrExternalDocNo	varchar(80)		NULL,
RAMvtHdrLftngNmbr		varchar(30)		NULL,
RAMvtPurchaseOrder		varchar(30)		NULL,
RAMvtRcptBAID			int				NULL,
RAMvtDlvryBAID			int				NULL,
RAMvtRctDlHdrID			int				NULL,
RAMvtRctDlDtlID			smallint		NULL,
RAMvtDlvryDlHdrID		int				NULL,
RAMvtDlvryDlDtlID		smallint		NULL,
RAMvtHdrCrrrBAID		int				NULL,
RAMvtHdrNote			varchar(MAX)	NULL,
RAMvtPlnndMvtID			int				NULL,
MvtHdrMvtDcmntID		int				NULL,
MvtHdrID				int				NULL,
TicketNumber      varchar(50)  NULL,
PurposeIndicator      varchar(20)  NULL,
TicketVersion      float  NULL, 
TransportEvent      varchar(30)  NULL,
CustodyLocationIndentifier      varchar(10)  NULL,
CustodyLocationDescription      varchar(80)  NULL,
TankNumber      varchar(10)  NULL,
PipelineLineNumber      varchar(10)  NULL,
CarrierPartnerIdentifier      varchar(10)  NULL,
CarrierPartnerName      varchar(80)  NULL,
CarrierAddressLine      varchar(50)  NULL,
CarrierCityName      varchar(50)  NULL,
CarrierStateProvince      varchar(5)  NULL,
CarrierPostalCode      varchar(15)  NULL,
ShipperPartnerIdentifier      varchar(10)  NULL,
ShipperPartnerName      varchar(80)  NULL,
ShipperAddressLine      varchar(50)  NULL,
ShipperCityName      varchar(50)  NULL,
ShipperStateProvince      varchar(5)  NULL,
ShipperPostalCode      varchar(15)  NULL,
SupplierPartnerIdentifier      varchar(10)  NULL,
SupplierPartnerName      varchar(80)  NULL,
TankagePartnerIdentifier      varchar(10)  NULL,
TankagePartnerName      varchar(80)  NULL,
ConsigneePartnerIdentifier      varchar(10)  NULL,
ConsigneePartnerName      varchar(80)  NULL,
CustodyTicketNumber      varchar(20)  NULL,
CarrierTicketType      varchar(10)  NULL,
BatchNumber      varchar(20)  NULL,
CustodyTicketDateTime      datetime  NULL, 
CustodyTransferStartDateTime      datetime  NULL, 
CustodyTransferStopDateTime      datetime  NULL, 
CustodyTicketComment      varchar(MAX)  NULL,
Product      varchar(30)  NULL,
ProductDescription      varchar(80)  NULL,
NetVolume      varchar(30)  NULL,
NetVolumeUOM      varchar(10)  NULL,
GrossVolume      varchar(30)  NULL,
GrossVolumeUOM      varchar(10)  NULL,
OpenDate      datetime  NULL, 
CloseDate      datetime  NULL, 
ObservedGravity      float  NULL, 
ObservedTemperature      float  NULL, 
ObservedTemperatureUOM      varchar(10)  NULL,
CorrectedGravity      float  NULL, 
AverageTemperature      float  NULL, 
AveragePressure      float  NULL, 
AverageFlowRate      float  NULL, 
AverageFlowRateUOM      varchar(10)  NULL,
TemperatureCorrected      float  NULL, 
PressureCorrected      float  NULL, 
CompositeFactor      varchar(30)  NULL,
MeterQuantity      varchar(30)  NULL,
MeterQuantityUOM      varchar(10)  NULL,
ProverReport      varchar(MAX)  NULL,
MeterFactor      float  NULL, 
MeterDistributionPercent      float  NULL, 
Statements      varchar(MAX)  NULL,
TransportMethodCode varchar(50) NULL,
TransportContainer varchar(50) NULL,
TransferFromPartnerIdentifier varchar(10) NULL,
TransferFromPartnerName varchar(80) NULL,
TransferToPartnerIdentifier varchar(10) NULL,
TransferToPartnerName varchar(80) NULL,
OriginalMessageXml		varchar(Max)	NULL,
Action					varchar(10)		NULL,
TicketStatus			char(1)			NULL,
InterfaceMessage		varchar(MAX)	NULL,
InterfaceFile			varchar(255)	NULL,
InterfaceID				varchar(20)		NULL,
ImportDate				smalldatetime	Not Null Default Current_TimeStamp,
ModifyDate				smalldatetime	Null, 
UserId					int,
ProcessedDate			smalldatetime	NULL
	)';
GO

Execute SRA_Index_Check @s_table	= 'MTVElemicaStaging', 
				    @s_index		= 'PK_MTVElemicaStaging_ID',
				    @s_keys			= 'MESID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO
Execute SRA_Index_Check @s_table	= 'MTVElemicaStaging', 
				    @s_index		= 'PK_MTVElemicaStaging_BOL',
				    @s_keys			= 'TicketNumber',
				    @c_unique		= 'N',
				    @c_clustered	= 'Y',
				    @c_primarykey	= 'N',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO
SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVElemicaStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVElemicaStaging.sql'
    PRINT '<<< CREATED TABLE MTVElemicaStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVElemicaStaging >>>'

