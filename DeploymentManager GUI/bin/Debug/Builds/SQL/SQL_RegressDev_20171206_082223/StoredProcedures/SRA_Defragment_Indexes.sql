PRINT 'Start Script=SRA_Defragment_Indexes.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SRA_Defragment_Indexes]') IS NULL
      BEGIN
                     EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SRA_Defragment_Indexes] AS SELECT 1'
                     PRINT '<<< CREATED StoredProcedure SRA_Defragment_Indexes >>>'
         END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER  Procedure [dbo].[SRA_Defragment_Indexes] (

        @online             int = 0                 ,

        @tempdb             int = 0                 ,

        @maxfrag            decimal = 20.0          ,

        @singletablename    varchar (128) = null

        )

As

------------------------------------------------------------------------------------------------------------------

-- Name:  SRA_Defragment_Indexes                                                        Copyright 2013 OpenLink

-- Overview:  Determines the logical fragmentation percentage for each index within the database,

--        and Reorganzies those indexes that are over 20% fragmented but under 30%. Rebuilds those

--        indexes where they are 30% fragmented or higher.

--

--

--        Procedure should be setup as nightly occuring SQL Server Job.

--        Procedure will not work running as a RAMQ Job, as sysuser is not DBO of the database.

--

-- Arguments: Online          - Allows for Online Rebuilds of Indexes.  Default is OFF.

--    tempdb    - Part of the work can be done in tempdb.  Default is OFF.

--            On those systems where the tempdb devices reside on seperate

--            Set of disks, there could be some performance gain. Uses more

--            Disk space.

--    MaxFrag         - Default 20% - Don't recommend changing the default

--    SingleTableName - Runs procedure for only the specified table

--

-- Examples:

--    Example 1:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES

--          Accepts the defaults  Online = OFF, tempdb = OFF, MaxFrag = 20.00 and ALL tables

--    Example 2:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES 1,1

--          Rebuilds indexes Online and intermediate sort results stored in tempdb, MaxFrag = 20.00 and ALL tables

--    Example 3:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES @singletablename='DealDetail'

--          Accepts the defaults  Online = OFF, tempdb = OFF, MaxFrag = 20.00 and only the table identified

--

-- SPs:

-- Temp Tables:

--

-- Created by:  Kurt Gerrild

-- History:     4/7/2011 - First Created

--

------------------------------------------------------------------------------------------------------------------

--  Date Modified   Modified By     Issue#  Modification

--  --------------- --------------  ------  ----------------------------------------------------------------------
--  11/16/2011      KEG                   Added code to update statistics on tables that were defragmented
--  12/07/2011      KEG                     Removed code to drop stats on computed columns.
--  12/08/2011      KEG                     Added a check of valid SQL Edition for ONLINE REBUILD of indexes.
--  02/26/2013      SABrown                 Modify to allow parm of Single Table to only handle indexes for that
--                                              table.
--  10/14/2015	    KEG			  Modified UPDATE STATISTICS to include WITH FULLSCAN, INDEX.  Removes the 
--					  COLUMNS STATS update which is included if nothing is specified. 
--	2017-11-08		RMM				Added space before WITH FULLSCAN in Update Statistics dynamic-SQL to avoid syntax errors.
------------------------------------------------------------------------------------------------------------------



SET NOCOUNT ON

SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON



-- Declare variables

Declare @tablename      varchar (128)

Declare @tableschema    varchar (128)

Declare @indexname      varchar (128)

Declare @execstr        varchar (max)

Declare @i_counter      int

Declare @dbid           int

Declare @objectid       int

Declare @indexid        int

Declare @frag           decimal

Declare @online_YN      varchar(3)

Declare @tempdb_YN      varchar(3)

Declare @parent_id      int



--Error checking for correct parameter values of Online and tempdb

If @Online not in (1,0)

  Begin

    RAISERROR ('*** The Online parameter must be set to an integer 1 (ON) or 0 (OFF) ***',16,-1)

    RETURN (1)

  End

