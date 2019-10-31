public with sharing class LT_ReportSummary{

    public List<string> SelMeasures{get;set;}    
private string strFromPlan;
public string getstrFromPlan(){return strFromPlan;}
public void setstrFromPlan(string s){if(s<>null) strFromPlan = String.escapeSingleQuotes(s);}
    private string strE_FromPlan;
public string getstrE_FromPlan(){return strE_FromPlan;}
public void setstrE_FromPlan(string s){if(s<>null) strE_FromPlan = String.escapeSingleQuotes(s);}
    private string userCurrencySign;
public string getuserCurrencySign(){return userCurrencySign;}
public void setuserCurrencySign(string s){if(s<>null) userCurrencySign = String.escapeSingleQuotes(s);}
    private string strE_FromPlanMeasure;
public string getstrE_FromPlanMeasure(){return strE_FromPlanMeasure;}
public void setstrE_FromPlanMeasure(string s){if(s<>null) strE_FromPlanMeasure = String.escapeSingleQuotes(s);}
    public List<TableParentExport> lstTParentExport{get;set;}
    public List<Header> lstHeader{get;set;}
    public List<TableParent> lstTParent{get;set;}
    public List<Header> lstHeaderExport{get;set;}
    public List<TableValue> lstTValue{get;set;}
    public TableValue totalval{get;set;}
    private string strFromPlanYear;
public string getstrFromPlanYear(){return strFromPlanYear;}
public void setstrFromPlanYear(string s){if(s<>null) strFromPlanYear = String.escapeSingleQuotes(s);}
    List<Data> chartData;
    private string strAccOwner;
public string getstrAccOwner(){return strAccOwner;}
public void setstrAccOwner(string s){if(s<>null) strAccOwner = String.escapeSingleQuotes(s);}
    public Set<string> setUser{get;set;}
    public opportunity dummyOpportunity{get;set;}
    
    map<string,Planning_Version__c> mapMPV;
    String[] Measures = new String[]{};
    
    List<Planning_Financial_Measure__c > lstMeasure;
    public List<wrapperMeasure> lstWrapperMeasure{get;set;}
    public class wrapperMeasure{
        public boolean isChecked{get;set;}
        public ID MeasureId{get;set;}
        public String Measure{get;set;}
        public string Type{get;set;}
        public wrapperMeasure(boolean isChecked, ID MeasureId, String Measure, string Type){
            this.isChecked = isChecked;
            this.MeasureId = MeasureId;
            this.Measure = Measure;
            this.Type = Type;
        }
    }
    private string category;
public string getcategory(){return category;}
public void setcategory(string s){if(s<>null) category = String.escapeSingleQuotes(s);}
    public Datetime LastLoginDate{get;set;}
    List<Planning_Version__c> lstClosedPlanningVersion;
    public Set<string> lstAccountOption{get;set;}
    public Set<string> lstOpportunityOption{get;set;}
    private string sAccountText;
public string getsAccountText(){return sAccountText;}
public void setsAccountText(string s){if(s<>null) sAccountText = String.escapeSingleQuotes(s);}
    private string sOpportunityText;
public string getsOpportunityText(){return sOpportunityText;}
public void setsOpportunityText(string s){if(s<>null) sOpportunityText = String.escapeSingleQuotes(s);}
    
    map<string,set<string>> mapAccount;
    map<string,string> mapOpportunity;
    
    map<string,string> mapPlanningName;
    public pagereference retrieveData(){
        return null;
    }
    public LT_ReportSummary(){
        mapMPV = new map<string,Planning_Version__c>();
        dummyOpportunity = new Opportunity();
        SelMeasures = new List<string>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
        && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()){ 
        	LstMeasure = [select id,Name,Measure_Type__c from Planning_Financial_Measure__c  where name <> null];  
        }
        setUser = new set<string>();
        if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
	        for(User u : [select Id,Name from User where name <> null and isActive=true limit 100]){
	            setUser.add(u.Name);
	        
	        }
        }
        lstWrapperMeasure = new List<WrapperMeasure>();
        for(Planning_Financial_Measure__c  m : LstMeasure){
            
            if(m.Name <> 'Revenue'){lstWrapperMeasure.add(new WrapperMeasure(true,m.Id,m.Name,m.Measure_Type__c));SelMeasures.add(m.Id);}
            else
            lstWrapperMeasure.add(new WrapperMeasure(false,m.Id,m.Name,m.Measure_Type__c));
        }
        
        mapPlanningName = new map<string,string>();
        if (Schema.sObjectType.user.fields.Id.isAccessible() && Schema.sObjectType.user.fields.lastloginDate.isAccessible()){
        	LastLoginDate = [select id,lastloginDate from user where Id =: userInfo.getUserId() limit 1].lastloginDate;
        }
        category = 'Month';
        if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()){
       	 lstClosedPlanningVersion = [select id,Name,Version_Status__c,Fiscal_Year_Planning__r.StartDate__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Planning_Version_Current_Period__c,Planning_Version_Fiscal_Year__c,SequenceNo__c,Fiscal_Year_Planning__r.EndDate__c from Planning_Version__c where Version_Status__c = 'Closed'];
        }
        Integer latestYear = 0;
        Integer latestPeriod = 0;
        
        for(Planning_Version__c p : lstClosedPlanningVersion){
            mapPlanningName.put(p.Id,p.Name);
            if(latestYear < Integer.valueOf(p.Planning_Version_Fiscal_Year__c)){
                latestYear = Integer.valueOf(p.Planning_Version_Fiscal_Year__c);
            }
        }
        for(Planning_Version__c p : lstClosedPlanningVersion){
            if(latestYear == Integer.valueOf(p.Planning_Version_Fiscal_Year__c)){
                if(latestPeriod < Integer.valueOf(p.SequenceNo__c)){
                    latestPeriod = Integer.valueOf(p.SequenceNo__c);
                }               
            }
            mapMPV.put(p.Id,p);
        }
        for(Planning_Version__c p : lstClosedPlanningVersion){
            if(latestYear == Integer.valueOf(p.Planning_Version_Fiscal_Year__c) && latestPeriod == Integer.valueOf(p.SequenceNo__c)){
                strFromPlan = p.Id;
                strFromPlanYear = latestYear+'';
            }
        }
        
        lstAccountOption = new Set<String>();
        lstOpportunityOption = new set<String>();
        List<Opportunity> lstOpportunity;
        if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
        && Schema.sObjectType.Account.fields.Name.isAccessible()){
         lstOpportunity = [select id,Name,Account.Name from Opportunity where name <> null];
        }
        mapAccount = new map<string,set<string>>();
        mapOpportunity = new map<string,string>();
        for(Opportunity opp : lstOpportunity){
            lstOpportunityOption.add(opp.Name);
            lstAccountOption.add(opp.Account.Name);
            mapOpportunity.put(opp.Name,opp.Account.Name);
            mapAccount.put(opp.Account.Name,new Set<String>());
        }
        for(Opportunity opp : lstOpportunity){
            if(mapAccount.ContainsKey(opp.Account.Name)){
                Set<string> setTemp = mapAccount.get(opp.Account.Name);
                setTemp.add(opp.Name);
                mapAccount.put(opp.Account.Name,setTemp);
            }
        }
        
        
        
        getPlanningModel();
    }
    public List<Data> getData() {
        return chartData;
    }
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer v1 { get; set; }
        public Integer v2 { get; set; }
        public Integer v3 { get; set; }
        public Integer v4 { get; set; }
        
        public Data(String name, Integer data1, Integer v1, Integer v2, Integer v3, Integer v4) {
            this.name = name;
            this.data1 = data1;
            this.v1 = v1;
            this.v2 = v2;
            this.v3 = v3;           
            this.v4 = v4;          
        }
    }
    public List<SelectOption> getMeasureItems() {
        List<SelectOption> options = new List<SelectOption>();
        for(Planning_Financial_Measure__c  m : lstMeasure){
            options.add(new SelectOption(m.Id,m.Name));
        }
        return options;
    }
    public pagereference getPlanningModel(){
    
        Date Bcklog_fslyear_startdate;
        Date Bcklog_fslyear_Enddate;
        Date crtprd_startdate;
        Date crtprd_enddate;
        set<string> setSelConStages = new set<string>();
        List<Configuration_Setting__c> lstconfStages;
        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
        	lstconfStages = [select Id,Stage__c from Configuration_Setting__c limit 1];
        }
        for(Configuration_Setting__c  c : lstconfStages){
            if(c.stage__c <> null && c.stage__c <> ''){
                for(string s : c.stage__c.split(',')){
                    setSelConStages.add(s);
                }
            }                                           
        }
        if(mapMPV.containsKey(strFromPlan)){
            Planning_Version__c sctpv = mapMPV.get(strFromPlan);
            Bcklog_fslyear_startdate = sctpv.Fiscal_Year_Planning__r.StartDate__c;
            crtprd_startdate = sctpv.Data_Entry_Start_Date__c;
            crtprd_enddate = sctpv.Data_Entry_Closed_Date__c;
            Bcklog_fslyear_Enddate = sctpv.Fiscal_Year_Planning__r.EndDate__c;
        }
        
        if(mapPlanningName.containsKey(strFromPlan))
            strE_FromPlan = mapPlanningName.get(strFromPlan);            
        
        map<string,boolean> NIds = new map<string,boolean>();
        
        for(string p : SelMeasures){
            NIds.put(p,true);
        }
        for(wrapperMeasure m : lstWrapperMeasure){
            if(NIds.containsKey(m.MeasureId))m.isChecked = true;
            else m.isChecked = false;
        }
        
        //Error
        boolean isRevenue = false;
        boolean isRevenueBacklog = false;
        String sm = Apexpages.currentPage().getParameters().get('selectMeasure');
        String smv = Apexpages.currentPage().getParameters().get('selectMeasureValue');
        for(wrapperMeasure m : lstWrapperMeasure){
            if(sm <> null && sm <> '' && sm == m.MeasureId && smv <> null && smv <> ''){
                m.isChecked = boolean.valueOf(smv);
            }
        }
        for(wrapperMeasure m : lstWrapperMeasure){
            if(m.isChecked){
                if(m.Measure == 'Revenue')isRevenue = true;
                if(m.Measure == 'Revenue Backlog')isRevenueBacklog = true;
            }
        }
        if( isRevenue && isRevenueBacklog){
            
            if(sm <> null && sm <> ''){
                for(wrapperMeasure m : lstWrapperMeasure){
                    if(m.isChecked && m.MeasureId == sm){
                        m.isChecked = false;
                    }
                }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'you can choose any one amoung two measures Revenue and Revenue Backlog.'));
            return null;
        }
        
        string measureForBench;
        Set<string> setFMeasure = new Set<String>();
        strE_FromPlanMeasure = '';
        for(wrapperMeasure m : lstWrapperMeasure){
            if(m.isChecked){
                setFMeasure.add(m.MeasureId);
                if(measureForBench == null) measureForBench = m.MeasureId;
                else measureForBench += ','+m.MeasureId;
                if(strE_FromPlanMeasure <> '')strE_FromPlanMeasure += ''+m.Measure;
                strE_FromPlanMeasure = m.Measure;
            }
        }
        
        
        
        string query = 'Select id,Amount__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Fiscal_Quarter__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Period_Name__c, ';
        query += 'Opportunity__r.CloseDate,Opportunity__r.StageName,Opportunity__r.Name, opportunity__c,Opportunity__r.Project_Start_Date__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Deal_Duration__c, ';
        query += 'Opportunity__r.Account.Name,Opportunity__r.AccountId,Opportunity__r.Legacy__c, opportunity__r.Project_End_date__c,  opportunity__r.IsWon,  opportunity__r.isClosed  ';
        query += 'from Planning_Model__c where Fiscal_Period__c <> null and Planning_Measure__c IN: setFMeasure and Planning_Version__c =: strFromPlan and Fiscal_Period__r.Fiscal_Year__c =: strFromPlanYear ';
        
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,':');
        //ApexPages.addMessage(myMsg);
        
        if(
            strAccOwner <> null && strAccOwner.trim() <> ''
        ){
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
        }
                
        if((sAccountText <> null && sAccountText.trim() <> '') && (sOpportunityText <> null && sOpportunityText.trim() <> '')){
            sAccountText = sAccountText.trim();
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        else if((sAccountText <> null && sAccountText.trim() <> '') && (sOpportunityText == null || sOpportunityText.trim() == '')){
            sAccountText = sAccountText.trim();
            query += ' and Opportunity__r.Account.Name =: sAccountText ';            
            lstOpportunityOption.clear();            
            if(mapAccount.containsKey(sAccountText)){                
                for(String opp: mapAccount.get(sAccountText)){
                    lstOpportunityOption.add(opp);
                }
            }         
        }
        else if((sAccountText == null || sAccountText.trim() == '') && (sOpportunityText <> null && sOpportunityText.trim() <> '')){
            query += ' and Opportunity__r.Name =: sOpportunityText ';
            lstAccountOption.clear();
            sAccountText = '';
            if(mapOpportunity.ContainsKey(sOpportunityText)){
                lstAccountOption.add(mapOpportunity.get(sOpportunityText));   
                sAccountText = mapOpportunity.get(sOpportunityText);
            }           
        }
        else if((sAccountText == null || sAccountText.trim() == '') && (sOpportunityText == null || sOpportunityText.trim() == '')){
            
            lstOpportunityOption.clear();
            lstAccountOption.clear();

            for(String acc : mapAccount.keySet()){
                lstAccountOption.add(acc);
                for(String opp : mapAccount.get(acc)){
                    lstOpportunityOption.add(opp);
                }
            }
        }
        if(dummyOpportunity.BussinessUnit__c <> null){
        	String dummyOppBusinessUnit=dummyOpportunity.BussinessUnit__c;
            query += ' and Opportunity__r.BussinessUnit__c = :dummyOppBusinessUnit';
        }
        if(dummyOpportunity.Service_Line__c <> null){
        	String dummyOppServiceLine=dummyOpportunity.Service_Line__c;
            query += ' and Opportunity__r.Service_Line__c = :dummyOppServiceLine';
        }
        if(dummyOpportunity.Division__c <> null){
        	String dummyOppDivision=dummyOpportunity.Division__c;
            query += ' and Opportunity__r.Division__c = :dummyOppDivision';
        }
        if(strOppCatg != 'All' && strOppCatg <> null){
            query += ' and Opportunity__r.ForecastCategoryName = \''+String.escapeSingleQuotes(strOppCatg)+'\'';
        }
  
        
        
        List<Planning_Model__c> lstModel = new List<Planning_Model__c>();
        
        map<Id,string> mapOppCategory = new map<Id,string>();
        if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() 
		&& Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()
		&& Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() 
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Name.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
		
		
		&& Schema.sObjectType.Planning_Model__c.fields.opportunity__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible()
		&& Schema.sObjectType.Account.fields.Name.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.IsWon.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.isClosed.isAccessible()){
	        for(Planning_Model__c lk:Database.Query(query))
	        {
	            string oppMStage;
	            if(Test.isRunningTest())    oppMStage = 'OpenSelected';                
	            /* closed
	            1. Revenue End Date > version.FY.startDate 
	            2. Stages IN Configuration Settings.
	            3. isWon and isclose = true
	            4. close date <= version.enddate*/
	            if(
	            lk.opportunity__r.Project_End_date__c > Bcklog_fslyear_startdate && 
	            setSelConStages.contains(lk.opportunity__r.stageName) && 
	            lk.opportunity__r.iswon == true && 
	            lk.opportunity__r.isClosed == true && 
	            lk.opportunity__r.closeDate <= crtprd_enddate){     
	                oppMStage = 'ClosedWon';
	                if(lk.opportunity__r.Legacy__c == 'YES')
	                    oppMStage = 'LegacyClosed';
	            }
	            
	            /*Selected Open
	            1. close Date >= version.StartDate
	            2. Stages IN Configuration Settings.
	            3. isWon and isclose = false
	            4. close Date <= version.fy.endDate*/
	            if(
	            lk.opportunity__r.closeDate >= crtprd_startdate && 
	            setSelConStages.contains(lk.opportunity__r.stageName) && 
	            lk.opportunity__r.iswon == false && 
	            lk.opportunity__r.isClosed == false && 
	            lk.opportunity__r.closeDate <= Bcklog_fslyear_Enddate){
	                oppMStage = 'OpenSelected';
	            }
	            
	            /*Not Selected Open
	            1. close Date >= version.StartDate
	            2. Stages Not IN Configuration Settings.
	            3. isWon and isclose = false
	            4. close Date <= version.fy.endDate*/
	            if(
	            lk.opportunity__r.closeDate >= crtprd_startdate && 
	            !setSelConStages.contains(lk.opportunity__r.stageName)  && 
	            lk.opportunity__r.iswon == false && 
	            lk.opportunity__r.isClosed == false && 
	            lk.opportunity__r.closeDate <= Bcklog_fslyear_Enddate){
	                oppMStage = 'OpenNotSelected';
	            }
	            
	            mapOppCategory.put(lk.opportunity__c,oppMStage);
	            if(oppMStage <> null){
	                lstModel.add(lk);
	            }
	        }
		}
        lstHeader = new List<Header>();
        lstHeaderExport = new List<Header>();
        chartData = new List<Data>();
        lstTValue = new List<TableValue>();
        lstTParent = new List<TableParent>();
        totalval = new TableValue();
        totalval.AccName = 'Total';
        
        //apply multicurrency
            boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
            string DefaultCurrency = userinfo.getDefaultCurrency();
            if(DefaultCurrency == 'USD')userCurrencySign = '$';
            else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
            else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
            else if(DefaultCurrency == 'CAD')userCurrencySign = '$';
            map<Id,string> mapcurrency = new map<Id,string>();
            if(isMultiCurrencyOrganization){
                CurrencyConversion.Initialization();
            }
        if(!lstModel.isEmpty()){
            
            
            map<String,Integer> mapHeader = new map<string,Integer>();            
            map<String,Integer> mapFiscalAmount = new map<String,Integer>(); 
            map<String,Planning_Model__c> mapOppModel = new map<String,Planning_Model__c>(); 
            
            set<Id> setOppCurrency = new set<Id>();
            
            for(Planning_Model__c m : lstModel){ 
                setOppCurrency.add(m.Opportunity__c);
            }
            if(isMultiCurrencyOrganization){
                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
            }
            
            if(category == 'Month'){
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put(m.Fiscal_Period__r.Name,Integer.valueOf(m.Fiscal_Period__r.Period_Number__c));
                    decimal model_amount = m.Amount__c;
                    if(isMultiCurrencyOrganization)CurrencyConversion.Convert(mapcurrency.get(m.Opportunity__c),DefaultCurrency,m.Amount__c);
                    mapFiscalAmount.put(m.Opportunity__c+'-'+m.Fiscal_Period__r.Name,Integer.valueOf(model_amount));
                    mapOppModel.put(m.Opportunity__c,m);
                } 
            }
            else if(category == 'Quarter'){
                map<string,Integer> mapLastQuarter = new map<string,Integer>();
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put('FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,Integer.valueOf((m.Fiscal_Period__r.Fiscal_Quarter__c).substring(1,2)));
                    mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                    
                    mapOppModel.put(m.Opportunity__c,m);
                    mapLastQuarter.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                } 
                for(Planning_Model__c m : lstModel){                
                    if(mapFiscalAmount.containsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c)){
                        Integer p = mapFiscalAmount.get(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c);
                        if(m.Amount__c <> null){
                            p += Integer.ValueOf(m.Amount__c);
                            mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,p);
                        }
                    }
                              
                } 
                
                         
            }
            
            lstHeader.add(new Header('Account Name',1));
            lstHeader.add(new Header('Opportunity Name',2));
            lstHeader.add(new Header('Project Start Date',3));
            lstHeader.add(new Header('Deal TCV',4));
            lstHeader.add(new Header('Deal Duration',5));
            lstHeader.add(new Header('Measure Total',6));
            
            for(String key : mapHeader.keySet()){
                String index = key.substring(2,6)+(mapHeader.get(key)+5);
                if((mapHeader.get(key)+5) < 10){
                    index =  key.substring(2,6)+'0'+(mapHeader.get(key)+5);
                }
                lstHeader.add(new Header(key,Integer.valueOf(index)));
            }
            lstHeader.sort();
            
            List<FYears> sampYears = new List<FYears>();
            for(Header h : lstHeader){
                if(h.labelNumber > 6){                  
                    FYears fy = new FYears();
                    fy.label = h.label;
                    fy.labelNumber = h.labelNumber;
                    sampYears.add(fy);
                }
            }
            
            //remove periods/quarters
            List<Header> lstHeader_temp = new List<Header>();
            for(Header h : lstHeader){
                lstHeaderExport.add(h);
                if(h.labelNumber <= 6){                  
                    lstHeader_temp.add(h);
                }
            }
            
            lstHeader.clear();
            lstHeader.addAll(lstHeader_temp);
            
            
            
            //value
            
            for(string oppId :  mapOppModel.keyset()){
                Planning_Model__c m = mapOppModel.get(oppId);
                decimal total = 0;
                TableValue o = new TableValue();
                o.OppCategory = mapOppCategory.get(m.opportunity__c);
                o.SPlnVersion = strFromPlan;
                o.SPlnVername = mapMPV.get(strFromPlan).Name;
                o.SMeasure = measureForBench;
                o.OppName = m.opportunity__r.Name;
                o.AccName = m.opportunity__r.Account.Name;
                o.CurrencyIsoCode = mapcurrency.get(m.Opportunity__c);
                o.OppId = m.opportunity__c;
                o.CloseDate = m.opportunity__r.CloseDate;
                o.AccId = m.opportunity__r.AccountId;
                o.Rdateopp = m.opportunity__r.Project_Start_Date__c;
                o.Contractvalue = (m.opportunity__r.Deal_TCV__c <> null)?double.valueOf(m.opportunity__r.Deal_TCV__c):0;
                o.ContractTerm = (m.opportunity__r.Deal_Duration__c <> null)?Integer.valueOf(m.opportunity__r.Deal_Duration__c):0;
                o.Total = total;
                o.licolor = '#1E5FB2';
                if(m.opportunity__r.StageName == 'Closed Won' && m.opportunity__r.Legacy__c == 'YES')o.licolor = '#398F38';
                if(m.opportunity__r.StageName == 'Closed Won' && m.opportunity__r.Legacy__c != 'YES')o.licolor = '#008080';
                //isWon=false,isClose=false,not selected 
                if(!m.Opportunity__r.isWon && !m.Opportunity__r.isClosed && !setSelConStages.contains(m.Opportunity__r.stageName)){o.licolor  = '#FA9100';}
                
                //o.lstYears = sampYears;
                
                lstTValue.add(o);
            }
            
            
            if(isMultiCurrencyOrganization){
                CurrencyConversion.Initialization();
                for(TableValue t: lstTValue){
                    t.Contractvalue = CurrencyConversion.Convert(t.CurrencyIsoCode,DefaultCurrency,t.Contractvalue);
                    t.Total = CurrencyConversion.Convert(t.CurrencyIsoCode,DefaultCurrency,t.Total);
                }
            }
            
            
            string test = '';
            
            for(TableValue t: lstTValue){
                List<FYears> lstFy = new List<FYears>();
                decimal tm = 0;
                for(FYears f: sampYears){
                    FYears fy = new FYears();
                    fy.label = f.label;
                    fy.labelNumber = f.labelNumber;
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        fy.value= mapFiscalAmount.get(t.oppId+'-'+f.label); 
                        tm += mapFiscalAmount.get(t.oppId+'-'+f.label);
                    }
                    lstFy.add(fy);
                }
                t.total = tm;
                t.lstYears = lstFy;
            }
            
            //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,test);
            //apexpages.addmessage(msg);
            
            //total 
            map<string,Integer> mapTotalAmount = new map<string,Integer>();
            map<string,Integer> mapTotalAmountLegacyClosed = new map<string,Integer>();
            map<string,Integer> mapTotalAmountClosedWon = new map<string,Integer>();
            map<string,Integer> mapTotalAmountOpenSelected = new map<string,Integer>();
            map<string,Integer> mapTotalAmountOpenNotSelected = new map<string,Integer>();
            for(TableValue t: lstTValue){
                
                for(FYears f: t.lstYears){
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        Integer tt = f.value;
                        if(mapTotalAmount.containsKey(f.label)){
                            tt += mapTotalAmount.get(f.label);
                        }
                        mapTotalAmount.put(f.label,tt);
                        
                        Integer t1 = f.value;       
                        if(t.OppCategory == 'LegacyClosed'){
                            if(mapTotalAmountLegacyClosed.containsKey(f.label+'-LegacyClosed')){
                                t1 += mapTotalAmountLegacyClosed.get(f.label+'-LegacyClosed');
                            }
                            mapTotalAmountLegacyClosed.put(f.label+'-LegacyClosed',t1);
                        }
                        Integer t2 = f.value;       
                        if(t.OppCategory == 'ClosedWon'){
                            if(mapTotalAmountClosedWon.containsKey(f.label+'-ClosedWon')){
                                t2 += mapTotalAmountClosedWon.get(f.label+'-ClosedWon');
                            }
                            mapTotalAmountClosedWon.put(f.label+'-ClosedWon',t2);
                        }
                        Integer t3 = f.value;       
                        if(t.OppCategory == 'OpenSelected'){
                            if(mapTotalAmountOpenSelected.containsKey(f.label+'-OpenSelected')){
                                t3 += mapTotalAmountOpenSelected.get(f.label+'-OpenSelected');
                            }
                            mapTotalAmountOpenSelected.put(f.label+'-OpenSelected',t3);
                        }
                        Integer t4 = f.value;       
                        if(t.OppCategory == 'OpenNotSelected'){
                            if(mapTotalAmountOpenNotSelected.containsKey(f.label+'-OpenNotSelected')){
                                t4 += mapTotalAmountOpenNotSelected.get(f.label+'-OpenNotSelected');
                            }
                            mapTotalAmountOpenNotSelected.put(f.label+'-OpenNotSelected',t4);
                        }
                        
                    }
                    
                 
                }
            }

            List<FYears> lstY = new List<FYears>();
            for(FYears f:sampYears){
                f.value = mapTotalAmount.get(f.label);
                f.valueLegacyClosed = mapTotalAmountLegacyClosed.get(f.label+'-LegacyClosed');
                f.valueClosedWon = mapTotalAmountClosedWon.get(f.label+'-ClosedWon');
                f.valueOpenSelected = mapTotalAmountOpenSelected.get(f.label+'-OpenSelected');
                f.valueOpenNotSelected = mapTotalAmountOpenNotSelected.get(f.label+'-OpenNotSelected');
                lstY.add(f);
            }     

            
            totalval.lstYears = lstY;
            
            //chart data
            
            for(FYears f: lstY){
                Integer v = f.value;
                if(f.value < 0) v = 0;
                chartData.add(new Data(f.label, v, f.valueLegacyClosed,f.valueClosedWon,f.valueOpenSelected,f.valueOpenNotSelected));
               // system.debug(f.label+'#'+v+'-'+f.valueLegacyClosed+'-'+f.valueClosedWon+'-'+f.valueOpenSelected+'-'+f.valueOpenNotSelected);
            } 
            
            
            //remove periods/quarters
        
            
            map<string,List<TableValue>> mapParent = new map<string,List<TableValue>>();
            for(TableValue t : lstTValue){
                mapParent.put(t.AccId,new List<TableValue>());
            }
            for(TableValue t : lstTValue){
                List<TableValue> temp = mapParent.get(t.AccId);             
                temp.add(t);
                mapParent.put(t.AccId,temp);
            }
            for(string AccId : mapParent.keyset()){
                List<TableValue> temp = mapParent.get(AccId);
                Integer count = temp.size();
                double total =0;
                                double Mtotal =0;
                string AccountName;
                for(TableValue t :temp ){
                    if(t.Contractvalue <> null)total+=t.Contractvalue;
                    if(t.total <> null)MTotal+=t.total;
                    AccountName = t.AccName;
                }
                temp.sort();
                lstTParent.add(new TableParent(AccId,AccountName,temp,count,total,Mtotal));
            }
            
            
        } 
        lstTParent.sort();
        
        
        lstTParentExport = new List<TableParentExport>();
        map<string,List<TableValueExport>> mapExportAccount = new map<string,List<TableValueExport>>();
        map<string,TableValue> mapExportTable = new map<string,TableValue>();
        for(TableValue t: lstTValue){
            if(t.AccId <> null){
                TableValueExport te = new TableValueExport();
                te.OppName = t.OppName;
                te.OppId = t.OppId;
                te.Rdateopp = t.Rdateopp;
                te.Contractvalue = t.Contractvalue;
                te.CloseDate = t.CloseDate;
                te.ContractTerm = t.ContractTerm;
                te.Total = t.Total;
                te.lstYears = t.lstYears;
                te.licolor = t.licolor;
                
                List<TableValueExport> temp = new List<TableValueExport>();
                if(mapExportAccount.containsKey(t.AccId)){
                    Temp.addAll(mapExportAccount.get(t.AccId));                 
                }
                Temp.add(te);
                mapExportAccount.put(t.AccId,temp);
                mapExportTable.put(t.AccId,t);
            }
        }
        double Ttotal = 0;
        for(string accId : mapExportAccount.keyset()){
            TableValue t = mapExportTable.get(accId);
            Integer size = (t.lstYears).size();
            List<TableValueExport> temp = mapExportAccount.get(accId);
            temp.sort();
            Integer OppCount = 0;
            Double OppAmount = 0;
            Double OppBckAmount = 0;
            for(TableValueExport tx : temp){
                OppCount++;
                OppAmount += tx.Contractvalue;
                OppBckAmount += tx.total;
                Ttotal+= tx.total;

            }
            TableParentExport eae = new TableParentExport(t.AccId,t.AccName, temp,OppCount,OppAmount,OppBckAmount,size);
            lstTParentExport.add(eae);
        }
        totalval.total = Ttotal;
        lstTParentExport.sort();
        
        return null;
        
    }


    public List<SelectOption> getPMeasures() {
        
        List<SelectOption> options = new List<SelectOption>();
        for(wrapperMeasure w : lstWrapperMeasure){
            options.add(new SelectOption(w.MeasureId+'',w.Measure+'('+w.Type+')'));
        }
        
        return options;
    }
    
    public List<SelectOption> getFromPlan() {

        
        List<SelectOption> options = new List<SelectOption>();
        
        List<WSeqPlanningVersion> lstwrapper = new List<WSeqPlanningVersion>();
        for(Planning_Version__c cp :  lstClosedPlanningVersion){
            if(strFromPlanYear <> null && strFromPlanYear.equals(cp.Planning_Version_Fiscal_Year__c))
                lstwrapper.add(new WSeqPlanningVersion(cp));
        }
        lstwrapper.sort();
        
        for(WSeqPlanningVersion w : lstwrapper){
            Planning_Version__c cp = w.planningversion;
            if(strFromPlan == null) {strFromPlan = cp.Id+'';strE_FromPlan = cp.Name;}
            options.add(new SelectOption(cp.Id,cp.Name));
        }
        
        return options;
    }
    
    public List<SelectOption> getCategoryItem() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Quarter','Quarter'));
        options.add(new SelectOption('Month','Month'));
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
    public string strOppCatg{get;set;}
    public List<SelectOption> getOpportunityCategories() {
        strOppCatg = 'All';     
        List<String> lstStageName = getPicklistValues('Opportunity','ForecastCategoryName');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        for(String  s: lstStageName){
            options.add(new SelectOption(s,s));
        }
        return options;
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
        
        
        
        for(WPYearPlanningVersion wc : lstClosePlanning){
            if(strFromPlanYear == null)strFromPlanYear = String.valueOf(wc.pYear);
            options.add(new SelectOption(String.valueOf(wc.pYear),String.valueOf(wc.pYear)));
        }          
        
        //setFiscalYearLabel(Integer.valueOf(strFromPlanYear));
        
        return options;
    }
    public class WPYearPlanningVersion implements Comparable {

        public Integer pYear;
            
        // Constructor
        public WPYearPlanningVersion(Integer pYear) {
            this.pYear = pYear;
        }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            WPYearPlanningVersion compareToPlan = (WPYearPlanningVersion)compareTo;
            if (pYear == compareToPlan.pYear) return 0;
            if (pYear > compareToPlan.pYear) return 1;
            return -1;        
        }
    }
    public class WSeqPlanningVersion implements Comparable {

        public Planning_Version__c planningversion;
            
        // Constructor
        public WSeqPlanningVersion(Planning_Version__c planningversion) {
            this.planningversion = planningversion;
        }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            WSeqPlanningVersion compareToPlan = (WSeqPlanningVersion)compareTo;
            if (planningversion.SequenceNo__c == compareToPlan.planningversion.SequenceNo__c) return 0;
            if (planningversion.SequenceNo__c > compareToPlan.planningversion.SequenceNo__c) return 1;
            return -1;        
        }
    }
    
    public class Header implements Comparable{
        public String label{get;set;}
        public Integer labelNumber{get;set;}
        public Header(String label,Integer labelNumber){
            this.label = label;
            this.labelNumber = labelNumber;
        }
         // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            Header compareToPlan = (Header)compareTo;
            if (labelNumber == compareToPlan.labelNumber) return 0;
            if (labelNumber > compareToPlan.labelNumber) return 1;
            return -1;        
        }
    }
    
        public class TableValue   implements Comparable{
        public String OppName{get;set;}
        public String CurrencyIsoCode{get;set;}
        public String SPlnVersion{get;set;}
        public String SPlnVername{get;set;}
        public String SMeasure{get;set;}
        public String AccName{get;set;}
        public String OppId{get;set;}
        public String AccId{get;set;}
        public Date CloseDate{get;set;}
        public Date Rdateopp{get;set;}
        public Double Contractvalue{get;set;}
        public Integer ContractTerm{get;set;}
        public Double Total{get;set;}
        public List<FYears> lstYears{get;set;}
        public string licolor{get;set;}
        public string OppCategory {get;set;}
        public Integer compareTo(Object compareTo) {
            TableValue compareToOppy = (TableValue)compareTo;
            Integer returnValue = 0;
            if (Total > compareToOppy.Total) {
                returnValue = 1;
            } else if (Total < compareToOppy.Total) {
                returnValue = -1;
            }        
        return returnValue; 
        }

    }

    public class TableParent  implements Comparable{
        public String AccId{get;set;}
        public String AccName{get;set;}        
        public List<TableValue> lstTableValue{get;set;}
        public Integer OppCount{get;set;}
        public Double OppTotal{get;set;}
                public Double MeasureTotal{get;set;}
        public TableParent(String AccId,String AccName,List<TableValue> lstTableValue,Integer OppCount,Double OppTotal,Double MeasureTotal){
            this.AccId = AccId;
            this.AccName = AccName;
            this.lstTableValue = lstTableValue;
            this.OppCount = OppCount;
            this.OppTotal = OppTotal;
            this.MeasureTotal = MeasureTotal;
        }
        public Integer compareTo(Object compareTo) {
            TableParent compareToOppy = (TableParent)compareTo;
            Integer returnValue = 0;
            if (OppTotal > compareToOppy.OppTotal) {
                returnValue = -1;
            } else if (OppTotal < compareToOppy.OppTotal) {
                returnValue = 1;
            }        
        return returnValue; 
        }
    }

    
    
     public class TableValueExport   implements Comparable{
        public String OppName{get;set;}
        public String AccName{get;set;}
        public String OppId{get;set;}
        public String AccId{get;set;}
        public Date CloseDate{get;set;}
        public Date Rdateopp{get;set;}
        public Double Contractvalue{get;set;}
        public Integer ContractTerm{get;set;}
        public Double Total{get;set;}
        public List<FYears> lstYears{get;set;}
        public string licolor{get;set;}
        
        public Integer LegacyClosed{get;set;}
        public Integer ClosedWon{get;set;}
        public Integer OpenSelected{get;set;}
        public Integer OpenNotSelected{get;set;}
        
 



        
        public Integer compareTo(Object compareTo) {
            TableValueExport compareToOppy = (TableValueExport)compareTo;
            Integer returnValue = 0;
            if (CloseDate > compareToOppy.CloseDate) {
                returnValue = 1;
            } else if (CloseDate < compareToOppy.CloseDate) {
                returnValue = -1;
            }        
        return returnValue; 
        }

    }
    public class TableParentExport  implements Comparable{
        public String AccId{get;set;}
        public Integer ColumnSize{get;set;}
        public String AccName{get;set;}        
        public List<TableValueExport> lstTableValue{get;set;}
        public Integer OppCount{get;set;}
        public Double bcklgAccTotal{get;set;}
        public Double OppTotal{get;set;}
        public TableParentExport(String AccId,String AccName,List<TableValueExport> lstTableValue,Integer OppCount,Double OppTotal,double bcklgAccTotal,Integer ColumnSize){
            this.AccId = AccId;
            this.AccName = AccName;
            this.lstTableValue = lstTableValue;
            this.OppCount = OppCount;
            this.OppTotal = OppTotal;
            this.bcklgAccTotal = bcklgAccTotal;
            this.ColumnSize = ColumnSize;
            
        }
        public Integer compareTo(Object compareTo) {
            TableParentExport compareToOppy = (TableParentExport)compareTo;
            Integer returnValue = 0;
            if (bcklgAccTotal > compareToOppy.bcklgAccTotal) {
                returnValue = -1;
            } else if (bcklgAccTotal < compareToOppy.bcklgAccTotal) {
                returnValue = 1;
            }        
        return returnValue; 
        }
    }
    
    public class FYears{
        public string label{get;set;}
        public Integer value{get;set;}
        public Integer valueLegacyClosed{get;set;}
        public Integer valueClosedWon{get;set;}
        public Integer valueOpenSelected{get;set;}
        public Integer valueOpenNotSelected{get;set;}
        public Integer labelNumber{get;set;}
        
        public Integer compareTo(Object compareTo) {
            FYears compareToPlan = (FYears)compareTo;
            if (labelNumber == compareToPlan.labelNumber) return 0;
            if (labelNumber > compareToPlan.labelNumber) return 1;
            return -1;        
        }
    }
    public String[] getMeasures() {
        return Measures;
    }
        
    public void setMeasures(String[] Measures) {
        this.Measures = Measures;
    } 
    public pagereference Export(){
        return page.LT_ReportSummaryExport;
    }
}