public with sharing class LT_Revenue_Backlog_by_Period_or_Quarter{

    private string strFromPlan;public string getstrFromPlan(){return strFromPlan;}public void setstrFromPlan(string s){if(s<>null) strFromPlan = String.escapeSingleQuotes(s);}
    private string userCurrencySign;public string getuserCurrencySign(){return userCurrencySign;}public void setuserCurrencySign(string s){if(s<>null) userCurrencySign = String.escapeSingleQuotes(s);}
    private string strE_FromPlan;public string getstrE_FromPlan(){return strE_FromPlan;}public void setstrE_FromPlan(string s){if(s<>null) strE_FromPlan = String.escapeSingleQuotes(s);}
    public List<Header> lstHeader{get;set;}
    public List<Header> lstHeaderExport{get;set;}
    public List<TableValue> lstTValue{get;set;}
    public List<TableParent> lstTParent{get;set;}
    public List<TableParentExport> lstTParentExport{get;set;}
    public TableValue totalval{get;set;}
    
    private string strFromPlanYear;public string getstrFromPlanYear(){return strFromPlanYear;}public void setstrFromPlanYear(string s){if(s<>null) strFromPlanYear = String.escapeSingleQuotes(s);}
    List<Data> chartData;
    private string strAccOwner;public string getstrAccOwner(){return strAccOwner;}public void setstrAccOwner(string s){if(s<>null) strAccOwner = String.escapeSingleQuotes(s);}
    public Set<string> setUser{get;set;}
    public opportunity dummyOpportunity{get;set;}
    
    String[] OppStages = new String[]{};
    public String[] getOppStages() {
        return OppStages;
    }
        
    public void setOppStages(String[] OppStages) {
        this.OppStages = OppStages;
    }
    private string category;public string getcategory(){return category;}public void setcategory(string s){if(s<>null) category = String.escapeSingleQuotes(s);}
    public Datetime LastLoginDate{get;set;}
    List<Planning_Version__c> lstClosedPlanningVersion;
    public Set<string> lstAccountOption{get;set;}
    public Set<string> lstOpportunityOption{get;set;}
    private string sAccountText;public string getsAccountText(){return sAccountText;}public void setsAccountText(string s){if(s<>null) sAccountText = String.escapeSingleQuotes(s);}
    private string sOpportunityText;public string getsOpportunityText(){return sOpportunityText;}public void setsOpportunityText(string s){if(s<>null) sOpportunityText = String.escapeSingleQuotes(s);}
    
    map<string,set<string>> mapAccount;
    map<string,string> mapOpportunity;
    
    map<string,string> mapPlanningName;
    public pagereference retrieveData(){
        return null;
    }
    map<string,Planning_Version__c> mapMPV;
    public LT_Revenue_Backlog_by_Period_or_Quarter(){
        
        dummyOpportunity = new Opportunity();
        
        setUser = new set<string>();
        if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
	        for(User u : [select Id,Name from User where name <> null and isActive=true limit 100]){
	            setUser.add(u.Name);
	        
	        }
        }
        mapMPV = new map<string,Planning_Version__c>();
        mapPlanningName = new map<string,string>();
        if (Schema.sObjectType.user.fields.Id.isAccessible() && Schema.sObjectType.user.fields.lastloginDate.isAccessible()){
         LastLoginDate = [select id,lastloginDate from user where Id =: userInfo.getUserId() limit 1].lastloginDate;
        }
        category = 'Month';
        string cstatus = string.escapeSingleQuotes('Closed');
        if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
        	lstClosedPlanningVersion = [select id,Name,Version_Status__c,Fiscal_Year_Planning__r.StartDate__c,Data_Entry_Start_Date__c,Planning_Version_Current_Period__c,Planning_Version_Fiscal_Year__c,SequenceNo__c from Planning_Version__c where Version_Status__c =: cStatus limit 100];
        }
        Integer latestYear = 0;
        Integer latestPeriod = 0;
        
        for(Planning_Version__c p : lstClosedPlanningVersion){
            if(latestYear < Integer.valueOf(p.Planning_Version_Fiscal_Year__c)){
                latestYear = Integer.valueOf(p.Planning_Version_Fiscal_Year__c);
            }
            mapPlanningName.put(p.Id,p.Planning_Version_Fiscal_Year__c);
            mapMPV.put(p.Id,p);
        }
        for(Planning_Version__c p : lstClosedPlanningVersion){
            if(latestYear == Integer.valueOf(p.Planning_Version_Fiscal_Year__c)){
                if(latestPeriod < Integer.valueOf(p.SequenceNo__c)){
                    latestPeriod = Integer.valueOf(p.SequenceNo__c);
                }               
            }
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
        	 lstOpportunity = [select id,Name,Account.Name from Opportunity where accountId <> null and Name <> null limit 100];
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
        public Data(String name, Integer data1) {
            this.name = name;
            this.data1 = data1;
        }
    }
    
    public void getPlanningModel(){
    
        if(mapPlanningName.containsKey(strFromPlan))
            strE_FromPlan = mapPlanningName.get(strFromPlan);
        
        
        string cPlanningYear='';
        if(mapMPV.containsKey(strFromPlan)){
            Planning_Version__c sctpv = mapMPV.get(strFromPlan);
            cPlanningYear = 'FY'+sctpv.Planning_Version_Fiscal_Year__c+'P'+sctpv.Planning_Version_Current_Period__c;
        }
            
        //get backlog measure
        map<String,String> mapFMeasureId = new map<String,String>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        for(Planning_Financial_Measure__c  fm : [select id,Name from Planning_Financial_Measure__c where name <> null]){
	            mapFMeasureId.put(fm.Name,fm.Id);
	        } 
        }
        Set<string> setFMeasure = new Set<String>();
        setFMeasure.add(mapFMeasureId.get('Revenue Backlog'));
        
        string query = 'Select id,Amount__c,Planning_Measure__c,Opportunity__r.Legacy__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Fiscal_Quarter__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Period_Name__c, ';
        query += 'Opportunity__r.CloseDate,Opportunity__r.StageName,Opportunity__r.BussinessUnit__c,Opportunity__r.Service_Line__c,Opportunity__r.Division__c,Opportunity__r.Name, opportunity__c,Opportunity__r.Project_Start_Date__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Deal_Duration__c, ';
        query += 'Opportunity__r.Account.Name,Opportunity__r.AccountId ';
        query += 'from Planning_Model__c where Fiscal_Period__c <> null and Planning_Measure__c IN: setFMeasure and Planning_Version__c =: strFromPlan and Fiscal_Period__r.Fiscal_Year__c =: strFromPlanYear';
        
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,':');
        //ApexPages.addMessage(myMsg);
                
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
        
        if(
            strAccOwner <> null && strAccOwner.trim() <> ''
        ){
            query += ' and Opportunity__r.Owner.Name =: strAccOwner ';
        }

        if(OppStages <> null && OppStages.size()>0){
            set<string> setStages = new set<string>();
            for(string s : OppStages){
                setStages.add(s);
            }
            query += ' and Opportunity__r.stageName IN: setStages';
        }
        if(dummyOpportunity.BussinessUnit__c <> null){
        	String dummyOppBusinessUnit=dummyOpportunity.BussinessUnit__c;
            query += ' and Opportunity__r.BussinessUnit__c =:dummyOppBusinessUnit';
        }
        if(dummyOpportunity.Service_Line__c <> null){
        	String dummyOppServiceLine=dummyOpportunity.Service_Line__c;
            query += ' and Opportunity__r.Service_Line__c =:dummyOppServiceLine';
        }
        
        if(dummyOpportunity.Division__c <> null){
        	String dummyOppDivision=dummyOpportunity.Division__c;
            query += ' and Opportunity__r.Division__c = :dummyOppDivision';
        }
        List<Planning_Model__c> lstModel;
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
		&& Schema.sObjectType.Opportunity.fields.BussinessUnit__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Service_Line__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Division__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()
		
		&& Schema.sObjectType.Planning_Model__c.fields.opportunity__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible()
		&& Schema.sObjectType.Account.fields.Name.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()){
		
			lstModel = Database.Query(query);
		} 
        
        lstHeader = new List<Header>();
        lstHeaderExport = new List<Header>();
        lstTParent = new List<TableParent>();       
        chartData = new List<Data>();
        lstTValue = new List<TableValue>();
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
            set<Id> setOppCurrency = new set<Id>();
            
            for(Planning_Model__c m : lstModel){ 
                setOppCurrency.add(m.Opportunity__c);
            }
            if(isMultiCurrencyOrganization){
                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
            }
            
            map<String,Integer> mapHeader = new map<string,Integer>();            
            map<String,Integer> mapFiscalAmount = new map<String,Integer>(); 
            map<String,Planning_Model__c> mapOppModel = new map<String,Planning_Model__c>(); 
            map<string,Integer> mapBacklogAmount = new map<string,Integer>(); 
            if(category == 'Month'){
                for(Planning_Model__c m : lstModel){ 
                    string fromCurrency;
                    fromCurrency = mapcurrency.get(m.Opportunity__c);
                    mapHeader.put(m.Fiscal_Period__r.Name,Integer.valueOf(m.Fiscal_Period__r.Period_Number__c));
                    decimal model_amount = m.Amount__c;
                    if(isMultiCurrencyOrganization)model_amount  = CurrencyConversion.Convert(fromCurrency,DefaultCurrency,m.Amount__c);
                    mapFiscalAmount.put(m.Opportunity__c+'-'+m.Fiscal_Period__r.Name,Integer.valueOf(model_amount));
                    mapOppModel.put(m.Opportunity__c,m);
                    if(cPlanningYear == m.Fiscal_Period__r.Name)mapBacklogAmount.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                } 
            }
            else if(category == 'Quarter'){
                map<string,Integer> mapLastQuarter = new map<string,Integer>();
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put('FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,Integer.valueOf((m.Fiscal_Period__r.Fiscal_Quarter__c).substring(1,2)));
                    mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                    mapOppModel.put(m.Opportunity__c,m);
                    mapLastQuarter.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,0);
                    
                    if(cPlanningYear == m.Fiscal_Period__r.Name)mapBacklogAmount.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                } 
                for(Planning_Model__c m : lstModel){                
                    
                    if(mapLastQuarter.containsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c)){
                        Integer p = mapLastQuarter.get(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c);
                        if(p < m.Fiscal_Period__r.Period_Number__c){
                            mapLastQuarter.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,Integer.ValueOf(m.Fiscal_Period__r.Period_Number__c));
                        }
                    }               
                } 
                
                
                for(Planning_Model__c m : lstModel){                
                    if(mapFiscalAmount.ContainsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c)){
                        if(mapLastQuarter.containsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c)){
                            if(mapLastQuarter.get(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c) == m.Fiscal_Period__r.Period_Number__c){
                                string fromCurrency;
                                fromCurrency = mapcurrency.get(m.Opportunity__c);
                                decimal model_amount = m.Amount__c;
                                if(isMultiCurrencyOrganization)CurrencyConversion.Convert(fromCurrency,DefaultCurrency,m.Amount__c);
                                mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,Integer.valueOf(model_amount));
                            }                       
                        }
                    }
                }       
            }
            
            lstHeader.add(new Header('Account Name',1));
            lstHeader.add(new Header('Opportunity Name',2));
            lstHeader.add(new Header('Project Start Date',3));
            lstHeader.add(new Header('Deal TCV',4));
            lstHeader.add(new Header('Deal Duration',5));
            lstHeader.add(new Header('BackLog Amount',6));
            
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
                o.OppName = m.opportunity__r.Name;
                o.AccName = m.opportunity__r.Account.Name;
                o.OppId = m.opportunity__c;
                o.CurrencyIsoCode = mapcurrency.get(m.Opportunity__c);
                o.CloseDate = m.opportunity__r.closeDate;
                o.AccId = m.opportunity__r.AccountId;
                o.Rdateopp = m.opportunity__r.Project_Start_Date__c;
                o.Contractvalue = m.opportunity__r.Deal_TCV__c;
                o.ContractTerm = (m.opportunity__r.Deal_Duration__c <> null)?Integer.valueOf(m.opportunity__r.Deal_Duration__c):0;
                o.Total = (mapBacklogAmount.ContainsKey(m.Opportunity__c))?mapBacklogAmount.get(m.Opportunity__c):0;
                o.licolor = '#185B95';
                
                if(m.opportunity__r.StageName == 'Closed Won'){
                    if(m.opportunity__r.Legacy__c == 'YES')   o.licolor  = '#398F38';
                    else if(m.opportunity__r.Legacy__c != 'YES') o.licolor  ='#008080';
                }
                
               
                
                o.lstYears = sampYears;
                
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
                decimal Total = 0;
                for(FYears f: sampYears){
                    FYears fy = new FYears();
                    fy.label = f.label;
                    fy.labelNumber = f.labelNumber;
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        fy.value= mapFiscalAmount.get(t.oppId+'-'+f.label); 
                        Total += fy.value;
                    }
                    lstFy.add(fy);
                }
                t.lstYears = lstFy;
                //t.Total = Total;
            }
            
            //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,test);
            //apexpages.addmessage(msg);
            
            //total 
            map<string,Integer> mapTotalAmount = new map<string,Integer>();
            for(TableValue t: lstTValue){
                for(FYears f: t.lstYears){
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        Integer tt = f.value;
                        if(mapTotalAmount.containsKey(f.label)){
                            tt += mapTotalAmount.get(f.label);
                        }
                        mapTotalAmount.put(f.label,tt);                     
                    }
                }
            }
            
            List<FYears> lstY = new List<FYears>();
            for(FYears f:sampYears){
                f.value = mapTotalAmount.get(f.label);
                lstY.add(f);
            }     

            
            totalval.lstYears = lstY;
            
            //chart data
            
            for(FYears f: lstY){
                chartData.add(new Data(f.label, f.value));
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
                double btotal =0;
                string AccountName;
                for(TableValue t :temp ){
                    if(t.Contractvalue <> null)total+=t.Contractvalue;
                    btotal+=t.total;
                    AccountName = t.AccName;
                }
                temp.sort();
                lstTParent.add(new TableParent(AccId,AccountName,temp,count,total,btotal));
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
    
    public class TableValue implements Comparable{
        public String OppName{get;set;}
        public String CurrencyIsoCode{get;set;}
        public String AccName{get;set;}
        public String OppId{get;set;}
        public String AccId{get;set;}
        public Date Closedate{get;set;}
        public Date Rdateopp{get;set;}        
        public Integer ContractTerm{get;set;}
        public Double Contractvalue{get;set;}
        
        public Integer C_Total{get;set;}
        public Double C_Contractvalue{get;set;}
        
        
        public Double Total{get;set;}
        public List<FYears> lstYears{get;set;}
        public string licolor{get;set;}
        public Integer compareTo(Object compareTo) {
            TableValue compareToOppy = (TableValue)compareTo;
            Integer returnValue = 0;
            if (Total > compareToOppy.Total) {
                returnValue = -1;
            } else if (Total < compareToOppy.Total) {
                returnValue = 1;
            }        
        return returnValue; 
        }

    }
    public class TableParent  implements Comparable{
        public String AccId{get;set;}
        public String AccName{get;set;}        
        public List<TableValue> lstTableValue{get;set;}
        public Integer OppCount{get;set;}
        public Double bcklgAccTotal{get;set;}
        public Double OppTotal{get;set;}
        public TableParent(String AccId,String AccName,List<TableValue> lstTableValue,Integer OppCount,Double OppTotal,double bcklgAccTotal){
            this.AccId = AccId;
            this.AccName = AccName;
            this.lstTableValue = lstTableValue;
            this.OppCount = OppCount;
            this.OppTotal = OppTotal;
            this.bcklgAccTotal = bcklgAccTotal;
            
        }
        public Integer compareTo(Object compareTo) {
            TableParent compareToOppy = (TableParent)compareTo;
            Integer returnValue = 0;
            if (bcklgAccTotal > compareToOppy.bcklgAccTotal) {
                returnValue = -1;
            } else if (bcklgAccTotal < compareToOppy.bcklgAccTotal) {
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
    public List<SelectOption> getOpportunityStages() {
        String[] OStages = new String[]{};
        List<SelectOption> options = new List<SelectOption>();
        if (Schema.sObjectType.OpportunityStage.fields.description.isAccessible() && Schema.sObjectType.OpportunityStage.fields.IsClosed.isAccessible()
        && Schema.sObjectType.OpportunityStage.fields.IsWon.isAccessible() && Schema.sObjectType.OpportunityStage.fields.MasterLabel.isAccessible()
        && Schema.sObjectType.OpportunityStage.fields.IsActive.isAccessible()){
	        for(OpportunityStage os : [select description,IsClosed,IsWon,MasterLabel,IsActive from OpportunityStage where isActive = true ]){
	            options.add(new SelectOption(os.MasterLabel,os.MasterLabel));
	            OStages.add(os.MasterLabel);
	        }
        }
        setOppStages(OStages);
        return options;
    }
    
    public class FYears{
        public string label{get;set;}
        public Integer value{get;set;}
        public Integer labelNumber{get;set;}
        public Integer compareTo(Object compareTo) {
            FYears compareToPlan = (FYears)compareTo;
            if (labelNumber == compareToPlan.labelNumber) return 0;
            if (labelNumber > compareToPlan.labelNumber) return 1;
            return -1;        
        }
    }
    public pagereference Export(){
        return page.BackLog_MonthExportv6;
    }
}