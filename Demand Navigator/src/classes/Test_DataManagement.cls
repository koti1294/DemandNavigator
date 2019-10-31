@isTest(seeAllData=true)
public with sharing class Test_DataManagement {
    public testMethod static void UnitTest1(){
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){ 
            PageReference pageRef = Page.DataManagementPageV1;
            Test.setCurrentPage(pageRef);
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
            System.assertEquals(lstVersion.size(),12);
            
            
            
            
            //New Planning Version
             
            NewPlanningVersionExtensionv4 newplan = new NewPlanningVersionExtensionv4();
            newplan.fiscalYear = '2001';
            newplan.FiscalPeriod = '1'; 
            newplan.isCustomFiscalYearEnable = false;
            newplan.getFYears();
            newplan.getFStatus();
            newplan.getFPeriods();
            newplan.changePeriods();
            newplan.setFiscalDates();
            newplan.cancelConfiguration();
            newplan.getPVType();
            newplan.saveConfiguration();
            
                  
                    
        }
        
    }
    public testMethod static void UnitTest2(){ 
        
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        NewPlanningVersionExtensionv4.S_FiscalYearSettings obj = new NewPlanningVersionExtensionv4.S_FiscalYearSettings();
        System.runAs(u){
            NewPlanningVersionExtensionv4 newplan = new NewPlanningVersionExtensionv4();
            newplan.getFYears();
            newplan.getFStatus();
            newplan.getFPeriods();
            newplan.changePeriods();
            newplan.setFiscalDates();
            newplan.cancelConfiguration();
            newplan.saveConfiguration();
            //newplan.setStandardPlannerPeriod(obj);
            
            PageReference pageRef = Page.DataManagementPageV1;
            Test.setCurrentPage(pageRef);
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
            System.assertEquals(lstVersion.size(),12);
        
                  
            ManageFiscalPlanningStatusv4  manageStatus = new ManageFiscalPlanningStatusv4(newplan);
            manageStatus.SelectedYear='2001';
            manageStatus.SelectedMonth='1';
            manageStatus.onChangeStatus();
            manageStatus.SelectedYear='2001';
            manageStatus.SelectedMonth='1';
            manageStatus.onChangeEndDate();
            manageStatus.save(); 
            manageStatus.getStatus('2017',02);
            manageStatus.getNextVersion(2017,02);
            manageStatus.getCurrentMonthId('2017');
            manageStatus.getAllFiscalPlanningPeriods();
            manageStatus.getWarning1();
            manageStatus.getFYL();
            manageStatus.getAllFiscalPlanningPeriods();
            manageStatus.save();
            manageStatus.acc=lstVersion[0];
        }
        
        
        
    }
    public testMethod static void UnitTest3(){
    	//Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
    	Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Budget').getRecordTypeId();
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        List<FiscalYearSettings> fisList2;
        if (Schema.sObjectType.FiscalYearSettings.fields.Id.isAccessible()){
          fisList2 = [Select Id from FiscalYearSettings ];
        }
        System.runAs(u){
            testutils.createConfigurationSettingObj('2001');
            NewPlanningVersionExtensionv4 newplan = new NewPlanningVersionExtensionv4();
            newplan.getFYears();
            newplan.getFStatus();
            newplan.getFPeriods();
            newplan.changePeriods();
            newplan.setFiscalDates(); 
            newplan.cancelConfiguration();
            newplan.saveConfiguration();
            newplan.lstfiscalsetting.addAll(fisList2); 
            
            PageReference pageRef = Page.DataManagementPageV1; 
            Test.setCurrentPage(pageRef);
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
                            NAME = '2001-b'+i,
                            Is_this_a_Budget_Planning_Version__c = true,
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
            System.assertEquals(lstVersion.size(),12);
           
                   
            //copy planning versions 
            
            System.currentPageReference().getParameters().put('P_strFromPlan', lstVersion[10].Id);
            System.currentPageReference().getParameters().put('P_strToPlan', lstVersion[0].Id);
            
            
    
            
            
            Planning_Financial_Measure__c fm = new Planning_Financial_Measure__c(Name = 'Revenue Backlog');
            if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
            insert fm;
            }
            System.currentPageReference().getParameters().put('P_strSavedStages', fm.Name);
            
            Account  Acc = new Account(Name = 'test account');
            if(Account.SObjectType.getDescribe().isCreateable()){
            insert Acc;
            }
            Date cd = date.newInstance(2001,6,1);
            Opportunity Opp = new Opportunity(name='Test Opp',RecordTypeId=devRecordTypeId,
            Deal_TCV__c = 100,accountId = Acc.Id,Deal_Duration__c  =12,
            StageName='Open',Project_Start_Date__c = date.today(),CloseDate=cd,Amount=1000000,Budget_Planning_Version__c=lstVersion[0].Id);
            if(Opportunity.SObjectType.getDescribe().isCreateable()){
            insert Opp;
            }
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible()){
         
            Planning_Version__c v = [select Id from Planning_Version__c where Name = '2001-b11' limit 1];
            
            
            Planning_Model__c pm = new Planning_Model__c();
            pm.ModelName__c = opp.Id+'#'+fyp1.Name +'#'+ lstVersion[10].Name +'#'+ 'Revenue Backlog';
            pm.Opportunity__c =opp.Id;
            pm.Amount__c = 100;
            pm.Comments__c = 'test';
            pm.Planning_Measure__c = fm.Id;
            pm.Planning_Version__c = v.Id;
            if(Planning_Model__c.SObjectType.getDescribe().isCreateable()){
            insert pm;
            } 
            if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() ){
            Opportunity Dopp = [select Id,RecordType.DeveloperName from Opportunity where Id =: opp.Id];
            
            system.AssertEquals(Dopp.RecordType.DeveloperName,'Budget');
            
            CopyPlanningVersionv1 copy = new CopyPlanningVersionv1(newplan );
            
            
            copy.setProcessContent();
            
            copy.setEnablePlanning();        
            copy.getFromPlanYear();
            copy.getToPlanYear();
            copy.getFromClearPlanYear();
            
            copy.getFromClearPlan();
            copy.getFromPlan();
            copy.getToPlan();
            
            
            
            
            
            copy.CopyPlanningVersion();        
            copy.resetCopyPlanning();
            copy.resetClearPlanning();
            copy.deleteAllModel();
            copy.getp_t();
            copy.getp_f();
            
            copy.verifyDeleteAllModel();
            
            
            
            Fiscal_Year_Planning__c fyp = new Fiscal_Year_Planning__c(Name = '2001',StartDate__c = fstartDate,EndDate__c = fendDate);
            if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()){
            insert fyp;
            }      
            startDate = System.today();
            endDate = startDate.addDays(30);
            
            List<Planning_Version__c>  lstoppVersion = new List<Planning_Version__c>();
            for(Integer i = 1;i<13;i++){
            
                    lstoppVersion.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = fyp.Id,
                            NAME = '2001-p'+i,
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
                 insert lstoppVersion; 
            }
            OppBacklogv5 oppback = new OppBacklogv5(newplan ); 
            oppback.getCPlanVersion();
            oppback.getPlanVersion(); 
            oppback.ER_strPlanversion = lstoppVersion[0].Id;

            

            
            //oppback.ER_strPlanversion = lstVersion[0].Id;
            oppback.onPlanningVersionChange();
            oppback.SaveModel(); 
            oppback.strPlanversion='test';
            List<FiscalYearSettings> fisList;
            if (Schema.sObjectType.FiscalYearSettings.fields.Id.isAccessible()){
             fisList = [Select Id from FiscalYearSettings ];
            }
           oppback.lstfiscalsetting.addAll(fisList);
            oppback.mapPlanningVersion.put(lstVersion[0].Id,lstVersion[0]);
            
            List<OppBacklogv5.wrapper_PModel> lstpModel = new List<OppBacklogv5.wrapper_PModel>();
            OppBacklogv5.wrapper_PModel pp = new OppBacklogv5.wrapper_PModel('1',pm);        
            lstpModel.add(pp); 
            OppBacklogv5.wrapper_PModel pp2 = new OppBacklogv5.wrapper_PModel('2',pm);        
            lstpModel.add(pp2); 
            lstpModel.sort();
            
            }
        }  
        }
        
    }
   
    
}