
/****** Object:   [dbo].[v_MTV_AccountDetailShipToSoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailShipToSoldTo.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailShipToSoldTo]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_AccountDetailShipToSoldTo TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_AccountDetailShipToSoldTo >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_AccountDetailShipToSoldTo >>>'