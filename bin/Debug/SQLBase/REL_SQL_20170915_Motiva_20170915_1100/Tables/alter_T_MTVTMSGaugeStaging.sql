If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSGaugeStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

	Execute SRA_Index_Check @s_table	= 'MTVTMSGaugeStaging', 
				    @s_index		= 'IK_MTVTMSGaugeStaging_tmstransref',
				    @s_keys			= 'trans_ref_no,term_id,tank,prod_id',
				    @c_unique		= 'N',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'N',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';				    
END