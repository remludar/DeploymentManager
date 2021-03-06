/****** Object:  StoredProcedure [dbo].[race_Insert_Contact]    Script Date: 5/11/2015 11:06:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER  Procedure  [dbo].[race_Insert_Contact] 
(
	 @BAID							varchar(255)=NULL
	,@OffceLcleID					varchar(255)=NULL
	,@FirstName						varchar(255)=NULL
	,@MiddleInitial					varchar(255)=NULL
	,@LastName						varchar(255)=NULL
	,@Department					varchar(255)=NULL
	,@Title							varchar(255)=NULL
	,@BusinessRoles					varchar(255)=NULL
	,@Email							varchar(255)=NULL
	,@Phone							varchar(255)=NULL
	,@Fax							varchar(255)=NULL
	,@Pager							varchar(255)=NULL
	,@BirthDate						varchar(255)=NULL
	,@UserName						varchar(255)=NULL
	,@NickName						varchar(255)=NULL
	,@ContactType					varchar(255)=NULL
	,@UserRoles						varchar(255)=NULL
	,@IsRealPerson					varchar(255)=NULL
	,@FTPServer						varchar(255)=NULL
	,@FTPPort						varchar(255)=NULL
	,@FTPUserName					varchar(255)=NULL
	,@FTPPassword					varchar(255)=NULL
	,@FTPAnonymous					varchar(255)=NULL
	,@FTPDocumentArchiveType		varchar(255)=NULL
	,@FTPRemoteFolder				varchar(255)=NULL
	,@FTPAddTimeStamp				varchar(255)=NULL
	,@EmailDocumentArchiveType		varchar(255)=NULL
	,@EasyLinkUserName				varchar(255)=NULL
	,@PreferredDistributionMethods	varchar(255)=NULL
	,@RaceTag						varchar(255)=NULL
	,@c_Debug				char(1) = 'N'
)
as
-----------------------------------------------------------------------------------------------------------------------------
-- Name:			race_Insert_Contact           Copyright 2010
-- Overview:		This SP will load offices from the reference data import workbook
-- Error Method:	Raises an error and rolls back changes
-- Arguments:  
-- SPs:				None
-- Tables:			Contact, 
-- Temp Tables:  None
-- Created by:		Scott Creed
-- History:			2010-06-18 - Original version
--
-- 	Date Modified 	Modified By		Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
	declare
		 @i_BAID				int
		,@i_OffceLcleID			int
		,@sdt_BirthDate			smalldatetime
		,@i_NewUserID			int
		
set nocount on

declare @i_NewID int,
		@Entity varchar(255)= 'Contact',
		@TableName varchar(255)= 'Contact',
		@ColumnList varchar(255)= 'CntctID',
		@KeyValueList varchar(255)

Begin Try

	select @i_BAID = CONVERT(int, coalesce(@BAID,0))
	if not exists (select * from BusinessAssociate where BAID = @i_BAID)
		Raiserror('The business associate (%s) does not exist',16,0,@BAID)

	select @MiddleInitial = coalesce(@MiddleInitial,' ')
	
	if DataLength(@MiddleInitial) = 0 select @MiddleInitial = ' '
	
	Select @i_NewID = CntctID from Contact where CntctBAID = @i_BAID and CntctFrstNme = @FirstName and CntctLstNme = @LastName and coalesce(CntctMddlIntl,'') = coalesce(@MiddleInitial,'')
	if NOT ISNULL(@i_NewID,0) = 0
	begin
		select @KeyValueList = convert(varchar(255), @i_newID)
		exec race_AddraceTag @RaceTag, @Entity, @TableName, @ColumnList, @KeyValueList

		Raiserror('The contact %s %s %s already exists',11,0,@FirstName,@MiddleInitial,@LastName)
	end
	
	select @i_OffceLcleID = CONVERT(int, coalesce(@OffceLcleID,0))
	if not exists (select * from Office where OffceLcleID = @i_OffceLcleID)
		Raiserror('The office does not exist.',16,0)
		
	if not exists (select * from Office where OffceLcleID = @i_OffceLcleID and OffceBAID = @i_BAID)
		Raiserror('The office is not set up for the requested BA.',16,0)

	if coalesce(@FirstName,'') = ''
		Raiserror('The first name is required',16,0)
		
	if DATALENGTH(@FirstName) > 20
		Raiserror('The first name cannot be greater than 20 characters',16,0)
	
	if DATALENGTH(@MiddleInitial) > 2
		Raiserror('The middle initial cannot be more than 2 characters.',16,0)
	
	if coalesce(@LastName,'') = ''
		Raiserror('The last name is required',16,0)
		
	if DATALENGTH(@LastName) > 20
		Raiserror('The last name cannot be greater than 20 characters',16,0)
	
	select @Phone = coalesce(@Phone,'(999) 999-9999')
	if coalesce(@Phone,'') = ''
		Raiserror('The phone is required',16,0)
		
	if DATALENGTH(@Phone) > 25
		Raiserror('The phone cannot be greater than 25 characters',16,0)

	select @Title = coalesce(@Title,'')
	--if coalesce(@Title,'') = ''
	--	Raiserror('The title is required',16,0)
		
	if DATALENGTH(@Title) > 50
		Raiserror('The title cannot be greater than 50 characters',16,0)

	--if coalesce(@Department,'') = ''
	--	Raiserror('The department is required',16,0)
	
	select @Department = Coalesce(@Department,'')
		
	if DATALENGTH(@Department) > 50
		Raiserror('The department cannot be greater than 50 characters',16,0)

	if DATALENGTH(@Fax) > 50
		Raiserror('The fax number cannot be greater than 25 characters',16,0)

	if DATALENGTH(@Pager) > 50
		Raiserror('The pager number cannot be greater than 50 characters',16,0)

	if DATALENGTH(@Email) > 50
		Raiserror('The email address cannot be greater than 50 characters',16,0)

	select @sdt_BirthDate = CONVERT(smalldatetime, @BirthDate)

SET IDENTITY_INSERT Contact ON
	
	BEGIN Transaction

	-- Get new id
	Execute sp_getkey 'Contact', @i_NewID Output

	-- If error...
	If @i_NewID Is Null Or @i_NewID = 0 
		Raiserror ('The attempt to generate a new CntctID failed',16,0)

	-- Insert contact
	Insert Contact
				(
				 CntctID
				,CntctBAID
				,CntctOffceLcleID
				,CntctStts
				,CntctFrstNme
				,CntctMddlIntl
				,CntctLstNme
				,CntctVcePhne
				,CntctTtle
				,CntctDprtmnt
				,CntctFxPhne
				,CntctPgrPhne
				,CntctEMlAddrss
				,CntctBrthDte
				,CntctRlPrsn
				,CntctFTPSrvr
				,CntctFTPPrt
				,CntctFTPNme
				,CntctFTPPsswrd
				,CntctFTPAnonymous
				,CntctFTPDcmntArchvTypID
				,CntctFTPRmtFldr
				,CntctFTPAddTmstmp
				,CntctEMlDcmntArchvTypID
				,CntctEsyLnkUsrNme
				,CntctPrfrrdDstMthds
				)
		  Values(  
				 @i_NewID 
				,@i_BAID
				,@i_OffceLcleID
				,'A'
				,@FirstName
				,coalesce(@MiddleInitial,'')
				,@LastName
				,@Phone
				,@Title
				,@Department
				,@Fax
				,@Pager
				,@Email
				,@sdt_BirthDate
				,@IsRealPerson				
				,@FTPServer					
				,@FTPPort					
				,@FTPUserName				
				,@FTPPassword				
				,@FTPAnonymous				
				,@FTPDocumentArchiveType	
				,@FTPRemoteFolder			
				,@FTPAddTimeStamp			
				,@EmailDocumentArchiveType	
				,@EasyLinkUserName			
				,@PreferredDistributionMethods
				 )

	Declare @Role varchar(2)
	
	while CHARINDEX(',',@BusinessRoles) > 0
	Begin
	
		select @Role = LEFT(@BusinessRoles,CharIndex(',',@BusinessRoles)-1)
		Insert ContactRole
			(
			 CntctRleCntctID
			,CntctRleTpe
			)
		Values
			(
			 @i_NewID
			,@Role
			)
			
		select @BusinessRoles = Right(@BusinessRoles,Datalength(@BusinessRoles) - Charindex(',',@BusinessRoles))

	End
	
	if coalesce(@BusinessRoles,'') > ''
	begin
		Select @Role = @BusinessRoles

		Insert ContactRole
			(
			 CntctRleCntctID
			,CntctRleTpe
			)
		Values
			(
			 @i_NewID
			,@Role
			)
	end
	
	if coalesce(@UserName,'') != ''
	begin

		-- Get new id
		Execute sp_getkey 'Users', @i_NewUserID Output

		-- If error...
		If @i_NewUserID Is Null Or @i_NewUserID = 0 
			Raiserror ('The attempt to generate a new UserID failed',16,0)

		-- Insert Office
		Insert Users
			(
			 UserID
			,UserDfltLcleID
			,UserDfltClntlID
			,UserCntctID
			,UserStat
			,UserNckNme
			,UserDBMnkr
			,UserEMlAddrss
			)
		Values
			(
			 @i_NewUserID
			,NULL
			,NULL
			,@i_NewID
			,'A'
			,@NickName
			,@UserName
			,@Email
			)
			
			Declare @i_RoleID int
			
			while CHARINDEX(',',@UserRoles) > 0
			Begin
			
				select @Role = LEFT(@UserRoles,CharIndex(',',@UserRoles)-1)
				select @i_RoleID = CONVERT(int,@Role)
				
				Insert UserRole
					(
					 UserRoleUserID
					,UserRoleRoleID
					)
				Values
					(
					 @i_NewUserID
					,@i_RoleID
					)
					
				select @UserRoles = Right(@UserRoles,Datalength(@UserRoles) - Charindex(',',@UserRoles))

			End
			
			Select @Role = @UserRoles
			select @i_RoleID = CONVERT(int,@Role)

			Insert UserRole
				(
				 UserRoleUserID
				,UserRoleRoleID
				)
			Values
				(
				 @i_NewUserID
				,@i_RoleID
				)

		end		

	-- Commit transaction
	Commit Transaction
	
	select @KeyValueList = convert(varchar(255), @i_newID)
	exec race_AddraceTag @RaceTag, @Entity, @TableName, @ColumnList, @KeyValueList

	Select 'Insert Contact Successful', @i_NewID

End Try

Begin Catch

	if @@TRANCOUNT > 0
		rollback transaction
	declare @message varchar(255),
			@severity int
	
	select @message = ERROR_MESSAGE(), @severity=ERROR_SEVERITY()
	
	Raiserror (@message,@severity,0)
	
End Catch

SET IDENTITY_INSERT Contact OFF
