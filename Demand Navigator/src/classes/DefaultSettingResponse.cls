public with sharing class DefaultSettingResponse{
    public boolean isSuccess;
    public String response;
    public Integer recordCount; 
    public DefaultSettingResponse(boolean isSuccess,String response,Integer recordCount){
        this.isSuccess = isSuccess;
        this.response = response;
        this.recordCount = recordCount;
    }
}