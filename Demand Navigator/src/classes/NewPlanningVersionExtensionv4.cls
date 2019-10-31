/*
Develop By : Habimoon 
Created Date : 25th March 2015
Last Modified Date : 20th April 2015
Purpose : User can create the records manually in the Planning version.
                    
    12 Planning Versions are automatically by default created based on the Fiscal Year periods defined.
    3 Budget Planning Versions are also created by default for each Fiscal Year.
    You are able to create more Planning Versions both for Budgeting and Forecasting purposes.

*/

public with sharing class NewPlanningVersionExtensionv4{ 


    public boolean isCustomFiscalYearEnable{get;set;}
    public String FiscalYear{get;set;}
    public String FiscalPeriod{get;set;}
    public String FiscalStatus{get;set;}
    map<String,Fiscal_Year_Planning__c> mapCFiscalYear;
    
    Map<String,Integer> mapAddYearMaxSeq;
    Map<String,Integer> mapGapYearMaxSeq;
    Map<String,Integer> mapYearMaxSeq;
    
    
    map<string,List<CustomPeriod>> mapFiscalYear;
    map<string,FiscalYearSettings> mapFiscalYearDates;
    map<string,S_FiscalYearSettings> mapStandardFiscalYearDates;

    public  List<FiscalYearSettings> lstfiscalsetting;
    public Planning_Version__c NewPlanVer{get;set;}
    
    public List<CustomPeriod> setPlannerPeriod(FiscalYearSettings fiscal){  Map<Integer,String> mapMonthString = new Map<Integer,String>();   mapMonthString .put(1,'January');      mapMonthString .put(2,'February'); mapMonthString .put(3,'March');mapMonthString .put(4,'April');  mapMonthString .put(5,'May'); mapMonthString .put(6,'June'); mapMonthString .put(7,'July');    mapMonthString .put(8,'August');mapMonthString .put(9,'September');    mapMonthString .put(10,'October');    mapMonthString .put(11,'November');  mapMonthString .put(12,'December');   Integer fyear = (fiscal.EndDate).Year();    List<CustomPeriod> lstPeriods = new List<CustomPeriod>();    String  Prefix = fiscal.PeriodPrefix;  Integer count = fiscal.startDate.Month();  Integer seq = 1;if((fiscal.PeriodLabelScheme).equals('Custom')){   for(Period p : fiscal.periods){     if((p.Type).equals('Month')) {                    lstPeriods.add( new CustomPeriod(p.Number+'',p.PeriodLabel,p.Type,p.startDate,p.endDate) );     }     }   }else if((fiscal.PeriodLabelScheme).equals('StandardMonths')){    for(Period p : fiscal.periods){       if((p.Type).equals('Month')) {  lstPeriods.add( new CustomPeriod(p.Number+'',mapMonthString.get(p.Number),p.Type,p.startDate,p.endDate) );     }   }    }else {    for(Period p : fiscal.periods){       if((p.Type).equals('Month')) {    lstPeriods.add( new CustomPeriod(p.Number+'',Prefix+'-'+p.Number,p.Type,p.startDate,p.endDate) );  }  }  }  return lstPeriods;    }
    
    public List<CustomPeriod> setStandardPlannerPeriod(S_FiscalYearSettings fiscal){
        
        Map<Integer,String> mapMonthString = new Map<Integer,String>();
            
        mapMonthString.put(1,'January');
        mapMonthString.put(2,'February');
        mapMonthString.put(3,'March');
        mapMonthString.put(4,'April');
        mapMonthString.put(5,'May');
        mapMonthString.put(6,'June');
        mapMonthString.put(7,'July');
        mapMonthString.put(8,'August');
        mapMonthString.put(9,'September');
        mapMonthString.put(10,'October');
        mapMonthString.put(11,'November');
        mapMonthString.put(12,'December');
        
        Integer fyear = (fiscal.EndDate).Year();
        List<CustomPeriod> lstPeriods = new List<CustomPeriod>();  
        String  Prefix = fiscal.PeriodPrefix;
        Integer count = fiscal.startDate.Month();
        Integer seq = 1;
        
        for(S_Period p : fiscal.periods){           
            if((p.Type).equals('Month')) {   
                lstPeriods.add( new CustomPeriod(p.MPNumber+'',mapMonthString.get(p.MPNumber),p.Type,p.startDate,p.endDate) );
            }
        }
        return lstPeriods;

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
    map<string,CustomPeriod> mapCustomPeriod;
  
    public list<S_FiscalYearSettings> lstStandardfiscalsetting;
    public NewPlanningVersionExtensionv4() {
        

        
        
        
        //get Max Sequence Number for Additional Planning Version
        mapAddYearMaxSeq = new Map<String,Integer>();
        mapgapYearMaxSeq = new Map<String,Integer>();
        mapYearMaxSeq = new Map<String,Integer>();
        try{
        	if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
         
            AggregateResult[] lstAddSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Gap_Planning_Version__c = false and Is_this_a_Budget_Planning_Version__c = true and SequenceNo__c <> null Group By Planning_Version_Fiscal_Year__c];
        	    
                for (AggregateResult ar : lstAddSeqNo)  {
                    mapAddYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
                }
        	}
        	if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
          
                AggregateResult[] lstgapSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = true and SequenceNo__c <> null Group By Planning_Version_Fiscal_Year__c];
        	  
                for (AggregateResult ar : lstgapSeqNo)  {
                    mapgapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
                }
               }  
            if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
        
                AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Gap_Planning_Version__c = false and Is_this_a_Budget_Planning_Version__c = false and SequenceNo__c <> null Group By Planning_Version_Fiscal_Year__c];
                
                for (AggregateResult ar : lstSeqNo)  {
                    mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
                }
            }
        }catch(Exception e){//system.debug('Exception on aggregate'+e);
        }
        NewPlanVer = new Planning_Version__c();
        mapFiscalYearDates = new map<string,FiscalYearSettings> ();
        mapStandardFiscalYearDates = new map<string,S_FiscalYearSettings> ();
        
        mapCFiscalYear = new map<String,Fiscal_Year_Planning__c>();
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
         
        for(Fiscal_Year_Planning__c fc : [select Id,Name from Fiscal_Year_Planning__c where name <> null limit 200]){
                mapCFiscalYear.put(fc.Name,fc);
            }
        } 
        mapFiscalYear = new map<string,List<CustomPeriod>>();
        if (Schema.sObjectType.FiscalYearSettings.fields.Description.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.IsStandardYear.isAccessible()  && Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible()
        && Schema.sObjectType.Period.fields.EndDate.isAccessible() && Schema.sObjectType.Period.fields.FiscalYearSettingsId.isAccessible()
        && Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible() && Schema.sObjectType.Period.fields.Number.isAccessible()
        && Schema.sObjectType.Period.fields.PeriodLabel.isAccessible() && Schema.sObjectType.Period.fields.QuarterLabel.isAccessible()
        && Schema.sObjectType.Period.fields.StartDate.isAccessible() && Schema.sObjectType.Period.fields.Type.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.QuarterPrefix.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.WeekLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.WeekStartDay.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.YearType.isAccessible()  ){
         
        lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods order by startdate),PeriodLabelScheme,
        PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
        WeekStartDay,YearType from FiscalYearSettings where name <> null order by startdate limit 200];
        }
        lstStandardfiscalsetting = new list<S_FiscalYearSettings>();
        
        isCustomFiscalYearEnable = false;
        
        if(test.isRunningTest())lstfiscalsetting.clear();
        if(lstfiscalsetting <> null && lstfiscalsetting.size()>0){
            isCustomFiscalYearEnable = true;
        }
        else {
        	if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
         
        	Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
        	
            if(org <> null && org.FiscalYearStartMonth <> null){        
                if(org.FiscalYearStartMonth <> null){
                            
                    string cyear = ''+(system.today()).year();
                    date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);

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
                    
                    S_FiscalYearSettings fiscal = new S_FiscalYearSettings();
                    fiscal.Name = cyear;
                    fiscal.startDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);
                    fiscal.endDate = fiscal.startDate.addyears(1).addDays(-1);
                    fiscal.PeriodPrefix = 'P';
                    fiscal.PeriodLabelScheme = 'StandardMonths';
                    fiscal.Periods = lstP;                  
                    lstStandardfiscalsetting.add(fiscal);   
                }
            }
            }
        }
        
        setFiscalYear(lstfiscalsetting,lstStandardfiscalsetting);
        
        mapCustomPeriod = new map<string,CustomPeriod>();

        for(string fyear : mapFiscalYear.keyset()){
        for(CustomPeriod p: mapFiscalYear.get(fyear) ){
            if(p.PeriodType == 'month'){
                mapCustomPeriod.put(p.PeriodId,p);
            }
            
        }
        }
    }
    
    
    public void setFiscalYear(List<FiscalYearSettings>  lstPeriod,List<S_FiscalYearSettings>  lstStPeriod){
        
        
        if(isCustomFiscalYearEnable){
            for(FiscalYearSettings  ap : lstPeriod){
                mapFiscalYear.put(ap.Name,setPlannerPeriod(ap));
                mapFiscalYearDates.put(ap.Name,ap);         
            }
        }
        else{
            for(S_FiscalYearSettings  ap : lstStPeriod){
                mapFiscalYear.put(ap.Name,setStandardPlannerPeriod(ap));
                mapStandardFiscalYearDates.put(ap.Name,ap);             
            }
        }
    }
    
    public List<SelectOption> getFYears(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        if(isCustomFiscalYearEnable){
            for(FiscalYearSettings  f: lstfiscalsetting){
                options.add(new SelectOption(f.Name,f.Name));
            }
        }else{
            for(S_FiscalYearSettings  f: lstStandardfiscalsetting){
                options.add(new SelectOption(f.Name,f.Name));
            }
        }
        return options;
    }
    public string strVersion{get;set;}
    public List<SelectOption> getPVType(){
        List<SelectOption> options = new List<SelectOption>();
        strVersion = 'Revenue';
        options.add(new SelectOption('Revenue','Revenue Planning Version'));
        options.add(new SelectOption('Budget','Budget Planning Version'));
        options.add(new SelectOption('Gap','Gap Planning Version'));
        return options;
    }
    
    public List<SelectOption> getFStatus(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Not Open','Not Open'));
        options.add(new SelectOption('Open (User)','Open (User)'));              
        options.add(new SelectOption('Open (Admin)','Open (Admin)'));     
        options.add(new SelectOption('Closed','Closed'));
        return options;
    }
   
    public List<SelectOption> getFPeriods(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        if(mapFiscalYear.ContainsKey(FiscalYear)){
            List<CustomPeriod> lstperiod = mapFiscalYear.get(FiscalYear);
            for(CustomPeriod p: lstperiod ){
                if(p.PeriodType == 'month'){
                    options.add(new SelectOption(p.PeriodId,p.PeriodName));
                    
                }
                
            }
        }
        return options;
    }
    public pagereference changePeriods(){       
        return null;
    }
    
    public pagereference setFiscalDates(){
        
        
        if((strVersion == 'Budget' || strVersion == 'Gap') && FiscalYear <> '--None--'){
            if(isCustomFiscalYearEnable){
                NewPlanVer.Data_Entry_Start_Date__c = mapFiscalYearDates.get(FiscalYear).StartDate;
                NewPlanVer.Data_Entry_Closed_Date__c = mapFiscalYearDates.get(FiscalYear).EndDate;
            }else{
                NewPlanVer.Data_Entry_Start_Date__c = mapStandardFiscalYearDates.get(FiscalYear).StartDate;
                NewPlanVer.Data_Entry_Closed_Date__c = mapStandardFiscalYearDates.get(FiscalYear).EndDate;
            }
        }else if(strVersion == 'Revenue' && FiscalYear <> '--None--'){
            
            if(FiscalPeriod <> null && mapCustomPeriod.containskey(FiscalPeriod)){
                NewPlanVer.Data_Entry_Start_Date__c = mapCustomPeriod.get(FiscalPeriod).StartDate;
                NewPlanVer.Data_Entry_Closed_Date__c =mapCustomPeriod.get(FiscalPeriod).EndDate;
            }
        }
        //system.debug('##:'+strVersion+'::'+FiscalYear+'::'+FiscalPeriod+'::'+mapCustomPeriod.containskey(FiscalPeriod)+'::'+mapCustomPeriod);
        if(FiscalYear <> '--None--'){
            Integer seqNo = 0;
            
           // system.debug('#:'+strVersion);
            if(strVersion == 'Budget'){
                
                seqNo = 99;
                if(mapAddYearMaxSeq.containsKey(FiscalYear)){
                    seqNo = mapAddYearMaxSeq.get(FiscalYear);
                }
            }
            else if(strVersion == 'Gap'){
                
                seqNo = 199;
                if(mapGapYearMaxSeq.containsKey(FiscalYear)){
                    seqNo = mapGapYearMaxSeq.get(FiscalYear);
                }
            }
            else{
                seqNo = 0;
                if(mapYearMaxSeq.containsKey(FiscalYear)){
                    seqNo = mapYearMaxSeq.get(FiscalYear);
                }
            }
            seqNo += 1;
            //system.debug('#:'+seqNo);
            NewPlanVer.SequenceNo__c = seqNo;
            NewPlanVer.Planning_Version_Current_Period__c = String.ValueOf(seqNo);
        }       
        
        return null;
    }
    
    public pagereference cancelConfiguration(){
        Pagereference page = new pagereference('/a01/o');
        page.setRedirect(true);
        return page;
    }
    
    public class CustomPeriod{
        public String PeriodId{get;set;}
        public String PeriodName{get;set;}
        public String PeriodType{get;set;}
        public Date StartDate{get;set;}
        public Date EndDate{get;set;}
        public CustomPeriod(String PeriodId,String PeriodName,String PeriodType, Date StartDate, Date EndDate){
            this.PeriodId = PeriodId;
            this.PeriodName = PeriodName;
            this.PeriodType = PeriodType;
            this.StartDate = StartDate;
            this.EndDate = EndDate;
        }
    }
    
    public pagereference saveConfiguration(){
        try{
            
                       
            NewPlanVer.Name = FiscalYear +'-'+NewPlanVer.MonthName__c;
            NewPlanVer.Fiscal_Year_Planning__c = mapCFiscalYear.get(FiscalYear).Id;
            NewPlanVer.Planning_Version_Fiscal_Year__c = FiscalYear;
            
            if(!FiscalPeriod.equals('--None--') && !NewPlanVer.Is_this_a_Budget_Planning_Version__c)
            if(!FiscalPeriod.equals('--None--') && strVersion <> 'Budget')
                NewPlanVer.Planning_Version_Current_Period__c = FiscalPeriod;
                                   
            NewPlanVer.Version_Status__c = FiscalStatus;
           // NewPlanVer.SequenceNo__c = 0;
            
            if(strVersion == 'Budget')NewPlanVer.Is_this_a_Budget_Planning_Version__c = true;
            else if(strVersion == 'Gap')NewPlanVer.Is_this_a_Gap_Planning_Version__c = true;
            else{NewPlanVer.Is_this_a_Budget_Planning_Version__c = false;
            NewPlanVer.Is_this_a_Gap_Planning_Version__c = false;}
            if (Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isCreateable()){
                upsert NewPlanVer;
            }
            NewPlanVer = new Planning_Version__c();
            FiscalYear = FiscalPeriod = '--None--';
        }
        catch(Exception e){
        }
        return null;
    }
    
   
    }