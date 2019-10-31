trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    
    
    if(trigger.isBefore){
         List<Opportunity> lstOpp = new List<Opportunity>();
         for(Opportunity Opp : trigger.new){
             if(trigger.isInsert || (trigger.isUpdate && 
                (trigger.oldmap.get(opp.Id).BussinessUnit__c <> opp.BussinessUnit__c ||  
                 trigger.oldmap.get(opp.Id).Division__c <> opp.Division__c || 
                 trigger.oldmap.get(opp.Id).Service_Line__c <> opp.Service_Line__c            
                ))){
                    lstOpp.add(opp);
                }
         }
         DemandConfiguration.updateDemandConfiguration(lstOpp);
         
         //Email
         List<Opportunity> lstEmailOpp = new List<Opportunity>();
         for(Opportunity Opp : trigger.new){
             if(trigger.isUpdate && 
                (trigger.oldmap.get(opp.Id).StageName <> opp.StageName)){
                    lstEmailOpp.add(opp);
                }
         }
         OpportunityEmailService.sendEmail(lstEmailOpp);
    }
    else{
        List<Opportunity> lstROpp = new List<Opportunity>();
        List<Opportunity> lstBOpp = new List<Opportunity>();
        List<Opportunity> lstGOpp = new List<Opportunity>();
        
        //revenue and sales booking
        map<string,Id> mapRecordType = new map<string,Id>();
        if (Schema.sObjectType.RecordType.fields.Id.isAccessible() && Schema.sObjectType.RecordType.fields.Name.isAccessible()){
	        for(RecordType r : [select Id,Name from RecordType where sObjectType = 'Opportunity']){
	            mapRecordType.put(r.Name,r.Id);
	        }
        }
        for(Opportunity Opp : trigger.new){
        	/*if(
                (Trigger.isInsert && mapRecordType.get('Regular') == Opp.RecordTypeId) || 
                (Trigger.isUpdate && mapRecordType.get('Regular') == Opp.RecordTypeId &&*/
              if(
                (Trigger.isInsert &&  mapRecordType.get('Budget') != Opp.RecordTypeId && mapRecordType.get('Gap') != Opp.RecordTypeId) || 
                (Trigger.isUpdate && mapRecordType.get('Budget') != Opp.RecordTypeId && mapRecordType.get('Gap') != Opp.RecordTypeId &&
                (
                	
                    Opp.CloseDate != Trigger.OldMap.get(opp.Id).closeDate || 
                    Opp.Actuals_to_Date__c != Trigger.OldMap.get(opp.Id).Actuals_to_Date__c||
                    Opp.Amount != Trigger.OldMap.get(opp.Id).Amount ||
                    Opp.StageName != Trigger.OldMap.get(opp.Id).StageName ||
                    Opp.Project_Start_Date__c != Trigger.OldMap.get(opp.Id).Project_Start_Date__c ||
                    Opp.Deal_Duration__c != Trigger.OldMap.get(opp.Id).Deal_Duration__c
                )
                )
            ){
            	//System.debug('>>>>>opp>>>>'+opp);
                lstROpp.add(opp);
                //System.debug('>>>>>lstROpp>>>>'+lstROpp);
            }
            
            if(
                (Trigger.isInsert && mapRecordType.get('Budget') == Opp.RecordTypeId) || 
                (
                    Trigger.isUpdate && mapRecordType.get('Budget') == Opp.RecordTypeId && 
                    (
                        Opp.CloseDate != Trigger.OldMap.get(opp.Id).closeDate || 
                        Opp.Amount != Trigger.OldMap.get(opp.Id).Amount ||
                        Opp.StageName!= Trigger.OldMap.get(opp.Id).StageName ||
                        Opp.Probability!= Trigger.OldMap.get(opp.Id).Probability||
                        Opp.Budget_Planning_Version__c!= Trigger.OldMap.get(opp.Id).Budget_Planning_Version__c || 
                        Opp.Deal_Duration__c!= Trigger.OldMap.get(opp.Id).Deal_Duration__c
                        
                    )
                )
            ){
                lstBOpp.add(opp);
            }
            
            if(
                (Trigger.isInsert && mapRecordType.get('Gap') == Opp.RecordTypeId) || 
                (Trigger.isUpdate && mapRecordType.get('Gap') == Opp.RecordTypeId && 
                (
                    Opp.CloseDate != Trigger.OldMap.get(opp.Id).closeDate || 
                    Opp.Amount != Trigger.OldMap.get(opp.Id).Amount ||
                    Opp.StageName!= Trigger.OldMap.get(opp.Id).StageName ||
                    Opp.Probability!= Trigger.OldMap.get(opp.Id).Probability||
                    Opp.Gap_Planning_Version__c!= Trigger.OldMap.get(opp.Id).Gap_Planning_Version__c || 
                    Opp.Deal_Duration__c!= Trigger.OldMap.get(opp.Id).Deal_Duration__c
                )
                )
            ){
                lstGOpp.add(opp);
            }
            
        }
       // System.debug('lstROpp>>>'+lstROpp.size()+'>>>>>lstROppv=='+lstROpp);
        if(lstROpp.size() > 0)InsertPlanningModel.AddPlanningModel(lstROpp );
        if(lstBOpp.size() > 0 )SalesBooking_Handler.AddPlanningModel(lstBOpp);
        if(lstGOpp.size() > 0 )GapPlanning_Handler.AddPlanningModel(lstGOpp);
    }
}