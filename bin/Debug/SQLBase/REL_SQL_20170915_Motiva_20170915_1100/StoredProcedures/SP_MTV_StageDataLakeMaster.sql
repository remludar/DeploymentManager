/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_StageDataLakeMaster WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_StageDataLakeMaster]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_StageDataLakeMaster.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StageDataLakeMaster]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_StageDataLakeMaster] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_StageDataLakeMaster >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_StageDataLakeMaster] 
@UserId INT = NULL
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  8/26/2016
-- Description:   To stage the DataLakemaster
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_StageDataLakeMaster 18
-----------------------------------------------------------------------------


BEGIN TRY

--Declare @UserId int
--set @UserId = 0;

DECLARE @DealTypes TABLE (DlTypID INT)
INSERT INTO @DealTypes
SELECT DlTypID
FROM DealType
WHERE DlTypID NOT IN (
SELECT CAST(Data AS INT) DlTypID
FROM dbo.fn_MTV_ParseList(',',dbo.GetRegistryValue('Motiva\Tax\DataLakeMaster\ExcludeFinancialDealIDS\')))

BEGIN TRANSACTION

DELETE FROM dbo.MTVDataLakeMasterTaxStaging
--DBCC CHECKIDENT ('[MTVDataLakeMasterTaxStaging]', RESEED, 0);

INSERT INTO [dbo].[MTVDataLakeMasterTaxStaging]
           ([BAID]
           ,[BAName]
           ,[BAAbbv]
           ,[BAStts]
           ,[FederalTaxID]
           ,[SCAC]
           ,[LicenseName]
           ,[LicenseDescription]
           ,[FromDate]
           ,[ToDate]
           ,[Exemption]
           ,[ExemptionTypeAbbreviation]
           ,[ExemptionTypeDescription]
           ,[DeferBilling]
           ,[LicenseTypeDescription]
           ,[LicenseTypeAbbreviation]
           ,[AnnualLicenseNumber]
           ,[PermanentLicenseNumber]
           ,[Comments]
           ,[Miscellaneous]
           ,[CertificateUrl]
           ,[LicenseID]
           ,[UniqueID]
           ,[ChangeType]
           ,[DataLakeStatus]
           ,[CreatedDate]
           ,[UserID]
           ,[ModifiedDate]
           ,[PublishedDate]
           ,[ProcessedStatus]
           ,[Message]
           ,[InterfaceID])
	SELECT	BusinessAssociate.BAID
			,BusinessAssociate.BANme + ISNULL(BusinessAssociate.BanmeExtended,'') AS BAName
			,BusinessAssociate.BAAbbrvtn + ISNULL(BusinessAssociate.BaAbbrvtnExtended,'') AS BAAbbv
			,BusinessAssociate.BAStts  AS BAStts			                         
			,FEIN.GnrlCnfgMulti AS FederalTaxId
			,SCAC.GnrlCnfgMulti AS SCAC
			,License.Name AS LicenseName
			,License.Description AS LicenseDescription
			,businessassociatelicense.FromDate
			,businessassociatelicense.ToDate
			,businessassociatelicense.Exemption
			,LicenseExemptType.Description AS ExemptionTypeDescription
			,LicenseExemptType.Abbreviation AS ExemptionTypeAbbreviation
			,businessassociatelicense.DeferBilling 
			,LicenseType.Description AS LicenseTypeDescription
			,LicenseType.Abbreviation AS LicenseTypeAbbreviation
			,businessassociatelicense.AnnualLicenseNumber
			,businessassociatelicense.PermanentLicenseNumber
			,businessassociatelicense.Comments
			,businessassociatelicense.Miscellaneous			
			,null as CertificateUrl
			,businessassociatelicense.BALcnseID  as LicenseID
			,convert(varchar(10),businessAssociate.BAID) + convert(varchar(10),businessassociatelicense.BALcnseID) as UniqueID
			,'Add' as ChangeType                                      	
            ,Null as DataLakeStatus
            ,getDate() as CreatedDate
			, @UserId
            ,getDate() as ModifiedDate
			,Null as PublishedDate
			,'N' as ProcessedStatus
			,Null as Message
			,Null as InterfaceID
	    FROM dbo.BusinessAssociate (NoLock)                    
		INNER JOIN dbo.businessassociatelicense (NoLock)
		ON    BusinessAssociate.BAID = businessassociatelicense.BAID
		INNER JOIN dbo.License (NoLock)
		ON    businessassociatelicense.LcnseID = License.LcnseID
		LEFT OUTER JOIN dbo.LicenseType (NoLock)
		ON    businessassociatelicense.LicenseType = LicenseType.LicenseTypeID
		LEFT OUTER JOIN dbo.LicenseExemptType (NoLock)
		ON    businessassociatelicense.ExemptType = LicenseExemptType.LicenseExemptTypeID
		LEFT OUTER JOIN      dbo.GeneralConfiguration AS FEIN (NoLock)
		ON    BusinessAssociate.BAID = FEIN.GnrlCnfgHdrID
		AND   FEIN.GnrlCnfgQlfr = 'FederalTaxId'
		LEFT OUTER JOIN     dbo.GeneralConfiguration AS SCAC (NoLock)
		ON    BusinessAssociate.BAID = SCAC.GnrlCnfgHdrID
		AND   SCAC.GnrlCnfgQlfr = 'SCAC'
		WHERE EXISTS (	SELECT 1 
						FROM dbo.DealHeader (nolock)
						WHERE (DealHeader.DlHdrExtrnlBAID = BusinessAssociate.BAID OR DealHeader.DlHdrIntrnlBAID = BusinessAssociate.BAID)
						AND DealHeader.DlHdrStat = 'A'
						AND DlHdrTyp IN (SELECT DlTypID FROM @DealTypes))
		Order by BusinessAssociate.BAID

COMMIT TRANSACTION

END TRY
BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE		@vc_Error					varchar(255)
		SELECT	@vc_Error	=  ERROR_MESSAGE()
		Raiserror (60010,-1,-1, @vc_Error	)
END CATCH	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_StageDataLakeMaster]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_StageDataLakeMaster.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_StageDataLakeMaster >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_StageDataLakeMaster >>>'
	  END



	