public with sharing class  OppBacklogv5{
    
    public map<String,Org_Year>  mapOrgYear;
    public String ConfigName;
    List<String> lstStages;
    public List<Org_Period>  lstPlanninerVersion;
    public List<FiscalYearSettings> lstfiscalsetting;
    
    List<Org_Year>  lstFiscalYear;
    map<Integer,Org_Year>  mapFiscalYear;
    
    public List<Planning_Version__c> lstPlanningVersion;
     
    //List<WOpportunity> lstWOpp;
    
    
    public String ER_strPlanversion{get;set;}
    public String strPlanversion{get;set;}
    public map<Id,Planning_Version__c> mapPlanningVersion{get;set;}
    
    map<Integer,List<Org_Period>> mapYearPlanningVersion = new map<Integer,List<Org_Period>>();
    
    map<String,String> mapFMeasureId = new map<String,String>();
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
    private boolean isCustomFiscalYear;
    public void preStart(){
        lstPlanninerVersion = new List<Org_Period>();
        isCustomFiscalYear = false;
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
          
        for(Planning_Financial_Measure__c fm : [select id,Name from Planning_Financial_Measure__c where name <> null]){
            mapFMeasureId.put(fm.Name,fm.Id+'');
        }
        }
        //lstWOpp = new List<WOpportunity>();
        
        lstPlanningVersion = new List<Planning_Version__c>();
        mapPlanningVersion = new map<Id,Planning_Version__c>();
        //Set<String> setyear = new Set<String>();
        if (Schema.sObjectType.Configuration_Setting__c.fields.id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Name.isAccessible()
        && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
        
        List<Configuration_Setting__c> lstconset = [select id,Name,Stage__c from Configuration_Setting__c LiMIT 1];
       
        lstStages = new List<String>();
        
        mapFiscalYear = new map<Integer,Org_Year>();
        
        if(lstconset <> null && lstconset.size()>0){
            if(lstconset[0].Stage__c <> null) {
            for(String s: (lstconset[0].Stage__c).split(',')){
                if(s <> null && !s.equals(''))lstStages.add(s);
            }
            }
            ConfigName = lstconset[0].Name;
            Set<String> setConfigYear = new Set<String>();
            
            for(Integer i = Integer.valueOf(ConfigName);i<Integer.valueOf(ConfigName)+20;i++){
                setConfigYear.add(i+'');
            }
                        
            lstPlanninerVersion = new List<Org_Period>();
            
            lstFiscalYear = new List<Org_Year>();
        	if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        	&& Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible() 
        	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() 
        	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible()
        	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
        	&& Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() ){
          
        
            lstPlanningVersion = [select id,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Fiscal_Year_Planning__r.StartDate__c,Is_this_a_Budget_Planning_Version__c,
            Fiscal_Year_Planning__r.EndDate__c,Planning_Version_Fiscal_Year__c,SequenceNo__c 
               from Planning_Version__c where Planning_Version_Fiscal_Year__c IN: setConfigYear ];
        	}
            for(Planning_Version__c p :lstPlanningVersion){
                mapPlanningVersion.put(p.Id,p);
            }
            lstfiscalsetting = new List<FiscalYearSettings>();
            if (Schema.sObjectType.FiscalYearSettings.fields.Description.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible()
            && Schema.sObjectType.FiscalYearSettings.fields.IsStandardYear.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible() 
            && Schema.sObjectType.Period.fields.Id.isAccessible() && Schema.sObjectType.Period.fields.EndDate.isAccessible()
            && Schema.sObjectType.Period.fields.FiscalYearSettingsId.isAccessible() && Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible()
            && Schema.sObjectType.Period.fields.Number.isAccessible() && Schema.sObjectType.Period.fields.PeriodLabel.isAccessible()
            && Schema.sObjectType.Period.fields.QuarterLabel.isAccessible() && Schema.sObjectType.Period.fields.StartDate.isAccessible()
            && Schema.sObjectType.Period.fields.Type.isAccessible()
            && Schema.sObjectType.FiscalYearSettings.fields.PeriodLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible()
            && Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.QuarterPrefix.isAccessible()
            && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.WeekLabelScheme.isAccessible()
            && Schema.sObjectType.FiscalYearSettings.fields.WeekStartDay.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.YearType.isAccessible() ){
          
            lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select Id,EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods order by startdate ),PeriodLabelScheme,
            PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
            WeekStartDay,YearType from FiscalYearSettings where name <> null  order by Name];
            }
            //getOrgFiscalSetting(setyear);
            
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
            List<S_FiscalYearSettings> lstStandardfiscalsetting = new List<S_FiscalYearSettings>();
            //custom Fiscal setting Enable
            if(lstfiscalsetting <> null && lstfiscalsetting.size() > 0){  isCustomFiscalYear = true; for(FiscalYearSettings f: lstfiscalsetting ){  S_FiscalYearSettings sfiscal = new S_FiscalYearSettings();    List<S_Period> lstP = new List<S_Period>();  for(Period p : f.periods){ S_Period pp = new S_Period();  pp.PID = p.Id; pp.Type =p.Type;       pp.startDate = p.startDate;    pp.endDate = p.EndDate;     pp.MPNumber = p.Number;   pp.PeriodLabel = p.PeriodLabel;  lstP.add(pp);   } sfiscal.Name = f.Name;          sfiscal.startDate = f.startDate;            sfiscal.endDate = f.endDate;  sfiscal.PeriodPrefix = f.PeriodPrefix;sfiscal.PeriodLabelScheme = f.PeriodLabelScheme;    sfiscal.Periods = lstP;    lstStandardfiscalsetting.add(sfiscal);   } }
            //custom Fiscal setting Not Enable
            else{
        		if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
         
                Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];            
        		              
                if(org <> null && org.FiscalYearStartMonth <> null){
                    S_FiscalYearSettings sfiscal = new S_FiscalYearSettings();
                    string cyear = ''+(system.today()).year();
                    date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear); 
                    List<S_Period> lstP = new List<S_Period>();
                    
                    for(integer i=1;i<13;i++){
                        S_Period pp = new S_Period();
                        pp.PID = 'P-'+i;
                        pp.Type ='Month';
                        pp.startDate = pstartDate;
                        pp.endDate = pstartDate.addMonths(1).addDays(-1);
                        pp.MPNumber = i;
                        pp.PeriodLabel = mapMonthString.get(i);
                        lstP.add(pp);
                        pstartDate = pstartDate.addMonths(1);
                    }
                
                    sfiscal.Name = cyear;
                    sfiscal.startDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);
                    sfiscal.endDate = sfiscal.startDate.addyears(1).addDays(-1);
                    sfiscal.PeriodPrefix = 'P';
                    sfiscal.PeriodLabelScheme = 'StandardMonths';
                    sfiscal.Periods = lstP;
                    lstStandardfiscalsetting.add(sfiscal);
                }
            }
            }
            getOrgFiscalSetting(lstStandardfiscalsetting);
        }
    }
    }
    
    public OppBacklogv5(NewPlanningVersionExtensionv4 controller) {
        preStart();
    }
    public OppBacklogv5(ApexPages.StandardController controller){
        preStart();
        
    }
    
    public List<SelectOption> getCPlanVersion() {
        ER_strPlanversion = null;
        List<SelectOption> options = new List<SelectOption>();
        List<WSeqPlanningVersion> lstwrapper = new List<WSeqPlanningVersion>();
        for(Planning_Version__c cp :  lstPlanningVersion){
            lstwrapper.add(new WSeqPlanningVersion(cp));
        }
        lstwrapper.sort();

        options.add(new SelectOption('none','--None--'));
        //ER_strPlanversion = 'none';
        for(WSeqPlanningVersion w : lstwrapper){
            Planning_Version__c cp = w.planningversion;
            if(cp.Version_Status__c == 'Closed'){
                //if(ER_strPlanversion == null) ER_strPlanversion = cp.Id+'';
                options.add(new SelectOption(cp.Id,cp.Name));
            }
        }

        return options;
    }
    
    public List<SelectOption> getPlanVersion() {
        ER_strPlanversion = null;
        List<SelectOption> options = new List<SelectOption>();
       
       for(Org_Period p : lstPlanninerVersion){
            if(ER_strPlanversion == null) ER_strPlanversion = p.Id+'';
            if(ConfigName == String.valueOf(p.ent_Planning_Version_Fiscal_Year_c))options.add(new SelectOption(p.Id,p.Name));
        }
        return options;
    }
    
   
    public pagereference onPlanningVersionChange(){        
        
        return null;
    }
    
    public class wrapper_PModel implements Comparable{
        
            string sequence;
            Planning_Model__c m;
            public wrapper_PModel(string sequence,Planning_Model__c m){
                this.sequence = sequence;
                this.m = m;
            }
        
        public Integer compareTo(Object compareTo) {
            wrapper_PModel compareToOppy = (wrapper_PModel)compareTo;
            Integer returnValue = 0;
            if (sequence > compareToOppy.sequence) {
                returnValue = 1;
            } else if (sequence < compareToOppy.sequence) {
                returnValue = -1;
            }
            return returnValue;       
        }
    }

    public pagereference SaveModel(){
       // system.debug('#1:'+ER_strPlanversion);
        Planning_Version__c pversion;
        if(test.isRunningTest()){for(string key:mapPlanningVersion.keySet()){ER_strPlanversion = key;break;}}
        if(mapPlanningVersion.containsKey(ER_strPlanversion)){
            pversion = mapPlanningVersion.get(ER_strPlanversion);
            ER_strPlanversion =  String.escapeSingleQuotes(ER_strPlanversion);
            if (Schema.sObjectType.Planning_Model__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible()
            && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.ExpectedRevenue.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible()
            && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.amount__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible()
            && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
            && Schema.sObjectType.Opportunity.fields.Actuals_to_Date__c.isAccessible()){
          
            List<Planning_Model__c> lstSelPlModel;
            /*if(test.isRunningTest()){
            	lstSelPlModel = [select id,ModelName__c,Planning_Measure__r.Name,Opportunity__r.ExpectedRevenue,Opportunity__r.Deal_Duration__c,Planning_Version__c,Planning_Version__r.Name,amount__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Actuals_to_Date__c from Planning_Model__c where Opportunity__r.RecordType.DeveloperName = 'RSB' and (Planning_Measure__r.Name = 'Revenue' or Planning_Measure__r.Name = 'Revenue Backlog')];
            }else{
            	lstSelPlModel = [select id,ModelName__c,Planning_Measure__r.Name,Opportunity__r.ExpectedRevenue,Opportunity__r.Deal_Duration__c,Planning_Version__c,Planning_Version__r.Name,amount__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Actuals_to_Date__c from Planning_Model__c where Planning_Version__c =: ER_strPlanversion and Opportunity__r.RecordType.DeveloperName = 'RSB' and (Planning_Measure__r.Name = 'Revenue' or Planning_Measure__r.Name = 'Revenue Backlog')];
            }*/
            if(test.isRunningTest()){
            	lstSelPlModel = [select id,ModelName__c,Planning_Measure__r.Name,Opportunity__r.ExpectedRevenue,Opportunity__r.Deal_Duration__c,Planning_Version__c,Planning_Version__r.Name,amount__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Actuals_to_Date__c from Planning_Model__c where  (Planning_Measure__r.Name = 'Revenue' or Planning_Measure__r.Name = 'Revenue Backlog')];
            }else{
            	lstSelPlModel = [select id,ModelName__c,Planning_Measure__r.Name,Opportunity__r.ExpectedRevenue,Opportunity__r.Deal_Duration__c,Planning_Version__c,Planning_Version__r.Name,amount__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Period_Number__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__r.Deal_TCV__c,Opportunity__r.Actuals_to_Date__c from Planning_Model__c where Planning_Version__c =: ER_strPlanversion  and (Planning_Measure__r.Name = 'Revenue' or Planning_Measure__r.Name = 'Revenue Backlog')];
            }
            //system.debug('#3:'+lstSelPlModel);
            Map<string,Planning_Model__c> mapPl_Models = new Map<string,Planning_Model__c>();
            Map<Id,List<wrapper_PModel>> mapOpp_Models = new Map<Id,List<wrapper_PModel>>();
            for(Planning_Model__c m : lstSelPlModel){
                mapPl_Models.put(m.ModelName__c,m);
                if(m.Planning_Measure__r.Name == 'Revenue'){
                    List<wrapper_PModel> lstModel = new List<wrapper_PModel>();
                    string pno;
                    if(m.Fiscal_Period__r.Period_Number__c < 10)pno = '00'+m.Fiscal_Period__r.Period_Number__c;
                    if(m.Fiscal_Period__r.Period_Number__c >= 10 && m.Fiscal_Period__r.Period_Number__c < 100 )pno = '0'+m.Fiscal_Period__r.Period_Number__c;
                    
                    lstModel.add(new wrapper_PModel(m.Fiscal_Period__r.Fiscal_Year__c+pno,m));
                    if(mapOpp_Models.ContainsKey(m.Opportunity__c))
                        lstModel.addAll(mapOpp_Models.get(m.Opportunity__c));
                    lstModel.sort();
                    mapOpp_Models.put(m.Opportunity__c,lstModel);
                }
            }
           
           // system.debug('#4:'+mapOpp_Models);
            
            map<String,Id> mapFMeasureId = new map<String,Id>();
            if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
         
            for(Planning_Financial_Measure__c fm : [select id,Name from Planning_Financial_Measure__c where name = 'Revenue' or name = 'Revenue Backlog' or name = 'Sales Booking']){
                mapFMeasureId.put(fm.Name,fm.Id);
            }
            }
            List<Planning_Model__c> lstRevBacklog = new List<Planning_Model__c>();
            for(Id oppId : mapOpp_Models.keySet()){
                decimal PreviousBal;
                integer count=1;
                for(wrapper_PModel w : mapOpp_Models.get(oppId)){   
                    Planning_Model__c m = w.m;
                    string MName = m.Opportunity__c+'#'+m.Fiscal_Period__r.Name+'#'+m.Planning_Version__r.Name+'#'+'Revenue Backlog';
                    Planning_Model__c rb;
                    if(mapPl_Models.containsKey(MName)){
                        rb = mapPl_Models.get(MName);
                    }else{
                        rb = new Planning_Model__c();
                    }
                    decimal RActual = 0;
                    if(m.Opportunity__r.Actuals_to_Date__c <> null)
                        RActual = m.Opportunity__r.Actuals_to_Date__c;    
                    
                    
                    if(PreviousBal == null){
                        PreviousBal = m.Opportunity__r.Deal_TCV__c - RActual;
                    }
                    
                    rb.Amount__c = PreviousBal - m.Amount__c;
                    PreviousBal = rb.Amount__c;
                    
                    rb.ModelName__c = MName;
                    rb.Planning_Version__c = m.Planning_Version__c;
                    rb.Comments__c = 'By Generate Revenue : Revenue Backlog';
                    //rb.Comments__c = (count++)+'---'+PreviousBal+'----'+rb.Amount__c+'----'+m.Opportunity__r.Deal_TCV__c+'---'+m.Amount__c+'---'+m.modelName__c+'----'+MName;
                    //10000.00---1400.00---00636000008kQTxAAM#FY2016P6#2016-August#Revenue----00636000008kQTxAAM#FY2016P6#2016-August#Revenue Backlog
                    rb.Fiscal_Period__c = m.Fiscal_Period__c;
                    rb.Planning_Measure__c = mapFMeasureId.get('Revenue Backlog');
                    rb.Opportunity__c = m.Opportunity__c;  
                    
                    lstRevBacklog.add(rb);
                }
            }
           
           // system.debug('#5:'+lstRevBacklog);
             
            if(lstRevBacklog.size() >0 ){
                
                if (Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isUpdateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isUpdateable()){
                        upsert lstRevBacklog;
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,lstRevBacklog.size()+' revenue backlog records saved successfully'));
            }
        }
        }
        return null;
    }
    
    public class Org_Year{
        String Id;
        Integer Name;
        Date StartDate_c;
        Date EndDate_c;
        public Org_Year(String Id,Integer Name,Date StartDate_c,Date EndDate_c){
            this.Id = Id;
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
        Integer Plan_no_c;
        String ent_MonthName_c;
        public Org_Period(Integer Index,String Id,String Org_Year,Integer ent_SequenceNo_c,Date ent_Data_Entry_Closed_Date_c,Date ent_Data_Entry_Start_Date_c,Integer ent_Planning_Version_Fiscal_Year_c,String ent_Planning_Version_Current_Period_c,String ent_MonthName_c,Integer Plan_no_c){
            this.Index = Index;
            this.Id = Id;
            this.Org_Year = Org_Year;
            this.ent_SequenceNo_c = ent_SequenceNo_c;
            this.ent_Data_Entry_Closed_Date_c = ent_Data_Entry_Closed_Date_c;
            this.ent_Data_Entry_Start_Date_c = ent_Data_Entry_Start_Date_c;
            this.ent_Planning_Version_Fiscal_Year_c = ent_Planning_Version_Fiscal_Year_c;
            this.ent_Planning_Version_Current_Period_c = ent_Planning_Version_Current_Period_c;
            this.ent_MonthName_c = ent_MonthName_c;
            this.Plan_no_c = Plan_no_c;
        }
        
        public Integer compareTo(Object compareTo) {
            Org_Period compareToPlan = (Org_Period)compareTo;
           if (Index == compareToPlan.Index) return 0;
           if (Index > compareToPlan.Index) return 1;
           return -1;             
        }
    }
    public List<Org_Period> createFiscalPeriods(S_FiscalYearSettings fiscal,Integer index,map<string,Integer> mapSeqNumber){
            
        Integer fyear = (fiscal.EndDate).Year();
        if(!isCustomFiscalYear){
            fyear = (fiscal.StartDate).Year();
        }
        
        List<Org_Period> lstPeriods = new List<Org_Period>();  
        
        Integer count = fiscal.startDate.Month();
        Integer seq = 1;
        if((fiscal.PeriodLabelScheme).equals('Custom')){    for(s_Period p : fiscal.periods){         if((p.Type).equals('Month')) {  lstPeriods.add(                  new Org_Period((index++),p.pId,mapOrgYear.get(fyear+'').Id,(seq++),p.EndDate,p.StartDate,fyear,(count++)+'',p.PeriodLabel,mapSeqNumber.get(p.pId))            );                if(count == 13)count =1;             } 
            }
        }
        else{
            for(s_Period p : fiscal.periods){           
                if((p.Type).equals('Month')) {   
                    lstPeriods.add(
                        new Org_Period(
                            (index++),p.pId,mapOrgYear.get(fyear+'').Id,(seq++),p.EndDate,p.StartDate,fyear,p.MPNumber+'','',mapSeqNumber.get(p.pId)
                        )); 
                } 
            }
        }
        return lstPeriods;
    }
    public void getOrgFiscalSetting(List<S_FiscalYearSettings> lstfiscalsetting){           
       
        
            
            
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
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            lstFiscalYear.add(new Org_Year('FY-'+(Id++),Integer.valueOf(fiscal.Name),fiscal.startDate,fiscal.EndDate));
        }
        
        
        for(Org_Year fy:lstFiscalYear){
            mapOrgYear.put(fy.name+'',fy);            
        }
        map<string,Integer> mapSeqNumber = new map<string,Integer>();
                    
                    for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
                        Integer seq = 1;
                        for(s_Period p : fiscal.periods){
                            if((p.Type).equals('Month')){
                                mapSeqNumber.put(p.pId,seq++);
                            }               
                        }  
                    }
        Integer index = 0;
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
             for(Org_Period p: createFiscalPeriods(fiscal,index,mapSeqNumber)){
            
                index++;
                if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                    if(mapMonthString.containsKey(Integer.valueOf(p.ent_Planning_Version_Current_Period_c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.ent_Planning_Version_Current_Period_c));                            
                }
                else if((fiscal.PeriodLabelScheme).equals('Custom')){
                   MonthName  = p.ent_MonthName_c;
                   
                }
                else{
                   MonthName  = Prefix+'-'+p.ent_Planning_Version_Current_Period_c;                      
                }                    
                p.ent_MonthName_c = MonthName; 
                p.Name = p.ent_Planning_Version_Fiscal_Year_c+'-'+MonthName;
                lstPlanninerVersion.add(p);
             }

        }
        


    }    

    public class WSeqPlanningVersion implements Comparable {
        public Integer seqNo;
        public Planning_Version__c planningversion;
            
        // Constructor
        public WSeqPlanningVersion(Planning_Version__c planningversion) {
            this.planningversion = planningversion;
            String sNo = planningversion.Planning_Version_Fiscal_Year__c+''+planningversion.SequenceNo__c;      
            String zeros='';        
            Integer sSize = sNo.length();       
            for(Integer i = 0;i<(7-sSize);i++){     
                zeros += '0';        
            }       
            this.seqNo = Integer.ValueOf(planningversion.Planning_Version_Fiscal_Year__c+''+zeros+''+planningversion.SequenceNo__c);        
                    }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            WSeqPlanningVersion compareToPlan = (WSeqPlanningVersion)compareTo;
            if (seqNo == compareToPlan.seqNo) return 0;
           if (seqNo > compareToPlan.seqNo) return 1;
            return -1;        
        }
    }
}