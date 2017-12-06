/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVManulMovementUpload WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVManulMovementUpload]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVManulMovementUpload.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVManulMovementUpload]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVManulMovementUpload]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVManulMovementUpload]
    PRINT '<<< DROPPED TABLE MTVManulMovementUpload >>>'
END


/****** Object:  Table [dbo].[MTVManulMovementUpload]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MTVManulMovementUpload
(
MMMUID			INT IDENTITY
,IssuedBy		VARCHAR(80)
,IssuedByID		INT
,BOLNumber		VARCHAR(80)
,MovementLocation	VARCHAR(80)
,RAOriginID		INT
,TaxOrigin		VARCHAR(80)
,RATaxOriginID	INT
,TaxDestination	VARCHAR(80)
,RATaxDestID	INT
,Product		VARCHAR(80)
,RAPrdctID		INT
,GrossQuantity	VARCHAR(80)
,NetQuantity	VARCHAR(80)
,MovementDate	SMALLDATETIME
,MovementType	VARCHAR(80)
,MovementTypeID	VARCHAR(1)
,Carrier		VARCHAR(80)
,RACarrierID	INT
,UOM			VARCHAR(8)
,RAUOMID		INT
,TemplateName	VARCHAR(80)
,LiftingNumber	VARCHAR(80)
,ReceiptDeal	VARCHAR(80)
,ReceiptDlHdrId	INT
,ReceiptDealDtl	VARCHAR(80)
,DeliveryDeal	VARCHAR(80)
,DeliveryDlHdrId INT
,DeliveryDealDtl VARCHAR(80)
,TicketStatus	CHAR(1)
,ErrorMessage	VARCHAR(MAX)
,LoadedDate		SMALLDATETIME
,RAMvmntDctId	INT
	
 CONSTRAINT [PK_MTVManulMovementUpload] PRIMARY KEY CLUSTERED 
(
	[MMMUID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVManulMovementUpload]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVManulMovementUpload.sql'
    PRINT '<<< CREATED TABLE MTVManulMovementUpload >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVManulMovementUpload >>>'

