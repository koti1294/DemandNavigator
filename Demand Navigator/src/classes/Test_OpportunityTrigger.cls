@isTest
public with sharing class Test_OpportunityTrigger{
    static testMethod void TEST_Method(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            //testUtils.ReportTestDate(); 
            testUtils.createOpportunities();
        }   
           
    }     
       
}