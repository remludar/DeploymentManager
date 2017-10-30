DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '''F'',''T'',''X'',''E'''

EXECUTE SP_Set_Registry_Value 'Motiva\CustomTransferStatus\',@RegEntry

GO