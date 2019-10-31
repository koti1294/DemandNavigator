public with sharing class Json_Measure implements Comparable{
    public String Id;
    public String Name;
    public String Label;
    public String Calculated;
    public boolean Restricted_by_Revenue_Term;
    public string Measure_Type;
    public string Unit_of_Measure;
    public Json_Measure(){}
    public Integer compareTo(Object compareTo) {
        Json_Measure compareToPlan = (Json_Measure)compareTo;
        if (Name == compareToPlan.Name) return 0;
        if (Name > compareToPlan.Name) return 1;
        return -1;        
    }
}