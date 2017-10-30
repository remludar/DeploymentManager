
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

Print 'Start Script=v_MTV_TaxAudit.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If OBJECT_ID('v_MTV_TaxAudit') Is NOT Null
  Begin
    DROP VIEW dbo.v_MTV_TaxAudit
    PRINT '<<< DROPPED VIEW v_MTV_TaxAudit >>>'
  End
GO


Create View dbo.v_MTV_TaxAudit AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxAudit												                Copyright 2012 SolArc
-- Overview:    View of MTV Tax Audit table which contains additional "last known" columns that will provide
--              usable results when the underlying table records have been deleted
-- Created by:  Eric Wallerstein
-- History:     09 Jul 2012 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
-- 09 Jul 2012  E.Wallerstein   Endeavour   Initial Creation
------------------------------------------------------------------------------------------------------------------

--  select * from v_MTV_TaxAudit

Select MTV_TaxAudit.Idnty
      ,MTV_TaxAudit.DateModified
      ,MTV_TaxAudit.UserID
      ,MTV_TaxAudit.UserDBMnkr
      ,MTV_TaxAudit.TxRleStID
      ,MTV_TaxAudit.DlDtlPrvsnID
      ,MTV_TaxAudit.TabChanged
      ,MTV_TaxAudit.EntityChanged
      ,MTV_TaxAudit.OldValue
      ,MTV_TaxAudit.NewValue
	  ,COALESCE((SELECT [Description]
				 FROM   dbo.TaxRuleSet AS TRS
				 WHERE  (TxRleStID = dbo.MTV_TaxAudit.TxRleStID)),
                 (SELECT TOP (1) (CASE WHEN NewValue='<DELETED>' THEN OldValue ELSE NewValue END)
                  FROM   dbo.MTV_TaxAudit AS LastKnown WITH (nolock)
                  WHERE  (LastKnown.TxRleStID = dbo.MTV_TaxAudit.TxRleStID) AND (TabChanged = 'Properties') AND (EntityChanged = 'Description') 
                        ORDER BY DateModified DESC),
				 (SELECT top(1) [Description] from MTVTaxProvision WHERE (MTVTaxProvision.TxRleStId =  MTV_TaxAudit.TxRleStId OR   MTVTaxProvision.DlDtlPrvsnId = MTV_TaxAudit.DlDtlPrvsnId))
			    ) 'LastKnownTaxRuleSetDescription'
      ,Case When MTV_TaxAudit.DlDtlPrvsnID is NULL Then ''
            Else (Select Top 1 LastKnown.NewValue
                  From   MTV_TaxAudit LastKnown (nolock)
                  Where  LastKnown.DlDtlPrvsnID = MTV_TaxAudit.DlDtlPrvsnID
                    and  LastKnown.TabChanged = 'Provisions'
                    and  LastKnown.EntityChanged = 'Provision Type'
                    and  LastKnown.NewValue <> '<DELETED>'
                  Order By LastKnown.DateModified desc
                 ) + ' of ' +
                 (Select Top 1 LastKnown.NewValue
                  From   MTV_TaxAudit LastKnown (nolock)
                  Where  LastKnown.DlDtlPrvsnID = MTV_TaxAudit.DlDtlPrvsnID
                    and  LastKnown.TabChanged = 'Provisions'
                    and  LastKnown.EntityChanged = 'Tax Rate'
                    and  LastKnown.NewValue <> '<DELETED>'
                  Order By LastKnown.DateModified desc
                 ) + ' from ' +
                 (Select Top 1 LastKnown.NewValue
                  From   MTV_TaxAudit LastKnown (nolock)
                  Where  LastKnown.DlDtlPrvsnID = MTV_TaxAudit.DlDtlPrvsnID
                    and  LastKnown.TabChanged = 'Provisions'
                    and  LastKnown.EntityChanged = 'From Date'
                    and  LastKnown.NewValue <> '<DELETED>'
                  Order By LastKnown.DateModified desc
                 ) + ' to ' +
                 (Select Top 1 LastKnown.NewValue
                  From   MTV_TaxAudit LastKnown (nolock)
                  Where  LastKnown.DlDtlPrvsnID = MTV_TaxAudit.DlDtlPrvsnID
                    and  LastKnown.TabChanged = 'Provisions'
                    and  LastKnown.EntityChanged = 'To Date'
                    and  LastKnown.NewValue <> '<DELETED>'
                  Order By LastKnown.DateModified desc
                 ) + 
                 ' [Provision ID = ' + Convert(varchar,MTV_TaxAudit.DlDtlPrvsnID) + ']'
       End 'LastKnownProvisionInfo'
	   ,CASE WHEN TabChanged = 'Properties'   THEN 1 
			   WHEN TabChanged = 'Rules'      THEN 2 
			   WHEN TabChanged = 'Provisions' THEN 3 
			   WHEN TabChanged = 'Licenses'   THEN 4 
			   WHEN TabChanged = 'Comments'   THEN 5 END AS EntitySort
From   MTV_TaxAudit (nolock)


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser and notify user
--------------------------------------------*/
If OBJECT_ID('v_MTV_TaxAudit') Is NOT Null
  BEGIN
    PRINT '<<< CREATED VIEW v_MTV_TaxAudit >>>'
    GRANT  SELECT  ON dbo.v_MTV_TaxAudit TO sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating View v_MTV_TaxAudit>>>'
GO


---End of Script: v_MTV_TaxAudit.sql

