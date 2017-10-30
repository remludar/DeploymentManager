/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTransferToDataLakeStaging WITH YOUR TABLE (NOTE: Motiva is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTransferToDataLakeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTransferToDataLakeStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTransferToDataLakeStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTransferToDataLakeStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVTransferToDataLakeStaging]
    PRINT '<<< DROPPED TABLE MTVTransferToDataLakeStaging >>>'
END


/****** Object:  Table [dbo].[MTVTransferToDataLakeStaging]    Script Date: 12/20/2016 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
-- =======================================================================================================================================
-- Author:		Craig Albright	
-- Create date: 12/20/2016
-- Description:	This report is roughly the same as the MtM report but has additional columns required by the credit interface
-- =======================================================================================================================================

Create table dbo.MTVTransferToDataLakeStaging
(
PlnndTrnsfrID int,
SchdlngOblgtnID int,
EstimatedMovementDate smalldatetime null, 
PlnndTrnsfrActlQty float null,--ActualQuantity
Quantity float null,
Negotiator varchar(256) null, 
PipelineCycleID int null,
PipelineCycleName varchar(256) null,
Sent bit null,
SentDate smalldatetime null,
LastChanged smalldatetime not null
)