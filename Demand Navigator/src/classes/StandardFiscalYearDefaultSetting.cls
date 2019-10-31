public with sharing class StandardFiscalYearDefaultSetting {

    public class S_FiscalYearSettings{
          public string Name;
          public Date startDate;
          public Date endDate;    
          public string PeriodLabelScheme;
          public string PeriodPrefix;
          public list<S_Period> Periods;
    }
    public class S_Period{
          public string PID;
          public string Type;
          public Date startDate;
          public Date endDate;    
          public Integer MPNumber;
          public string PeriodLabel;
    }
    public S_FiscalYearSettings sfiscal;
    public Map<Integer,String> mapMonthString;
            
        
  
    public StandardFiscalYearDefaultSetting(){
        
        mapMonthString = new Map<Integer,String>();
        
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        
        sfiscal = new S_FiscalYearSettings();
        string cyear = ''+(system.today()).year();
        if (Schema.sObjectType.Organization.fields.id.isAccessible() && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible()){
          
        
        Organization org = [Select id,FiscalYearStartMonth from Organization limit 1];
        
        date pstartDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);

         Map<Integer,String> mapMonthString = new Map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');    
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
         mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');    
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
         mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');    
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
            
            
        
        List<S_Period> lstP = new List<S_Period>();
            for(integer i=1;i<13;i++){
                S_Period pp = new S_Period();
                pp.PID = 'P-'+i;
                pp.Type ='Month';
                pp.startDate = pstartDate;
                pp.endDate = pstartDate.addMonths(1).addDays(-1);
                pp.MPNumber = i;
                pp.PeriodLabel = mapMonthString.get(i);
                lstP.add(pp);
                pstartDate = pstartDate.addMonths(1);
            }
        
        

     
        
        sfiscal.Name = cyear;
        sfiscal.startDate = date.parse(org.FiscalYearStartMonth+'/1/'+cyear);
        sfiscal.endDate = sfiscal.startDate.addyears(1).addDays(-1);
        sfiscal.PeriodPrefix = 'P';
        sfiscal.PeriodLabelScheme = 'StandardMonths';
        sfiscal.Periods = lstP;
    }
    }
    public  map<String,Fiscal_Year_Planning__c>  mapFiscalYear;
      
    public  List<Planning_Version__c> createFiscalPeriods(S_FiscalYearSettings fiscal){
            
        Integer fyear = (fiscal.EndDate).Year();
        List<Planning_Version__c> lstPeriods = new List<Planning_Version__c>();  
        
        Integer count = fiscal.startDate.Month();
        Integer seq = 1;
        if((fiscal.PeriodLabelScheme).equals('Custom')){
            for(S_Period p : fiscal.periods){           
                if((p.Type).equals('Month')) {   
                    lstPeriods.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = (mapFiscalYear.ContainsKey(fyear+''))?mapFiscalYear.get(fyear+'').Id:null,
                            Is_this_a_Budget_Planning_Version__c     = false,
                            SequenceNo__c = seq++,
                            Data_Entry_Closed_Date__c= p.EndDate,
                            Data_Entry_Start_Date__c  = p.StartDate,
                            Version_Status__c= 'Not Open',
                            Planning_Version_Fiscal_Year__c = fyear+'',
                            Planning_Version_Current_Period__c= (count++)+'',
                            MonthName__c = p.PeriodLabel,
                            Record_Source__c = 'Installation'
                        )); 
                        if(count == 13)count =1;
                } 
            }
        }
        else{
            for(S_Period p : fiscal.periods){           
                if((p.Type).equals('Month')) {   
                    lstPeriods.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = (mapFiscalYear.ContainsKey(fyear+''))?mapFiscalYear.get(fyear+'').Id:null,
                            Is_this_a_Budget_Planning_Version__c     = false,
                            SequenceNo__c =  seq++,
                            Data_Entry_Closed_Date__c= p.EndDate,
                            Data_Entry_Start_Date__c  = p.StartDate,
                            Version_Status__c= 'Not Open',
                            Planning_Version_Fiscal_Year__c = fyear+'',
                            Planning_Version_Current_Period__c= p.MPNumber+'',
                            Record_Source__c = 'Installation'
                        )); 
                } 
            }
        }
        return lstPeriods;
    }
    
    public class wrapperQuarter{
        Integer QId;
        Date StartDate;
        Date EndDate;
        public wrapperQuarter(Integer QId,Date StartDate,Date EndDate){
            this.QId = QId;
            this.StartDate = StartDate;
            this.EndDate = EndDate;
        }
        
    }
    
    public  Integer getQuarterId(List<wrapperQuarter> lstQuarterWrapper,Date mStartDate,Date mEndDate){
        for(wrapperQuarter w : lstQuarterWrapper){
            if(w.StartDate <= mStartDate && w.EndDate >= mEndDate){
                return w.QId;
            }
        }
        return 1;
    }
    public  List<Fiscal_Year_Model__c> createCustomFiscalPeriods(S_FiscalYearSettings fiscal){
            
            
        List<wrapperQuarter> lstQuarterWrapper = new List<wrapperQuarter>();
        map<Id,Integer> mapSeqNumber = new map<Id,Integer>();
        Integer seq = 1;
        for(S_Period p : fiscal.periods){
            if((p.Type).equals('Quarter')){
                lstQuarterWrapper.add(new wrapperQuarter(p.MPNumber,p.StartDate,p.EndDate));
            }
            if((p.Type).equals('Month')){
                mapSeqNumber.put(p.PId,seq++);
            }
            
            
        }
        
        Integer fyear = (fiscal.EndDate).Year();
        List<Fiscal_Year_Model__c> lstPeriods = new List<Fiscal_Year_Model__c>();  
        
        Integer count = fiscal.startDate.Month();
        
        if((fiscal.PeriodLabelScheme).equals('Custom')){
            
            for(S_Period p : fiscal.periods){
                
                       
                if((p.Type).equals('Month')) {   
                    lstPeriods.add(
                        new Fiscal_Year_Model__c(
                            Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.PID),
                            Fiscal_Period_Id__c = p.PId,
                            End_Date__c = p.EndDate,
                            Start_Date__c  = p.StartDate,
                            Fiscal_Year__c = fyear+'',
                            Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),
                            Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:(count++)+'',
                            Period_Number__c =  mapSeqNumber.get(p.Pid),
                            Record_Source__c = 'Installation'
                        )); 
                        if(count == 13)count =1;
                } 
            }
        }
        else{

            for(s_Period p : fiscal.periods){
          
                if((p.Type).equals('Month')) {   
                    lstPeriods.add(
                        new Fiscal_Year_Model__c(
                            Name = 'FY'+fyear+'P'+mapSeqNumber.get(p.PID),
                            Fiscal_Period_Id__c = p.PId,
                            End_Date__c = p.EndDate,
                            Start_Date__c  = p.StartDate,
                            Fiscal_Year__c = fyear+'',
                            Fiscal_Quarter__c = 'Q'+getQuarterId(lstQuarterWrapper,p.StartDate,p.EndDate),
                            Period_Name__c= (p.PeriodLabel <> null)?p.PeriodLabel:p.MPNumber+'',
                            Period_Number__c =  mapSeqNumber.get(p.Pid),
                            Record_Source__c = 'Installation'
                        )); 
                } 
            }
        }
        return lstPeriods;
    }


        public  DefaultSettingResponse putFiscalYearCustom(){
    
        List<S_FiscalYearSettings> lstfiscalsetting = new List<S_FiscalYearSettings>();
        lstfiscalsetting.add(sfiscal);
        
        map<String,Fiscal_Year_Model__c> mapFY = new map<String,Fiscal_Year_Model__c>();

		if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible()
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isAccessible() 
		&& Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible()){
         
        for(Fiscal_Year_Model__c FY : [select Id, Name,Fiscal_Period_Id__c,End_Date__c,Start_Date__c ,Fiscal_Year__c,Fiscal_Quarter__c,Period_Name__c,Period_Number__c from Fiscal_Year_Model__c where Name <> null]){
            mapFY.put(FY.Name,FY);
        }

		}
             
        List<Fiscal_Year_Model__c>  lstFiscalYear = new List<Fiscal_Year_Model__c>();
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Fiscal_Year_Model__c p: createCustomFiscalPeriods(fiscal)){
                if(mapFY.ContainsKey(p.Name)){
                    p = mapFY.get(p.Name);
                }
                else{
                    if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                        if((p.Period_Name__c).isNumeric() && mapMonthString.containsKey(Integer.valueOf(p.Period_Name__c)))
                        MonthName  = mapMonthString.get(Integer.valueOf(p.Period_Name__c));                            
                    }
                    else if((fiscal.PeriodLabelScheme).equals('Custom')){
                       MonthName  = p.Period_Name__c;
                       
                    }
                    else{
                       MonthName  = Prefix+'-'+p.Period_Name__c;                      
                    }                    
                    p.Period_Name__c  = MonthName;
                }
                lstFiscalYear.add(p);
            }
        }        
        if(lstFiscalYear.size()>0){
            try{
                if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isCreateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Record_Source__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isUpdateable() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Period_Id__c.isUpdateable()){
	                upsert lstFiscalYear; 
                }
                            
            }
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstFiscalYear),lstFiscalYear.size());
    }
    
    public  DefaultSettingResponse putFiscalYearPlanningVersion(){
            
        List<S_FiscalYearSettings> lstfiscalsetting = new List<S_FiscalYearSettings>();
        lstfiscalsetting.add(sfiscal);
            
        map<String,Planning_Version__c> mapFP = new map<String,Planning_Version__c>();

		if (Schema.sObjectType.Planning_Version__c.fields.id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() 
		&& Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isAccessible()  && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() 
		&& Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible()  && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() 
		&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() 
		&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()  && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isAccessible()
		&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isAccessible() ){
          
        for(Planning_Version__c plan : [select id,Name,Fiscal_Year_Planning__c,Is_this_a_Budget_Planning_Version__c ,SequenceNo__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c,Version_Status__c,
        Planning_Version_Fiscal_Year__c,Planning_Version_Current_Period__c,MonthName__c from Planning_Version__c where Name <> null and Data_Entry_Start_Date__c <> null]){
            mapFP.put(plan.Name,plan);
        }

		}
        
            
        List<Planning_Version__c>  lstPlanninerVersion = new List<Planning_Version__c>();
        List<Fiscal_Year_Planning__c>  lstFiscalYear = new List<Fiscal_Year_Planning__c>();
        
        
        map<String,Fiscal_Year_Planning__c> mapOFY = new map<String,Fiscal_Year_Planning__c>();

        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
          
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c where name <> null]){
            mapOFY.put(fy.name,fy);            
        }
        }
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            Fiscal_Year_Planning__c pv;
            if(mapOFY.containsKey(fiscal.Name))
                pv = mapOFY.get(fiscal.Name);
            else
                pv = new Fiscal_Year_Planning__c(name = fiscal.Name,StartDate__c = fiscal.startDate,EndDate__c = fiscal.EndDate,Record_Source__c = 'Installation');
            lstFiscalYear.add(pv);
        }
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable() && Fiscal_Year_Planning__c.SObjectType.getDescribe().isUpdateable()) {
        upsert lstFiscalYear;

        }
        mapFiscalYear = new map<String,Fiscal_Year_Planning__c>();

        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible()){
          
        for(Fiscal_Year_Planning__c fy:[select Id,Name from Fiscal_Year_Planning__c where name <> null]){
            mapFiscalYear.put(fy.name,fy);            
        }

        } 
        for(S_FiscalYearSettings fiscal : lstfiscalsetting ){
            
            Integer fyear = (fiscal.EndDate).Year();
            String  Prefix = fiscal.PeriodPrefix;
            String MonthName;
            for(Planning_Version__c p: createFiscalPeriods(fiscal)){
                if((fiscal.PeriodLabelScheme).equals('StandardMonths') ){
                    if(mapMonthString.containsKey(Integer.valueOf(p.Planning_Version_Current_Period__c)))
                    MonthName  = mapMonthString.get(Integer.valueOf(p.Planning_Version_Current_Period__c));                            
                }
                else if((fiscal.PeriodLabelScheme).equals('Custom')){
                   MonthName  = p.MonthName__c;
                   
                }
                else{
                   MonthName  = Prefix+'-'+p.Planning_Version_Current_Period__c;                      
                }                    
                p.MonthName__c = MonthName; 
                p.Name = p.Planning_Version_Fiscal_Year__c+'-'+MonthName;
                
                if(mapFP.containsKey(p.Name)){
                    p = mapFP.get(p.Name);
                }
                
                lstPlanninerVersion.add(p);
            }
        }
        
        if(lstPlanninerVersion.size()>0){
            try{
            	if (Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Status_Closed_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Status_Closed_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Record_Source__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Record_Source__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Gap_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Gap_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isUpdateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable() && Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable()){
	                upsert lstPlanninerVersion;  
            	}
}            
            
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstPlanninerVersion),lstPlanninerVersion.size());
    }    

    public  DefaultSettingResponse putGapPlanningVersion(){

        map<String,String> mapAPDesc = new map<String,String>();
        mapAPDesc.put('Q1 Gap','');
        mapAPDesc.put('Q2 Gap','');
        mapAPDesc.put('Q3 Gap','');
        mapAPDesc.put('Q4 Gap','');

        
        map<String,Gap_Planning_Version__c> MapOrgAP = new Map<String,Gap_Planning_Version__c>();
        if (Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isAccessible()){
          
        for(Gap_Planning_Version__c AP : [select Name,Version_Description__c from Gap_Planning_Version__c where name <> null]){
            MapOrgAP.put(AP.Name,AP);
        }
        }
        List<Gap_Planning_Version__c> lstAddPlanning = new List<Gap_Planning_Version__c>();
        for(String AP : mapAPDesc.keySet()){
            Gap_Planning_Version__c APObj;
            if(MapOrgAP.containsKey(AP)){
                APObj = MapOrgAP.get(AP);
            }
            else{
                APObj = new Gap_Planning_Version__c(
                    Name = AP,
                    Version_Description__c = mapAPDesc.get(AP),
                    Record_Source__c = 'Installation'
                );
            }
            lstAddPlanning.add(APObj);
        }
        if(lstAddPlanning.size()>0){
            try{
            	if (Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isUpdateable() && Schema.sObjectType.Gap_Planning_Version__c.fields.Version_Description__c.isCreateable() && Schema.sObjectType.Gap_Planning_Version__c.fields.Record_Source__c.isUpdateable() && Schema.sObjectType.Gap_Planning_Version__c.fields.Record_Source__c.isCreateable() && Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isUpdateable() && Schema.sObjectType.Gap_Planning_Version__c.fields.Name.isCreateable()){
	            	upsert lstAddPlanning; 
            	}
}             
            
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        
        //Remaining Additional Year
        //putRemainingAdditionalPeriods(MapOrgAP.values());
        return new DefaultSettingResponse(true,String.ValueOf(lstAddPlanning),lstAddPlanning.size());
    }
    
    public  DefaultSettingResponse putAdditionalPlanningVersion(){

        map<String,String> mapAPDesc = new map<String,String>();
        mapAPDesc.put('Budget01','');
        //mapAPDesc.put('Budget02','');
        //mapAPDesc.put('Budget03','');

        
        map<String,Additional_Planning_Versions__c> MapOrgAP = new Map<String,Additional_Planning_Versions__c>();
        if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isAccessible() && Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isAccessible() ){
         
        for(Additional_Planning_Versions__c AP : [select Name,Version_Description__c from Additional_Planning_Versions__c where name <> null]){
            MapOrgAP.put(AP.Name,AP);
        }
        }
        List<Additional_Planning_Versions__c> lstAddPlanning = new List<Additional_Planning_Versions__c>();
        for(String AP : mapAPDesc.keySet()){
            Additional_Planning_Versions__c APObj;
            if(MapOrgAP.containsKey(AP)){
                APObj = MapOrgAP.get(AP);
            }
            else{
            	if (Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isCreateable()
            	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Name.isUpdateable()
            	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isCreateable()
            	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Version_Description__c.isUpdateable()
            	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Record_Source__c.isCreateable()
            	&& Schema.sObjectType.Additional_Planning_Versions__c.fields.Record_Source__c.isUpdateable()) {
                APObj = new Additional_Planning_Versions__c(
                    Name = AP,
                    Version_Description__c = mapAPDesc.get(AP),
                    Record_Source__c = 'Installation'
                );
                }
            }
            lstAddPlanning.add(APObj);
        }
        if(lstAddPlanning.size()>0){
            try{
            	if(Additional_Planning_Versions__c.SObjectType.getDescribe().isCreateable() && Additional_Planning_Versions__c.SObjectType.getDescribe().isUpdateable()) {
            	upsert lstAddPlanning; 
            	}
}             
            
            catch(Exception e){
                return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        
        //Remaining Additional Year
        putRemainingAdditionalPeriods(MapOrgAP.values());
        return new DefaultSettingResponse(true,String.ValueOf(lstAddPlanning),lstAddPlanning.size());
    }

    
    public  void putRemainingAdditionalPeriods(List<Additional_Planning_Versions__c> lstAdditionalPlanning){
        Set<string> setExistingFiscalYear = new Set<String>();

       if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible()){
         
        for(Planning_Version__c pv : [select Planning_Version_Fiscal_Year__c from Planning_Version__c where Is_this_a_Budget_Planning_Version__c     = true]){
            setExistingFiscalYear.add(pv.Planning_Version_Fiscal_Year__c);
        }

       } 
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();

       if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isAccessible()
       && Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isAccessible()){
          
        List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where Name <> null and Name Not IN: setExistingFiscalYear order by startdate__c ];
       
       if(lstfiscalsetting.size() >0 ){ 
            Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();  
            if (Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isAccessible() ){
          
            AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c  = true Group By Planning_Version_Fiscal_Year__c];  
            for (AggregateResult ar : lstSeqNo)  {           
                mapYearMaxSeq.put(String.ValueOf(ar.get('year')),
                Integer.ValueOf(String.ValueOf(ar.get('seq'))));        
            } 
            for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){            
                Integer seq = 99; 
                if(mapYearMaxSeq.ContainsKey(fiscal.Name))  
                    seq = mapYearMaxSeq.get(fiscal.Name);  
                for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){     
                	if (Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Name.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Additional_Planning_Version__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isCreateable()
            	&& Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Description__c.isUpdateable()) {           
                    lstPlanningversion.add(   
                        new Planning_Version__c(   
                            Fiscal_Year_Planning__c = fiscal.Id, 
                            Name = fiscal.Name+'-'+ap.Name,  
                            Additional_Planning_Version__c = ap.Id,                        
                            Is_this_a_Budget_Planning_Version__c     = true, 
                            SequenceNo__c = ++seq, 
                            Data_Entry_Closed_Date__c= fiscal.EndDate__c,                      
                            Data_Entry_Start_Date__c  = fiscal.StartDate__c,
                            Version_Status__c= 'Not Open',  
                            Planning_Version_Fiscal_Year__c = fiscal.Name,    
                            Planning_Version_Current_Period__c= '',  
                            MonthName__c =ap.Name,
                            Planning_Version_Description__c = ap.Version_Description__c     
                        ) 
                    ); 
            	}
                }

            }
       } 
        }

    }
        
        if(lstPlanningversion.size()>0){
        	if(Planning_Version__c.SObjectType.getDescribe().isCreateable() && Planning_Version__c.SObjectType.getDescribe().isUpdateable()) {
            upsert lstPlanningversion;
        	}
        }
    }
    
    public  DefaultSettingResponse putFinancialMeasure(){

        map<String,String> mapFMDesc = new map<String,String>();
        mapFMDesc.put('Revenue','Revenue recognized');
        mapFMDesc.put('Revenue Adjustment','Adjustment to Revenue recognized');
        mapFMDesc.put('Revenue Backlog','Revenue Backlog calculated');
        mapFMDesc.put('Sales Booking','Sales Booking recognized');
        mapFMDesc.put('Gap Mitgation','Gap Mitgation Booking recognized');
        
        map<String,String> mapFMType = new map<String,String>();
        mapFMType.put('Revenue','Income');
        mapFMType.put('Revenue Adjustment','Income');
        mapFMType.put('Revenue Backlog','KPI');
        mapFMType.put('Sales Booking','KPI');
        mapFMType.put('Gap Mitgation','KPI');
        
        
        map<String,Planning_Financial_Measure__c> MapOrgFM = new Map<String,Planning_Financial_Measure__c>();
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible() &&  Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isAccessible()
        && Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Type__c.isAccessible()){
         
       
        for(Planning_Financial_Measure__c FM : [select Name,Measure_Description__c,Measure_Type__c  from Planning_Financial_Measure__c where name <> null]){
            MapOrgFM.put(FM.Name,FM);
        }
         }
        List<Planning_Financial_Measure__c> lstFinancialMeasure = new List<Planning_Financial_Measure__c>();
        for(String FM : mapFMDesc.keySet()){
            Planning_Financial_Measure__c FMObj;
            if(MapOrgFM.containsKey(FM)){
                FMObj = MapOrgFM.get(FM);
            }
            else{  
                Boolean AutoCalculated = false;
                if(FM == 'Revenue Backlog') 
                    AutoCalculated = true;  
                    if (Schema.sObjectType.Planning_Version__c.fields.Name.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isUpdateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Automatically_Calculated__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Measure_Description__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Record_Source__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Unit_of_Measure__c.isUpdateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isCreateable()
            	&& Schema.sObjectType.Planning_Financial_Measure__c.fields.Restricted_by_Revenue_Term__c.isUpdateable()) {
                FMObj = new Planning_Financial_Measure__c(   
                    Name = FM,           
                    Automatically_Calculated__c= AutoCalculated ,
                    Measure_Description__c = mapFMDesc.get(FM),   
                    Measure_Type__c = mapFMType.get(FM),   
                    Record_Source__c = 'Installation',
                    Unit_of_Measure__c = 'Currency',  
                    Restricted_by_Revenue_Term__c = !AutoCalculated );  
            	}
            }
            lstFinancialMeasure.add(FMObj);
        }

        if(lstFinancialMeasure.size()>0){
            try{
            	if(Planning_Financial_Measure__c.SObjectType.getDescribe().isCreateable() && Planning_Financial_Measure__c.SObjectType.getDescribe().isUpdateable()) {
	            	upsert lstFinancialMeasure;  
            	}
                          
            }
            catch(Exception e){ // system.debug('#error:'+e);
            	 return new DefaultSettingResponse(false,String.ValueOf(e.getMessage()),0);
            }
        }
        return new DefaultSettingResponse(true,String.ValueOf(lstFinancialMeasure),lstFinancialMeasure.size());
    }
    
    
}