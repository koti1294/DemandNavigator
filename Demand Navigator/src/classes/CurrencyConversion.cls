public with sharing class CurrencyConversion{
    public static map<string,decimal> mapConversionTable;
    public static void Initialization(){
        mapConversionTable = new map<string,decimal>();
        try{
            
        if (Opportunity.sObjectType.getDescribe().isAccessible()){
            for(sobject c : database.query('select id, isocode, conversionrate from currencytype where isactive = true')){ mapConversionTable.put(string.valueOf(c.get('isocode')), decimal.valueOf(string.valueOf(c.get('conversionrate'))));}

            }    
        }
        catch(Exception e){system.debug('MultiCurrency Not Enable');}
    }
    public Static decimal Convert(string fromCurrency, string toCurrency, decimal Amount){        
        decimal ConvertedAmount = 0;
        try{
            if(Amount <> null && mapConversionTable <> null && mapConversionTable.containsKey(fromCurrency) && mapConversionTable.containsKey(toCurrency)){ConvertedAmount  = Amount * (mapConversionTable.get(toCurrency) / mapConversionTable.get(fromCurrency)); }

        }
        catch(Exception e){system.debug('MultiCurrency Not Enable');}
        return ConvertedAmount.setScale(2);
    }
    public static map<Id,string> opportunityCurrencyCode(set<Id> opportunityIds){
        map<Id,string> mapOppCode = new map<Id,string>();
        try{
        	if (Opportunity.sObjectType.getDescribe().isAccessible()){
             for(sobject c : database.query('select id,CurrencyIsoCode from opportunity where CurrencyIsoCode <> null and Id IN: opportunityIds')){ mapOppCode.put(Id.valueOf(string.valueOf(c.get('id'))), string.valueOf(c.get('CurrencyIsoCode')));}


        	}    
           }
        catch(Exception e){system.debug('MultiCurrency Not Enable');}
        return mapOppCode;
    }
}