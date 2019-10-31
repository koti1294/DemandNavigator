/*
Develop By : Habimoon 
Created Date : 14th April 2015
Last Modified Date : 23th April 2015 
Purpose :   
            This program will allow you to copy an existing data set (such as the Previous Month Actuals) into a Planning Version that is current to your process.
            This program will allow you to delete all data within a Planning Version.
            You can only delete data from Closed Planning Versions.
*/


public with sharing class CopyPlanningVersionv1  {

    

    
    private List<Planning_Version__c> lstClosedPlanningVersion;
    private List<Planning_Version__c> OpenAdminPlanningVersion;
    private List<Planning_Financial_Measure__c> lstFinancialMeasure;
    
    public String clearPlanningMessage{get;set;}
    public Boolean clearMessagePopup{get;set;}
    public List<Planning_Model__c> lstClearPlanningModels;
    
    public String FromCopyText{get;set;}        
    public String ToCopyText{get;set;}      
               
    public String strStages{get;set;}       
    public String strPlanningStages{get;set;}      
    public String strSavedStages{get;set;}
    
    public String strFromPlanYear{get;set;}
    public String strToPlanYear{get;set;}
    public String strFromPlan{get;set;}
    public String strToPlan{get;set;}
    
   
    
     public String strFromClearPlanYear{get;set;}
    public String strFromClearPlan{get;set;}
    public String ProcessText{get;set;}
    
    public map<String,boolean> mapClosedPlanning{get;set;}
    
    
    
    public List<PlanningMeasure> lstMeasure{get;set;}
    
    public CopyPlanningVersionv1(NewPlanningVersionExtensionv4 controller) {
        Startup();
    }
    
    
    
    public void setEnablePlanning(){
        strPlanningStages = '';
        Set<String> setStages = new Set<String>();
        string P_strFromPlan = apexpages.currentPage().getParameters().get('P_strFromPlan');
        if(P_strFromPlan <> null && P_strFromPlan <> '')
        {
            P_strFromPlan = String.escapeSingleQuotes(P_strFromPlan);
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
         
       
            for(Planning_Model__c pm :  [select Planning_Measure__r.Name from Planning_Model__c where Planning_Version__c =: P_strFromPlan and Planning_Measure__c <> null]){
                strPlanningStages = strPlanningStages+','+pm.Planning_Measure__r.Name;
            }
          } 
        }
        
  
    }
    
    public string getp_t(){
        return ToCopyText;
    }
    public string getp_f(){
        return FromCopyText;
    }
        public pagereference setProcessContent(){       
                            
                    
        string p_t = apexpages.currentpage().getparameters().get('p_to');
        string p_f = apexpages.currentpage().getparameters().get('p_from'); 
            
            FromCopyText = (p_f <> null && p_f <> '')?mapFromFiscalYearMap.get(p_f):'None';  
            ToCopyText = (p_t <> null && p_t <> '')?mapToFiscalYearMap.get(p_t):'None';       
            

            return  null;       
        }
    public void Startup(){
           
        strStages = '';
        strPlanningStages = '';
        strSavedStages = '';
        clearPlanningMessage = 'none';
        
        mapClosedPlanning = new map<String,boolean>();
        clearMessagePopup = false;
        if ( Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() &&
            Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
         
        lstClosedPlanningVersion = [select id,Name,Planning_Version_Fiscal_Year__c,Is_this_a_Budget_Planning_Version__c,SequenceNo__c  
               from Planning_Version__c where Version_Status__c = 'Closed'];
        }
       if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() &&
            Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
                
        OpenAdminPlanningVersion = [select id,Name,Planning_Version_Fiscal_Year__c,Is_this_a_Budget_Planning_Version__c,SequenceNo__c 
               from Planning_Version__c where Version_Status__c = 'Open (Admin)'];
           } 
            
        lstMeasure = new List<PlanningMeasure>();
        
         if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() ){
            
             for(Planning_Financial_Measure__c fm : [select Id,Name from Planning_Financial_Measure__c where name <> null]){
	            strStages += fm.Name + ',';
	            lstMeasure.add( new PlanningMeasure(fm,false));
	        }
        }
    }
    
    public List<SelectOption> getFromPlanYear() {
        List<SelectOption> options = new List<SelectOption>();
        map<String,Integer> mapPlanningYear = new map<String,Integer>();
        
        
        
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            mapPlanningYear.put(cp.Planning_Version_Fiscal_Year__c,Integer.ValueOf(cp.Planning_Version_Fiscal_Year__c));
        }
        
        List<WPYearPlanningVersion> lstClosePlanning = new List<WPYearPlanningVersion>();
        for(String key : mapPlanningYear.keySet())  lstClosePlanning.add(new WPYearPlanningVersion(mapPlanningYear.get(key)));
        lstClosePlanning.sort();         
        
        options.add(new SelectOption('none','--None--'));
        strFromPlanYear = 'none';
        for(WPYearPlanningVersion wc : lstClosePlanning){
            options.add(new SelectOption(String.valueOf(wc.pYear),String.valueOf(wc.pYear)));
        }          
        
        return options;
    }
    public List<SelectOption> getToPlanYear() {
        
        List<SelectOption> options = new List<SelectOption>();
        map<String,Integer> mapPlanningYear = new map<String,Integer>();
        for(Planning_Version__c cp :  OpenAdminPlanningVersion)
            mapPlanningYear.put(cp.Planning_Version_Fiscal_Year__c,Integer.ValueOf(cp.Planning_Version_Fiscal_Year__c));
            
        List<WPYearPlanningVersion> lstNotOpenPlanning = new List<WPYearPlanningVersion>();
        for(String key : mapPlanningYear.keySet())  lstNotOpenPlanning.add(new WPYearPlanningVersion(mapPlanningYear.get(key)));
        lstNotOpenPlanning.sort();
        options.add(new SelectOption('none','--None--'));
        strToPlanYear = 'none';
        for(WPYearPlanningVersion wc : lstNotOpenPlanning){
            options.add(new SelectOption(String.valueOf(wc.pYear),String.valueOf(wc.pYear)));
        }    
            
        
        
        return options;
    }
    
    public List<SelectOption> getFromClearPlanYear() {
        strFromClearPlanYear = null;
        List<SelectOption> options = new List<SelectOption>();
        map<String,Integer> mapPlanningYear = new map<String,Integer>();
        
            for(Planning_Version__c cp :  lstClosedPlanningVersion){
            mapPlanningYear.put(cp.Planning_Version_Fiscal_Year__c,Integer.ValueOf(cp.Planning_Version_Fiscal_Year__c));
        }
        
        List<WPYearPlanningVersion> lstClosePlanning = new List<WPYearPlanningVersion>();
        for(String key : mapPlanningYear.keySet())  lstClosePlanning.add(new WPYearPlanningVersion(mapPlanningYear.get(key)));
        lstClosePlanning.sort();
        for(WPYearPlanningVersion wc : lstClosePlanning){
            if(strFromClearPlanYear == null)strFromClearPlanYear = String.valueOf(wc.pYear);
            options.add(new SelectOption(String.valueOf(wc.pYear),String.valueOf(wc.pYear)));
        }          
        
        return options;
    }
    public List<SelectOption> getFromClearPlan() {
        
        strFromClearPlan = null;
        
        List<SelectOption> options = new List<SelectOption>();
        List<WSeqPlanningVersion> lstwrapper = new List<WSeqPlanningVersion>();
        
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            if(strFromClearPlanYear <> null && strFromClearPlanYear.equals(cp.Planning_Version_Fiscal_Year__c)){
                lstwrapper.add(new WSeqPlanningVersion(cp));
            }
        }
        lstwrapper.sort();
        
        strFromClearPlan = 'none';
        //System.debug('-->>strFromClearPlan='+strFromClearPlan);
        options.add(new SelectOption('none','--None--'));
        for(WSeqPlanningVersion w : lstwrapper){
            Planning_Version__c cp = w.planningversion;
            options.add(new SelectOption(String.valueOf(cp.Id).escapehtml4(),cp.Name));
        }
        
        setDeletedModel();
        return options;
    }
     map<String,String> mapFromFiscalYearMap;
    public List<SelectOption> getFromPlan() {
        
        strFromPlan = null;
        mapFromFiscalYearMap = new map<String,String>();
        List<SelectOption> options = new List<SelectOption>();
        
        List<WSeqPlanningVersion> lstwrapper = new List<WSeqPlanningVersion>();
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            if(strFromPlanYear <> null && strFromPlanYear.equals(cp.Planning_Version_Fiscal_Year__c))
                lstwrapper.add(new WSeqPlanningVersion(cp));
        }
        lstwrapper.sort();
        
        options.add(new SelectOption('none','--None--'));
        strFromPlan = 'none';
        for(WSeqPlanningVersion w : lstwrapper){
            Planning_Version__c cp = w.planningversion;
            if(strFromPlan == null) strFromPlan = cp.Id+'';
            options.add(new SelectOption(string.valueOf(cp.Id),cp.Name));
            mapFromFiscalYearMap.put(cp.Id,cp.Name);
        }
        
                
        return options;
    }
    map<String,String> mapToFiscalYearMap;
    public List<SelectOption> getToPlan() {
    
        strFromPlan = null;
        mapToFiscalYearMap = new map<String,String>();
                
        List<SelectOption> options = new List<SelectOption>();
    
        List<WSeqPlanningVersion> lstwrapper = new List<WSeqPlanningVersion>();
        for(Planning_Version__c cp :  OpenAdminPlanningVersion){
            if(strToPlanYear <> null && strToPlanYear.equals(cp.Planning_Version_Fiscal_Year__c))
                lstwrapper.add(new WSeqPlanningVersion(cp));
        }
        lstwrapper.sort();
        
        options.add(new SelectOption('none','--None--'));       
        strToPlan = 'none';
        for(WSeqPlanningVersion w : lstwrapper){
            Planning_Version__c cp = w.planningversion;
            if(strToPlan == null) strToPlan = cp.Id+'';
            options.add(new SelectOption(cp.Id,cp.Name));
            mapToFiscalYearMap.put(cp.Id,cp.Name);
        }        
        
        
        return options;
    }
    
    public class WSeqPlanningVersion implements Comparable {

        public Planning_Version__c planningversion;
            
        // Constructor
        public WSeqPlanningVersion(Planning_Version__c planningversion) {
            this.planningversion = planningversion;
        }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {  WSeqPlanningVersion compareToPlan = (WSeqPlanningVersion)compareTo;    if (planningversion.SequenceNo__c == compareToPlan.planningversion.SequenceNo__c) return 0;    if (planningversion.SequenceNo__c > compareToPlan.planningversion.SequenceNo__c) return 1;return -1;     }
    }
    
    public class WPYearPlanningVersion implements Comparable {

        public Integer pYear;
            
        // Constructor
        public WPYearPlanningVersion(Integer pYear) {
            this.pYear = pYear;
        }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {WPYearPlanningVersion compareToPlan = (WPYearPlanningVersion)compareTo; if (pYear == compareToPlan.pYear) return 0;   if (pYear > compareToPlan.pYear) return 1;  return -1;  }
    }
    
    
    public class PlanningMeasure{
        public Planning_Financial_Measure__c Measure{get;set;}       
        public Boolean isCheck{get;set;}
        public PlanningMeasure(Planning_Financial_Measure__c Measure,Boolean isCheck){
            this.Measure = Measure;
            this.isCheck = isCheck;
            
        }
    }
    
    
    public pagereference CopyPlanningVersion(){
        
        
        
        
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            mapFromFiscalYearMap.put(cp.Id,cp.Name);
        }
        
        
                                    
        strToPlan = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('P_strToPlan'));
        strFromPlan = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('P_strFromPlan'));     
        strSavedStages = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('P_strSavedStages'));
        string test = '';
        List<Planning_Version__c> pverList;
        if (Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()){
         pverList= [SELECT Name FROM Planning_Version__c WHERE ID =: strToPlan];
        }
        String strToPlanName;
        if(pverList.size() > 0) {
        	strToPlanName = pverList[0].Name;
        }
        
        
        if(strToPlan == null || strFromPlan == null || strToPlan.equals('') || strFromPlan.equals('') )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select to planning version and from planning version.'));
            return null;
        }
        else if(strSavedStages == null || strSavedStages.equals('')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,strSavedStages+':Please select at least one planning measure'));
        }
        else{
            
        
            List<String> lstMeasure = new List<String>();
            for(String measure : strSavedStages.split(',')){
                if(measure <> '' && measure <> null)lstMeasure.add(measure);
            }
            
            
            
            if(lstMeasure.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,strSavedStages+':Please select at least one planning measure'));
                return null;
            }
        
            string query = 'select Id,ModelName__c,Amount__c,Comments__c,Business_Type__c,Planning_Measure__c,Planning_Measure__r.Name,Opportunity__c,Planning_Version__r.name,Planning_Version__c,Fiscal_Period__c,Fiscal_Period__r.Name from Planning_Model__c where ';
            string q;
            string test1 = mapFromFiscalYearMap+'';
            for(string s : lstMeasure){
                string fq = string.escapeSingleQuotes('%#'+mapFromFiscalYearMap.get(strFromPlan)+'#'+s);
                
                if(q == null)
                    q = 'ModelName__c like : fq';
                else 
                    q += ' or ModelName__c like :fq';
            }
            //system.debug('#QueryFrom:'+query+''+q);
            if (Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() &&
                Schema.sObjectType.Planning_Model__c.fields.Business_Type__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() &&
            	Schema.sObjectType.Planning_Version__c.fields.name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() &&
            	Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() ){
         
          
            List<Planning_Model__c> lstExPlModel = database.query(query+''+q);
           // system.debug('#lstExPlModel:'+lstExPlModel); 
            
            if(lstExPlModel.size() > 0 ){
                string Toquery = 'select Id,ModelName__c,Amount__c,Comments__c,Business_Type__c,Planning_Measure__c,Planning_Measure__r.Name,Opportunity__c,Planning_Version__r.name,Planning_Version__c,Fiscal_Period__c,Fiscal_Period__r.Name from Planning_Model__c where ';
                string Toq;
                for(string s : lstMeasure){
                    string fq = string.escapeSingleQuotes('%#'+mapToFiscalYearMap.get(strToPlan)+'#'+s);
                    if(Toq == null)
                        Toq = 'ModelName__c like :fq';
                    else 
                        Toq += ' or ModelName__c like :fq';
                }
                //system.debug('#QueryTo:'+Toquery+''+Toq);
                 if (Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() &&
                 	 Schema.sObjectType.Planning_Model__c.fields.Business_Type__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() &&
                 	 Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()){
                 	
                 
                List<Planning_Model__c> lstExToPlModel = database.query(Toquery+''+Toq);
               // system.debug('#lstExToPlModel:'+lstExToPlModel);
                 
                string stext = '';
                map<string,Planning_Model__c> mapExistingToModel = new map<string,Planning_Model__c>();
                for(Planning_Model__c m: lstExToPlModel){
                    mapExistingToModel.put(m.ModelName__c,m);
                }
                List<Planning_Model__c> lstNewPlanningModel = new List<Planning_Model__c>();
                for(Planning_Model__c m: lstExPlModel){
                    string MName = m.opportunity__c+'#'+m.Fiscal_Period__r.Name+'#'+ (strToPlanName == NULL ? mapToFiscalYearMap.get(strToPlan) : strToPlanName) +'#'+m.Planning_Measure__r.Name;
                    Planning_Model__c newplan;
                    if(mapExistingToModel.containsKey(MName)){
                        newplan = mapExistingToModel.get(MName);
                    }else{
                        newplan = new Planning_Model__c();                      
                    }
                    newplan.ModelName__c = MName;
                    newplan.Fiscal_Period__c = m.Fiscal_Period__c;
                    newplan.Amount__c = m.Amount__c;
                    newplan.Comments__c = m.Comments__c;
                    newplan.Business_Type__c = m.Business_Type__c;
                    newplan.Planning_Measure__c = m.Planning_Measure__c;
                    newplan.Opportunity__c = m.Opportunity__c;  
                    newplan.Planning_Version__c = strToPlan;
                                        
                    lstNewPlanningModel.add(newplan);
                    
                }
               if (Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Business_Type__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Business_Type__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isUpdateable()){  
                if(lstNewPlanningModel.size()>0){
                   
                     
                        upsert lstNewPlanningModel;                     
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,lstNewPlanningModel.size()+' records saved successfully'));
                }
                
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There is no record related to '+mapFromFiscalYearMap.get(strFromPlan)));
            }
                 	 }
      	}
                
      }    
     }
        
        
        return null;
    }
    
    public pagereference resetCopyPlanning(){
        return null;
    }
    public pagereference resetClearPlanning(){
        return null;
    }
    
    
    public pagereference deleteAllModel(){
    	//System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>Inside deleteAllModel');  
        lstClearPlanningModels.clear();
        List<Planning_Model__c> lstTemp = new List<Planning_Model__c>();
        if(strFromClearPlan <> null && strFromClearPlan <> 'none')
        {
            strFromClearPlan = String.escapeSingleQuotes(strFromClearPlan);
            //System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>strFromClearPlan=='+strFromClearPlan);  
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible()){
                lstTemp = [select Id from Planning_Model__c where Planning_Version__c <> null and Planning_Version__c =: strFromClearPlan];
               //  System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>lstTemp=='+lstTemp);   
            }
        }
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            
            if(strFromClearPlan <> null && strFromClearPlan.equals(cp.Id))
            {
                lstClearPlanningModels.addAll(lstTemp);
            }
            
        }
      // System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>lstClearPlanningModels=='+lstClearPlanningModels);  
        if(lstClearPlanningModels <> null && lstClearPlanningModels.size()>0)
        {
            if (Planning_Model__c.sObjectType.getDescribe().isDeletable()){
                delete lstClearPlanningModels;      
            }
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Planning Model deleted successfully!'));
            lstClearPlanningModels.clear();
            clearMessagePopup = false;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning,'There are no any records on planning model!'));
            clearMessagePopup = false;
        }
        
        return null;
    }
    
    public void setDeletedModel(){
        lstClearPlanningModels = new List<Planning_Model__c>();
        List<Planning_Model__c> lstTemp = new List<Planning_Model__c>();
        if(strFromClearPlan <> null)
        { 
            strFromClearPlan = String.escapeSingleQuotes(strFromClearPlan);
            //System.debug('-->>strFromClearPlan='+strFromClearPlan);
            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible()){
         // System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>strFromClearPlan=='+strFromClearPlan);  
          lstTemp = [select Id from Planning_Model__c where Planning_Version__c <> null and Planning_Version__c =: strFromClearPlan];
         // System.debug(Logginglevel.ERROR,'>>>>>>>>>>>>>>>>>>>>lstTemp=='+lstTemp);  
         }
            
        }
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            
            if(strFromClearPlan <> null && strFromClearPlan.equals(cp.Id))
            {
                lstClearPlanningModels.addAll(lstTemp);
                clearPlanningMessage = 'There are total number of record is '+lstClearPlanningModels.size()+'\n Do you want to delete all records.';
                clearMessagePopup = true;
            }
            
        }
        if(lstClearPlanningModels.size() == 0){
            clearMessagePopup = false;
        }
        
       // system.debug('#setDeletedModel:'+strFromClearPlan+'::'+lstClearPlanningModels+'::'+lstClosedPlanningVersion);
        
    }
    public pagereference verifyDeleteAllModel(){
        setDeletedModel();
        return null;
    }
    
}