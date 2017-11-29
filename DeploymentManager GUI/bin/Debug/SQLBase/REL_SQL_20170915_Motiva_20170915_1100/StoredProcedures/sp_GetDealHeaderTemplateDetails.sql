/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_GetDealHeaderTemplateDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDealHeaderTemplateDetails.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetDealHeaderTemplateDetails]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetDealHeaderTemplateDetails] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_GetDealHeaderTemplateDetails >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[sp_GetDealHeaderTemplateDetails]
@iDlHdrId int
AS

-- =============================================
-- Author:        gpk
-- Create date:	  6/5/2014
-- Description:   Returns DealHeader EntityTemplate and UserInterfaceTemplate Details
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
select DlHdrId
       ,DealHeader.EntityTemplateID
	   ,EntityTemplate.TemplateName
	   , UserInterfaceTemplateID 
from DealHeader (nolock) 
inner join EntityTemplate on DealHeader.EntityTemplateID = EntityTemplate.EntityTemplateID
where DlHdrId = @iDlHdrId

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_GetDealHeaderTemplateDetails]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_sp_GetDealHeaderTemplateDetails.sql'
			PRINT '<<< ALTERED StoredProcedure sp_GetDealHeaderTemplateDetails >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_GetDealHeaderTemplateDetails >>>'
	  END