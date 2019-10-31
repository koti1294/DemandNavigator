public with sharing class configurationSettingControllerV1 {

    map<string,List<string>> mapCategoryStages;
    public boolean isCustomFiscalYearEnable{get;set;}
    public List<WOpportunityFiscalYear> lstOppStatus{get;set;}
    public boolean isMissed{get;set;}
    public map<String,Org_Year>  mapOrgYear;        
    List<Org_Year>  lstFiscalYear;  
    List<Org_Period>  lstPlanninerVersion;  
    private string InstanceURL;public string getInstanceURL(){return InstanceURL;}public void setInstanceURL(string s){if(s<>null) InstanceURL = String.escapeSingleQuotes(s);}
            
    private string forecast_BacklogFiscaYear;public string getforecast_BacklogFiscaYear(){return forecast_BacklogFiscaYear;}public void setforecast_BacklogFiscaYear(string s){if(s<>null) forecast_BacklogFiscaYear = String.escapeSingleQuotes(s);}   
    private string forecast_OpportunityStages;public string getforecast_OpportunityStages(){return forecast_OpportunityStages;}public void setforecast_OpportunityStages(string s){if(s<>null) forecast_OpportunityStages = String.escapeSingleQuotes(s);}  
    //TM :
    //public string forecast_TerritoryModel{get;set;}     
            
    private string forecast_BudgetVersions;public string getforecast_BudgetVersions(){return forecast_BudgetVersions;}public void setforecast_BudgetVersions(string s){if(s<>null) forecast_BudgetVersions = String.escapeSingleQuotes(s);}   
    private string forecast_PlanningFiscalPeriods;public string getforecast_PlanningFiscalPeriods(){return forecast_PlanningFiscalPeriods;}public void setforecast_PlanningFiscalPeriods(string s){if(s<>null) forecast_PlanningFiscalPeriods = String.escapeSingleQuotes(s);}        
    private string forecast_PlanningVersions;public string getforecast_PlanningVersions(){return forecast_PlanningVersions;}public void setforecast_PlanningVersions(string s){if(s<>null) forecast_PlanningVersions = String.escapeSingleQuotes(s);}     
    private string forecast_PlanningMeasures;public string getforecast_PlanningMeasures(){return forecast_PlanningMeasures;}public void setforecast_PlanningMeasures(string s){if(s<>null) forecast_PlanningMeasures = String.escapeSingleQuotes(s);}
    
    private string forecast_M_BacklogFiscaYear;public string getforecast_M_BacklogFiscaYear(){return forecast_M_BacklogFiscaYear;}public void setforecast_M_BacklogFiscaYear(string s){if(s<>null) forecast_M_BacklogFiscaYear = String.escapeSingleQuotes(s);}
    private string forecast_M_OpportunityStages;public string getforecast_M_OpportunityStages(){return forecast_M_OpportunityStages;}public void setforecast_M_OpportunityStages(string s){if(s<>null) forecast_M_OpportunityStages = String.escapeSingleQuotes(s);}
    //TM :
    //public string forecast_M_TerritoryModel{get;set;}    
    private string forecast_M_BudgetVersions;public string getforecast_M_BudgetVersions(){return forecast_M_BudgetVersions;}public void setforecast_M_BudgetVersions(string s){if(s<>null) forecast_M_BudgetVersions = String.escapeSingleQuotes(s);}
    private string forecast_M_PlanningFiscalPeriods;public string getforecast_M_PlanningFiscalPeriods(){return forecast_M_PlanningFiscalPeriods;}public void setforecast_M_PlanningFiscalPeriods(string s){if(s<>null) forecast_M_PlanningFiscalPeriods = String.escapeSingleQuotes(s);}
    private string forecast_M_PlanningVersions;public string getforecast_M_PlanningVersions(){return forecast_M_PlanningVersions;}public void setforecast_M_PlanningVersions(string s){if(s<>null) forecast_M_PlanningVersions = String.escapeSingleQuotes(s);}
    private string forecast_M_PlanningMeasures;public string getforecast_M_PlanningMeasures(){return forecast_M_PlanningMeasures;}public void setforecast_M_PlanningMeasures(string s){if(s<>null) forecast_M_PlanningMeasures = String.escapeSingleQuotes(s);}
    private string forecast_M_Warning;public string getforecast_M_Warning(){return forecast_M_Warning;}public void setforecast_M_Warning(string s){if(s<>null) forecast_M_Warning = String.escapeSingleQuotes(s);}
     
     
    private string financelistview;public string getfinancelistview(){return financelistview;}public void setfinancelistview(string s){if(s<>null) financelistview = String.escapeSingleQuotes(s);}
    private string addplanningVersionlistview;public string getaddplanningVersionlistview(){return addplanningVersionlistview;}public void setaddplanningVersionlistview(string s){if(s<>null) addplanningVersionlistview = String.escapeSingleQuotes(s);}
    
    public List<Additional_Planning_Versions__c> lstAddPlanVersion{get;set;}
    public List<Planning_Financial_Measure__c> lstFinancialMeasure{get;set;}
    
    
    private string strStages;public string getstrStages(){return strStages;}public void setstrStages(string s){if(s<>null) strStages = String.escapeSingleQuotes(s);}
    private string strCategories;public string getstrCategories(){return strCategories;}public void setstrCategories(string s){if(s<>null) strCategories = String.escapeSingleQuotes(s);}
    private string strSavedStages;public string getstrSavedStages(){return strSavedStages;}public void setstrSavedStages(string s){if(s<>null) strSavedStages = String.escapeSingleQuotes(s);}
    private string strSavedCategories;public string getstrSavedCategories(){return strSavedCategories;}public void setstrSavedCategories(string s){if(s<>null) strSavedCategories = String.escapeSingleQuotes(s);}
    List<FiscalYearSettings> lstfiscalsetting;
    //TM :
    //public String TerritoryModel{get;set;}
    private string FiscalYear;public string getFiscalYear(){return FiscalYear;}public void setFiscalYear(string s){if(s<>null) FiscalYear = String.escapeSingleQuotes(s);}
    public Configuration_Setting__c configurationsetting{get;set;}
    public List<wrapperOpportunityStage> lstStage{get;set;}
    public List<wrapperOpportunityStage> lstCategory{get;set;}
    //TM :
    //List<Territory2Model> lstTerritoryModels;
    public List<String> lstFinancePickMeasure{get;set;}
    
    
    public pagereference RunReport(){
        lstOppStatus = new List<WOpportunityFiscalYear>();
        try{
            setOpportunityStatus();
            }catch(Exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,''+e));}
          
        return null;
    }
    private StandardFiscalYearDefaultSetting standardFYS;
    public configurationSettingControllerV1(){
        mapCategoryStages = new map<string,List<string>>();
        
        if (Schema.sObjectType.OpportunityStage.fields.Id.isAccessible() && Schema.sObjectType.OpportunityStage.fields.APiName.isAccessible() 
        && Schema.sObjectType.OpportunityStage.fields.defaultProbability.isAccessible() && Schema.sObjectType.OpportunityStage.fields.ForecastCategoryName.isAccessible() 
        && Schema.sObjectType.OpportunityStage.fields.IsActive.isAccessible() && Schema.sObjectType.OpportunityStage.fields.MasterLabel.isAccessible() 
        && Schema.sObjectType.OpportunityStage.fields.SortOrder.isAccessible() ){
         
        
        for(OpportunityStage stg : [select Id,APiName,defaultProbability,ForecastCategoryName,IsActive,MasterLabel,SortOrder from OpportunityStage where IsActive = true order by SortOrder]){
            List<String> lsttemp = new List<String>();
            lsttemp.add(stg.APiName.escapeHtml4());
            if(mapCategoryStages.containsKey(stg.ForecastCategoryName)){
                lsttemp.addAll(mapCategoryStages.get(stg.ForecastCategoryName.escapeHtml4()));
            }
            mapCategoryStages.put(stg.ForecastCategoryName.escapeHtml4(),lsttemp);
        }

        }
        
        standardFYS = new StandardFiscalYearDefaultSetting();
        isCustomFiscalYearEnable = false;
        
        
        
        lstOppStatus = new List<WOpportunityFiscalYear>();
        String pre = Planning_Financial_Measure__c.SObjectType.getDescribe().getKeyPrefix();
        
        financelistview = (URL.getSalesforceBaseUrl().toExternalForm()+'/'+pre+'/'+'o');
    
        
        String pre1 = String.escapeSingleQuotes('/'+Additional_Planning_Versions__c.SObjectType.getDescribe().getKeyPrefix()+'/'+'o');
        
        addplanningVersionlistview= (URL.getSalesforceBaseUrl().toExternalForm()+pre1);
        
        strStages = '';
        strCategories='';
        strSavedStages = '';
        strSavedCategories = '';
		if (Schema.sObjectType.FiscalYearSettings.fields.Description.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.IsStandardYear.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.PeriodLabelScheme.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.QuarterPrefix.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.WeekLabelScheme.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.WeekStartDay.isAccessible()
		&& Schema.sObjectType.FiscalYearSettings.fields.YearType.isAccessible()
		&& Schema.sObjectType.Period.fields.EndDate.isAccessible()
		&& Schema.sObjectType.Period.fields.FiscalYearSettingsId.isAccessible()
		&& Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible()
		&& Schema.sObjectType.Period.fields.Number.isAccessible()
		&& Schema.sObjectType.Period.fields.PeriodLabel.isAccessible()
		&& Schema.sObjectType.Period.fields.QuarterLabel.isAccessible()
		&& Schema.sObjectType.Period.fields.StartDate.isAccessible()
		&& Schema.sObjectType.Period.fields.Type.isAccessible()){
          
        
        lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods ),PeriodLabelScheme,
        PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
        WeekStartDay,YearType from FiscalYearSettings where name <> null  order by startdate limit 100 ];

        }
        if(lstfiscalsetting <> null && lstfiscalsetting.size() > 0){
            isCustomFiscalYearEnable = false;
        }
        List<Configuration_Setting__c> lstConSet = new List<Configuration_Setting__c>();
        if (Schema.sObjectType.Configuration_Setting__c.fields.id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Name.isAccessible()
        &&  Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.TerritoryModel__c.isAccessible()
        && Schema.sObjectType.Configuration_Setting__c.fields.Category__c.isAccessible() ){
          
       
        lstConSet = [select id,Name,Stage__c,TerritoryModel__c,Category__c from Configuration_Setting__c limit 1]; 

         }
