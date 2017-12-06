DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPPRD0134\apps\rightangle\webservicedata\datalake\BOLLifecycle\Outbound\MovementLifeCycle'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\BOLLifeCycle\Export\Path',@RegEntry

GO