If @tempdb not in (1,0)

  Begin

    RAISERROR ('*** The Tempdb parameter must be set to an integer 1 (ON) or 0 (OFF) ***',16,-1)

    RETURN (1)

  End



--Setting online and tempdb variable values based upon Argument input of stor proc.

-- Default is OFF for both

Select @online_YN = Case When @online = 1 Then 'ON' Else 'OFF' End

Select @tempdb_YN = Case When @tempdb = 1 Then 'ON' Else 'OFF' End



 -- Online Build set to 1  we do a SQL Edition Check and RETURN if the Edition is invalid for ONLINE Build

--If @online = 1

--  Begin

--    /* Check our server version; 1804890536 = Enterprise, 610778273 = Enterprise Evaluation, -2117995310 = Developer */

--    If (Select ServerProperty('EditionID')) Not In (1804890536, 610778273, -2117995310)

--      Begin

--        Print 'SQL Edition does not support ONLINE Rebuild of Indexes'

--        RETURN

--      End

--  End



Select @dbid = (Select db_id())

Select @objectid = (select OBJECT_ID(NULL))

--Create table to contain table names

CREATE TABLE #dbtables (

        tableID                         int identity(1,1)   ,

        table_schema                    varchar (255)       ,

        table_name                      varchar (255)

)



--Create table to contain table names that were defragmented

CREATE TABLE #defrag_tables (

        tableID                         int identity(1,1)   ,

        table_schema                    varchar (255)       ,

        table_name                      varchar (255)

)



-- Create the table to contain fragmented information

CREATE TABLE #fraglist (

        fragid                          int identity(1,1)   ,

        database_id                     smallint            ,

        ObjectId                        int                 ,

        IndexId                         int                 ,

        partition_number                int                 ,

        index_type_desc                 nvarchar (60)       ,

        alloc_unit_type_desc            nvarchar (60)       ,

        index_depth                     tinyint             ,

        index_level                     tinyint             ,

        avg_fragmentation_in_percent    float               ,

        fragment_count                  bigint              ,

        avg_fragmentation_size_in_pages float               ,

        page_count                      bigint              ,

        avg_page_space_used_in_percent  float               ,

        record_count                    bigint              ,

        ghost_record_count              bigint              ,

        version_ghost_record_count      bigint              ,

        min_record_size_in_bytes        int                 ,

        max_record_size_in_bytes        int                 ,

        avg_record_size_in_bytes        float               ,

        forwarded_record_count          bigint              ,

        table_schema                    varchar (255) NULL

)



Insert  #dbtables

Select  table_schema

      , table_name

From    INFORMATION_SCHEMA.TABLES

Where   TABLE_TYPE = 'BASE TABLE'

And     ISNULL(@singletablename, TABLE_NAME) = TABLE_NAME



-- Getting a list of indexes from the database

Insert  #fraglist

Select  frag.database_id

      , frag.object_id

      , frag.index_id

      , frag.partition_number

      , frag.index_type_desc

      , frag.alloc_unit_type_desc

      , frag.index_depth

      , frag.index_level

      , frag.avg_fragmentation_in_percent

      , frag.fragment_count

      , frag.avg_fragment_size_in_pages

      , frag.page_count

      , frag.avg_page_space_used_in_percent

      , frag.record_count

      , frag.ghost_record_count

      , frag.version_ghost_record_count

      , frag.min_record_size_in_bytes

      , frag.max_record_size_in_bytes

      , frag.avg_record_size_in_bytes

      , frag.forwarded_record_count

      , table_schema = myTables.table_schema

From    sys.dm_db_index_physical_stats (@dbid, @objectid, NULL, NULL , 'limited') frag

Join    sys.objects obj

        On  frag.object_id = obj.object_id

Join    sys.indexes i

        On  i.object_id = frag.object_id

        And i.index_id = frag.index_id

Join    #dbtables myTables

        On  obj.name = myTables.table_name



-- Defragging Indexes

Select  @i_counter = MIN(fragid)

From    #fraglist



-- loop through the indexes

