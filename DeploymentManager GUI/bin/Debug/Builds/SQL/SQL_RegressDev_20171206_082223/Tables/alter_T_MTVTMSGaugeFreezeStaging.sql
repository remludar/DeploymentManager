If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSGaugeFreezeStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

	Execute SRA_Index_Check @s_table	= 'MTVTMSGaugeFreezeStaging', 
				    @s_index		= 'IK_MTVTMSGaugeFreezeStaging_fyr_fmo_fno',
				    @s_keys			= 'term_id,prod_code,tank,folio_mo,folio_no,action',
				    @c_unique		= 'N',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'N',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';				    
END