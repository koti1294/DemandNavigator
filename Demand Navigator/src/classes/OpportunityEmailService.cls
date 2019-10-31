public with sharing class OpportunityEmailService{
    public static void sendEmail(List<Opportunity> lstNewOpportunity){
        set<Id> setIds = new set<Id>();
        for(Opportunity opp: lstNewOpportunity){
            setIds.add(opp.Id);
        }
        sendAttachment(setIds);
    }
    //@Future(callout=true)
    public static void sendAttachment(set<Id> setIds){   
        set<Id> setVersions = new set<Id>();
        map<Id,string> mapVersionNames = new map<Id,string>();
        List<Opportunity> lstNewOpportunity;
        if (Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible()
        && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
        && Schema.sObjectType.Opportunity.fields.StageName.isAccessible() && Schema.sObjectType.Opportunity.fields.Demand_Key__c.isAccessible() 
        && Schema.sObjectType.Opportunity.fields.Onsite_Resource__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Rate_per_Head_onsite__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Rate_per_Head_onsite__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Onsite_Deal_Month__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.onsite_Ratio__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Offshore_Resource__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Rate_per_Head_offshore__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Offshore_Deal_Month__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Offshore_Ratio__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Total_Resource__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible()){
        	lstNewOpportunity = [select Id,Name,(select Id,Planning_Version__r.Name,Planning_Version__c from Planning_Models__r order by Planning_Version__r.Name),StageName,Demand_Key__c,Onsite_Resource__c,Rate_per_Head_onsite__c,Onsite_Deal_Month__c,onsite_Ratio__c,Offshore_Resource__c,Rate_per_Head_offshore__c,Offshore_Deal_Month__c,Offshore_Ratio__c,Total_Resource__c,Total_Deal__c from Opportunity where Id IN: setIds];
        }
        set<string> ConfigStages = new set<string>();
        if (Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
	        for(Configuration_Setting__c cs : [select Id,Stage__c from Configuration_Setting__c limit 1]){
	            if(cs.Stage__c <> null)
	            for(string s : cs.Stage__c.split(',')){
	                ConfigStages.add(s);
	            }           
	        }
        }
        map<string,Demand_Configuration_Ratio__c> mapDemandKey = new map<string,Demand_Configuration_Ratio__c>();
        map<Id,Set<Id>> mapOppVersions = new map<Id,set<Id>>();
        for(Opportunity opp: lstNewOpportunity){
            if(ConfigStages.contains(opp.StageName))
                mapDemandKey.put(opp.Demand_Key__c,null);
            
            setVersions.clear();
            for(Planning_Model__c m : opp.Planning_Models__r){
                setVersions.add(m.Planning_Version__c);
                mapVersionNames.put(m.Planning_Version__c,m.Planning_Version__r.Name);
            }
            mapOppVersions.put(opp.Id,setVersions);
            
        }    
        if (Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Demand_Key__c.isAccessible()
        && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Emails__c.isAccessible()){ 
	        for(Demand_Configuration_Ratio__c dcr : [select Id,Demand_Key__c, Emails__c from Demand_Configuration_Ratio__c 
	        where Demand_Key__c in: mapDemandKey.keyset()]){
	            mapDemandKey.put(dcr.Demand_Key__c, dcr);
	        }
        }      
        List<Messaging.SingleEmailMessage> lstMail = new List<Messaging.SingleEmailMessage>();
        
        for(Opportunity opp: lstNewOpportunity){
            if(mapDemandKey.containsKey(opp.Demand_Key__c ) && mapDemandKey.get(opp.Demand_Key__c ) <> null){
                
                if(mapOppVersions.containsKey(opp.Id)){
                    
                    string strEmailTB = '';
                    string strEmailCSV = '';
     
                    Demand_Configuration_Ratio__c conf = mapDemandKey.get(opp.Demand_Key__c );
                    string DCREmail = conf.Emails__c;
                    String EmailBody = 'Hi,<br/><br/>'+opp.Name+' is updated by Stage '+opp.StageName+' for following demand configuration information.<div>   <table><tr><td><table><tr><td>Onsite Resource Ratio</td><td>'+opp.Onsite_Resource__c+'</td></tr><tr><td>Onsite rate per head</td><td>'+opp.Rate_per_Head_onsite__c+'</td> </tr><tr><td>Onsite Hours / Month</td><td>'+opp.Onsite_Deal_Month__c+'</td></tr><tr><td>Onsite Revenue Ratio</td><td>'+opp.Onsite_Ratio__c+'</td></tr></table></td><td><table><tr><td>Offshore Resource Ratio</td>   <td>'+opp.Offshore_Resource__c+'</td></tr><tr><td>Offshore rate per head</td><td>'+opp.Rate_per_Head_offshore__c+'</td></tr><tr><td>Offshore Hours / Month</td><td>'+opp.Offshore_Deal_Month__c+'</td></tr><tr><td>Offshore Revenue Ratio</td><td>'+opp.Offshore_Ratio__c+'</td></tr></table></td></tr><tr><td>Total Resource : '+opp.Total_Resource__c+'</td><td>total Deal : '+opp.Total_Deal__c+'</td></tr></table></div><br/>';


                        
                    for(Id vId : mapOppVersions.get(opp.Id)){
                        DemandUtility dobj = new DemandUtility(opp.Id,vId);
                        List<FiscalYear> lstTFModel = dobj.lstFModel;
                        
                        strEmailTB += dobj.getDemandData(lstTFModel,mapVersionNames.get(vId))+'<br/><br/>';
                        strEmailCSV += dobj.getDemandCSV(lstTFModel,mapVersionNames.get(vId))+'\n\n';
                    }
                    
                    if(DCREmail <> null){
                        List<string> lstEmails = new List<String>();
                        for(string s: DCREmail.split(';'))
                            lstEmails.add(s);
                        //lstEmails.clear();
                       // lstEmails.add('skhabimoonmca@gmail.com');
                        if(lstEmails.size()>0){

                            // Create the email attachment
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName('DemandForcecaseReport.csv');
                            efa.setBody(Blob.valueOf (strEmailCSV));

                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(lstEmails);
                            mail.setSenderDisplayName('Salesforce Support');
                            mail.setSubject('Opportunity Stage Updated');
                            mail.setUseSignature(true);
                            mail.setHtmlBody(EmailBody+strEmailTB);
                            //mail.setHtmlBody(EmailBody);
                            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                            lstMail.add(mail);
                        }
                    }
                }
                
            }
            
        }
        
        if(lstMail.size()>0){
           //Messaging.sendEmail(lstMail);
           try{Messaging.sendEmail(lstMail);}catch(Exception e){}
        }
    }
    
   
}