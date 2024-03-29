@isTest 
private with sharing class Test_DemandPlanning{
    static testMethod void unitTest() {
        
        
        
        User loginUser = Test_Utility.createUser(); 
        system.runAs(loginUser)
        {       
            
            List<string> lstYearNames = new List<string>();
            lstYearNames.add('2016');
            lstYearNames.add('2017');
            lstYearNames.add('2018');
            List<Fiscal_Year_Planning__c> lstPYear = Test_Utility.createFiscalYear(lstYearNames);
            if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
             insert lstPYear;
            }
            
            List<Fiscal_Year_Model__c> lstPYearPeriod = Test_Utility.createFiscalYearPeriods(lstPYear);
            if(Fiscal_Year_Model__c.SObjectType.getDescribe().isCreateable()){
            insert lstPYearPeriod;
            }
            
            
            List<Planning_Version__c> lstPVersion = Test_Utility.createPlanningVersion(lstPYear);
            if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            insert lstPVersion;
            }
            
            Planning_Financial_Measure__c measureObj1 = Test_Utility.createMeasure('Revenue');
            if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
            insert measureObj1;
            }
            Planning_Financial_Measure__c measureObj2 = Test_Utility.createMeasure('Revenue Backlog');
            if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
            insert measureObj2;
            }
            Planning_Financial_Measure__c measureObj3 = Test_Utility.createMeasure('Onsite');
             if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
            insert measureObj3;
             }
            Planning_Financial_Measure__c measureObj4 = Test_Utility.createMeasure('Offshore');
            if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
            insert measureObj4;
            }
            Configuration_Setting__c configObj = Test_Utility.createConfigurationSettingObj('2018');
            if(Configuration_Setting__c.SObjectType.getDescribe().isCreateable()){
            insert configObj;
            }
            
            Account Acc = Test_Utility.createAccount();
            if(Account.SObjectType.getDescribe().isCreateable()){
            insert Acc;
            }
            system.assertNotEquals(Acc.Id,null);
            
           // Opportunity Opp = Test_Utility.createOpportunity('Test Opp',Acc.Id,'Regular');
           	Opportunity Opp = Test_Utility.createOpportunity('Test Opp',Acc.Id,'Budget');
            Opp.BussinessUnit__c = 'Americas';
            Opp.Division__c = 'Manufacturing';
            Opp.Service_Line__c = 'Applications'; 
            if(Opportunity.SObjectType.getDescribe().isCreateable()){
            insert Opp;
            }
            
            Demand_Configuration_Ratio__c  demand = Test_Utility.createDemandConfiguration();
            demand.Emails__c = 'test@gmail.com';
             if(Demand_Configuration_Ratio__c.SObjectType.getDescribe().isCreateable()){
           		 insert demand;
             }
            
            Demand_Configuration_Ratio__c  demand2 = Test_Utility.createDemandConfiguration();
            
            try {
            	if(Demand_Configuration_Ratio__c.SObjectType.getDescribe().isCreateable()){
                insert demand2;
            	}
            } 
            catch (DMLException e) {
                System.assert(e.getMessage().contains('Duplicate Records Found'), e.getMessage());
            }
            
            demand.Offshore_Deal_Month__c   = 30;
             if(Demand_Configuration_Ratio__c.SObjectType.getDescribe().isUpdateable()){
            update demand;
             }
            
            opp.stageName = 'Prospecting';
            if(Opportunity.SObjectType.getDescribe().isUpdateable()){
            update opp;
            }
            
            User cUser;
        	if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.UserRoleId.isAccessible()){
           	  cUser = [select Id,UserRoleId from User where Id=: loginUser.id];
       		 }
            Test.StartTest();     
        
                PageReference pageRef = Page.DemandPlanning;
                pageRef.getParameters().put('id', String.valueOf(Opp.Id));
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController sc = new ApexPages.StandardController(Opp);
                DemandPlanningHandler con = new DemandPlanningHandler(sc);
                con.getPlanningModel();
                con.getDemandData();
                con.updateModel();
                con.saveModels();
                con.GotoBack();
                con.resetModels();
            Test.StopTest();
        }        
        
    }
}