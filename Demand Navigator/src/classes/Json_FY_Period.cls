public with sharing class Json_FY_Period  implements Comparable{
    public String Id;
    public Integer Period;
    public String Label;
    public String Category;
    public Integer CurrentPeriod;
    
    public Integer compareTo(Object compareTo) {
        Json_FY_Period compareToPlan = (Json_FY_Period)compareTo;
        if (CurrentPeriod == compareToPlan.CurrentPeriod) return 0;
        if (CurrentPeriod > compareToPlan.CurrentPeriod) return 1;
        return -1;        
    }
}