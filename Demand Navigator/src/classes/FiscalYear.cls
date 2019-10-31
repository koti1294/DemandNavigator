public with sharing class FiscalYear implements Comparable{
        public string FYear{get;set;}
        public List<FiscalModel> lstModel{get;set;}
        public Integer compareTo(Object compareTo) {
            FiscalYear compareObj = (FiscalYear)compareTo;
            if (FYear == compareObj.FYear) return 0;
            if (FYear > compareObj.FYear) return 1;
            return -1;        
        }
    }