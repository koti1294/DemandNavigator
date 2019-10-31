public with sharing class DemandForcecaseCSV{

    public DemandForcecaseCSV() {
        string OppId = apexPages.currentPage().getParameters().get('Id');
        
        map<Id,String> mapVersion = new map<Id,string>();
        if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() 
        && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()  ){
            for(Opportunity opp : [select Id,(select Id,Planning_Version__c,Planning_Version__r.Name from Planning_Models__r) from Opportunity where Id=: oppId]){
                for(Planning_Model__c m : opp.Planning_Models__r){
                   mapVersion.put(m.Planning_Version__c, m.Planning_Version__r.Name);
                }
            }
        }
        input = '';
        
        for(Id vId :mapVersion.keySet()){
            DemandUtility dobj = new DemandUtility(oppId,vId );
            List<FiscalYear> lstTFModel = dobj.lstFModel;
            input += dobj.getDemandData(lstTFModel,mapVersion.get(vid));
        }
        
    }

    
    public string input{get;set;}
    
}