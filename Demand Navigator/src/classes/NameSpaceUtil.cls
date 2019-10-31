public with sharing class NameSpaceUtil{
    public static string getNameSpace(string objname){
        Integer indexOfToken = -1;
        String namespace = '';
        for ( Schema.SObjectType type : Schema.getGlobalDescribe().values() ) {
        String sobjName = String.valueOf(type);
        
        if (null != sobjName) {
        indexOfToken = sobjName.indexOf(objname);
        }
        
        if (indexOfToken != -1) {
        namespace = sobjName.substring(0, indexOfToken);
        break;
        }
        }
        
        return namespace;
    }
}