if(lstConSet.size()>0){
            FiscalYear = lstConSet[0].Name;
            strSavedStages = lstConSet[0].Stage__c;
            strSavedCategories = lstConSet[0].Category__c;
            configurationsetting = lstConSet[0];
        }
        else{
            configurationsetting = new Configuration_Setting__c();
        }
        
        lstStage = new List<wrapperOpportunityStage>();
        lstCategory = new List<wrapperOpportunityStage>();
        setOpportunityStages();
        setOpportunityCategories();
        
        
           if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Id.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible() 
           && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isAccessible()  ){
        lstAddPlanVersion = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where Name <> null limit 200];
           }
        if(lstAddPlanVersion == null)
        lstAddPlanVersion = new List<Additional_Planning_Versions__c>();
        
	     if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
	     && Schema.sObjectType.Planning_Financial_Measure__c.fields.General_Ledger_Account__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible()
	     && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()){
	   		 lstFinancialMeasure = [select Id,Name,General_Ledger_Account__c,Measure_Description__c,Measure_Type__c from Planning_Financial_Measure__c where Name <> null limit 100];
	     }
        if(lstFinancialMeasure == null)
        lstFinancialMeasure = new List<Planning_Financial_Measure__c>();
        
        string namespace = NameSpaceUtil.getNameSpace('Planning_Financial_Measure__c');
        lstFinancePickMeasure = getPicklistValues(namespace +'Planning_Financial_Measure__c',namespace +'Measure_Type__c');
        
        lstPlanninerVersion = new List<Org_Period>();
        lstFiscalYear = new List<Org_Year>();
         
         
        if(isCustomFiscalYearEnable)getOrgFiscalSetting();
        else getOrgStandardFiscalSetting();

         setForcastData();
         RunReport();
    
    
    }
    
    
    private set<Integer> NewFiscalYears;
    public void setOpportunityStatus(){
         
        map<String,boolean> mapFiscalYear = new map<string,boolean>();
        Integer LastRevenueYear = 0;
        Integer StartRevenueYear = 0;
        if (Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()){
	        AggregateResult[] groupedResults  = [SELECT Min(Project_End_date__c)REMINDate,Max(Project_End_date__c)REMAXDate FROM Opportunity where Project_End_date__c <> null];
	        if(groupedResults <> null && groupedResults.size()>0 && groupedResults[0].get('REMINDate') <> null && groupedResults[0].get('REMAXDate') <> null){
	            StartRevenueYear = date.valueOf(groupedResults[0].get('REMINDate')).year();
	            LastRevenueYear = date.valueOf(groupedResults[0].get('REMAXDate')).year();
	        }
    	}
        isMissed = false;  
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){ 
	        for(Fiscal_Year_Planning__c ff : [select id,Name from Fiscal_Year_Planning__c where Name <> null]) 
	        {mapFiscalYear.put(ff.Name.escapeHtml4()+'',true);}
        }
        NewFiscalYears = new set<Integer>();
                if(StartRevenueYear <> 0 && LastRevenueYear <> 0){     for(Integer i=StartRevenueYear;i <= LastRevenueYear; i++){       if(!mapFiscalYear.containsKey(i+'')){ mapFiscalYear.put(i+'',false);       isMissed = true;   NewFiscalYears.add(i);
                                }
                        }
                }
     
        
        
    }
    
    public void setForcastData(){
        forecast_BacklogFiscaYear = 'Action Required';
        forecast_OpportunityStages = 'Action Required';
        //TM :
        //forecast_TerritoryModel = 'Action Required';
        
        forecast_BudgetVersions = 'Action Required';
        forecast_PlanningFiscalPeriods = 'Action Required';
        forecast_PlanningVersions = 'Action Required';
        forecast_PlanningMeasures = 'Action Required';
        
        
        forecast_M_BacklogFiscaYear = 'Set the Backlog Fiscal Year';
        forecast_M_OpportunityStages = 'Set the Backlog Opportunity Stages ';
        //TM :
        //forecast_M_TerritoryModel = 'Set the Territory Model';    
        forecast_M_BudgetVersions = 'Re-run the Installation Script';
        forecast_M_PlanningFiscalPeriods = 'Re-run the Installation Script';  
        forecast_M_PlanningVersions = 'Re-run the Installation Script';
        forecast_M_PlanningMeasures = 'Re-run the Installation Script';
        
        forecast_M_Warning = '';
       
        
        if(configurationsetting <> null && configurationsetting.Id <> null){       forecast_BacklogFiscaYear = 'Complete';      forecast_M_BacklogFiscaYear = '';        if(configurationsetting.Stage__c <> null && configurationsetting.Stage__c <> '')      {forecast_OpportunityStages = 'Complete';  forecast_M_OpportunityStages = '';}   
         
        }
        
        Set<String> setMeasure = new Set<String>();
        setMeasure.add('Revenue');
        setMeasure.add('Revenue Adjustment');
        setMeasure.add('Revenue Backlog');
        setMeasure.add('Sales Booking');
        setMeasure.add('Gap Mitgation');
         map<String,string> mapfm = new map<String,string>(); 
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        List<Planning_Financial_Measure__c> lstfm = [select Id,Name from Planning_Financial_Measure__c where Name IN: setMeasure and Name <> null];
	              
	        for(Planning_Financial_Measure__c fm : lstfm){
	           mapfm.put(fm.Name,fm.id);
	        }
        }
        if(mapfm.size() == 5){
            forecast_PlanningMeasures = 'Complete';
            forecast_M_PlanningMeasures = 'In order to get you started, we have created the following Planning Measures:<br<ul>';
            for(String s : mapfm.keySet())      
                    forecast_M_PlanningMeasures += '<li><a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapfm.get(s)+'">'+s+'</a></li>';     
                forecast_M_PlanningMeasures += '</ul>';
        }
        
        Set<String> setAddPlan= new Set<String>();
        setAddPlan.add('Budget01');
        setAddPlan.add('Budget02');
        setAddPlan.add('Budget03');
        
        map<String,Id> mapap = new map<String,Id>();
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Id.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible()){ 
	        List<Additional_Planning_Versions__c> lstap = [select Id,Name from Additional_Planning_Versions__c where Name IN: setAddPlan and name <> null];
	        for(Additional_Planning_Versions__c ap : lstap){
	           mapap.put(ap.Name.escapeHtml4(),String.valueOf(ap.Id).escapeHtml4());
	        } 
        }     
        if(mapap.size() == 3){
            forecast_BudgetVersions = 'Complete';
            forecast_M_BudgetVersions = 'We have setup three budget related versions that will be created automatically for your convenience each time you create a new Fiscal Year:<br<ul>';
            for(String s: mapap.keySet()) {    
                    forecast_M_BudgetVersions += '<li><a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapap.get(s)+'">'+s+'</a></li>';       
            }
            forecast_M_BudgetVersions += '</ul>';
        
        }
        
        
        
        Set<String> set1PlanningVersion = new Set<String>();
        Set<String> SetYears = new Set<String>();
        Set<String> SetPeriods = new Set<String>();
        Set<Decimal> SetDPeriods = new Set<Decimal>();
        for(Org_Period p: lstPlanninerVersion){
            set1PlanningVersion.add(p.ent_Planning_Version_Fiscal_Year_c+'-'+String.escapeSingleQuotes(p.ent_Planning_Version_Current_Period_c));      
            SetYears.add(String.escapeSingleQuotes(p.ent_Planning_Version_Fiscal_Year_c+''));
            SetPeriods.add(String.escapeSingleQuotes(String.valueOf(p.ent_Planning_Version_Current_Period_c.escapeHtml4())));
            SetDPeriods.add(Decimal.valueOf(p.ent_Planning_Version_Current_Period_c));           
        }
        
        Set<String> set2PlanningVersion = new Set<String>(); 
        for(Fiscal_Year_Model__c v : [select Id,Fiscal_Year__c,Period_Number__c from Fiscal_Year_Model__c where Name <> null and Fiscal_Year__c IN: SetYears and Period_Number__c IN: SetDPeriods]){
            set2PlanningVersion.add(String.escapeSingleQuotes(v.Fiscal_Year__c+'-'+v.Period_Number__c));
        }
        if(set1PlanningVersion.size() > 0 && set1PlanningVersion.size() == set2PlanningVersion.size()){
            forecast_PlanningFiscalPeriods = 'Complete';
            forecast_M_PlanningFiscalPeriods = 'Based on your Company Profile Fiscal Year Settings, we have created a list of <strong>'+set2PlanningVersion.size()+'</strong> corresponding Fiscal Year Periods to be used in your Planning. Whenever you define a new Fiscal Year, the corresponding Planning Fiscal Periods will be created.';
        }
        
        //Planning Version
        set2PlanningVersion.clear();
        for(Planning_Version__c v : [select Id,Planning_Version_Fiscal_Year__c,Planning_Version_Current_Period__c from Planning_Version__c where Planning_Version_Fiscal_Year__c <> null and  Planning_Version_Fiscal_Year__c IN: SetYears and Planning_Version_Current_Period__c IN: SetPeriods]){
            set2PlanningVersion.add(v.Planning_Version_Fiscal_Year__c.escapeHtml4()+'-'+v.Planning_Version_Current_Period__c.escapeHtml4());
        }
        
        setAddPlan.clear();
        
        for(Org_Year y : lstFiscalYear){
        	//System.debug('lstFiscalYear Budget>>>>>>>>>>>>>>>>>>>>>>'+y.Name);
            setAddPlan.add(y.Name+'-Budget01');
            setAddPlan.add(y.Name+'-Budget02');
            setAddPlan.add(y.Name+'-Budget03');     
        }
        
        Set<String> setAdditionalPlan = new Set<String>();
        for(Planning_Version__c p : [select Id,Name from Planning_Version__c where Name IN: setAddPlan and Is_this_a_Budget_Planning_Version__c = true]){
            setAdditionalPlan.add(p.Name.escapeHtml4());
        }
        
        boolean flag1 = false;
        boolean flag2 = false;
         Integer Count = setAdditionalPlan.size() + set1PlanningVersion.size();
        if(setAddPlan.size() > 0 && setAdditionalPlan.size() == setAddPlan.size())flag1 = true;
        if(set1PlanningVersion.size() > 0 && set1PlanningVersion.size() == set2PlanningVersion.size())flag2 = true;
        forecast_M_PlanningVersions =setAddPlan.size()+'--'+setAdditionalPlan.size()+'-'+setAddPlan.size();
        if(flag1 && flag2){
            forecast_PlanningVersions = 'Complete';     
            forecast_M_PlanningVersions = 'We have created a list of  <strong>'+Count+'</strong> Planning Versions for your organization based on your Company Fiscal Year settings';
        }
       
        if(     
            forecast_BacklogFiscaYear == 'Action Required' || forecast_OpportunityStages == 'Action Required' ||         
            forecast_BudgetVersions == 'Action Required' || forecast_PlanningFiscalPeriods == 'Action Required' || forecast_PlanningVersions == 'Action Required' ||        
            forecast_PlanningMeasures == 'Action Required'){        
                forecast_M_Warning = ' <div class="alert alert-danger" role="alert"><span><apex:image alt="eye" title="eye" url="{!URLFOR($Resource.iconic, \'open-iconic-master/png/warning-2x.png\')}"/></span> <strong>Warning</strong> <p class="body"> You need to perform some additional configuration in order for you to use the app. Please consult the documentation that we have provided you in order to complete the setup before starting to use it for your planning purposes.</p></div>'; 
            }
    }
    
    
    
    
    public void setOpportunityCategories() {
        for(String  s: mapCategoryStages.keyset()){
            strCategories += s + ',';
            string stages = '';
            for(String  stg: mapCategoryStages.get(s)){stages += stg + ',';}
            if(configurationsetting <> null && configurationsetting.Category__c <> null && configurationsetting.Category__c.contains(s))
                lstCategory.add(new wrapperOpportunityStage(stages.escapeHtml4(),true,s));
            else
                lstCategory.add(new wrapperOpportunityStage(stages.escapeHtml4(),false,s));
        }
    }
    public void setOpportunityStages() {
        for(String  fc: mapCategoryStages.keyset()){
            for(String  s: mapCategoryStages.get(fc)){
                strStages += s.escapeHtml4() + ',';
                if(configurationsetting <> null && configurationsetting.Stage__c <> null && configurationsetting.Stage__c.contains(s))
                    lstStage.add(new wrapperOpportunityStage(s.escapeHtml4(),true,fc));
                else
                    lstStage.add(new wrapperOpportunityStage(s.escapeHtml4(),false,fc));
            }
        }
    }
    
    public String getAllSelectedStage(){
        String Stage = '';
        for(wrapperOpportunityStage w : lstStage){
            if(w.isCheck){
                if(!Stage.equals('')){
                    Stage += ',';
                }
                Stage += w.StageName.escapeHtml4();
            }
        }
        return Stage;
    }
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name.escapeHtml4());//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name.escapeHtml4()).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          lstPickvals.add(a.getValue());//add the value  to our final list
        }
    
        return lstPickvals;
    }
     public List<SelectOption> getFYears() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));

        if(isCustomFiscalYearEnable){
            for(FiscalYearSettings  f: lstfiscalsetting){
            	//System.debug('#>>>>>>>>>>>>>>>FiscalYearSettings==='+f);
                options.add(new SelectOption(f.Name.escapeHtml4(),f.Name.escapeHtml4()));
            }
        }else {
            for(Org_Year  f: lstFiscalYear){
            	//System.debug('#>>>>>>>>>>>>>>>FiscalYearSettings===+++++======'+f);
                options.add(new SelectOption(f.Name+'',f.Name+''));
            }

        }
        
        return options;
    }
    //TM :

    
    public pagereference ResetFiscalYears(){ 
        if( configurationsetting <> null && configurationsetting.Name <> null)
        FiscalYear = configurationsetting.Name.escapeHtml4();
        return null;
    }
    //TM :
 
    public pagereference saveconfigurationSetting(){   
        if(FiscalYear == '--None--'){

            if(configurationsetting <> null )
            if (Configuration_Setting__c.sObjectType.getDescribe().isDeletable()){
            delete configurationsetting;
            }
        }
        else{
        	if (Schema.sObjectType.Configuration_Setting__c.fields.Name.isUpdateable()
        	&& Schema.sObjectType.Configuration_Setting__c.fields.Name.isCreateable()) {
	            configurationsetting.Name = FiscalYear;         
	            upsert configurationsetting;
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Saved Fiscal Year Successfully'));
        	}
                       
        }
        
        return null;
    }
    
    public pagereference saveOppStage(){   
    
    
        if(configurationsetting <> null && configurationsetting.Id <> null
        	&& Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isUpdateable()
        	&& Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isCreateable()
        	&& Schema.sObjectType.Configuration_Setting__c.fields.Category__c.isUpdateable()
        	&& Schema.sObjectType.Configuration_Setting__c.fields.Category__c.isCreateable()){
            //system.debug('#c1:'+strStages);
            configurationsetting.Stage__c = strStages; 
            configurationsetting.Category__c = strCategories;
            upsert configurationsetting;        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Saved Opportunity Stage Successfully'));
                  
            
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please set configuration planning year first then stages.'));
        }
        return null;
    }
    
    
     
    //TM :

    
    public pagereference SaveNewFiscalYears(){
        Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
        if(!isCustomFiscalYearEnable && org <> null && org.FiscalYearStartMonth <> null){

            Map<Integer,String> mapMonthString = new Map<Integer,String>();
            
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
            
            map<Integer,Integer> mapQ = new map<Integer,Integer>();
            mapQ.put(1,1);
            mapQ.put(2,1);
            mapQ.put(3,1);
            mapQ.put(4,2);
            mapQ.put(5,2);
            mapQ.put(6,2);
            mapQ.put(7,3);
            mapQ.put(8,3);
            mapQ.put(9,3);
            mapQ.put(10,4);
            mapQ.put(11,4);
            mapQ.put(12,4);
            
            List<Fiscal_Year_Planning__c> lstOrgFiscalYears = new List<Fiscal_Year_Planning__c>();
            set<string> setNFNames = new set<string> ();
                        
            for(Integer cyear : NewFiscalYears){setNFNames.add(cyear+'');date startDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);date endDate = startDate.addyears(1).addDays(-1);Fiscal_Year_Planning__c  pv = new Fiscal_Year_Planning__c(name = cyear+'',StartDate__c = startDate,EndDate__c = EndDate,Record_Source__c = 'Installation');             lstOrgFiscalYears.add(pv);
            }
            if(lstOrgFiscalYears.size()>0){
			if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isUpdateable() 
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isCreateable()
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isUpdateable() 
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isUpdateable() 
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isUpdateable() 
			&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isCreateable()) {	
			upsert lstOrgFiscalYears;
			}

			List<Fiscal_Year_Planning__c> lstFYSR = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where name IN: setNFNames];
			//System.debug('>>>> Fiscal_Year_Model__c lstFYSR+=='+lstFYSR.Size()+'+++lstFYSR>>>>>>>'+lstFYSR);
			List<Fiscal_Year_Model__c> lstFYChilds = new List<Fiscal_Year_Model__c>(); for(Fiscal_Year_Planning__c Efy : lstFYSR ){
				//System.debug('Fiscal_Year_Model__c>>>>>>>>>>Fiscal_Year_Planning__c'+Efy);
				 date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+Efy.Name.escapeHtml4()); for(Integer i = 1;i<13;i++){  lstFYChilds.add(     new Fiscal_Year_Model__c( Name = 'FY'+Efy.Name+'P'+i,                  Fiscal_Period_Id__c = 'P-'+i, End_Date__c = pstartDate.addMonths(1).addDays(-1),                            Start_Date__c  = pstartDate, Fiscal_Year__c = Efy.Name,  Fiscal_Quarter__c = 'Q'+mapQ.get(i),    Period_Name__c=  mapMonthString.get(pstartDate.month()),Period_Number__c =  i, Record_Source__c = 'Installation' )); pstartDate = pstartDate.addMonths(1); }} if(lstFYChilds.size() > 0){
			if(Fiscal_Year_Model__c.SObjectType.getDescribe().isCreateable() && Fiscal_Year_Model__c.SObjectType.getDescribe().isUpdateable()) {
			upsert lstFYChilds;
			}			}
                
                //12+budget versions for year
                List<Planning_Version__c> lstFYVersionChilds = new List<Planning_Version__c>();Integer seq = 1;
                //System.debug('>>>> Fiscal_Year_Planning__c lstFYSR+=='+lstFYSR.Size()+'+++lstFYSR>>>>>>>'+lstFYSR);
                for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                	//System.debug('Planning_Version__c>>>>>>>>>>Fiscal_Year_Planning__c'+Efy);
                    date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+Efy.Name.escapeHtml4());         for(Integer i = 1;i<13;i++){         lstFYVersionChilds.add(    new Planning_Version__c( Fiscal_Year_Planning__c = String.valueOf(Efy.Id).escapeHtml4(),      MonthName__c = mapMonthString.get(pstartDate.month()),
                            Name = Efy.Name.escapeHtml4()+'-'+mapMonthString.get(pstartDate.month()),                     Is_this_a_Budget_Planning_Version__c     = false,
                            SequenceNo__c =  seq++,                         Data_Entry_Closed_Date__c= pstartDate.addMonths(1).addDays(-1),                          Data_Entry_Start_Date__c  = pstartDate,                         Version_Status__c= 'Not Open',
                            Planning_Version_Fiscal_Year__c = Efy.Name.escapeHtml4(),               Planning_Version_Current_Period__c= pstartDate.month()+'',                          Record_Source__c = 'Installation'        ));
                        pstartDate = pstartDate.addMonths(1);                           
                    }
                } 
                
              
                if(lstFYVersionChilds.size() > 0 ){
					if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
                    upsert lstFYVersionChilds;
					}
                }
                
                //budget versions for year
                Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();
    
                AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c  = true Group By Planning_Version_Fiscal_Year__c];
                        
                for (AggregateResult ar : lstSeqNo)  {
                  mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
                }
                
                List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
                List<Additional_Planning_Versions__c> lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where name <> null];
                for(Fiscal_Year_Planning__c fiscal :  lstFYSR ){
                  seq = 99;
                  if(mapYearMaxSeq.ContainsKey(fiscal.Name))
                    seq = mapYearMaxSeq.get(fiscal.Name);
                  for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){
                    lstPlanningversion.add(
                      new Planning_Version__c(
                        Fiscal_Year_Planning__c = String.valueOf(fiscal.Id).escapeHtml4(),
                        Name = fiscal.Name+'-'+ap.Name.escapeHtml4(),
                        Additional_Planning_Version__c = String.valueOf(ap.Id).escapeHtml4(),
                        Is_this_a_Budget_Planning_Version__c     = true,
                        SequenceNo__c = ++seq,
                        Data_Entry_Closed_Date__c= fiscal.EndDate__c,
                        Data_Entry_Start_Date__c  = fiscal.StartDate__c,
                        Version_Status__c= 'Not Open',
                        Planning_Version_Fiscal_Year__c = fiscal.Name.escapeHtml4(),
                        Planning_Version_Current_Period__c= '',
                        MonthName__c =ap.Name.escapeHtml4(),
                        Planning_Version_Description__c = ap.Version_Description__c
                      )        
                    );
                  }
                }
                  
                if(lstPlanningversion.size()>0){

                        if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
                            upsert lstPlanningversion;  
						}							
                        
                }
    
            }
        }
        
        return  null;
    }
    public pagereference redirectToFinancialMeasure(){   
    
        String pre = Planning_Financial_Measure__c.SObjectType.getDescribe().getKeyPrefix();
        
        Pagereference page = new pagereference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+pre+'/'+'o');
        
        page.setRedirect(true);
        return page;
    }
    public pagereference redirectToAddPlan(){   

        String pre = Additional_Planning_Versions__c.SObjectType.getDescribe().getKeyPrefix();
        
        Pagereference page = new pagereference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+pre+'/'+'o');
        
        page.setRedirect(true);
        return page;
    }
    
    public pagereference resetStages(){
        strSavedStages = configurationsetting.Stage__c.escapeHtml4();
        strSavedCategories = configurationsetting.Category__c;
        return null;
    }    
    
    public pagereference addAdditionalPlanningVersion(){
        try{
            if(isCustomFiscalYearEnable){
                standardFYS.putAdditionalPlanningVersion();
            }else{
                FiscalYearDefaultSetting.putAdditionalPlanningVersion();
            }
            
        }
        Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,e + ''));
        }
        return null;
    }
    public pagereference addFinancialMeasure(){
        try{
            if(isCustomFiscalYearEnable){
                standardFYS.putFinancialMeasure();
            }else{
                FiscalYearDefaultSetting.putFinancialMeasure();
            }
            
        }
        Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,e + ''));
        }
        return null;
    }
    
    public pagereference addPlanning12Version(){
        try{
            
            if(isCustomFiscalYearEnable){
                standardFYS.putFiscalYearCustom();
            }else{
                FiscalYearDefaultSetting.putFiscalYearCustom();
            }
        }
        Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,e + ''));
        }
        return null;
    }
    
    public pagereference addPlanning15Version(){
        try{
            if(isCustomFiscalYearEnable){
                standardFYS.putFiscalYearPlanningVersion();
                standardFYS.putAdditionalPlanningVersion();
            }else{
                FiscalYearDefaultSetting.putFiscalYearPlanningVersion();
                FiscalYearDefaultSetting.putAdditionalPlanningVersion();
            }
            
            
        }
        Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,e + ''));
        }
        return null;
    } 
    
     public class wrapperOpportunityStage{
        public String StageName{get;set;}
        public String CategoryName{get;set;}
        public Boolean isCheck{get;set;}
        public wrapperOpportunityStage(String StageName,Boolean isCheck,String CategoryName){
            this.StageName = StageName;
            this.isCheck = isCheck;
            this.CategoryName = CategoryName;
            
        }
    }
    
    
    public void getOrgFiscalSetting(){           
        List<FiscalYearSettings> lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select Id,EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods order by startdate ),PeriodLabelScheme,
        PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
        WeekStartDay,YearType from FiscalYearSettings where name <> null  order by Name limit 200 ];
            
            
        Map<Integer,String> mapMonthString = new Map<Integer,String>();
            
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
            
        
        mapOrgYear = new map<String,Org_Year>();
        
        Integer Id = 1;
        for(FiscalYearSettings fiscal : lstfiscalsetting ){
        	//System.debug('fiscal>>>>>>>>>>>>>>>>>>>>>>===='+fiscal);
        	lstFiscalYear.add(new Org_Year('FY-'+(Id++),Integer.valueOf(fiscal.Name.escapeHtml4()),fiscal.startDate,fiscal.EndDate));
        }
        
        
        for(Org_Year fy:lstFiscalYear){
        	//System.debug('lstFiscalYear>>>>>>>>>>>>>>>====='+lstFiscalYear);
            mapOrgYear.put(fy.name+'',fy);            
        }
        
        Integer index = 0;
        for(FiscalYearSettings fiscal : lstfiscalsetting ){
        	//System.debug('+++++++++++FiscalYearSettings>>>>>>>>>>>>>>>====='+fiscal);
        	Integer fyear = (fiscal.EndDate).Year();
        	string  Prefix = String.escapeSingleQuotes(fiscal.PeriodPrefix);
        	string MonthName;
        	for(Org_Period p: createFiscalPeriods(fiscal,index)){
        		index++;
        		if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){ 
        			//System.debug('+++++++++++mapMonthString>>>>>>>>>>>>>>>====='+mapMonthString);
        			if(mapMonthString.containsKey(Integer.valueOf(p.ent_Planning_Version_Current_Period_c.escapeHtml4()))) 
        			MonthName  = mapMonthString.get(Integer.valueOf(p.ent_Planning_Version_Current_Period_c));     
        		}    else if((fiscal.PeriodLabelScheme).equals('Custom')){
        			MonthName  = String.escapeSingleQuotes(p.ent_MonthName_c.escapeHtml4());   
        		}  else{    
        			MonthName  = Prefix+'-'+p.ent_Planning_Version_Current_Period_c;        
        		}
        		p.ent_MonthName_c = String.escapeSingleQuotes(MonthName);
        		p.Name = p.ent_Planning_Version_Fiscal_Year_c+'-'+String.escapeSingleQuotes(MonthName);  
        		//System.debug('+++++++++++p>>>>>>>>>>>>>>>====='+p);
        		lstPlanninerVersion.add(p);
        	}

        }
    
    }
        
        
    public class Org_Year{
        String Id;
        Integer Name;
        Date StartDate_c;
        Date EndDate_c;
        public Org_Year(String Id,Integer Name,Date StartDate_c,Date EndDate_c){
            this.Id = Id.escapeHtml4();
            this.Name = Name;
            this.StartDate_c = StartDate_c;
            this.EndDate_c = EndDate_c;
        }
    }
    
    
    public class Org_Period implements Comparable{
        Integer Index;
        String Id;
        String Name;
        String Org_Year;
        Integer ent_SequenceNo_c;
        Date ent_Data_Entry_Closed_Date_c;
        Date ent_Data_Entry_Start_Date_c;
        Integer ent_Planning_Version_Fiscal_Year_c;
        String ent_Planning_Version_Current_Period_c;
        String ent_MonthName_c;
        public Org_Period(Integer Index,String Id,String Org_Year,Integer ent_SequenceNo_c,Date ent_Data_Entry_Closed_Date_c,Date ent_Data_Entry_Start_Date_c,Integer ent_Planning_Version_Fiscal_Year_c,String ent_Planning_Version_Current_Period_c,String ent_MonthName_c){
            this.Index = Index;
            this.Id = Id.escapeHtml4();
            this.Org_Year = Org_Year;
            this.ent_SequenceNo_c = ent_SequenceNo_c;
            this.ent_Data_Entry_Closed_Date_c = ent_Data_Entry_Closed_Date_c;
            this.ent_Data_Entry_Start_Date_c = ent_Data_Entry_Start_Date_c;
            this.ent_Planning_Version_Fiscal_Year_c = ent_Planning_Version_Fiscal_Year_c;
            this.ent_Planning_Version_Current_Period_c = ent_Planning_Version_Current_Period_c.escapeHtml4();
            this.ent_MonthName_c = String.escapeSingleQuotes(ent_MonthName_c);
            
        }
        
        public Integer compareTo(Object compareTo) {
            Org_Period compareToPlan = (Org_Period)compareTo;
            if (ent_SequenceNo_c == compareToPlan.ent_SequenceNo_c) return 0;
            if (ent_SequenceNo_c > compareToPlan.ent_SequenceNo_c) return 1;
            return -1;        
        }
    }
    
    public List<Org_Period> createFiscalPeriods(FiscalYearSettings fiscal,Integer index){
    	Integer fyear = (fiscal.EndDate).Year();
    	List<Org_Period> lstPeriods = new List<Org_Period>();
    	Integer count = fiscal.startDate.Month();
    	Integer seq = 1;
    	if((fiscal.PeriodLabelScheme).equals('Custom')){
    		for(Period p : fiscal.periods){
    			if((p.Type).equals('Month')) {
    				lstPeriods.add( new Org_Period((index++),String.escapeSingleQuotes(p.Id),String.escapeSingleQuotes(mapOrgYear.get(fyear+'').Id),(seq++),p.EndDate,p.StartDate,fyear,(count++)+'',String.escapeSingleQuotes(p.PeriodLabel)));
    				if(count == 13)count =1;
    			}
    		}
    	}else{
    		for(Period p : fiscal.periods){
    			if((p.Type).equals('Month')) {
    				lstPeriods.add(new Org_Period(
        (index++),String.escapeSingleQuotes(p.Id),String.escapeSingleQuotes(mapOrgYear.get(fyear+'').Id),(seq++),p.EndDate,p.StartDate,fyear,String.escapeSingleQuotes(p.Number+''),''      ));
        		}
    		}
    	}
    	return lstPeriods;
    }        
        
    
    public class WOpportunityFiscalYear{
        public opportunity opp{get;set;}
        public boolean isChecked{get;set;}
        public String userMessage{get;
         set{ 
         userMessage = String.escapeSingleQuotes(userMessage);
            }
        }
            
        public WOpportunityFiscalYear(opportunity opp, boolean isChecked,String userMessage){
            this.opp = opp;
            this.ischecked = ischecked;
            this.userMessage = userMessage;
        }
        
    }
