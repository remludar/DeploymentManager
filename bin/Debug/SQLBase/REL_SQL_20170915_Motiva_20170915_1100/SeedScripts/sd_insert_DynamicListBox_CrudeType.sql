
delete FROM DynamicListBox WHERE DynLstBxQlfr = 'CrudeType'
Declare @i_Key Int
Declare @vc_Qualifier Varchar(20)
Declare @vc_Type Varchar(40)
Declare @vc_Description Varchar(80)
Declare @vc_Abbreviation Varchar(40)
Declare	@si_Order smallint
Declare @c_TableType char(1)
Declare @c_Status Char(1)

Select	@vc_Qualifier = 'CrudeType',
		@vc_Type = 'Arabian',
		@vc_Description = 'Arabian',
		@vc_Abbreviation = 'Arabian',
		@si_Order = 10,
		@c_TableType = 'M',
		@c_Status = 'A'
		
If	Not Exists
	(
	Select	1
	From	DynamicListBox
	Where	DynLstBxQlfr = @vc_Qualifier
	And		DynLstBxDesc = @vc_Description
	)
Begin
	execute dbo.sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_Key Out, @i_increment = 1, @c_resultset = 'N' 

	Insert	DynamicListBox
			(
			DynLstBxID,
			DynLstBxQlfr,
			DynLstBxTyp,
			DynLstBxDesc,
			DynLstBxAbbv,
			DynLstBxOrdr,
			DynLstBxTblTyp,
			DynLstBxStts
			)
	Select	@i_Key,
			@vc_Qualifier,
			@vc_Type,
			@vc_Description,
			@vc_Abbreviation,
			@si_Order,
			@c_TableType,
			@c_Status
End

Select	@vc_Qualifier = 'CrudeType',
		@vc_Type = 'Domestic',
		@vc_Description = 'Domestic',
		@vc_Abbreviation = 'Domestic',
		@si_Order = 20,
		@c_TableType = 'M',
		@c_Status = 'A'
		
If	Not Exists
	(
	Select	1
	From	DynamicListBox
	Where	DynLstBxQlfr = @vc_Qualifier
	And		DynLstBxDesc = @vc_Description
	)
Begin
	execute dbo.sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_Key Out, @i_increment = 1, @c_resultset = 'N' 

	Insert	DynamicListBox
			(
			DynLstBxID,
			DynLstBxQlfr,
			DynLstBxTyp,
			DynLstBxDesc,
			DynLstBxAbbv,
			DynLstBxOrdr,
			DynLstBxTblTyp,
			DynLstBxStts
			)
	Select	@i_Key,
			@vc_Qualifier,
			@vc_Type,
			@vc_Description,
			@vc_Abbreviation,
			@si_Order,
			@c_TableType,
			@c_Status
End

Select	@vc_Qualifier = 'CrudeType',
		@vc_Type = 'Foreign',
		@vc_Description = 'Foreign',
		@vc_Abbreviation = 'Foreign',
		@si_Order = 30,
		@c_TableType = 'M',
		@c_Status = 'A'
		
If	Not Exists
	(
	Select	1
	From	DynamicListBox
	Where	DynLstBxQlfr = @vc_Qualifier
	And		DynLstBxDesc = @vc_Description
	)
Begin
	execute dbo.sp_getkey @vc_TbleNme = 'DynamicListBox', @i_Ky = @i_Key Out, @i_increment = 1, @c_resultset = 'N' 

	Insert	DynamicListBox
			(
			DynLstBxID,
			DynLstBxQlfr,
			DynLstBxTyp,
			DynLstBxDesc,
			DynLstBxAbbv,
			DynLstBxOrdr,
			DynLstBxTblTyp,
			DynLstBxStts
			)
	Select	@i_Key,
			@vc_Qualifier,
			@vc_Type,
			@vc_Description,
			@vc_Abbreviation,
			@si_Order,
			@c_TableType,
			@c_Status
End

Go


