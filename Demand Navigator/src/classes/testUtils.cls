public with sharing class testUtils { 
    public static final String USER_PROFILE_NAME = 'System Administrator';
    
   
    public static User createUser(){ 
        if (Schema.sObjectType.Profile.fields.Id.isAccessible()){
         
        Profile p = [SELECT Id FROM Profile WHERE Name=: USER_PROFILE_NAME ]; 


        
        UserRole Pr = new UserRole(Name = 'Backlog Adjustment');
        if(UserRole.SObjectType.getDescribe().isCreateable()){ 
        
        insert Pr;
        
        UserRole r = new UserRole(Name = 'Backlog',ParentRoleId = Pr.Id);
        if(UserRole.SObjectType.getDescribe().isCreateable()){
        insert r;
        
        User u = new User(Alias = 'standt', Email='test18th_1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='test18th_1@testorg.com');
        if(User.SObjectType.getDescribe().isCreateable()){
            insert u;
        }
        return u;
        }
    }
        }
        return null;  
    }
    

    public static void ReportTestDate(){
        
        map<string,Id> mapMeasure = new map<string,Id>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() &&  Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
          
        for(Planning_Financial_Measure__c fm : [select Id,Name from Planning_Financial_Measure__c WHERE Id != NULL]){
            mapMeasure.put(fm.Name,fm.Id);
        }

        } 
        
        map<Integer,String> mapMonthString  = new map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        
        Date fstartDate = Date.newInstance(2001,1,1);
        Date fendDate = Date.newInstance(2001,12,31);
        Fiscal_Year_Planning__c fyp;
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()) {
        fyp = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
            insert fyp;
        }
        Date startDate = fstartDate;
        Date endDate = startDate.addDays(30);
    
        List<Fiscal_Year_Model__c> lstFiscalYear = new List<Fiscal_Year_Model__c>();
        
        List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
        Integer q = 0;
        for(Integer i = 1;i<13;i++){
        
        if(i > 4)q= 1;
        else if(i > 7)q= 2;
        else if(i > 10)q= 3;
        else q = 4;
        if (Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
        && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()) {
                lstVersion.add(
                    new Planning_Version__c(
                        Fiscal_Year_Planning__c = fyp.Id,
                        Is_this_a_Budget_Planning_Version__c = true,
                        SequenceNo__c = i,
                        Data_Entry_Closed_Date__c= endDate ,
                        Data_Entry_Start_Date__c  = startDate ,
                        Version_Status__c= 'Closed',
                        Planning_Version_Fiscal_Year__c = '2001',
                        Planning_Version_Current_Period__c= i+'',
                        MonthName__c = mapMonthString.get(i)
                    ));



                    
        }
                 if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isCreateable()
                 && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isCreateable()) {
                    lstFiscalYear.add(
                      new Fiscal_Year_Model__c(
                        Name = 'FY2001P'+i,
                        End_Date__c = endDate,
                        Fiscal_Quarter__c = 'Q'+q,
                        Fiscal_Year__c = '2001',
                        Period_Name__c = mapMonthString.get(i),
                        Period_Number__c = i,
                        Start_Date__c = startDate




                    ));
                    
                 }
        startDate  = endDate.addDays(1);
                endDate = startDate.addDays(30);
    
        } 
        
        if(Planning_Version__c.SObjectType.getDescribe().isCreateable()) {
                        insert lstVersion;
                    }
        if(Fiscal_Year_Model__c.SObjectType.getDescribe().isCreateable()) {
                        insert lstFiscalYear;
                    }
    
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isCreateable() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isCreateable()) {
        Additional_Planning_Versions__c addversion1 = new Additional_Planning_Versions__c(Name = 'Budget01', Version_Description__c = 'test');
        
        if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()) {
            insert addversion1;
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isUpdateable()) {
        addversion1.Version_Description__c = 'check update case';
        if(Additional_Planning_Versions__c.SObjectType.getDescribe().isUpdateable()) {
            update addversion1;
        }
        }
        }
        }
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isCreateable()
        && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isCreateable()) {
        Additional_Planning_Versions__c addversion2 = new Additional_Planning_Versions__c(Name = 'Budget02', Version_Description__c = 'test');
            insert addversion2;
        }
        if (Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isCreateable()
        && Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isCreateable()) {
        Gap_Planning_Version__c gap1 = new Gap_Planning_Version__c(Name = 'Q1 Gap', Version_Description__c = 'test');
            insert gap1;
        }
        
        
        Account  Acc;
        if (Schema.sObjectType.Account.fields.Name.isCreateable()) {
        Acc = new Account(Name = 'test account');
        insert Acc;
        }
        Date cd = date.newInstance(2001,6,1);
        //Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        //Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Budget').getRecordTypeId();
        Opportunity Opp;
        if (Schema.sObjectType.Opportunity.fields.name.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.accountId.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.StageName.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.CloseDate.isCreateable()) {
        Opp = new Opportunity(
        //RecordTypeId=devRecordTypeId,
        name='Test Opp', 
        Deal_TCV__c = 100,
        accountId = Acc.Id,
        Deal_Duration__c  =12,
        StageName='Open',
        Project_Start_Date__c = date.today(),
        CloseDate=cd,
        Amount=1000000,
        Budget_Planning_Version__c=lstVersion[0].Id
        );
        insert Opp;
        }
        
        List<Planning_Model__c> listpm = new List<Planning_Model__c>();
        
        for(Id mId : mapMeasure.values()){
            Planning_Model__c pm = new Planning_Model__c();
            if (Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable()) {
            pm.Amount__c = 100;
            }
            if (Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable()) {
            pm.Comments__c = 'test';
            }
            if (Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable()) {
            pm.Opportunity__c = Opp.Id;
            }
            if (Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable()) {
            pm.Fiscal_Period__c = lstFiscalYear[lstFiscalYear.size()-1].Id;
            }
            if (Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable()) {
            pm.Planning_Measure__c = mId;
            }
            if (Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable()) {
            pm.Planning_Version__c = lstVersion[lstVersion.size()-1].Id;
            }
            listpm.add(pm);
        }      
        
        if(Planning_Model__c.SObjectType.getDescribe().isCreateable()) {
        insert listpm ;
        }
        //System.assertEquals(pm.Name,'Test');

    }
    
    public static Configuration_Setting__c createConfigurationSettingObj(){
        Configuration_Setting__c con = new Configuration_Setting__c();
        if (Schema.sObjectType.Configuration_Setting__c.fields.Name.isCreateable()
        && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isCreateable()) {
        con.Name = '2016';
        con.Stage__c = 'Open,Prospecting,ClosedWon,ClosedLost';
        if(Configuration_Setting__c.SObjectType.getDescribe().isCreateable()) {
        insert con;
        }
        }
        return con;
        
    }
    

    public static void createMeasures(){
        map<String,String> mapFMDesc = new map<String,String>();
        mapFMDesc.put('Revenue','Revenue recognized');
        mapFMDesc.put('Revenue Adjustment','Adjustment to Revenue recognized');
        mapFMDesc.put('Revenue Backlog','Revenue Backlog calculated');
        mapFMDesc.put('Sales Booking','Sales Booking recognized');
        mapFMDesc.put('Gap Mitgation','Gap Mitgation Booking recognized');

        map<String,String> mapFMType = new map<String,String>();
        mapFMType.put('Revenue','Income');
        mapFMType.put('Revenue Adjustment','Income');
        mapFMType.put('Revenue Backlog','KPI');
        mapFMType.put('Sales Booking','KPI');
        mapFMType.put('Gap Mitgation','KPI');
                
        List<Planning_Financial_Measure__c> lstFinancialMeasure = new List<Planning_Financial_Measure__c>();
        for(String FM : mapFMDesc.keySet()){
            Boolean AutoCalculated = false;
        if(FM == 'Revenue Backlog') 
                AutoCalculated = true;
                if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isCreateable()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isCreateable()) {
        
            Planning_Financial_Measure__c FMObj = new Planning_Financial_Measure__c( 
            Name = FM,
            Automatically_Calculated__c= AutoCalculated , 
            Measure_Description__c = mapFMDesc.get(FM),
            Measure_Type__c = mapFMType.get(FM),
            Record_Source__c = 'Installation',
            Unit_of_Measure__c = 'Currency',
            Restricted_by_Revenue_Term__c = !AutoCalculated );
            lstFinancialMeasure.add(FMObj);
        }
        

         
    }
      if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
        insert lstFinancialMeasure;
      }
    }


    
    public static void createOpportunities() {
    
        map<string,Id> mapMeasure = new map<string,Id>(); 
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
          
        for(Planning_Financial_Measure__c fm : [select Id,Name from Planning_Financial_Measure__c WHERE Id != NULL]){
            mapMeasure.put(fm.Name,fm.Id);
        }
        }
        //Date startDate = Date.newInstance(2016,01,01);
        Date startDate = date.newInstance(system.today().year(),1,1);
        Date endDate = (startDate.addMonths(1)).addDays(-1);
        map<Integer,String> mapMonthString  = new map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
    
        Date fstartDate = date.newInstance(startDate.year(),1,1);
        Date fendDate = (startDate.addMonths(12)).addDays(-1);
        Fiscal_Year_Planning__c fyp;
        Fiscal_Year_Planning__c fyp2;
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()) {
        fyp = new Fiscal_Year_Planning__c(Name = string.valueOf(fstartDate.year()),StartDate__c = fstartDate,EndDate__c = fendDate);
        fyp2 = new Fiscal_Year_Planning__c(Name = string.valueOf(fstartDate.year()+1),StartDate__c = fstartDate.addYears(1),EndDate__c = fendDate.addYears(1));
        
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()) {
            insert fyp;
            insert fyp2;
        }
        }
        
        List<Fiscal_Year_Model__c> lstFiscalYear = new List<Fiscal_Year_Model__c>();
        
        List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
    Integer q = 0;
        
        
        List<Fiscal_Year_Planning__c> lstInsertedYear = new List<Fiscal_Year_Planning__c>();
        if(Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable() &&
         Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()) {
            lstInsertedYear  = [select Name,StartDate__c from  Fiscal_Year_Planning__c where Id != NULL];
        }
        for(Fiscal_Year_Planning__c nf : lstInsertedYear ){
            startDate = nf.StartDate__c;
            endDate = startDate.addMonths(1).addDays(-1);
            for(Integer i = 1;i<13;i++){
            
            if(i > 4)q= 1;
            else if(i > 7)q= 2;
            else if(i > 10)q= 3;
            else q = 4;
            if (Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()) {
                    lstVersion.add(
                        new Planning_Version__c(
                            //Fiscal_Year_Planning__c = fyp.Id,
                            Is_this_a_Budget_Planning_Version__c = false,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = string.valueOf(startDate.year()),
                            Planning_Version_Current_Period__c= i+'',
                            Fiscal_Year_Planning__c = fyp.Id,
                            MonthName__c = mapMonthString.get(i)
                        ));
            }
            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isCreateable()) {    
            lstFiscalYear.add(
              new Fiscal_Year_Model__c(
                Name = 'FY'+string.valueOf(startDate.year())+'P'+i,
                End_Date__c = endDate,
                Fiscal_Quarter__c = 'Q'+q,
                Fiscal_Year__c = string.valueOf(startDate.year()),
                Period_Name__c = mapMonthString.get(i),
                Period_Number__c = i,
                Start_Date__c = startDate
            ));
            }
            startDate  = endDate.addDays(1);
                    endDate = (startDate.addmonths(1)).addDays(-1);
        
            } 
        }
        
        
        
        if(Planning_Version__c.SObjectType.getDescribe().isCreateable()) {
        insert lstVersion;
        }
        if(Fiscal_Year_Model__c.SObjectType.getDescribe().isCreateable()) {
        insert lstFiscalYear;
        }
        
        
        
        Additional_Planning_Versions__c addversion5;
         if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isCreateable()
        && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isCreateable()) {
        addversion5 = new Additional_Planning_Versions__c(Name = 'Budget05', Version_Description__c = 'test');
        if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()) {
        insert addversion5;
        }
        }
        
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isUpdateable()) {
        addversion5.Version_Description__c = 'check update case';
        if(Additional_Planning_Versions__c.SObjectType.getDescribe().isUpdateable()) {
        update addversion5;
        }
    }
        Gap_Planning_Version__c gap4;
        if (Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isCreateable()
        && Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isCreateable()) {
        gap4 = new Gap_Planning_Version__c(Name = 'Q4 Gap', Version_Description__c = 'test');
        if(Gap_Planning_Version__c.SObjectType.getDescribe().isCreateable()) {
        insert gap4;
        }
        }
        
        if (Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isUpdateable()) {
        gap4.Version_Description__c = 'check update case';
        if(Gap_Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
        update gap4;
        }
        }    

        if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible()){
        string cyear = string.valueOf(system.today().year());
        Planning_Version__c  budgetversion = [select Id from Planning_Version__c where  Is_this_a_Budget_Planning_Version__c = true and Planning_Version_Fiscal_Year__c  =: cyear and Additional_Planning_Version__c =: addversion5.ID limit 1];
        
        Planning_Version__c  gapversion = [select Id from Planning_Version__c where  Is_this_a_Gap_Planning_Version__c = true limit 1];
        
        if (Schema.sObjectType.Planning_Version__c.fields.version_status__c.isUpdateable()) {
        budgetversion.version_status__c = 'Closed';
        gapversion.version_status__c = 'Closed';
        }
        if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
        update budgetversion;
        }
        if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
        update gapversion;
        }

        if (Schema.sObjectType.RecordType.fields.Id.isAccessible()){
         
        List<recordType> lstRecordType = [select Id from RecordType Where sObjectType = 'Opportunity'  And Name!='Regular'];
        
        Account  Acc;
        if (Schema.sObjectType.Account.fields.Name.isCreateable()) {
         Acc = new Account(Name = 'test account');
        if(Account.SObjectType.getDescribe().isCreateable()) {
        insert Acc;
        }
        }
        Date cd = system.today().addMonths(5);
        List<Opportunity> lstOpp = new List<Opportunity>();
        if (Schema.sObjectType.Opportunity.fields.name.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.accountId.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.RecordTypeId.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Amount.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Budget_Planning_Version__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Gap_Planning_Version__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.StageName.isCreateable()
        && Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isCreateable()
        && Schema.sObjectType.Opportunity.fields.CloseDate.isCreateable()) {
            Integer i=10;
        for(RecordType r : lstRecordType ){
            
            Opportunity Opp = new Opportunity(
            name='Test Opp', 
            Deal_TCV__c = 100,
            accountId = Acc.Id,
            Deal_Duration__c  =8,
            RecordTypeId = r.Id,
            Amount = 100,
            Budget_Planning_Version__c = budgetversion.Id,
            Gap_Planning_Version__c = gapversion.Id,
            StageName='Open',
            Project_Start_Date__c = cd.addDays(1),
            CloseDate=cd
            );
            i++;
            lstOpp.add(opp);
        }
        
            insert lstOpp ;
        
        }
        }
    }
    }
    
     public static Configuration_Setting__c createConfigurationSettingObj(string cyear){
        Configuration_Setting__c con = new Configuration_Setting__c();
        if (Schema.sObjectType.Configuration_Setting__c.fields.Name.isCreateable()) {
        con.Name = cyear;
        }
        if (Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isCreateable()) {
        con.Stage__c = 'Open,Prospecting,ClosedWon,ClosedLost';
        }
        if(Configuration_Setting__c.SObjectType.getDescribe().isCreateable()) {
        insert con;
        }
        return con;
        
    }

}