/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchContactMasterDataStaging WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchContactMasterDataStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchContactMasterDataStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVSearchContactMasterDataStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVSearchContactMasterDataStaging >>>'
	  END
GO

-- MAKE SURE QUOTE INDENTIFIER IS SET TO OFFC:\OLFAppSource\Motiva\Development\s15_ITC1\Motiva.RightAngle\Server\Server.ConfigurationData\ConfigurationData\Reports\Override\MOT Search Vendor MasterData Staging.config
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVSearchContactMasterDataStaging]
					 	(@c_IsThisNavigation 	Char(1) 		= 'N',
						--@vc_InterfaceID			VarChar(255),
						@vc_EntityStatus		char(1) = null,
						@dt_DateFrom			varchar(50),
						@dt_DateTo				varchar(50),
						@VC_Debug				VarChar(1)		= 'N')
AS

-- ========================================================
-- Author:        Joseph McClean
-- Create date:	  10-19-2016
-- Description:   Searches MTV Contact MasterData Staging
-- =======================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
--Set NoCount ON
--Set ANSI_NULLS ON
--Set ANSI_PADDING ON
--Set ANSI_Warnings ON
--Set Quoted_Identifier OFF


Declare @vc_SQLSelect VarChar(8000), @vc_SQLFrom VarChar(8000), @vc_SQLWhere VarChar(8000)
	
						
Select	@vc_SQLSelect	= '
INSERT INTO dbo.#MTVContactMasterDataStaging
Select	
									ID,
									MDMCustID,
									Name,
									Abbreviation,
									ContactRole,
									ContactPhone,
									FirstName,
									LastName,
									MDMFunction,
									Fax,
									Email,
									EmailArchiveTypeId,
									EmailArchiveType,
									MobilePhone,
									ContactType,
									ContactStatus,
									Office,
									OfficeLocaleId,
									BACode,
									ContactID,
									Department,
									CommunicatonMethod,
									DistributionMethod,
									InterfaceId,
									InterfaceAction,
									ProcessedDate,
									InterfaceStatus,
									InterfaceMessage '
Select @vc_SQLFrom		= 'From	dbo.MTVContactMasterDataStaging	(NoLock) ' 
Select @vc_SQLWhere		= 'Where 1=1 '

--Select @vc_SQLWhere = @vc_SQLWhere + ' And MTV_VendorMasterDataStaging.InterfaceStatus In ( ' +  @vc_EntityStatus + ' )'
--If @c_IsThisNavigation <> 'Y'
--Begin
	If @vc_EntityStatus is not Null 
	begin
	   Select @vc_SQLWhere = @vc_SQLWhere + ' And dbo.MTVContactMasterDataStaging.InterfaceStatus In ( ' +  '''' + @vc_EntityStatus + '''' +  ')'
	end
		--Select @vc_SQLWhere = @vc_SQLWhere + ' And InterfaceStatus = C'
		--Select @vc_SQLWhere = @vc_SQLWhere + ' And MTV_VendorMasterDataStaging.InterfaceStatus =  ' +  '' +  @vc_EntityStatus + ''
--End



IF @dt_DateFrom IS NOT NULL AND @dt_DateTo IS  NULL 
BEGIN
	Select @vc_SQLWhere = @vc_SQLWhere + ' AND dbo.MTVContactMasterDataStaging.ProcessedDate >=  ' +  + '''' + convert(VARCHAR, @dt_DateFrom, 110) + ''''
END

IF @dt_DateTo IS NOT NULL AND @dt_DateFrom IS NULL
BEGIN
	Select @vc_SQLWhere = @vc_SQLWhere + ' AND dbo.MTVContactMasterDataStaging.ProcessedDate <=  ' + '''' +  convert(VARCHAR, @dt_DateTo, 110) + ''''
END

IF @dt_DateFrom IS NOT NULL AND @dt_DateTo IS NOT NULL 
BEGIN 
    SELECT @vc_SQLWhere = @vc_SQLWhere + '  AND dbo.MTVContactMasterDataStaging.ProcessedDate BETWEEN ' + '''' + convert(varchar, @dt_DateFrom, 110) + '''' + ' AND ' + '''' + convert(varchar, @dt_DateTo) + ''''
END


if @VC_Debug = 'Y'
		select @vc_SQLSelect + @vc_SQLFrom + @vc_SQLWhere
else
		exec(@vc_SQLSelect + @vc_SQLFrom + @vc_SQLWhere)


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVContactMasterDataStaging]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVContactMasterDataStaging.sql'
			PRINT '<<< ALTERED StoredProcedure MTVContactMasterDataStaging >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVContactMasterDataStaging >>>'
	  END