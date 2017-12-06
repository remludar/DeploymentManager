/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVUserBySecurityRole WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVUserBySecurityRole]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVUserBySecurityRole.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUserBySecurityRole]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[MTVUserBySecurityRole] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVUserBySecurityRole >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[MTVUserBySecurityRole]
AS 
	SELECT	arm.AuthRoleId,arm.AuthRoleMemberId,ar.Name RoleName,ar.Description RoleDescription,
			u.UserID,c.CntctID,c.CntctLstNme+ ', ' + c.CntctFrstNme ContactName,u.UserNckNme,
			u.UserDBMnkr,u.UserStat,u.UserNonInteractive,arm.MemberSid
	FROM dbo.AuthRole ar (NOLOCK)
	INNER JOIN dbo.AuthRoleMember arm (NOLOCK)
	ON ar.AuthRoleId = arm.AuthRoleId
	INNER JOIN dbo.Users u (NOLOCK)
	ON u.UserID = arm.UserID
	INNER JOIN dbo.Contact c (NOLOCK)
	ON u.UserCntctID = c.CntctID
	UNION ALL
	SELECT arm.AuthRoleId,arm.AuthRoleMemberId,ar.Name RoleName,ar.Description RoleDescription,
			u.UserID,c.CntctID,c.CntctLstNme+ ', ' + c.CntctFrstNme ContactName,u.UserNckNme,
			u.UserDBMnkr,u.UserStat,u.UserNonInteractive,arm.MemberSid
	FROM (
		SELECT AuthRoleId,AuthRoleMemberId,MemberSid,SUBSTRING(u.MemberName, CHARINDEX('\', u.MemberName) + 1, 500) MemberName
		FROM (
			SELECT AuthRoleId,AuthRoleMemberId,MemberSid,dbo.SRAIT_FN_StrSIDToUser(MemberSid) MemberName
			FROM dbo.AuthRoleMember (NOLOCK)
			WHERE UserID IS NULL
		) u
		WHERE u.MemberName IS NOT NULL
	) arm
	INNER JOIN dbo.AuthRole ar (NOLOCK)
	ON ar.AuthRoleId = arm.AuthRoleId
	INNER JOIN dbo.Users u (NOLOCK)
	ON arm.MemberName = u.UserDBMnkr
	INNER JOIN dbo.Contact c (NOLOCK)
	ON u.UserCntctID = c.CntctID
GO

GRANT SELECT ON [dbo].[MTVUserBySecurityRole] TO [RightAngleAccess] AS [dbo]
GO

GRANT SELECT ON [dbo].[MTVUserBySecurityRole] TO [sysuser] AS [dbo]
GO

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVUserBySecurityRole]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVUserBySecurityRole.sql'
			PRINT '<<< ALTERED View v_MTVUserBySecurityRole >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVUserBySecurityRole >>>'
	  END



