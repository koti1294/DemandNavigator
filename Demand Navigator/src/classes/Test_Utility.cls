public with sharing class Test_Utility {
    public static final String USER_PROFILE_NAME = 'System Administrator';   
    public static User createUser(){
    	Profile p;
    	if (Schema.sObjectType.Profile.fields.Id.isAccessible()){
         p = [SELECT Id FROM Profile WHERE Name=: USER_PROFILE_NAME ]; 
    	}
        UserRole Pr = new UserRole(Name = 'Backlog Adjustment');
        if(UserRole.SObjectType.getDescribe().isCreateable()){
       	 insert Pr;
        }
        User pu = new User(Alias = 'standt11', Email='test138th_1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testinssg', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = pr.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='test1s8th_1@testorg.com');  
        if(User.SObjectType.getDescribe().isCreateable()){
        insert pu;
        }
        
        
        UserRole r = new UserRole(Name = 'Backlog',ParentRoleId = Pr.Id);
        if(UserRole.SObjectType.getDescribe().isCreateable()){  
        insert r;
        }
        User u = new User(Alias = 'standt', Email='test18th_1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='test18th_1@testorg.com');
        if(User.SObjectType.getDescribe().isCreateable()){  
        insert u;
        }
        
        return pu;  
    }
    public static List<Fiscal_Year_Planning__c> createFiscalYear(List<string> lstYears){
        List<Fiscal_Year_Planning__c> lstFY = new List<Fiscal_Year_Planning__c>();
        for(string syear : lstYears){
            Date fstartDate = Date.newInstance(Integer.valueOf(syear),1,1);
            Date fendDate = Date.newInstance(Integer.valueOf(syear),12,31);
            lstFY.add(new Fiscal_Year_Planning__c(Name = syear,StartDate__c = fstartDate,EndDate__c = fendDate));
        }
        return lstFY;
    }
    public static Account createAccount(){
        Account Acc = new Account(Name = 'Test Account');
        return Acc;
    }
    public static Configuration_Setting__c createConfigurationSettingObj(string cyear){
        Configuration_Setting__c con = new Configuration_Setting__c();
        con.Name = cyear;
        con.Stage__c = 'Open,Prospecting,ClosedWon,ClosedLost,Solutioning';
        return con;
        
    }
    public static Planning_Financial_Measure__c createMeasure(string mName){
        Planning_Financial_Measure__c FMObj = new Planning_Financial_Measure__c( 
        Name = mName,
        Automatically_Calculated__c= true , 
        Measure_Description__c = 'test',
        Measure_Type__c = 'Income',
        Record_Source__c = 'Installation',
        Unit_of_Measure__c = 'Currency',
        Restricted_by_Revenue_Term__c =false);
        return FMObj;
    }
    public static opportunity createOpportunity(string oppName, string AccId, string RT){
        
        Date FirstDate = Date.newInstance(2001,1,1);
        Date LastDate = Date.newInstance(2001,12,31);
        Date startpDate = System.today();
        Date endpDate = startpDate.addDays(30);
        
        Fiscal_Year_Planning__c fyp1 = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = FirstDate,EndDate__c = LastDate);
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            
        insert fyp1;
         }
         List<Planning_Version__c>  listVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    listVersion.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = fyp1.Id,
                            Is_this_a_Budget_Planning_Version__c = true,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endpDate ,
                            Data_Entry_Start_Date__c  = startpDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = ((2000+i)+''),
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = '5'
                        ));
                        startpDate  = endpDate.addDays(1);
                        endpDate = startpDate.addDays(30);
            } 
           if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            
            insert listVersion;
           }
        //Id RTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(RT).getRecordTypeId();
        Opportunity Opp = new Opportunity(
            name = oppName,
            Deal_TCV__c = 100,
            accountId = AccId,
            Deal_Duration__c = 12,
            //RecordTypeId = RTId,
            Amount = 100,
            StageName='Open',
            Project_Start_Date__c = date.today(),
            CloseDate=date.today(),
            Budget_Planning_Version__c=listVersion[0].Id
        );
        return opp;
    }
    public static List<Fiscal_Year_Model__c> createFiscalYearPeriods(List<Fiscal_Year_Planning__c> lstFY)
    {
        List<Fiscal_Year_Model__c> lstFYP = new List<Fiscal_Year_Model__c>();       
        Integer q = 0;
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
        for(Fiscal_Year_Planning__c f : lstFY){
            Date startDate = f.StartDate__c;
            Date endDate = (startDate.addMonths(1)).adddays(-1);
            for(Integer i = 1;i<=12;i++){            
                if(i > 4)q= 1;
                else if(i > 7)q= 2;
                else if(i > 10)q= 3;
                else q = 4;
                lstFYP.add(
                    new Fiscal_Year_Model__c(
                    Name = 'FY'+f.Name+'P'+i,
                    End_Date__c = endDate,
                    Fiscal_Quarter__c = 'Q'+q,
                    Fiscal_Year__c = f.Name,
                    Period_Name__c = mapMonthString.get(i),
                    Period_Number__c = i,
                    Start_Date__c = startDate
                ));
                startDate  = startDate.addMonths(1);
                endDate = endDate.addMonths(1);
            }
        }
        return lstFYP;
    }
    public static Demand_Configuration_Ratio__c createDemandConfiguration(){
        Demand_Configuration_Ratio__c demand = new Demand_Configuration_Ratio__c();
        demand.Business_Unit__c = 'Americas';
        demand.Division__c = 'Manufacturing';
        demand.Offshore_Deal_Month__c = 10;
        demand.Offshore_Resource__c = 50;
        demand.Onsite_Deal_Month__c = 10;   
        demand.Onsite_Resource__c = 50;
        demand.Rate_per_Head_offshore__c = 20;  
        demand.Rate_per_Head_onsite__c = 20;
        demand.Service_Line__c = 'Applications'; 
        demand.OnSiteAmount__c = 'test1:20;test2:80';
        demand.OffshoreAmount__c = 'test1:20;test2:80';
        return demand;
    }
    public static List<Planning_Version__c> createPlanningVersion(List<Fiscal_Year_Planning__c> lstFY)
    {
        List<Planning_Version__c> lstFYP = new List<Planning_Version__c>();     
        Integer q = 0;
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
        for(Fiscal_Year_Planning__c f : lstFY){
            Date startDate = f.StartDate__c;
            Date endDate = (startDate.addMonths(1)).adddays(-1);
            for(Integer i = 1;i<=12;i++){            
                if(i > 4)q= 1;
                else if(i > 7)q= 2;
                else if(i > 10)q= 3;
                else q = 4;
                lstFYP.add(
                    new Planning_Version__c(
                    Is_this_a_Budget_Planning_Version__c = false,
                    Is_this_a_Gap_Planning_Version__c  = false,
                    SequenceNo__c = i,
                    Data_Entry_Closed_Date__c= endDate ,
                    Data_Entry_Start_Date__c  = startDate ,
                    Version_Status__c= 'Open(Admin)',
                    Planning_Version_Fiscal_Year__c = f.Name,
                    Planning_Version_Current_Period__c= i+'',
                    Fiscal_Year_Planning__c = f.Id,
                    MonthName__c = mapMonthString.get(i)
                    
                ));
                startDate  = startDate.addMonths(1);
                endDate = endDate.addMonths(1);
            }
        }
        return lstFYP;
    }
}