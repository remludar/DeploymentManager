Go
Update dbo.MTVT4LineItemsStaging 
set RecordStatus = 'I'
where PipelineEventStatus = 'JCT'
Go