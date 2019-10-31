public  with sharing class DemandConfigurationController {

    Id DemandConfigId;
    string namespace;
    Demand_Configuration_Ratio__c DemandObj;
    map<string,decimal> mapDemandOnsite;
    map<string,decimal> mapDemandOffshore;
    public DemandConfigurationController(ApexPages.StandardController controller) {
        DemandConfigId = apexpages.currentpage().getParameters().get('id');
        namespace = 'Fcstdemand__';
        
        Initialize();
    }
    public void Initialize(){
        if(
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnSite__c.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffShore__c.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnSiteAmount__c.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffshoreAmount__c.isAccessible()
        ){
            DemandObj = [select id,Name,OnSite__c,OffShore__c,OnSiteAmount__c,OffshoreAmount__c from Demand_Configuration_Ratio__c where id =: DemandConfigId];
        }
        mapDemandOnsite = new map<string,decimal>();
        if(DemandObj.OnSiteAmount__c <> null){
            for(string s : (DemandObj.OnSiteAmount__c).split(';')){
                if(s <> null && s.contains(':')){
                    string d = s.split(':')[0];
                    string m = s.split(':')[1];
                    mapDemandOnsite.put(d,decimal.valueOf(m));
                }
            }
        }
        mapDemandOffshore = new map<string,decimal>();
        if(DemandObj.OffshoreAmount__c <> null){
            for(string s : (DemandObj.OffshoreAmount__c).split(';')){
                if(s <> null && s.contains(':')){
                    string d = s.split(':')[0];
                    string m = s.split(':')[1];
                    mapDemandOffshore.put(d,decimal.valueOf(m));
                }
            }
        }
    }
    
    public class WOption{
        public boolean isCheck{get;set;}
        public string rId{get;set;}
        public string Label{get;set;}
        public decimal Amount{get;set;}
        
        public WOption(boolean isCheck, string rId, string Label, decimal Amount){
            this.isCheck = isCheck;
            this.rId = rId;
            this.Label = Label;
            this.Amount= Amount;
        }
    }
     List<WOption> lstOnsiteOption;
    public List<WOption> lstOffshoreOption;
    
    public void reset(){
        Initialize();
        getOnSiteOption();
        getOffShoreOption();
    }
    public void saveDemandRatio(){
        string onsitevalue;
        string offshorevalue;
        string onsiteamount;
        string offshoreamount;
        if(lstOnsiteOption.size()>0){
            decimal total = -1;
            for(WOption w : lstOnsiteOption){
                if(w.isCheck && w.Amount <> null)
                {       
                    if(total == -1)total =0;
                    total += w.Amount;
                    if(onsitevalue == null){onsitevalue = w.Label;onsiteamount=w.Label+':'+w.Amount;}
                    else {onsitevalue += ';'+w.Label;onsiteamount += ';'+w.Label+':'+w.Amount;}
                }
            }
            if(total <> 100 && total <> -1){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,'onsite percentage should be equals to 100% for selected item, please give correct amounts.'));
                return;
            }
        }
        if(lstOffshoreOption.size()>0){
            decimal total = -1;
            for(WOption w : lstOffshoreOption){
                if(w.isCheck && w.Amount <> null)
                {
                    if(total == -1)total =0;
                    total += w.Amount;
                    if(offshorevalue == null){offshorevalue = w.Label;offshoreamount=w.Label+':'+w.Amount;}
                    else {offshorevalue += ';'+w.Label;offshoreamount += ';'+w.Label+':'+w.Amount;}
                }
            }
            if(total <> 100 && total <> -1){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,'offshore percentage should be equals to 100% for selected item, please give correct amounts.'));
                return;
            }
        }
        
        DemandObj.OnSite__c = onsitevalue;
        DemandObj.OffShore__c = offshorevalue;
        DemandObj.OnSiteAmount__c = onsiteamount;
        DemandObj.OffshoreAmount__c = offshoreamount;
        try{
            if(
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnSite__c.isUpdateable() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffShore__c.isUpdateable() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnSiteAmount__c.isUpdateable() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffshoreAmount__c.isUpdateable() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Name.isUpdateable()
            ){
                update DemandObj;
            }
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Updated Successfully!!!'));
            reset();
        }catch(Exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }

    }
    
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        Sobject Object_name;
        Schema.sObjectType sobject_type;
        Schema.DescribeSObjectResult sobject_describe;
         Map<String, Schema.SObjectField> field_map;
        List<Schema.PicklistEntry> pick_list_values;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        if(targetType!=null)
         Object_name = targetType.newSObject();
        
        if(Object_name!=null)
         sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        
         if(sobject_type!=null)
         sobject_describe = sobject_type.getDescribe(); //describe the sobject
        if(sobject_describe!=null)
         field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        
        if(field_map!=null)
         pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        if(pick_list_values!=null){
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
              lstPickvals.add(a.getValue());//add the value  to our final list
            }
        }
        return lstPickvals;
    }
    
    public List<WOption> getOnSiteOption(){
        lstOnsiteOption = new List<WOption>();
        for(string s : getPicklistValues(namespace +'Demand_Configuration_Ratio__c',namespace +'OnSite__c')){
            if(mapDemandOnsite.containsKey(s))
                lstOnsiteOption.add(new WOption(true,s.replaceAll(' ',''),s,mapDemandOnsite.get(s)));
            else
                lstOnsiteOption.add(new WOption(false,s.replaceAll(' ',''),s,null));
        }
        return lstOnsiteOption;
    }
    public List<WOption> getOffShoreOption(){
        //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'2namespace:'+namespace));
        lstOffshoreOption = new List<WOption>();
        for(string s : getPicklistValues(namespace +'Demand_Configuration_Ratio__c',namespace +'OffShore__c')){
            if(mapDemandOffshore.containsKey(s))
                lstOffshoreOption.add(new WOption(true,s.replaceAll(' ',''),s,mapDemandOffshore.get(s)));
            else
                lstOffshoreOption.add(new WOption(false,s.replaceAll(' ',''),s,null));
        }
        return lstOffshoreOption;
    }
    
    
    

}