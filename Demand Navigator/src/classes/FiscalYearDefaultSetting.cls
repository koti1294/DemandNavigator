public with sharing class FiscalYearDefaultSetting { 

    public static map<String,Fiscal_Year_Planning__c>  mapFiscalYear;
    public FiscalYearDefaultSetting() { }    public static List<Planning_Version__c> createFiscalPeriods(FiscalYearSettings fiscal){ Integer fyear = (fiscal.EndDate).Year();        List<Planning_Version__c> lstPeriods = new List<Planning_Version__c>(); Integer count = fiscal.startDate.Month();Integer seq = 1; if((fiscal.PeriodLabelScheme).equals('Custom')){            for(Period p : fiscal.periods){ if((p.Type).equals('Month')) { lstPeriods.add(new Planning_Version__c(Fiscal_Year_Planning__c = mapFiscalYear.get(fyear+'').Id, Is_this_a_Budget_Planning_Version__c     = false,SequenceNo__c = seq++,Data_Entry_Closed_Date__c= p.EndDate,Data_Entry_Start_Date__c  = p.StartDate,Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fyear+'',Planning_Version_Current_Period__c= (count++)+'',MonthName__c = p.PeriodLabel,Record_Source__c = 'Installation')); if(count == 13)count =1;}  }}        else{ for(Period p : fiscal.periods){if((p.Type).equals('Month')) { lstPeriods.add(new Planning_Version__c(Fiscal_Year_Planning__c = mapFiscalYear.get(fyear+'').Id,Is_this_a_Budget_Planning_Version__c     = false,SequenceNo__c =  seq++,Data_Entry_Closed_Date__c= p.EndDate,                            Data_Entry_Start_Date__c  = p.StartDate,Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fyear+'',Planning_Version_Current_Period__c= p.Number+'',Record_Source__c = 'Installation'));                }   }   }        return lstPeriods;    }
    
    public class wrapperQuarter{
        Integer QId;
        Date StartDate;
        Date EndDate;
        public wrapperQuarter(Integer QId,Date StartDate,Date EndDate){this.QId = QId;this.StartDate = StartDate;this.EndDate = EndDate;}
        
    }
    
    public static Integer getQuarterId(List<wrapperQuarter> lstQuarterWrapper,Date mStartDate,Date mEndDate){for(wrapperQuarter w : lstQuarterWrapper){if(w.StartDate <= mStartDate && w.EndDate >= mEndDate){ return w.QId;}} return 1;} public static List<Fiscal_Year_Model__c> createCustomFiscalPeriods(FiscalYearSettings fiscal){List<wrapperQuarter> lstQuarterWrapper = new List<wrapperQuarter>(); map<Id,Integer> mapSeqNumber = new map<Id,Integer>();Integer seq = 1;for(Period p : fiscal.periods){ if((p.Type).equals('Quarter')){ lstQuarterWrapper.add(new wrapperQuarter(p.Number,p.StartDate,p.EndDate)); }if((p.Type).equals('Month')){ mapSeqNumber.put(p.Id,seq++);}}Integer fyear = (fiscal.EndDate).Year();List<Fiscal_Year_Model__c> lstPeriods = new List<Fiscal_Year_Model__c>();  Integer count = fiscal.startDate.Month();  if((fiscal.PeriodLabelScheme).equals('Custom')){          for(Period p : fiscal.periods){if((p.Type).equals('Month')) {   lstPeriods.add( new Fiscal_Year_Model__c(  Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.id),        Fiscal_Period_Id__c = p.Id,End_Date__c = p.EndDate, Start_Date__c  = p.StartDate, Fiscal_Year__c = fyear+'', Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),  Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:(count++)+'',Period_Number__c =  mapSeqNumber.get(p.id), Record_Source__c = 'Installation' ));                       if(count == 13)count =1;} }}  else{ for(Period p : fiscal.periods){  if((p.Type).equals('Month')) {      lstPeriods.add(     new Fiscal_Year_Model__c(                           Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.id), Fiscal_Period_Id__c = p.Id, End_Date__c = p.EndDate,      Start_Date__c  = p.StartDate,                    Fiscal_Year__c = fyear+'',    Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate), Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:p.Number+'', Period_Number__c =  mapSeqNumber.get(p.id), Record_Source__c = 'Installation'    ));    }   }  }return lstPeriods;   }


        public static DefaultSettingResponse putFiscalYearCustom(){
            
   
        if (Schema.sObjectType.FiscalYearSettings.fields.Description.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.IsStandardYear.isAccessible() &&
        	    Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible() && Schema.sObjectType.Period.fields.Id.isAccessible() && Schema.sObjectType.Period.fields.EndDate.isAccessible() &&
        	    Schema.sObjectType.Period.fields.FiscalYearSettingsId.isAccessible() && Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible() && Schema.sObjectType.Period.fields.Number.isAccessible() &&
        	    Schema.sObjectType.Period.fields.PeriodLabel.isAccessible() && Schema.sObjectType.Period.fields.QuarterLabel.isAccessible() && Schema.sObjectType.Period.fields.StartDate.isAccessible() &&
        	    Schema.sObjectType.Period.fields.Type.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible() &&
        	    Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.WeekLabelScheme.isAccessible() &&
        	    Schema.sObjectType.FiscalYearSettings.fields.WeekStartDay.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.YearType.isAccessible() ){
        	    	
         List<FiscalYearSettings> lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select Id,EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods order by startDate),PeriodLabelScheme,
        PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
        WeekStartDay,YearType from FiscalYearSettings where name <> null order by startdate limit 100];
        map<String,Fiscal_Year_Model__c> mapFY = new map<String,Fiscal_Year_Model__c>();
        
        if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isAccessible()
         && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
         && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible()  && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()){
        	
        


        for(Fiscal_Year_Model__c FY : [select Id, Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c ,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c from Fiscal_Year_Model__c where Name <> null]){
            mapFY.put(FY.Name,FY);
        }

       }	      
        
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
        for(FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Fiscal_Year_Model__c p: createCustomFiscalPeriods(fiscal)){
                if(mapFY.ContainsKey(p.Name)){
                    p = mapFY.get(p.Name);
                }
                else{
                    if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                        if((p.Period_Name__c).isNumeric() && mapMonthString.containsKey(Integer.valueOf(p.Period_Name__c)))
                        MonthName  = mapMonthString.get(Integer.valueOf(p.Period_Name__c));                            
                    }
                    else if((fiscal.PeriodLabelScheme).equals('Custom')){
                       MonthName  = p.Period_Name__c;
                       
                    }
                    else{
                       MonthName  = Prefix+'-'+p.Period_Name__c;                      
                    }
                    p.Period_Name__c  = MonthName;
                }
                lstFiscalYear.add(p);
            }
        }        
        if(lstFiscalYear.size()>0){
            try{
            	if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isUpdateable()
	&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable()) {
            	upsert lstFiscalYear; 
	}
}              
            
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstFiscalYear),lstFiscalYear.size());

            }
    return null;
        
}
    
    public Static DefaultSettingResponse putFiscalYearPlanningVersion(){
    	
    	if (Schema.sObjectType.FiscalYearSettings.fields.Description.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.IsStandardYear.isAccessible()
    	&& Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible() && Schema.sObjectType.Period.fields.EndDate.isAccessible() && Schema.sObjectType.Period.fields.FiscalYearSettingsId.isAccessible()
    	&& Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible() && Schema.sObjectType.Period.fields.Number.isAccessible() && Schema.sObjectType.Period.fields.PeriodLabel.isAccessible()
    	&& Schema.sObjectType.Period.fields.QuarterLabel.isAccessible() && Schema.sObjectType.Period.fields.StartDate.isAccessible() && Schema.sObjectType.Period.fields.Type.isAccessible()
    	&& Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.QuarterPrefix.isAccessible()
    	&& Schema.sObjectType.FiscalYearSettings.fields.QuarterLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.QuarterPrefix.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible()
    	&& Schema.sObjectType.FiscalYearSettings.fields.WeekLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.WeekStartDay.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.YearType.isAccessible() ){
    		
    	
       List<FiscalYearSettings> lstfiscalsetting = [select Description,EndDate,IsStandardYear,Name,(select EndDate,FiscalYearSettingsId,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods order by startdate ),PeriodLabelScheme,
        PeriodPrefix,QuarterLabelScheme,QuarterPrefix,StartDate,WeekLabelScheme,
        WeekStartDay,YearType from FiscalYearSettings where name <> null order by startdate  limit 100];
            

    	   
        map<String,Planning_Version__c> mapFP = new map<String,Planning_Version__c>();

		
		if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isAccessible()
		 && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible()
		 && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
		 && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isAccessible() ){
			
		
		
        for(Planning_Version__c plan : [select id,Name,Fiscal_Year_Planning__c,Is_this_a_Budget_Planning_Version__c ,SequenceNo__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c,Version_Status__c,
        Planning_Version_Fiscal_Year__c,Planning_Version_Current_Period__c,MonthName__c from Planning_Version__c where Name <> null and Data_Entry_Start_Date__c <> null]){
            mapFP.put(plan.Name,plan);
        }

	  }
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
        List<Fiscal_Year_Planning__c>  lstFiscalYear = new List<Fiscal_Year_Planning__c>();
        
        
        map<String,Fiscal_Year_Planning__c> mapOFY = new map<String,Fiscal_Year_Planning__c>();
        
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
        	
       
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c where name <> null]){
            mapOFY.put(fy.name,fy);            
        }
       }
        for(FiscalYearSettings fiscal : lstfiscalsetting ){
            Fiscal_Year_Planning__c pv;
            if(mapOFY.containsKey(fiscal.Name))
                pv = mapOFY.get(fiscal.Name);
            else
                pv = new Fiscal_Year_Planning__c(name = fiscal.Name,StartDate__c = fiscal.startDate,EndDate__c = fiscal.EndDate,Record_Source__c = 'Installation');
            lstFiscalYear.add(pv);
        }
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isUpdateable()
	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable()
	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isUpdateable()
	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isUpdateable()
	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Record_Source__c.isCreateable()) {
        upsert lstFiscalYear;

	}
        mapFiscalYear = new map<String,Fiscal_Year_Planning__c>();
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible() ){
         
        
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c where name <> null]){
            mapFiscalYear.put(fy.name,fy);            
        }

       } 
        for(FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Planning_Version__c p: createFiscalPeriods(fiscal)){
                if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                    if(mapMonthString.containsKey(Integer.valueOf(p.Planning_Version_Current_Period__c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.Planning_Version_Current_Period__c));                            
                }
                else if((fiscal.PeriodLabelScheme).equals('Custom')){
                   MonthName  = p.MonthName__c;
                   
                }
                else{
                   MonthName  = Prefix+'-'+p.Planning_Version_Current_Period__c;                      
                }                    
                p.MonthName__c = MonthName; 
                p.Name = p.Planning_Version_Fiscal_Year__c+'-'+MonthName;
                
                if(mapFP.containsKey(p.Name)){
                    p = mapFP.get(p.Name);
                }
                
                lstPlanninerVersion.add(p);
            }
        }
        
        if(lstPlanninerVersion.size()>0){
            try{
            	if (Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable()
	&& Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable()
	&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable()
	&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()
	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable()
	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isUpdateable()
	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()) {
            	upsert lstPlanninerVersion; 
	}
            }
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstPlanninerVersion),lstPlanninerVersion.size());

    }     
    return null;
}

    
    public Static DefaultSettingResponse putAdditionalPlanningVersion(){

        map<String,String> mapAPDesc = new map<String,String>();
        mapAPDesc.put('Budget01','');
        mapAPDesc.put('Budget02','');
        mapAPDesc.put('Budget03','');

        
        map<String,Additional_Planning_Versions__c> MapOrgAP = new Map<String,Additional_Planning_Versions__c>();
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isAccessible()){
         
        
        for(Additional_Planning_Versions__c AP : [select Name,Version_Description__c from Additional_Planning_Versions__c where name <> null]){
            MapOrgAP.put(AP.Name,AP);
        }
       }
        List<Additional_Planning_Versions__c> lstAddPlanning = new List<Additional_Planning_Versions__c>();
        for(String AP : mapAPDesc.keySet()){
            Additional_Planning_Versions__c APObj;
            if(MapOrgAP.containsKey(AP)){
                APObj = MapOrgAP.get(AP);
            }
            else{APObj = new Additional_Planning_Versions__c(Name = AP,Version_Description__c = mapAPDesc.get(AP),Record_Source__c = 'Installation');}
            lstAddPlanning.add(APObj);
        }
        if(lstAddPlanning.size()>0){
            try{
            	if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isUpdateable()
	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isCreateable()
	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isUpdateable()
	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isCreateable()
	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Record_Source__c.isUpdateable()
	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Record_Source__c.isCreateable()) {
            	upsert lstAddPlanning;  
	}
}            
            
            catch(Exception e){
                //system.debug('#Error:'+e);
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        
        //Remaining Additional Year
        putRemainingAdditionalPeriods(MapOrgAP.values());
        return new DefaultSettingResponse(true,String.ValueOf(lstAddPlanning),lstAddPlanning.size());
    }

    
    public static void putRemainingAdditionalPeriods(List<Additional_Planning_Versions__c> lstAdditionalPlanning){
    Set<string> setExistingFiscalYear = new Set<String>();

    if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()){
          
        
    for(Planning_Version__c pv : [select Planning_Version_Fiscal_Year__c from Planning_Version__c where Is_this_a_Budget_Planning_Version__c = true]){
        setExistingFiscalYear.add(pv.Planning_Version_Fiscal_Year__c);
    }

   }
    List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();

   if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()){
   	
    List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where Name <> null and Name Not IN: setExistingFiscalYear order by startdate__c ];
    
   if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
    
   
    if(lstfiscalsetting.size() >0 ){Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c  = true Group By Planning_Version_Fiscal_Year__c];for (AggregateResult ar : lstSeqNo)  {            mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));}for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){Integer seq = 99;if(mapYearMaxSeq.ContainsKey(fiscal.Name))seq = mapYearMaxSeq.get(fiscal.Name);for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){lstPlanningversion.add(new Planning_Version__c(Fiscal_Year_Planning__c = fiscal.Id,Name = fiscal.Name+'-'+ap.Name,Additional_Planning_Version__c = ap.Id,Is_this_a_Budget_Planning_Version__c     = true,SequenceNo__c = ++seq,Data_Entry_Closed_Date__c= fiscal.EndDate__c,Data_Entry_Start_Date__c  = fiscal.StartDate__c,Version_Status__c= 'Not Open',Planning_Version_Fiscal_Year__c = fiscal.Name,Planning_Version_Current_Period__c= '',MonthName__c =ap.Name,Planning_Version_Description__c = ap.Version_Description__c ) );}}
    }


   }
  } 
    if(lstPlanningversion.size()>0){
    	if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
    	 upsert lstPlanningversion;
    	}
     }
}
    
    public Static DefaultSettingResponse putFinancialMeasure(){

        map<String,String> mapFMDesc = new map<String,String>();
        mapFMDesc.put('Revenue','Revenue recognized');
        mapFMDesc.put('Revenue Adjustment','Adjustment to Revenue recognized');
        mapFMDesc.put('Revenue Backlog','Revenue Backlog calculated');
        mapFMDesc.put('Sales Booking','Sales Booking recognized');
        mapFMDesc.put('Gap Mitgation','Gap Mitgation Booking recognized');
        
        map<String,String> mapFMType = new map<String,String>();
        mapFMType.put('Revenue','Income');
        mapFMType.put('Revenue Adjustment','Income');
        mapFMType.put('Revenue Backlog','KPI');
        mapFMType.put('Sales Booking','KPI');
        mapFMType.put('Gap Mitgation','KPI');
        
        
        map<String,Planning_Financial_Measure__c> MapOrgFM = new Map<String,Planning_Financial_Measure__c>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()) {
          
        
        for(Planning_Financial_Measure__c FM : [select Name,Measure_Description__c,Measure_Type__c  from Planning_Financial_Measure__c where name <> null]){
            MapOrgFM.put(FM.Name,FM);
        }
       }
        List<Planning_Financial_Measure__c> lstFinancialMeasure = new List<Planning_Financial_Measure__c>();
        for(String FM : mapFMDesc.keySet()){
            Planning_Financial_Measure__c FMObj;
            if(MapOrgFM.containsKey(FM)){
                FMObj = MapOrgFM.get(FM);
            }
            else{Boolean AutoCalculated = false; if(FM == 'Revenue Backlog') AutoCalculated = true;FMObj = new Planning_Financial_Measure__c( Name = FM,Automatically_Calculated__c= AutoCalculated , Measure_Description__c = mapFMDesc.get(FM),Measure_Type__c = mapFMType.get(FM),Record_Source__c = 'Installation',Unit_of_Measure__c = 'Currency',Restricted_by_Revenue_Term__c = !AutoCalculated );}
            lstFinancialMeasure.add(FMObj);
        }

        if(lstFinancialMeasure.size()>0){
            try{
            	if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isCreateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isUpdateable()
	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isCreateable()) {
            	upsert lstFinancialMeasure;  
	}
                         
            }
            catch(Exception e){//system.debug('RR3:'+e);
            	 return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0); }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstFinancialMeasure),lstFinancialMeasure.size());
    }
    
    
}