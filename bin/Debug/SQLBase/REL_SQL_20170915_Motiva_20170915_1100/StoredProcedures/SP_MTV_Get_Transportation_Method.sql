/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_Transportation_Method WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Get_Transportation_Method]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_Transportation_Method.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_Transportation_Method]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Get_Transportation_Method] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Get_Transportation_Method >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Get_Transportation_Method]	 @i_DlHdrID int = NULL, @i_DlDtlID int = NULL, @i_DlDtlPrvsnID int = NULL, @i_PlnndTrnsfrID int = NULL, @i_XHdrID int = NULL
AS

-----------------------------------------------------------------------------------------------------------------------------

-- Name			:MTV_Get_Transportation_Method          

-- Overview		:This Procedure will retrieve the Transportation Method specified on the PlannedTransfer or the DealDetail

-- Created by	:Bartt Shelton

-- History		:02/23/2013 - First Created

--

-- 	Date Modified 	Modified By	Issue#	Modification

-- 	--------------- -------------- 	------	-------------------------------------------------------------------------

--

declare @c_MthdTrns Char(1)


begin --test for presence of Planned Transfer

If @i_PlnndTrnsfrID is null
  begin -- No PT so get it from DlDtl
    select @c_MthdTrns =
      IsNull((Select DealDetail.DlDtlMthdTrnsprttn
      From  DealDetail (nolock)
      Where DealDetail.DlDtlDlHdrID = @i_DlHdrID
        and DealDetail.DlDtlID = @i_DlDtlID), '-')
  end -- No PT so get it from DlDtl

else

  begin -- PT exists, so get it from PT
    select @c_MthdTrns =
      IsNull((Select PlannedTransfer.MethodTransportation
      from  PlannedTransfer
      Where PlannedTransfer.PlnndTrnsfrID = @i_PlnndTrnsfrID), '-')
  end -- PT exists, so get it from PT

end --test for presence of Planned Transfer

Select @c_MthdTrns

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_Transportation_Method]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Get_Transportation_Method.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Get_Transportation_Method >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Get_Transportation_Method >>>'
	  END