SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_MTVSAPARStaging') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_MTVSAPARStaging
    IF OBJECT_ID('dbo.tu_MTVSAPARStaging') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_MTVSAPARStaging >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_MTVSAPARStaging >>>'
  END
go


CREATE trigger tu_MTVSAPARStaging on dbo.MTVSAPARStaging AFTER UPDATE as
begin

if UPDATE(SAPStatus)
begin

	Update	SalesInvoiceHeader
	Set		SlsInvceHdrFdDte	= getdate()
	Where	SlsInvceHdrFdDte	is null
	And		Exists	(
					Select	1
					From	Inserted
							Inner Join CustomMessageQueue
								on	CustomMessageQueue.ID		= Inserted.CIIMssgQID
								and	CustomMessageQueue.Entity	= 'SH'
					Where	SalesInvoiceHeader.SlsInvceHdrID	= CustomMessageQueue.EntityID
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

IF OBJECT_ID('dbo.tu_MTVSAPARStaging') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_MTVSAPARStaging >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_MTVSAPARStaging >>>'

go
