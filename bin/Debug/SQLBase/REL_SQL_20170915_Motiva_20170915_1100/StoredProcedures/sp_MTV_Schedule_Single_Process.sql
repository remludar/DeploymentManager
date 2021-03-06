/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_MTV_Schedule_Single_Process WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_MTV_Schedule_Single_Process]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTV_Schedule_Single_Process.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_MTV_Schedule_Single_Process]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[SP_MTV_Schedule_Single_Process] AS SELECT 1'
			PRINT '<<< CREATED Procedure SP_MTV_Schedule_Single_Process >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[SP_MTV_Schedule_Single_Process]    Script Date: 11/17/2016 8:20:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[SP_MTV_Schedule_Single_Process] @ai_PrcssGrpID  int,		/* The Proces Group ID to schedule */
					@avc_Prmtr      Varchar(MAX) = '',	/* The Parameter to pass to the process */
					@adt_BgnTme     smalldatetime = Null,   /* The Beginning time for the process, 
										   defaults to the current system datetime*/
					@ac_Frqncy      Char(1) = 'N',		/* The Frequency to reschdule the process, 
										   defaults to 'N'one */
					@avc_Hst	Varchar(50) = Null,	/* The host computer on which the process 
										   should run, defaults to system value */
					@ac_stts	Char(1) = 'A'		/* The status of the process, defaults 
										   to 'A'ctive */
as

/*------------------------------------------------------------------------------------------------------------------------------------
-- SP:             SP_Schedule_Single_Process		Copyright 1997-2006 SolArc
-- Tables:         GeneralConfiguration, ProcessSchedulerII, ProcessParameter
-- Stored Procs:   none
-- Dynamic Tables: none
-- Overview:       Schedules a process to be run by inserting a record into ProcessSchedulerII, and
--		   inserting the parameters into ProcessParameters.
--
-- Created by:     Pat Newgent
-- History:        04/16/1997 - First Created
-- Date Modified Modified RAID   Modification
-- ------------- -------- ------ -------------------------------------------------------------------------------------------
-- 12/20/2005	 RPN      63410  Corrected null comparison syntax.
--                               Changed logic to schedule to process queue & not host computer.  As a result, the argument 
--                               @avc_Hst now represents the process queue.
--                               RAMQ processing was changed in s3 to no longer allow scheduling to specific Host Computers.
----------------------------------------------------------------------------------------------------------------------------------*/


Declare @i_PrcssSchdlrID int
Declare @i_PrcssGrpRltnID int

/*----------------------------------------------------------- 
-- If no host parameter was passed, then determine the system
-- default from GeneralConfiguration
-----------------------------------------------------------*/
If @avc_hst is null
   Begin
      Select @avc_Hst = GnrlCnfgMulti
      From GeneralConfiguration
      Where GnrlCnfgQlfr = 'DefaultHostMachine'
   End

/*----------------------------------------------------------- 
-- If no beginning datetime was passed, then set the beggining
-- datetime to now.
-----------------------------------------------------------*/
if @adt_BgnTme is null
   Begin
	Select @adt_BgnTme = getdate()
   End


/*----------------------------------------------------------- 
-- Determine the next ProcessScheduler key, and insert the
-- process to be scheduled.
-----------------------------------------------------------*/
Exec SP_getkey 'ProcessSchedulerII', @i_PrcssSchdlrID output

Insert ProcessSchedulerII
   (PrcssSchdlrIIID,
    PrcssSchdlrIIPrcssGrpID,
    PrcssSchdlrIINxtRnDteTme,
    PrcssSchdlrStts,
    PrcssSchdlrPrd,
--    PrcssSchdlrHstCmptr)
    PrcssQNme)
Values (@i_PrcssSchdlrID,
	@ai_PrcssGrpID,
	@adt_BgnTme,
	@ac_stts,
	@ac_Frqncy,
	@avc_Hst)


/*----------------------------------------------------------- 
-- Determine the ProcessGroupRelationID for the single process
-- being scheduled, and insert the parameters into 
-- ProcessParameter.
-----------------------------------------------------------*/
Select 	@i_PrcssGrpRltnID = PrcssGrpRltnID
From 	ProcessGroup, ProcessGroupRelation
Where 	PrcssGrpSnglePrcss = 'Y'
and   	PrcssGrpID = @ai_PrcssGrpID
and   	PrcssGrpID = PrcssGrpRltnPrcssGrpID

Insert ProcessParameter
   (PrcssPrmtrPrcssSchdlrIIID,
    PrcssPrmtrPrcssGrpRltnID,
    PrcssPrmtrPrmtr)
Values (@i_PrcssSchdlrID,
	@i_PrcssGrpRltnID,
	@avc_Prmtr)

