PRINT 'Start SQLPermissions  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()

--*************************************************************************************************
-- Run SQL permission restore script
------------------------------------------------------------------------------------------------------------------
-- SeedData:	SD_SQLPermissions                                                       Copyright 2015 OpenLink
-- Overview:    
-- Created by:	Blake Doerr
-- History:     7/9/99 - First Created
--
-- Modified     Modified By     Issue#  Modification
-- --------     -------------- 	------  --------------------------------------------------------------------------
-- 18 Feb 2015  Sean Brown              Change Grant statements to include schema name to allow for References
------------------------------------------------------------------------------------------------------------------
Begin
    Create Table #GrantRights (
        ID          int Not Null Identity   ,
        SQLCommand  Varchar(255)
        )

    Create Table #UserName (
        ID          int Not Null Identity   ,
        name        varchar (255)
        )
        
    Declare @i_minID    int
          , @s_UserName varchar (255)

    Insert  #UserName (name)
    Select  'sysuser'
    UNION
    Select  'RightAngleAccess'

    Select  @i_minID = MIN(ID)
    From    #UserName

    While @i_minID > 0
      Begin
        Select  @s_UserName = name
        From    #UserName
        Where   ID = @i_minID
        
        Insert  #GrantRights (SQLCommand) 
        Select  'Grant execute on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'P'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant execute, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'fn'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Alter, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'u'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'v'
        And     so.status >= 0
        Order by so.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'TF'
        And     so.status >= 0
        Order by so.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'IF'
        And     so.status >= 0
        Order by so.name

        Select  @i_minID = MIN(ID)
        From    #UserName
        Where   ID > @i_minID
      End

    Drop Table #UserName

    --*************************************************************************************************
    --******************************   REMOVE GRANTED PRIVILEGES FROM PUBLIC
    Create Table #tmp1 (
        permission_name     nvarchar(128)
      , obj_name            nvarchar(128)
      , principal_name      nvarchar(128)
      , obj_schema          nvarchar(129)
        )

    Insert  #tmp1
    Select  dp.permission_name permission_name , obj.name obj_name , principals.name principal_name, S.name obj_schema
    From    sys.database_permissions dp
    Join    sys.database_principals principals
            On  dp.grantee_principal_id = principals.principal_id
            and principals.name = 'public'
    Join    sys.objects obj
            on  dp.major_id = obj.object_id
    Join    sys.schemas S
            On  obj.schema_id = S.schema_id
            And S.name != 'sys'
    Where   1=1
    and     dp.major_id > 0
    And     dp.minor_id = 0
    And     dp.grantor_principal_id = 1
    Order by dp.permission_name,obj.name,principals.name

    Insert #GrantRights (SQLCommand) 
    Select cast('Revoke ' as nvarchar) + sub1.permission_name + cast(' on [' as varchar) + sub1.obj_schema + cast('].[' as nvarchar) + sub1.obj_name + cast('] from ' as nvarchar) + sub1.principal_name 
    From    #tmp1 sub1
    Order by sub1.obj_name

    Truncate Table #tmp1
    Insert  #tmp1
    Select  dp.permission_name permission_name , obj.name obj_name , principals.name principal_name, S.name obj_schema
    From    sys.database_permissions dp
    Join    sys.database_principals principals
            On  dp.grantee_principal_id = principals.principal_id
            and principals.name = 'public'
    Join    sys.types obj
            on  dp.major_id = obj.user_type_id
    Join    sys.schemas S
            On  obj.schema_id = S.schema_id
            And S.name != 'sys'

    Where   1=1
    and     dp.major_id > 0
    And     dp.minor_id = 0
    And     dp.grantor_principal_id = 1
    And     dp.class_desc = 'Type'

    Insert  #GrantRights (SQLCommand) 
    Select  cast('REVOKE ' as nvarchar) + sub1.permission_name + cast(' on Type::[' as varchar) + sub1.obj_schema + cast('].[' as nvarchar) + sub1.obj_name + cast('] to ' as nvarchar) + sub1.principal_name 
    From    #tmp1 sub1
    Order by sub1.obj_name

    DROP TABLE #tmp1
    --******************************   END REMOVE GRANTED PRIVILEGES FROM PUBLIC
    --*************************************************************************************************

    Declare @vc_SQLCommand varchar(255)
    Declare @i int
    Select @i = Min(ID) From #GrantRights
    While @i > 0 
      Begin
        Select @vc_SQLCommand = SQLCommand From #GrantRights where ID = @i
        Execute (@vc_SQLCommand)
        Select @i = Min(ID) From #GrantRights Where ID > @i
      End

    Drop Table #GrantRights
End
Go

--******************************   END SQL Permission Restore Script
--*************************************************************************************************


-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_AddAdditionalGrants
-- Overview:    
-- Created by:	Sean Brown
-- History:     28 Mar 2012 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--Grant rights left for PUBLIC
grant select on SourceSystemElementXref to public
go
grant select on users to public
go
grant select on GeneralConfiguration to public
go
grant select,insert,update,delete on SourceSystemElementXref to sysuser
go
