
delete FROM DynamicListBox WHERE DynLstBxQlfr = 'TransferPriceType'
Declare @i_Key Int
Declare @vc_Qualifier Varchar(20)
Declare @vc_Type Varchar(40)
Declare @vc_Description Varchar(80)
Declare @vc_Abbreviation Varchar(40)
Declare	@si_Order smallint
Declare @c_TableType char(1)
Declare @c_Status Char(1)

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT01',
		@vc_Description = 'YT01',
		@vc_Abbreviation = 'YT01',
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT02',
		@vc_Description = 'YT02',
		@vc_Abbreviation = 'YT02',
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT03',
		@vc_Description = 'YT03',
		@vc_Abbreviation = 'YT03',
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT04',
		@vc_Description = 'YT04',
		@vc_Abbreviation = 'YT04',
		@si_Order = 40,
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


Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT05',
		@vc_Description = 'YT05',
		@vc_Abbreviation = 'YT05',
		@si_Order = 50,
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT06',
		@vc_Description = 'YT06',
		@vc_Abbreviation = 'YT06',
		@si_Order = 60,
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT07',
		@vc_Description = 'YT07',
		@vc_Abbreviation = 'YT07',
		@si_Order = 70,
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT08',
		@vc_Description = 'YT08',
		@vc_Abbreviation = 'YT08',
		@si_Order = 80,
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT09',
		@vc_Description = 'YT09',
		@vc_Abbreviation = 'YT09',
		@si_Order = 90,
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

Select	@vc_Qualifier = 'TransferPriceType',
		@vc_Type = 'YT10',
		@vc_Description = 'YT10',
		@vc_Abbreviation = 'YT10',
		@si_Order = 100,
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


