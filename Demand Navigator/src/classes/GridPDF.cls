public with sharing class GridPDF{
        public string jsonOutput{get;
                set {
                jsonOutput =(jsonOutput <>null)?String.escapeSingleQuotes(jsonOutput):'';
            }
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
        public GridPDF(){
                string PlanningVersionId = ApexPages.currentPage().getParameters().get('PlanningVersionId') ;
                map<string,boolean> SlstMeasure = new map<string,boolean> ();
                String mm = apexpages.currentPage().getparameters().get('Measure');
                if(mm <> null){
                        for(string mId : mm.split(',')){
                                if(mid <> null && mId <> ''){
                                        SlstMeasure.put(String.valueOf(mId).escapehtml4(),true);
                                }
                        }
                }
                jsonOutput = getPDFContent(PlanningVersionId ,SlstMeasure);
        }
        public Integer getYearId(string year,string month){
                string cPeriod = (month.length() == 1)? '0'+month:month;
                return Integer.ValueOf(year+''+cPeriod);
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
                        lstPickvals.add(a.getValue().escapehtml4());//add the value  to our final list
                }

                return lstPickvals;
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
        public string getPDFContent(string PlanningVersionId,map<string,boolean> SlstMeasure)
        {
                string outputstr = '';
                JSONGenerator gen = JSON.createGenerator(true); 
                Date Bcklog_fslyear_startdate;
                Date Bcklog_fslyear_Enddate;
                Date crtprd_startdate;
                Date crtprd_enddate;

                string pversionId = PlanningVersionId;

                //List<Json_PlanningVersion> lstJson_PlanningVersion = new List<Json_PlanningVersion>();
                List<Json_Measure> lstJson_Measure = new List<Json_Measure>();
                List<Json_FY> lstJson_FY = new List<Json_FY>();


                /*map<Id,Planning_Version__c> mapPlanningVersion = new map<Id,Planning_Version__c>([select id,Fiscal_Year_Planning__c,Fiscal_Year_Planning__r.StartDate__c,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Is_this_a_Budget_Planning_Version__c,
                Fiscal_Year_Planning__r.EndDate__c,Planning_Version_Fiscal_Year__c,SequenceNo__c 
                from Planning_Version__c where name <> null]);*/
                
                if (Schema.sObjectType.Planning_Financial_Measure__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isAccessible()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.General_Ledger_Account__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()
                && Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isAccessible() ){
                    
                
                List<Planning_Financial_Measure__c> lstMeasure = [select id,NAme, Automatically_Calculated__c, General_Ledger_Account__c, Measure_Description__c, Measure_Type__c, Record_Source__c,Restricted_by_Revenue_Term__c,Unit_of_Measure__c from Planning_Financial_Measure__c where ID IN: sLstMeasure.keySet()];

                List<FiscalYearSettings> lstOrgFiscalYear = new List<FiscalYearSettings>();
                if (Schema.sObjectType.FiscalYearSettings.fields.Name.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodLabelScheme.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.PeriodPrefix.isAccessible()
                &&  Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible() && Schema.sObjectType.FiscalYearSettings.fields.StartDate.isAccessible() 
                &&  Schema.sObjectType.Period.fields.Id.isAccessible() && Schema.sObjectType.Period.fields.EndDate.isAccessible() && Schema.sObjectType.Period.fields.IsForecastPeriod.isAccessible()
                &&  Schema.sObjectType.Period.fields.Number.isAccessible() && Schema.sObjectType.Period.fields.PeriodLabel.isAccessible() && Schema.sObjectType.Period.fields.QuarterLabel.isAccessible() 
                && Schema.sObjectType.Period.fields.StartDate.isAccessible() && Schema.sObjectType.Period.fields.Type.isAccessible()){
                lstOrgFiscalYear =  [select Name,PeriodLabelScheme,PeriodPrefix,EndDate,StartDate,(select Id,EndDate,IsForecastPeriod,Number,PeriodLabel,QuarterLabel,StartDate,Type from Periods where type = 'month' order by startdate) from FiscalYearSettings where name <> null order by startdate];
                
               
                map<String,Integer> mapIsEditable = new map<String,Integer>();
                set<Id> setOppMeasures = new set<Id>();

                boolean isRevenueActual = false;
                for(Planning_Financial_Measure__c p: lstMeasure){
                if(p.Name == 'Revenue' || p.Name == 'Revenue Adjustment')isRevenueActual = true;
                Json_Measure pv = new Json_Measure();
                pv.Id = p.Id;
                setOppMeasures.add(String.valueOf(p.Id).escapehtml4());
                pv.Label = p.Name;
                pv.Name = (p.Name).ReplaceAll(' ','');
                pv.Calculated = (p.Automatically_Calculated__c)?'Y':'N';
                pv.Restricted_by_Revenue_Term =p.Restricted_by_Revenue_Term__c;
                pv.Measure_Type = (p.Measure_Type__c<>null)?p.Measure_Type__c:'';
                pv.Unit_of_Measure = (p.Unit_of_Measure__c<>null)?p.Unit_of_Measure__c:'';
                lstJson_Measure.add(pv);
                Integer V_Editable = (!p.Automatically_Calculated__c)?1:0;
                string pname = p.Name;
                pname=pname.replaceAll(' ','');
                mapIsEditable.put(pname,V_Editable);
                }

                if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()
                &&  Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
                &&  Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible()
                &&  Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()){
                    
                
                Planning_Version__c pversion =  [select id,Fiscal_Year_Planning__c,Fiscal_Year_Planning__r.StartDate__c,Name,Version_Status__c,Planning_Version_Current_Period__c,Data_Entry_Start_Date__c,Data_Entry_Closed_Date__c,Is_this_a_Budget_Planning_Version__c,
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
                if(lstOrgFiscalYear <> null && lstOrgFiscalYear.size() > 0){
                for(FiscalYearSettings p: lstOrgFiscalYear){
                Json_FY pv = new Json_FY();
                pv.Year = Integer.valueOf(p.Name);
                String  Prefix = p.PeriodPrefix;
                String MonthName;
                List<Json_FY_Period> lstp = new List<Json_FY_Period>();
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
                if(!pversion.Is_this_a_Budget_Planning_Version__c)
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
                }
                else {
                        if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
                Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
                        
                string cyear = ''+(system.today()).year();
                date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear); 
                        }
                if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()
                &&  Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()){
                    
                List<Fiscal_Year_Planning__c> lstFYSR = [select Id,Name,StartDate__c,EndDate__c from Fiscal_Year_Planning__c where name <> null order by StartDate__c];
                
                set<string> setFYNames = new set<string>();
                map<string,List<Fiscal_Year_Model__c>> mapExistingFY = new map<string,List<Fiscal_Year_Model__c>>();
                for(Fiscal_Year_Planning__c Efy : lstFYSR ){
                setFYNames.add(Efy.Name.escapehtml4());
                mapExistingFY.put(Efy.Name.escapehtml4(),new List<Fiscal_Year_Model__c>());
                }
                if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isAccessible()
                &&  Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
                &&  Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()){
                     
                
                for(Fiscal_Year_Model__c pp : [select Id,Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c,Record_Source__c from Fiscal_Year_Model__c where Fiscal_Year__c IN: setFYNames]){
                List<Fiscal_Year_Model__c> temp = mapExistingFY.get(pp.Fiscal_Year__c);
                temp.add(pp);
                mapExistingFY.put(pp.Fiscal_Year__c.escapehtml4(),temp);
                }
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

                S_FiscalYearSettings sfiscal = new S_FiscalYearSettings();     sfiscal.Name = Efy.Name;              sfiscal.startDate = Efy.StartDate__c;         sfiscal.endDate =  Efy.EndDate__c;
                sfiscal.PeriodPrefix =  'P';          sfiscal.PeriodLabelScheme = 'StandardMonths';             sfiscal.Periods = lstP;            lstfiscalsetting.add(sfiscal);

                }
                
                for(S_FiscalYearSettings p: lstfiscalsetting){         Json_FY pv = new Json_FY();
                pv.Year = Integer.valueOf(p.Name);          String  Prefix = p.PeriodPrefix;
                String MonthName;        List<JSON_FY_Period> lstp = new List<JSON_FY_Period>();


                for(JSON_FY_Period m : getFiscalPeriods(false,p,null,pversion)){          if(!pversion.Is_this_a_Budget_Planning_Version__c)
                m.Category = getCategory(PYear,pv.Year,m.Period);          if(m.Category == 'Actual(c)'){
                string M_m = ((m.Period+'').length() == 1)?'0'+m.Period:m.Period+'';        c_Actual = Integer.valueOf(pv.Year+''+m_m);
                }
                //m.Label = MonthName;
                lstp.add(m);
                }
                pv.Periods = lstp;       lstJson_FY.add(pv);
                }
                }

                }
       
                if(pversion <> null && pversion.Fiscal_Year_Planning__c <> null && pversion.Fiscal_Year_Planning__r.StartDate__c <> null && pversion.Data_Entry_Start_Date__c <> null ){

                if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
                List<Configuration_Setting__c> lstconfStages = [select Id,Stage__c from Configuration_Setting__c limit 1];
                
                set<string> setSelConStages = new set<string>();
                if(lstconfStages <> null && lstconfStages.size() > 0){                            

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
                }
                String strmodel = '(Select   ID,Opportunity__c,Planning_Measure__c,Planning_Measure__r.Name,Amount__c,Comments__c,Fiscal_Period__c,';
                strmodel += 'Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Name,Fiscal_Period__r.Period_Number__c,Fiscal_Period__r.Start_Date__c,';
                strmodel += 'Fiscal_Period__r.End_Date__c,Fiscal_Period__r.Period_Name__c from Planning_Models__r ';
                strmodel += 'where  Planning_Measure__c <> null and Planning_Measure__c IN: setOppMeasures and Planning_Version__c =: pversionId)';

                /* closed
                1. Revenue End Date > version.FY.startDate 
                2. Stages IN Configuration Settings.
                3. isWon and isclose = true
                4. close date <= version.startDate*/
                String strQuery1 = 'Select Id,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                strQuery1 +=  String.escapeSingleQuotes(strmodel);                   
                strQuery1 +=' from Opportunity where Project_End_date__c >: Bcklog_fslyear_startdate and stageName IN: setSelConStages and iswon = true and isClosed = true and closeDate <=: crtprd_enddate and stageName <> \'closed Lost\'';

                /*Selected Open
                1. close Date >= version.StartDate
                2. Stages IN Configuration Settings.
                3. isWon and isclose = false
                4. close Date <= version.fy.endDate*/
                String strQuery2 = 'Select Id,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                strQuery2 += String.escapeSingleQuotes(strmodel) ;                   
                strQuery2 +=' from Opportunity where closeDate >=: crtprd_startdate and stageName IN: setSelConStages and iswon = false and isClosed = false and closeDate <=: Bcklog_fslyear_Enddate and stageName <> \'closed Lost\'';

                /*Not Selected Open
                1. close Date >= version.StartDate
                2. Stages Not IN Configuration Settings.
                3. isWon and isclose = false
                4. close Date <= version.fy.endDate*/
                String strQuery3 = 'Select Id,Probability,StageName,isWon,isclosed,Actuals_to_date__c,Description,Deal_Duration__c,CloseDate,Project_Start_Date__c,         Deal_TCV__c,Name,Account.Name,AccountId,Project_End_date__c,';
                strQuery3 += String.escapeSingleQuotes(strmodel);                   
                strQuery3 +=' from Opportunity where closeDate >=: crtprd_startdate and stageName Not IN: setSelConStages and iswon = false and isClosed = false and closeDate <=: Bcklog_fslyear_Enddate and stageName <> \'closed Lost\'';

                if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.isWon.isAccessible() && Schema.sObjectType.Opportunity.fields.isclosed.isAccessible() && Schema.sObjectType.Opportunity.fields.Actuals_to_date__c.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Description.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                &&  Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible() && Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()){
                List<Opportunity> lstOpportunity1  = Database.query(strQuery1);
                
                  if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.isWon.isAccessible() && Schema.sObjectType.Opportunity.fields.isclosed.isAccessible() && Schema.sObjectType.Opportunity.fields.Actuals_to_date__c.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Description.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                &&  Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible() && Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()){
                    
                List<Opportunity> lstOpportunity2  = Database.query(strQuery2);
                
                if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.isWon.isAccessible() && Schema.sObjectType.Opportunity.fields.isclosed.isAccessible() && Schema.sObjectType.Opportunity.fields.Actuals_to_date__c.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Description.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
                &&  Schema.sObjectType.Opportunity.fields.Project_Start_Date__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible() &&  Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                &&  Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible() && Schema.sObjectType.Opportunity.fields.Project_End_date__c.isAccessible()){
                List<Opportunity> lstOpportunity3  = Database.query(strQuery3);
                
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
                for(opportunity opp : lstOpportunity){ 
                for(Json_FY pv : lstJson_FY){  
                mapYears.put(String.valueOf(opp.Id).escapehtml4()+'-'+pv.Year,new List<Json_Period>());
                for(JSON_FY_Period ap: pv.Periods){
                mapPeriodMeasure.put(String.valueOf(opp.Id).escapehtml4()+'-'+pv.Year+'-'+ap.Period,mapORGMeasure);
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
                mapJson_Opportunity.put(String.valueOf(opp.AccountId).escapehtml4(),new List<Json_Opportunity>());
                map_O_M.put(String.valueOf(opp.Id).escapehtml4(),opp);
                for(Planning_Model__c m: opp.Planning_Models__r){
                if(m.Fiscal_Period__r.Fiscal_Year__c <> null && m.Planning_Measure__c <> null ){
                mapYears.put(String.valueOf(opp.Id).escapehtml4()+'-'+m.Fiscal_Period__r.Fiscal_Year__c.escapehtml4(),new List<Json_Period>());
                if(mapPeriodMeasure.ContainsKey(opp.Id+'-'+m.Fiscal_Period__r.Fiscal_Year__c+'-'+m.Fiscal_Period__r.Period_Number__c)){
                string meName = m.Planning_Measure__r.Name;
                meName = meName.replaceAll(' ','');
                mmmm.put(String.valueOf(opp.Id).escapehtml4()+'-'+m.Fiscal_Period__r.Fiscal_Year__c+'-'+m.Fiscal_Period__r.Period_Number__c+'-'+meName,m);
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

                if(mmmm.ContainsKey(pid+'-'+mn)){          Planning_Model__c m = mmmm.get(pid+'-'+mn);     mes.Id=m.Id;      mes.isEditable = mapIsEditable.get(mn);   mes.Name=mn;     mes.Comment=(m.comments__c <> NULL)?m.comments__c:'';     mes.Amount=Integer.valueOf(m.amount__c);
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
                if( mapIsEditable.get(mn) == 0){                 if(SId >= c_Actual && SId < 999999)       mes.isEditable = 1;         else     mes.isEditable = 0;

                }
                //restricted
                else if( mapIsEditable.get(mn) == 1){
                if(SId >= c_Actual && SId < REDId)
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

                

                set<Id> setBudgetOpportunity = new set<Id>();
                for(opportunity opp : lstOpportunity){                        
                        for(Planning_Model__c m: opp.Planning_Models__r){
                                if(m.Opportunity__c <> null){
                                        setBudgetOpportunity.add(String.valueOf(m.Opportunity__c).escapehtml4());
                                }
                        }
                }
                for(opportunity opp : lstOpportunity){

                        string oppMStage;

                        /* closed
                        1. Revenue End Date > version.FY.startDate 
                        2. Stages IN Configuration Settings.
                        3. isWon and isclose = true
                        4. close date <= version.startDate*/
                        if(
                        opp.Project_End_date__c > Bcklog_fslyear_startdate &&              setSelConStages.contains(opp.stageName) &&            opp.iswon == true &&                opp.isClosed == true &&        opp.closeDate <= crtprd_startdate){      oppMStage = 'Closed';
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
                        opp.closeDate >= crtprd_startdate &&              !setSelConStages.contains(opp.stageName)  && 
                        opp.iswon == false &&             opp.isClosed == false && 
                        opp.closeDate <= Bcklog_fslyear_Enddate){        oppMStage = 'Open Not Selected';
                        }


                        if((oppMStage <> null && !pversion.Is_this_a_Budget_Planning_Version__c) || // Non budget version
                        (oppMStage <> null &&  pversion.Is_this_a_Budget_Planning_Version__c && setBudgetOpportunity.contains(opp.Id)) //budget version
                        )                                   
                        {

                                List<Json_Opportunity> temp = mapJson_Opportunity.get(opp.AccountId);
                                Json_Opportunity aOpp = new Json_Opportunity();
                                aOpp.OpportunityName = opp.Name;
                                aOpp.OpportunityId = opp.Id;
                                aOpp.Probability = opp.Probability+'';
                                aOpp.OpportunityStage = oppMStage;
                                if(opp.stageName == 'Closed Won'){aOpp.color  = 'green';}
                                else if(!setSelConStages.contains(opp.stageName)){aOpp.color  = 'orange';}
                                else if(setSelConStages.contains(opp.stageName)){aOpp.color  = 'blue';}

                                aOpp.RevenueStartDate = ( opp.Project_Start_Date__c <> null)? (opp.Project_Start_Date__c).month()+'/'+(opp.Project_Start_Date__c).day()+'/'+(opp.Project_Start_Date__c).year():'';
                                
                                aOpp.ClosedDate = (opp.CloseDate).year()+'-'+(opp.CloseDate).month()+'-'+(opp.CloseDate).day()+'';
                                
                                aOpp.ContractTerm = ( opp.Deal_Duration__c <> null)?Integer.valueOf(opp.Deal_Duration__c):0;
                                aOpp.LegacyActuals = ( opp.Actuals_to_date__c <> null)?opp.Actuals_to_date__c:0;
                                aOpp.ContractValue = ( opp.Deal_TCV__c <> null)?opp.Deal_TCV__c:0;
                                aOpp.Description = ( opp.Description <> null)?opp.Description:'';
                                if(mapOppYear.containsKey(opp.Id))aOpp.FYI = mapOppYear.get(opp.Id);
                                temp.add(aOpp);
                                mapJson_Opportunity.put(String.valueOf(opp.AccountId).escapehtml4(),temp);
                                map_v_Account.put(String.valueOf(opp.AccountId).escapehtml4(),opp.Account.Name.escapehtml4());
                        }
                }

                List<Json_Account> lstAccounts = new List<Json_Account>();
                for(string AccId : map_v_Account.keyset()){
                lstAccounts.add(new Json_Account(map_v_Account.get(AccId),AccId,mapJson_Opportunity.get(AccId)));
                }
                lstJson_Measure.sort();


                //if values is not present for any cell
                map<string,string> mapOYPM_Amount = new map<string,string>();

                for(Json_Account a : lstAccounts){ 
                for(Json_Opportunity o : a.Opportunity){ 
                for(Json_Measure m : lstJson_Measure){
                for(Json_FY y : lstJson_FY){
                for(Json_FY_Period p: y.Periods){
                mapOYPM_Amount.put(o.opportunityId.escapehtml4()+'-'+m.Name.escapehtml4()+'-'+y.year+'-'+p.Period,'');                                             
                }
                }
                }
                }
                }

                for(Json_Account a : lstAccounts){ 
                for(Json_Opportunity o : a.Opportunity){
                if(o.FYI == null) continue;
                o.FYI.sort();
                for(Json_Measure m : lstJson_Measure){

                for(Json_Year y : o.FYI){
                y.period.sort(); 
                for(Json_Period p : y.period){  
                p.lstPMeasure.sort();
                for(Json_Period_Measure h : p.lstPMeasure)
                {
                if(m.Name == h.Name){
                mapOYPM_Amount.put(o.opportunityId+'-'+m.Name+'-'+y.year+'-'+p.month,h.amount+'');
                }
                }                       
                }
                }
                }
                }
                }
                outputstr += '<table style="font-family: verdana,arial,sans-serif; font-size:11px;color:#333333;border-width: 1px;border-color: #666666; border-collapse: collapse;" >';
                outputstr+='<tr style="font-size: 12px !important;color:white;background-color:#185B95">';
                outputstr+='<td style="border-width: 1px; padding: 8px; border-style: solid;border-color: #666666;text-align:center;color:white;font-weight:bold;">Planning Version : '+pversion.Name +'</td>';
                outputstr += '</tr>';
                outputstr += '</table>';
                outputstr += '<br/><br/>';

                outputstr += '<table style="font-family: verdana,arial,sans-serif; font-size:11px;color:#333333;border-width: 1px;border-color: #666666; border-collapse: collapse;" >';
                outputstr+='<tr style="font-size: 12px !important;color:white;background-color:#185B95">';
                outputstr+='<td colspan="4" ></td>';

                for(Json_FY pv : lstJson_FY){  
                outputstr+='<td colspan="'+pv.Periods.size()+'" style="border-width: 1px; padding: 8px; border-style: solid;border-color: #666666;text-align:center;color:white;font-weight:bold;">'+pv.Year+'</td>';
                }
                outputstr+='</tr>';
                outputstr+='<tr style="background-color:#7BA640;">';
                outputstr+='<td colspan="3" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:white;font-weight:bold;">Account / Opportunity / Measure</td>';
                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:white;font-weight:bold;">Actuals to date</td>';

                Integer colspan = 0;
                for(Json_FY pv : lstJson_FY){
                for(Json_FY_Period ap: pv.Periods){
                outputstr+='<td style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:white;font-weight:bold;">'+ap.Label+'</td>'; 
                colspan++;                                  
                }
                }
                outputstr+='</tr>'; 
                outputstr+='<tr style="background-color:#EEF1F6">';
                outputstr+='<td colspan="3" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:white;font-weight:bold;"></td>';
                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:white;font-weight:bold;"></td>';
                for(Json_FY pv : lstJson_FY){
                for(Json_FY_Period ap: pv.Periods){
                outputstr+='<td style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:bold;">'+ap.Category+'</td>';                                              
                }
                }
                outputstr+='</tr>'; 



                for(Json_Account a : lstAccounts){ 
                        outputstr+='<tr style="background-color:#EEEEEE">';
                        outputstr+='<td colspan="'+(colspan+4)+'" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:left;padding: 5px;color:black;font-weight:bold;">'+a.AccountName+'</td>';
                        outputstr+='<tr>';
                        for(Json_Opportunity o : a.Opportunity){ 
                                outputstr+='<tr>';
                                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">&nbsp;</td>';
                                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">'+o.OpportunityName+'</td>';
                                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;"></td>';
                                if(!isRevenueActual)
                                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">'+o.LegacyActuals+'</td>';
                                else
                                outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">&nbsp;</td>';
                                outputstr+='<td colspan="'+colspan+'" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">&nbsp;</td>';
                                outputstr+='</tr>';
                                boolean isPrint = true;
                                for(Json_Measure pv : lstJson_Measure){
                                        outputstr+='<tr>';
                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">&nbsp;</td>';
                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">&nbsp;</td>';                                 
                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">'+pv.label+'</td>';
                                        if(isRevenueActual && (pv.label == 'Revenue Adjustment' || pv.label == 'Revenue') && isPrint){
                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">'+o.LegacyActuals+'</td>';
                                        isPrint = false;
                                        }
                                        else
                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;"></td>';



                                        /*Measure Amount*/

                                        for(Json_FY y : lstJson_FY){
                                                for(Json_FY_Period p: y.Periods){
                                                        //outputstr+='<td colspan="1"><font size="0.1">'+mapOYPM_Amount.get(o.opportunityId+'-'+pv.Name+'-'+y.year+'-'+p.Period)+'('+y.Year+'-'+p.Period+')</font></td>';
                                                        outputstr+='<td colspan="1" style="border-width: 1px;padding: 8px; border-style: solid; border-color: #666666;text-align:center;padding: 5px;color:black;font-weight:normal;">'+mapOYPM_Amount.get(o.opportunityId+'-'+pv.Name+'-'+y.year+'-'+p.Period)+'</td>';                                            
                                                }
                                        }
                                        outputstr+='</tr>';
                                }
                        }
                }
                outputstr += '</table>';
                }
                }
                }
                }
                }
                }
               } 
        }
                return outputstr;
        }
}