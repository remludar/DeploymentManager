

/****** Object:  UserDefinedFunction [dbo].[fnParseList]    Script Date: 5/26/2016 7:06:23 PM ******/
IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseList]') IS NOT NULL
BEGIN

DROP FUNCTION [dbo].[fn_MTV_ParseList]
PRINT '<<< DROPPED Function dbo.[fn_MTV_ParseList] >>>'

END
GO

/****** Object:  UserDefinedFunction [dbo].[fnParseList]    Script Date: 5/26/2016 7:06:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE Function [dbo].[fn_MTV_ParseList]
(
	@Delimiter varchar(2),
	@Text TEXT
)
Returns @Result TABLE (RowID smallint identity(1,1) PRIMARY KEY, Data varchar(8000))
AS

Begin
	Declare @NextPos int,
			@LastPos int
			
	Select	@NextPos = CharIndex(@Delimiter, @Text, 1),
			@LastPos = 0
	
	While @NextPos > 0
	Begin
		Insert @Result (Data)
		Select  Substring(@Text, @LastPos + 1, @NextPos - @LastPos - 1)
		
		select  @LastPos = @NextPos,
				@NextPos = CharIndex(@Delimiter, @Text, @NextPos + 1)
	End
	
	If @NextPos <= @LastPos
		Insert @Result (Data)
		Select Substring(@Text, @LastPos + 1, DataLength(@Text) - @LastPos)
		
	Return
End

GO


IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseList]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_MTV_ParseList.sql'
			PRINT '<<< CREATED Function fn_MTV_ParseList >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function fn_MTV_ParseList >>>'
	  END
GO