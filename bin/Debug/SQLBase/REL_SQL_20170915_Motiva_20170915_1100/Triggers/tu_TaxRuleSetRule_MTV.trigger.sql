SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tu_TaxRuleSetRule_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tu_TaxRuleSetRule_MTV
    IF OBJECT_ID('dbo.tu_TaxRuleSetRule_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tu_TaxRuleSetRule_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tu_TaxRuleSetRule_MTV >>>'
  END
go


CREATE trigger tu_TaxRuleSetRule_MTV on dbo.TaxRuleSetRule AFTER UPDATE as
begin

-----------------------------------------------------------------------------------------------------------------------------
-- Name:       tu_TaxRuleSetRule_MTV
-- Arguments: 
-- Tables:    
-- Indexes:   
-- SPs:        
-- Overview:   This custom update trigger will write records to the custom MTV_TaxAudit table to maintain
--             an easily identifiable record of updated TaxRuleSetRule records
-- Created by: Eric Wallerstein
-- History:    06/13/2012 - First Created
--*************************************************************************************
--
-- Date Modified  Modified By      Issue# Modification
-- -------------  ---------------  ------ ---------------------------------------------------------------------------------------------
--  06/13/2012    E.Wallerstein           Because SPID information can erroneously remain (or be removed) from the
--                                          LoginInformation table, we won't bother to look there for Revision User information;
--                                          instead, we'll check first to see if we can tell if the SPID is attached to a
--                                          RightAngle application (PB or .NET) -- if so, we'll get the Revision User from the
--                                          TaxRuleSet table; otherwise we'll get it from the SYSTEM_USER SQL property
--                                          ** NOTE: if the names of the RightAngle applications change, this check will need to change also **
--  06/18/2012    E.Wallerstein           Increased size of Array table fields in order to avoid truncation errors
--  07/09/2012    E.Wallerstein           After more analysis, we found that deleted records from the LoginInformation table are archived
--                                          in the LoginInformationArchive table; after determining that the SPID is attached to a RightAngle
--                                          application, we should be able to look in the LoginInformation table for the SPID and then
--                                          look in the LoginInformationArchive table for the latest login date associated with the SPID if the
--                                          record wasn't found in the LoginInformation table
--                                          ** NOTE: this will only work for the PowerBuilder side, since the SPID logged for the .NET side is currently
--                                                   just the UserID * 1000
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON 

Declare @i_Idnty                   int
       ,@i_TxRleStID               int
       ,@i_UserID                  int
       ,@vc_User                   varchar(80)
       ,@vc_TaxRule                varchar(80)
       ,@vc_DataObject             varchar(40)
       ,@vc_OldRuleValue           varchar(2000)
       ,@vc_NewRuleValue           varchar(2000)
       ,@vc_OldRuleValueFormatted  varchar(max)
       ,@vc_NewRuleValueFormatted  varchar(max)
       ,@vc_Title                  varchar(80)
       ,@vc_TemplateArguments      varchar(255)
       ,@i_ID                      int
       ,@i_PrevGrouping            int
       ,@i_Grouping                int
       ,@vc_LicenseInfo            varchar(2000)
       ,@vc_ProdUsageInfo          varchar(2000)
       ,@vc_ProductInfo            varchar(2000)


Create Table #Audit
( Idnty          int IDENTITY(1,1)
 ,TxRleStID      int
 ,EntityChanged  varchar(200)
 ,OldValue       varchar(max)
 ,NewValue       varchar(max)
)

Create Table #TRSR
( Idnty           int IDENTITY(1,1)
 ,TxID            int
 ,TxRleStID       int
 ,TxRleID         int
 ,RuleValue       varchar(2000)
 ,RuleExpression  varchar(2000)
)

Create Table #Array
( ID              int IDENTITY(1,1)
 ,ColumnName      varchar(255)
 ,Value           varchar(255)
)

Create Table #ArrayLicense
( ID              int
 ,ColumnName      varchar(255)
 ,Value           varchar(255)
)

Create Table #ArrayProdUsage
( ID              int
 ,ColumnName      varchar(255)
 ,Value           varchar(255)
)

Create Table #ArrayProduct
( ID              int
 ,ColumnName      varchar(255)
 ,Value           varchar(255)
)

Create Table #Licenses
( Idnty           int IDENTITY(1,1)
 ,Grouping        int
 ,BAIdentifier    varchar(25)
 ,Operator        varchar(20)
 ,LicenseID       int
)

Create Table #ProdUsage
( Idnty           int IDENTITY(1,1)
 ,PrdctID         int
 ,UsageID         int
)

Create Table #Products
( Idnty           int IDENTITY(1,1)
 ,PrdctID         int
 ,PrdctAttrbteID  int
)


--
-- Determine the Revision User ID from RightAngle (or from SQL Server if the change is happening outside of RightAngle)
--

-- if the SPID isn't tied to a RightAngle application, get the name of the user currently logged into SQL Server
-- because the update most likely came directly from a SQL Server Management Studio session
-- ** NOTE: if the RightAngle application names change, this check will need to be updated **
if (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) NOT In ('.Net SqlClient Data Provider', 'Right Angle IV')
  Select @vc_User = System_User

-- if the user name is NULL, that measns the update DID come from a RightAngle application, so attempt to get the UserDBMnkr and UserID
-- from the LoginInformation or LoginInformationArchive table (will only work for the PowerBuilder SRA application, since
-- the .NET application does not store an actual SPID in the SPID field -- it stores UserID * 1000)
if @vc_User is NULL and (Select PROGRAM_NAME From sys.sysprocesses Where spid = @@SPID) = 'Right Angle IV'
  Begin
    Select @vc_User = LoginInformation.UserDBMnkr
          ,@i_UserID = LoginInformation.UserID
    From   LoginInformation (nolock)
    Where  LoginInformation.SPID = @@SPID

    -- if the user name is still NULL, try looking for the last record associated with the SPID in the LoginInformationArchive table
    if @vc_User is NULL
      Begin
        Select Top 1 @vc_User = LoginInformationArchive.UserDBMnkr
                    ,@i_UserID = LoginInformationArchive.UserID
        From   LoginInformationArchive (nolock)
        Where  LoginInformationArchive.SPID = @@SPID
        Order By LoginInformationArchive.LoginDate desc
      End
  End

-- if the user name is still NULL, that means the lookup in the LoginInformation (or LoginInformationArchive) table failed,
-- so get the the Revision User off the TaxRuleSet record
if @vc_User is NULL
  Begin
    Select Top 1 @vc_User  = Users.UserDBMnkr
                ,@i_UserID = TaxRuleSet.RevisionUserID
    From   Inserted (nolock)
           join TaxRuleSet (nolock)
                on Inserted.TxRleStID = TaxRuleSet.TxRleStID
           left join Users (nolock)
                on TaxRuleSet.RevisionUserID = Users.UserID
  End


-- Populate the #TRSR temp table with all of the updated records so that we can attach an Idnty column to each record
-- and process them one-by-one; there is no single unique key for the TaxRuleSetRule table

Insert #TRSR
( TxID
 ,TxRleStID
 ,TxRleID
 ,RuleValue
 ,RuleExpression
)
Select Inserted.TxID
      ,Inserted.TxRleStID
      ,Inserted.TxRleID
      ,Inserted.RuleValue
      ,Inserted.RuleExpression
From   Inserted
Order By Inserted.TxRleStID
        ,Inserted.TxRleID

--
-- Insert a record into the MTV_TaxAudit table for each field on each updated record
--

-- Determine the first updated record to process
Select @i_Idnty = Min(Idnty)
From   #TRSR (nolock)

While @i_Idnty IS NOT NULL
  Begin

    -- Get the TaxRule Description, DataObject, and TemplateArguments for use in process flow
    Select @vc_TaxRule = Coalesce(TaxRule.Description, Convert(varchar,#TRSR.TxRleID))
          ,@vc_DataObject = Coalesce(TaxRule.DataObject, Convert(varchar,#TRSR.TxRleID))
          ,@vc_TemplateArguments = TaxRule.TemplateArguments
    From   #TRSR
           left join TaxRule (nolock)
                on #TRSR.TxRleID = TaxRule.TxRleID
    Where  #TRSR.Idnty = @i_Idnty

    -- Get alternate title if specified
    Truncate Table #Array
    exec sp_parsestringintotemptable @vc_TemplateArguments, '||', '='

    Select @vc_Title = (Select Top 1 #Array.Value
                        From   #Array
                        Where  #Array.ColumnName = 'Title'
                       )

    -- Get the old and new RuleValue
    Select @vc_OldRuleValue = IsNull(Deleted.RuleValue,'')
          ,@vc_NewRuleValue = IsNull(#TRSR.RuleValue,'')
    From   #TRSR
           left join Deleted (nolock)
                on #TRSR.TxID = Deleted.TxID
               and #TRSR.TxRleStID = Deleted.TxRleStID
               and #TRSR.TxRleID = Deleted.TxRleID
    Where  #TRSR.Idnty = @i_Idnty


    if @vc_TaxRule = 'Location Rule' or @vc_DataObject = 'n_dao_taxrulesetrule_location'
      Begin
        -- We won't process the 'Location Rule' tax rule (or any other tax rule that is based off the n_dao_taxrulesetrule_location
        -- DataObject) in this trigger because it is handled in the TaxLocation triggers
        select @vc_TaxRule = @vc_TaxRule
      End


    if @vc_DataObject = 'n_dao_taxrulesetrule_sql' or @vc_TaxRule in ('Destination Location does not have a TCN'
                                                                     ,'Destination Location has a TCN'
                                                                     ,'Destination Terminal Operator does have 637'
                                                                     ,'Destination Terminal Operator does not have 637'
                                                                     ,'Exclude Inventory Movement Rule'
                                                                     ,'Exclude Movement Out of Inventory (Not Exchange) Rule'
                                                                     ,'Movement Out of Inventory (Not Exchange) Rule'
                                                                     ,'Non-Common Carrier Rule'
                                                                     ,'Origin Location does not have a TCN'
                                                                     ,'Origin Location has a TCN'
                                                                     ,'Origin Terminal Operator does have 637'
                                                                     ,'Origin Terminal Operator does not have 637'
                                                                     ,'TCN - Non-TCN Inventory Movement Rule'
                                                                     ,'Terminal Operator does have 637'
                                                                     ,'Terminal Operator does not have 637'
                                                                     )
      Begin
        -- Tax rules based on the n_dao_taxrulesetrule_sql dataobject should never hit this Update trigger because
        -- there are no components to update; these rules should only ever be added or deleted.  Nevertheless, we will
        -- put simple code in here to represent old/new values just in case.  We also listed specific TaxRule descriptions
        -- in case the DataObject field isn't used in the future.

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValue
              ,@vc_NewRuleValue
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Transaction Rule'
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(TransactionType.TrnsctnTypDesc, #Array.Value)
        From   #Array
               left join TransactionType (nolock)
                    on Convert(int,#Array.Value) = TransactionType.TrnsctnTypID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(TransactionType.TrnsctnTypDesc, #Array.Value)
        From   #Array
               left join TransactionType (nolock)
                    on Convert(int,#Array.Value) = TransactionType.TrnsctnTypID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('Internal Business Associate Rule'
                      ,'Internal Business Associate Exclusion Rule'
                      ,'External Business Associate Rule'
                      ,'External Business Associate Exclusion Rule'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce((BusinessAssociate.BANme + IsNull(BusinessAssociate.BANmeExtended,'')), #Array.Value)
        From   #Array
               left join BusinessAssociate (nolock)
                    on Convert(int,#Array.Value) = BusinessAssociate.BAID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce((BusinessAssociate.BANme + IsNull(BusinessAssociate.BANmeExtended,'')), #Array.Value)
        From   #Array
               left join BusinessAssociate (nolock)
                    on Convert(int,#Array.Value) = BusinessAssociate.BAID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Movement Rule'
      Begin
        -- Strip out quotes from the old and new RuleValue
        Select @vc_OldRuleValue = REPLACE( @vc_OldRuleValue, '"', '')
              ,@vc_NewRuleValue = REPLACE( @vc_NewRuleValue, '"', '')

        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(MovementHeaderType.Name), #Array.Value)
        From   #Array
               left join MovementHeaderType (nolock)
                    on #Array.Value = MovementHeaderType.MvtHdrTyp
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(MovementHeaderType.Name), #Array.Value)
        From   #Array
               left join MovementHeaderType (nolock)
                    on #Array.Value = MovementHeaderType.MvtHdrTyp
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('Commodity Rule'
                      ,'Tax Commodity Rule'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(CommoditySubGroup.Name), #Array.Value)
        From   #Array
               left join CommoditySubGroup (nolock)
                    on Convert(int,#Array.Value) = CommoditySubGroup.CmmdtySbGrpID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(CommoditySubGroup.Name), #Array.Value)
        From   #Array
               left join CommoditySubGroup (nolock)
                    on Convert(int,#Array.Value) = CommoditySubGroup.CmmdtySbGrpID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Deal Type Rule'
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(DealType.Description), #Array.Value)
        From   #Array
               left join DealType (nolock)
                    on Convert(int,#Array.Value) = DealType.DlTypID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(RTrim(DealType.Description), #Array.Value)
        From   #Array
               left join DealType (nolock)
                    on Convert(int,#Array.Value) = DealType.DlTypID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('Deal Rule'
                      ,'Deal Exclusion Rule'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(DealHeader.DlHdrIntrnlNbr, #Array.Value)
        From   #Array
               left join DealHeader (nolock)
                    on Convert(int,#Array.Value) = DealHeader.DlHdrID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(DealHeader.DlHdrIntrnlNbr, #Array.Value)
        From   #Array
               left join DealHeader (nolock)
                    on Convert(int,#Array.Value) = DealHeader.DlHdrID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Movement Usage Rule'
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(DynamicListBox.DynLstBxDesc, #Array.Value)
        From   #Array
               left join DynamicListBox (nolock)
                    on Convert(int,#Array.Value) = DynamicListBox.DynLstBxID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce(DynamicListBox.DynLstBxDesc, #Array.Value)
        From   #Array
               left join DynamicListBox (nolock)
                    on Convert(int,#Array.Value) = DynamicListBox.DynLstBxID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('Location Exclusion Rule - (Destination)'
                      ,'Location Exclusion Rule - (Origin)'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce((Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension,'')), #Array.Value)
        From   #Array
               left join Locale (nolock)
                    on Convert(int,#Array.Value) = Locale.LcleID
        Order By #Array.ID

        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When #Array.ID = 1 Then '' Else ', ' End + Coalesce((Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension,'')), #Array.Value)
        From   #Array
               left join Locale (nolock)
                    on Convert(int,#Array.Value) = Locale.LcleID
        Order By #Array.ID

        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Supply/Demand Rule'
      Begin
        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,Case @vc_OldRuleValue When 'R' Then 'Receipt' When 'D' Then 'Delivery' Else @vc_OldRuleValue End
              ,Case @vc_NewRuleValue When 'R' Then 'Receipt' When 'D' Then 'Delivery' Else @vc_NewRuleValue End
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'We Pay/They Pay Rule'
      Begin
        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,Case @vc_OldRuleValue When 'R' Then 'We Pay' When 'D' Then 'They Pay' Else @vc_OldRuleValue End
              ,Case @vc_NewRuleValue When 'R' Then 'We Pay' When 'D' Then 'They Pay' Else @vc_NewRuleValue End
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('External BA License Rule'
                      ,'Internal BA License Rule'
                      ,'All BA License Rule'
                      ,'License Rule'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayLicense
        Truncate Table #Licenses
        
        Insert #ArrayLicense
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayLicense.ID)
        From   #ArrayLicense
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_LicenseInfo = #ArrayLicense.Value
            From   #ArrayLicense
            Where  #ArrayLicense.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_LicenseInfo, ',', '~~' -- use '~~' to basically force ignoring of column determination

            Insert #Licenses
            ( Grouping
             ,BAIdentifier
             ,Operator
             ,LicenseID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ID = 1
                   ) -- Grouping
                  ,Case @vc_TaxRule
                     When 'External BA License Rule' Then 'External BA'
                     When 'Internal BA License Rule' Then 'Internal BA'
                     When 'License Rule' Then 'Business Associate'
                     Else (Select #Array.Value
                           From   #Array
                           Where  #Array.ID = 2
                          )
                   End -- BAIdentifier
                  ,(Select #Array.Value
                    From   #Array
                    Where  #Array.ID = Case @vc_TaxRule
                                         When 'External BA License Rule' Then 2
                                         When 'Internal BA License Rule' Then 2
                                         When 'License Rule' Then 2
                                         Else 3
                                       End
                   ) -- Operator
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ID = Case @vc_TaxRule
                                         When 'External BA License Rule' Then 3
                                         When 'Internal BA License Rule' Then 3
                                         When 'License Rule' Then 3
                                         Else 4
                                       End
                   ) -- LicenseID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayLicense.ID)
            From   #ArrayLicense
            Where  #ArrayLicense.ID > @i_ID
          End


        Select @vc_OldRuleValueFormatted = ''
        Select @i_PrevGrouping = 0

        -- Get the first license to process
        Select @i_ID = Min(#Licenses.Idnty)
        From   #Licenses

        While @i_ID is NOT NULL
          Begin
            Select @vc_OldRuleValueFormatted += Case When @i_PrevGrouping <> #Licenses.Grouping
                                                       Then Case When @i_PrevGrouping = 0
                                                                   Then '('
                                                                 Else ') [OR] ('
                                                            End
                                                     Else ' [AND] '
                                                End +
                                                Case #Licenses.BAIdentifier
                                                  When 'InternalLicense' Then 'Internal BA'
                                                  When 'ExternalLicense' Then 'External BA'
                                                  When 'CarrierLicenses' Then 'Carrier BA'
                                                  Else IsNull(#Licenses.BAIdentifier,'')
                                                End +
                                                Case #Licenses.Operator
                                                  When 'like' Then ' Has '
                                                  When 'not like' Then ' Doesn''t Have '
                                                  Else ' ' + IsNull(#Licenses.Operator,'') + ' '
                                                End +
                                                Coalesce(License.Description, Convert(varchar,#Licenses.LicenseID), '<Unknown>')
            From   #Licenses
                   left join License (nolock)
                        on #Licenses.LicenseID = License.LcnseID
            Where  #Licenses.Idnty = @i_ID

            Select @i_PrevGrouping = #Licenses.Grouping
            From   #Licenses
            Where  #Licenses.Idnty = @i_ID
            
            -- Get the next license to process
            Select @i_ID = Min(#Licenses.Idnty)
            From   #Licenses
            Where  #Licenses.Idnty > @i_ID
          End

        if @vc_OldRuleValueFormatted <> ''
          Select @vc_OldRuleValueFormatted += ')'


        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, '||', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayLicense
        Truncate Table #Licenses
        
        Insert #ArrayLicense
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayLicense.ID)
        From   #ArrayLicense
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_LicenseInfo = #ArrayLicense.Value
            From   #ArrayLicense
            Where  #ArrayLicense.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_LicenseInfo, ',', '~~' -- use '~~' to basically force ignoring of column determination

            Insert #Licenses
            ( Grouping
             ,BAIdentifier
             ,Operator
             ,LicenseID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ID = 1
                   ) -- Grouping
                  ,Case @vc_TaxRule
                     When 'External BA License Rule' Then 'External BA'
                     When 'Internal BA License Rule' Then 'Internal BA'
                     When 'License Rule' Then 'Business Associate'
                     Else (Select #Array.Value
                           From   #Array
                           Where  #Array.ID = 2
                          )
                   End -- BAIdentifier
                  ,(Select #Array.Value
                    From   #Array
                    Where  #Array.ID = Case @vc_TaxRule
                                         When 'External BA License Rule' Then 2
                                         When 'Internal BA License Rule' Then 2
                                         When 'License Rule' Then 2
                                         Else 3
                                       End
                   ) -- Operator
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ID = Case @vc_TaxRule
                                         When 'External BA License Rule' Then 3
                                         When 'Internal BA License Rule' Then 3
                                         When 'License Rule' Then 3
                                         Else 4
                                       End
                   ) -- LicenseID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayLicense.ID)
            From   #ArrayLicense
            Where  #ArrayLicense.ID > @i_ID
          End


        Select @vc_NewRuleValueFormatted = ''
        Select @i_PrevGrouping = 0

        -- Get the first license to process
        Select @i_ID = Min(#Licenses.Idnty)
        From   #Licenses

        While @i_ID is NOT NULL
          Begin
            Select @vc_NewRuleValueFormatted += Case When @i_PrevGrouping <> #Licenses.Grouping
                                                       Then Case When @i_PrevGrouping = 0
                                                                   Then '('
                                                                 Else ') [OR] ('
                                                            End
                                                     Else ' [AND] '
                                                End +
                                                Case #Licenses.BAIdentifier
                                                  When 'InternalLicense' Then 'Internal BA'
                                                  When 'ExternalLicense' Then 'External BA'
                                                  When 'CarrierLicenses' Then 'Carrier BA'
                                                  Else IsNull(#Licenses.BAIdentifier,'')
                                                End +
                                                Case #Licenses.Operator
                                                  When 'like' Then ' Has '
                                                  When 'not like' Then ' Doesn''t Have '
                                                  Else ' ' + IsNull(#Licenses.Operator,'') + ' '
                                                End +
                                                Coalesce(License.Description, Convert(varchar,#Licenses.LicenseID), '<Unknown>')
            From   #Licenses
                   left join License (nolock)
                        on #Licenses.LicenseID = License.LcnseID
            Where  #Licenses.Idnty = @i_ID

            Select @i_PrevGrouping = #Licenses.Grouping
            From   #Licenses
            Where  #Licenses.Idnty = @i_ID
            
            -- Get the next license to process
            Select @i_ID = Min(#Licenses.Idnty)
            From   #Licenses
            Where  #Licenses.Idnty > @i_ID
          End

        if @vc_NewRuleValueFormatted <> ''
          Select @vc_NewRuleValueFormatted += ')'


        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule = 'Product Usage Exclusion Rule'
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, ',', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayProdUsage
        Truncate Table #ProdUsage
        
        Insert #ArrayProdUsage
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayProdUsage.ID)
        From   #ArrayProdUsage
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_ProdUsageInfo = #ArrayProdUsage.Value
            From   #ArrayProdUsage
            Where  #ArrayProdUsage.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_ProdUsageInfo, '||', '='

            Insert #ProdUsage
            ( PrdctID
             ,UsageID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctID'
                   ) -- PrdctID
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else NULL End
                    From   #Array
                    Where  #Array.ColumnName = 'Usage'
                   ) -- UsageID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayProdUsage.ID)
            From   #ArrayProdUsage
            Where  #ArrayProdUsage.ID > @i_ID
          End


        Select @vc_OldRuleValueFormatted = ''

        -- Get the first Product Usage record to process
        Select @i_ID = Min(#ProdUsage.Idnty)
        From   #ProdUsage

        While @i_ID is NOT NULL
          Begin
            Select @vc_OldRuleValueFormatted += Case When @vc_OldRuleValueFormatted <> '' Then ' or (' Else '(' End +
                                                Coalesce(Product.PrdctNme, Convert(varchar,#ProdUsage.PrdctID), '<Unknown>') +
                                                ' and Usage is ' +
                                                Case When #ProdUsage.UsageID is NULL Then '[All]'
                                                     Else Coalesce(DynamicListBox.DynLstBxDesc, Convert(varchar,#ProdUsage.UsageID), '<Unknown>')
                                                End + ')'
            From   #ProdUsage
                   left join Product (nolock)
                        on #ProdUsage.PrdctID = Product.PrdctID
                   left join DynamicListBox (nolock)
                        on #ProdUsage.UsageID = DynamicListBox.DynLstBxID
            Where  #ProdUsage.Idnty = @i_ID

            -- Get the next Product Usage record to process
            Select @i_ID = Min(#ProdUsage.Idnty)
            From   #ProdUsage
            Where  #ProdUsage.Idnty > @i_ID
          End


        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, ',', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayProdUsage
        Truncate Table #ProdUsage
        
        Insert #ArrayProdUsage
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayProdUsage.ID)
        From   #ArrayProdUsage
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_ProdUsageInfo = #ArrayProdUsage.Value
            From   #ArrayProdUsage
            Where  #ArrayProdUsage.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_ProdUsageInfo, '||', '='

            Insert #ProdUsage
            ( PrdctID
             ,UsageID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctID'
                   ) -- PrdctID
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else NULL End
                    From   #Array
                    Where  #Array.ColumnName = 'Usage'
                   ) -- UsageID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayProdUsage.ID)
            From   #ArrayProdUsage
            Where  #ArrayProdUsage.ID > @i_ID
          End


        Select @vc_NewRuleValueFormatted = ''

        -- Get the first Product Usage record to process
        Select @i_ID = Min(#ProdUsage.Idnty)
        From   #ProdUsage

        While @i_ID is NOT NULL
          Begin
            Select @vc_NewRuleValueFormatted += Case When @vc_NewRuleValueFormatted <> '' Then ' or (' Else '(' End +
                                                Coalesce(Product.PrdctNme, Convert(varchar,#ProdUsage.PrdctID), '<Unknown>') +
                                                ' and Usage is ' +
                                                Case When #ProdUsage.UsageID is NULL Then '[All]'
                                                     Else Coalesce(DynamicListBox.DynLstBxDesc, Convert(varchar,#ProdUsage.UsageID), '<Unknown>')
                                                End + ')'
            From   #ProdUsage
                   left join Product (nolock)
                        on #ProdUsage.PrdctID = Product.PrdctID
                   left join DynamicListBox (nolock)
                        on #ProdUsage.UsageID = DynamicListBox.DynLstBxID
            Where  #ProdUsage.Idnty = @i_ID

            -- Get the next Product Usage record to process
            Select @i_ID = Min(#ProdUsage.Idnty)
            From   #ProdUsage
            Where  #ProdUsage.Idnty > @i_ID
          End


        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


    if @vc_TaxRule in ('Product Rule'
                      ,'Product Exclusion Rule'
                      )
      Begin
        -- Format the old RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_OldRuleValue, ',', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayProduct
        Truncate Table #Products
        
        Insert #ArrayProduct
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayProduct.ID)
        From   #ArrayProduct
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_ProductInfo = #ArrayProduct.Value
            From   #ArrayProduct
            Where  #ArrayProduct.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_ProductInfo, '||', '='

            Insert #Products
            ( PrdctID
             ,PrdctAttrbteID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctID'
                   ) -- PrdctID
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else NULL End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctAttrbteID'
                   ) -- PrdctAttrbteID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayProduct.ID)
            From   #ArrayProduct
            Where  #ArrayProduct.ID > @i_ID
          End


        Select @vc_OldRuleValueFormatted = ''

        Select @vc_OldRuleValueFormatted += Case When @vc_OldRuleValueFormatted <> '' Then ', ' Else '' End +
                                            Coalesce(Product.PrdctNme, Convert(varchar,#Products.PrdctID), '<Unknown>') +
                                            Case When #Products.PrdctAttrbteID is NULL Then ''
                                                 Else ' [' + Coalesce(TaxProductAttribute.TxPrdctAttrbteDscrptn, Convert(varchar,#Products.PrdctAttrbteID)) + ']'
                                            End
        From   #Products
               left join Product (nolock)
                    on #Products.PrdctID = Product.PrdctID
               left join TaxProductAttribute (nolock)
                    on #Products.PrdctAttrbteID = TaxProductAttribute.TxPrdctAttrbteID


        -- Format the new RuleValue
        Truncate Table #Array
        exec sp_parsestringintotemptable @vc_NewRuleValue, ',', '~~' -- use '~~' to basically force ignoring of column determination

        Truncate Table #ArrayProduct
        Truncate Table #Products
        
        Insert #ArrayProduct
        Select *
        From   #Array
        Order By #Array.ID

        -- Get first array record to process
        Select @i_ID = Min(#ArrayProduct.ID)
        From   #ArrayProduct
        
        While @i_ID is NOT NULL
          Begin
            Select @vc_ProductInfo = #ArrayProduct.Value
            From   #ArrayProduct
            Where  #ArrayProduct.ID = @i_ID

            Truncate Table #Array
            exec sp_parsestringintotemptable @vc_ProductInfo, '||', '='

            Insert #Products
            ( PrdctID
             ,PrdctAttrbteID
            )
            Select (Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else -1 End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctID'
                   ) -- PrdctID
                  ,(Select Case When IsNumeric(#Array.Value) = 1 Then Convert(int,#Array.Value) Else NULL End
                    From   #Array
                    Where  #Array.ColumnName = 'PrdctAttrbteID'
                   ) -- PrdctAttrbteID

            -- Get next array record to process
            Select @i_ID = Min(#ArrayProduct.ID)
            From   #ArrayProduct
            Where  #ArrayProduct.ID > @i_ID
          End


        Select @vc_NewRuleValueFormatted = ''

        Select @vc_NewRuleValueFormatted += Case When @vc_NewRuleValueFormatted <> '' Then ', ' Else '' End +
                                            Coalesce(Product.PrdctNme, Convert(varchar,#Products.PrdctID), '<Unknown>') +
                                            Case When #Products.PrdctAttrbteID is NULL Then ''
                                                 Else ' [' + Coalesce(TaxProductAttribute.TxPrdctAttrbteDscrptn, Convert(varchar,#Products.PrdctAttrbteID)) + ']'
                                            End
        From   #Products
               left join Product (nolock)
                    on #Products.PrdctID = Product.PrdctID
               left join TaxProductAttribute (nolock)
                    on #Products.PrdctAttrbteID = TaxProductAttribute.TxPrdctAttrbteID


        Insert #Audit
        ( TxRleStID
         ,EntityChanged
         ,OldValue
         ,NewValue
        )
        Select #TRSR.TxRleStID
              ,Coalesce(@vc_Title, @vc_TaxRule)
              ,@vc_OldRuleValueFormatted
              ,@vc_NewRuleValueFormatted
        From   #TRSR
        Where  #TRSR.Idnty = @i_Idnty
      End


NextRecord:

    -- Process the next updated record
    Select @i_Idnty = Min(Idnty)
    From   #TRSR (nolock)
    Where  Idnty > @i_Idnty

  End

Insert MTV_TaxAudit
(DateModified
,UserID
,UserDBMnkr
,TxRleStID
,TabChanged
,EntityChanged
,OldValue
,NewValue
)
Select Current_TimeStamp
      ,@i_UserID
      ,@vc_User
      ,#Audit.TxRleStID
      ,'Rules'
      ,#Audit.EntityChanged
      ,#Audit.OldValue
      ,#Audit.NewValue
From   #Audit (nolock)
Order By #Audit.Idnty

Drop Table #Audit
Drop Table #TRSR
Drop Table #Array
Drop Table #ArrayLicense
Drop Table #ArrayProdUsage
Drop Table #ArrayProduct
Drop Table #Licenses
Drop Table #ProdUsage
Drop Table #Products

return

end

GO


IF OBJECT_ID('dbo.tu_TaxRuleSetRule_MTV') IS NOT NULL
  PRINT '<<< CREATED TRIGGER dbo.tu_TaxRuleSetRule_MTV >>>'
ELSE
  PRINT '<<< FAILED CREATING TRIGGER dbo.tu_TaxRuleSetRule_MTV >>>'

go
