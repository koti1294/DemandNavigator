public with sharing class Revenue_PrioritizationController{

    private string userCurrencySign;public string getuserCurrencySign(){return userCurrencySign;}public void setuserCurrencySign(string s){if(s<>null) userCurrencySign = String.escapeSingleQuotes(s);}
    private string strFromPlan;public string getstrFromPlan(){return strFromPlan;}public void setstrFromPlan(string s){if(s<>null) strFromPlan = String.escapeSingleQuotes(s);}
    private string strE_FromPlan;public string getstrE_FromPlan(){return strE_FromPlan;}public void setstrE_FromPlan(string s){if(s<>null) strE_FromPlan = String.escapeSingleQuotes(s);}
    public opportunity dummyOpportunity{get;set;}
    private string strQuarter;public string getstrQuarter(){return strQuarter;}public void setstrQuarter(string s){if(s<>null) strQuarter = String.escapeSingleQuotes(s);}
    private string strAccOwner;public string getstrAccOwner(){return strAccOwner;}public void setstrAccOwner(string s){if(s<>null) strAccOwner = String.escapeSingleQuotes(s);}
    private string strBussUnit;public string getstrBussUnit(){return strBussUnit;}public void setstrBussUnit(string s){if(s<>null) strBussUnit = String.escapeSingleQuotes(s);}
    private string strDivision;public string getstrDivision(){return strDivision;}public void setstrDivision(string s){if(s<>null) strDivision = String.escapeSingleQuotes(s);}
    
    String[] OppStages = new String[]{};
    public String[] getOppStages() {
        return OppStages;
    }
        
    public void setOppStages(String[] OppStages) {
        this.OppStages = OppStages;
    }
    
   
    private string strFromPlanYear;public string getstrFromPlanYear(){return strFromPlanYear;}public void setstrFromPlanYear(string s){if(s<>null) strFromPlanYear = String.escapeSingleQuotes(s);}
    private string strFromPlanVersion;public string getstrFromPlanVersion(){return strFromPlanVersion;}public void setstrFromPlanVersion(string s){if(s<>null) strFromPlanVersion = String.escapeSingleQuotes(s);}
    List<Data> chartData;
    
    
    private string category;public string getcategory(){return category;}public void setcategory(string s){if(s<>null) category = String.escapeSingleQuotes(s);}
    public Datetime LastLoginDate{get;set;}
    List<Planning_Version__c> lstClosedPlanningVersion;
    public Set<string> lstAccountOption{get;set;}
    public Set<string> lstOpportunityOption{get;set;}
    private string sAccountText;public string getsAccountText(){return sAccountText;}public void setsAccountText(string s){if(s<>null) sAccountText = String.escapeSingleQuotes(s);}
    private string sOpportunityText;public string getsOpportunityText(){return sOpportunityText;}public void setsOpportunityText(string s){if(s<>null) sOpportunityText = String.escapeSingleQuotes(s);}
    
    map<string,set<string>> mapAccount;
    map<string,string> mapOpportunity;
    map<string,Fiscal_Year_Planning__c> mapFiscalSetting = new map<string,Fiscal_Year_Planning__c>();
    
    map<string,string> mapPlanningName;
    
    
    public List<Opportunity> lstOpportunity{get;set;}
    public pagereference retrieveData(){
        return null;
    }
    public List<wrapperOpportunity> PriorityOpportunity{get;set;}
    public Revenue_PrioritizationController(){ 
        dummyOpportunity = new Opportunity();
        category = 'Month'; 
        PriorityOpportunity = new List<wrapperOpportunity>();
        mapPlanningName = new map<string,string>();  
        getFromPlanYear();
        getFromPlanVersion();
        getFilterOpportunity();
    }
    public List<Data> getData() {
        return chartData;
    }
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Data(String name, Integer data1) {
            this.name = name;
            this.data1 = data1;
        }
    }
    
    public class wrapperOpportunity implements Comparable{
        public opportunity opp{get;set;}
        public decimal oppConValue{get;set;}
        public string licolor{get;set;}
        public string FiscalPeriodId{get;set;}
        public string FiscalPeriodName{get;set;}
        public string fQuarter{get;set;}
        public decimal FiscalAmount{get;set;}
        public wrapperOpportunity(opportunity opp, string FiscalPeriodId, string FiscalPeriodName, string fQuarter,decimal FiscalAmount,decimal oppConValue, string licolor){
            this.opp = opp;
            this.FiscalPeriodId = FiscalPeriodId;
            this.FiscalPeriodName = FiscalPeriodName;
            this.fQuarter = fQuarter;
            this.FiscalAmount = FiscalAmount;
            this.oppConValue = oppConValue;
            this.licolor = licolor;
        }
        public Integer compareTo(Object compareTo) {
            wrapperOpportunity compareToOppy = (wrapperOpportunity)compareTo;
            Integer returnValue = 0;
            if (FiscalAmount > compareToOppy.FiscalAmount) {
                returnValue = -1;
            } else if (FiscalAmount < compareToOppy.FiscalAmount) {
                returnValue = 1;
            }        
        return returnValue;       
    }
    }
    
    
    
    public void getFilterOpportunity(){
        
        //Date Bcklog_fslyear_startdate;
        Date Bcklog_fslyear_Enddate;
        Date crtprd_startdate;
        Planning_Version__c pversion;
        if(strFromPlanversion == null ) return;
        
        if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isAccessible()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
             pversion =  [select id,Fiscal_Year_Planning__c,Fiscal_Year_Planning__r.StartDate__c,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Is_this_a_Budget_Planning_Version__c,
        Fiscal_Year_Planning__r.EndDate__c,Planning_Version_Fiscal_Year__c,SequenceNo__c 
        from Planning_Version__c where id =: strFromPlanversion limit 1];
        }
        if(pversion <> null && pversion.Fiscal_Year_Planning__c <> null && pversion.Fiscal_Year_Planning__r.StartDate__c <> null && pversion.Data_Entry_Start_Date__c <> null){
            //Bcklog_fslyear_startdate = pversion.Fiscal_Year_Planning__r.StartDate__c;
            crtprd_startdate = pversion.Data_Entry_Start_Date__c;
            Bcklog_fslyear_Enddate = pversion.Fiscal_Year_Planning__r.EndDate__c;
                                
            //get backlog measure
            map<String,String> mapFMeasureId = new map<String,String>();
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	            for(Planning_Financial_Measure__c  fm : [select id,Name from Planning_Financial_Measure__c where name <> null]){
	                mapFMeasureId.put(fm.Name,fm.Id);
	            } 
            }
            Set<string> setFMeasure = new Set<String>();
            setFMeasure.add(mapFMeasureId.get('Revenue'));
            
            string selYear = pversion.Planning_Version_Fiscal_Year__c;
            String strmodel = '(Select   ID,Fiscal_Period__r.Fiscal_Quarter__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,';
            strmodel += 'Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,';
            strmodel += 'Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c from Planning_Models__r ';
            strmodel += 'where  Planning_Measure__c <> null and Planning_Measure__c IN: setFMeasure and  Fiscal_Period__r.Fiscal_Year__c =: selYear and Planning_Version__c =: strFromPlanversion';
            if(strQuarter <> 'All' && strQuarter <> null){
                strmodel += ' and Fiscal_Period__r.Fiscal_Quarter__c = \''+String.escapeSingleQuotes(strQuarter)+'\'';
            }
            strmodel += ' ) ';
            
            String query = 'Select Id,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c, Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,Account.Owner.Name,BussinessUnit__c,Division__c,Legacy__c,';
            query += strmodel;                   
            query +=' from Opportunity where closeDate >=: crtprd_startdate and iswon = false and isClosed = false and closeDate <=: Bcklog_fslyear_Enddate and stageName <> \'closed Lost\'';
            
            if(sAccountText <> null && sAccountText <> ''){
                query += ' and AccountId <> null and Account.Name = \'' +String.escapeSingleQuotes(sAccountText)+'\' ';
            }
            if(sOpportunityText <> null && sOpportunityText <> ''){
                query += ' and Name = \'' +String.escapeSingleQuotes(sOpportunityText)+'\' ';
                
            }
            
            
            if(strAccOwner <> 'All' && strAccOwner <> null){
                query += ' and Account.OwnerId = \''+String.escapeSingleQuotes(strAccOwner)+'\'';
            }
                            
                            
            if(dummyOpportunity.BussinessUnit__c <> null){
            	String dummyOppBusinessUnit=dummyOpportunity.BussinessUnit__c;
                query += ' and BussinessUnit__c = :dummyOppBusinessUnit';
            }
            if(dummyOpportunity.Service_Line__c <> null){
            	String dummyOppServiceLine=dummyOpportunity.Service_Line__c;
                query += ' and Service_Line__c = :dummyOppServiceLine';
            }
            if(dummyOpportunity.Division__c <> null){
            	String dummyOppDivision =dummyOpportunity.Division__c;
                query += ' and Division__c = :dummyOppDivision';
            }
          
            query += ' order By Deal_TCV__c DESC';  
       
                
            List<Opportunity> lstOpp = new List<Opportunity>();
            try{
            	if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() 
            	&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible()
				&& Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible()
				&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
				&& Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()
				&& Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
				&& Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()
				&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
				
				&& Schema.sObjectType.Opportunity.fields.Id.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.isWon.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.isclosed.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Actuals_to_date__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Description.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
				&& Schema.sObjectType.Account.fields.Name.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Name.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.BussinessUnit__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Division__c.isAccessible()
				&& Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()){
               // system.debug('#-#:'+setFMeasure+'-'+selYear+'-'+strFromPlanversion+'-'+crtprd_startdate+'-'+Bcklog_fslyear_Enddate+'::'+query);
            		lstOpp = Database.Query(query); 
				}
            }catch(Exception e){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e+'::'+setFMeasure+'-'+selYear+'-'+strFromPlanversion+'-'+crtprd_startdate+'-'+Bcklog_fslyear_Enddate+'::'+query);
                ApexPages.addMessage(myMsg);}
              
            
            PriorityOpportunity.clear();
            
            string FiscalPeriodId;
            string FiscalPeriodName;
            decimal FiscalAmount;
            map<string,decimal> mapviews = new map<string,decimal>();
            map<string,decimal> mapQviews = new map<string,decimal>();
            map<Id,string> mapcurrency = new map<Id,string>();
            //apply multicurrency
            
            boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
            string DefaultCurrency = userinfo.getDefaultCurrency();
            if(DefaultCurrency == 'USD')userCurrencySign = '$';
            else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
            else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
            else if(DefaultCurrency == 'CAD')userCurrencySign = '$';
            if(isMultiCurrencyOrganization){
                CurrencyConversion.Initialization();
            }
            set<Id> setOppCurrency = new set<Id>();
            
            for(Opportunity Opp: lstOpp){
                setOppCurrency.add(opp.id);
            }
            if(isMultiCurrencyOrganization){
                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
            }
            
            for(Opportunity Opp: lstOpp){
                FiscalPeriodId = '';
                FiscalPeriodName = '';
                FiscalAmount = 0;
                //string fyear = 'FY'+opp.Project_Start_Date__c.year()+'P'+opp.Project_Start_Date__c.month();
                string fQuarter = '';
                for(Planning_Model__c m : opp.Planning_Models__r){
                    //if(m.Fiscal_Period__r.Name == fyear ){
                        m.Amount__c = m.Amount__c;
                        if(isMultiCurrencyOrganization)CurrencyConversion.Convert(mapcurrency.get(opp.Id),DefaultCurrency,m.Amount__c);
                        
                        FiscalPeriodId = m.Fiscal_Period__c;
                        FiscalPeriodName= m.Fiscal_Period__r.Name;
                        if(strQuarter <> 'All' && m.Fiscal_Period__c <> null && strQuarter == m.Fiscal_Period__r.Fiscal_Quarter__c && m.Planning_Measure__r.Name == 'Revenue')FiscalAmount += m.Amount__c;
                        else if(strQuarter == 'All' && m.Planning_Measure__r.Name == 'Revenue') FiscalAmount += m.Amount__c;
                        //mapviews.put(m.Fiscal_Period__r.Name,0);
                        //mapQviews.put('FY'+opp.Project_Start_Date__c.year()+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                        fQuarter = m.Fiscal_Period__r.Fiscal_Quarter__c;
                        //break;
                    //}
                }
                string licolor = '#005FB2';
                if(opp.Legacy__c == 'YES' && opp.StageName == 'Closed Won')licolor  = '#398F38';
                else if(opp.Legacy__c != 'YES' && opp.StageName == 'Closed Won')licolor  ='#008080';


                decimal oppconval = opp.Deal_TCV__c;
                if(isMultiCurrencyOrganization)CurrencyConversion.Convert(mapcurrency.get(opp.Id),DefaultCurrency,opp.Deal_TCV__c);
                PriorityOpportunity.add(new wrapperOpportunity(opp,FiscalPeriodId, FiscalPeriodName, fQuarter,FiscalAmount,oppconval,licolor));
            }
            
           
            PriorityOpportunity.sort();
        }
        
    }


    public List<SelectOption> getOpportunityStages() {
        String[] OStages = new String[]{};
        List<SelectOption> options = new List<SelectOption>();
        if (Schema.sObjectType.OpportunityStage.fields.description.isAccessible() && Schema.sObjectType.OpportunityStage.fields.IsClosed.isAccessible()
        && Schema.sObjectType.OpportunityStage.fields.IsWon.isAccessible() && Schema.sObjectType.OpportunityStage.fields.MasterLabel.isAccessible()
        && Schema.sObjectType.OpportunityStage.fields.IsActive.isAccessible()){
	        for(OpportunityStage os : [select description,IsClosed,IsWon,MasterLabel,IsActive from OpportunityStage where isActive = true and IsClosed = false ]){
	            options.add(new SelectOption(os.MasterLabel,os.MasterLabel));
	            OStages.add(os.MasterLabel);
	        }
        }
        setOppStages(OStages);
        return options;
    }

    
    
    public List<SelectOption> getFromPlanYear() {
        List<SelectOption> options = new List<SelectOption>();
        strFromPlanYear = null;
        List<Fiscal_Year_Planning__c> lstLV;
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){ 
       	 lstLV = [select Id,Name from Fiscal_Year_Planning__c where name <> null order by Name limit 200];
        }
        for(Fiscal_Year_Planning__c fy : lstLV){
            if(strFromPlanYear == null)strFromPlanYear = fy.Id;                 
            options.add(new selectOption(fy.Id,fy.Name));
            mapFiscalSetting.put(fy.Name,fy);
        }
        
        return options;
    }
    
    public List<SelectOption> getFromPlanVersion() {
        List<SelectOption> options = new List<SelectOption>();
        strFromPlanVersion = null;
        if(strFromPlanYear <> null){
        	 if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()){
                List<Planning_Version__c> lstLV = [select Id,Name from Planning_Version__c where Fiscal_Year_Planning__c =: strFromPlanYear limit 200];
        	 
                for(Planning_Version__c fy : lstLV){
                    if(strFromPlanVersion == null) strFromPlanVersion = fy.Id;
                    options.add(new selectOption(fy.Id,fy.Name));
                }
        	 }
            }
        
        return options;
    }
    
    public List<SelectOption> getFiscalQuarter() {
        List<SelectOption> options = new List<SelectOption>();
        strQuarter = 'All';
        options.add(new selectOption('All','All'));
        for(Integer i=1;i<5;i++){
            options.add(new selectOption('Q'+i,'Q'+i));
        }       
        return options;
    }
    
    public List<SelectOption> getFiscalOwner() {
        List<SelectOption> options = new List<SelectOption>();
        strAccOwner = 'All';
        options.add(new selectOption('All','All'));
        if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
	        for(User u: [select Id,Name from User where isActive = true limit 100]){
	                options.add(new selectOption(u.Id,u.Name));
	            } 
        }   
        return options;
    }
    
    
    public List<SelectOption> getOppBussinessUnit() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('All','All'));
        strBussUnit = 'All';
        string namespace = NameSpaceUtil.getNameSpace('Planning_Financial_Measure__c');
        for(string s : getPicklistValues('Opportunity',namespace +'BussinessUnit__c')){
            options.add(new selectOption(s,s));
        }       
        return options;
    }
    
    
    
    public List<SelectOption> getOppDivision() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('All','All'));
                strDivision = 'All';
        string namespace = NameSpaceUtil.getNameSpace('Planning_Financial_Measure__c');
        for(string s : getPicklistValues('Opportunity',namespace +'Division__c')){
            options.add(new selectOption(s,s));
        }       
        return options;
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

    public pagereference Export(){
        return page.Revenue_prioritization_Export;
    }
}