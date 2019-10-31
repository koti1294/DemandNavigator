public with sharing class FYears implements Comparable{
        public string label{get;set;}
        public Integer value{get;set;}
        public Integer labelNumber{get;set;}
        public Integer compareTo(Object compareTo) {
            FYears compareToPlan = (FYears)compareTo;
            if (labelNumber == compareToPlan.labelNumber) return 0;
            if (labelNumber > compareToPlan.labelNumber) return 1;
            return -1;        
        }
    }