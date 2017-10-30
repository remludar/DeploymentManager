SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

Print 'Start Script=MTV_TaxAudit.table.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--****************************************************************************************************************
-- Name:       MTV_TaxAudit           Copyright 2009 SolArc
-- Overview:   Table Creation Script: Audit table for tax setup, which will store an easily identifiable record
--                                    of what changed on tax setup
-- Created by: Eric Wallerstein
-- History:    12 Jun 2012 - First Created
--****************************************************************************************************************
-- Date         Modified        Issue#      Modification
-- -----------  --------------  ----------  -----------------------------------------------------------------------
-- 12 Jun 2012  E.Wallerstein   N/A         Initial Creation
-- 18 Jun 2012  E.Wallerstein               Added DlDtlPrvsnID
------------------------------------------------------------------------------------------------------------------

CREATE TABLE dbo.tmp_MTV_TaxAudit
( Idnty           int IDENTITY(1,1)
 ,DateModified    datetime
 ,UserID          int
 ,UserDBMnkr      varchar(80)
 ,TxRleStID       int
 ,DlDtlPrvsnID    int
 ,TabChanged      varchar(200)
 ,EntityChanged   varchar(200)
 ,OldValue        varchar(max)
 ,NewValue        varchar(max)
)
GO


SET IDENTITY_INSERT dbo.tmp_MTV_TaxAudit ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTV_TaxAudit') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTV_TaxAudit)
        EXEC('
            INSERT  dbo.tmp_MTV_TaxAudit (
                    Idnty
                   ,DateModified
                   ,UserID
                   ,UserDBMnkr
                   ,TxRleStID
                   ,DlDtlPrvsnID
                   ,TabChanged
                   ,EntityChanged
                   ,OldValue
                   ,NewValue
                    )
            Select  Idnty
                   ,DateModified
                   ,UserID
                   ,UserDBMnkr
                   ,TxRleStID
                   ,NULL
                   ,TabChanged
                   ,EntityChanged
                   ,OldValue
                   ,NewValue
            FROM    MTV_TaxAudit
            WITH    (HOLDLOCK TABLOCKX)')
            
    --IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End
GO
SET IDENTITY_INSERT dbo.tmp_MTV_TaxAudit OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTV_TaxAudit') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    DROP TABLE dbo.MTV_TaxAudit
GO
EXECUTE sp_rename N'dbo.tmp_MTV_TaxAudit', N'MTV_TaxAudit', 'OBJECT' 
GO

ALTER TABLE dbo.MTV_TaxAudit WITH NOCHECK
  ADD CONSTRAINT PK_MTV_TaxAudit_Indx PRIMARY KEY CLUSTERED (Idnty)

GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights and notify user
--------------------------------------------*/
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTV_TaxAudit') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  BEGIN
    PRINT '<<< CREATED TABLE MTV_TaxAudit >>>'
    GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.MTV_TaxAudit TO sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<< Failed Creating Table MTV_TaxAudit >>>'
GO