While @i_counter > 0

  Begin

    --  First, get what we need to work with into variables

    Select  @objectid = frag.ObjectId

          , @tableschema = frag.table_schema

          , @indexid = frag.IndexId

          , @frag = frag.avg_fragmentation_in_percent

          , @tablename = obj.name

          , @parent_id = obj.parent_object_id

          , @indexname = i.name

    From    #fraglist frag

    Join    sys.objects obj (nolock)

            On  frag.ObjectId = obj.object_id

    Join    sys.indexes i (nolock)

            On  i.object_id = frag.objectid

            And i.index_id = frag.indexid

    Where   fragid = @i_counter



    --Checking to see if any columns on the table are LOB, If so I turn the ONLINE parameter to OFF.

    If EXISTS ( Select  'Y'

                From    sys.columns cols (nolock)

                Join    sys.types coltype (nolock)

                        On  cols.system_type_id = coltype.system_type_id

                        And (   coltype.name in ('image','text','ntext') -- system_type_id in (34,35,99)

                            or  cols.max_length = -1 )

                Where   cols.object_id in (@objectid,@parent_id)    )

        Set @Online_YN = 'OFF'



    --Check for Indexes where there is little to no fragmentation and Do Nothing

    If @frag < @maxfrag

      Begin

        Print 'Nothing to do, the INDEX ' + RTRIM(@indexname) + ' ON '

                + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'

      End

    Else

      Begin

        --Check for Indexes where the fragmentation is Under 30% but because of the above check

        --the fragmentation is above 20%.  Do a REORGANIZE

        If @frag < 30.0

          Begin

            Select  @execstr = 'ALTER INDEX ' + RTRIM(@indexname) + ' ON '

                        + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' REORGANIZE'



            Print 'Executing ' + @execstr + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'



            EXEC (@execstr)

          End

        Else  --All other indexes left have a fragmentation above 30% and we do a rebuild.

          Begin

            Select  @execstr = 'ALTER INDEX ' + RTRIM(@indexname) + ' ON '

                        + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' REBUILD '



            Print 'Executing ' + @execstr + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'



            Select  @execstr = @execstr + 'WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = '

                        + @tempdb_YN + ', ONLINE = ' + @online_YN + ')'



            EXEC (@execstr)

          End



        --  This will set the list of tables that have been defragmented that will be used for

        --  UPDATE STATISTICS

        Insert  #defrag_tables (table_schema,table_name)

        Select  @tableschema, @tablename

        Where   Not Exists (Select  1

                            From    #defrag_tables

                            Where   table_schema = @tableschema

                            And     table_name = @tablename)



      End



    -- setting the ONLINE value back to what was specified when executed If it changed in LOB check

    Select  @online_YN = Case When @Online = 1 Then 'ON' Else 'OFF' End

    --  Get the next record to process

    Select  @i_counter = MIN(fragid)

    From    #fraglist

    Where   fragid > @i_counter

  End  --  While @@i_counter > 0



-- Now update statistics on those tables that were defragmented

--Added WITH FULLSCAN, INDEX   to the update Statistics, column statistics can be run outside of this process. 

Print 'Tables to be Altered since Defrag...'

Select  *

From    #defrag_tables



Select  @i_counter = MIN(tableID)

From    #defrag_tables



While @i_counter > 0

  Begin

    Select  @tablename = table_name

          , @tableschema = table_schema

    From    #defrag_tables

    Where   tableID = @i_counter



    If @frag >= @maxfrag

      Begin

        Select  @execstr = 'Update Statistics ' + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' WITH FULLSCAN, INDEX'

        Print 'Updating: ' + @execstr

        EXEC (@execstr)

      End



    Select  @i_counter = MIN(tableID)

    From    #defrag_tables

    Where   tableID > @i_counter

  End



-- Delete the temporary table

DROP TABLE #fraglist
DROP TABLE #dbtables
DROP TABLE #defrag_tables




/****** Object:  ViewName [dbo].[SRA_Defragment_Indexes]    Script Date: DATECREATED ******/
PRINT 'Start Script=SRA_Defragment_Indexes.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SRA_Defragment_Indexes]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SRA_Defragment_Indexes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SRA_Defragment_Indexes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SRA_Defragment_Indexes >>>'
