public with sharing class DemandPlanningHandler{

    public Opportunity MOpportunity{get;set;}
    public List<FiscalYear> lstFModel{get;set;}
    public Decimal TotalOnsiteResource{get;set;}
    public Decimal TotalOffshoreResource{get;set;}
    public Decimal TotalRevenue{get;set;}
    public boolean isClosedOpp{get;set;}
    map<string,Planning_Model__c> mapOtherModels;
    public DemandPlanningHandler(ApexPages.StandardController str){
        getModelVersions();
        Initialize();      
    }
    public string str{get;set;}
    
    public string getDemandData(){
        
        Integer colspan=1;
        if(mapDemandOffshore <> null && (mapDemandOnsite.size()>0 || mapDemandOffshore.size()>0)){
            colspan = 2;
        }
        str = '<table>';
        string thdate = '<tr style="background-color: teal;">';
        thdate += '<td style="width:120px;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Year</td>';
        
        string trdate ='<tr>';
        trdate +='<td style="width:120px;background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Period</td>';

        
        
        string onsiteHeader = '';
        if(mapDemandOffshore <> null &&  mapDemandonsite.size()>0){
            onsiteHeader = '<Table style="width:100%">';
                for(string s : mapDemandonsite.keyset()){
                    onsiteHeader += '<tr>';
                        onsiteHeader += '<td style="padding: 5px;color:white;text-align:left;">'+s+'</td>';
                    onsiteHeader += '</tr>';
                }
            onsiteHeader += '</Table>';
        }
        string offshoreHeader = '';
        if(mapDemandOffshore <> null && mapDemandOffshore.size()>0){
            offshoreHeader = '<Table style="width:100%">';
                for(string s : mapDemandOffshore.keyset()){
                    offshoreHeader += '<tr>';
                        offshoreHeader += '<td style="padding: 5px;color:white;text-align:left;">'+s+'</td>';
                    offshoreHeader += '</tr>';
                }
            offshoreHeader += '</Table>';
        }
        string tronsitedate ='<tr>';
        tronsitedate +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'"># Resource Onsite</td>';
        //tronsitedate +='<td style="width:120px;background-color: teal;"><table><tr><td style="background-color: teal;padding: 5px;color:white;text-align:left;"># Resource Onsite</td><td>'+onsiteHeader+'</td></tr></table></td>';

        string troffshoredate ='<tr>';
        troffshoredate +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'"># Resource Offshore</td>';
        //troffshoredate +='<td style="width:120px;background-color: teal;"><table><tr><td style="background-color: teal;padding: 5px;color:white;text-align:left;"># Resource Offshore</td><td>'+offshoreHeader+'</td></tr></table></td>';
        
        string trrevenue ='<tr>';
        trrevenue +='<td style="width:120px;background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Revenue</td>';

        string trrevenuebacklog ='<tr>';
        trrevenuebacklog +='<td style="width:120px;background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Revenue Backlog</td>';

        string offshoreTRS = '';
        if(mapDemandOffshore <> null && mapDemandOffshore.size()>0){
            offshoreHeader = '<Table style="width:100%">';
            for(string s : mapDemandOffshore.keyset()){
                string strp = '<tr>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">'+s+'('+mapDemandoffshore.get(s)+'%)</td>';
                        for(FiscalYear f : lstFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OffshoreModel.Amount__c > 0 && mapDemandoffshore.size()>0){
                                    amount = kk.OffshoreModel.Amount__c * (mapDemandoffshore.get(s) / 100);
                                }
                                strp += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;">'+Math.Round(amount)+'</td>';
                            }
                        }
                        
                strp +='</tr>';
                offshoreTRS += strp;
            }
        }
        string onsiteTRS = '';
        if(mapDemandonsite <> null && mapDemandonsite.size()>0){
            onsiteHeader = '<Table style="width:100%">';
            for(string s : mapDemandonsite.keyset()){
                string strp = '<tr>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">'+s+'('+mapDemandonsite.get(s)+'%)</td>';
                        for(FiscalYear f : lstFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OnsiteModel.Amount__c > 0 && mapDemandonsite.size()>0){
                                    amount = kk.OnsiteModel.Amount__c * (mapDemandonsite.get(s) / 100);
                                }
                                strp += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;">'+Math.Round(amount)+'</td>';
                            }
                        }
                        
                strp +='</tr>';
                onsiteTRS += strp;
            }
        }
        
        
        for(FiscalYear f : lstFModel){            
            for(FiscalModel kk : f.lstModel){
                
                trdate += '<td style="background-color:#A9A9A9;padding:5px;width:80px;text-align:center">'+(kk.FPeriod).substring(6)+'</td>';
                string onsiteExtra='';
                if(mapDemandonsite <> null && kk.OnsiteModel.Amount__c > 0 && mapDemandonsite.size()>0){
                    onsiteExtra = '<table style="width:150%;border-left: 1px solid #ECD887;">';                    
                    for(string s : mapDemandonsite.keyset()){
                        onsiteExtra += '<tr>';
                        onsiteExtra += '<td>'+Math.Round(kk.OnsiteModel.Amount__c * (mapDemandonsite.get(s) / 100))+'</td>';
                        onsiteExtra += '</tr>';
                    }
                    onsiteExtra += '</table>';
                    //tronsitedate += '<td style="background-color:#FFFFFF;padding:5px">'+onsiteExtra+'</td>';
                }
                
                    //tronsitedate += '<td style="background-color:#FFFFFF;padding:5px" ><div style="float:left">'+kk.OnsiteModel.Amount__c+'</div><div style="float:right">'+onsiteExtra+'</div></td>';
                    tronsitedate += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;" >'+Math.Round(kk.OnsiteModel.Amount__c)+'</td>';
                
                
                string offshoreExtra='';
                if(mapDemandonsite <> null && kk.OffshoreModel.Amount__c > 0 && mapDemandoffshore.size()>0){
                    offshoreExtra = '<table style="width:150%;border-left: 1px solid #ECD887;">';                  
                    for(string s : mapDemandoffshore.keyset()){
                        offshoreExtra += '<tr>';
                        offshoreExtra += '<td>'+Math.Round(kk.OffshoreModel.Amount__c * (mapDemandoffshore.get(s) / 100))+'</td>';
                        offshoreExtra += '</tr>';
                    }
                    offshoreExtra += '</table>';
                    //troffshoredate += '<td style="background-color:#FFFFFF;padding:5px">'+offshoreExtra+'</td>';
                }
                
                 
                //troffshoredate += '<td style="background-color:#FFFFFF;padding:5px" ><div style="float:left">'+kk.OffshoreModel.Amount__c+'</div><div style="float:right">'+offshoreExtra+'</div></td>';
                troffshoredate += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;" >'+Math.Round(kk.OffshoreModel.Amount__c)+'</td>';
                
                trrevenue += '<td><input  style="width:80px;background-color:#FDFDCB;padding:5px" type="text" value="'+Math.Round(kk.Model.Amount__c)+'" onChange="SaveDemandModel(\''+kk.Model.Id+'\',this)"></input></td>'; 
               if(kk.RBModel.Amount__c!=null)
                trrevenuebacklog += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;">'+Math.Round(kk.RBModel.Amount__c)+'</td>'; 
            }
            thdate += '<td style="padding: 5px;color:white;text-align:center;" colspan="'+f.lstModel.size()+'">'+f.FYear+'</td>';
        }
        trrevenuebacklog += '</tr>';
        trrevenue += '</tr>';
        tronsitedate += '</tr>';
        troffshoredate += '</tr>';
        trdate += '</tr>';
        thdate += '</tr>';
        
        str += thdate;
        str += trdate;  
        str += tronsitedate;
        str += onsiteTRS;
        str += troffshoredate;
        str += offshoreTRS;
        str += trrevenue;
        str += trrevenuebacklog;
        str += '</table>';     
        return str;
    }
    Demand_Configuration_Ratio__c demandobj;
    map<string,decimal> mapDemandOnsite;
    map<string,decimal> mapDemandOffshore;
    map<string,Id> mapMeasure;
    map<Id,string> mapVersions;
    public string strVersion{get;set;}
    public List<SelectOption> getModelVersions() {
        mapVersions = new map<Id,string>();
        //mapOtherModels = new map<string,Planning_Model__c>();
        String OppId = apexpages.currentpage().getparameters().get('id');  
        if(Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && 
        Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && 
        Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible()
        ){      
            for(Planning_Model__c m: [select Planning_Version__c,Planning_Version__r.Name from Planning_Model__c where Opportunity__c =:OppId]){
                mapVersions.put(m.Planning_Version__c,m.Planning_Version__r.Name);
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        //strVersion = null;
        for(Id  vId : mapVersions.keyset()){
            if(strVersion == null)strVersion = vId;
            options.add(new SelectOption(vId,mapVersions.get(vId)));
        }
        return options;
    }
    public void getPlanningModel(){
        Initialize();
    }
    public void Initialize(){
        
        //try{
        mapMeasure = new map<string,Id>();
        if(Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
            for(Planning_Financial_Measure__c mr : [select id,Name from Planning_Financial_Measure__c limit 100]){
                mapMeasure.put(mr.Name,mr.Id);
            }
        }
        
        TotalOnsiteResource = 0;
        TotalOffshoreResource = 0;
        TotalRevenue = 0;
        isClosedOpp = false;
        String OppId = apexpages.currentpage().getparameters().get('id');   
        if(Schema.sObjectType.Opportunity.fields.Id.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Name.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Id.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Amount.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Demand_Key__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Actuals_to_Date__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Onsite_Resource__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Offshore_Resource__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Rate_per_Head_onsite__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Rate_per_Head_offshore__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Onsite_Ratio__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Offshore_Ratio__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Onsite_Deal_Month__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Offshore_Deal_Month__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.ExpectedRevenue.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && 
            Schema.sObjectType.OpportunityLineItem.fields.Id.isAccessible() && 
            Schema.sObjectType.OpportunityLineItem.fields.Quantity.isAccessible()
        ){
            List<Opportunity> oppList = new List<Opportunity>();
            System.debug('>>>>>>>>>'+OppId);
            if(OppId!=null){
                oppList = [select Id,Name,Amount,Demand_Key__c,StageName,Deal_TCV__c,Actuals_to_Date__c,Onsite_Resource__c,Offshore_Resource__c,Rate_per_Head_onsite__c,Rate_per_Head_offshore__c,Onsite_Ratio__c,Offshore_Ratio__c,
                Onsite_Deal_Month__c ,Offshore_Deal_Month__c ,Total_Deal__c,ExpectedRevenue,Deal_Duration__c,Probability,isWon,isClosed,(select Id,Quantity from OpportunityLineItems) from Opportunity where Id =: OppId];
            }
            if(oppList.size()>0){
                MOpportunity=oppList[0];
            }
        }
        List<Demand_Configuration_Ratio__c> lstDemandObj = new List<Demand_Configuration_Ratio__c>();
        if(Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnsiteAmount__c.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffshoreAmount__c.isAccessible() && 
            Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Demand_Key__c.isAccessible()
        ){
        lstDemandObj = [select Id, OnsiteAmount__c,    OffshoreAmount__c from Demand_Configuration_Ratio__c where Demand_Key__c =: MOpportunity.Demand_Key__c]; 
        }
        if(!lstDemandObj.isempty() && lstDemandObj.size()>0){
            demandobj = lstDemandObj[0];
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
        
        if(MOpportunity.isWon && MOpportunity.isClosed){
            isClosedOpp = true;
            string hlink = ', you can recalculate onsite and offshore amount from<b><a target="_blank" href="/apex/Forecastera_Planning_Workbench">Workbench</a></b>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'You can not calculate revenue for closed won opportunities'+hlink));
        }
        
        List<Planning_Model__c> lstModel = new List<Planning_Model__c>();
        if(Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Resource_onsite__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() && 
            Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() &&
            Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && 
            Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()         
        ){
            
            lstModel = [select Id,ModelName__c,Resource_offshore__c,Resource_onsite__c,Name,Amount__c,Planning_Version__c,Comments__c,Fiscal_Period__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Opportunity__c,Opportunity__r.Probability,Opportunity__r.Total_Deal__c from Planning_Model__c where Opportunity__c =:OppId and Planning_Measure__r.Name = 'Revenue' and Planning_Version__c =: strVersion];
        
        }
        
        mapOtherModels = new map<string,Planning_Model__c>();
        if(Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Resource_onsite__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && 
            Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && 
            Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible() &&
            Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() &&
            Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() &&
            Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && 
            Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()         
        ){
        for(Planning_Model__c m: [select Id,ModelName__c,Resource_offshore__c,Resource_onsite__c,Name,Amount__c,Planning_Version__c,Planning_Version__r.Name,Comments__c,
            Fiscal_Period__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Opportunity__c,Opportunity__r.Probability,Opportunity__r.Total_Deal__c from Planning_Model__c where Opportunity__c =:OppId and Planning_Measure__c IN: mapMeasure.Values()  and Planning_Version__c =: strVersion]){
                mapOtherModels.put(m.ModelName__c,m);
            }
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,mapOtherModels+''));
        
        map<string,List<Planning_Model__c>> mapFYear = new map<string,List<Planning_Model__c>>();
        map<Id,string> mapSequenceModel = new map<Id,string>();
        for(Planning_Model__c m : lstModel){
            List<Planning_Model__c> lstMd = new List<Planning_Model__c>();
            lstMd.add(m);
            if(mapFYear.ContainsKey(m.Fiscal_Period__r.Fiscal_Year__c)){
                lstMd.addAll(mapFYear.get(m.Fiscal_Period__r.Fiscal_Year__c));
            }
            mapFYear.put(m.Fiscal_Period__r.Fiscal_Year__c,lstMd);
            List<string> sq = (m.Fiscal_Period__r.Name).split('P');
            string pp = sq[0]+'P'+sq[1];
            if(Integer.valueOf(sq[1]) < 10){
                pp = sq[0]+'P0'+sq[1];
            }
            mapSequenceModel.put(m.Id,pp);
        }
        lstFModel = new List<FiscalYear>();
        
        boolean isVolumable  = false;
        Integer PeriodCount = 0;
        
        for(string fyear : mapFYear.keyset()){
            
            List<FiscalModel> lstFYear = new List<FiscalModel>();
            
            for(Planning_Model__c m : mapFYear.get(fyear)){
                
                PeriodCount++;
                FiscalModel kk = new FiscalModel();
                kk.FPeriod = mapSequenceModel.get(m.Id);
                string modelName = m.ModelName__c;
                modelName = modelName.replaceAll('Revenue','');
                kk.Model = m;
                if((m.Resource_onsite__c == null || m.Resource_onsite__c == 0) &&  (m.Resource_offshore__c == null || m.Resource_offshore__c == 0)){
                    isVolumable = true;
                }
                
                if(mapOtherModels.containsKey(modelName+'Revenue Backlog'))
                    kk.RBModel = mapOtherModels.get(modelName+'Revenue Backlog');
                if(mapOtherModels.containsKey(modelName+'Onsite') && mapOtherModels.get(modelName+'Onsite') <> null)
                    kk.OnsiteModel = mapOtherModels.get(modelName+'Onsite');
                else{   
                    kk.OnsiteModel = new Planning_Model__c();
                    kk.OnsiteModel.Amount__c = 0;
                    kk.OnsiteModel.Planning_Version__c = m.Planning_Version__c;
                    kk.OnsiteModel.ModelName__c = modelName +'Onsite';
                    kk.OnsiteModel.Comments__c = 'Default Model:Onsite';
                    kk.OnsiteModel.Fiscal_Period__c = m.Fiscal_Period__c;
                    kk.OnsiteModel.Planning_Measure__c = mapMeasure.get('Onsite');
                    kk.OnsiteModel.Opportunity__c = m.Opportunity__c;
                    if(m.Amount__c <> null && MOpportunity.Onsite_Ratio__c <> null && MOpportunity.onsite_Deal_Month__c <> null && MOpportunity.onsite_Deal_Month__c >0 )
                    kk.OnsiteModel.Amount__c = (m.Amount__c * MOpportunity.Onsite_Ratio__c)/MOpportunity.onsite_Deal_Month__c;
                    kk.OnsiteModel.Amount__c = Math.Round(kk.OnsiteModel.Amount__c);
                                    
                }
                if(mapOtherModels.containsKey(modelName+'Offshore') && mapOtherModels.get(modelName+'Offshore') <> null)
                    kk.OffshoreModel = mapOtherModels.get(modelName+'Offshore');
                else{   
                    Planning_Model__c newRplan = new Planning_Model__c();
                    newRPlan.Amount__c = 0;
                    newRplan.Planning_Version__c = m.Planning_Version__c;
                    newRplan.ModelName__c = modelName +'Offshore';
                    newRplan.Comments__c = 'Default Model:Offshore';
                    newRplan.Fiscal_Period__c = m.Fiscal_Period__c;
                    newRplan.Planning_Measure__c = mapMeasure.get('Offshore');
                    newRplan.Opportunity__c = m.Opportunity__c;  
                    kk.OffshoreModel    = newRplan;       

                    if(m.Amount__c <> null && MOpportunity.Offshore_Ratio__c <> null && MOpportunity.Offshore_Deal_Month__c <> null && MOpportunity.Offshore_Deal_Month__c >0)
                    kk.OffshoreModel.Amount__c = (m.Amount__c * MOpportunity.Offshore_Ratio__c)/MOpportunity.Offshore_Deal_Month__c;
                    kk.OffshoreModel.Amount__c = Math.Round(kk.OffshoreModel.Amount__c);
                }
                kk.Model.Amount__c = (kk.Model.Amount__c).setScale(2);
                if(kk.RBModel <> null && kk.RBModel.Amount__c <> null)
                kk.RBModel.Amount__c = (kk.RBModel.Amount__c).setScale(2);
                lstFYear.add(kk);
                TotalOnsiteResource += m.Resource_onsite__c;
                TotalOffshoreResource += m.Resource_offshore__c;
                TotalRevenue += m.Amount__c;
            }
            lstFYear.sort();            
            FiscalYear ll = new FiscalYear();
            ll.FYear = fyear;
            ll.lstModel = lstFYear;
            lstFModel.add(ll);   
            lstFModel.sort();
        }
        Integer ProductCount = 0;
        if(MOpportunity.OpportunityLineItems <> null){
            for(OpportunityLineItem line : MOpportunity.OpportunityLineItems){
                ProductCount+= Integer.valueOf(line.Quantity);
            }
        }        
        TotalOnsiteResource = TotalOnsiteResource.setScale(2);
        TotalOffshoreResource = TotalOffshoreResource.setScale(2);
        TotalRevenue = TotalRevenue.setScale(2);
        //}catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,e.getMessage()+'--'+e.getLineNumber()));}

        
    }
    public pagereference updateModel(){
        string mid = apexpages.currentpage().getparameters().get('mid');
        string value = apexpages.currentpage().getparameters().get('value');
        
        List<Planning_Model__c> lstMmodel = new List<Planning_Model__c>();
        decimal PreviousBal;
        TotalOnsiteResource = 0;
        TotalOffshoreResource = 0;
        TotalRevenue = 0;
        for(FiscalYear f : lstFModel){            
            for(FiscalModel m : f.lstModel){
                if(m.Model.Id == mid){
                    Planning_Model__c Model = m.Model;
                    if(value <> null && value <> ''){
                        model.Amount__c = decimal.valueOf(value);
                    }
                }
            }
        }
        for(FiscalYear f : lstFModel){            
            for(FiscalModel m : f.lstModel){
                //if(m.Model.Id == mid)
                {
                    Planning_Model__c Model = m.Model;
                    Planning_Model__c RBModel = m.RBModel;
                    Planning_Model__c OnsiteModel = m.OnsiteModel;
                    Planning_Model__c OffshoreModel = m.OffshoreModel;

                    if(model.Amount__c<>null){
                        
                        if(model.Amount__c <> null && MOpportunity.Onsite_Ratio__c <> null  && MOpportunity.onsite_Deal_Month__c <> null && MOpportunity.onsite_Deal_Month__c >0)
                        OnsiteModel.Amount__c = (model.Amount__c * MOpportunity.Onsite_Ratio__c)/MOpportunity.onsite_Deal_Month__c;
                        if(model.Amount__c <> null && MOpportunity.Offshore_Ratio__c <> null && MOpportunity.Offshore_Deal_Month__c <> null && MOpportunity.Offshore_Deal_Month__c >0)
                        OffshoreModel.Amount__c = (model.Amount__c * MOpportunity.Offshore_Ratio__c)/MOpportunity.Offshore_Deal_Month__c;
                        
                        OnsiteModel.Amount__c = Math.Round(OnsiteModel.Amount__c);
                        OffshoreModel.Amount__c = Math.Round(OffshoreModel.Amount__c);
                    
                        TotalOnsiteResource += OnsiteModel.Amount__c;
                        TotalOffshoreResource += OffshoreModel.Amount__c;
                        
                        
                        m.Model = Model;
                        lstMmodel.add(m.Model);
                        
                        if(OnsiteModel <> null){
                            m.OnsiteModel = OnsiteModel;
                            lstMmodel.add(m.OnsiteModel);
                        }
                        if(OffshoreModel <> null){
                            m.OffshoreModel = OffshoreModel;
                            lstMmodel.add(m.OffshoreModel);
                        }
                        
                        
                        if(RBModel <> null){
                            decimal RActual = 0;
                            if(mOpportunity.Actuals_to_Date__c <> null)
                                RActual = mOpportunity.Actuals_to_Date__c;
                                        
                            if(PreviousBal == null){
                                PreviousBal = mOpportunity.Deal_TCV__c - RActual;
                            }
                            RBModel.Amount__c = PreviousBal - Model.Amount__c;
                            PreviousBal = RBModel.Amount__c;                    

                            if(RBModel.Amount__c < 0.1)
                                RBModel.Amount__c = Math.Floor(RBModel.Amount__c);
                            
                            
                            m.RBModel = RBModel;                   
                            
                            lstMmodel.add(m.RBModel);
                        }
                    }
                }
            }
        }
        //upsert lstMmodel;
        TotalOnsiteResource = Math.Round(TotalOnsiteResource);
        TotalOffshoreResource = Math.Round(TotalOffshoreResource);
        TotalRevenue = TotalRevenue.setScale(2);
        return null;
    }
                
    public pagereference saveModels(){
        List<Planning_Model__c> lstMmodel = new List<Planning_Model__c>();
        List<Planning_Model__c> lstOnsiteExist = new List<Planning_Model__c>();
        List<Planning_Model__c> lstOffshoreExist = new List<Planning_Model__c>();
        List<Planning_Model__c> lstOnsiteMmodel = new List<Planning_Model__c>();
        List<Planning_Model__c> lstOffshoreMmodel = new List<Planning_Model__c>();
        for(FiscalYear f : lstFModel){
            for(FiscalModel m : f.lstModel){
                lstMmodel.add(m.Model);
                lstMmodel.add(m.RBModel);
                lstMmodel.add(m.OnsiteModel);
                lstMmodel.add(m.OffshoreModel);

                lstOnsiteExist.add(m.OnsiteModel);  
                lstOffshoreExist.add(m.OffshoreModel);                  
            }           
        }
        
        
        
        for(Planning_Model__c p1:lstOnsiteExist){
            if(mapDemandonsite.size()>0){
                for(string s : mapDemandonsite.keyset()){
                    if(mapMeasure.containsKey('Onsite-'+s)){
                        decimal amount = p1.Amount__c * (mapDemandonsite.get(s) / 100);
                        List<string> mName = (p1.ModelName__c).split('#');
                        string modelname = mName[0]+'#'+ mName[1]+'#'+ mName[2]+'#Onsite-'+s;
                        Planning_Model__c newp;
                        if(mapOtherModels.containsKey(modelname)){
                            newp = mapOtherModels.get(modelname);
                        }else{
                            newp = new Planning_Model__c();                                                                 
                            newp.Planning_Version__c = p1.Planning_Version__c;
                            newp.ModelName__c = modelname;
                            newp.Comments__c = 'Default Onsite Sub Model';
                            newp.Fiscal_Period__c = p1.Fiscal_Period__c;
                            newp.Planning_Measure__c = mapMeasure.get('Onsite-'+s);
                            newp.Opportunity__c = p1.Opportunity__c;
                        }
                        newp.Amount__c = amount;                                
                        lstOnsiteMmodel.add(newp);
                    }
                }
            }                   
        }
        for(Planning_Model__c p1:lstOffshoreExist){
            if(mapDemandoffshore.size()>0){
                for(string s : mapDemandoffshore.keyset()){
                    if(mapMeasure.containsKey('Offshore-'+s)){
                        decimal amount = p1.Amount__c * (mapDemandoffshore.get(s) / 100);
                        List<string> mName = (p1.ModelName__c).split('#');
                        string modelname = mName[0]+'#'+ mName[1]+'#'+ mName[2]+'#Offshore-'+s;
                        Planning_Model__c newp;
                        if(mapOtherModels.containsKey(modelname)){
                            newp = mapOtherModels.get(modelname);
                        }else{
                            newp = new Planning_Model__c();                             
                            newp.Planning_Version__c = p1.Planning_Version__c;
                            newp.ModelName__c = modelname;
                            newp.Comments__c = 'Default Offshore Sub Model';
                            newp.Fiscal_Period__c = p1.Fiscal_Period__c;
                            newp.Planning_Measure__c = mapMeasure.get('Offshore-'+s);
                            newp.Opportunity__c = p1.Opportunity__c;
                        }
                        newp.Amount__c = amount;    
                        lstOffshoreMmodel.add(newp);
                    }
                }
            }                   
        }
                
        try{  
        if(
        Schema.sObjectType.Planning_Model__c.fields.Amount__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Comments__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isUpdateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Amount__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Comments__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isCreateable() && 
        Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isCreateable()
        ){
            upsert lstMmodel;
            upsert lstOnsiteMmodel;
            upsert lstOffshoreMmodel;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Saved Successfully'));
        Initialize();
        }catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,e+'--------------'+mapOtherModels));
            for(string s : mapOtherModels.keyset()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,s));
        }
            
        }
        
        return null;
    }
    public pagereference resetModels(){
        Initialize();
        return null;
    }
    public pagereference GotoBack(){
        pagereference pg = new Pagereference('/'+MOpportunity.Id);
        pg.setRedirect(true);
        return pg;
        return null;
    }
    
    public class FiscalYear implements Comparable{
        public string FYear{get;set;}
        public List<FiscalModel> lstModel{get;set;}
        public Integer compareTo(Object compareTo) {
            FiscalYear compareObj = (FiscalYear)compareTo;
            if (FYear == compareObj.FYear) return 0;
            if (FYear > compareObj.FYear) return 1;
            return -1;        
        }
    }
    public class FiscalModel implements Comparable{
        public string FPeriod{get;set;}
        public Planning_Model__c Model{get;set;}
        public Planning_Model__c RBModel{get;set;}
        public Planning_Model__c OnsiteModel{get;set;}
        public Planning_Model__c OffshoreModel{get;set;}
        
        public decimal Revenue_Volume{get;set;}
        public Integer compareTo(Object compareTo) {
            FiscalModel compareObj = (FiscalModel)compareTo;
            if (FPeriod == compareObj.FPeriod) return 0;
            if (FPeriod > compareObj.FPeriod) return 1;
            return -1;        
        }
    }
    public pagereference DownloadCSV(){
        return page.DemandForcecastCSV;
    }

}