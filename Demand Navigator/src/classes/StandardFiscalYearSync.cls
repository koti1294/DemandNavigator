public with sharing class StandardFiscalYearSync {
  public static map<String,Fiscal_Year_Planning__c>  mapFiscalYear;
  public static List<S_FiscalYearSettings> lstfiscalsetting;
  public static List<Additional_Planning_Versions__c> lstAdditionalPlanning;
  
  
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
  public static void Initialization(){
  
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

        
    mapFiscalYear = new map<String,Fiscal_Year_Planning__c>();
    lstfiscalsetting = new List<S_FiscalYearSettings>();
    if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Id.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible()
    && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isAccessible()){
         
    lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where name <> null];

    } 
    
    map<String,Fiscal_Year_Planning__c> mapOFY = new map<String,Fiscal_Year_Planning__c>();

        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
         
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c  where name <> null]){
            mapOFY.put(fy.name,fy);            
        }

        }
        Set<String> setFName = new Set<String>();

    if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
         
    Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
    
    List<Fiscal_Year_Planning__c> lstFYP = new List<Fiscal_Year_Planning__c>();
    if(org <> null && org.FiscalYearStartMonth <> null){
        
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
        
        Fiscal_Year_Planning__c pv;
        if(mapOFY.containsKey(fiscal.Name))
            pv = mapOFY.get(fiscal.Name);
        else{
            pv = new Fiscal_Year_Planning__c(name = fiscal.Name,StartDate__c = fiscal.startDate,EndDate__c = fiscal.EndDate,Record_Source__c = 'Installation');
            setFName.add(fiscal.Name);
            lstfiscalsetting.add(fiscal);
          }
        lstFYP.add(pv);
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isUpdateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isCreateable()) {	
        upsert lstFYP;
        }
    }

  } 
    


   if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()
   && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() ){
         
    for(Fiscal_Year_Planning__c fy:[select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where Name IN: setFName]){
        mapFiscalYear.put(fy.name,fy);            
    }

   } 
    
    
  }
  public static DefaultSettingResponse putFiscalPeriods(){
    
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
            
        List<Planning_Version__c>  lstPlanninerVersion = new List<Planning_Version__c>();
    
    for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Planning_Version__c p: createFiscalPeriods(fiscal)){
               
                    if(mapMonthString.containsKey(Integer.valueOf(p.Planning_Version_Current_Period__c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.Planning_Version_Current_Period__c));                            
                
                                  
                p.MonthName__c = MonthName; 
                p.Name = p.Planning_Version_Fiscal_Year__c+'-'+MonthName;
                               
                lstPlanninerVersion.add(p);
            }
        }
        
        if(lstPlanninerVersion.size()>0){
            try{
            	if (Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()){
	                upsert lstPlanninerVersion;              
            	}
            }
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstPlanninerVersion),lstPlanninerVersion.size());
  }
  
  public static DefaultSettingResponse putFiscalAdditionalPeriods(){
    Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();

    if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
         
    AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c  = true Group By Planning_Version_Fiscal_Year__c];
            
    for (AggregateResult ar : lstSeqNo)  {
      mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
    }

    } 
    List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
    
    for(Fiscal_Year_Planning__c fiscal :  mapFiscalYear.values() ){ Integer seq = 99; if(mapYearMaxSeq.ContainsKey(fiscal.Name)) seq = mapYearMaxSeq.get(fiscal.Name);   for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){   lstPlanningversion.add(  new Planning_Version__c(   Fiscal_Year_Planning__c = fiscal.Id,      Name = fiscal.Name+'-'+ap.Name,   Additional_Planning_Version__c = ap.Id,  Is_this_a_Budget_Planning_Version__c     = true,  SequenceNo__c = ++seq,    Data_Entry_Closed_Date__c= fiscal.EndDate__c, Data_Entry_Start_Date__c  = fiscal.StartDate__c,Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fiscal.Name, Planning_Version_Current_Period__c= '',  MonthName__c =ap.Name,Planning_Version_Description__c = ap.Version_Description__c   )             );      }    }
      
    if(lstPlanningversion.size()>0){
            try{
            	if (Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isCreateable()) {	
                upsert lstPlanningversion;  
            	}             
            }
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstPlanningversion),lstPlanningversion.size());
  }
  
  public static DefaultSettingResponse putCustomFiscalYear(){
    
        
        
        
        
        List<Fiscal_Year_Model__c>  lstFiscalYear = new List<Fiscal_Year_Model__c>();
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Fiscal_Year_Model__c p: createCustomFiscalPeriods(fiscal)){
                lstFiscalYear.add(p);
            }
        }        
        if(lstFiscalYear.size()>0){
            try{
            	if(Fiscal_Year_Model__c.SObjectType.getDescribe().isCreateable() && Fiscal_Year_Model__c.SObjectType.getDescribe().isUpdateable()) {
                upsert lstFiscalYear; 
            	}              
            }
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstFiscalYear),lstFiscalYear.size());
  }
  
  
  
  public static List<Planning_Version__c> createFiscalPeriods(S_FiscalYearSettings fiscal){
            
        Integer fyear = (fiscal.StartDate).Year();
        List<Planning_Version__c> lstPeriods = new List<Planning_Version__c>();  
        
        Integer count = fiscal.startDate.Month();
        Integer seq = 1;
        
        for(S_Period p : fiscal.periods){           
            if((p.Type).equals('Month')) {   
                lstPeriods.add(
                    new Planning_Version__c(
                        Fiscal_Year_Planning__c = (mapFiscalYear.ContainsKey(fyear+''))?mapFiscalYear.get(fyear+'').Id:null,
                        Is_this_a_Budget_Planning_Version__c     = false,
                        SequenceNo__c =  seq++,
                        Data_Entry_Closed_Date__c= p.EndDate,
                        Data_Entry_Start_Date__c  = p.StartDate,
                        Version_Status__c= 'Not Open',
                        Planning_Version_Fiscal_Year__c = fyear+'',
                        Planning_Version_Current_Period__c= p.StartDate.month()+'',
                        Record_Source__c = 'Installation'
                    )); 
            } 
        }
      
        return lstPeriods;
    }
  
  public static List<Fiscal_Year_Model__c> createCustomFiscalPeriods(S_FiscalYearSettings fiscal){List<wrapperQuarter> lstQuarterWrapper = new List<wrapperQuarter>();map<string,Integer> mapSeqMPNumber = new map<string,Integer>(); Integer seq = 1; map<Integer,Integer> mapQ = new map<Integer,Integer>();mapQ.put(1,1);    mapQ.put(2,1);   mapQ.put(3,1);   mapQ.put(4,2);    mapQ.put(5,2);    mapQ.put(6,2);     mapQ.put(7,3);   mapQ.put(8,3);  mapQ.put(9,3);  mapQ.put(10,4);   mapQ.put(11,4); mapQ.put(12,4); Map<Integer,String> mapMonthString = new Map<Integer,String>();mapMonthString .put(1,'January'); mapMonthString.put(2,'February');mapMonthString.put(3,'March');
        mapMonthString .put(4,'April');mapMonthString .put(5,'May'); mapMonthString .put(6,'June'); mapMonthString .put(7,'July'); mapMonthString .put(8,'August');  mapMonthString .put(9,'September'); mapMonthString .put(10,'October');mapMonthString .put(11,'November');   mapMonthString .put(12,'December');for(S_Period p : fiscal.periods){          if((p.Type).equals('Month')){mapSeqMPNumber.put(p.PID,seq++);lstQuarterWrapper.add(new wrapperQuarter(mapQ.get(p.MPNumber),p.StartDate,p.EndDate));  }   }  Integer fyear = (fiscal.Startdate).Year();List<Fiscal_Year_Model__c> lstPeriods = new List<Fiscal_Year_Model__c>();  Integer count = fiscal.startDate.Month(); for(S_Period p : fiscal.periods){ if((p.Type).equals('Month')) {lstPeriods.add(new Fiscal_Year_Model__c(
                           Name = 'FY'+fyear+'P'+mapSeqMPNumber.get(p.PID),Fiscal_Period_Id__c = p.PID, End_Date__c = p.EndDate,Start_Date__c  = p.StartDate,Fiscal_Year__c = fyear+'',                            Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),Period_Name__c=  mapMonthString.get(p.StartDate.month()),Period_Number__c =  mapSeqMPNumber.get(p.PID),Record_Source__c = 'Installation')); } }return lstPeriods;}
    public class wrapperQuarter{
        Integer QId;
        Date StartDate;
        Date EndDate;
        public wrapperQuarter(Integer QId,Date StartDate,Date EndDate){this.QId = QId;this.StartDate = StartDate; this.EndDate = EndDate;}
        
    }
  public static Integer getQuarterId(List<wrapperQuarter> lstQuarterWrapper,Date mStartDate,Date mEndDate){for(wrapperQuarter w : lstQuarterWrapper){if(w.StartDate <= mStartDate && w.EndDate >= mEndDate){ return w.QId; }} return 1; }
  
}