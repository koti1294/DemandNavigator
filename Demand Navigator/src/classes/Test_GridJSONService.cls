@isTest
public with sharing class Test_GridJSONService{
    static testMethod void OtherClasses(){
        
        Json_Year j1 = new Json_Year();
        j1.year = 2015;
        Json_Year j2 = new Json_Year();
        j2.year = 2016;
        
        List<Json_Year> lstJYear = new List<Json_Year>();
        lstJYear.add(j1);
        lstJYear.add(j2);
        
        lstJYear.sort();
        
        Json_Measure m1 = new Json_Measure();
        m1.name = 'revenue';
        Json_Measure m2 = new Json_Measure();
        m2.name = 'adjustment';
        
        List<Json_Measure> lstMeasure = new List<Json_Measure>();
        lstMeasure.add(m1);
        lstMeasure.add(m2);
        lstMeasure.sort();
        
        
        Json_Period_Measure pm1 = new Json_Period_Measure();
        pm1.name = 'revenue';
        Json_Period_Measure pm2 = new Json_Period_Measure();
        pm2.name = 'adjustment';
        
        List<Json_Period_Measure> plstMeasure = new List<Json_Period_Measure>();
        plstMeasure.add(pm1);
        plstMeasure.add(pm2);
        plstMeasure.sort();
        
        System.assertEquals(pm1.name,'revenue'); 
        
    }
    static testMethod void UnitTest1(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
         
       
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
           }
           if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()){
         
        
            Planning_Model__c  Model = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c limit 1];
            
           if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() &&  Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()){
          
        
            Planning_Version__c version = [select Id,Fiscal_Year_Planning__r.StartDate__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Fiscal_Year_Planning__r.EndDate__c,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
           
           //system.assertEquals(version.Fiscal_Year_Planning__r.StartDate__c+', '+version.Fiscal_Year_Planning__r.EndDate__c+', '+version.Data_Entry_Start_Date__c+', '+version.Data_Entry_Closed_Date__c,'k');
                            
                            
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
           }

            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'getFilterJSON');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', Model.Id);
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', model.Fiscal_Period__c);
            System.currentPageReference().getParameters().put('MeasureId', mm );
            System.currentPageReference().getParameters().put('Amount', '200');
            System.currentPageReference().getParameters().put('Comment','ok tested');
             }
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            
            
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'JsonDataRefined');
            GridJSONService con1 = new GridJSONService();
            con1.StartUpAction();
            
            test.StopTest();
        }

        
    }
    static testMethod void UnitTest2(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        List<Opportunity> oppList = new List<Opportunity>();
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() ){
       
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
           }
           if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Opportunity.fields.closeDate.isAccessible()
           && Schema.sObjectType.Opportunity.fields.stageName.isAccessible() && Schema.sObjectType.Opportunity.fields.iswon.isAccessible()
           && Schema.sObjectType.Opportunity.fields.isClosed.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible()
           && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() 
           && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() ){
        
            Planning_Model__c  Model = [Select   ID,Opportunity__r.closeDate,Opportunity__r.stageName,Opportunity__r.iswon,Opportunity__r.isClosed,Planning_Version__r.Name,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
          
          if (Schema.sObjectType.opportunity.fields.Id.isAccessible() && Schema.sObjectType.opportunity.fields.CloseDate.isAccessible()
          && Schema.sObjectType.opportunity.fields.Project_Start_Date__c.isAccessible()){
            
          
            opportunity opp = [select Id,CloseDate,Project_Start_Date__c   from opportunity where Id =: Model.Opportunity__c];
            oppList.add(opp);
            opp.closeDate = Date.newInstance(2016,10,1);
            opp.Project_Start_Date__c  =Date.newInstance(2016,11,1);
            if(opportunity.SObjectType.getDescribe().isUpdateable()){
            update opp;
            }
            system.assertEquals(opp.closeDate,Date.newInstance(2016,10,1));
           if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()){
       
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
           }
           }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'JsonDataRefined');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', Model.Id);
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', model.Fiscal_Period__c);
            System.currentPageReference().getParameters().put('MeasureId', model.Planning_Measure__c);
            System.currentPageReference().getParameters().put('Amount', '200');
            System.currentPageReference().getParameters().put('Comment','ok tested');
            
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            
           }
            test.StopTest();
        }

        
    }
    static testMethod void UnitTest_GridPDF(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.Gridpdf;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
        
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
            }
             if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Opportunity.fields.closeDate.isAccessible()
           && Schema.sObjectType.Opportunity.fields.stageName.isAccessible() && Schema.sObjectType.Opportunity.fields.iswon.isAccessible()
           && Schema.sObjectType.Opportunity.fields.isClosed.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible()
           && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()
           && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
           && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() 
           && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() ){
            
           
            Planning_Model__c  Model = [Select   ID,Opportunity__r.closeDate,Opportunity__r.stageName,Opportunity__r.iswon,Opportunity__r.isClosed,Planning_Version__r.Name,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
           
           if (Schema.sObjectType.opportunity.fields.Id.isAccessible() && Schema.sObjectType.opportunity.fields.CloseDate.isAccessible()
           && Schema.sObjectType.opportunity.fields.Project_Start_Date__c.isAccessible()) {
       
            opportunity opp = [select Id,CloseDate,Project_Start_Date__c   from opportunity where Id =: Model.Opportunity__c];
            
            opp.closeDate = Date.newInstance(2016,10,1);
            opp.Project_Start_Date__c  =Date.newInstance(2016,11,1);
            if(opportunity.SObjectType.getDescribe().isUpdateable()){
            update opp;
            }
            system.assertEquals(opp.closeDate,Date.newInstance(2016,10,1));
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()) {
            
           
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'JsonDataRefined');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', Model.Id);
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', model.Fiscal_Period__c);
            System.currentPageReference().getParameters().put('MeasureId', model.Planning_Measure__c);
            System.currentPageReference().getParameters().put('Amount', '200');
            System.currentPageReference().getParameters().put('Comment','ok tested');
    
            GridPDF con = new GridPDF();
            GridPDF.S_FiscalYearSettings pp = new GridPDF.S_FiscalYearSettings();
            GridPDF.S_Period pph = new GridPDF.S_Period();
            con.getPicklistValues('Opportunity','StageName');
            }
           }
          }        
            test.StopTest();
        }

        
    }


    static testMethod void UnitTest3(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() ){
       
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
             }
            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
           ){
            
            Planning_Model__c  Model = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
            
            system.assertNotEquals(Model.Id,null);
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()){
      
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'UpdateModel');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', Model.Id);
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId',  string.valueOf(model.Fiscal_Period__r.Period_Number__c));
            System.currentPageReference().getParameters().put('MeasureId', model.Planning_Measure__c);
            System.currentPageReference().getParameters().put('Amount', '888');
            System.currentPageReference().getParameters().put('Comment','ok tested');
    
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()){
       
            Planning_Model__c lstpm = [Select ID,Amount__c from Planning_Model__c where id=: Model.Id limit 1];
             }
           // system.assertNotEquals(lstpm.ID,null);
            //system.assertEquals(lstpm.Amount__c,888);
              }
           } 
            test.StopTest();
        }

        
    }
    static testMethod void UnitTest4(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
       
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
             if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
           ){
            Planning_Model__c  Model = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
            
            system.assertNotEquals(Model.Id,null);
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() ){
        
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'UpdateModelComment');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', Model.Id);
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', model.Fiscal_Period__c);
            System.currentPageReference().getParameters().put('MeasureId', mm );
            System.currentPageReference().getParameters().put('Amount', '200');
            System.currentPageReference().getParameters().put('Comment','ok tested');
    
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()){
        
            Planning_Model__c  CModel = [Select   ID,Comments__c from  Planning_Model__c where Id =:Model.Id ];
            system.assertNotEquals(CModel.ID,null);
            //system.assertEquals(CModel.Comments__c, 'ok tested');
            }
             }
           }
          }
            test.StopTest();
        }

        
    }
    static testMethod void UnitTest5(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
        
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
           ){
            Planning_Model__c  Model = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
            
            
            system.assertNotEquals(Model.Id,null);
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()){
       
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'UpdateModel');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', 'NewId');
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', model.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', string.valueOf(model.Fiscal_Period__r.Period_Number__c));
            System.currentPageReference().getParameters().put('MeasureId', model.Planning_Measure__c);
            System.currentPageReference().getParameters().put('Amount', '999');
            System.currentPageReference().getParameters().put('Comment','ok tested');
    
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            
            
            String FName = 'FY'+Model.Fiscal_Period__r.Fiscal_Year__c+'P'+string.valueOf(model.Fiscal_Period__r.Period_Number__c);
            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.id.isAccessible() ){
        
            Fiscal_Year_Model__c fyear = [select id,Name from Fiscal_Year_Model__c where Name =: FName];
           if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()){
         
            Planning_Model__c lstpm = [Select ID,Amount__c from Planning_Model__c where 
                Fiscal_Period__c =: fyear.Id and 
                Opportunity__c =: model.Opportunity__c and 
                Planning_Version__c =: model.Planning_Version__c and 
                Planning_Measure__c =: model.Planning_Measure__c  limit 1];
            //system.assertEquals(lstpm.Amount__c,999);                    
            test.StopTest();
           }
            }
             }
           }
            }
        }
        }
   static testMethod void UnitTest6(){
          
        user u = testUtils.createUser();       
        System.assertNotEquals(u.Id,null);
        System.runAs(u){
            test.StartTest();
            
            
            testUtils.createMeasures();  
            Configuration_Setting__c confsett = testUtils.createConfigurationSettingObj();   
            testUtils.createOpportunities();      
            PageReference pageRef = Page.GridJSONService;
            Test.setCurrentPage(pageRef);
            
            string mm;
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
       
            for(Planning_Financial_Measure__c m : [select Id,Name from Planning_Financial_Measure__c]){
                if(mm == null) mm = m.Id;
                else mm += ', '+m.Id;
            }
             if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
           ){
            Planning_Model__c  Model = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Budget' limit 1];
            system.assertNotEquals(Model.Id,null);
            
            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
           ){
            Planning_Model__c  GModel = [Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,
            Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,
            Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c,Planning_Version__c from  Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'Gap' limit 1];
            
            system.assertNotEquals(GModel.Id,null);
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()){
        
            Planning_Version__c version = [select Id,Version_Status__c from Planning_Version__c where Id =: model.Planning_Version__c limit 1];
            version.Version_Status__c  = 'Open (User)';
            if(Planning_Version__c.SObjectType.getDescribe().isUpdateable()){
            update version ;
            }
            System.currentPageReference().getParameters().put('securityToken', encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));
            System.currentPageReference().getParameters().put('MethodName', 'UpdateModel');
            System.currentPageReference().getParameters().put('PlanningVersionId', model.Planning_Version__c);
            System.currentPageReference().getParameters().put('Measure', mm);
            System.currentPageReference().getParameters().put('RowId', 'NewId');
            System.currentPageReference().getParameters().put('YearId', Model.Fiscal_Period__r.Fiscal_Year__c);
            System.currentPageReference().getParameters().put('OpportunityId', GModel.Opportunity__c);
            System.currentPageReference().getParameters().put('PeriodId', string.valueOf(model.Fiscal_Period__r.Period_Number__c));
            System.currentPageReference().getParameters().put('MeasureId', model.Planning_Measure__c);
            System.currentPageReference().getParameters().put('Amount', '200');
            System.currentPageReference().getParameters().put('Comment','ok tested');
    
            GridJSONService con = new GridJSONService();
            con.StartUpAction();
            
            String FName = 'FY'+Model.Fiscal_Period__r.Fiscal_Year__c+'P'+string.valueOf(model.Fiscal_Period__r.Period_Number__c);
            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()){
       
            Fiscal_Year_Model__c fyear = [select id,Name from Fiscal_Year_Model__c where Name =: FName];
            
             if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){     
                           
            string MName = [select Id,Name from Planning_Financial_Measure__c where id =:  model.Planning_Measure__c].Name; 
            
             if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()){  
                
             
            string PName = [select Id,Name from Planning_Version__c where Id =:model.Planning_Version__c].Name;
            string newModel  = GModel.Opportunity__c+'#'+fyear.Name+'#'+PName+'#'+MName;
                                    
            //Planning_Model__c nmodel = [select Id,ModelName__c from Planning_Model__c where ModelName__c  =: newModel ];
            //system.assertNotEquals(nmodel.Id,null);
             }
             }
            }
            }
           }
              }
             }
            test.StopTest();
        }

        
    }

}