public class S_FiscalYearSettings{
          public string Name;
          public Date startDate;
          public Date endDate;    
          public string PeriodLabelScheme;
          public string PeriodPrefix;
          public list<S_Period> Periods;
        }
        public class S_Period{
              public string PID;
              public string Type;
              public Date startDate;
              public Date endDate;    
              public Integer MPNumber;
              public string PeriodLabel;
        }
    public void getOrgStandardFiscalSetting(){           
       
        
        Map<Integer,String> mapMonthString = new Map<Integer,String>();
        
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
        
                        List<Fiscal_Year_Planning__c> lstFYSR = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where Name <> null order by StartDate__c];
                        set<string> setFYNames = new set<string>();
                        map<string,List<Fiscal_Year_Model__c>> mapExistingFY = new map<string,List<Fiscal_Year_Model__c>>();
                        for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                            setFYNames.add(String.escapeSingleQuotes(Efy.Name));
                            mapExistingFY.put(String.escapeSingleQuotes(Efy.Name),new List<Fiscal_Year_Model__c>());
                        }
                        
                        for(Fiscal_Year_Model__c pp : [select Id,Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c,Record_Source__c from Fiscal_Year_Model__c where Fiscal_Year__c <> null and Fiscal_Year__c IN: setFYNames]){
                            List<Fiscal_Year_Model__c> temp = mapExistingFY.get(pp.Fiscal_Year__c);
                            temp.add(pp);
                            mapExistingFY.put(pp.Fiscal_Year__c,temp);
                        }
                       
                        List<S_FiscalYearSettings> lstfiscalsettingORG = new List<S_FiscalYearSettings>();
                        for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                        
                            List<S_Period> lstP = new List<S_Period>();
                            
                            for(Fiscal_Year_Model__c mm : mapExistingFY.get(Efy.Name)){ S_Period pp = new S_Period(); pp.PID = mm.Id; pp.Type ='Month';     pp.startDate = mm.Start_Date__c;        pp.endDate = mm.End_Date__c;      pp.MPNumber = Integer.valueOf(mm.Period_Number__c);        pp.PeriodLabel = mm.Period_Name__c;           lstP.add(pp);           }          
                            S_FiscalYearSettings sfiscal = new S_FiscalYearSettings();
                            sfiscal.Name = Efy.Name.escapeHtml4();
                            sfiscal.startDate = Efy.StartDate__c;
                            sfiscal.endDate =  Efy.EndDate__c;
                            sfiscal.PeriodPrefix =  'P';
                            sfiscal.PeriodLabelScheme = 'StandardMonths';
                            sfiscal.Periods = lstP;
                            lstfiscalsettingORG.add(sfiscal);
                            
                        }



       
        mapOrgYear = new map<String,Org_Year>();
        
        Integer Id = 1;
        for(S_FiscalYearSettings fiscal : lstfiscalsettingORG ){
            lstFiscalYear.add(new Org_Year('FY-'+(Id++),Integer.valueOf(fiscal.Name),fiscal.startDate,fiscal.EndDate));
        }
        
        
        for(Org_Year fy:lstFiscalYear){
            mapOrgYear.put(fy.name+'',fy);            
        }
        
        Integer index = 0;
        for(S_FiscalYearSettings fiscal : lstfiscalsettingORG ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Org_Period p: createStandardFiscalPeriods(fiscal,index)){
            
                index++;
                if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                    if(mapMonthString.containsKey(Integer.valueOf(p.ent_Planning_Version_Current_Period_c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.ent_Planning_Version_Current_Period_c));                            
                }
                else if((fiscal.PeriodLabelScheme).equals('Custom')){
                   MonthName  = p.ent_MonthName_c.escapeHtml4();
                   
                }
                else{
                   MonthName  = Prefix+'-'+p.ent_Planning_Version_Current_Period_c.escapeHtml4();                      
                }                    
                p.ent_MonthName_c = MonthName.escapeHtml4(); 
                p.Name = p.ent_Planning_Version_Fiscal_Year_c+'-'+MonthName.escapeHtml4();
                lstPlanninerVersion.add(p);
             }

        }
    }

