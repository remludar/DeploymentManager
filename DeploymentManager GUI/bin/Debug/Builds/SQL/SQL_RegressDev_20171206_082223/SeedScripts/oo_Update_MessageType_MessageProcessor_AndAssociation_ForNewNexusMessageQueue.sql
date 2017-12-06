if not exists (select top 1 * from MessageProcessor where MessageProcessorNm = 'NexusMessage')
begin
insert into MessageProcessor (MessageProcessorNm) values ('NexusMessage')
end

if not exists (select top 1 * from MessageType where MessageTypeDesc = 'NexusMessage')
begin
insert into MessageType (MessageTypeDesc) values ('NexusMessage')
end

if exists (select top 1 * from MessageTypeMessageProcessor where 
					MessageTypeID = (select top 1 MessageTypeID from MessageType where MessageTypeDesc = 'NexusMessage')
					and MessageProcessorID = (select top 1 MessageProcessorID from MessageProcessor where MessageProcessorNm = 'Default'))
begin
delete from MessageTypeMessageProcessor where 
					MessageTypeID = (select top 1 MessageTypeID from MessageType where MessageTypeDesc = 'NexusMessage')
					and MessageProcessorID = (select top 1 MessageProcessorID from MessageProcessor where MessageProcessorNm = 'Default')
end

if not exists (select top 1 * from MessageTypeMessageProcessor where 
					MessageTypeID = (select top 1 MessageTypeID from MessageType where MessageTypeDesc = 'NexusMessage')
					and MessageProcessorID = (select top 1 MessageProcessorID from MessageProcessor where MessageProcessorNm = 'NexusMessage'))
begin
insert into MessageTypeMessageProcessor (MessageTypeID, MessageProcessorID) 
	values ((select top 1 MessageTypeID from MessageType where MessageTypeDesc = 'NexusMessage'),
			(select top 1 MessageProcessorID from MessageProcessor where MessageProcessorNm = 'NexusMessage'))
end