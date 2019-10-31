@isTest(SeeAllData = true)
public with sharing class Test_Forecastera_Planning_Workbench{
    public testMethod static void UnitTest(){ 
        PageReference pageRef = Page.Forecastera_Planning_Workbench;
        Test.setCurrentPage(pageRef);
        Forecastera_Planning_Workbench con = new Forecastera_Planning_Workbench();
        con.setcUserName('testuser');
        con.setcUserRole('testrole');
        con.setSFDCInstance('na23');
        con.setsecurityToken('123');
        
        string user = con.getcUserName();
        string role = con.getcUserRole();
        string name = con.getSFDCInstance();
        string sec = con.getsecurityToken();
        
        con.gotohomepage();
        
        
        
        Date startDate = System.today();
        Date endDate = startDate.addDays(30);
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
        Fiscal_Year_Planning__c fyp1 = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
        insert fyp1;
        }
        
        List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
        for(Integer i = 1;i<13;i++){
        
                lstVersion.add(
                    new Planning_Version__c(
                        Fiscal_Year_Planning__c = fyp1.Id,
                        Is_this_a_Budget_Planning_Version__c = false,
                        SequenceNo__c = i,
                        Data_Entry_Closed_Date__c= endDate ,
                        Data_Entry_Start_Date__c  = startDate ,
                        Version_Status__c= 'Closed',
                        Planning_Version_Fiscal_Year__c = ((2000+i)+''),
                        Planning_Version_Current_Period__c= i+'',
                        MonthName__c = mapMonthString.get(i)
                    ));
                    startDate  = endDate.addDays(1);
                    endDate = startDate.addDays(30);
        } 
        if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
        insert lstVersion;
        }
        
        Planning_Financial_Measure__c fm = new Planning_Financial_Measure__c(Name = 'Revenue Backlog');
        if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
        insert fm;
        }
        System.currentPageReference().getParameters().put('P_strSavedStages', fm.Name);
        
        Planning_Model__c pm = new Planning_Model__c();
        
        pm.Amount__c = 100;
        pm.Comments__c = 'test';
        pm.Planning_Measure__c = fm.Id;
        pm.Planning_Version__c = lstVersion[10].Id;
        if(Planning_Model__c.SObjectType.getDescribe().isCreateable()){
        insert pm;
        }
        System.assertEquals(pm.Amount__c,100);
    }
   
}