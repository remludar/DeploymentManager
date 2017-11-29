/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_Invoice_Template_Footer WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_Invoice_Template_Footer]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Footer.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_Invoice_Template_Footer]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_Invoice_Template_Footer] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure SP_Invoice_Template_Footer >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].[SP_Invoice_Template_Footer] @i_SlsInvceHdrID int
as
/*
Create Table #CorrespondenceAddress
(ContactName varchar(80) null,
 Phone varchar(80) null,
 Address1 varchar(50) null,
 Address2 varchar(50) null,
 Address3 varchar(50) null,
 Address4 varchar(50) null)


Declare  @i_Internalbaid  int 
	, @i_Externalbaid  int 
	, @i_SlsInvceTpeID int 
	, @c_BARelationShip char(1) 

Declare	@i_FOBLcleID int 
	, @i_CntctID int
	, @i_PrdctID int

Select  TOP 1
	@i_Internalbaid = SlsInvceHdrIntrnlBAID
	, @i_Externalbaid = SlsInvceHdrBARltnBAID
	, @i_SlsInvceTpeID = SlsInvceHdrSlsInvceTpeID
	, @c_BARelationShip = SlsInvceHdrBARltnRltn
	, @i_FOBLcleID = SlsInvceDtlFOBLcleID
	, @i_PrdctID = SlsInvceDtlPrntPrdctID
From   SalesInvoiceHeader
	Inner Join SalesInvoiceDetail on (SlsInvceHdrID = SlsInvceDtlSlsInvceHdrID)
Where  SlsInvceHdrID = @i_SlsInvceHdrID

--select top 1 @i_FOBLcleID = SlsInvceDtlFOBLcleID, @i_PrdctID = SlsInvceDtlPrntPrdctID from salesinvoicedetail where slsinvcedtlslsinvcehdrid = 268763

exec dbo.sp_RtrveAcctgPrfle
	@c1_indctr = 'S',
	@c1_prchse = null,
	@i_sls = @i_SlsInvceTpeID,
	@c1_rltn = @c_BARelationShip,
	@c1_mvmt = null,
	@i_prdct = @i_PrdctID,
	@i_lcle = @i_FOBLcleID,
	@i_usrid = 0,
	@i_rtrn1 = @i_CntctID Out,
	@i_intrnl = @i_Internalbaid,
	@i_extrnl = @i_Externalbaid


Insert #CorrespondenceAddress
Exec sp_RtrveAddrss @i_BAID = @i_Internalbaid, @i_crrspnd = 1, @c1_dlvry = 'PM', @i_CntctID = @i_CntctID

Select	'Send Correspondence only to: ' + 
	Case 
            When AltBAName. GnrlCnfgMulti is null then BANme + BANmeExtended 
            Else AltBAName. GnrlCnfgMulti
        End +
        Case When Address1 is null then ''
             Else ' - ' + Address1
	End + 
        Case When Address2 is null then ''
             Else ' - ' + Address2
	End + 
        Case When Address3 is null then ''
             Else ' - ' + Address3
	End + 
        Case When Address4 is null then ''
             Else ' - ' + Address4
	End 'CompanyAddress'
From	#CorrespondenceAddress
	Inner Join BusinessAssociate on (BAID = @i_Internalbaid)
	Left Outer Join GeneralConfiguration as AltBAName on  (BAID = AltBAName. GnrlCnfgHdrID
                                                        and  AltBAName. GnrlCnfgQlfr = 'InvoiceDisplayName')
	Left Outer Join GeneralConfiguration as AltBANameAbbv on  (BAID = AltBANameAbbv. GnrlCnfgHdrID
                                                        and  AltBANameAbbv. GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm')

*/

Select	Case 
            When AltBAName. GnrlCnfgMulti is null then BANme + BANmeExtended 
            Else AltBAName. GnrlCnfgMulti
        End 'InternalBAName', 
	Case 	When Address. AddressLine1 is null or rtrim(Address. AddressLine1) = '' then ''
             	Else ' - ' + Address. AddressLine1
	End + 
      	Case 	When Address. AddressLine2 is null or rtrim(Address. AddressLine2) = '' then ''
             	Else ' - ' + Address. AddressLine2
	End + 
        Case 	When Address. CityStateZip is null or rtrim(Address. CityStateZip) = '' then ''
             	Else ' - ' + Address. CityStateZip
	End + 
        Case 	When Address. Country is null  or rtrim(Address. Country) = '' then ''
             	Else ' - ' + Address. Country
	End 'InternalAddress'
From	SalesInvoiceHeader
	Inner Join BusinessAssociate on (SlsInvceHdrIntrnlBAID = BAID)
	Left Outer Join GeneralConfiguration as AltBAName on  (BAID = AltBAName. GnrlCnfgHdrID
                                                        and  AltBAName. GnrlCnfgQlfr = 'InvoiceDisplayName')
	Left Outer Join GeneralConfiguration as AltBANameAbbv on  (BAID = AltBANameAbbv. GnrlCnfgHdrID
                                                        and  AltBANameAbbv. GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm')
	Left Outer Join Contact on (InternalCntctID = Contact.CntctID)
	Left Outer Join v_AddressInformation as Address	on (Contact.CntctID = Address.CntctID
							and Contact.CntctOffceLcleID = Address.LcleID
							and Address.DeliveryMethod = 'P'
							and Address.Type = 'M')
Where	SlsInvceHdrID = @i_SlsInvceHdrID



GO


if OBJECT_ID('SP_Invoice_Template_Footer')is not null begin
   --print "<<< Procedure SP_Invoice_Template_Footer created >>>"
   grant execute on SP_Invoice_Template_Footer to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure SP_Invoice_Template_Footer failed >>>"