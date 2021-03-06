/****** Object:  StoredProcedure [dbo].[SP_MTV_RAMQ_Publish]    Script Date: 12/7/2016 9:28:42 AM ******/
PRINT 'Start Script=SP_MTV_RAMQ_Publish.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_MTV_RAMQ_Publish]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_MTV_RAMQ_Publish] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure SP_MTV_RAMQ_Publish >>>'
	  END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[SP_MTV_RAMQ_Publish]
	@vc255_msg	varchar(255),
	@vc255_arg	varchar(2000),
	@i_PblshdMssgeID	int=NULL OUTPUT
As

-----------------------------------------------------------------------------------------------------------------------------
-- SP:            dbo.SP_MTV_RAMQ_Publish           Copyright 1997,1998, 1999 SolArc
-- Arguments:	 
-- Tables:         Tables
-- Indexes: LIST ANY INDEXES used in OPTIMIZER hints
-- Stored Procs:   StoredProcedures
-- Dynamic Tables: DynamicTables
-- Overview:       DocumentFunctionalityHere
--
-- Created by:     Sanjay Kumar
-- History:        12/3/16 - First Created
-- Date Modified Modified By        Modification
-- ------------- ------------------ -------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON

insert into publishedmessage
	(Message,
	Argument,
	PublishedDate,
	Status,
	ScheduledResponseDate
	)
values
	(@vc255_msg,
	@vc255_arg,
	DATEADD(DAY, -1, getdate()),
	'N',
	DATEADD(DAY, -1, getdate())
	)

select @i_PblshdMssgeID = @@identity

Set NoCount OFF

