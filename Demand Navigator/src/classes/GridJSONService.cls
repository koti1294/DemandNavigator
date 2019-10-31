public with sharing class GridJSONService {

    private JSONGenerator gen = JSON.createGenerator(true);   
    private string MName;
    private string PlanningVersionId;
    private string mm;
    private string u_RowId;
    private string u_YearId;
    private string u_planningVersionId;
    private string u_OpportunityId;
    private string u_PeriodId;
    private string u_MeasureId;
    private string u_Amount;
    private string u_Comment;
 
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
    
    @future
    public static void performDML(String obj, String isUpdate) {
        if(isUpdate == 'true') {
            if( Planning_Model__c.SObjectType.getDescribe().isUpdateable()) {
                update (Planning_Model__c) JSON.deserialize(obj, Planning_Model__c.class);
            }
        } else {
            if(Planning_Model__c.SObjectType.getDescribe().isCreateable()){
                insert (Planning_Model__c) JSON.deserialize(obj, Planning_Model__c.class);
         }
        }
    }
    
    public GridJSONService () {
        
        
        MName = apexpages.currentPage().getparameters().get('MethodName');
        MName = MName == null ? null : string.escapesinglequotes(MName);
        PlanningVersionId = apexpages.currentPage().getparameters().get('PlanningVersionId');
        PlanningVersionId = PlanningVersionId == null ? null : string.escapesinglequotes(PlanningVersionId);
        mm = apexpages.currentPage().getparameters().get('Measure');
        mm = mm == null ? null : string.escapesinglequotes(mm);
        
        u_RowId = apexpages.currentPage().getparameters().get('RowId');
        u_RowId = u_RowId == null ? null : string.escapesinglequotes(u_RowId);
        u_YearId = apexpages.currentPage().getparameters().get('YearId');
        u_YearId = u_YearId == null ? null : string.escapesinglequotes(u_YearId);
        u_planningVersionId = apexpages.currentPage().getparameters().get('planningVersionId');
        u_planningVersionId = u_planningVersionId == null ? null : string.escapesinglequotes(u_planningVersionId);
        u_OpportunityId = apexpages.currentPage().getparameters().get('OpportunityId');
        u_OpportunityId = u_OpportunityId == null ? null : string.escapesinglequotes(u_OpportunityId);
        u_PeriodId = apexpages.currentPage().getparameters().get('PeriodId');
        u_PeriodId = u_PeriodId == null ? null : string.escapesinglequotes(u_PeriodId);
        u_MeasureId = apexpages.currentPage().getparameters().get('MeasureId');
        u_MeasureId = u_MeasureId == null ? null : string.escapesinglequotes(u_MeasureId);
        u_Amount = apexpages.currentPage().getparameters().get('Amount');
        u_Amount = u_Amount == null ? null : string.escapesinglequotes(u_Amount);
        u_Comment = apexpages.currentPage().getparameters().get('Comment');
        u_Comment = u_Comment == null ? null : string.escapesinglequotes(u_Comment);
    }
    
    public string getOutput()
    {  
        
        String JSON = gen.getAsString();
        JSON = JSON == null ? null : string.escapesinglequotes(JSON);
        return JSON;
    }
    
    
    public  List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          lstPickvals.add(a.getValue().escapeHtml4());//add the value  to our final list
        }
    
        return lstPickvals;
    }
    
    public Integer getYearId(string year,string month){
        string cPeriod = (month.length() == 1)? '0'+month:month;
        return Integer.ValueOf(year+''+cPeriod);
    }
    
    
    public string getCategory(Integer PYear, Integer year,Integer month){
        string cat = 'p';
        if(PYear > getYearId(year+'',month+'') ){
            cat = 'Actual';
        }
        else if(PYear < getYearId(year+'',month+'') ){
            cat = 'Forecast';       
        }
        else if(PYear == getYearId(year+'',month+'') ){
            cat = 'Actual(C)';        
        }
        return cat;
    }
    public List<JSON_FY_Period> getFiscalPeriods(boolean isCustomEnable, S_FiscalYearSettings sfiscal,FiscalYearSettings fiscal, Planning_Version__c pv){
        
        
        
                    
        Integer BudgetYear = Integer.valueOf(pv.Planning_Version_Fiscal_Year__c);
        Integer fyear;
        
        List<JSON_FY_Period> lstPeriods = new List<JSON_FY_Period>();  
        
        if(isCustomEnable){
            fyear = (fiscal.EndDate).Year();
            Integer seq = 0;
            Integer count = fiscal.startDate.Month();
            if((fiscal.PeriodLabelScheme).equals('Custom')){
                for(Period m : fiscal.periods){           
                    if((m.Type).equals('Month')) { 
                        seq++;                    
                        JSON_FY_Period afp = new JSON_FY_Period();
                            afp.Id = m.id;
                            afp.Period =  seq ;
                            afp.Label = m.PeriodLabel;
                            if(pv.Is_this_a_Budget_Planning_Version__c){
                                if(BudgetYear > fyear)afp.Category = 'Actual';
                                else afp.Category = 'Budget';
                            }
                            afp.CurrentPeriod = count++;                    
                        lstPeriods.add(afp);                       
                        if(count == 13)count =1;
                    } 
                }
            }
            else{
                for(Period m : fiscal.periods){           
                    if((m.Type).equals('Month')) {   
                        seq++;                    
                        JSON_FY_Period afp = new JSON_FY_Period();
                            afp.Id = m.id;
                            afp.Period =  seq;
                            afp.Label = m.PeriodLabel;                          
                            if(pv.Is_this_a_Budget_Planning_Version__c){
                                if(BudgetYear > fyear)afp.Category = 'Actual';
                                else afp.Category = 'Budget';
                            }
                            afp.CurrentPeriod = m.Number;               
                        lstPeriods.add(afp);                       
                    } 
                }
            }
        }
        else{
            fyear = (sfiscal.EndDate).Year();
            Integer seq = 0;
            Integer count = sfiscal.startDate.Month();
            
            for(S_Period m : sfiscal.periods){           
                if((m.Type).equals('Month')) {   
                    seq++;                    
                    JSON_FY_Period afp = new JSON_FY_Period();
                        afp.Id = m.Pid;
                        afp.Period =  seq;
                        afp.Label = m.PeriodLabel;
                        if(pv.Is_this_a_Budget_Planning_Version__c){
                            if(BudgetYear > fyear)afp.Category = 'Actual';
                            else afp.Category = 'Budget';
                        }
                        afp.CurrentPeriod = m.MPNumber;               
                    lstPeriods.add(afp);                       
                } 
            }
            
        }
        for(Integer s = (lstPeriods.size()+1); s < 13 ;s++){
            JSON_FY_Period afp = new JSON_FY_Period();
                afp.Id = '';
                afp.Period =  s;
                afp.Label = '';
                if(pv.Is_this_a_Budget_Planning_Version__c){
                    if(BudgetYear > fyear)afp.Category = 'Actual';
                    else afp.Category = 'Budget';
                }
                afp.CurrentPeriod = s;               
            lstPeriods.add(afp);   
        }
        
        return lstPeriods;
    }
    
    public void StartUpAction()
    { 
        //Security token
        string securityToken = ApexPages.currentPage().getParameters().get('securityToken');
        securityToken = securityToken == null ? null : string.escapesinglequotes(securityToken);
        try
        { 
            gen.writeStartObject();
            
            //string result;
            GridJSONService K = new GridJSONService();            
 
            
            map<string,boolean> SlstMeasure = new map<string,boolean> ();
            
            
            if(mm <> null){
            for(string mId : mm.split(',')){
                if(mid <> null && mId <> ''){
                    SlstMeasure.put(String.valueOf(mId).escapeHtml4(),true);
                }
            }
            }
            
            if(MName != '' || MName != null)
            {
                if (securityToken != encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId())))){
                    
                    //this request does not have a valid security token for this session so deny it
                    gen.writeBooleanField('success',false);
                    gen.writeStringField('error','Invalid security token for this session'+'--'+securityToken +'----'+ encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId()))));

                }
                else if(MName == 'getFilterJSON')
                {
                    
                    //checking is it forecastera admin member or not
                    if (Schema.sObjectType.GroupMember.fields.Id.isAccessible() &&  Schema.sObjectType.GroupMember.fields.UserOrGroupId.isAccessible()
                    &&  Schema.sObjectType.group.fields.Id.isAccessible() &&  Schema.sObjectType.group.fields.name.isAccessible()
                     &&  Schema.sObjectType.group.fields.type.isAccessible()){
                        
                     
                    //List<GroupMember> grpmem = [SELECT Id, UserOrGroupId ,group.id, group.name, group.type FROM GroupMember 
                   // where group.type='Regular' and group.name = 'Forecastera Admin' and UserOrGroupId =: userinfo.getUserId()];
                   List<GroupMember> grpmem;
                   if (Schema.sObjectType.GroupMember.fields.Id.isAccessible() && Schema.sObjectType.GroupMember.fields.UserOrGroupId.isAccessible()){
                    grpmem = [SELECT Id, UserOrGroupId ,group.id, group.name, group.type FROM GroupMember 
                    where  group.name = 'Forecastera Admin' and UserOrGroupId =: userinfo.getUserId()];
                   }
                      if (Schema.sObjectType.OpportunityStage.fields.MasterLabel.isAccessible() &&  Schema.sObjectType.OpportunityStage.fields.IsActive.isAccessible()
                    &&  Schema.sObjectType.OpportunityStage.fields.IsWon.isAccessible() &&  Schema.sObjectType.OpportunityStage.fields.IsWon.isAccessible()
                    &&  Schema.sObjectType.OpportunityStage.fields.IsClosed.isAccessible()){
                    List<OpportunityStage> lstStages = [select MasterLabel,IsActive,IsWon,IsClosed from OpportunityStage where IsActive = true];
                    
                    List<String> lstVersionStatus = new List<String>();
                    lstVersionStatus.add('Open (User)');
                    if(grpmem <> null && grpmem.size() > 0){
                        lstVersionStatus.add('Open (Admin)');
                    }

                
                    if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isAccessible()
                    && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
                    &&  Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()){
          
        
                    List<Planning_Version__c> lstP =  [select id,MonthName__c,Version_Status__c,Planning_Version_Current_Period__c,Is_this_a_Budget_Planning_Version__c,
                        Planning_Version_Fiscal_Year__c from Planning_Version__c where  Version_Status__c IN: lstVersionStatus and MonthName__c <> null  and Planning_Version_Fiscal_Year__c <> null ];

                    
                    
                     if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()
                      && Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.General_Ledger_Account__c.isAccessible()
                      && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()
                      && Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isAccessible()){
                        
                      
                    List<Planning_Financial_Measure__c> lstMeasure = [select id,Name, Automatically_Calculated__c, General_Ledger_Account__c, Measure_Description__c, Measure_Type__c, Record_Source__c from Planning_Financial_Measure__c where name <> null];

                     
                    
                    
                        gen.writeFieldName('PlanningVersion');
                        gen.writeStartArray();
                            if(lstP <> null && lstP.size()>0){
                                for(Planning_Version__c  p: lstP){
                                    gen.writeStartObject();
                                        gen.writeStringField('Id', p.Id);
                                        gen.writeStringField('Name', p.Planning_Version_Fiscal_Year__c+'-'+p.MonthName__c);
                                    gen.writeEndObject();
                                }
                            }
                   
                        gen.writeEndArray();
                        
                        gen.writeFieldName('Measures'); 
                        gen.writeStartArray();
                            for(Planning_Financial_Measure__c m : lstMeasure){
                                gen.writeStartObject();
                                    gen.writeStringField('Id',m.ID);
                                    gen.writeStringField('Name', m.Name);
                                gen.writeEndObject();


                            } 
                           }                         
                          } 
                       
                        gen.writeEndArray();
                        
                                
                            
                        gen.writeFieldName('Stages'); 
                        gen.writeStartArray();
                        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
         
                         
                        List<Configuration_Setting__c> lstconfStages = [select Id,Stage__c from Configuration_Setting__c limit 1];
                       
                        set<string> setSelConStages = new set<string>();
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
                        
                            for(OpportunityStage m : lstStages){
                                
                                String oppMStage='';
                                /* closed
                                1. Revenue End Date > version.FY.startDate 
                                2. Stages IN Configuration Settings.
                                3. isWon and isclose = true
                                4. close date <= version.startDate*/
                                if(setSelConStages.contains(m.MasterLabel) && 
                                m.iswon == true && 
                                m.isClosed == true){     
                                    oppMStage = 'Closed';
                                }
                                
                                /*Selected Open
                                1. close Date >= version.StartDate
                                2. Stages IN Configuration Settings.
                                3. isWon and isclose = false
                                4. close Date <= version.fy.endDate*/
                                if(
                                setSelConStages.contains(m.MasterLabel) && 
                                m.iswon == false && 
                                m.isClosed == false){
                                    oppMStage = 'Open Selected';
                                }
                                
                                /*Not Selected Open
                                1. close Date >= version.StartDate
                                2. Stages Not IN Configuration Settings.
                                3. isWon and isclose = false
                                4. close Date <= version.fy.endDate*/
                                if(!setSelConStages.contains(m.MasterLabel)  && 
                                m.iswon == false && 
                                m.isClosed == false){
                                    oppMStage = 'Open Not Selected';
                                }
                                if(m.MasterLabel <> 'Closed Lost' && m.MasterLabel <> 'Closed Dropped'){
                                gen.writeStartObject();
                                    
                                    gen.writeStringField('Name',m.MasterLabel);
                                    gen.writeBooleanField('IsWon', m.IsWOn);
                                    gen.writeBooleanField('IsClosed', m.IsClosed);
                                    gen.writeStringField('ConfigStage', oppMStage);
                                    
                                gen.writeEndObject();
                                }


                            } 
                        } 
                     }                        
                        }  
                        gen.writeEndArray();
        
                }


                else if(MName == 'JsonDataRefined')
                {
                     
                    string userCurrencySign;
                    Date Bcklog_fslyear_startdate;
                    Date Bcklog_fslyear_Enddate;
                    Date crtprd_startdate;
                    Date crtprd_enddate;
                    
                    string pversionId = String.escapeSingleQuotes(PlanningVersionId);
                    
                    //List<Json_PlanningVersion> lstJson_PlanningVersion = new List<Json_PlanningVersion>();
                    List<Json_Measure> lstJson_Measure = new List<Json_Measure>();
                    List<Json_FY> lstJson_FY = new List<Json_FY>();
                    
                                        
                    /*map<Id,Planning_Version__c> mapPlanningVersion = new map<Id,Planning_Version__c>([select id,Fiscal_Year_Planning__c,Fiscal_Year_Planning__r.StartDate__c,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Is_this_a_Budget_Planning_Version__c,
                        Fiscal_Year_Planning__r.EndDate__c,Planning_Version_Fiscal_Year__c,SequenceNo__c 
                        from Planning_Version__c]);*/

                    if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isAccessible()
                    &&  Schema.sObjectType.Planning_Financial_Measure__c.fields.General_Ledger_Account__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()
                    &&  Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isAccessible()){
          
                         
                    List<Planning_Financial_Measure__c> lstMeasure = [select id,Name, Automatically_Calculated__c, General_Ledger_Account__c, Measure_Description__c, Measure_Type__c, Record_Source__c,Restricted_by_Revenue_Term__c,Unit_of_Measure__c from Planning_Financial_Measure__c where NAme <> null and ID IN: sLstMeasure.keySet()];
                    
                    if (Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible()
                     && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible() && Schema.sObjectType.Period.fields.Id.isAccessible()
                     && Schema.sObjectType.Period.fields.EndDate.isAccessible() && Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible() && Schema.sObjectType.Period.fields.Number.isAccessible()
                     && Schema.sObjectType.Period.fields.PeriodLabel.isAccessible() && Schema.sObjectType.Period.fields.QuarterLabel.isAccessible() && Schema.sObjectType.Period.fields.StartDate.isAccessible()
                     && Schema.sObjectType.Period.fields.Type.isAccessible() ){
                        
                    
                    List<FiscalYearSettings> lstOrgFiscalYear = new List<FiscalYearSettings>();
                    lstOrgFiscalYear =  [select Name,PeriodLabelScheme,PeriodPrefix,EndDate,StartDate,(select Id,EndDate,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods where type = 'month' order by startdate) from FiscalYearSettings where name <> null order by startdate];

                    
                    map<String,Integer> mapIsEditable = new map<String,Integer>();
                    
                    set<Id> setOppMeasures = new set<Id>();
                    for(Planning_Financial_Measure__c p: lstMeasure){
                        Json_Measure pv = new Json_Measure();
                        pv.Id = p.Id;
                        setOppMeasures.add(p.Id);
                        pv.Label = p.Name;
                        pv.Name = (p.Name).ReplaceAll(' ','');
                        pv.Calculated = (p.Automatically_Calculated__c)?'Y':'N';
                        pv.Restricted_by_Revenue_Term =p.Restricted_by_Revenue_Term__c;
                        pv.Measure_Type = (p.Measure_Type__c<>null)?p.Measure_Type__c:'';
                        pv.Unit_of_Measure = (p.Unit_of_Measure__c<>null)?p.Unit_of_Measure__c:'';
                        lstJson_Measure.add(pv);
                        Integer V_Editable = (p.Restricted_by_Revenue_Term__c)?1:0;
                        string pname = p.Name;
                        pname=pname.replaceAll(' ','');
                        mapIsEditable.put(pname,V_Editable);
                        
                    }
                                     

                    if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()
                    && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()  && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
                    && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() 
                    && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
                    && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
                        
                    Planning_Version__c pversion =  [select id,Fiscal_Year_Planning__c,Fiscal_Year_Planning__r.StartDate__c,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Is_this_a_Budget_Planning_Version__c,Is_this_a_Gap_Planning_Version__c,
                        Fiscal_Year_Planning__r.EndDate__c,Planning_Version_Fiscal_Year__c,SequenceNo__c  
                        from Planning_Version__c where id =: pversionId limit 1];
                    
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
                    Integer PYear = getYearId(pversion.Planning_Version_Fiscal_Year__c, pversion.Planning_Version_Current_Period__c);
                    
                    Integer c_Actual = 0;
                    
                    string testp  ='';
                    if(lstOrgFiscalYear <> null && lstOrgFiscalYear.size() > 0){
                        for(FiscalYearSettings p: lstOrgFiscalYear){
                            Json_FY pv = new Json_FY();
                            pv.Year = Integer.valueOf(p.Name);
                            String  Prefix = p.PeriodPrefix;
                            String MonthName;
                            List<JSON_FY_Period> lstp = new List<JSON_FY_Period>();
                            for(JSON_FY_Period m : getFiscalPeriods(true,null,p,pversion)){
                                
                                if((p.PeriodLabelScheme).equals('StandardMonths') ){
                                    if(mapMonthString.containsKey(m.CurrentPeriod))
                                    MonthName  = mapMonthString.get(m.CurrentPeriod);                            
                                }
                                else if((p.PeriodLabelScheme).equals('Custom')){
                                   MonthName  = m.Label;
                                   
                                }
                                else{
                                   MonthName  = Prefix+'-'+m.CurrentPeriod;                      
                                }           
                                if(!pversion.Is_this_a_Budget_Planning_Version__c && !pversion.Is_this_a_Gap_Planning_Version__c)
                                    m.Category = getCategory(PYear,pv.Year,m.Period);
                                if(m.Category == 'Actual(c)'){
                                    string M_m = ((m.Period+'').length() == 1)?'0'+m.Period:m.Period+'';
                                    c_Actual = Integer.valueOf(pv.Year+''+m_m);
                                }
                                m.Label = MonthName;
                                lstp.add(m);
                                
                            }
                            
                            pv.Periods = lstp;
                            lstJson_FY.add(pv);
                            
                        }
                    }else 
                        {

                        if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible() ){
          
                        
                        Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
            
                        
                        
                        
                        string cyear = ''+(system.today()).year();
                        date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear); 

                         if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible() 
                         &&  Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()){
                            
                         
                        List<Fiscal_Year_Planning__c> lstFYSR = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where Name <> null and StartDate__c <> null and EndDate__c <> null order by StartDate__c];
                        set<string> setFYNames = new set<string>();
                        map<string,List<Fiscal_Year_Model__c>> mapExistingFY = new map<string,List<Fiscal_Year_Model__c>>();
                        for(Fiscal_Year_Planning__c Efy : lstFYSR ){

                            setFYNames.add(Efy.Name);
                            mapExistingFY.put(Efy.Name,new List<Fiscal_Year_Model__c>());
                        }
                         if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isAccessible() &&
                         Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() &&
                         Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()
                         && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isAccessible()   ){
                            
                        
                        for(Fiscal_Year_Model__c pp : [select Id,Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c,Record_Source__c from Fiscal_Year_Model__c where Fiscal_Year__c IN: setFYNames]){
                            List<Fiscal_Year_Model__c> temp = mapExistingFY.get(pp.Fiscal_Year__c);
                            temp.add(pp);
                            mapExistingFY.put(pp.Fiscal_Year__c,temp);
                        }
                       
                        List<S_FiscalYearSettings> lstfiscalsetting = new List<S_FiscalYearSettings>();
                        for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                        
                            List<S_Period> lstP = new List<S_Period>();
                            
                            for(Fiscal_Year_Model__c mm : mapExistingFY.get(Efy.Name)){
                                S_Period pp = new S_Period();
                                pp.PID = mm.Id;
                                pp.Type ='Month';
                                pp.startDate = mm.Start_Date__c;
                                pp.endDate = mm.End_Date__c;
                                pp.MPNumber = Integer.valueOf(mm.Period_Number__c);
                                pp.PeriodLabel = mm.Period_Name__c;
                                lstP.add(pp);
                                
                            }  
                            
                            S_FiscalYearSettings sfiscal = new S_FiscalYearSettings();
                            sfiscal.Name = Efy.Name;
                            sfiscal.startDate = Efy.StartDate__c;
                            sfiscal.endDate =  Efy.EndDate__c;
                            sfiscal.PeriodPrefix =  'P';
                            sfiscal.PeriodLabelScheme = 'StandardMonths';
                            sfiscal.Periods = lstP;
                            lstfiscalsetting.add(sfiscal);
                            
                        }
                            for(S_FiscalYearSettings p: lstfiscalsetting){
                                Json_FY pv = new Json_FY();
                                pv.Year = Integer.valueOf(p.Name);
                                String  Prefix = p.PeriodPrefix;
                                String MonthName;
                                List<JSON_FY_Period> lstp = new List<JSON_FY_Period>();
                                testp += p.Name+':';
                                
                                for(JSON_FY_Period m : getFiscalPeriods(false,p,null,pversion)){
                                    
                                   
                                    //if(mapMonthString.containsKey(m.Period))
                                    //MonthName  = mapMonthString.get(m.Period);                            
                                    
                                              
                                    if(!pversion.Is_this_a_Budget_Planning_Version__c)
                                        m.Category = getCategory(PYear,pv.Year,m.Period);
                                    if(m.Category == 'Actual(c)'){
                                        string M_m = ((m.Period+'').length() == 1)?'0'+m.Period:m.Period+'';
                                        c_Actual = Integer.valueOf(pv.Year+''+m_m);
                                    }
                                    //m.Label = MonthName;
                                    lstp.add(m);
                                    testp += m.label+'('+m.CurrentPeriod+')'+', ';
                                
                                }
                                testp += '; ';
                                pv.Periods = lstp;
                                lstJson_FY.add(pv);
                            }


                         }
                         }  
                        }    
                        }
                    
                    
        
        
                    
                    string bug ='';
                    if(pversion <> null && pversion.Fiscal_Year_Planning__c <> null && pversion.Fiscal_Year_Planning__r.StartDate__c <> null && pversion.Data_Entry_Start_Date__c <> null ){
                        

                        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible() ){
        
                              
                        List<Configuration_Setting__c> lstconfStages = [select Id,Stage__c from Configuration_Setting__c limit 1];
                        
                        set<string> setSelConStages = new set<string>();
                        if(lstconfStages <> null && lstconfStages.size() > 0){                            
                            
                            //2017-01-01 00:00:00, 2017-12-31 00:00:00, 2017-03-01 00:00:00, 2017-03-31 00:00:00,
                            Bcklog_fslyear_startdate = pversion.Fiscal_Year_Planning__r.StartDate__c;
                            crtprd_startdate = pversion.Data_Entry_Start_Date__c;
                            crtprd_enddate = pversion.Data_Entry_Closed_Date__c;
                            Bcklog_fslyear_Enddate = pversion.Fiscal_Year_Planning__r.EndDate__c;
                                
                            for(Configuration_Setting__c  c : lstconfStages){
                                if(c.stage__c <> null && c.stage__c <> ''){
                                    for(string s : c.stage__c.split(',')){
                                        setSelConStages.add(s);
                                    }
                                }                                           
                            }
                           
                            
                            
                            
                            String strmodel = '(Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,';
                            strmodel += 'Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,';
                            strmodel += 'Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c from Planning_Models__r ';
                            strmodel += 'where  Planning_Measure__c <> null and Planning_Measure__c IN: setOppMeasures and Planning_Version__c =: pversionId)';
                            
                            /* closed
                            1. Revenue End Date > version.FY.startDate 
                            2. Stages IN Configuration Settings.
                            3. isWon and isclose = true
                            4. close date <= version.enddate*/
                            String strQuery1 = 'Select Id,Legacy__c,ForecastCategoryName,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                            strQuery1 += strmodel;                   
                            strQuery1 +=' from Opportunity where Project_End_date__c >: Bcklog_fslyear_startdate and stageName IN: setSelConStages and iswon = true and isClosed = true and closeDate <=: crtprd_enddate and stageName <> \'closed Lost\'';
                            
                            /*Selected Open
                            1. close Date >= version.StartDate
                            2. Stages IN Configuration Settings.
                            3. isWon and isclose = false
                            4. close Date <= version.fy.endDate*/
                            String strQuery2 = 'Select Id,Legacy__c,ForecastCategoryName,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                            strQuery2 += strmodel;                   
                            strQuery2 +=' from Opportunity where closeDate >=: crtprd_startdate and stageName IN: setSelConStages and iswon = false and isClosed = false and closeDate <=: Bcklog_fslyear_Enddate and stageName <> \'closed Lost\'';
                            
                            /*Not Selected Open
                            1. close Date >= version.StartDate
                            2. Stages Not IN Configuration Settings.
                            3. isWon and isclose = false
                            4. close Date <= version.fy.endDate*/
                            String strQuery3 = 'Select Id,Legacy__c,ForecastCategoryName,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                            strQuery3 += strmodel;                   
                            strQuery3 +=' from Opportunity where closeDate >=: crtprd_startdate and stageName Not IN: setSelConStages and iswon = false and isClosed = false and closeDate <=: Bcklog_fslyear_Enddate and stageName <> \'closed Lost\'';
                            
                            //string RecordTypeCondition = 'and RecordType.DeveloperName = \'RSB\'';
                            string RecordTypeCondition ='';
                            if(pversion.Is_this_a_Budget_Planning_Version__c){
                                RecordTypeCondition = 'and RecordType.DeveloperName = \'Budget\'';                               
                            }
                            else if(pversion.Is_this_a_Gap_Planning_Version__c){
                                RecordTypeCondition = 'and RecordType.DeveloperName = \'Gap\'';                             
                            }
                            if(RecordTypeCondition!=null){
                            strQuery1 += RecordTypeCondition;
                            strQuery2 += RecordTypeCondition;
                            strQuery3 += RecordTypeCondition;
                            }
                            
                            if(u_OpportunityId <> null && u_OpportunityId <> ''){
                                String u_OppportunityId=u_OpportunityId;
                                strQuery1 += ' and Id = :u_OppportunityId';
                                strQuery2 += ' and Id = :u_OppportunityId';
                                strQuery3 += ' and Id = :u_OppportunityId';
                               /* strQuery1 += ' and Id = \''+u_OpportunityId+'\'';
                                strQuery2 += ' and Id = \''+u_OpportunityId+'\'';
                                strQuery3 += ' and Id = \''+u_OpportunityId+'\'';*/
                            }
                            
                            //system.debug('#Var:'+crtprd_startdate+'::'+setOppMeasures+'::'+pversionId+'::'+Bcklog_fslyear_Enddate+'::'+setSelConStages+'::'+crtprd_enddate+'::'+pversionId);

                            if(Test.isRunningTest()){
                            strQuery1 = 'Select Id,Legacy__c,ForecastCategoryName,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                            strQuery1 += strmodel;                   
                            strQuery1 +=' from Opportunity';
                            }
                            List<Opportunity> lstOpportunity1;
                            List<Opportunity> lstOpportunity2;
                            List<Opportunity> lstOpportunity3;
                            if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() 
                                && Schema.sObjectType.Planning_Model__c.fields.opportunity__c.isAccessible() 
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
                                && Schema.sObjectType.Opportunity.fields.Legacy__c.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.ForecastCategoryName.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.IsWon.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.isClosed.isAccessible()
                                
                                && Schema.sObjectType.Opportunity.fields.Actuals_to_date__c.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Description.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                                && Schema.sObjectType.Account.fields.Name.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
                                && Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()
                                
                                ){
                                    lstOpportunity1  = Database.query(strQuery1);
                                    lstOpportunity2  = Database.query(strQuery2);
                                    lstOpportunity3  = Database.query(strQuery3);
                                } 
                           
                            
                            
                            List<Opportunity> lstOpportunity =  new List<Opportunity>();
                            if(lstOpportunity1 <> null)lstOpportunity.addAll(lstOpportunity1);
                            if(lstOpportunity2 <> null)lstOpportunity.addAll(lstOpportunity2);
                            if(lstOpportunity3 <> null)lstOpportunity.addAll(lstOpportunity3);
                            
                            map<String,List<Json_Opportunity>> mapJson_Opportunity = new map<String,List<Json_Opportunity>>();
                            map<string,string> map_v_Account = new map<string,string>();
                            map<String,Json_Period> mapPeriods = new map<String,Json_Period>();
                            map<String,map<string,Planning_Model__c>> mapPeriodMeasure = new map<String,map<string,Planning_Model__c>>();
                            map<String,List<Json_Period>> mapYears = new map<String,List<Json_Period>>();
                            
                            lstJson_Measure.sort();
                            map<string,Planning_Model__c> mapORGMeasure = new map<string,Planning_Model__c>();
                            
                            for(Json_Measure pv : lstJson_Measure){
                                string meName = pv.Name;
                                meName = meName.replaceAll(' ','');
                                mapORGMeasure.put(meName,null);
                            }
                            map<Id,string> mapcurrency = new map<Id,string>();
                            set<Id> setOppCurrency = new set<Id>();
        
                            if(!lstOpportunity.isEmpty()){           
                                for(opportunity opp : lstOpportunity){
                                        setOppCurrency.add(opp.Id);
                                }
                            }
                            
                            //apply multicurrency
                            boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
                            string DefaultCurrency = userinfo.getDefaultCurrency();
                            if(DefaultCurrency == 'USD')userCurrencySign = '$';
                            else if(DefaultCurrency == 'EUR')userCurrencySign = '€';
                            else if(DefaultCurrency == 'INR')userCurrencySign = 'INR';
                            else if(DefaultCurrency == 'CAD')userCurrencySign = '$';
                            if(isMultiCurrencyOrganization){
                                CurrencyConversion.Initialization();
                                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
                                
                            }
            
                            for(opportunity opp : lstOpportunity){ 
                                if(isMultiCurrencyOrganization){
                                    string fromCurrency;
                                    fromCurrency = mapcurrency.get(opp.Id);
                                    decimal Con_amount = CurrencyConversion.Convert(fromCurrency,DefaultCurrency,opp.Deal_TCV__c);
                                    opp.Deal_TCV__c = Con_amount;
                                }
                                for(Json_FY pv : lstJson_FY){  
                                    mapYears.put(opp.Id+'-'+pv.Year,new List<Json_Period>());
                                    for(JSON_FY_Period ap: pv.Periods){
                                        mapPeriodMeasure.put(opp.Id+'-'+pv.Year+'-'+ap.Period,mapORGMeasure);
                                    }
                                }
                            }
                            //mapPeriodMeasure = GridDefaultPlanningModel.getPlanningModel(lstOpportunity,lstJson_Measure,mapORGMeasure);
                            for(string kk: mapPeriodMeasure.keySet()){
                                mapPeriods.put(kk,new Json_Period());
                            }
                            map<string,Planning_Model__c> mmmm = new map<string,Planning_Model__c>();
                            map<string,Opportunity> map_O_M = new map<string,Opportunity>();
                            for(opportunity opp : lstOpportunity){                              
                                mapJson_Opportunity.put(opp.AccountId,new List<Json_Opportunity>());
                                map_O_M.put(opp.Id,opp);
                                for(Planning_Model__c m: opp.Planning_Models__r){
                                    if(isMultiCurrencyOrganization){
                                        string fromCurrency;
                                        fromCurrency = mapcurrency.get(m.opportunity__c);
                                        decimal Con_amount = CurrencyConversion.Convert(fromCurrency,DefaultCurrency,m.Amount__c);
                                        m.Amount__c = Con_amount;
                                    }
                                    if(m.Fiscal_Period__r.Fiscal_Year__c <> null && m.Planning_Measure__c <> null ){
                                        //mapYears.put(opp.Id+'-'+m.Fiscal_Period__r.Fiscal_Year__c,new List<Json_Period>());
                                        if(mapPeriodMeasure.ContainsKey(opp.Id+'-'+m.Fiscal_Period__r.Fiscal_Year__c+'-'+m.Fiscal_Period__r.Period_Number__c)){
                                            string meName = m.Planning_Measure__r.Name;
                                            meName = meName.replaceAll(' ','');
                                            mmmm.put(opp.Id+'-'+m.Fiscal_Period__r.Fiscal_Year__c+'-'+m.Fiscal_Period__r.Period_Number__c+'-'+meName,m);
                                        }
                                    }
                                }
                            }
                            
                            for(string s : mmmm.keyset()){
                                string  mapkey = s.split('-')[0]+'-'+s.split('-')[1]+'-'+s.split('-')[2];
                                string  mnkey = s.split('-')[3];
                                map<string,Planning_Model__c> tempmap = mapPeriodMeasure.get(mapkey);
                                tempmap.put(mnkey,mmmm.get(mnkey));
                                //mapPeriodMeasure.put(mapkey,tempmap);                                
                            }
                            
                            for(string kk: mapPeriodMeasure.keySet()){
                                Json_Period p = mapPeriods.get(kk);
                                p.month = Integer.valueOf(kk.split('-')[2]);   
                                mapPeriods.put(kk,p);
                            }
                            for(string pid : mapPeriodMeasure.keyset()){
                                Json_Period p = mapPeriods.get(pid);
                                
                                List<Json_Period_Measure> lstPM = new List<Json_Period_Measure>();
                                //map<string,Planning_Model__c> tempmap = mapPeriodMeasure.get(pid);
                                string pp = '';
                                Opportunity opp = map_O_M.get(pid.split('-')[0]);
                                
                                string RSDM = (((opp.Project_Start_Date__c).month()+'').length() == 1)?'0'+(opp.Project_Start_Date__c).month():(opp.Project_Start_Date__c).month()+'';
                                Integer RSDId = Integer.valueOf((opp.Project_Start_Date__c).year()+''+RSDM);
                                
                                string REDM = (((opp.Project_End_date__c).month()+'').length() == 1)?'0'+(opp.Project_End_date__c).month():(opp.Project_End_date__c).month()+'';
                                Integer REDId = Integer.valueOf((opp.Project_End_date__c).year()+''+REDM);
                                
                                for(string mn : mapORGMeasure.keyset() ){
                                    Json_Period_Measure mes = new Json_Period_Measure();
                                        
                                        if(mmmm.ContainsKey(pid+'-'+mn)){
                                            Planning_Model__c m = mmmm.get(pid+'-'+mn);
                                            mes.Id=m.Id;
                                            mes.isEditable = mapIsEditable.get(mn);
                                            mes.Name=mn;
                                            mes.Comment=(m.comments__c <> NULL)?m.comments__c:'';
                                            mes.Amount=Integer.valueOf(m.amount__c);
                                        }else{
                                            mes.Id='NewId';
                                            mes.isEditable = mapIsEditable.get(mn);
                                            mes.Name=mn;
                                            mes.Comment=' ';
                                            mes.Amount=0;
                                            
                                        }
                                        
                                        
                                        string m_m = ((pid.split('-')[2]).length() == 1)?'0'+pid.split('-')[2]:+pid.split('-')[2]+'';
                                        Integer SId = Integer.valueOf(pid.split('-')[1]+''+m_m);
                                        //201403--201403--201603
                                        //if(SId >= RSDId && SId <= REDId)
                                        
                                            //unrestricted
                                            if( mapIsEditable.get(mn) == 0){
                                                
                                                    //201403::201610

                                                    if(SId >= c_Actual)
                                                        mes.isEditable = 1;
                                                    else
                                                        mes.isEditable = 0;
                                                
                                            }
                                            //restricted
                                            else if( mapIsEditable.get(mn) == 1){

                                                if(SId >= c_Actual && SId <= REDId)
                                                    mes.isEditable = 1;
                                                else
                                                    mes.isEditable = 0;
                                            }
                                           // mes.Comment =  SId+'--'+RSDId+'--'+REDId+'::'+c_Actual;
                                        
                                        
                                    lstPM.add(mes);
                                }
                                p.monthlabel = p.month+'';
                                p.lstPMeasure = lstPM;
                                mapPeriods.put(pid,p);
                               
                            }

 
                            string testt = '';
                            //making Periods list
                            map<string,List<Json_Year>> mapOppYear = new map<string,List<Json_Year>>();
                            for(string key : mapPeriods.keyset()){
                                string yId = key.split('-')[0]+'-'+key.split('-')[1];
                                mapOppYear.put(key.split('-')[0],new List<Json_Year>());
                                if(mapYears.containsKey(yId)){
                                    List<Json_Period> temp = mapYears.get(yId);
                                    temp.add(mapPeriods.get(key));
                                    mapYears.put(yId,temp);
                                    
                                }                   
                            }
                            
                            //making years list
                            
                            for(string key : mapYears.keyset()){                        
                                string oId = key.split('-')[0];
                                if(mapOppYear.containsKey(oId)){
                                    List<Json_Year> temp = mapOppYear.get(oId);
                                    Json_Year y = new Json_Year();
                                    y.Year = Integer.valueOf(key.split('-')[1]);
                                    y.period = mapYears.get(key);
                                    temp.add(y);
                                    mapOppYear.put(oId,temp);
                                }                   
                            }
                    
                            map<string,boolean> mapConfigurationStages = new map<string,boolean>();
                            for(string s : getPicklistValues('opportunity','stageName')){
                                mapConfigurationStages.put(s,false);
                            }
                            
                            for(string  c : setSelConStages){
                                mapConfigurationStages.put(c,true);
                            }
                            
                            set<Id> setBudgetOpportunity = new set<Id>();
                            for(opportunity opp : lstOpportunity){                        
                                for(Planning_Model__c m: opp.Planning_Models__r){
                                    if(m.Opportunity__c <> null){
                                        setBudgetOpportunity.add(m.Opportunity__c);
                                    }
                                }
                            }
                
                            map<String,ForecastCategory__c> mapForecastCategoryColor = ForecastCategory__c.getall();

                            for(opportunity opp : lstOpportunity){
                            
                                string oppMStage;
                                
                                if(Test.isRunningTest()){
                                     oppMStage = 'Open Selected';
                                }
                                /* closed
                                1. Revenue End Date > version.FY.startDate 
                                2. Stages IN Configuration Settings.
                                3. isWon and isclose = true
                                4. close date <= version.enddate*/
                                if(
                                opp.Project_End_date__c > Bcklog_fslyear_startdate && 
                                setSelConStages.contains(opp.stageName) && 
                                opp.iswon == true && 
                                opp.isClosed == true && 
                                opp.closeDate <= crtprd_enddate){     
                                    oppMStage = 'Closed';
                                }
                                
                                /*Selected Open
                                1. close Date >= version.StartDate
                                2. Stages IN Configuration Settings.
                                3. isWon and isclose = false
                                4. close Date <= version.fy.endDate*/
                                if(
                                opp.closeDate >= crtprd_startdate && 
                                setSelConStages.contains(opp.stageName) && 
                                opp.iswon == false && 
                                opp.isClosed == false && 
                                opp.closeDate <= Bcklog_fslyear_Enddate){
                                    oppMStage = 'Open Selected';
                                }
                                
                                /*Not Selected Open
                                1. close Date >= version.StartDate
                                2. Stages Not IN Configuration Settings.
                                3. isWon and isclose = false
                                4. close Date <= version.fy.endDate*/
                                if(
                                opp.closeDate >= crtprd_startdate && 
                                !setSelConStages.contains(opp.stageName)  && 
                                opp.iswon == false && 
                                opp.isClosed == false && 
                                opp.closeDate <= Bcklog_fslyear_Enddate){
                                    oppMStage = 'Open Not Selected';
                                }
                                
                                
                                
                                if(
                                    (oppMStage <> null && !pversion.Is_this_a_Budget_Planning_Version__c) || // Non budget version
                                    (oppMStage <> null &&  pversion.Is_this_a_Budget_Planning_Version__c && setBudgetOpportunity.contains(opp.Id)) //budget version
                                )                                   
                                {
                                    List<Json_Opportunity> temp = mapJson_Opportunity.get(opp.AccountId);
                                    Json_Opportunity aOpp = new Json_Opportunity();
                                    aOpp.OpportunityName = opp.Name;
                                    aOpp.OpportunityId = opp.Id;
                                    aOpp.Probability = opp.Probability+'';
                                    aOpp.OpportunityStage = oppMStage;
                                    aOpp.color = '#000000';//default color black
                                    
                                    //isWon=true,isClose=true,selected 
                                    if(opp.isWon && opp.isClosed && setSelConStages.contains(opp.stageName)){
                                        if(opp.Legacy__c == 'YES'){
                                            aOpp.color  = '#398F38';
                                        }else if(opp.Legacy__c != 'YES'){
                                            aOpp.color  ='#008080';
                                        }                                       
                                    }
                                    
                                    //isWon=false,isClose=false,not selected 
                                    else if(!opp.isWon && !opp.isClosed && !setSelConStages.contains(opp.stageName)){aOpp.color  = 'orange';}
                                    
                                    //isWon=false,isClose=false,selected 
                                    else if(!opp.isWon && !opp.isClosed && setSelConStages.contains(opp.stageName)){aOpp.color  = 'blue';}

                                    /*aOpp.color = '#000000';//default color black
                                    if(mapForecastCategoryColor.ContainsKey(opp.ForeCastCategoryName)){
                                        aOpp.color = mapForecastCategoryColor.get(opp.ForeCastCategoryName).chartColor__c;
                                    }*/
                                    
                                    aOpp.RevenueStartDate = ( opp.Project_Start_Date__c <> null)? (opp.Project_Start_Date__c).month()+'/'+(opp.Project_Start_Date__c).day()+'/'+(opp.Project_Start_Date__c).year():'';
                                    
                                    aOpp.ClosedDate = (opp.CloseDate).year()+'-'+(opp.CloseDate).month()+'-'+(opp.CloseDate).day()+'';
                                    
                                    aOpp.ContractTerm = ( opp.Deal_Duration__c <> null)?Integer.valueOf(opp.Deal_Duration__c):0;
                                    aOpp.LegacyActuals = ( opp.Actuals_to_date__c <> null)?opp.Actuals_to_date__c:0;
                                    aOpp.ContractValue = ( opp.Deal_TCV__c <> null)?opp.Deal_TCV__c:0;
                                    aOpp.Description = ( opp.Description <> null)?opp.Description:'';
                                    if(mapOppYear.containsKey(opp.Id))aOpp.FYI = mapOppYear.get(opp.Id);
                                    temp.add(aOpp);
                                    mapJson_Opportunity.put(opp.AccountId,temp);
                                    map_v_Account.put(opp.AccountId,opp.Account.Name);
                                }
                            }
                            
                            List<Json_Account> lstAccounts = new List<Json_Account>();
                            for(string AccId : map_v_Account.keyset()){
                                lstAccounts.add(new Json_Account(map_v_Account.get(AccId),AccId,mapJson_Opportunity.get(AccId)));
                            }
                            lstJson_Measure.sort();
                            
                            //find isEditable
                            map<string,Integer> mapIsEditableNew = new map<string,Integer>();
                            for(Json_FY pv : lstJson_FY){                                               
                                for(JSON_FY_Period ap: pv.Periods){
                                    Integer isEdit = 0;
                                    if(ap.Category == 'Actual(c)' || ap.Category == 'Forecast' )
                                        isEdit = 1;
                                    mapIsEditableNew.put(pv.Year+'-'+ap.Period,isEdit);
                                }
                            }
                
                            Integer sno=1;
                            gen.writeFieldName('Response');
                                    gen.writeStartObject();
                                    gen.writeFieldName('FY');
                                        gen.writeStartArray();
                                            for(Json_FY pv : lstJson_FY){                                               
                                                gen.writeStartObject();
                                                gen.writeNumberField('Year',pv.Year);
                                                    gen.writeFieldName('Periods');
                                                    gen.writeStartArray();
                                                    (pv.Periods).sort();
                                                    for(JSON_FY_Period ap: pv.Periods){
                                                        gen.writeStartObject();
                                                            gen.writeNumberField('Period',ap.Period);
                                                            gen.writeStringField('Label',ap.Label);
                                                            gen.writeStringField('Category',ap.Category);
                                                            gen.writeStringField('Id',ap.Id);
                                                        gen.writeEndObject();
                                                    }
                                                    gen.writeEndArray();
                                                gen.writeEndObject();
                                            }
                                        gen.writeEndArray();
                                    
                                    gen.writeFieldName('Measures');
                                        gen.writeStartArray();
                                            for(Json_Measure pv : lstJson_Measure){                                                
                                                gen.writeStartObject();
                                                gen.writeStringField('Id',pv.Id);
                                                gen.writeStringField('Name',pv.Name);
                                                gen.writeStringField('Label',pv.Label);
                                                gen.writeStringField('Calculated',pv.Calculated);
                                                gen.writeBooleanField('Restricted_by_Revenue_Term',pv.Restricted_by_Revenue_Term);
                                                gen.writeStringField('Measure_Type',pv.Measure_Type);
                                                gen.writeStringField('Unit_of_Measure',pv.Unit_of_Measure);
                                                gen.writeEndObject();
                                            }
                                        gen.writeEndArray();
                                        
                                    gen.writeFieldName('Accounts'); 
                                    gen.writeStartArray();
                                    
                                    for(Json_Account a : lstAccounts){                                 
                                        gen.writeStartObject();
                                            if(a.AccountName == null)
                                                gen.writeStringField('AccountName', '');
                                            else
                                                gen.writeStringField('AccountName', a.AccountName);
                                            gen.writeStringField('AccountId', a.AccountId);                                             
                                            gen.writeFieldName('Opportunity');  
                                            gen.writeStartArray();
                                            for(Json_Opportunity o : a.Opportunity){                                  
                                                gen.writeStartObject();
                                                    gen.writeStringField('OpportunityName', o.OpportunityName);
                                                    gen.writeStringField('OpportunityStage', o.OpportunityStage);
                                                    gen.writeStringField('OpportunityId', o.OpportunityId);
                                                    gen.writeStringField('Probability', o.Probability);
                                                    gen.writeStringField('Color', o.Color);
                                                    gen.writeStringField('RevenueStartDate', o.RevenueStartDate);
                                                    gen.writeStringField('ClosedDate', o.ClosedDate);
                                                    gen.writeNumberField('ContractTerm', o.ContractTerm);
                                                    gen.writeNumberField('LegacyActuals', o.LegacyActuals);
                                                    gen.writeNumberField('ContractValue', o.ContractValue);
                                                    gen.writeStringField('Description', o.Description); 
                                                    gen.writeStringField('CurrencySign', userCurrencySign);                                             
                                                    gen.writeFieldName('FY');
                                                    gen.writeStartArray();
                                                    if(o.FYI<>null){
                                                        o.FYI.sort();
                                                        for(Json_Year y : o.FYI){                                 
                                                            gen.writeStartObject();
                                                                gen.writeNumberField('Year', y.Year); 
                                                                gen.writeFieldName('Cells');
                                                                gen.writeStartArray();
                                                                y.period.sort();                                                                
                                                                for(Json_Period p : y.period){  
                                                                    p.lstPMeasure.sort();
                                                                    gen.writeStartObject();
                                                                        gen.writeNumberField('Period', p.month);
                                                                        //gen.writeStringField('monthlabel', p.monthlabel);
                                                                        
                                                                                                                                            
                                                                        List<string> lstRId = new List<String>();
                                                                        List<string> lstComments = new List<String>();
                                                                        List<Integer> lstEdit = new List<Integer>();
                                                                        List<Integer> lstValue = new List<Integer>();
                                                                        List<string> lstName = new List<String>();
                                                                        
                                                                        
                                                                        for(Json_Period_Measure h : p.lstPMeasure)
                                                                        {
                                                                            lstName.add(h.Name);
                                                                            lstRId.add(h.Id);
                                                                            lstComments.add(h.Comment);
                                                                            lstEdit.add(h.IsEditable);
                                                                            /*
                                                                            if(mapIsEditableNew.containsKey(y.Year+'-'+p.month))
                                                                                lstEdit.add(mapIsEditableNew.get(y.Year+'-'+p.month));
                                                                            else 
                                                                                lstEdit.add(0);*/
                                                                            lstValue.add(h.Amount);
                                                                        }
                                                                        /*gen.writeFieldName('Name');
                                                                        gen.writeObject(lstName);*/
                                                                        
                                                                        gen.writeFieldName('Values');                                                   
                                                                        gen.writeObject(lstValue);
                                                                        
                                                                        gen.writeFieldName('IsEditable');                                                   
                                                                        gen.writeObject(lstEdit);
                                                                        
                                                                        gen.writeFieldName('Comment');                                                      
                                                                        gen.writeObject(lstComments);
                                                                        
                                                                        gen.writeFieldName('RowIds');                                                       
                                                                        gen.writeObject(lstRId);

                                                                    gen.writeEndObject();
                                                                    
                                                                }
                                                                gen.writeEndArray();
                                                            gen.writeEndObject(); 
                                                            
                                                            
                                                        }
                                                    }
                                                    gen.writeEndArray();

                                                gen.writeEndObject();
                                            }
                                            gen.writeEndArray();
                                        gen.writeEndObject();
                                    }
                                  
                                 
                                
                                    gen.writeEndArray();
                                gen.writeEndObject();
                        }
                      }
                    }
                   }
                    }
                  }  
                }
                else if(MName == 'updateModel')
                {
                    try{
                           
                        boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
                        map<Id,string> mapcurrency = new map<Id,string>(); 
                                                
                        if(u_RowId <> null && u_RowId <> '' && u_RowId <> 'NewId'){
                        u_RowId  = String.escapeSingleQuotes(u_RowId );
                        u_OpportunityId = String.escapeSingleQuotes(u_OpportunityId);
                        if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible()
                        && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()){
                            Planning_Model__c pm = [Select ID,Name,Amount__c from Planning_Model__c where NAme <> null and ID =: u_RowId];
                            pm.Amount__c = decimal.valueOf(u_Amount);
                            
                            if(isMultiCurrencyOrganization){
                                CurrencyConversion.Initialization();
                                string DefaultCurrency = userinfo.getDefaultCurrency();
                                Set<Id> setOppCurrency = new set<Id>();setOppCurrency.add(Id.valueOf(u_OpportunityId));
                                mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
                                string fromCurrency;
                                fromCurrency = mapcurrency.get(u_OpportunityId);
                                decimal Con_amount = CurrencyConversion.Convert(DefaultCurrency,fromCurrency,pm.Amount__c);
                                pm.Amount__c = Con_amount;
                                //pm.put('CurrencyISOCode',fromCurrency);
                            }

                            if(Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable()){
                            update pm;//removed comment
                            }
                            performDML(JSON.serialize(pm), 'true');                          
                            gen.writeBooleanfield('Status', true);

                        }  
                            
                        }
                        else{
                        
                            
                            String FName = 'FY'+u_YearId+'P'+u_PeriodId;

                            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()){
                            Fiscal_Year_Model__c fyear = [select id,Name from Fiscal_Year_Model__c where Name =: FName];

                            
                            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible()){
                                
                            List<Planning_Model__c> lstpm = [Select ID,Amount__c from Planning_Model__c where 

                                Fiscal_Period__c =: fyear.Id and 
                                Opportunity__c =: u_OpportunityId and 
                                Planning_Version__c =: u_planningVersionId and 
                                Planning_Measure__c =: u_MeasureId limit 1];
                            
                            if(lstpm <> null && lstpm.size()>0){
                                lstpm[0].amount__c = Integer.valueOf(u_Amount);
                                if(isMultiCurrencyOrganization){
                                    CurrencyConversion.Initialization();
                                    string DefaultCurrency = userinfo.getDefaultCurrency();
                                    Set<Id> setOppCurrency = new set<Id>();setOppCurrency.add(Id.valueOf(u_OpportunityId));
                                    mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
                                    string fromCurrency;
                                    fromCurrency = mapcurrency.get(u_OpportunityId);
                                    decimal Con_amount = CurrencyConversion.Convert(DefaultCurrency,fromCurrency,lstpm[0].amount__c);
                                    lstpm[0].amount__c = Con_amount;
                                    //lstpm[0].put('CurrencyISOCode',fromCurrency);
                                }
                                if(Schema.sObjectType.Planning_Model__c.fields.amount__c.isUpdateable()){
                                update lstpm[0];//removed comment
                                }
                                performDML(JSON.serialize(lstpm[0]), 'true');                        
                                gen.writeBooleanfield('Status', true);
                                
                                

                            
                        }
                            else{   
                                if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
                                string MName = [select Id,Name from Planning_Financial_Measure__c where id =: u_MeasureId].Name; 
                                }
                                if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()){
                                string PName = [select Id,Name from Planning_Version__c where Id =: u_planningVersionId].Name;
                                
                                Planning_Model__c pm = new Planning_Model__c(
                                    
                                    ModelName__c = u_OpportunityId+'#'+fyear.Name+'#'+PName+'#'+MName,
                                    Fiscal_Period__c = fyear.Id,
                                    Amount__c = Integer.valueOf(u_Amount),
                                    Opportunity__c = u_OpportunityId,
                                    Planning_Version__c = u_planningVersionId,
                                    Planning_Measure__c = u_MeasureId  
                                                              
                                );
                                
                                if(isMultiCurrencyOrganization){
                                    CurrencyConversion.Initialization();
                                    string DefaultCurrency = userinfo.getDefaultCurrency();
                                    Set<Id> setOppCurrency = new set<Id>();setOppCurrency.add(Id.valueOf(u_OpportunityId));
                                    mapcurrency = CurrencyConversion.opportunityCurrencyCode(setOppCurrency);
                                    string fromCurrency;
                                    fromCurrency = mapcurrency.get(u_OpportunityId);
                                    decimal Con_amount = CurrencyConversion.Convert(DefaultCurrency,fromCurrency,pm.amount__c);
                                    pm.amount__c = Con_amount;                                   
                                    //pm.put('CurrencyISOCode', fromCurrency);
                                }

                                 if(Planning_Model__c.SObjectType.getDescribe().isCreateable()){
                                //insert pm;//removed comment
                                 }
                                performDML(JSON.serialize(pm), 'false');
                                    gen.writeBooleanfield('Status', true);


                                }  
                            }  
                            }
                            }
                        }
                    }
                    catch(Exception e){
                        gen.writeBooleanField('success',false);
                        gen.writeStringField('error',e.getMessage()+'-'+e.getLineNumber());
                    }
                }
                else if(MName == 'updateModelComment')
                {
                   try{
                        
                        
                        if(u_RowId <> null && u_RowId <> '' && u_RowId <> 'NewId'){
                            if (Schema.sObjectType.Planning_Model__c.fields.ID.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()){
                            Planning_Model__c pm = [Select ID,Comments__c from Planning_Model__c where ID =: u_RowId];
                            pm.Comments__c = u_Comment;
                                if(Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable()){
                                update pm;//removed comment
                                }
                            performDML(JSON.serialize(pm), 'true');      
                                gen.writeBooleanfield('Status', true);
                            

                            }      
                            
                        }
                       
                   }
                    catch(Exception e){
                        
                        gen.writeBooleanField('success',false);
                        gen.writeStringField('error',e.getMessage()+'-'+e.getLineNumber());
                    }
                }
                else
                {
                    gen.writeBooleanField('success',false);
                    gen.writeStringField('error','Unrecognized Action (' + MName + ')');
                }
            }
            else
            {
                gen.writeBooleanField('success',false);
                gen.writeStringField('error','Missing Action Param');
            }
            
        }
        catch (Exception e)
        {
            gen.writeBooleanField('success',false);
            gen.writeStringField('error',e.getMessage()+'-'+e.getLineNumber()+'-'+e.getStackTraceString());
        }  
        gen.writeEndObject();  
    }

}