exec SRNTC_Create_ExternalColumn_JoinSyntax @vc_FromTable = 'PlannedTransfer',
	 @vc_ToTable = 'v_MTVT4Nominations',
	 @vc_TableAbbrv = 'T4 ',
	 @vc_TableDesc = 'T4 Order Status',
	 @vc_JoinType = 'OneToOne',
	 @vc_JoinSyntax = '[PlannedTransfer].PlnndTrnsfrID = [v_MTVT4Nominations].PlnndTrnsfrID'


