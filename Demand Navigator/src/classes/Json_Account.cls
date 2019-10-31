public with sharing class Json_Account{
    public String AccountName;
    public String  AccountID;
    public List<Json_Opportunity> Opportunity;
    public Json_Account(string AccountName,string AccountId, List<Json_Opportunity> Opportunity){
        this.AccountId = AccountId;
        this.AccountName = AccountNAme;
        this.Opportunity = Opportunity;
    }
    public Json_Account(){
    }
}