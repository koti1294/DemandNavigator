@isTest
public with sharing class Test_Reports{
    static testMethod void TEST_RB_by_Period_or_Quarter(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate(); 
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){   
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Revenue_Backlog_by_Period_or_Quarter;
            Test.setCurrentPage(pageRef);
            LT_Revenue_Backlog_by_Period_or_Quarter con = new LT_Revenue_Backlog_by_Period_or_Quarter();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getData();
            con.getOpportunityStages();
            con.getOppStages();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();    
            con.setcategory('Quarter');              
            con.getPlanningModel(); 
        }   
    } 
    static testMethod void TEST_PM_by_Period(){
       user u = testUtils.createUser();       
       System.assertNotEquals(u.Id,null);
       System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();  
            Planning_Model__c model;
             if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){  
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Planning_Measure_by_Period3;
            Test.setCurrentPage(pageRef);
            LT_Planning_Measure_by_Period3 con = new LT_Planning_Measure_by_Period3();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getMeasureItems();
            con.getPMeasures();
            con.getData();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();    
            con.setcategory('Quarter'); 
            con.setsAccountText('');
            con.setsOpportunityText('');              
            con.getPlanningModel();
        }    
    } 
    static testMethod void TEST_PM_by_PeriodR3(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();  
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){   
            	 model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Planning_Measure_by_Period;
            Test.setCurrentPage(pageRef);
            LT_Planning_Measure_by_Period con = new LT_Planning_Measure_by_Period();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getMeasureItems();
            con.getPMeasures();
            con.getData();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();    
            con.setcategory('Quarter'); 
            con.setsAccountText('');
            con.setsOpportunityText('');               
            con.getPlanningModel();   
        } 
    } 
    
    static testMethod void TEST_ReportSummary(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){     
            	 model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_ReportSummary;
            Test.setCurrentPage(pageRef);
            LT_ReportSummary con = new LT_ReportSummary();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getMeasureItems();
            con.getPMeasures();
            con.getData();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();    
            con.setcategory('Quarter'); 
            con.setsAccountText('');
            con.setsOpportunityText('');           
            con.getPlanningModel();  
            con.getOpportunityCategories();  
        }
    } 
    static testMethod void TEST_Total_LT_Total_Backlog_by_Roless_1(){ 
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            //Part 1
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate(); 
            Planning_Model__c model; 
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){   
            	 model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }        
            PageReference pageRef = Page.LT_Total_Backlog_by_Roles;      
            Test.setCurrentPage(pageRef);
            
            System.currentPageReference().getParameters().put('RoleId', UserInfo.getUserRoleId());
            System.currentPageReference().getParameters().put('OwnerId', userinfo.getuserId());
            
            LT_Total_Backlog_by_Roles con = new LT_Total_Backlog_by_Roles();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setstrRole('Backlog');
            con.setstrAccOwner(u.Name);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            
            con.getData();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();
            con.setcategory('Quarter'); 
            con.getPlanningModel();
        }
    }
    static testMethod void TEST_Total_LT_Total_Backlog_by_Roless_2(){ 
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            //Part 2
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();
            Planning_Model__c model; 
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){    
            	 model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }      
            LT_Total_Backlog_by_Roles con = new LT_Total_Backlog_by_Roles();
            con.setstrFromPlan(model.Planning_Version__c); 
            con.setstrRole('Backlog');
            con.setstrAccOwner(u.Name);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getData();
            con.retrieveData();
            con.getFromPlan();
            con.getCategoryItem();
            con.getFromPlanYear();
            con.Export();
            
            
            con.setcategory('Quarter'); 
            con.getPlanningModel();
            
            
            
            List<FYears> lstF = new List<FYears>();
            FYears f1 = new FYears();
            f1.label = 'january';
            f1.value = 1;
            f1.labelNumber = 1;
            
            FYears f2 = new FYears();
            f2.label = 'february';
            f2.value = 2;
            f2.labelNumber = 2;
            
            lstF.add(f1);
            lstF.add(f2);
            lstF.sort();
            
            List<TableValue> lstT = new List<TableValue>();
            TableValue t1 = new TableValue();
            t1.AccountOwner = 'Test1';
            
            
            TableValue t2 = new TableValue();
            t2.AccountOwner = 'Test2';      
            
            lstT.add(t1);
            lstT.add(t2);
            lstT.sort();
            
            system.assertNotEquals(con.lstTValue,null);
        }
    }
    
    static testMethod void TEST_Total_LT_Total_Backlog_by_Roless_3(){ 
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            //Part 3
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate(); 
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){    
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }       
            LT_Total_Backlog_by_Roles con = new LT_Total_Backlog_by_Roles();
            con.setstrFromPlan(model.Planning_Version__c); 
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setstrRole('Backlog');
            con.setstrAccOwner(u.Name);
            con.setsAccountText('');
            con.setsOpportunityText('');   
            con.getPlanningModel();
        }
    }
    static testMethod void TEST_Total_LT_Total_Backlog_by_Roless_4(){ 
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            //Part 4
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();  
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){  
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            LT_Total_Backlog_by_Roles con = new LT_Total_Backlog_by_Roles();
            con.setstrFromPlan(model.Planning_Version__c); 
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setstrRole('Backlog');
            con.setstrAccOwner(u.Name);
            con.setsAccountText('');
            con.setsOpportunityText('');      
            con.getPlanningModel();
        }
        
    }
    
   static testMethod void TEST_Revenue_prioritization_report(){
       user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate(); 
            Planning_Model__c model;
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){    
              model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Revenue_prioritization_report;
            Test.setCurrentPage(pageRef);
            Revenue_PrioritizationController con = new Revenue_PrioritizationController();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getData();
            con.getOpportunityStages();
            con.getOppStages();
            con.retrieveData();
            con.getFromPlanYear();
            con.Export(); 
            con.getFiscalQuarter();
            con.getFiscalOwner();
            con.getOppBussinessUnit();
            con.getOppDivision();
        }
        
    }
    
    static testMethod void TEST_Bookings_Prioritization_report(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();   
            Planning_Model__c model; 
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){ 
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Bookings_prioritization_report;
            Test.setCurrentPage(pageRef);
            Bookings_PrioritizationController con = new Bookings_PrioritizationController();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.sAccountText = model.Opportunity__r.Account.Name;
            con.sOpportunityText = model.Opportunity__r.Name;
            con.getData();
            con.getOpportunityStages();
            con.getOppStages();
            con.retrieveData();
            con.getFromPlanYear();
            con.Export(); 
        }
    } 
    static testMethod void TEST_Bookings_Prioritization_Quarter_report(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();    
            Planning_Model__c model;
             if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){ 
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_Bookings_prioritization_report;
            Test.setCurrentPage(pageRef);
            Bookings_PrioritizationController con = new Bookings_PrioritizationController();
            con.setCategory('Quarter');
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.sAccountText = model.Opportunity__r.Account.Name;
            con.sOpportunityText = model.Opportunity__r.Name;
            con.getData();
            con.getOpportunityStages();
            con.getOppStages();
            con.retrieveData();
            con.getFromPlanYear();
            con.Export(); 
        }
    } 
    
    static testMethod void TEST_ComparePlanningVersion(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.ReportTestDate();
            Planning_Model__c model;
			if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){    
          
             model = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' limit 1];    
            }
            PageReference pageRef = Page.LT_ComparePlanningVersion;
            Test.setCurrentPage(pageRef);
            LT_ComparePlanningVersion con = new LT_ComparePlanningVersion();
            con.setstrFromPlan(model.Planning_Version__c);
            System.assertEquals(con.getstrFromPlan(),model.Planning_Version__c);
            con.setsAccountText(model.Opportunity__r.Account.Name);
            con.setsOpportunityText(model.Opportunity__r.Name);
            con.getData();
            con.getOpportunityStages();
            con.getOppStages();
            con.retrieveData();
            con.getFromPlanYear();
            con.Export(); 
            con.getFiscalQuarter();
            con.getFromPlan();
            con.getCategoryItem();
            con.getCompaireMeasure();
            con.getOpportunityCategories();
        
        }
    } 
    static testMethod void TEST_VeryNewReportSummary(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            testUtils.createMeasures();
            Configuration_Setting__c consett = testUtils.createConfigurationSettingObj();
            testUtils.createOpportunities(); 
             List<Planning_Model__c> modelList1;  
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()){
             
              modelList1 = [select Id,Name,Planning_Measure__r.Name,Planning_Version__c,Opportunity__r.Name,Opportunity__r.Account.Name from Planning_Model__c  where Planning_Measure__r.Name = 'Revenue Backlog' and Planning_Version__r.Is_this_a_Budget_Planning_Version__c = false and Id!=null and Planning_Version__r.Is_this_a_Gap_Planning_Version__c = false limit 1];
            }
          	Planning_Model__c model1;
          	if(modelList1.size()>0)
          	 model1 =modelList1[0];
          	 Planning_Version__c version2;
          	  Planning_Version__c version3;
          	 if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()){
             version2= [select Id,Name from Planning_Version__c where Is_this_a_Budget_Planning_Version__c = true  and Is_this_a_Gap_Planning_Version__c = false limit 1];
             version3= [select Id,Name from Planning_Version__c where Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = true limit 1];  
       		 }
            PageReference pageRef = Page.LT_VeryNewReportSummary;
            Test.setCurrentPage(pageRef);
            LT_VeryNewReportSummary con = new LT_VeryNewReportSummary();
            if(model1!=null)
            con.setstrFromPlan(model1.Planning_Version__c);
            con.setstrBudgetFromPlan(version2.Id);
            con.setstrGapFromPlan(version3.Id);
            con.getOpportunityCategories();
            con.getFromPlanYear();
            con.getCategoryItem();
            con.getGapFromPlan();
            con.getBudgetFromPlan();
            con.getFromPlan();
            con.getPMeasures();
            
            con.getPlanningModel();
            
            con.retrieveData();
        
        }
    } 
    
    
       
}