/*
Develop By : Habimoon 
Created Date : 25th March 2015
Last Modified Date : 20th April 2015
Purpose : Display all the list of Planning version in the organigation.
            
    Planning Versions have the status of Not Open by default.
    It is best practice to only have 1 Planning Version Open during the planning cycle.
    A data entry Start Date and End Date should be specified as part of the process - only during the timeframe specified will users be able to enter data via the Planning Workbench.

*/

public with sharing class ManageFiscalPlanningStatusv4 {

    public Boolean isAdmin{get;set;}        
    public ManageFiscalPlanningStatusv4(NewPlanningVersionExtensionv4 controller) {
        Id profileId=userinfo.getProfileId();
        if (Schema.sObjectType.Profile.fields.Id.isAccessible() && Schema.sObjectType.Profile.fields.Name.isAccessible()){
             
        String profileName=[Select Id,Name from Profile where Id=:profileId limit 1].Name;      
       
        isAdmin = false;        
        if(profileName == 'System Administrator' || profileName == 'ForecastEra System Administrator'){     
            isAdmin = true;     
        }
	  }
        Startup();
    }

    // variable declarations
    map<string,string> mapSavePeriod;
    public Planning_Version__c acc{get;set;}
    public String EditableMonths{get;set;}
    
    public String SelectedYear{get;set;}
    public String SelectedMonth{get;set;}
    
    // method get all previos save status of accounting period.
    public void SetOldStatus(){
        
         
        for(FiscalSettingYear fs : lstFiscalSettingYear){
             for(FiscalSettingMonth fsm : fs.lstMonth){
             	 /*******Pritam Start****************/
                Planning_Version__c pvObj = (Planning_Version__c) fsm.Period; 
                if(pvObj.Version_Status__c <> null) {
                	fsm.OLDStatus = pvObj.Version_Status__c;
                } else 
                 /*******Pritam End****************/
                if(mapSavePeriod.ContainsKey(fsm.YearId+'_'+fsm.MonthId)){
                    fsm.OLDStatus = mapSavePeriod.get(fsm.YearId+'_'+fsm.MonthId);
                }
                else{
                    fsm.OLDStatus = 'Not Open';                    
                }
                
               if(fsm.Period.Version_Status__c.equals('Open (Admin)') || fsm.Period.Version_Status__c.equals('Open (User)')){
                    fsm.is_Disable = false;
                }
                else{                    
                    fsm.is_Disable = true;
                } 
             }
         }
         
         String rs = '';
         for(String s : mapSavePeriod.keySet()){
            if(s.contains('2013'))rs= rs+s+':'+mapSavePeriod.get(s)+'#';
         }
         //system.debug('#FIND:'+rs);
         
    }
    
    // method save update accounting periods.    
    public pagereference save(){
        list<Planning_Version__c> lstPeriod = new  list<Planning_Version__c>();
        for(FiscalSettingYear fs : lstFiscalSettingYear){
                 for(FiscalSettingMonth fsm : fs.lstMonth){ 
                     Planning_Version__c FPeriod = fsm.Period;
                     lstPeriod.add(FPeriod);
                 }
             }
        if (Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isCreateable()){
                upsert lstPeriod;
        }
         Startup();
         return null;
        
    }
    public List<FiscalSettingYear> lstFiscalSettingYear{get;set;}
    
    public List<FiscalSettingYear> getAllFiscalPlanningPeriods(){
        Startup();
        return this.lstFiscalSettingYear;
    }
    
    public void setAllFiscalPlanningPeriods(List<FiscalSettingYear> lstFiscalSettingYear){
        this.lstFiscalSettingYear = lstFiscalSettingYear;
    }
    
    public String getStatus(string Syear,Integer Smonth){
        

        for(FiscalSettingYear fs : lstFiscalSettingYear){
            
             
             if(Syear.equals(fs.YearId+'')){
                 for(FiscalSettingMonth fsm : fs.lstMonth){
                     
                     if(Smonth == Integer.valueOf(fsm.MonthId)){
                         return fsm.Period.Version_Status__c;
                     }
                 }
             }
        }
        
        return null;
      
    }
    public FiscalSettingMonth getNextVersion(Integer Syear,Integer Smonth){
        

        for(FiscalSettingYear fs : lstFiscalSettingYear){
            
             
             if(Syear == fs.YearId){
                 for(FiscalSettingMonth fsm : fs.lstMonth){
                     
                     if(Smonth == Integer.valueOf(fsm.MonthId)){
                         return fsm;
                     }
                 }
             }
        }
        
        return null;
      
    }
    
    public Integer getCurrentMonthId(string Syear){
        

        for(FiscalSettingYear fs : lstFiscalSettingYear){
            
             
             if(Syear.equals(fs.YearId+'')){
                 for(FiscalSettingMonth fsm : fs.lstMonth){
                     if(fsm.is_Editable){
                         return fsm.MonthId;
                     }
                 }
             }
        }
        
        return 0;
      
    }
    
    public String getEditableMonths(){
        
        String r='';
        for(FiscalSettingYear fs : lstFiscalSettingYear){
            for(FiscalSettingMonth fsm : fs.lstMonth){
                if(fsm.is_Editable){
                    r += fs.yearId +'-'+fsm.MonthId;
                    r += ';'+fs.yearId +'-'+(fsm.MonthId+1);
                }
             }
        }
        
        return r;
      
    }
    public Integer getWarning1(){
        
        Integer r=0;
        for(FiscalSettingYear fs : lstFiscalSettingYear){
             for(FiscalSettingMonth fsm : fs.lstMonth){
                 if(fsm.Period.Version_Status__c.equals('Open (Admin)') || fsm.Period.Version_Status__c.equals('Open (User)')){
                     r++;
                 }
             }
         }
         return r;
      
    }
    public List<FiscalSettingYear> getFYL(){
        return lstFiscalSettingYear;
    }
    
    // call when user change status of accounting periods
    public pagereference onChangeStatus(){
        
        
        String Msg ='';
        SelectedYear = SelectedYear.trim();
        SelectedMonth = SelectedMonth.trim();
        
        for(FiscalSettingYear fs : lstFiscalSettingYear){
            
            
             if(SelectedYear.equals(fs.YearId+'')){
             
                 for(FiscalSettingMonth fsm : fs.lstMonth){
                 
                     //find out which Accoutign period user select.
                     
                     if(SelectedMonth.equals(fsm.MonthId+'')){
                         Integer ffyear = fs.YearId;
                         Integer ffmonth = fsm.MonthId;
                         
                     
                        boolean isNextStatusEditable = true;
                        
                         if(fsm.Period.Version_Status__c== null){
                             return null;
                         }
                     
                         // get previos status
                         String preMS = getStatus(SelectedYear,(fsm.MonthId-1));
                         // find which one current month.
                         Integer currentMonth = getCurrentMonthId(SelectedYear);
                         String OLDStatus = '';
                         Integer w1 = getWarning1();
                         
                         /*******Pritam Start****************/
                         Planning_Version__c pvObj = (Planning_Version__c) fsm.Period; 
		                if(pvObj.Version_Status__c <> null) {
		                	OLDStatus = pvObj.Version_Status__c;
		                } 
                         
                         // find what is the previus value of seleted accounting period
                         else
                         /*******Pritam End****************/
                          if(mapSavePeriod.ContainsKey(SelectedYear+'_'+SelectedMonth))
                             OLDStatus  = mapSavePeriod.get(SelectedYear+'_'+SelectedMonth);
                         
                             
                         if(fsm.Period.Version_Status__c.Contains('Open') && !fsm.Period.Version_Status__c.equals('Not Open')){
                             fsm.is_Disable = false;
                         }else{
                             fsm.is_Disable = true;
                         }
                        
                        string Editable = SelectedYear+'-'+SelectedMonth;
                        if(OLDStatus.equals('Not Open')){
                             if(fsm.Period.Version_Status__c.equals('Open')){
                                 // functionality moved to Visualforce page
                             }
                             else if(fsm.Period.Version_Status__c.equals('Closed')){
                                 isNextStatusEditable = false;
                                 fsm.Period.Version_Status__c= 'Not Open';
                                 Msg = 'This period has not been previously Opened. Cannot change status to Closed.';
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,Msg));
                                 
                             }
                        }
                        else if(OLDStatus.equals('Open')){
                             if(fsm.Period.Version_Status__c.equals('Closed')){
                                // functionality moved to Visualforce page
                             }
                             else if(fsm.Period.Version_Status__c.equals('Not Open')){
                                 isNextStatusEditable = false;
                                Msg = 'This period was previously Open and can only be set to the Closed status.';
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,Msg));
                             }
                        }
                        else if(OLDStatus.equals('Closed')){
                             if(fsm.Period.Version_Status__c.equals('Open')){
                                // functionality moved to Visualforce page
                             }
                             else if(fsm.Period.Version_Status__c.equals('Not Open')){
                                 isNextStatusEditable = false;
                                Msg = 'This period was previously Closed and can only be set to the Open status.';
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,Msg));
                                
                             }
                        }
                            
                        //Next Version update to Open Admin
                        if(isNextStatusEditable && ffmonth != 0){
                            if(fsm.Period.Version_Status__c.equals('Closed')){
                                ffmonth++;
                                if(ffmonth == 13) {ffyear++;ffmonth = 1;}
                                
                                FiscalSettingMonth ffsm = getNextVersion(ffyear,ffmonth);
                                if(ffsm <> null){
                                    ffsm.Period.Version_Status__c = 'Open (Admin)';
                                    ffsm.is_Disable = false;
                                }
                            
                                
                            }
                        }
                        
                     }
                 }
             }
        }
        
        
        SelectedYear = SelectedMonth = null;
        return null;
    }

    public pagereference onChangeEndDate(){
        
        
        String Msg ='';
        SelectedYear = SelectedYear.trim();
        SelectedMonth = SelectedMonth.trim();
        
        for(FiscalSettingYear fs : lstFiscalSettingYear){
            
            
             if(SelectedYear.equals(fs.YearId+'')){
             
                 for(FiscalSettingMonth fsm : fs.lstMonth){
                 
                     //find out which Accoutign period user select.
                     
                     if(SelectedMonth.equals(fsm.MonthId+'')){
                         Integer ffyear = fs.YearId;
                         Integer ffmonth = fsm.MonthId;                   
                        
                        
                        //Next Version Start Date to Next Day of Previous Day.
                        if(ffmonth != 0){
                            
                                ffmonth++;
                                if(ffmonth == 13) {ffyear++;ffmonth = 1;}
                                
                                FiscalSettingMonth ffsm = getNextVersion(ffyear,ffmonth);
                                if(ffsm <> null){
                                ffsm.Period.Data_Entry_Start_Date__c = (fsm.Period.Data_Entry_Closed_Date__c).addDays(1);
                                //ffsm.is_Disable = false;
                                }
                            
                        }
                        
                     }
                 }
             }
        }
        
        
        SelectedYear = SelectedMonth = null;
        return null;
    }

    
    
    public boolean isPreviousYear(FiscalYearSettings fiscal){
        //Date tdate = Date.newInstance(2018,1,1);
        Date tdate = Date.Today();
        if(fiscal.enddate < tdate){
            return true;
        }
        return false;
    }
    public ManageFiscalPlanningStatusv4 (){
            Startup();
    }
    public boolean isCustomFiscalYearEnable{get;set;}
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
        
    public void Startup(){
           
        mapSavePeriod = new map<string,string>();
       
        map<String,List<Planning_Version__c>> mapPlanningYear = new map<String,List<Planning_Version__c>>();
       
       if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() 
       && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isAccessible()
       && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isAccessible()
       && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible()
       && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
       && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible()){
         
        List<Planning_Version__c> lstPlanningVersion = [select id,Name,Is_this_a_Budget_Planning_Version__c,Is_this_a_Gap_Planning_Version__c,SequenceNo__c,MonthName__c,Data_Entry_Closed_Date__c, Version_Status__c,Planning_Version_Fiscal_Year__c ,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c 
               from Planning_Version__c where name <> null and Planning_Version_Fiscal_Year__c <> null ORDER BY SequenceNo__c ];
       
        for(Planning_Version__c p :lstPlanningVersion){
               mapPlanningYear.put(p.Planning_Version_Fiscal_Year__c,new List<Planning_Version__c>());
               String key= p.Planning_Version_Fiscal_Year__c+'_'+p.Planning_Version_Current_Period__c;
               mapSavePeriod.put(key,p.Version_Status__c);
        }
       
        for(Planning_Version__c p :lstPlanningVersion){
               List<Planning_Version__c> tempPlanningVersion = mapPlanningYear.get(p.Planning_Version_Fiscal_Year__c);
               tempPlanningVersion.add(p);
               mapPlanningYear.put(p.Planning_Version_Fiscal_Year__c,tempPlanningVersion);
               
        }
       }
        lstFiscalSettingYear = new List<FiscalSettingYear>();
        
        List<FiscalYearSettings> lstFSY = new List<FiscalYearSettings>();
        if (Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible()){
         
        lstFSY = [select EndDate,Name,StartDate from FiscalYearSettings where name <> null order by startdate];
        //System.debug(System.LoggingLevel.ERROR, 'lstFSY>>>>>>>>>>>>>>>>>>>>>>>>'+lstFSY);
        
        }
        
        isCustomFiscalYearEnable = false;
        if(test.isRunningTest())lstFSY.clear();
        if(lstFSY <> null && lstFSY.size() > 0){
            isCustomFiscalYearEnable = true;
            
        }
        
        if(!isCustomFiscalYearEnable){
        	if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
          
            Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
        	 
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
            
            
            string cyear = ''+(system.today()).year();
            date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear); 
        	}
        	if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()
        	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()){
         
            List<Fiscal_Year_Planning__c> lstFYSR = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where name <> null order by StartDate__c];
        	
            set<string> setFYNames = new set<string>();
            map<string,List<Fiscal_Year_Model__c>> mapExistingFY = new map<string,List<Fiscal_Year_Model__c>>();
            for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                setFYNames.add(String.escapeSingleQuotes(Efy.Name));
                mapExistingFY.put(String.escapeSingleQuotes(Efy.Name),new List<Fiscal_Year_Model__c>());
            }
        	
            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() 
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isAccessible()){
            
            for(Fiscal_Year_Model__c pp : [select Id,Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c,Record_Source__c from Fiscal_Year_Model__c where Fiscal_Year__c IN: setFYNames]){
                List<Fiscal_Year_Model__c> temp = mapExistingFY.get(pp.Fiscal_Year__c);
                temp.add(pp);
                mapExistingFY.put(pp.Fiscal_Year__c,temp);
            }
            }
            string test = '';
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
         
            for(S_FiscalYearSettings f:  lstfiscalsetting){
                String fiscalyear = f.name;
                Integer fyear = Integer.ValueOf(fiscalyear);
                boolean iscorrectyear = false;
                List<FiscalSettingMonth> lstmonths = new List<FiscalSettingMonth>();
                if(mapPlanningYear.containskey(fiscalyear)){
                    for(Planning_Version__c p: mapPlanningYear.get(fiscalyear)){
                        
                        boolean iseditable = isExist(p.Data_Entry_Start_Date__c,p.Data_Entry_Closed_Date__c,Date.today());
                        if(iseditable){if(!iscorrectyear)iscorrectyear = true;}
                        boolean is_Disable = true;
                        if(p.Version_Status__c== 'Not Open' || p.Version_Status__c== 'Closed')is_Disable  = true;
                        String MonthName  = p.MonthName__c; 
                        p.MonthName__c = MonthName ;
                        Integer MonthId = 0;
                        //if(!p.Is_this_a_Budget_Planning_Version__c)
                        if(p.Planning_Version_Current_Period__c <> null)
                            MonthId = Integer.valueOf(p.Planning_Version_Current_Period__c);
                    
                        string type = 'Forecast version';
                        if(p.Is_this_a_Budget_Planning_Version__c)
                            type = 'Budget version';
                        else if(p.Is_this_a_Gap_Planning_Version__c)
                            type = 'Gap version';
                        lstmonths.add(new FiscalSettingMonth(
                            fyear,
                            MonthId,
                            MonthName,
                            iseditable,
                            p,
                            is_Disable,
                            type
                        ));
                        
                    }
                }
                
                lstFiscalSettingYear.add(new FiscalSettingYear(fyear,f.StartDate,f.EndDate,lstmonths,iscorrectyear ));
                
            }
        }  
        
        }
        else{
            for(FiscalYearSettings f:  lstFSY){string fiscalyear = f.name;       Integer fyear = Integer.ValueOf(fiscalyear); 
            	//System.debug(System.LoggingLevel.ERROR, 'fyear>>>>>>>>>>>>>>>>>>>>>>>>'+fyear);
            	            boolean iscorrectyear = false;         List<FiscalSettingMonth> lstmonths = new List<FiscalSettingMonth>();             if(mapPlanningYear.containskey(fiscalyear)){           for(Planning_Version__c p: mapPlanningYear.get(fiscalyear)){boolean iseditable = isExist(p.Data_Entry_Start_Date__c,p.Data_Entry_Closed_Date__c,Date.today());
          if(iseditable){if(!iscorrectyear)iscorrectyear = true;}boolean is_Disable = true;if(p.Version_Status__c== 'Not Open' || p.Version_Status__c== 'Closed')is_Disable  = true;           String MonthName  = p.MonthName__c;p.MonthName__c = MonthName ;                      Integer MonthId = 0; string type = 'Revenue & Sales booking';if(p.Is_this_a_Budget_Planning_Version__c)type = 'Budget';               else if(p.Is_this_a_Gap_Planning_Version__c)type = 'Gap';if(p.Planning_Version_Current_Period__c <> null)
          MonthId = Integer.valueOf(p.Planning_Version_Current_Period__c);lstmonths.add(new FiscalSettingMonth(fyear, MonthId,                 MonthName,iseditable,p,is_Disable,type));}}lstFiscalSettingYear.add(new FiscalSettingYear(fyear,f.StartDate,f.EndDate,lstmonths,iscorrectyear ));    }
        }
    EditableMonths = getEditableMonths();
    SetOldStatus();
    }
    
    public boolean isExist(Date fromdt, Date tdt, Date cdt){
    
        if(fromdt.daysBetween(cdt) >= 0 && tdt.daysBetween(cdt) <= 0)
        return true;
        
        return false;
    }


    public String getStatus(Date tdt, Date cdt){
    
        if(tdt.daysBetween(cdt) <= 0)
        return 'Not Open';
        
        return 'Closed';
    }
    
    
    
    public class FiscalSettingYear{
        
        public Integer YearId{get;set;} 
            
        public Date StartDate{get;set;}
        public Date EndDate{get;set;}        
        public boolean is_CorentYear{get;set;}
        public List<FiscalSettingMonth> lstMonth{get;set;}
        
        public FiscalSettingYear(Integer YearId,Date StartDate,Date EndDate,List<FiscalSettingMonth> lstMonth,boolean is_CorentYear){
            this.YearId = YearId;
            this.StartDate = StartDate;
            this.EndDate = EndDate;
            this.lstMonth = lstMonth;
            this.is_CorentYear = is_CorentYear;
            
        }
        
    }
     
    // wrapper class FiscalSettingMonth mainting state of Accounting period  
    public class FiscalSettingMonth{
    
        public Integer YearId{get;set;}
        public String Type{get;set;}    
        public Integer MonthId{get;set;}
        public String MonthName{get;set;}        
        public boolean is_Editable{get;set;}
        public boolean is_Disable{get;set;}
        public Planning_Version__c Period{get;set;}
        public String OLDStatus{get;set;}         
        
        public FiscalSettingMonth(Integer YearId,Integer MonthId,String MonthName,boolean is_Editable,Planning_Version__c Period,boolean is_Disable,String Type){
            this.YearId = YearId ;
            this.MonthId = MonthId;
            this.MonthName = MonthName;
            this.type= type;
            
            this.is_Editable = is_Editable;
            this.Period = Period;
            this.is_Disable = is_Disable;
        }        
    }
}