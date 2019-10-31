public with sharing class LT_ComparePlanningVersion{

    private string strFromPlan;public string getstrFromPlan(){return strFromPlan;}public void setstrFromPlan(string s){if(s<>null) strFromPlan = String.escapeSingleQuotes(s);}
    private string userCurrencySign;public string getuserCurrencySign(){return userCurrencySign;}public void setuserCurrencySign(string s){if(s<>null) userCurrencySign = String.escapeSingleQuotes(s);}
    private string strQuarter;public string getstrQuarter(){return strQuarter;}public void setstrQuarter(string s){if(s<>null) strQuarter = String.escapeSingleQuotes(s);}
    private string strFromPlan2;public string getstrFromPlan2(){return strFromPlan2;}public void setstrFromPlan2(string s){if(s<>null) strFromPlan2 = String.escapeSingleQuotes(s);}
    private string strE_FromPlan;public string getstrE_FromPlan(){return strE_FromPlan;}public void setstrE_FromPlan(string s){if(s<>null) strE_FromPlan = String.escapeSingleQuotes(s);}
    private string strE_FromPlan2;public string getstrE_FromPlan2(){return strE_FromPlan2;}public void setstrE_FromPlan2(string s){if(s<>null) strE_FromPlan2 = String.escapeSingleQuotes(s);}
    public List<Header> lstHeader{get;set;}
    public List<Header> lstHeaderExport{get;set;}
    public List<TableValue> lstTValue{get;set;}
    public List<TableParent> lstTParent{get;set;}
    public TableValue totalval{get;set;}
    private string strFromPlanYear;public string getstrFromPlanYear(){return strFromPlanYear;}public void setstrFromPlanYear(string s){if(s<>null) strFromPlanYear = String.escapeSingleQuotes(s);}
    List<Data> chartData;
    private string strAccOwner;public string getstrAccOwner(){return strAccOwner;}public void setstrAccOwner(string s){if(s<>null) strAccOwner = String.escapeSingleQuotes(s);}
    public Set<string> setUser{get;set;}
    public opportunity dummyOpportunity{get;set;}
    private string ComMeasure;public string getComMeasure(){return ComMeasure;}public void setComMeasure(string s){if(s<>null) ComMeasure = String.escapeSingleQuotes(s);}
    
    String[] OppStages = new String[]{};
    public List<SelectOption> getFiscalQuarter() {
        List<SelectOption> options = new List<SelectOption>();
        strQuarter = 'All';
        options.add(new selectOption('All','All'));
        for(Integer i=1;i<5;i++){
            options.add(new selectOption('Q'+i,'Q'+i));
        }       
        return options;
    }
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
    
    public map<string,string> mapPlanningName{get;set;}
    public pagereference retrieveData(){
        return null;
    }
    public map<string,Planning_Version__c> mapMPV{get;set;}
    set<string> setSelConStages;
    
    public LT_ComparePlanningVersion(){
        List<Configuration_Setting__c> lstconfStages;
        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
        	lstconfStages = [select Id,Stage__c from Configuration_Setting__c limit 1];
        }
        setSelConStages = new set<string>();
        if(lstconfStages <> null && lstconfStages.size() > 0){                            
            
                                            
            for(Configuration_Setting__c  c : lstconfStages){
                if(c.stage__c <> null && c.stage__c <> ''){
                    for(string s : c.stage__c.split(',')){
                        if(s.trim() <> '')
                        setSelConStages.add(s);
                    }
                }           
            }
        }
                        
        dummyOpportunity = new Opportunity();
        setUser = new set<string>();
        if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
	        for(User u : [select Id,Name from User where Name <> null and isActive=true limit 100]){
	            setUser.add(u.Name);           
	        }
    	}
        mapMPV = new map<string,Planning_Version__c>();
        mapPlanningName = new map<string,string>();
        if (Schema.sObjectType.user.fields.Id.isAccessible() && Schema.sObjectType.user.fields.lastloginDate.isAccessible()){
        	LastLoginDate = [select id,lastloginDate from user where Id =: userInfo.getUserId() limit 1].lastloginDate;
        }
        category = 'Month';
        if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() 
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
       	 lstClosedPlanningVersion = [select id,Name,Version_Status__c,Fiscal_Year_Planning__r.StartDate__c,Data_Entry_Start_Date__c,Planning_Version_Current_Period__c,Planning_Version_Fiscal_Year__c,SequenceNo__c from Planning_Version__c where Version_Status__c = 'Closed' limit 100 ];
   		 }
        //and Is_this_a_Budget_Planning_Version__c = false 

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
                strFromPlan2 = p.Id;
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
        public Integer data2 { get; set; }
        public Data(String name, Integer data1,Integer data2) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
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
        
        if(mapPlanningName.containsKey(strFromPlan2))
            strE_FromPlan2 = mapPlanningName.get(strFromPlan2);
        
        
        string cPlanningYear2='';
        if(mapMPV.containsKey(strFromPlan2)){
            Planning_Version__c sctpv = mapMPV.get(strFromPlan2);
            cPlanningYear2 = 'FY'+sctpv.Planning_Version_Fiscal_Year__c+'P'+sctpv.Planning_Version_Current_Period__c;
        }
            
        //get backlog measure
        map<String,String> mapFMeasureId = new map<String,String>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        for(Planning_Financial_Measure__c  fm : [select id,Name from Planning_Financial_Measure__c where Name <> null]){
	            mapFMeasureId.put(fm.Name,fm.Id);
	        } 
        }
        Set<string> setFMeasure = new Set<String>();
        setFMeasure.add(mapFMeasureId.get('Revenue'));
        
        string query = 'Select id,Amount__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Fiscal_Quarter__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Period_Name__c, Planning_Version__c, ';
        query += 'Opportunity__r.StageName,Opportunity__r.BussinessUnit__c,Opportunity__r.IsWon,Opportunity__r.IsClosed,Opportunity__r.Legacy__c,Opportunity__r.Division__c,Opportunity__r.Name, opportunity__c,Opportunity__r.Project_Start_Date__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Deal_Duration__c, ';
        query += 'Opportunity__r.Account.Name,Opportunity__r.AccountId ';
        query += 'from Planning_Model__c where Fiscal_Period__c <> null and (Planning_Version__c =: strFromPlan or Planning_Version__c =: strFromPlan2) and Fiscal_Period__r.Fiscal_Year__c =: strFromPlanYear ';
        
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
                if(ComMeasure != 'All' && ComMeasure <> null){
                        query += ' and  Planning_Measure__c =: ComMeasure ';
                }

        /*if(OppStages <> null && OppStages.size()>0){
            set<string> setStages = new set<string>();
            for(string s : OppStages){
                setStages.add(s);
            }
            query += ' and Opportunity__r.stageName IN: setStages';
        }*/
        
        if(dummyOpportunity.BussinessUnit__c <> null){
        	String dummyOppBusinessUnit=dummyOpportunity.BussinessUnit__c;
            query += ' and Opportunity__r.BussinessUnit__c = :dummyOppBusinessUnit';
        }
        if(dummyOpportunity.Service_Line__c <> null){
        	String dummyOppServiceLine=dummyOpportunity.Service_Line__c;
            query += ' and Opportunity__r.Service_Line__c =:dummyOppServiceLine';
        }
        if(dummyOpportunity.Division__c <> null){
        	String dummyOppDivision=dummyOpportunity.Division__c;
            query += ' and Opportunity__r.Division__c = :dummyOppDivision';
        }
        if(strQuarter <> 'All' && strQuarter <> null){
            query += ' and Fiscal_Period__r.Fiscal_Quarter__c =: strQuarter ';
        }
        if(strOppCatg != 'All' && strOppCatg <> null){
            query += ' and Opportunity__r.ForecastCategoryName = \''+String.escapeSingleQuotes(strOppCatg)+'\'';
        }
        //system.debug('###:'+strFromPlan+'-'+strFromPlan2+'-'+strFromPlanYear+'-'+ComMeasure+'::'+query);        
        List<Planning_Model__c> lstModel ;
        if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() 
		&& Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()
		&& Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() 
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()
		&& Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Name.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.BussinessUnit__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.IsWon.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.isClosed.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Division__c.isAccessible()
		&& Schema.sObjectType.Planning_Model__c.fields.opportunity__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible()
		&& Schema.sObjectType.Account.fields.Name.isAccessible()
		&& Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
		){
        	lstModel = Database.Query(query);
		}
        lstHeader = new List<Header>();
        lstHeaderExport = new List<Header>();
        lstTParent = new List<TableParent>();
        chartData = new List<Data>();
        map<Id,string> mapcurrency = new map<Id,string>();
        set<Id> setOppCurrency = new set<Id>();
        
        if(!lstModel.isEmpty()){
            for(Planning_Model__c m : lstModel){ 
                setOppCurrency.add(m.Opportunity__c);
            }
            map<String,Integer> mapHeader = new map<string,Integer>();            
            map<String,Integer> mapFiscalAmount = new map<String,Integer>();        
            map<String,Planning_Model__c> mapOppModel = new map<String,Planning_Model__c>(); 
            map<string,Integer> mapBacklogAmount = new map<string,Integer>();
            map<string,Integer> mapBacklogAmount2 = new map<string,Integer>();

            map<string,Integer> mapVersionAmount = new map<string,Integer>();
                
            if(category == 'Month'){
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put(m.Fiscal_Period__r.Name,Integer.valueOf(m.Fiscal_Period__r.Period_Number__c));
                    mapFiscalAmount.put(m.Opportunity__c+'-'+m.Fiscal_Period__r.Name+'-'+m.Planning_Version__c,Integer.valueOf(m.Amount__c));
                    mapOppModel.put(m.Opportunity__c,m);
                    if(cPlanningYear == m.Fiscal_Period__r.Name)mapBacklogAmount.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                    if(cPlanningYear2 == m.Fiscal_Period__r.Name)mapBacklogAmount2.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                    
                    Integer verAmount = Integer.valueOf(m.Amount__c);
                    if(mapVersionAmount.containsKey(m.Opportunity__c+'-'+m.Planning_Version__c)){
                        verAmount += mapVersionAmount.get(m.Opportunity__c+'-'+m.Planning_Version__c);
                    }
                    mapVersionAmount.put(m.Opportunity__c+'-'+m.Planning_Version__c,verAmount);
                } 
            }
            else if(category == 'Quarter'){
                map<string,Integer> mapLastQuarter = new map<string,Integer>();
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put('FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c,Integer.valueOf((m.Fiscal_Period__r.Fiscal_Quarter__c).substring(1,2)));
                    mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c,0);
                    mapOppModel.put(m.Opportunity__c,m);
                    mapLastQuarter.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c,0);
                    
                    if(cPlanningYear == m.Fiscal_Period__r.Name)mapBacklogAmount.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                    if(cPlanningYear2 == m.Fiscal_Period__r.Name)mapBacklogAmount2.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
                    
                    Integer verAmount = Integer.valueOf(m.Amount__c);
                    if(mapVersionAmount.containsKey(m.Opportunity__c+'-'+m.Planning_Version__c)){
                        verAmount += mapVersionAmount.get(m.Opportunity__c+'-'+m.Planning_Version__c);
                    }
                    mapVersionAmount.put(m.Opportunity__c+'-'+m.Planning_Version__c,verAmount);
                } 
                /*for(Planning_Model__c m : lstModel){                
                    
                    if(mapLastQuarter.containsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c)){
                        Integer p = mapLastQuarter.get(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c);
                        if(p < m.Fiscal_Period__r.Period_Number__c){
                            mapLastQuarter.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c,Integer.ValueOf(m.Fiscal_Period__r.Period_Number__c));
                        }
                    }               
                } */
                
                
                for(Planning_Model__c m : lstModel){                
                    Integer verAmount = Integer.valueOf(m.Amount__c);
                    if(mapFiscalAmount.ContainsKey(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c))
                        verAmount += mapFiscalAmount.get(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c);
                    mapFiscalAmount.put(m.Opportunity__c+'-FY'+m.Fiscal_Period__r.Fiscal_Year__c+m.Fiscal_Period__r.Fiscal_Quarter__c+'-'+m.Planning_Version__c,verAmount);
                    
                }       
            }
            
            lstHeader.add(new Header('Account Name',1));
            lstHeader.add(new Header('Opportunity Name',2));
            lstHeader.add(new Header('Revenue Start Date',3));
            lstHeader.add(new Header('Contract Value',4));
            lstHeader.add(new Header('Contract Term',5));
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
            
            
            
            boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
            if(isMultiCurrencyOrganization){
                CurrencyConversion.Initialization();
                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
            }
            
            
            //value
            lstTValue = new List<TableValue>();
            for(string oppId :  mapOppModel.keyset()){
                Planning_Model__c m = mapOppModel.get(oppId);
                decimal total = 0;
                TableValue o = new TableValue();
                o.OppName = m.opportunity__r.Name;
                o.AccName = m.opportunity__r.Account.Name;
                o.OppId = m.opportunity__c;
                o.AccId = m.opportunity__r.AccountId;
                o.Rdateopp = m.opportunity__r.Project_Start_Date__c;
                o.Contractvalue = m.opportunity__r.Deal_TCV__c;
                o.ContractTerm = (m.opportunity__r.Deal_Duration__c <> null)?Integer.valueOf(m.opportunity__r.Deal_Duration__c):0;
                o.Total = (mapBacklogAmount.ContainsKey(m.Opportunity__c))?mapBacklogAmount.get(m.Opportunity__c):0;
                o.Value1 = (mapVersionAmount.ContainsKey(m.Opportunity__c+'-'+strFromPlan))?mapVersionAmount.get(m.Opportunity__c+'-'+strFromPlan):0;
                o.Value2 = (mapVersionAmount.ContainsKey(m.Opportunity__c+'-'+strFromPlan2))?mapVersionAmount.get(m.Opportunity__c+'-'+strFromPlan2):0;
                o.Difference = o.Value1 - o.Value2;
                o.CurrencyIsoCode = mapcurrency.get(m.opportunity__c);
                o.licolor = '#000000'; 
                if(m.Opportunity__r.isWon && m.Opportunity__r.isClosed && setSelConStages.contains(m.Opportunity__r.stageName)){
                    if(m.Opportunity__r.Legacy__c == 'YES'){
                        o.licolor  = '#398F38';
                    }else if(m.Opportunity__r.Legacy__c != 'YES'){
                        o.licolor  ='#008080';
                    }                                       
                }
                //isWon=false,isClose=false,selected 
                else if(!m.Opportunity__r.isWon && !m.Opportunity__r.isClosed && !setSelConStages.contains(m.Opportunity__r.stageName)){o.licolor  = 'orange';}
                //isWon=false,isClose=false,not selected 
                else if(!m.Opportunity__r.isWon && !m.Opportunity__r.isClosed && setSelConStages.contains(m.Opportunity__r.stageName)){o.licolor  = 'blue';}

                
                o.lstYears = sampYears;
                
                lstTValue.add(o);
            }
            
            //apply multicurrency
           
            string DefaultCurrency = userinfo.getDefaultCurrency();
            if(DefaultCurrency == 'USD')userCurrencySign = '$';
            else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
            else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
            else if(DefaultCurrency == 'CAD')userCurrencySign = '$';
            if(isMultiCurrencyOrganization){
                for(TableValue t: lstTValue){
                    t.Contractvalue = CurrencyConversion.Convert(t.CurrencyIsoCode,DefaultCurrency,t.Contractvalue);
                    t.Value1 = CurrencyConversion.Convert(t.CurrencyIsoCode,DefaultCurrency,t.Value1);
                    t.Value2 = CurrencyConversion.Convert(t.CurrencyIsoCode,DefaultCurrency,t.Value2);
                    t.Difference = t.Value1 - t.Value2;
                }
            }
            
            /*
            if(strQuarter <> 'All' && m.Fiscal_Period__c <> null && strQuarter == m.Fiscal_Period__r.Fiscal_Quarter__c)FiscalAmount += m.Amount__c;
                        else if(strQuarter == 'All') FiscalAmount += m.Amount__c;
            */
            
            
            string test = '';
            
            for(TableValue t: lstTValue){
                List<FYears> lstFy = new List<FYears>();
                decimal Total = 0;
                for(FYears f: sampYears){
                    FYears fy = new FYears();
                    fy.label = f.label;
                    fy.labelNumber = f.labelNumber;
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label+'-'+strFromPlan)){
                        fy.value= mapFiscalAmount.get(t.oppId+'-'+f.label+'-'+strFromPlan); 
                        Total += fy.value;
                    }
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label+'-'+strFromPlan2)){
                        fy.value2= mapFiscalAmount.get(t.oppId+'-'+f.label+'-'+strFromPlan2); 
                        Total += fy.value2;
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
            map<string,Integer> mapTotalAmount2 = new map<string,Integer>();
            for(TableValue t: lstTValue){
                for(FYears f: t.lstYears){
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label+'-'+strFromPlan)){
                        Integer tt = f.value;
                        if(mapTotalAmount.containsKey(f.label+'-'+strFromPlan)){
                            tt += mapTotalAmount.get(f.label+'-'+strFromPlan);
                        }
                        mapTotalAmount.put(f.label+'-'+strFromPlan,tt);     
                    }
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label+'-'+strFromPlan2)){
                        Integer tt = f.value2;
                        if(mapTotalAmount.containsKey(f.label+'-'+strFromPlan2)){
                            tt += mapTotalAmount.get(f.label+'-'+strFromPlan2);
                        }
                        mapTotalAmount.put(f.label+'-'+strFromPlan2,tt);    
                    }
                }
            }
            
            List<FYears> lstY = new List<FYears>();
            for(FYears f:sampYears){
                f.value = mapTotalAmount.get(f.label+'-'+strFromPlan);
                f.value2 = mapTotalAmount.get(f.label+'-'+strFromPlan2);
                lstY.add(f);
            }     

            totalval = new TableValue();
            totalval.AccName = 'Total';
            totalval.lstYears = lstY;
            
            //chart data
            
            for(FYears f: lstY){
                chartData.add(new Data(f.label, f.value,f.value2));
            } 
            
            
            //remove periods/quarters
            /*for(TableValue t: lstTValue){
                List<FYears> lstFy = new List<FYears>();
                for(FYears f: sampYears){
                    if(f.labelNumber <= 5){
                        lstFy.add(f);
                    }
                }
                t.lstYears = lstFy;
            }*/
            
            
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
                double p1total =0;
                double p2total =0;
                string AccountName;
                for(TableValue t :temp ){
                    if(t.Contractvalue <> null)total+=t.Contractvalue;
                    btotal+=t.total;
                    AccountName = t.AccName;
                    p1total += t.value1;
                    p2total += t.value2;
                }
                temp.sort();
                lstTParent.add(new TableParent(AccId,AccountName,temp,count,total,btotal,p1total,p2total));
            }

            
            
        } 

        lstTParent.sort();
        
        
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
            if(strFromPlan2 == null) {strFromPlan2 = cp.Id+'';strE_FromPlan2 = cp.Name;}
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
        public string CurrencyIsoCode{get;set;}
        public String OppName{get;set;}
        public String AccName{get;set;}
        public String OppId{get;set;}
        public String AccId{get;set;}
        public Date Rdateopp{get;set;}
        public Double Contractvalue{get;set;}
        public Double Value1{get;set;}
        public Double Value2{get;set;}
        public Double Difference{get;set;}
        public Integer ContractTerm{get;set;}
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
        public Double p1total{get;set;}
        public Double p2total{get;set;}
        public Double p1p2diff{get;set;}
        public Double OppTotal{get;set;}
        public TableParent(String AccId,String AccName,List<TableValue> lstTableValue,Integer OppCount,Double OppTotal,double bcklgAccTotal,Double p1total,Double p2total){
            this.AccId = AccId;
            this.AccName = AccName;
            this.lstTableValue = lstTableValue;
            this.OppCount = OppCount;
            this.OppTotal = OppTotal;
            this.bcklgAccTotal = bcklgAccTotal;
            this.p1total = p1total;
            this.p2total = p2total;
            this.p1p2diff = p1total-p2total;
            
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
        
        public List<SelectOption> getCompaireMeasure() {
                ComMeasure  = 'All';
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('All','All')); 
                if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){     
	                for(Planning_Financial_Measure__c  fm : [select id,Name from Planning_Financial_Measure__c where Name = 'Booking Adjustment' or Name = 'Revenue Adjustment' or Name = 'Revenue' or Name = 'Sales Booking' or Name = 'Gap Mitgation' ]){
	                        options.add(new SelectOption(fm.Id,fm.Name));
	        		 }
                } 		
        return options;
    }
    
    public class FYears{
        public string label{get;set;}
        public string version{get;set;}
        public Integer value{get;set;}
        public Integer value2{get;set;}
        public Integer labelNumber{get;set;}
        public Integer compareTo(Object compareTo) {
            FYears compareToPlan = (FYears)compareTo;
            if (labelNumber == compareToPlan.labelNumber) return 0;
            if (labelNumber > compareToPlan.labelNumber) return 1;
            return -1;        
        }
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
    
    public pagereference Export(){
        return page.ComparePlanningVersionExport;
    }
}