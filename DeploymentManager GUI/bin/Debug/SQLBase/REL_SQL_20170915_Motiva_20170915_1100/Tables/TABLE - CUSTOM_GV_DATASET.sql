
/*
As an example of how to use this table.  If you wanted to put in BALMO quotes 
for PLATTS for #PA00026689MM01 to #PA00026689MM04, you would configure a BALMO 
curve in RA with an interface code of #PA00026689.  Then you would NOT set it 
as a GV Curve (that is, you would not set the PriceSourceGV attribute to Yes, 
you would leve it unpopulated or set it to NO instead).  This table overrides
the default functionality to allow you to explicitly specify what to pull from 
globalview.  Next, you'd enter rows into this table to configure how you want
to map those codes.  In our example, PLATTS is RawPriceHeader ID 2, and the 
curve we have set up for this is RawPriceLocale ID 215.  We do not need any 
Price Multipliers for this example, so we put NULL in for that. The gv Request
Type for these rows is PLATTSFUTURE.  Example entries are : 

Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', '#PA00026689', '#PA00026689MM01D', 1, 215, 'Close', 'Settle', 'GlobalView', null, 'PLATTSFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', '#PA00026689', '#PA00026689MM02D', 2, 215, 'Close', 'Settle', 'GlobalView', null, 'PLATTSFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', '#PA00026689', '#PA00026689MM03D', 3, 215, 'Close', 'Settle', 'GlobalView', null, 'PLATTSFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', '#PA00026689', '#PA00026689MM04D', 4, 215, 'Close', 'Settle', 'GlobalView', null, 'PLATTSFUTURE', 'A')

This data is then appended to the default view, and will end up in the dataset,
and the accelerator will process it normally.  In the example above, it will 
request Instrumet ID's of #PA00026689MM01 to #PA00026689MM04, but it will feed
them all to curve 215 using Interface Code #PA00026689.  

If you needed to pull two curves from GV, and put them into one curve in RA,
this can be done by doing the same thing, create two insert rows.  For example,
if you want to pull from Instrument ID #PAAMB01 Close and #PAMB02 Close and put
the 01 value into the curve's High, and the 02 value into the Low value, you 
would insert the following into the table (Assuming your aggregate curve is 512
and you have set the interface code to 'MyCombinedCurve') : 

Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', 'MyCombinedCurve', '#PAAMB01', null, 512, 'Close', 'High', 'GlobalView', null, 'DAILY', 'A')
Insert Into CUSTOM_GV_DATASET Values (2, 'PLATTS', 'MyCombinedCurve', '#PAAMB02', null, 512, 'Close', 'Low',  'GlobalView', null, 'DAILY', 'A')

If you need to pull past prices for a NYMEX Future curve, the default offset 
logic that GV uses for pulling futures won't work for loading past futures.  
This can be gotten around with a bit of manual work.  To do this, you'd insert 
rows into this table to handle the Futures you want to load, then disable the 
Future curve by setting PriceSourceGV to NO.  Remember, rows in this table that 
are ACTIVE override the default logic and are always processed.  If you wanted 
to pull historic prices for NYMEX Heating Oil (/HO) for the month of March 2016, you would 
insert the following into the table (Assuming your NYMEX service is price header 1,
and your /CL curve is curve ID 100): 

Insert Into CUSTOM_GV_DATASET Values (1, 'NYMEX', '/CL', '/CL',    null, 100, 'Close', 'Close', 'GlobalView', null, 'NYMEXFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (1, 'NYMEX', '/CL', '/CLJ16', null, 100, 'Close', 'Close', 'GlobalView', null, 'NYMEXFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (1, 'NYMEX', '/CL', '/CLK16', null, 100, 'Close', 'Close', 'GlobalView', null, 'NYMEXFUTURE', 'A')
...
Insert Into CUSTOM_GV_DATASET Values (1, 'NYMEX', '/CL', '/CLG17', null, 100, 'Close', 'Close', 'GlobalView', null, 'NYMEXFUTURE', 'A')
Insert Into CUSTOM_GV_DATASET Values (1, 'NYMEX', '/CL', '/CLH17', null, 100, 'Close', 'Close', 'GlobalView', null, 'NYMEXFUTURE', 'A')

This would tell GV to pull /CL for any date range you input (theoretically 
Mar 01, 2016 to Mar 31, 2016), and request 12 months worth of futures for those 
futures, (/CLJ16 to /CLH17 = April 2016 to March 2017), as well as the daily
quote for the /CL curve (that would be the instrument ID of /CL).  You would
then run the GV interface and tell it to only process interface code /CL, which
would pull all 13 lines fromt he GV DataSet table and process them.  This would 
pull in the historical futures for /CL.  You could then inactivate those rows,
or update the instrument IDs to pull May 2016 to April 2017 and load April 2016
/CL Historical data using the rows. 

Using this table you can force GV to load specific data for one time runs for 
go live activity that is not performed under normal day to day operations. Or,
you can configure unusual situations where you want multiple instruments to be
fed into one curve.  
*/


IF OBJECT_ID('CUSTOM_GV_DATASET') Is NULL
BEGIN
  
	Create Table dbo.CUSTOM_GV_DATASET (
    ID Int Identity
  , RPHdrID Int
  , RPHdrAbbv VarChar(20)
  , RPLcleIntrfceCde VarChar(100)
  , InstrumentID VarChar(100)
   , RwPrceLcleID Int
  , GVQuoteType VarChar(255)
  , GVRAQuoteType VarChar(255)
  , Source VarChar(80)
  , GVMultiplier VarChar(255)
  , GVRequestType VarChar(255)
  , Status Char(1)
  , PLATTSOffset Int default 0
  )

   PRINT '<<< CREATED Table dbo.CUSTOM_GV_DATASET >>>'
END
Else Begin
	PRINT '<<< Table dbo.CUSTOM_GV_DATASET ALREADY EXISTS >>>'
END

GO

GO

If OBJECT_ID('CUSTOM_GV_DATASET') Is NOT Null
BEGIN
            PRINT '<<< GRANTED PERMISSION TO Table CUSTOM_GV_DATASET >>>'
            Grant Select, Update, Delete, Insert, Alter on CUSTOM_GV_DATASET to SYSUSER
            Grant Select, Update, Delete, Insert, Alter on CUSTOM_GV_DATASET to RightAngleAccess
END
ELSE
            Print '<<<Failed Creating Table CUSTOM_GV_DATASET>>>'

GO
