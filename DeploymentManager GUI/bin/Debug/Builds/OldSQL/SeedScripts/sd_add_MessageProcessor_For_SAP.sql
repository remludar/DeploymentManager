/*
Select * From MessageType
Select * From MessageProcessor
Select * From MessageTypeMessageProcessor
*/

Insert MessageProcessor Select 'SAPandDefault' Where not exists (Select 1 From MessageProcessor Where MessageProcessorNm = 'SAPandDefault')

Insert	MessageTypeMessageProcessor (MessageTypeID, MessageProcessorID)
	Select MessageTypeID, (Select MessageProcessorId from MessageProcessor Where MessageProcessorNm = 'SAPandDefault')
	From MessageTypeMessageProcessor
	Where MessageProcessorId = (Select MessageProcessorId from MessageProcessor Where MessageProcessorNm = 'Default')
	And		Not Exists (Select 1 From MessageTypeMessageProcessor Where MessageProcessorID = (Select MessageProcessorId from MessageProcessor Where MessageProcessorNm = 'SAPandDefault'))

Delete	MessageTypeMessageProcessor
Where	MessageProcessorId = (Select MessageProcessorId from MessageProcessor Where MessageProcessorNm = 'Default')
and		MessageTypeID = (Select MessageTypeID from MessageType where MessageTypeDesc = 'MTVSAPRequestMessageHandler')
