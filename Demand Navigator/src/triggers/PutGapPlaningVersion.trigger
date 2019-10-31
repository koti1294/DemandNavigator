/*
    1. on Insert : Create New Planningversion record for each Fiscal year in PlanningVersion Object.
    2. on Update : Update Name,MonthName,description of PlanningVersion Record.
    3. on Delete : Delete all Planning Version which is related to deleted Additional Planning Version
*/

trigger PutGapPlaningVersion on Gap_Planning_Version__c (after insert,after update, before delete) {
    
    if(trigger.isInsert || trigger.isUpdate){
        List<Gap_Planning_Version__c> lstAdditionalPlanning;
        if (Schema.sObjectType.Gap_Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isAccessible()){
          lstAdditionalPlanning = [select Id,Name,Version_Description__c from Gap_Planning_Version__c where Id IN: trigger.New];
        }
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
       	List<Fiscal_Year_Planning__c> lstfiscalsetting;
       	if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()
       	&& Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()){
          lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where name <> null order by startdate__c ];
       	}
        if(trigger.isInsert){
            
            // get Max Sequence Number for Additional Planning Version
            Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();
            AggregateResult[] lstSeqNo;
            if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() &&
           	   Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() ){ 
               lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Gap_Planning_Version__c = true Group By Planning_Version_Fiscal_Year__c];
        	}
            for (AggregateResult ar : lstSeqNo)  {
                mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
            }
        
            map<string,Date> mapGapSDate;
            map<string,Date> mapGapEDate;
            
            for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){
                Integer seq = 199;
                mapGapSDate = new map<string,Date>();
                mapGapEDate = new map<string,Date>();
                Date sQDate = fiscal.StartDate__c;
                Date eQDate = sQDate.addMonths(3);
                eQDate = eQDate.addDays(-1);
                mapGapSDate.put('Q1 Gap',sQDate);
                mapGapEDate.put('Q1 Gap',eQDate);
                
                sQDate = sQDate.addMonths(3);
                eQDate = sQDate.addMonths(3);
                eQDate = eQDate.addDays(-1);
                mapGapSDate.put('Q2 Gap',sQDate);
                mapGapEDate.put('Q2 Gap',eQDate);
                
                sQDate = sQDate.addMonths(3);
                eQDate = sQDate.addMonths(3);
                eQDate = eQDate.addDays(-1);
                mapGapSDate.put('Q3 Gap',sQDate);
                mapGapEDate.put('Q3 Gap',eQDate);
                
                sQDate = sQDate.addMonths(3);
                eQDate = sQDate.addMonths(3);
                eQDate = eQDate.addDays(-1);
                mapGapSDate.put('Q4 Gap',sQDate);
                mapGapEDate.put('Q4 Gap',eQDate);
                
                if(mapYearMaxSeq.ContainsKey(fiscal.Name))
                    seq = mapYearMaxSeq.get(fiscal.Name);
                for(Gap_Planning_Version__c ap: lstAdditionalPlanning ){
                    Date sGPDate,eGPDate;
                    seq++;
                    if(mapGapEDate.ContainsKey(ap.Name)){
                        sGPDate = mapGapSDate.get(ap.Name);
                        eGPDate = mapGapEDate.get(ap.Name);
                        lstPlanningversion.add(
                            new Planning_Version__c(
                                Fiscal_Year_Planning__c = fiscal.Id,
                                Name = fiscal.Name+'-'+ap.Name,
                                Gap_Planning_Version__c = ap.Id,
                                Is_this_a_Gap_Planning_Version__c = true,
                                SequenceNo__c = seq,
                                Data_Entry_Closed_Date__c= eGPDate,
                                Data_Entry_Start_Date__c  = sGPDate,
                                Version_Status__c= 'Not Open',
                                Planning_Version_Fiscal_Year__c = fiscal.Name,
                                Planning_Version_Current_Period__c= string.valueOf(seq),
                                MonthName__c =ap.Name,
                                Planning_Version_Description__c = ap.Version_Description__c 
                            )        
                        );
                    }
                }
            }
        }
        else if(trigger.isUpdate){
            map<Id,Gap_Planning_Version__c> mapPlanningVersion = new map<Id,Gap_Planning_Version__c>();
            for(Gap_Planning_Version__c ap: lstAdditionalPlanning ){
                mapPlanningVersion.put(ap.Id,ap);
            }
            if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()
            && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Gap_Planning_Version__c.isAccessible()
             && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isAccessible() ){
	            for(Planning_Version__c pv : [select Id,Planning_Version_Fiscal_Year__c,MonthName__c,Gap_Planning_Version__c,Planning_Version_Description__c from Planning_Version__c where Gap_Planning_Version__c IN: mapPlanningVersion.keySet() and Is_this_a_Gap_Planning_Version__c = true]){
	                pv.Name = pv.Planning_Version_Fiscal_Year__c+'-'+mapPlanningVersion.get(pv.Gap_Planning_Version__c).Name;
	                pv.MonthName__c = mapPlanningVersion.get(pv.Gap_Planning_Version__c).Name;
	                pv.Planning_Version_Description__c = mapPlanningVersion.get(pv.Gap_Planning_Version__c).Version_Description__c;
	                
	                lstPlanningversion.add(pv);
	            }
            }
            
        }
        
        if(lstPlanningversion.size()>0){
        	if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
            upsert lstPlanningversion;
        	}
        }
    }
    
    
    else if(trigger.isdelete && trigger.isBefore){
    	List<Planning_Version__c> lstdeletePlanning;
    	if (Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Gap_Planning_Version__c.isAccessible()){
         	lstdeletePlanning = [select Id,Gap_Planning_Version__c from Planning_Version__c where Gap_Planning_Version__c IN: Trigger.OldMap.Keyset()];
    	}
    	if (Planning_Version__c.sObjectType.getDescribe().isDeletable()){
        	delete lstdeletePlanning;
    	}
    }
}