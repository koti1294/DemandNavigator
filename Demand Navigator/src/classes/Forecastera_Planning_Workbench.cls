global with sharing class Forecastera_Planning_Workbench{
    private string cUserName;public string getcUserName(){return cUserName;}public void setcUserName(string s){if(s<>null) cUserName = String.escapeSingleQuotes(s);}
    private string cUserRole;public string getcUserRole(){return cUserRole;}public void setcUserRole(string s){if(s<>null) cUserRole = String.escapeSingleQuotes(s);}
    private string SFDCInstance;public string getSFDCInstance(){return SFDCInstance;}public void setSFDCInstance(string s){if(s<>null) SFDCInstance = String.escapeSingleQuotes(s);}
    private string securityToken;public string getsecurityToken(){return securityToken;}public void setsecurityToken(string s){if(s<>null) securityToken = String.escapeSingleQuotes(s);}
    
    global Forecastera_Planning_Workbench(){
        securityToken = encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId())));
         if (Schema.sObjectType.user.fields.Id.isAccessible() && Schema.sObjectType.user.fields.Name.isAccessible() && Schema.sObjectType.Userrole.fields.Name.isAccessible()){
            User u = [select Id,Name,Userrole.Name from user where Id =: userinfo.getUserId() LIMIT 1];
            cUserName = u.Name;
            cUserRole = u.UserRole.Name;
    }
        SFDCInstance = System.URL.getSalesforceBaseUrl().getHost();
    }

   
    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
}