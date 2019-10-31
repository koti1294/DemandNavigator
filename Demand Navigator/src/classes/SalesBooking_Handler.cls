public with sharing class SalesBooking_Handler{
    
    public Static Integer getDateId(Date dd){
        string cPeriod = (dd.Month()<10)? '0'+dd.Month():dd.Month()+'';
        string cDay = (dd.Day()<10)? '0'+dd.Day():dd.Day()+'';
        return Integer.ValueOf(dd.Year()+''+cPeriod+''+cDay);
    }
    public Static boolean IsExistDate(String mm, Date dd){
        Integer StartDate = Integer.valueOf(mm.split('-')[0]);
        Integer EndDate = Integer.valueOf(mm.split('-')[1]);
        Integer FDate = getDateId(dd);
        
        if(FDate >= StartDate && FDate <=EndDate)
            return true;
        else return false;
    }
    
    public Static Integer getFiscalYearId(Date dd,map<String,Integer> mapFiscalId){
        for(String key : mapFiscalId.keyset()){
            if(IsExistDate(key,dd)){
                return mapFiscalId.get(key);
            }
        }
        return 0;
    }
    public static string getPlanningVersion(Date dd,list<Planning_Version__c> lstPlanningversion ){
        for(Planning_Version__c p :lstPlanningversion){
            if(dd >= p.Data_Entry_Start_Date__c && dd <= p.Data_Entry_Closed_Date__c){
                return p.Id+'';
            }
        }
        return null;        
    }
    
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          lstPickvals.add(a.getValue());//add the value  to our final list
        }
    
        return lstPickvals;
    }
   
    

    
    public static void AddPlanningModel(List<Opportunity> lstopp){
        map<Integer,Fiscal_Year_Model__c> mapFiscalYear = new map<Integer,Fiscal_Year_Model__c>();
        map<String,Integer> mapFiscalId = new map<String,Integer>();
        map<string,boolean> mapConfigurationStages = new map<string,boolean>();
        for(string s : getPicklistValues('opportunity','stageName')){
            mapConfigurationStages.put(s,false);
        }
        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
	        for(Configuration_Setting__c  c : [select Id,Stage__c from Configuration_Setting__c limit 1]){
	            if(c.stage__c <> null && c.stage__c <> ''){
	                for(string s : c.stage__c.split(',')){
	                    mapConfigurationStages.put(s,true);
	                }
	            }           
	        }
        }
        map<Integer,List<Integer>> mapFYear;
        if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
        && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
        && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()  && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()){
	        for(Fiscal_Year_Model__c fy : [select Id,Name,Fiscal_Year__c,Start_Date__c,End_Date__c,Period_Number__c from Fiscal_Year_Model__c where name <> null]){
	            if(fy.Name <> null && fy.Period_Number__c <> null && fy.Fiscal_Year__c <> null ){
	                string cPeriod = (fy.Period_Number__c < 10)? '0'+fy.Period_Number__c:fy.Period_Number__c+'';
	                mapFiscalYear.put(Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod),fy);
	                mapFiscalId.put(getDateId(fy.Start_Date__c)+'-'+getDateId(fy.End_Date__c),Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod));
	            }
	        }
        }
        for(string mID : mapFiscalId.keyset()){
            //system.debug('#M#:'+mID+':::'+mapFiscalId.get(mID));
        }
        
        List<Planning_Model__c> lstModel = new List<Planning_Model__c>();
        map<String,Id> mapFMeasureId = new map<String,Id>();
         if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        for(Planning_Financial_Measure__c fm : [select id,Name from Planning_Financial_Measure__c where name = 'Revenue' or name = 'Revenue Backlog' or name = 'Sales Booking']){
	            mapFMeasureId.put(fm.Name,fm.Id);
	        }
         }
        map<Id,Planning_Version__c> mapPlanningversion = new map<Id,Planning_Version__c>([select Id,Name,Version_Status__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c from Planning_Version__c where Data_Entry_Start_Date__c <> null and Is_this_a_Budget_Planning_Version__c = true]);
        set<Id> setOppModelIds = new set<Id>();
       
        for(Opportunity opp : lstopp){
            setOppModelIds.add(opp.Id);
        }
        
        map<string,Planning_Model__c> mapModel = new map<string,Planning_Model__c>();
        
        
         if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()
         && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
         && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()
         && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()){
	        for(Planning_Model__c m : [select Id,Name,Amount__c,Planning_Version__c,Comments__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__c from Planning_Model__c where Opportunity__c IN: setOppModelIds]){
	            mapModel.put(m.Planning_Version__c+'-'+m.Fiscal_Period__c+'-'+m.Opportunity__c+'-'+m.Planning_Measure__c,m);
	        }
         }
        boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
        string DefaultCurrency = userinfo.getDefaultCurrency();
        map<Id,string> mapcurrency = new map<Id,string>();
        if(isMultiCurrencyOrganization){
            CurrencyConversion.Initialization();
            mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppModelIds);   
        }
        for(Opportunity opp : lstopp){
            
            if(mapConfigurationStages.containsKey(opp.StageName) && mapConfigurationStages.get(opp.StageName))
            {
                mapFYear = new map<Integer,List<Integer>>();
                Integer CloseIndex = getFiscalYearId(opp.CloseDate,mapFiscalId);
                
                
                Integer StartIndex = getFiscalYearId(mapPlanningversion.get(opp.Budget_Planning_Version__c).Data_Entry_Start_Date__c,mapFiscalId);//
                Integer EndIndex = getFiscalYearId(mapPlanningversion.get(opp.Budget_Planning_Version__c).Data_Entry_Closed_Date__c,mapFiscalId);//
                
                string ss = '';
                for(string s :mapFiscalId.keyset() ){
                    ss += s+':'+mapFiscalId.get(s)+', ';
                }
    
                //system.debug('#:#'+ss);
                if(StartIndex <> 0 && EndIndex <> 0){   
                string test=''; 
                for(Integer sI = StartIndex;sI<= EndIndex;sI++){
                    if(mapFiscalYear.Containskey(sI)){
                        Fiscal_Year_Model__c fy = mapFiscalYear.get(sI);  
                        String PlanningVersionId = opp.Budget_Planning_Version__c;
                        if(PlanningVersionId <> null ){
                        	if(Planning_Model__c.SObjectType.getDescribe().isCreateable() 
                             && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.modelname__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.modelname__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable()){
                             	
	                            Planning_Model__c newRplan = new Planning_Model__c();  if(isMultiCurrencyOrganization){newRplan.put('CurrencyISOCode', mapcurrency.get(opp.Id));}
	                            if(mapModel.containsKey(PlanningVersionId+'-'+fy.Id+'-'+opp.Id+'-'+mapFMeasureId.get('Revenue'))){ 
	                            newRplan = mapModel.get(PlanningVersionId+'-'+fy.Id+'-'+opp.Id+'-'+mapFMeasureId.get('Revenue')); }
	                            decimal AmountR = 0;if(opp.ExpectedRevenue <> null && opp.Deal_Duration__c <> null){
	                             AmountR = opp.ExpectedRevenue/opp.Deal_Duration__c;}
	                             newRplan.Amount__c = AmountR;newRplan.Planning_Version__c = PlanningVersionId;
	                             newRplan.ModelName__c = opp.Id+'#'+fy.Name +'#'+ mapPlanningversion.get(PlanningVersionId).Name +'#'+ 'Revenue';
	                             newRplan.Comments__c = 'Default Model:Revenue';newRplan.Fiscal_Period__c = fy.Id;
	                             newRplan.Planning_Measure__c = mapFMeasureId.get('Revenue');newRplan.Opportunity__c = opp.Id;lstModel.add(newRplan);
                             
                             if(Planning_Model__c.SObjectType.getDescribe().isCreateable() 
                             && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.modelname__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.modelname__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable()
                             && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable()){
                             Planning_Model__c newRBplan = new Planning_Model__c();
                             if(isMultiCurrencyOrganization){newRplan.put('CurrencyISOCode', mapcurrency.get(opp.Id));}
                             if(mapModel.containsKey(PlanningVersionId+'-'+fy.Id+'-'+opp.Id+'-'+mapFMeasureId.get('Sales Booking'))){
                             newRBplan = mapModel.get(PlanningVersionId+'-'+fy.Id+'-'+opp.Id+'-'+mapFMeasureId.get('Sales Booking'));}
                             decimal AmountB = 0;if(opp.ExpectedRevenue <> null && opp.Deal_Duration__c <> null){ 
                             AmountB = opp.ExpectedRevenue/opp.Deal_Duration__c;}
                             newRBplan.Amount__c = AmountB;newRBplan.Planning_Version__c = PlanningVersionId;
                             newRBplan.ModelName__c = opp.Id+'#'+fy.Name +'#'+ mapPlanningversion.get(PlanningVersionId).Name +'#'+ 'Sales Booking';
                             newRBplan.Comments__c = 'Default Model: Sales Booking';newRBplan.Fiscal_Period__c = fy.Id;
                             newRBplan.Planning_Measure__c = mapFMeasureId.get('Sales Booking');newRBplan.Opportunity__c = opp.Id;lstModel.add(newRBplan);}}}} 
                             }} 
            }
        }   

        
            //retrieve all deletable
            set<string> setWModel = new set<string>(); 
            for(Planning_Model__c pm: lstModel){
                if(pm.Id <> null){
                    setWModel.add(pm.Planning_Version__c+'-'+pm.Fiscal_Period__c+'-'+pm.Opportunity__c+'-'+pm.Planning_Measure__c);
                }
            }
            Set<Planning_Model__c> lstModelSet = new Set<Planning_Model__c>();
            lstModelSet.addAll(lstModel);
            lstModel.clear();
            lstModel.addAll(lstModelSet);
            
            if(lstModel.size()>0){
            	 if(Planning_Model__c.SObjectType.getDescribe().isCreateable() && Planning_Model__c.SObjectType.getDescribe().isUpdateable()) {
            		upsert lstModel;
            	 }
            }
            
            
            
        
    } 
}