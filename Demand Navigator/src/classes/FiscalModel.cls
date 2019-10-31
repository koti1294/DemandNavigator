public with sharing class FiscalModel implements Comparable{
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