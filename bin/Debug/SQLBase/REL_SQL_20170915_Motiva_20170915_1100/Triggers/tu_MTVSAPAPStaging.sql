SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_MTVSAPAPStaging') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_MTVSAPAPStaging
    IF OBJECT_ID('dbo.tu_MTVSAPAPStaging') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_MTVSAPAPStaging >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_MTVSAPAPStaging >>>'
  END
go


CREATE trigger tu_MTVSAPAPStaging on dbo.MTVSAPAPStaging AFTER UPDATE as
begin

if UPDATE(SAPStatus)
begin
	
	Update	PayableHeader
	Set		FedDate = getdate()
	Where	FedDate	is null
	And		Exists	(
					Select	1
					From	Inserted
							Inner Join CustomMessageQueue
								on	CustomMessageQueue.ID		= Inserted.CIIMssgQID
								and	CustomMessageQueue.Entity	= 'PH'
					Where	PayableHeader.PybleHdrID	= CustomMessageQueue.EntityID
					)
	And		Exists	(
					Select	1
					From	Inserted
							Inner Join Deleted
								on	Deleted.ID	= Inserted.ID
					Where	Inserted.SAPStatus	= 'I'
					And		Deleted.SAPStatus	<> 'I'
					)

end

end

GO

IF OBJECT_ID('dbo.tu_MTVSAPAPStaging') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_MTVSAPAPStaging >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_MTVSAPAPStaging >>>'

go
