/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSNominationDetermintAction WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTVTMSNominationDetermineAction]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_MTVTMSNominationDetermineAction].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSNominationDetermineAction]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTVTMSNominationDetermineAction] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_MTVTMSNominationDetermineAction] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_MTVTMSNominationDetermineAction]    Script Date: 5/16/2016 11:48:12 PM ******/
--exec sp_MTVTMSNominationDetermineAction 2, 1334
alter procedure dbo.sp_MTVTMSNominationDetermineAction 
(  @TMSFileIdnty int,  @orderid int )
AS

Declare @orderStatus char(1)
Declare @LastTMSFileIdnty int

              select @orderStatus = ( Select PlnndMvtStts From PlannedMovement where PlnndMvtID = @orderid  )

			  --if status = 'I' then you need to delete it if the last send to tms host is 'U'
			  --
			  if @orderStatus = 'I'
			  begin

			   
                    select @lastTMSFileIdnty = ( 
				      Select max(nom.TMSFileIdnty) 
                        From MTVTMSNominationStaging nom
                             inner join MTVTMSAccountToTmsStaging MA on MA.TMSFileIdnty = nom.TMSFileIdnty
                                                                    and MA.InterfaceStatus = 'C'
                                                                    and MA.Action = 'D' )

                     if @lastTMSFileIdnty is not null  --you need to do nothing it has already been deleted
                     begin
	    			     select 'I'
	    			     return
	    			 end
				
				     select @lastTMSFileIdnty = (
					    select max(nom.TMSFileIdnty)
					 From MTVTMSNominationStaging nom
					      inner join MTVTMSAccountToTMSStaging MA on MA.TMSFileIdnty = nom.TMSFIleIdnty
						                                         and MA.InterfaceStatus = 'C'
														    	 and MA.Action = 'U' ) 
				    if @lastTMSFileIdnty is not null -- you need to delete it
				    begin
					   select 'D'
					   return
					end
                
               end

			   --if you are here then the status wasn't 'I' if nothing for this order has been entered then you are good to go with a 'U'pdate status
			   select @lastTMSFileIdnty = ( 
				      Select max(nom.TMSFileIdnty) 
                        From MTVTMSNominationStaging nom
                             inner join MTVTMSAccountToTmsStaging MA on MA.TMSFileIdnty = nom.TMSFileIdnty
                                                                    and MA.InterfaceStatus = 'C'
                                                                    and MA.Action = 'U' )
               if @lastTMSFileIdnty is null
               begin
			      select 'U'
			      return
			   end

			   --if you are here then the status wasn't 'I' and there is a valid record sent to TMSHost
			   --you can't check to see if your primary key ( order_no and cust_no has changed until you determine what the cust_no is
			   --so return '?' as a placeholder to validate that the rows currently in tms are in the rows you are sending as an update
			  select 'U'
			  return

go



if OBJECT_ID('sp_MTVTMSNominationDetermineAction')is not null begin
   --print '<< Procedure sp_MTVTMSNominationDetermineAction created >>>'
   grant execute on sp_MTVTMSNominationDetermineAction to sysuser, RightAngleAccess
end
else
   print '<<<< Creation of procedure sp_MTVTMSNominationDetermineAction failed >>>'


   go