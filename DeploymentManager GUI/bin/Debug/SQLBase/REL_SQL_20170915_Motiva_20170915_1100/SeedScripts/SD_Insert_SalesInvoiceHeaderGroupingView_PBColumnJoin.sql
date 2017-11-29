
/****** Object:  View [dbo].[v_SalesInvoiceGrouping]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_SalesInvoiceGrouping.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_SalesInvoiceGrouping]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_SalesInvoiceGrouping] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_SalesInvoiceGrouping >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:        Rborgman
-- Create date:	  2/13/2017
-- -----------  --------------  ------  -----------------------------------------------------------------------------
ALTER view dbo.v_SalesInvoiceGrouping
as

SELECT	SalesInvoiceHeader.SlsInvceHdrID
		,SalesInvoiceHeader.GroupByColumn

FROM	SalesInvoiceHeader (NoLock)

go




SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_SalesInvoiceGrouping]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_SalesInvoiceGrouping.sql'
			PRINT '<<< ALTERED View v_SalesInvoiceGrouping >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_SalesInvoiceGrouping >>>'
	  END

GO


/****** Object:   [dbo].[v_SalesInvoiceGrouping]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_SalesInvoiceGrouping.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_SalesInvoiceGrouping]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_SalesInvoiceGrouping TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_SalesInvoiceGrouping >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_SalesInvoiceGrouping >>>'

GO

Declare @FromTable int
Declare @ToTable int

select @FromTable = ( Select Idnty from columnselectiontable where tablename = 'SalesInvoiceHeader' )
select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_SalesInvoiceGrouping' )


If @ToTable is null
begin
    insert into ColumnSelectionTable
	select 'v_SalesInvoiceGrouping', 'SIGS', 'Sales Invoice Grouping',null,'',null

	
   select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_SalesInvoiceGrouping' )
end

if not exists ( select 'x' from columnselectiontablejoin where FromClmnSlctnTbleIdnty = @FromTable and ToClmnSlctnTbleIdnty = @ToTable )
   insert into columnselectiontablejoin
   select @fromtable, @toTable, 'OneToOne', 'Y', '', '[SalesInvoiceHeader].SlsInvceHdrID = [v_SalesInvoiceGrouping].SlsInvceHdrID','Y' 

