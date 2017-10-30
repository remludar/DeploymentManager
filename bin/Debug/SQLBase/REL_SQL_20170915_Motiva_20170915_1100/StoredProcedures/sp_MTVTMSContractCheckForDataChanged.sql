/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSContractCheckForDataChanged WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTVTMSContractCheckForDataChanged]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSContractCheckForDataChanged.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractCheckForDataChanged]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTVTMSContractCheckForDataChanged] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTVTMSContractCheckForDataChanged >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--exec sp_MTVTMSContractCheckForDataChanged 104591,104684
Alter Procedure [dbo].sp_MTVTMSContractCheckForDataChanged @NewTMSFileIdnty int, @OldTMSFileIdnty int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTVTMSContractCheckForDataChanged           
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Deborah Keeton
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON



declare @customercount int
declare @accountcount  int
declare @acctprodcount int


            Select @customercount = Count(*)
              Where exists 
              (
              Select  isnull(action,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(cust_type,'') + isnull(cust_name,'') + isnull(short_cust_name,'') + isnull(name1,'') + isnull(name2,'') + 
			          isnull(addr1,'') + isnull(addr2,'')+ isnull(city,'') + isnull(state,'')+ isnull(zip,'') + isnull(country,'') + isnull(phone,'') + isnull(fax_group,'') + isnull(mail_group,'')
                    + isnull(contact_name,'') + isnull(eff_date,'') + isnull(exp_date,'') + isnull(locked,'') + isnull(lockout_date,'') + isnull(lockout_reason,'') + isnull(user_data_line1,'')
                    + isnull(user_data_line2,'') + isnull(user_data_line3,'') + isnull(user_data_line4,'') + isnull(user_data_line5,'') + isnull(freight,'') + isnull(cot_major,'') + isnull(cot_minor,'')
                    + isnull(tax_cert_no,'') + isnull(refiner_code,'') + isnull(credit_status,'') + isnull(emergency_no,'') + isnull(emergency_co,'') + isnull(dest_splc_code,'') + isnull(credit_risk,'')
                    + isnull(credit_id,'') + isnull(irs_h637,'') + isnull(fein,'') + isnull(dirty_flag,'') + isnull(vat_no,'')
                    + isnull(iso_language,'') + isnull(comp_reg_no,'') + isnull(inherit_supplier_prod,'') + isnull(is_consignor,'') + isnull(DutyToNumber,'') + isnull(contractrequired,'')
                    + isnull(ar_acct_no,'') + isnull(co_station,'') + isnull(agree_no,'') + isnull(print_fsii_data,'') + isnull(SuppressComponentPrinting,'') + isnull(SeasonalZone,'')
			  From MTVTMSCustomerStaging Where TMSFileIdnty = @NewTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'
             EXCEPT
               Select  isnull(action,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(cust_type,'') + isnull(cust_name,'') + isnull(short_cust_name,'') + isnull(name1,'') + isnull(name2,'') + 
			          isnull(addr1,'') + isnull(addr2,'')+ isnull(city,'') + isnull(state,'')+ isnull(zip,'') + isnull(country,'') + isnull(phone,'') + isnull(fax_group,'') + isnull(mail_group,'')
                    + isnull(contact_name,'') + isnull(eff_date,'') + isnull(exp_date,'') + isnull(locked,'') + isnull(lockout_date,'') + isnull(lockout_reason,'') + isnull(user_data_line1,'')
                    + isnull(user_data_line2,'') + isnull(user_data_line3,'') + isnull(user_data_line4,'') + isnull(user_data_line5,'') + isnull(freight,'') + isnull(cot_major,'') + isnull(cot_minor,'')
                    + isnull(tax_cert_no,'') + isnull(refiner_code,'') + isnull(credit_status,'') + isnull(emergency_no,'') + isnull(emergency_co,'') + isnull(dest_splc_code,'') + isnull(credit_risk,'')
                    + isnull(credit_id,'') + isnull(irs_h637,'') + isnull(fein,'') + isnull(dirty_flag,'') + isnull(vat_no,'')
                    + isnull(iso_language,'') + isnull(comp_reg_no,'') + isnull(inherit_supplier_prod,'') + isnull(is_consignor,'') + isnull(DutyToNumber,'') + isnull(contractrequired,'')
                    + isnull(ar_acct_no,'') + isnull(co_station,'') + isnull(agree_no,'') + isnull(print_fsii_data,'') + isnull(SuppressComponentPrinting,'') + isnull(SeasonalZone,'')
			  From MTVTMSCustomerStaging Where TMSFileIdnty = @OldTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'
              )

 
            Select @accountcount = Count(*)
              Where exists 
              (
              Select isnull(ACTION,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(acct_no,'') + isnull(acct_type,'') + isnull(acct_name,'') + isnull(short_acct_name,'') + 
                     isnull(name1,'') + isnull(name2,'') + isnull(addr1,'') + isnull(addr2,'') + isnull(city,'') + isnull(state,'') + isnull(zip,'') + isnull(country,'') + isnull(phone,'') + 
                     isnull(fax_group,'') + isnull(email_group,'') + isnull(contact_name,'') + isnull(delv_instr,'') + isnull(equip_instr,'') + isnull(credit_risk,'') + 
                     isnull(eff_date,'') + isnull(exp_date,'') + isnull(locked,'') + isnull(lockout_date,'') + isnull(lockout_reason,'') + isnull(user_data_line1,'') + isnull(user_data_line2,'') + isnull(user_data_line3,'') + 
                     isnull(user_data_line4,'') + isnull(user_data_line5,'') + isnull(emergency_no,'') + isnull(emergency_co,'') + isnull(freight,'') + isnull(cot_major,'') + isnull(cot_minor,'') + 
                     isnull(dest_splc_code,'') + isnull(po_number,'') + isnull(tax_cert_no,'') + isnull(refiner_code,'') + isnull(credit_status,'') + isnull(host_po_number,'') + isnull(contract_number,'') + 
                     isnull(adv_ship_notice,'') + isnull(zone,'') + isnull(retail_site_num,'') + isnull(def_transid,'') + isnull(credit_id,'') + isnull(irs_h637,'') + isnull(fein,'') + 
                     isnull(po_req,'') + isnull(relno_req,'') + isnull(gross_net,'') + isnull(special_msg,'') + isnull(prnt_reg_doc,'') + isnull(is_consignor,'') +  isnull(dirty_flag,'') + isnull(pbl_no,'') + 
                     isnull(haulier_test_no,'') + isnull(dispatch_test_no,'') + isnull(vat_no,'') + isnull(iso_language,'') + isnull(veh_acct_comp,'') + isnull(comp_reg_no,'') + isnull(inherit_cust_prods,'') + 
                     isnull(ulsd_epa_id,'') + isnull(DutyToNumber,'') + isnull(ar_acct_no,'') + isnull(co_station,'') + isnull(_reserved,'') + isnull(DestinationType,'') + isnull(TransportArrangement,'') + isnull(INCOTerms,'') + isnull(SeasonalZone,'')  
			  From MTVTMSAccountStaging Where TMSFileIdnty = @NewTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'
             EXCEPT
              Select isnull(ACTION,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(acct_no,'') + isnull(acct_type,'') + isnull(acct_name,'') + isnull(short_acct_name,'') + 
                     isnull(name1,'') + isnull(name2,'') + isnull(addr1,'') + isnull(addr2,'') + isnull(city,'') + isnull(state,'') + isnull(zip,'') + isnull(country,'') + isnull(phone,'') + 
                     isnull(fax_group,'') + isnull(email_group,'') + isnull(contact_name,'') + isnull(delv_instr,'') + isnull(equip_instr,'') + isnull(credit_risk,'') + 
                     isnull(eff_date,'') + isnull(exp_date,'') + isnull(locked,'') + isnull(lockout_date,'') + isnull(lockout_reason,'') + isnull(user_data_line1,'') + isnull(user_data_line2,'') + isnull(user_data_line3,'') + 
                     isnull(user_data_line4,'') + isnull(user_data_line5,'') + isnull(emergency_no,'') + isnull(emergency_co,'') + isnull(freight,'') + isnull(cot_major,'') + isnull(cot_minor,'') + 
                     isnull(dest_splc_code,'') + isnull(po_number,'') + isnull(tax_cert_no,'') + isnull(refiner_code,'') + isnull(credit_status,'') + isnull(host_po_number,'') + isnull(contract_number,'') + 
                     isnull(adv_ship_notice,'') + isnull(zone,'') + isnull(retail_site_num,'') + isnull(def_transid,'') + isnull(credit_id,'') + isnull(irs_h637,'') + isnull(fein,'') + 
                     isnull(po_req,'') + isnull(relno_req,'') + isnull(gross_net,'') + isnull(special_msg,'') + isnull(prnt_reg_doc,'') + isnull(is_consignor,'') + isnull(dirty_flag,'') + isnull(pbl_no,'') + 
                     isnull(haulier_test_no,'') + isnull(dispatch_test_no,'') + isnull(vat_no,'') + isnull(iso_language,'') + isnull(veh_acct_comp,'') + isnull(comp_reg_no,'') + isnull(inherit_cust_prods,'') + 
                     isnull(ulsd_epa_id,'') + isnull(DutyToNumber,'') + isnull(ar_acct_no,'') + isnull(co_station,'') + isnull(_reserved,'') + isnull(DestinationType,'') + isnull(TransportArrangement,'') + isnull(INCOTerms,'') + isnull(SeasonalZone,'') 
			  From MTVTMSAccountStaging Where TMSFileIdnty = @OldTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'

              )

            Select @acctprodcount= Count(*)
              Where exists 
              (
              Select isnull(ACTION,'') + isnull(term_id,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(acct_no,'') + isnull(prod_id,'') + isnull(spd_code,'') + 
                     isnull(contract_number,'') + isnull(active_enable,'') + isnull(auth_eff_dt,'') + isnull(auth_expr_dt,'') +  
                     isnull(dirty_flag,'') + isnull(source,'') + isnull(osp_interface_enabled,'') + isnull(ERPHandlingType,'') 
			   From MTVTMSAcctProdStaging Where TMSFileIdnty = @NewTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'
              EXCEPT
              Select isnull(ACTION,'') + isnull(term_id,'') + isnull(supplier_no,'') + isnull(cust_no,'') + isnull(acct_no,'') + isnull(prod_id,'') + isnull(spd_code,'') + 
                     isnull(contract_number,'') + isnull(active_enable,'') + isnull(auth_eff_dt,'') + isnull(auth_expr_dt,'') +  
                     isnull(dirty_flag,'') + isnull(source,'') + isnull(osp_interface_enabled,'') + isnull(ERPHandlingType,'') 
		      From MTVTMSAcctProdStaging Where TMSFileIdnty = @OldTMSFileIdnty and isnull(interfacestatus,'N') <> 'E'

			  )
			  
			  
			  select isnull(@customercount,0) + isnull(@accountcount,0) + isnull(@acctprodcount,0)
go



if OBJECT_ID('sp_MTVTMSContractCheckForDataChanged')is not null begin
   --print "<<< Procedure sp_MTVTMSContractCheckForDataChanged created >>>"
   grant execute on sp_MTVTMSContractCheckForDataChanged to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_MTVTMSContractCheckForDataChanged failed >>>"
 