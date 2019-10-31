public with sharing class LT_Total_Backlog_by_Roles{

   
    public map<string,string> headers { get { return apexpages.currentpage().getheaders(); } set; }
    private string userCurrencySign;public string getuserCurrencySign(){return userCurrencySign;}public void setuserCurrencySign(string s){if(s<>null) userCurrencySign = String.escapeSingleQuotes(s);}

    public PageReference Export() {
        return page.Backlog_by_Role_Export;
    }

    private string strroles;public string getstrroles(){return strroles;}public void setstrroles(string s){if(s<>null) strroles = String.escapeSingleQuotes(s);}

    private string strFromPlan;public string getstrFromPlan(){return strFromPlan;}public void setstrFromPlan(string s){if(s<>null) strFromPlan = String.escapeSingleQuotes(s);}
    private string strRole;public string getstrRole(){return strRole;}public void setstrRole(string s){if(s<>null) strRole = String.escapeSingleQuotes(s);}
    private string strAccOwner;public string getstrAccOwner(){return strAccOwner;}public void setstrAccOwner(string s){if(s<>null) strAccOwner = String.escapeSingleQuotes(s);}
    
    
    private string strE_FromPlan;public string getstrE_FromPlan(){return strE_FromPlan;}public void setstrE_FromPlan(string s){if(s<>null) strE_FromPlan = String.escapeSingleQuotes(s);}
    public List<Header> lstHeader{get;set;}
    public List<Header> lstHeaderExport{get;set;}
    public List<TableValue> lstTValue{get;set;}
    public TableValue totalval{get;set;}
    private string strFromPlanYear;public string getstrFromPlanYear(){return strFromPlanYear;}public void setstrFromPlanYear(string s){if(s<>null) strFromPlanYear = String.escapeSingleQuotes(s);}
    List<Data> chartData;    
    
    private string category;public string getcategory(){return category;}public void setcategory(string s){if(s<>null) category = String.escapeSingleQuotes(s);}
    public Datetime LastLoginDate{get;set;}
    List<Planning_Version__c> lstClosedPlanningVersion;
    public Set<string> lstAccountOption{get;set;}
    public Set<string> lstOpportunityOption{get;set;}
    private string sAccountText;public string getsAccountText(){return sAccountText;}public void setsAccountText(string s){if(s<>null) sAccountText = String.escapeSingleQuotes(s);}
    private string sOpportunityText;public string getsOpportunityText(){return sOpportunityText;}public void setsOpportunityText(string s){if(s<>null) sOpportunityText = String.escapeSingleQuotes(s);}
    
    map<string,set<string>> mapAccount;
    map<string,set<string>> mapRole;
    map<string,set<string>> mapOwner;
    map<string,opportunity> mapOpportunity;
    
    String closingPeriod;
    
    map<string,opportunity> mapAccount_Opp;
    map<string,opportunity> mapOwner_Opp;
    map<string,opportunity> mapRole_Opp;
    
    public Set<string> setRole{get;set;}
    public Set<string> setUser{get;set;}
    
    map<Id,UserRole> mapRole_R;
    map<Id,Set<Id>> mapchild;
    map<Id,Set<Id>> mapparent;
    
    map<string,Planning_Version__c> mapPlanningName;
    public pagereference retrieveData(){
        return null;
    }
    public LT_Total_Backlog_by_Roles(){
    
        userCurrencySign = '$';
        setRole = new set<string>();
        setUser = new set<string>();
        
        
        mapRole_R = RoleHierarchyUtility.getORGRoles();
        mapchild = RoleHierarchyUtility.getChilds(mapRole_R);
        mapparent =  RoleHierarchyUtility.getParents(mapRole_R);
        
        map<Id,boolean> setUsers = new map<Id,boolean>();
         if (Schema.sObjectType.user.fields.UserRoleId.isAccessible()){
	        for(User u: [select UserRoleId from user where IsActive = true]){           
	            if(u.UserRoleId <> null)setUsers.put(u.UserRoleId,true);
	        
	    	}
         }
        for(UserRole u : mapRole_R.values()){
            if(setUsers.containskey(u.id)){
                setRole.add(u.Name);
            }
        }
        mapPlanningName = new map<string,Planning_Version__c>();
         if (Schema.sObjectType.user.fields.Id.isAccessible() && Schema.sObjectType.user.fields.lastloginDate.isAccessible()){
        	LastLoginDate = [select id,lastloginDate from user where Id =: userInfo.getUserId() limit 1].lastloginDate;
         }
        category = 'Month';
         if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
         && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()
         && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
         && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
        	lstClosedPlanningVersion = [select id,Name,Version_Status__c,Fiscal_Year_Planning__r.StartDate__c,Data_Entry_Start_Date__c,Planning_Version_Current_Period__c, Planning_Version_Fiscal_Year__c,SequenceNo__c from Planning_Version__c where Version_Status__c = 'Closed' ];
         }
        Integer latestYear = 0;
        Integer latestPeriod = 0;
        
        for(Planning_Version__c p : lstClosedPlanningVersion){
            if(latestYear < Integer.valueOf(p.Planning_Version_Fiscal_Year__c)){
                latestYear = Integer.valueOf(p.Planning_Version_Fiscal_Year__c);                
            }
            mapPlanningName.put(p.Id,p);
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
         && Schema.sObjectType.Account.fields.Name.isAccessible() ){
       		 lstOpportunity = [select id,Name,Account.Name,Account.Owner.Name,Account.Owner.UserRole.Name from Opportunity where name <> null];
         }
        mapAccount = new map<string,set<string>>();
        mapOpportunity = new map<string,opportunity>();
        mapAccount_Opp = new map<string,opportunity>();
        mapOwner_Opp = new map<string,opportunity>();
        mapRole_Opp = new map<string,opportunity>();
        
        mapRole = new map<string,set<String>>();
        mapOwner = new map<string,set<String>>();
        for(Opportunity opp : lstOpportunity){
            lstOpportunityOption.add(opp.Name);
            lstAccountOption.add(opp.Account.Name);
            //setRole.add(opp.Account.Owner.UserRole.Name);
            setUser.add(opp.Account.Owner.Name);  
            mapOpportunity.put(opp.Name,opp);
            mapAccount_Opp.put(opp.Account.Name,opp);
            mapOwner_Opp.put(opp.Account.Owner.Name,opp);
            mapRole_Opp.put(opp.Account.Owner.UserRole.Name,opp);
            
            mapAccount.put(opp.Account.Name,new Set<String>());
            
            mapRole.put(opp.Account.Owner.UserRole.Name,new Set<String>());
            mapOwner.put(opp.Account.Owner.Name,new Set<String>());
        }
        for(Opportunity opp : lstOpportunity){
            if(mapAccount.ContainsKey(opp.Account.Name)){
                Set<string> setTemp = mapAccount.get(opp.Account.Name);
                setTemp.add(opp.Name);
                mapAccount.put(opp.Account.Name,setTemp);
            }
            if(mapRole.ContainsKey(opp.Account.Owner.UserRole.Name)){
                Set<string> setTemp = mapRole.get(opp.Account.Owner.UserRole.Name);
                setTemp.add(opp.Account.Owner.Name);
                mapRole.put(opp.Account.Owner.UserRole.Name,setTemp);
            }
            if(mapOwner.ContainsKey(opp.Account.Owner.Name)){
                Set<string> setTemp = mapOwner.get(opp.Account.Owner.Name);
                setTemp.add(opp.Account.Name);
                mapOwner.put(opp.Account.Owner.Name,setTemp);
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
    
        
        
        if(mapPlanningName.containsKey(strFromPlan)){
            strE_FromPlan = mapPlanningName.get(strFromPlan).Name;
            closingPeriod = 'FY'+mapPlanningName.get(strFromPlan).Planning_Version_Fiscal_Year__c+'P'+mapPlanningName.get(strFromPlan).Planning_Version_Current_Period__c;
        }
            
        //get backlog measure
        map<String,String> mapFMeasureId = new map<String,String>();
         if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        for(Planning_Financial_Measure__c   fm : [select id,Name from Planning_Financial_Measure__c where name <> null]){
	            mapFMeasureId.put(fm.Name,fm.Id);
	        } 
         }
        
        Set<string> setFMeasure = new Set<String>();
        setFMeasure.add(mapFMeasureId.get('Revenue Backlog'));
        
        string query = 'Select id,Amount__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Fiscal_Quarter__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Period_Name__c, ';
        query += 'Opportunity__r.Name, opportunity__r.Legacy__c,opportunity__r.StageName,opportunity__c,Opportunity__r.Project_Start_Date__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Deal_Duration__c, ';
        query += 'Opportunity__r.Account.Name,Opportunity__r.AccountId,Opportunity__r.Account.Owner.Id,Opportunity__r.Account.Owner.Name,Opportunity__r.Account.Owner.UserRole.Id,Opportunity__r.Account.Owner.UserRole.Name ';
        query += 'from Planning_Model__c where Fiscal_Period__c <> null and Planning_Measure__c IN: setFMeasure and Planning_Version__c =: strFromPlan ';
        
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,':');
        //ApexPages.addMessage(myMsg);
                
        //0001
        if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
                query += ' and Opportunity__r.Name =: sOpportunityText ';
                if(mapOpportunity.ContainsKey(sOpportunityText)){
                    opportunity opp = mapOpportunity.get(sOpportunityText);     
                    strRole = opp.Account.Owner.UserRole.Name;
                    strAccOwner = opp.Account.Owner.Name;
                    sAccountText = opp.account.Name;
                }
             
        }
        //0010
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            
            if(mapAccount_Opp.ContainsKey(sAccountText)){
                opportunity opp = mapAccount_Opp.get(sAccountText);     
                strRole = opp.Account.Owner.UserRole.Name;
                strAccOwner = opp.Account.Owner.Name;
            }
            
            lstOpportunityOption.Clear();       
            
            if(mapAccount.containsKey(sAccountText)){                
                for(String opp: mapAccount.get(sAccountText)){
                    lstOpportunityOption.add(opp);                                  
                }
            } 
        }
        //0011
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        //0100
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            if(mapOwner_Opp.ContainsKey(strAccOwner)){
                opportunity opp = mapOwner_Opp.get(strAccOwner);    
                strRole = opp.Account.Owner.UserRole.Name;
            }

            lstAccountOption.clear();
            lstOpportunityOption.Clear();           

            if(mapOwner.containsKey(strAccOwner)){                
                for(String acc: mapOwner.get(strAccOwner)){
                    lstAccountOption.add(acc);
                    if(mapAccount.containsKey(acc)){                
                        for(String opp: mapAccount.get(acc)){
                            lstOpportunityOption.add(opp);                                  
                        }
                    } 
                }
            } 
                

        }
        //0101
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
            
        }
        //0110
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            
            if(mapOwner_Opp.ContainsKey(strAccOwner)){
                opportunity opp = mapOwner_Opp.get(strAccOwner);    
                strRole = opp.Account.Owner.UserRole.Name;
            }
            
            lstOpportunityOption.clear();
            if(mapAccount.containsKey(sAccountText)){                
                for(String opp: mapAccount.get(sAccountText)){
                    lstOpportunityOption.add(opp);                                  
                }
            }
            
        }
        //0111
        else if(
            (strRole == null || strRole.trim() == '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        //1000
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            
            setUser.clear(); 
            lstAccountOption.clear();
            lstOpportunityOption.Clear();           
            if(mapRole.containsKey(strRole)){                
                for(String owner: mapRole.get(strRole)){
                    setUser.add(owner);
                    if(mapOwner.containsKey(owner)){                
                        for(String acc: mapOwner.get(owner)){
                            lstAccountOption.add(acc);
                            if(mapAccount.containsKey(acc)){                
                                for(String opp: mapAccount.get(acc)){
                                    lstOpportunityOption.add(opp);                                  
                                }
                            } 
                        }
                    } 
                }
            } 
        }
        //1001
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        //1010
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
        }
        //1011
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner == null || strAccOwner.trim() == '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        //1100
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            

            lstAccountOption.clear();
            lstOpportunityOption.Clear();           

            if(mapOwner.containsKey(strAccOwner)){                
                for(String acc: mapOwner.get(strAccOwner)){
                    lstAccountOption.add(acc);
                    if(mapAccount.containsKey(acc)){                
                        for(String opp: mapAccount.get(acc)){
                            lstOpportunityOption.add(opp);                                  
                        }
                    } 
                }
            }       
        }
        //1101
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText == null || sAccountText.trim() == '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
        }
        //1110
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText == null || sOpportunityText.trim() == '') 
        )
        {
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            
            lstOpportunityOption.clear();
            if(mapAccount.containsKey(sAccountText)){                
                for(String opp: mapAccount.get(sAccountText)){
                    lstOpportunityOption.add(opp);                                  
                }
            }
        }
        //1111
        else if(
            (strRole <> null && strRole.trim() <> '') &&
            (strAccOwner <> null && strAccOwner.trim() <> '') &&
            (sAccountText <> null && sAccountText.trim() <> '') && 
            (sOpportunityText <> null && sOpportunityText.trim() <> '') 
        ){
            query += ' and Opportunity__r.Account.Owner.UserRole.Name =: strRole ';
            query += ' and Opportunity__r.Account.Owner.Name =: strAccOwner ';
            query += ' and Opportunity__r.Account.Name =: sAccountText ';
            query += ' and Opportunity__r.Name =: sOpportunityText ';
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
			&& Schema.sObjectType.Opportunity.fields.Name.isAccessible()
			&& Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()
			&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
			&& Schema.sObjectType.Planning_Model__c.fields.opportunity__c.isAccessible()
			&& Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
			&& Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
			&& Schema.sObjectType.Account.fields.Name.isAccessible()
			&& Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
			 ){
       			 lstModel = Database.Query(query);
			 }
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,lstModel.size()+'::'+lstModel);
        //ApexPages.addMessage(myMsg);
        
        lstHeader = new List<Header>();
        lstHeaderExport = new List<Header>();
        lstTValue = new List<TableValue>();
        lstTValue.sort();
        strroles = '';
        set<Id> setOppCurrency = new set<Id>();
        string DefaultCurrency = userinfo.getDefaultCurrency();
        if(DefaultCurrency == 'USD')userCurrencySign = userCurrencySign;
        else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
        else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
        else if(DefaultCurrency == 'CAD')userCurrencySign = userCurrencySign;
        boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
        map<Id,string> mapcurrency = new  map<Id,string>();
        
           
        if(!lstModel.isEmpty() && lstModel.size()>0){
            
            for(Planning_Model__c m : lstModel){ 
                setOppCurrency.add(m.Opportunity__c);
            }
            if(isMultiCurrencyOrganization){
                CurrencyConversion.Initialization();
                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
            }
            
            map<String,Integer> mapHeader = new map<string,Integer>();            
            map<String,Integer> mapFiscalAmount = new map<String,Integer>(); 
            map<String,Planning_Model__c> mapOppModel = new map<String,Planning_Model__c>(); 
            
            map<string,Integer> mapClosingPeriod = new map<string,Integer>();
            
                
            for(Planning_Model__c m : lstModel){                
                mapClosingPeriod.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
            }
            for(Planning_Model__c m : lstModel){     
                if(closingPeriod == m.Fiscal_Period__r.Name)
                    mapClosingPeriod.put(m.Opportunity__c,Integer.valueOf(m.Amount__c));
            }
                
            if(category == 'Month'){
                for(Planning_Model__c m : lstModel){                
                    mapHeader.put(m.Fiscal_Period__r.Name,Integer.valueOf(m.Fiscal_Period__r.Period_Number__c));
                    string fromCurrency;
                    fromCurrency = mapcurrency.get(m.Opportunity__c);
                    decimal model_amount = m.Amount__c;
                    if(isMultiCurrencyOrganization)CurrencyConversion.Convert(fromCurrency,DefaultCurrency,m.Amount__c);
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

            lstHeader.add(new Header('Role',-2));
            lstHeader.add(new Header('Account Owner',-1));
            lstHeader.add(new Header('Account Name',0));
            lstHeader.add(new Header('Opportunity Name',1));
            lstHeader.add(new Header('Revenue Start Date',2));
            lstHeader.add(new Header('Contract Value',3));
            lstHeader.add(new Header('Contract Term',4));
            lstHeader.add(new Header('Backlog Amount',5));
            
            
            
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
                if(h.labelNumber > 5){                  
                    FYears fy = new FYears();
                    fy.label = h.label;
                    fy.labelNumber = h.labelNumber;
                    sampYears.add(fy);
                }
            }
            
            
            //remove periods/quarters
            List<Header> lstHeader_temp = new List<Header>();
            for(Header h : lstHeader){
                if(h.labelNumber != 5)lstHeaderExport.add(h);
                if(h.labelNumber <= 5){                     
                    lstHeader_temp.add(h);
                }
            }
            
            lstHeader.clear();
            lstHeader.addAll(lstHeader_temp);
            map<string,Integer> mapRecordCount = new map<string,Integer>();
            map<string,string> mapRecordTotal = new map<string,string>();
            
            //value            
            for(string oppId :  mapOppModel.keyset()){
                Planning_Model__c m = mapOppModel.get(oppId);
                decimal total = 0;
                TableValue o = new TableValue();
                o.Role = m.opportunity__r.Account.Owner.UserRole.Name;
                o.AccountOwner = m.opportunity__r.Account.Owner.Name;
                o.RoleId = m.opportunity__r.Account.Owner.UserRole.Id;
                o.AccountOwnerId = m.opportunity__r.Account.Owner.Id;
                mapRecordCount.put(o.AccountOwnerId,0);
                mapRecordTotal.put(o.AccountOwnerId,'0');
                o.OppName = m.opportunity__r.Name;
                o.AccName = m.opportunity__r.Account.Name;
                o.OppId = m.opportunity__c;
                o.OppColor = '#1E5FB2';
                o.userCurrencySign = userCurrencySign;
                if(m.opportunity__r.StageName == 'Closed Won' && m.opportunity__r.Legacy__c == 'YES')o.OppColor = '#398F38';
                if(m.opportunity__r.StageName == 'Closed Won' && m.opportunity__r.Legacy__c != 'YES')o.OppColor = '#008080';
                
                o.AccId = m.opportunity__r.AccountId;
                o.Rdateopp = m.opportunity__r.Project_Start_Date__c; 
                o.Contractvalue = m.opportunity__r.Deal_TCV__c;
                if(isMultiCurrencyOrganization){
                    o.Contractvalue = CurrencyConversion.Convert(mapcurrency.get(m.opportunity__c),DefaultCurrency,m.opportunity__r.Deal_TCV__c);
                }               
                
                o.ContractTerm = (m.opportunity__r.Deal_Duration__c <> null)?Integer.valueOf(m.opportunity__r.Deal_Duration__c):0;
                o.Total = total;
                if(mapClosingPeriod.ContainsKey(oppId)){
                    o.ClosingTotal = mapClosingPeriod.get(oppId);
                }
                else{
                    o.ClosingTotal = 0;
                }
                
                
                Datetime dt = o.Rdateopp;
                if(o.Rdateopp <> null) o.S_Rdateopp = dt.format('MM/dd/yyyy');
                if(o.Contractvalue <> null){
                    Decimal rA = o.Contractvalue;
                    List<String> args = new String[]{'0','number','###,###,###,###'};
                    o.S_Contractvalue = userCurrencySign+String.format(rA.format(), args);
                }
                //o.lstYears = sampYears;                
                lstTValue.add(o);
            }
            
            
            string test = '';
            lstTValue.sort();
            for(TableValue t: lstTValue){
                List<FYears> lstFy = new List<FYears>();
                for(FYears f: sampYears){
                    FYears fy = new FYears();
                    fy.label = f.label;
                    fy.labelNumber = f.labelNumber;
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        fy.value = mapFiscalAmount.get(t.oppId+'-'+f.label); 
                     }
                     lstFy.sort();
                    lstFy.add(fy);
                }
                if(mapRecordCount.ContainsKey(t.AccountOwnerId)){
                    Integer count = mapRecordCount.get(t.AccountOwnerId);
                    count++;
                    mapRecordCount.put(t.AccountOwnerId,count);
                }
                t.lstYears = lstFy;
            }
            
            //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,test);
            //apexpages.addmessage(msg);
            
            //total 
            map<string,Integer> mapTotalAmount = new map<string,Integer>();
            integer ln = 0;
            for(TableValue t: lstTValue){
                decimal total = 0;
                for(FYears f: t.lstYears){
                    if(mapFiscalAmount.containsKey(t.oppId+'-'+f.label)){
                        Integer tt = f.value;
                        if(ln < f.labelNumber){ln = f.labelNumber;total = f.value;}
                        if(mapTotalAmount.containsKey(f.label)){
                            tt += mapTotalAmount.get(f.label);
                        }
                        mapTotalAmount.put(f.label,tt);                     
                    }
                }
                t.Total = total;
                if(mapRecordTotal.ContainsKey(t.AccountOwnerId)){
                    Decimal tt = Decimal.ValueOf(mapRecordTotal.get(t.AccountOwnerId));
                    tt += t.ClosingTotal;
                    //tt += t.Total;
                    mapRecordTotal.put(t.AccountOwnerId,tt+'');
                }
                
                if(t.Total <> null){
                    Decimal rA = t.Total;
                    List<String> args = new String[]{'0','number','###,###,###,###'};
                    t.S_Total = userCurrencySign+String.format(rA.format(), args);
                }
                
                if(t.ClosingTotal <> null){
                    Decimal rA = t.ClosingTotal;
                    List<String> args = new String[]{'0','number','###,###,###,###'};
                    t.S_ClosingTotal = userCurrencySign+String.format(rA.format(), args);
                }
            }
            
            List<FYears> lstY = new List<FYears>();
            for(FYears f:sampYears){
                f.value = mapTotalAmount.get(f.label);
                lstY.add(f);
            }     

            totalval = new TableValue();
            totalval.Role = 'Total';
            totalval.lstYears = lstY;
            
            //chart data
            chartData = new List<Data>();
            for(FYears f: lstY){
                chartData.add(new Data(f.label, f.value));
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
            }
            */
            
            //Tree View
            
            
            map<string,List<TableValue>> mapOwner = new map<string,List<TableValue>>();
           decimal GrandTotal =0;
            for(string wId : mapRecordTotal.keyset()){
                Decimal rA = Decimal.ValueOf(mapRecordTotal.get(wId));
                GrandTotal += rA;
                List<String> args = new String[]{'0','number','###,###,###,###'};
                string st  = userCurrencySign+String.format(rA.format(), args);
                mapRecordTotal.put(wId,st);
            }
            for(TableValue t: lstTValue){
                mapOwner.put(t.RoleId,new List<TableValue>()); 
            }
            lstTValue.sort();
            for(TableValue t: lstTValue){
                
                if(mapOwner.containsKey(t.RoleId)){
                    List<TableValue> lstt = mapOwner.get(t.RoleId);
                    lstt.add(t);
                    mapOwner.put(t.RoleId,lstt); 
                }
                             
            }
            List<String> args = new String[]{'0','number','###,###,###,###'};
            string gtotal  = userCurrencySign+String.format(GrandTotal.format(), args);
            NestedTreeDemo(mapOwner,mapRecordCount,mapRecordTotal,gtotal);
        }   

        
        
        
    }
    
    public map<string,string> RoleHeaderWidthMap{get;set;}
    public map<string,string> RoleFooterWidthMap{get;set;}
    public Integer RoleHeaderWidth{get;set;}
    public void NestedTreeDemo(map<string,List<TableValue>> mapOwner,map<string,Integer> mapRecordCount,map<string,string> mapRecordTotal,string gtotal) {
        

        RoleHeaderWidthMap = new map<string,string>();
        RoleFooterWidthMap = new map<string,string>();
        Integer count = 1;
        strroles  = '';

        
        map<string,boolean> mapIsChild = new map<string,boolean>();
        for(Id rid : mapRole_R.keyset()){
            mapIsChild.put(rid,false);
        }
        
        for(Id rid : mapOwner.keyset()){
            mapIsChild.putAll(RoleHierarchyUtility.getIsChild(rId,mapRole_R,mapchild,mapIsChild));
        }
        String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');

        for(Id rId : mapparent.keySet()){
            string s='<ul><li>';
            if(mapparent.ContainsKey(rId)){
                RoleHierarchyUtility.getDepth(mapRole_R,mapchild,mapparent.get(rId),count+'');
                if(mapparent.get(rId).size() > 0 && mapIsChild.get(rid)){
                    s += RoleHierarchyUtility.getRoles2(rId,mapRole_R,mapchild,'<span><i class="icon-minus-sign"></i>'+mapRole_R.get(rId).Name+'</span>',mapparent.get(rId),count+'',mapOwner,mapIsChild,mapRecordCount,mapRecordTotal,userAgent);
                }
                count++;
            }
            s+='</li></ul>';
            strroles += s;
        }
        
        string strRole = '<table>';
        for(string pcId : mapOwner.keyset()){
            List<TableValue> tlist = mapOwner.get(pcId);
            tlist.sort();
            integer Rcount = 1;
            string AccountOwner = '';
            for(TableValue t : tlist){
                AccountOwner = t.AccountOwner;
                if(Rcount == 1){
                    strRole += '<tr><td colspan="7" style="height:15px;"></td></tr>';
                    strRole += '<tr style="border-bottom: 1px solid black;">';                            
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:130px;">Owner</td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:150px;">Account</td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:250px;">Opportunity </td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:110px;">Revenue Start Date</td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:90px;">Contract value</td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:95px;">Contract Term</td>';
                        strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:100px;">Backlog Amount</td>';
                    strRole += '</tr>';
                    strRole += '<tr><td colspan="7"></td></tr>';
                }
                strRole += '<tr>';                            
                    strRole += '<td style="width:130px;">'+t.AccountOwner+'</td>';
                    strRole += '<td style="width:150px;">'+t.AccName+'</td>';
                    strRole += '<td style="width:250px;">'+t.OppName+'</td>';
                    strRole += '<td style="width:110px;text-align:right;">'+t.S_Rdateopp+'</td>';
                    strRole += '<td style="width:90px;text-align:right;">'+t.S_Contractvalue+'</td>';
                    strRole += '<td style="width:95px;text-align:right;">'+t.ContractTerm+'</td>';
                    strRole += '<td style="width:100px;text-align:right;">'+t.s_ClosingTotal+'</td>';
                strRole += '</tr>';
                if(mapRecordCount.get(t.AccountOwnerId) == Rcount){
                    Rcount = 0;
                    strRole += '<tr style="border-top: 1px solid black;">';                            
                        strRole += '<td colspan="4"></td>';
                        strRole += '<td colspan="2" style="font-weight:bold;text-align:right">'+AccountOwner+' Total</td>';
                        strRole += '<td colspan="1" style="width:80px;font-weight:bold;text-align:right">'+mapRecordTotal.get(t.AccountOwnerId)+'</td>';
                    strRole += '</tr>';
                    strRole += '<tr><td colspan="7"></td></tr>';
                }
                Rcount++;
                
            }
        }
                    
                strRole += '</table>';
                
       // strroles = strRole;
        
        Integer mleft = 45;
        
        if (userAgent <> null && userAgent.contains('Mobile'))mleft  = 30;
                
        RoleHeaderWidthMap.put('Role',(RoleHierarchyUtility.RoleDepth*mleft)+'px');
        RoleHeaderWidthMap.put('Account Owner','150px');
        RoleHeaderWidthMap.put('Account Name','150px');
        RoleHeaderWidthMap.put('Opportunity Name','330px');
        RoleHeaderWidthMap.put('Revenue Start Date','80px');
        RoleHeaderWidthMap.put('Contract Value','80px');
        RoleHeaderWidthMap.put('Contract Term','80px');
        RoleHeaderWidthMap.put('Backlog Amount','100px');
        RoleHeaderWidth = (RoleHierarchyUtility.RoleDepth*mleft)+990;
        
        
        RoleFooterWidthMap.put('Role','');
        RoleFooterWidthMap.put('Account Owner','');
        RoleFooterWidthMap.put('Account Name','');
        RoleFooterWidthMap.put('Opportunity Name','');
        RoleFooterWidthMap.put('Revenue Start Date','');
        RoleFooterWidthMap.put('Contract Value','');
        RoleFooterWidthMap.put('Contract Term','Grand Total');
        RoleFooterWidthMap.put('Backlog Amount',gtotal);
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
    
}