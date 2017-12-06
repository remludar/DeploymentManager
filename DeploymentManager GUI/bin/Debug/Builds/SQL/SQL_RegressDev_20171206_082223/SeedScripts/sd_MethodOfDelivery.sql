
--****************************************************************************************************************
-- SeedData:	sd_MethodOfDelivery                                                     Copyright 2016 OpenLink
-- Overview:	This will set up the Method of Delivery records (Document Generation)
-- Created by:	Sean Brown
-- History:     18 May 2016 - First Created
--****************************************************************************************************************
-- 	Date         Modified By     Issue#  Modification
-- 	-----------  --------------  ------  -------------------------------------------------------------------------
--  18 May 2016  S. Brown                Initial Creation
--****************************************************************************************************************
Set ANSI_NULLS ON
Set QUOTED_IDENTIFIER OFF
GO

Print 'Start Script = sd_MethodOfDelivery.sql  Domain = MTV  Time = ' + Convert(Varchar(50), GetDate(), 109) + ' ON ' + @@SERVERNAME + '.' + db_name()
GO

Select  *
From    dbo.MethodOfDelivery

Insert  dbo.MethodOfDelivery (MethodOfDeliveryID, Description, Abbreviation)
Select  'E', 'Email', 'Email'
Where   Not Exists (Select  'x'
                    From    dbo.MethodOfDelivery
                    Where   MethodOfDeliveryID = 'E')

Insert  dbo.MethodOfDelivery (MethodOfDeliveryID, Description, Abbreviation)
Select  'S', 'Salesforce', 'Salesforce'
Where   Not Exists (Select  'x'
                    From    dbo.MethodOfDelivery
                    Where   MethodOfDeliveryID = 'S')



Select  *
From    dbo.MethodOfDelivery

Print   'Method of Delivery setup complete.  Domain = MTV  Time = ' + Convert(Varchar(50), GetDate(), 109) + ' ON ' + @@SERVERNAME + '.' + db_name()

-----------------------------------------------------------------------------------------------------------------|