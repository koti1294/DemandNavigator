public with sharing class Json_Period_Measure implements Comparable {

    public string Id;
    public Integer isEditable;
    public String Name;
    public String Comment;
    public Integer Amount;
    
    
    
    public Json_Period_Measure (){
        this.Id= '';
        this.isEditable= 1;
        this.Name = '';
        this.Comment= '';
        this.Amount= 0;
    }
    public Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        Json_Period_Measure compareToOppy = (Json_Period_Measure )compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (Name> compareToOppy.Name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (Name< compareToOppy.Name) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}