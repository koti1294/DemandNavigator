trigger DemandConfigurationTrigger on Demand_Configuration_Ratio__c (after insert, after update) {

            
    List<Opportunity> lstOpportunity = new List<Opportunity>();
    map<string,Integer> mapDemandKeyCount = new map<string,Integer>();
    map<string,list<Demand_Configuration_Ratio__c>> mapDemandKeyLinks = new map<string,list<Demand_Configuration_Ratio__c>>();
    map<string,Demand_Configuration_Ratio__c> mapDemandKey = new map<string,Demand_Configuration_Ratio__c>();
    for(Demand_Configuration_Ratio__c dcr : trigger.new){
        if(dcr.Business_Unit__c <> null && dcr.Division__c <> null && dcr.Service_Line__c <> null){
            if(trigger.isInsert || (trigger.isUpdate && 
            (trigger.oldmap.get(dcr.Id).Business_Unit__c <> dcr.Business_Unit__c ||  
             trigger.oldmap.get(dcr.Id).Division__c <> dcr.Division__c || 
             trigger.oldmap.get(dcr.Id).Service_Line__c <> dcr.Service_Line__c || 
             trigger.oldmap.get(dcr.Id).Offshore_Resource__c <> dcr.Offshore_Resource__c || 
             trigger.oldmap.get(dcr.Id).Onsite_Resource__c <> dcr.Onsite_Resource__c || 
             trigger.oldmap.get(dcr.Id).Rate_per_Head_offshore__c <> dcr.Rate_per_Head_offshore__c || 
             trigger.oldmap.get(dcr.Id).Rate_per_Head_onsite__c <> dcr.Rate_per_Head_onsite__c || 
             trigger.oldmap.get(dcr.Id).Onsite_Deal_Month__c <> dcr.Onsite_Deal_Month__c || 
             trigger.oldmap.get(dcr.Id).Offshore_Deal_Month__c <> dcr.Offshore_Deal_Month__c
            ))){
                mapDemandKey.put(dcr.Demand_Key__c,dcr);
            }
        }
    }
    if (Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Demand_Key__c.isAccessible()
    && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Name.isAccessible()){
	    for(Demand_Configuration_Ratio__c dcr : [select Id,Demand_Key__c,Name from Demand_Configuration_Ratio__c where Demand_Key__c in: mapDemandKey.keyset() and Id NOT IN: trigger.New]){
	        
	        list<Demand_Configuration_Ratio__c> lstDemand = new list<Demand_Configuration_Ratio__c>();        
	        lstDemand.add(dcr);
	        if(mapDemandKeyLinks.ContainsKey(dcr.Demand_Key__c)){
	            lstDemand.addAll(mapDemandKeyLinks.get(dcr.Demand_Key__c));
	        }
	        mapDemandKeyLinks.put(dcr.Demand_Key__c,lstDemand);
	    }
    }
    for(Demand_Configuration_Ratio__c dcr : trigger.new){
         if(mapDemandKeyLinks.containsKey(dcr.Demand_Key__c)){
            string ErrorMsg = 'Duplicate Records Found<br/>';
            for(Demand_Configuration_Ratio__c cr : mapDemandKeyLinks.get(dcr.Demand_Key__c)){
                ErrorMsg += '<a href="/'+cr.Id+'" target="_blank">'+cr.Name+'</a></br>';
            }
            dcr.addError(ErrorMsg,false);
        }
        
    }
    
    map<Id,Opportunity> mapOpportunity = new map<Id,Opportunity>([select Id,Demand_Key__c,Offshore_Resource__c,Onsite_Resource__c, 
    Rate_per_Head_offshore__c,Rate_per_Head_onsite__c,Onsite_Deal_Month__c,Offshore_Deal_Month__c from opportunity where Demand_Key__c in: mapDemandKey.keyset() ]);
    
    for(Opportunity opp: mapOpportunity.values()){
        if(mapDemandKey.containsKey(opp.Demand_Key__c )){
            Demand_Configuration_Ratio__c conf = mapDemandKey.get(opp.Demand_Key__c );
            opp.Onsite_Resource__c = conf.Onsite_Resource__c;
            opp.Rate_per_Head_onsite__c = conf.Rate_per_Head_onsite__c ;
            opp.offshore_Resource__c = conf.offshore_Resource__c;
            opp.Rate_per_Head_offshore__c= conf.Rate_per_Head_offshore__c;
            opp.Onsite_Deal_Month__c= conf.Onsite_Deal_Month__c;
            opp.Offshore_Deal_Month__c= conf.Offshore_Deal_Month__c;
            lstOpportunity.add(opp);
        }
    }
    
    if(lstOpportunity.size() > 0){
    	if(Opportunity.SObjectType.getDescribe().isUpdateable()){
       	 update lstOpportunity;
    	}
    }
    
    
    //Create Planning measures on demand.
    
        
    set<string> setExistingMeasure = new set<string>();
    if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
        for(Planning_Financial_Measure__c mr : [select id,Name from Planning_Financial_Measure__c limit 1000]){
            setExistingMeasure.add(mr.Name);
        }
    }
    
    List<Planning_Financial_Measure__c> lstMeasure = new List<Planning_Financial_Measure__c>();
    for(Demand_Configuration_Ratio__c dcr : trigger.new){
        if(dcr.OnSiteAmount__c <> null){
            for(string s : (dcr.OnSiteAmount__c).split(';')){
                string t = s.trim();
                if(t.contains(':')){
                    string mname = t.split(':')[0];
                    mname = 'Onsite-'+mname;
                    if(!setExistingMeasure.contains(mname)){
                        Planning_Financial_Measure__c mobj = new Planning_Financial_Measure__c();
                        mobj.Name = mname;
                        mobj.Measure_Type__c = 'KPI';
                        mobj.Unit_of_Measure__c = 'Currency' ;                          
                        lstMeasure.add(mobj);
                    }
                }
                
            }
        }
        if(dcr.OffshoreAmount__c <> null){
            for(string s : (dcr.OffshoreAmount__c).split(';')){
                string t = s.trim();
                if(t.contains(':')){
                    string mname = t.split(':')[0];
                    mname = 'Offshore-'+mname;
                    if(!setExistingMeasure.contains(mname)){
                        Planning_Financial_Measure__c mobj = new Planning_Financial_Measure__c();
                        mobj.Name = mname;
                        mobj.Measure_Type__c = 'KPI';
                        mobj.Unit_of_Measure__c = 'Currency' ;                          
                        lstMeasure.add(mobj);
                    }
                }
                
            }
        }
    }
    if(lstMeasure.size()>0){
    	 if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable()){
        	insert lstMeasure;
    	 }
    }
    
}