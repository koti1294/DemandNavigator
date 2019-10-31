@isTest
public with sharing class Test_ConfigurationSettingV1 {
    public testMethod static void UnitTest(){  
        user u = testUtils.createUser();
               
        System.assertNotEquals(u.Id,null); 
        System.runAs(u)
        {
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
            
            List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    lstVersion.add(
                        new Planning_Version__c(
                            //Fiscal_Year_Planning__c = fyp.Id,
                            Is_this_a_Budget_Planning_Version__c = false,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = '2001',
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = mapMonthString.get(i)
                        ));
                        startDate  = endDate.addDays(1);
                        endDate = startDate.addDays(30);
            } 
            
            if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            insert lstVersion;
            System.assertEquals(lstVersion.size(),12);

            }
             
            Date fstartDate = Date.newInstance(2001,1,1);
            Date fendDate = Date.newInstance(2001,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
            if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            insert fyp;
            }
            
            Additional_Planning_Versions__c addversion1 = new Additional_Planning_Versions__c(Name = 'Budget01', Version_Description__c = 'test');
            if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion1;
            }
            
            Additional_Planning_Versions__c addversion2 = new Additional_Planning_Versions__c(Name = 'Budget02', Version_Description__c = 'test');
            if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion2;

            }
             
            configurationSettingControllerV1 config = new configurationSettingControllerV1();
            config.getFYears();
            config.ResetFiscalYears();
            config.saveconfigurationSetting();
            config.saveOppStage();
            config.redirectToFinancialMeasure();
            config.redirectToAddPlan();
            config.resetStages();
            config.getAllSelectedStage();
            config.SaveNewFiscalYears();
            config.getOrgFiscalSetting();
            config.isCustomFiscalYearEnable = false;        
            config.addAdditionalPlanningVersion();
            config.addFinancialMeasure();
            config.addPlanning12Version();
            config.addPlanning15Version();
            
            config.batchRun();
        }
    }
    public testMethod static void TestStandardFiscalYearSync(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            StandardFiscalYearSync.Initialization();
            StandardFiscalYearSync.putFiscalPeriods();
            StandardFiscalYearSync.putFiscalAdditionalPeriods();
            StandardFiscalYearSync.putCustomFiscalYear();
         }
    }
    public testMethod static void UnitTest2(){  
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();  
            testUtils.createOpportunities();
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
            
            List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    lstVersion.add(
                        new Planning_Version__c(
                            //Fiscal_Year_Planning__c = fyp.Id,
                            Is_this_a_Budget_Planning_Version__c = false,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = '2001',
                            Planning_Version_Current_Period__c= i+'',
                            MonthName__c = mapMonthString.get(i)
                        ));
                        startDate  = endDate.addDays(1);
                        endDate = startDate.addDays(30);
            } 

            if(Planning_Version__c.SObjectType.getDescribe().isCreateable()){
            insert lstVersion;
            System.assertEquals(lstVersion.size(),12);
            }
            
            Date fstartDate = Date.newInstance(2001,1,1);
            Date fendDate = Date.newInstance(2001,12,31);
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
            if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            insert fyp;
            }
            
            Additional_Planning_Versions__c addversion1 = new Additional_Planning_Versions__c(Name = 'Budget01', Version_Description__c = 'test');
            if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion1;
            }
            
            Additional_Planning_Versions__c addversion2 = new Additional_Planning_Versions__c(Name = 'Budget02', Version_Description__c = 'test');
             if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable()){
            insert addversion2;
             }
              
            configurationSettingControllerV1 config = new configurationSettingControllerV1();
            config.getFYears();
            config.ResetFiscalYears();
            config.saveconfigurationSetting();
            config.saveOppStage();
            config.redirectToFinancialMeasure();
            config.redirectToAddPlan();
            config.resetStages();        
            config.getAllSelectedStage();
            config.SaveNewFiscalYears();
            config.getOrgFiscalSetting(); 
            config.isCustomFiscalYearEnable = true;        
            config.addAdditionalPlanningVersion();
            config.addFinancialMeasure();
            config.addPlanning12Version();
            config.addPlanning15Version();        
            config.batchRun();
            
            config.setInstanceURL(config.getInstanceURL());
            config.setforecast_BacklogFiscaYear(config.getforecast_BacklogFiscaYear());
            config.setforecast_OpportunityStages(config.getforecast_OpportunityStages());
            config.setforecast_BudgetVersions(config.getforecast_BudgetVersions());
            config.setforecast_PlanningFiscalPeriods(config.getforecast_PlanningFiscalPeriods());
            config.setforecast_PlanningVersions(config.getforecast_PlanningVersions());
            config.setforecast_PlanningMeasures(config.getforecast_PlanningMeasures());
            config.setforecast_M_BacklogFiscaYear(config.getforecast_M_BacklogFiscaYear());
            config.setforecast_M_OpportunityStages(config.getforecast_M_OpportunityStages());
            config.setforecast_M_BudgetVersions(config.getforecast_M_BudgetVersions());
            config.setforecast_M_PlanningFiscalPeriods(config.getforecast_M_PlanningFiscalPeriods());
    config.setforecast_M_PlanningVersions(config.getforecast_M_PlanningVersions());
    config.setforecast_M_PlanningMeasures(config.getforecast_M_PlanningMeasures());
    config.setforecast_M_Warning(config.getforecast_M_Warning());
    config.setfinancelistview(config.getfinancelistview());
    config.setaddplanningVersionlistview(config.getaddplanningVersionlistview());
    config.setstrStages(config.getstrStages());
    config.setstrCategories(config.getstrCategories());
    config.setstrSavedCategories(config.getstrSavedCategories());
    config.setFiscalYear(config.getFiscalYear());
    config.setstrSavedStages(config.getstrSavedStages());
    
            List<configurationSettingControllerV1.Org_Period> lstCon = new List<configurationSettingControllerV1.Org_Period>();
            configurationSettingControllerV1.Org_Period wclass1 = new configurationSettingControllerV1.Org_Period(1,'1','2001',1,date.today(),date.today(),2001,'101','jun');
            configurationSettingControllerV1.Org_Period wclass2 = new configurationSettingControllerV1.Org_Period(1,'1','2001',1,date.today(),date.today(),2001,'101','jun');
            lstCon.add(wclass1);
            lstCon.add(wclass2);
            lstCon.sort();
        }
    }
}