public List<Org_Period> createStandardFiscalPeriods(S_FiscalYearSettings fiscal,Integer index){
            
        Integer fyear = (fiscal.StartDate).Year();
        List<Org_Period> lstPeriods = new List<Org_Period>();  
        
        Integer count = fiscal.startDate.Month();
        Integer seq = 1;
        
        for(s_Period p : fiscal.periods){           
            if((p.Type).equals('Month')) {   
                lstPeriods.add(
                    new Org_Period(
                        (index++),String.valueOf(p.PId).escapeHtml4(),seq+'',(seq++),p.EndDate,p.StartDate,fyear,p.MPNumber+'',''
                    )); 
            } 
        }
        
        return lstPeriods;
}
public pagereference batchRun(){
    if(isCustomFiscalYearEnable){
        //Initialize start up component.
        FiscalYearSync.Initialization(lstfiscalsetting);

        //create new planning versions.
        FiscalYearSync.putFiscalPeriods();

        //create new planing version for All Budgets.
        FiscalYearSync.putFiscalAdditionalPeriods();

        //create new fiscal year custom.
        FiscalYearSync.putCustomFiscalYear();
    }
    else{
        StandardFiscalYearSync.Initialization();
        
        //create new planning versions.
        //version 12
        StandardFiscalYearSync.putFiscalPeriods();
        
        //create new planing version for All Budgets.
        // versions according to budget records.
        StandardFiscalYearSync.putFiscalAdditionalPeriods();
        
        //create new fiscal year custom.
        //12 periods of year
        StandardFiscalYearSync.putCustomFiscalYear();
    }
    return null;
}


    
    
}