public with sharing class DemandConfiguration{ 
    public static void updateDemandConfiguration(List<Opportunity> lstNewOpportunity){
      
        map<string,Demand_Configuration_Ratio__c> mapDemandKey = new map<string,Demand_Configuration_Ratio__c>();
        for(Opportunity opp: lstNewOpportunity){
            mapDemandKey.put(opp.Demand_Key__c,null);
        }    
         if (Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Demand_Key__c.isAccessible()
         && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Onsite_Resource__c.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Rate_per_Head_onsite__c.isAccessible()
         && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.offshore_Resource__c.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Rate_per_Head_offshore__c.isAccessible()
         && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Onsite_Deal_Month__c.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Offshore_Deal_Month__c.isAccessible()){
	        for(Demand_Configuration_Ratio__c dcr : [select Id,Demand_Key__c, Onsite_Resource__c,Rate_per_Head_onsite__c,
	        offshore_Resource__c,Rate_per_Head_offshore__c,Onsite_Deal_Month__c,Offshore_Deal_Month__c from Demand_Configuration_Ratio__c 
	        where Demand_Key__c in: mapDemandKey.keyset()]){
	            mapDemandKey.put(dcr.Demand_Key__c, dcr);
	        }
         }
        for(Opportunity opp: lstNewOpportunity){
            if(mapDemandKey.containsKey(opp.Demand_Key__c ) && mapDemandKey.get(opp.Demand_Key__c) <> null){
                Demand_Configuration_Ratio__c conf = mapDemandKey.get(opp.Demand_Key__c );
                opp.Onsite_Resource__c = conf.Onsite_Resource__c;
                opp.Rate_per_Head_onsite__c = conf.Rate_per_Head_onsite__c ;
                opp.offshore_Resource__c = conf.offshore_Resource__c;
                opp.Rate_per_Head_offshore__c= conf.Rate_per_Head_offshore__c;
                opp.Onsite_Deal_Month__c= conf.Onsite_Deal_Month__c;
                opp.Offshore_Deal_Month__c= conf.Offshore_Deal_Month__c;

            }
        }
    }
}