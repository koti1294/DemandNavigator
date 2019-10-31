@isTest
public with sharing class TEST_CurrencyConversion{
    static testMethod void unitTest() {
        Date fstartDate = Date.newInstance(2001,1,1);
        Date fendDate = Date.newInstance(2001,12,31);
        Date startDate = System.today();
        Date endDate = startDate.addDays(30);
        Fiscal_Year_Planning__c fyp1 = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            
        insert fyp1;
         }
         List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    lstVersion.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = fyp1.Id,
                            Is_this_a_Budget_Planning_Version__c = true,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = ((2000+i)+''),
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = '5'
                        ));
                        startDate  = endDate.addDays(1);
                        endDate = startDate.addDays(30);
            } 
           if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            
            insert lstVersion;
           }
        //Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        //Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Budget').getRecordTypeId();
        Account  Acc = new Account(Name = 'test account');
        if(Account.SObjectType.getDescribe().isCreateable()){
        insert Acc;
        }
        Date cd = date.newInstance(2001,6,1);
        Opportunity Opp = new Opportunity(
            name='Test Opp', 
            Deal_TCV__c = 100,
            accountId = Acc.Id,
            Deal_Duration__c  =12,
            StageName='Open',
            Project_Start_Date__c = date.today(),
            CloseDate=cd,
            //RecordTypeId=devRecordTypeId,
            Budget_Planning_Version__c=lstVersion[0].Id,
            Amount=1000000
        );  
        if(Opportunity.SObjectType.getDescribe().isCreateable()){      
        insert Opp;
        }
        system.assertNotEquals(opp.Id,null);
        set<Id> setOpp = new Set<Id>();
        setOpp.add(opp.Id);
        CurrencyConversion con = new CurrencyConversion();
        CurrencyConversion.Initialization();
        CurrencyConversion.opportunityCurrencyCode(setOpp);
        CurrencyConversion.Convert('USD','INR',100);
        
    }
}