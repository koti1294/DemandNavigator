@isTest 
private with sharing class Test_DemandConfiguration{
    static testMethod void unitTest() {
        
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
        if(Demand_Configuration_Ratio__c.SObjectType.getDescribe().isCreateable()){
         insert demand;
        }
        system.assertNotEquals(demand.Id,null);
        
        PageReference pageRef = Page.DemandConfiguration;
        pageRef.getParameters().put('id', String.valueOf(demand.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(demand);
        DemandConfigurationController con = new DemandConfigurationController(sc);
        con.getOnSiteOption();
        con.getOffShoreOption();        
        con.reset();
        con.saveDemandRatio(); 
        DemandConfigurationController.WOption empWObj = new DemandConfigurationController.WOption(true,'test1','Test2',42.5);
        con.lstOffshoreOption.add(empWObj);
       // con.lstOnsiteOption.add(empWObj);
    }
    static testmethod void demandconfig(){
        Account Acc = Test_Utility.createAccount();
         if(Account.SObjectType.getDescribe().isCreateable()){
        	insert Acc;
         }
        system.assertNotEquals(Acc.Id,null);
        
        Demand_Configuration_Ratio__c  demand = Test_Utility.createDemandConfiguration();
        if(Demand_Configuration_Ratio__c.SObjectType.getDescribe().isCreateable()){
        	insert demand;
        }
        
       // Opportunity Opp = Test_Utility.createOpportunity('Test Opp',Acc.Id,'Regular');
        Opportunity Opp = Test_Utility.createOpportunity('Test Opp',Acc.Id,'Budget');
        Opp.BussinessUnit__c = 'Americas';
        Opp.Division__c = 'Manufacturing';
        Opp.Service_Line__c = 'Applications'; 
         if(Opportunity.SObjectType.getDescribe().isCreateable()){
        	insert Opp;
         }
        
        
    }
}