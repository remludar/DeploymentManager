IF OBJECT_ID('CUSTOM_GV_SETTINGS') Is Not NULL
BEGIN
    Drop Table dbo.CUSTOM_GV_SETTINGS
    PRINT '<<< DROPPED Table dbo.CUSTOM_GV_SETTINGS >>>'
END
GO

Create Table dbo.CUSTOM_GV_SETTINGS (
  GVID                      Integer       Identity,
  Setting                   VarChar(50),
  Value                     VarChar(MAX)
)
GO

Exec dbo.SRA_Index_Check      @s_table       = CUSTOM_GV_SETTINGS
                             ,@s_index       = CUSTOM_GV_SETTINGS_I1
                             ,@s_keys        = 'GVID, Setting'
                             ,@c_unique      = 'Y'
                             ,@c_clustered   = 'Y'
                             ,@c_primarykey  = 'N'
                             ,@c_uniquekey   = 'N'
                             ,@c_build_index = 'Y'
                             ,@vc_domain     = 'Reporting'
GO

If OBJECT_ID('CUSTOM_GV_SETTINGS') Is NOT Null
BEGIN
            PRINT '<<< CREATED Table CUSTOM_GV_SETTINGS >>>'
            Grant Select, Update, Delete, Insert, Alter on CUSTOM_GV_SETTINGS to SYSUSER
            Grant Select, Update, Delete, Insert, Alter on CUSTOM_GV_SETTINGS to RightAngleAccess
END
ELSE
            Print '<<<Failed Creating Table CUSTOM_GV_SETTINGS>>>'

GO
