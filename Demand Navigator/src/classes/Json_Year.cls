public with sharing class Json_Year implements Comparable{
    public Integer Year;
    public List<Json_Period> period;
    public Json_Year(){}
    public Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        Json_Year compareToOppy = (Json_Year)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (Year > compareToOppy.Year) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (Year < compareToOppy.Year) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}