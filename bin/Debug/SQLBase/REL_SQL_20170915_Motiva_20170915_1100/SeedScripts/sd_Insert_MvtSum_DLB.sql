-- Select * from DynamicListBox
declare @i_key int

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumPrdctSubgroups', 0, 'All Product Types', 'All', 0, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumPrdctSubgroups', 1, 'Gasoline, Diesel, Heat, Ethanol, Jet', 'Gasoline,Diesel,Heat,Ethanol,Jet', 10, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumPrdctSubgroups', 2, 'Diesel, Heat', 'Diesel,Heat', 20, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumPrdctSubgroups', 3, 'Gasoline, Ethanol', 'Gasoline,Ethanol', 30, 'I', 'A'



exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumExcludeMvtTyp', 0, 'Exclude None', 'None', 10, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumExcludeMvtTyp', 1, 'Exclude IT', 'IT', 20, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumExcludeMvtTyp', 2, 'Exclude Pumpover', 'Pumpover', 30, 'I', 'A'

exec sp_getkey 'DynamicListBox', @i_key out
Insert	DynamicListBox (DynLstBxID, DynLstBxQlfr, DynLstBxTyp, DynLstBxDesc, DynLstBxAbbv, DynLstBxOrdr, DynLstBxTblTyp, DynLstBxStts)
Select	@i_key, 'MvtSumExcludeMvtTyp', 3, 'Exclude IT & Pumpover', 'IT,Pumpover', 40, 'I', 'A'