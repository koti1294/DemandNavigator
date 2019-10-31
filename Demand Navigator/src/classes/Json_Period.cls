public with sharing class Json_Period implements Comparable {

    public string Id;
    public Integer month;
    public String monthlabel;
    public String Measure;
    public Integer Amount;
    
    public List<Json_Period_Measure> lstPMeasure;
    
    //measure IDs
    public string Revenue_RowId;
    public string RevenueAdjustment_RowId;
    public string GrossMargin_RowId;
    public string BusinessAnalyst_RowId;
    public string DatabaseEngineers_RowId;
    public string Investment_RowId;
    public string RevenueBacklog_RowId;
    
    //measure amount
    public Integer Revenue;
    public Integer RevenueAdjustment;
    public Integer GrossMargin;
    public Integer BusinessAnalyst;
    public Integer DatabaseEngineers;
    public Integer Investment;
    public Integer RevenueBacklog;
    
    //Is Editable
    public Integer Revenue_isEditable;
    public Integer RevenueAdjustment_isEditable;
    public Integer GrossMargin_isEditable;
    public Integer BusinessAnalyst_isEditable;
    public Integer DatabaseEngineers_isEditable;
    public Integer Investment_isEditable;
    public Integer RevenueBacklog_isEditable;
    
    public Integer isEditable;
    
    //comment
    public string Revenue_Comment;
    public string RevenueAdjustment_Comment;
    public string GrossMargin_Comment;
    public string BusinessAnalyst_Comment;
    public string DatabaseEngineers_Comment;
    public string Investment_Comment;
    public string RevenueBacklog_Comment;
    
    public string Comment;
    
    public Json_Period(){
    
        this.lstPMeasure = new list<Json_Period_Measure>();
        this.Revenue_RowId = '';
        this.RevenueAdjustment_RowId = '';
        this.GrossMargin_RowId = '';
        this.BusinessAnalyst_RowId = '';
        this.DatabaseEngineers_RowId = '';
        this.Investment_RowId = '';
        this.RevenueBacklog_RowId = '';
        
        this.Revenue = 0;
        this.RevenueAdjustment = 0;
        this.GrossMargin = 0;
        this.BusinessAnalyst = 0;
        this.DatabaseEngineers = 0;
        this.Investment = 0;
        this.RevenueBacklog = 0;

        this.Revenue_isEditable = 1;
        this.RevenueAdjustment_isEditable = 1;
        this.GrossMargin_isEditable = 1;
        this.BusinessAnalyst_isEditable = 1;
        this.DatabaseEngineers_isEditable = 1;
        this.Investment_isEditable = 1;
        this.RevenueBacklog_isEditable = 0;
        
        this.Revenue_Comment = '';
        this.RevenueAdjustment_Comment = '';
        this.GrossMargin_Comment = '';
        this.BusinessAnalyst_Comment = '';
        this.DatabaseEngineers_Comment = '';
        this.Investment_Comment = '';
        this.RevenueBacklog_Comment = '';
    }
    public Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        Json_Period compareToOppy = (Json_Period)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (month > compareToOppy.month) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (month < compareToOppy.month) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}