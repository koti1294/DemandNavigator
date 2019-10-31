public with sharing class TableValue implements Comparable{
        public String Role{get;set;}
        public Integer NoRd{get;set;}
        public String AccountOwner{get;set;}
        public string userCurrencySign{get;set;}
        public String OppColor{get;set;}
        public String RoleId{get;set;}
        public String AccountOwnerId{get;set;}
        public String OppName{get;set;}
        public String AccName{get;set;}
        public String OppId{get;set;}
        public String AccId{get;set;}
        public Date Rdateopp{get;set;}
        public Double Contractvalue{get;set;}
        public Integer ContractTerm{get;set;}
        public Integer ClosingTotal{get;set;}
        public String S_ClosingTotal{get;set;}
        
        public String S_Rdateopp{get;set;}
        public String S_Contractvalue{get;set;}
        public String s_Total{get;set;}
        
        
        public Double Total{get;set;}
        public List<FYears> lstYears{get;set;}
        public Integer compareTo(Object compareTo) {
            TableValue compareToPlan = (TableValue)compareTo;
            if (AccountOwner== compareToPlan.AccountOwner) return 0;
            if (AccountOwner > compareToPlan.AccountOwner) return 1;
            return -1;        
        }

    }