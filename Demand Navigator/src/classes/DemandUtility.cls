public with sharing class DemandUtility{
    public map<string,decimal> mapDemandOnsite;
    public map<string,decimal> mapDemandOffshore;
    public List<FiscalYear> lstFModel{get;set;}
    public Decimal TotalOnsiteResource{get;set;}
    public Decimal TotalOffshoreResource{get;set;}
    public Decimal TotalRevenue{get;set;}
    public map<string,Planning_Model__c> mapOtherModels ;
    public Opportunity MOpportunity ;
    public string str;
    
    public DemandUtility(Id OppId,Id strVersion){
           
        TotalOnsiteResource = 0;
        TotalOffshoreResource =0;
        TotalRevenue = 0;
        map<string,Id> mapMeasure = new map<string,Id>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
	        for(Planning_Financial_Measure__c mr : [select id,Name from Planning_Financial_Measure__c limit 100]){
	            mapMeasure.put(mr.Name,mr.Id);
	        }
        }
        if (Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Demand_Key__c.isAccessible() && Schema.sObjectType.Opportunity.fields.StageName.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_TCV__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Actuals_to_Date__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Onsite_Resource__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Offshore_Resource__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Rate_per_Head_onsite__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Rate_per_Head_offshore__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Onsite_Ratio__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Offshore_Ratio__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Onsite_Deal_Month__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.ExpectedRevenue.isAccessible() && Schema.sObjectType.Opportunity.fields.Deal_Duration__c.isAccessible() && Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
        && Schema.sObjectType.Opportunity.fields.isWon.isAccessible() && Schema.sObjectType.Opportunity.fields.isClosed.isAccessible() && Schema.sObjectType.OpportunityLineItem.fields.Id.isAccessible()){
        	MOpportunity = [select Id,Name,Amount,Demand_Key__c,StageName,Deal_TCV__c,Actuals_to_Date__c,Onsite_Resource__c,Offshore_Resource__c,Rate_per_Head_onsite__c,Rate_per_Head_offshore__c,Onsite_Ratio__c,Offshore_Ratio__c,Onsite_Deal_Month__c ,Offshore_Deal_Month__c ,Total_Deal__c,ExpectedRevenue,Deal_Duration__c,Probability,isWon,isClosed,(select Id,Quantity from OpportunityLineItems) from Opportunity where Id =: OppId];
        }
        List<Demand_Configuration_Ratio__c> lstdemandobj;
        if (Schema.sObjectType.Demand_Configuration_Ratio__c.fields.Id.isAccessible() && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OnsiteAmount__c.isAccessible()
        && Schema.sObjectType.Demand_Configuration_Ratio__c.fields.OffshoreAmount__c.isAccessible()){
        	lstdemandobj = [select Id, OnsiteAmount__c, OffshoreAmount__c from Demand_Configuration_Ratio__c where Demand_Key__c =: MOpportunity.Demand_Key__c limit 1];
        }
        mapDemandOnsite = new map<string,decimal>();        
        mapDemandOffshore = new map<string,decimal>();
        
        if(lstdemandobj.size() > 0){
            Demand_Configuration_Ratio__c DemandObj = lstdemandobj[0];
            if(DemandObj.OnSiteAmount__c <> null){
                for(string s : (DemandObj.OnSiteAmount__c).split(';')){
                    if(s <> null && s.contains(':')){
                        string d = s.split(':')[0];
                        string m = s.split(':')[1];
                        mapDemandOnsite.put(d,decimal.valueOf(m));
                    }
                }
            }
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
        List<Planning_Model__c> lstModel = new List<Planning_Model__c>();
        if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Resource_onsite__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
        && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible()  
        && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()    
        && Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible()    
        && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()          
        && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() ){        
            lstModel = [select Id,ModelName__c,Resource_offshore__c,Resource_onsite__c,Name,Amount__c,Planning_Version__c,Comments__c,Fiscal_Period__c,Planning_Measure__c,
            Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Opportunity__c,Opportunity__r.Probability,Opportunity__r.Total_Deal__c from Planning_Model__c where Opportunity__c =:OppId and Planning_Measure__r.Name = 'Revenue'  and Planning_Version__c =: strVersion];
        }
        mapOtherModels = new map<string,Planning_Model__c>();
        
        if (Schema.sObjectType.Planning_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.ModelName__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Resource_onsite__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Comments__c.isAccessible()
        && Schema.sObjectType.Planning_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Planning_Measure__c.isAccessible()  
        && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()    
        && Schema.sObjectType.Opportunity.fields.Probability.isAccessible() && Schema.sObjectType.Opportunity.fields.Total_Deal__c.isAccessible()    
        && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()          
        && Schema.sObjectType.Planning_Model__c.fields.Amount__c.isAccessible() 
        && Schema.sObjectType.Planning_Model__c.fields.Resource_offshore__c.isAccessible() && Schema.sObjectType.Planning_Model__c.fields.Opportunity__c.isAccessible() ){      
        for(Planning_Model__c m: [select Id,ModelName__c,Resource_offshore__c,Resource_onsite__c,Name,Amount__c,Planning_Version__c,Comments__c,Fiscal_Period__c,Planning_Measure__c,Fiscal_Period__r.Name,Fiscal_Period__r.Fiscal_Year__c,Opportunity__c,Opportunity__r.Probability,Opportunity__r.Total_Deal__c from Planning_Model__c where Opportunity__c =:OppId and Planning_Measure__c IN: mapMeasure.Values()  and Planning_Version__c =: strVersion]){
            mapOtherModels.put(m.ModelName__c,m);
        }
        }
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
                if(kk.RBModel.Amount__c!=null)
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
    }

    public string getDemandData(List<FiscalYear> lstTFModel,string versionNAme){
        
        Integer colspan=1;
        if(mapDemandOnsite.size()>0 || mapDemandOffshore.size()>0){
            colspan = 2;
        }
        str = versionName+'<br/><br/>';
        str += '<table>';
        string thdate = '<tr style="background-color: teal;">';
        thdate += '<td style="width:120px;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Year</td>';
        
        string trdate ='<tr>';
        trdate +='<td style="width:120px;background-color: teal;padding: 5px;color:white;text-align:left;" colspan="'+colspan+'">Period</td>';

        
        
        string onsiteHeader = '';
        if(mapDemandonsite.size()>0){
            onsiteHeader = '<Table style="width:100%">';
                for(string s : mapDemandonsite.keyset()){
                    onsiteHeader += '<tr>';
                        onsiteHeader += '<td style="padding: 5px;color:white;text-align:left;">'+s+'</td>';
                    onsiteHeader += '</tr>';
                }
            onsiteHeader += '</Table>';
        }
        string offshoreHeader = '';
        if(mapDemandOffshore.size()>0){
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
        if(mapDemandOffshore.size()>0){
            offshoreHeader = '<Table style="width:100%">';
            for(string s : mapDemandOffshore.keyset()){
                string strp = '<tr>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">'+s+'('+mapDemandoffshore.get(s)+'%)</td>';
                        for(FiscalYear f : lstTFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OffshoreModel.Amount__c > 0 && mapDemandoffshore.size()>0){
                                    amount = kk.OffshoreModel.Amount__c * (mapDemandoffshore.get(s) / 100);
                                }
                                strp += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;">'+amount+'</td>';
                            }
                        }
                        
                strp +='</tr>';
                offshoreTRS += strp;
            }
        }
        string onsiteTRS = '';
        if(mapDemandonsite.size()>0){
            onsiteHeader = '<Table style="width:100%">';
            for(string s : mapDemandonsite.keyset()){
                string strp = '<tr>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                    strp +='<td style="background-color: teal;padding: 5px;color:white;text-align:left;">'+s+'('+mapDemandonsite.get(s)+'%)</td>';
                        for(FiscalYear f : lstTFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OnsiteModel.Amount__c > 0 && mapDemandonsite.size()>0){
                                    amount = kk.OnsiteModel.Amount__c * (mapDemandonsite.get(s) / 100);
                                }
                                strp += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;">'+amount+'</td>';
                            }
                        }
                        
                strp +='</tr>';
                onsiteTRS += strp;
            }
        }
        
        
        for(FiscalYear f : lstTFModel){            
            for(FiscalModel kk : f.lstModel){
                
                trdate += '<td style="background-color:#A9A9A9;padding:5px;width:80px;text-align:center">'+(kk.FPeriod).substring(6)+'</td>';
                string onsiteExtra='';
                if(kk.OnsiteModel.Amount__c > 0 && mapDemandonsite.size()>0){
                    onsiteExtra = '<table style="width:150%;border-left: 1px solid #ECD887;">';                    
                    for(string s : mapDemandonsite.keyset()){
                        onsiteExtra += '<tr>';
                        onsiteExtra += '<td>'+kk.OnsiteModel.Amount__c * (mapDemandonsite.get(s) / 100)+'</td>';
                        onsiteExtra += '</tr>';
                    }
                    onsiteExtra += '</table>';
                    //tronsitedate += '<td style="background-color:#FFFFFF;padding:5px">'+onsiteExtra+'</td>';
                }
                
                    //tronsitedate += '<td style="background-color:#FFFFFF;padding:5px" ><div style="float:left">'+kk.OnsiteModel.Amount__c+'</div><div style="float:right">'+onsiteExtra+'</div></td>';
                    tronsitedate += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;" >'+kk.OnsiteModel.Amount__c+'</td>';
                
                
                string offshoreExtra='';
                if(kk.OffshoreModel.Amount__c > 0 && mapDemandoffshore.size()>0){
                    offshoreExtra = '<table style="width:150%;border-left: 1px solid #ECD887;">';                  
                    for(string s : mapDemandoffshore.keyset()){
                        offshoreExtra += '<tr>';
                        offshoreExtra += '<td>'+kk.OffshoreModel.Amount__c * (mapDemandoffshore.get(s) / 100)+'</td>';
                        offshoreExtra += '</tr>';
                    }
                    offshoreExtra += '</table>';
                    //troffshoredate += '<td style="background-color:#FFFFFF;padding:5px">'+offshoreExtra+'</td>';
                }
                
                 
                //troffshoredate += '<td style="background-color:#FFFFFF;padding:5px" ><div style="float:left">'+kk.OffshoreModel.Amount__c+'</div><div style="float:right">'+offshoreExtra+'</div></td>';
                troffshoredate += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;vertical-align:middle;" >'+kk.OffshoreModel.Amount__c+'</td>';
                
                trrevenue += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;">'+kk.Model.Amount__c+'</td>'; 
                trrevenuebacklog += '<td style="background-color:#FFFFFF;padding:5px;text-align:center;">'+kk.RBModel.Amount__c+'</td>'; 
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
    public string getDemandCSV(List<FiscalYear> lstTFModel,string versionNAme){
        
        Integer colspan=1;
        if(mapDemandOnsite.size()>0 || mapDemandOffshore.size()>0){
            colspan = 2;
        }
        str = versionName+'\n\n';
        string thdate = '';
        thdate += 'Year,';
        
        string trdate ='';
        trdate +='Period,';

        string tronsitedate ='';
        tronsitedate +='# Resource Onsite,';
        
        string troffshoredate ='';
        troffshoredate +='# Resource Offshore,';
        
        string trrevenue ='';
        trrevenue +='Revenue,';

        string trrevenuebacklog ='';
        trrevenuebacklog +='Revenue Backlog,';

        string offshoreTRS = '';
        if(mapDemandOffshore.size()>0){
            for(string s : mapDemandOffshore.keyset()){
                string strp = '';
                    strp +=','+s+'('+mapDemandoffshore.get(s)+'%)';
                        for(FiscalYear f : lstTFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OffshoreModel.Amount__c > 0 && mapDemandoffshore.size()>0){
                                    amount = kk.OffshoreModel.Amount__c * (mapDemandoffshore.get(s) / 100);
                                }
                                strp += ','+amount;
                            }
                        }
                        
                strp +='\n';
                offshoreTRS += strp;
            }
        }
        string onsiteTRS = '';
        if(mapDemandonsite.size()>0){
            for(string s : mapDemandonsite.keyset()){
                string strp = '';
                    strp +=','+s+'('+mapDemandonsite.get(s)+'%)';
                        for(FiscalYear f : lstTFModel){            
                            for(FiscalModel kk : f.lstModel){
                                decimal amount=0;
                                if(kk.OnsiteModel.Amount__c > 0 && mapDemandonsite.size()>0){
                                    amount = kk.OnsiteModel.Amount__c * (mapDemandonsite.get(s) / 100);
                                }
                                strp += ','+amount;
                            }
                        }
                        
                strp +='\n';
                onsiteTRS += strp;
            }
        }
        
        
        for(FiscalYear f : lstTFModel){            
            Integer count = 0;
            for(FiscalModel kk : f.lstModel){
                count++;
                trdate += ','+(kk.FPeriod).substring(6);
                tronsitedate += ','+kk.OnsiteModel.Amount__c;
                troffshoredate += ','+kk.OffshoreModel.Amount__c;
                trrevenue += ','+kk.Model.Amount__c;
                trrevenuebacklog += ','+kk.RBModel.Amount__c;
            }
            if(count>0){
                count = Integer.valueOf(count/2);
            }
            string ecomma = '';
            for(integer i=0;i<count;i++){
                ecomma+=',';
            }
            thdate += ','+ecomma+f.FYear+ecomma;
        }
        trrevenuebacklog += '\n';
        trrevenue += '\n';
        tronsitedate += '\n';
        troffshoredate += '\n';
        trdate += '\n';
        thdate += '\n';
        
        str += thdate;
        str += trdate;  
        str += tronsitedate;
        str += onsiteTRS;
        str += troffshoredate;
        str += offshoreTRS;
        str += trrevenue;
        str += trrevenuebacklog;
        return str;
    }
}