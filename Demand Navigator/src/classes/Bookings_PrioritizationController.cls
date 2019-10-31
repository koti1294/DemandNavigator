public with sharing class Bookings_PrioritizationController{

    private string strFromPlan;
    public string getstrFromPlan() {return strFromPlan;}
    public void setstrFromPlan(string s) {if(s<>null)strFromPlan= String.escapeSingleQuotes(s);}
    
    private string userCurrencySign;
    public string getuserCurrencySign(){return userCurrencySign;}  public void setuserCurrencySign(string u){ userCurrencySign= String.escapeSingleQuotes(u); }
    
    private string strE_FromPlan; public string getstrE_FromPlan() {return strE_FromPlan;}  public void setstrE_FromPlan(string s) {if(s<>null)strE_FromPlan= String.escapeSingleQuotes(s);}
    
    private string strAccOwner;   public string getstrAccOwner() {return strAccOwner;}    public void setstrAccOwner(string s) {if(s<>null)strAccOwner= String.escapeSingleQuotes(s);}
    
    public opportunity dummyOpportunity{get;set;}
    public Set<string> setUser{get;set;}
    
    String[] OppStages = new String[]{};
    public String[] getOppStages() { return OppStages; }    public void setOppStages(String[] OppStages) { this.OppStages = OppStages;  }   
   
    private String strFromPlanYear;public String getstrFromPlanYear(){return strFromPlanYear;}public void setstrFromPlanYear(string s){if(s<>null)strFromPlanYear= String.escapeSingleQuotes(s); }
    
      
    List<Data> chartData;  
    private string Category; public string getCategory(){  return Category; } public void setCategory(string c){ if(c<>null)category= String.escapeSingleQuotes(c); }
    
    public Datetime LastLoginDate{get;set;}
    List<Planning_Version__c> lstClosedPlanningVersion;
    public Set<string> lstAccountOption{get;set;}
    public Set<string> lstOpportunityOption{get;set;}
    public String sAccountText{get;
        set {
            if(sAccountText<>null)sAccountText = String.escapeSingleQuotes(sAccountText);
        }
    }
    public String sOpportunityText{get;
        set {
            if(sOpportunityText<>null)sOpportunityText = String.escapeSingleQuotes(sOpportunityText);
        }
    }
    
    map<string,set<string>> mapAccount;
    map<string,string> mapOpportunity;
    map<string,Fiscal_Year_Planning__c> mapFiscalSetting = new map<string,Fiscal_Year_Planning__c>();
    
    map<string,string> mapPlanningName;
    
    
    public List<Opportunity> lstOpportunity{get;set;}
    public pagereference retrieveData(){
        return null;
    }
    public List<wrapperOpportunity> PriorityOpportunity{get;set;}
    public Bookings_PrioritizationController(){ 
        
        
            dummyOpportunity = new Opportunity();
            setUser = new set<string>(); 
            if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
	            for(User u : [select Id,Name from User where Name <> null and isActive= true limit 100]){
	                setUser.add(u.Name);
	            }
            }
            Category ='Month'; 
            PriorityOpportunity = new List<wrapperOpportunity>();
            mapPlanningName = new map<string,string>();  
            getFilterOpportunity();
        
    }
    public List<Data> getData() {
        return chartData;
    }
    public class Data {
        public String name { get;set;}
        public Integer data1 { get; set; }
        public Data(String name, Integer data1) {
            this.name = name;
            this.data1 = data1;
        }
    }
    
    public class wrapperOpportunity{
        public opportunity opp{get;set;}
        public decimal oppConValue{get;set;}
        public string licolor{get;set;}      
        public string FiscalPeriodId{get;set;}        
        public string FiscalPeriodName{get;set;}        
        public string fQuarter{get;set;}
       
        public decimal FiscalAmount{get;set;}
        public wrapperOpportunity(opportunity opp, string FiscalPeriodId, string FiscalPeriodName, string fQuarter,decimal FiscalAmount,decimal oppConValue,string licolor){
            this.opp = opp;
            this.FiscalPeriodId = FiscalPeriodId;
            this.FiscalPeriodName = FiscalPeriodName;
            this.fQuarter = fQuarter;
            this.FiscalAmount = FiscalAmount;
            this.oppConValue = oppConValue;
            this.licolor = licolor;
        }
    }
    
    
    public void getFilterOpportunity(){
        
        
        try{
        string Inp_sAccountText = null;
        if(sAccountText <> null) {
            Inp_sAccountText = String.escapeSingleQuotes(sAccountText);
        }
        string Inp_sOpportunityText = null;
        if(sOpportunityText <> null) {
            Inp_sOpportunityText = String.escapeSingleQuotes(sOpportunityText);
        }
        
        string query = 'Select id,Name,Project_Start_Date__c,Deal_TCV__c,StageName,CloseDate,Deal_Duration__c,Account.Name,AccountId,Legacy__c,(select Id,Fiscal_Period__r.Fiscal_Quarter__c, Fiscal_Period__c,Fiscal_Period__r.Name,Amount__c from Planning_Models__r where Planning_Measure__r.Name = \'Revenue\') from Opportunity WHERE Deal_TCV__c <> NULL  AND isClosed = false  And StageName <> \'Sales Proration\'';
        if(strFromPlanYear <> null && strFromPlanYear <> 'All' && mapFiscalSetting.containsKey(strFromPlanYear)){
            Integer sYear = Integer.valueOf(mapFiscalSetting.get(strFromPlanYear).Name);
            query += ' and CALENDAR_YEAR(Project_Start_Date__c)  =: sYear and Project_Start_Date__c >= today ';
        }
        if(sAccountText <> null && sAccountText <> ''){
            query += ' and AccountId <> null and Account.Name =: Inp_sAccountText';
        }
        if(sOpportunityText <> null && sOpportunityText <> ''){
            query += ' and Name =: Inp_sOpportunityText';
            
        }
        
        if(OppStages <> null && OppStages.size()>0){
            set<string> setStages = new set<string>();
            for(string s : OppStages){ setStages.add(s);   }
            query += ' and stageName IN: setStages';
        }
        if(strAccOwner <> null && strAccOwner.trim() <> ''){
            query += ' and Account.Owner.Name =: strAccOwner ';
        }
        if(dummyOpportunity.BussinessUnit__c <> null){
        	String dummyOpportunityBussinessUnit =dummyOpportunity.BussinessUnit__c;
            query += ' and BussinessUnit__c = :dummyOpportunityBussinessUnit';
        }
        if(dummyOpportunity.Service_Line__c <> null){
        	String dummyOpportunityService_Line=dummyOpportunity.Service_Line__c;
            query += ' and Service_Line__c = :dummyOpportunityService_Line';
        }
        if(dummyOpportunity.Division__c <> null){
        	String dummyOpportunityDivision=dummyOpportunity.Division__c;
            query += ' and Division__c = :dummyOpportunityDivision';
        }
        query += ' order By Deal_TCV__c DESC';  
    
        List<Opportunity> lstOpp = new List<Opportunity>();
        try{
        	if(Opportunity.sObjectType.getDescribe().isAccessible()){
        		lstOpp = Database.Query(query); 
        	}
        	lstOpp = Database.Query(query); 
        }catch(Exception e){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e+'-'+query)); }
        
        
            
        PriorityOpportunity.clear();
        
        string FiscalPeriodId;
        string FiscalPeriodName;
        decimal FiscalAmount;
        map<string,decimal> mapviews = new map<string,decimal>();
        map<string,decimal> mapQviews = new map<string,decimal>();
        
        //apply multicurrency
        boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
        string DefaultCurrency = userinfo.getDefaultCurrency();
        if(DefaultCurrency == 'USD')userCurrencySign = '$';
        else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
        else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
        else if(DefaultCurrency == 'CAD')userCurrencySign = '$';
        map<Id,string> mapcurrency = new map<Id,string>();
        set<Id> setOppCurrency = new set<Id>();
            
        for(Opportunity opp : lstOpp){ 
            setOppCurrency.add(opp.id);
        }
        if(isMultiCurrencyOrganization){
            mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
        }
        if(isMultiCurrencyOrganization){
            CurrencyConversion.Initialization();
            mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
        }
            
        for(Opportunity Opp: lstOpp){
            FiscalPeriodId = '';
            FiscalPeriodName = '';
            FiscalAmount = 0;
            string fyear = 'FY';
            fyear += opp.Project_Start_Date__c.year();
            fyear += 'P';
            fyear += opp.Project_Start_Date__c.month();
            string fQuarter = '';
            for(Planning_Model__c m : opp.Planning_Models__r){
                //system.debug('###:'+m.Fiscal_Period__r.Name +'=='+ fyear);
                if(m.Fiscal_Period__r.Name == fyear ){
                    FiscalPeriodId = m.Fiscal_Period__c;
                    FiscalPeriodName= m.Fiscal_Period__r.Name;
                    FiscalAmount= m.Amount__c;
                    if(isMultiCurrencyOrganization)CurrencyConversion.Convert(mapcurrency.get(opp.Id),DefaultCurrency,m.Amount__c);
                    mapviews.put(m.Fiscal_Period__r.Name,0);
                    mapQviews.put('FY'+opp.Project_Start_Date__c.year()+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                    fQuarter = m.Fiscal_Period__r.Fiscal_Quarter__c;    break;
                }
            }
            string licolor = '#005FB2';
            if(opp.Legacy__c == 'YES' && opp.StageName == 'Closed Won')licolor  = '#398F38';
            else if(opp.Legacy__c != 'YES' && opp.StageName == 'Closed Won')licolor  ='#008080';


            decimal oppconval = opp.Deal_TCV__c;
            if(isMultiCurrencyOrganization)CurrencyConversion.Convert(mapcurrency.get(opp.Id),DefaultCurrency,opp.Deal_TCV__c);
            PriorityOpportunity.add(new wrapperOpportunity(opp,FiscalPeriodId, FiscalPeriodName, fQuarter,FiscalAmount,oppconval,licolor));
        }
        
        for(wrapperOpportunity w: PriorityOpportunity){
            decimal t=0;
            if(mapviews.containsKey(FiscalPeriodName))t = mapviews.get(FiscalPeriodName);
            if( w.FiscalAmount <> null)
                t += w.FiscalAmount;
            mapviews.put(FiscalPeriodName,t);
            
            decimal t1=0;
            if(mapQviews.ContainsKey('FY'+w.opp.Project_Start_Date__c.year()+w.fQuarter))   t1 = mapQviews.get('FY'+w.opp.Project_Start_Date__c.year()+w.fQuarter);
            if( w.FiscalAmount <> null)
                t1 += w.FiscalAmount;
            
            mapQviews.put('FY'+w.opp.Project_Start_Date__c.year()+w.fQuarter,t1);
            
        }
        chartData = new List<Data>();
        if(category == 'Month'){
            for(string s : mapviews.keyset()){
                chartData.add(new Data(s,Integer.valueOf(mapviews.get(s))));
            }
        }
        else if(category == 'Quarter'){
            for(string s : mapQviews.keyset()){
                chartData.add(new Data(s,Integer.valueOf(mapQviews.get(s))));
            }
        }
        }
        catch(Exception e){  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e+'-'+e.getLineNumber()));  }
        
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
        List<Fiscal_Year_Planning__c> lstYear = new List<Fiscal_Year_Planning__c>();
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() ){
        	 lstYear = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where Name <> null order by StartDate__c];
    	}
        options.add(new selectOption('All','All'));
        strFromPlanYear = 'All';
        if(lstYear.Size()>0){
	        for(Fiscal_Year_Planning__c fy : lstYear){
	            options.add(new selectOption(fy.Id,fy.Name));
	            mapFiscalSetting.put(fy.Id,fy);
	        }
        }
        return options;
    }

    public pagereference Export(){
        return page.SalesbookingExport;
    }
}