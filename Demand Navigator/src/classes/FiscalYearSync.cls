public with sharing class FiscalYearSync {
    public static map<String,Fiscal_Year_Planning__c>  mapFiscalYear;
  public static List<FiscalYearSettings> lstfiscalsetting;
  public static List<Additional_Planning_Versions__c> lstAdditionalPlanning;
  
  
  public static void Initialization(List<FiscalYearSettings> lstfs){
  Map<Integer,String> mapMonthString2 = new Map<Integer,String>();
            
        mapMonthString2.put(1,'January');
        mapMonthString2.put(2,'February');
        mapMonthString2.put(3,'March');
        mapMonthString2.put(4,'April');
        mapMonthString2.put(5,'May');
        mapMonthString2.put(6,'June');
        mapMonthString2.put(7,'July');
        mapMonthString2.put(8,'August');
        mapMonthString2.put(9,'September');
        mapMonthString2.put(10,'October');
        mapMonthString2.put(11,'November');
        mapMonthString2.put(12,'December');
        
    mapFiscalYear = new map<String,Fiscal_Year_Planning__c>();
    lstfiscalsetting = new List<FiscalYearSettings>();
    if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Id.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isAccessible() ){
         
        
    lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where name <> null];

    }  
    
    map<String,Fiscal_Year_Planning__c> mapOFY = new map<String,Fiscal_Year_Planning__c>();
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
        	
        
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c  where name <> null]){
            mapOFY.put(fy.name,fy);            
        }

       } 
        Set<String> setFName = new Set<String>();
    
    List<Fiscal_Year_Planning__c> lstFYP = new List<Fiscal_Year_Planning__c>();
        for(FiscalYearSettings fiscal : lstfs ){Fiscal_Year_Planning__c pv;if(mapOFY.containsKey(fiscal.Name))pv = mapOFY.get(fiscal.Name); else{pv = new Fiscal_Year_Planning__c(name = fiscal.Name,StartDate__c = fiscal.startDate,EndDate__c = fiscal.EndDate,Record_Source__c = 'Installation');setFName.add(fiscal.Name); lstfiscalsetting.add(fiscal);      }            lstFYP.add(pv);  }
	       if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isUpdateable()
		&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.name.isCreateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isUpdateable()
		&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isUpdateable()
		&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()  && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isUpdateable()
		&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isCreateable()) {
        upsert lstFYP;

		}
		if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()  && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() ){
          
        
    for(Fiscal_Year_Planning__c fy:[select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where NAme <> null and Name IN: setFName]){     mapFiscalYear.put(fy.name,fy);         }
    
    
    
  }
  }
  public static DefaultSettingResponse putFiscalPeriods(){
  
  Map<Integer,String> mapMonthString2 = new Map<Integer,String>();
            
        mapMonthString2.put(1,'January');
        mapMonthString2.put(2,'February');
        mapMonthString2.put(3,'March');
        mapMonthString2.put(4,'April');
        mapMonthString2.put(5,'May');
        mapMonthString2.put(6,'June');
        mapMonthString2.put(7,'July');
        mapMonthString2.put(8,'August');
        mapMonthString2.put(9,'September');
        mapMonthString2.put(10,'October');
        mapMonthString2.put(11,'November');
        mapMonthString2.put(12,'December');
        
    
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
    
    for(FiscalYearSettings fiscal : lstfiscalsetting ){Integer fyear = (fiscal.EndDate).Year();String  Prefix = fiscal.PeriodPrefix; String MonthName;for(Planning_Version__c p: createFiscalPeriods(fiscal)){if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){if(mapMonthString.containsKey(Integer.valueOf(p.Planning_Version_Current_Period__c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.Planning_Version_Current_Period__c));}else if((fiscal.PeriodLabelScheme).equals('Custom')){ MonthName  = p.MonthName__c;}else{MonthName  = Prefix+'-'+p.Planning_Version_Current_Period__c;}  p.MonthName__c = MonthName; p.Name = p.Planning_Version_Fiscal_Year__c+'-'+MonthName;lstPlanninerVersion.add(p); }}if(lstPlanninerVersion.size()>0){try{
                    if (Schema.sObjectType.Planning_Version__c.fields.Monthname__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Monthname__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable()){
                    	upsert lstPlanninerVersion;
                    }
                    }catch(Exception e){return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);}}return new DefaultSettingResponse(true,String.ValueOf(lstPlanninerVersion),lstPlanninerVersion.size());}
  
  public static DefaultSettingResponse putFiscalAdditionalPeriods(){
     Map<Integer,String> mapMonthString1 = new Map<Integer,String>();
            
        mapMonthString1.put(1,'January');
        mapMonthString1.put(2,'February');
        mapMonthString1.put(3,'March');
        mapMonthString1.put(4,'April');
        mapMonthString1.put(5,'May');
        mapMonthString1.put(6,'June');
        mapMonthString1.put(7,'July');
        mapMonthString1.put(8,'August');
        mapMonthString1.put(9,'September');
        mapMonthString1.put(10,'October');
        mapMonthString1.put(11,'November');
        mapMonthString1.put(12,'December');
    mapMonthString1.put(1,'January');
        mapMonthString1.put(2,'February');
        mapMonthString1.put(3,'March');
        mapMonthString1.put(4,'April');
        mapMonthString1.put(5,'May');
        mapMonthString1.put(6,'June');
        mapMonthString1.put(7,'July');
        mapMonthString1.put(8,'August');
        mapMonthString1.put(9,'September');
        mapMonthString1.put(10,'October');
        mapMonthString1.put(11,'November');
        mapMonthString1.put(12,'December');
        
    Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();

    if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
        
        
    AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c  = true Group By Planning_Version_Fiscal_Year__c];
            
    for (AggregateResult ar : lstSeqNo)  {
      mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
    }

    } 
    List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
    
    for(Fiscal_Year_Planning__c fiscal :  mapFiscalYear.values() ){
    Integer seq = 99;
    if(mapYearMaxSeq.ContainsKey(fiscal.Name))
        seq = mapYearMaxSeq.get(fiscal.Name); 
    for(Additional_Planning_Versions__c ap: lstAdditionalPlanning )
        { 
    ++seq;
            lstPlanningversion.add( 
            new Planning_Version__c( Fiscal_Year_Planning__c = fiscal.Id, Name = fiscal.Name+'-'+ap.Name, Additional_Planning_Version__c = ap.Id,Is_this_a_Budget_Planning_Version__c     = true, SequenceNo__c = seq,Data_Entry_Closed_Date__c= fiscal.EndDate__c,            Data_Entry_Start_Date__c  = fiscal.StartDate__c,Version_Status__c= 'Not Open', Planning_Version_Fiscal_Year__c = fiscal.Name,            Planning_Version_Current_Period__c= seq+'', MonthName__c =ap.Name, Planning_Version_Description__c = ap.Version_Description__c )
            );
        }
    }
      
    if(lstPlanningversion.size()>0){try{
    	 if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
    	 	upsert lstPlanningversion;
    	 }
     }catch(Exception e){ return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);  } }        return new DefaultSettingResponse(true,String.ValueOf(lstPlanningversion),lstPlanningversion.size());
  }
  
  public static DefaultSettingResponse putCustomFiscalYear(){
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
        
        
        
        
        List<Fiscal_Year_Model__c>  lstFiscalYear = new List<Fiscal_Year_Model__c>();
        for(FiscalYearSettings fiscal : lstfiscalsetting ){Integer fyear = (fiscal.EndDate).Year();String  Prefix = fiscal.PeriodPrefix;String MonthName; for(Fiscal_Year_Model__c p: createCustomFiscalPeriods(fiscal)){ if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){if((p.Period_Name__c).isNumeric() && mapMonthString.containsKey(Integer.valueOf(p.Period_Name__c)))MonthName  = mapMonthString.get(Integer.valueOf(p.Period_Name__c)); }
        else if((fiscal.PeriodLabelScheme).equals('Custom')){MonthName  = p.Period_Name__c;}  else{MonthName  = Prefix+'-'+p.Period_Name__c;  }  p.Period_Name__c  = MonthName; lstFiscalYear.add(p); }}        
        if(lstFiscalYear.size()>0){  try{
        	if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isUpdateable()){
	        	upsert lstFiscalYear;
        	}
        	}  catch(Exception e){return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);  }}
        return new DefaultSettingResponse(true,String.ValueOf(lstFiscalYear),lstFiscalYear.size());
  }
  
  
  
  public static List<Planning_Version__c> createFiscalPeriods(FiscalYearSettings fiscal){ Integer fyear = (fiscal.EndDate).Year();List<Planning_Version__c> lstPeriods = new List<Planning_Version__c>(); Integer count = fiscal.startDate.Month();Integer seq = 1; if((fiscal.PeriodLabelScheme).equals('Custom')){ for(Period p : fiscal.periods){    if((p.Type).equals('Month')) {   lstPeriods.add(  new Planning_Version__c( Fiscal_Year_Planning__c = mapFiscalYear.get(fyear+'').Id, Is_this_a_Budget_Planning_Version__c     = false,                            SequenceNo__c = seq++,  Data_Entry_Closed_Date__c= p.EndDate,Data_Entry_Start_Date__c  = p.StartDate,                            Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fyear+'', Planning_Version_Current_Period__c= (count++)+'', MonthName__c = p.PeriodLabel,                            Record_Source__c = 'Installation'          ));   if(count == 13)count =1;}  }}       else{        for(Period p : fiscal.periods){   if((p.Type).equals('Month')) { lstPeriods.add(   new Planning_Version__c( Fiscal_Year_Planning__c = mapFiscalYear.get(fyear+'').Id,Is_this_a_Budget_Planning_Version__c     = false, SequenceNo__c =  seq++, Data_Entry_Closed_Date__c= p.EndDate,Data_Entry_Start_Date__c  = p.StartDate, Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fyear+'',Planning_Version_Current_Period__c= p.Number+'', Record_Source__c = 'Installation' )); }   }   }return lstPeriods;}
  
  public static List<Fiscal_Year_Model__c> createCustomFiscalPeriods(FiscalYearSettings fiscal){List<wrapperQuarter> lstQuarterWrapper = new List<wrapperQuarter>();map<Id,Integer> mapSeqNumber = new map<Id,Integer>();Integer seq = 1;for(Period p : fiscal.periods){if((p.Type).equals('Quarter')){lstQuarterWrapper.add(new wrapperQuarter(p.Number,p.StartDate,p.EndDate)); }if((p.Type).equals('Month')){mapSeqNumber.put(p.Id,seq++);} }Integer fyear = (fiscal.EndDate).Year();List<Fiscal_Year_Model__c> lstPeriods = new List<Fiscal_Year_Model__c>(); Integer count = fiscal.startDate.Month(); if((fiscal.PeriodLabelScheme).equals('Custom')){for(Period p : fiscal.periods){if((p.Type).equals('Month')) { lstPeriods.add( new Fiscal_Year_Model__c(Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.id),Fiscal_Period_Id__c = p.Id,End_Date__c = p.EndDate,Start_Date__c  = p.StartDate,Fiscal_Year__c = fyear+'',Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),                            Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:(count++)+'',                            Period_Number__c =  mapSeqNumber.get(p.id),Record_Source__c = 'Installation'  )); if(count == 13)count =1; }}}else{for(Period p : fiscal.periods){if((p.Type).equals('Month')) {lstPeriods.add(new Fiscal_Year_Model__c(Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.id),                            Fiscal_Period_Id__c = p.Id,End_Date__c = p.EndDate,Start_Date__c  = p.StartDate,Fiscal_Year__c = fyear+'',Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:p.Number+'',Period_Number__c =  mapSeqNumber.get(p.id),Record_Source__c = 'Installation'  ));  }   }  }   return lstPeriods; }
  public class wrapperQuarter{
        Integer QId;
        Date StartDate;
        Date EndDate;
        public wrapperQuarter(Integer QId,Date StartDate,Date EndDate){ this.QId = QId;this.StartDate = StartDate;   this.EndDate = EndDate; }
        
    }
  public static Integer getQuarterId(List<wrapperQuarter> lstQuarterWrapper,Date mStartDate,Date mEndDate){for(wrapperQuarter w : lstQuarterWrapper){if(w.StartDate <= mStartDate && w.EndDate >= mEndDate){return w.QId;}}return 1;}
  
}