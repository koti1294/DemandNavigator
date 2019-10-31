public with sharing class RoleHierarchyUtility{
    public static Integer RoleDepth=0;
    public static map<Id,UserRole> getORGRoles(){
    	return new map<Id,UserRole>([select Id,ParentRoleId,Name from UserRole where Name <> null LIMIT 100]);
    	
    }
    public static map<Id,Set<Id>> getChilds(map<Id,UserRole> mapRole){
        map<Id,set<Id>> mapChild = new map<Id,set<Id>>();
        for(UserRole r : mapRole.values()){
            mapChild.put(r.Id,new Set<Id>());
        }
        for(UserRole r : mapRole.values()){            
            if(mapChild.containsKey(r.ParentRoleId)){
                Set<Id> setIds = new Set<Id>();
                setIds.add(r.Id);
                setIds.addAll(mapChild.get(r.ParentRoleId));
                mapChild.put(r.ParentRoleId,setIds );
            }            
        }
        return mapChild;
    }
    public static map<Id,Set<Id>> getParents(map<Id,UserRole> mapRole){
        
        map<Id,set<Id>> mapParent = new map<Id,set<Id>>();
        for(UserRole r : mapRole.values()){
            if(r.ParentRoleId == null )mapParent.put(r.Id,new Set<Id>());
        }
        for(UserRole r : mapRole.values()){
           if(mapParent.containsKey(r.ParentRoleId)){
                 Set<Id> setIds = new Set<Id>();
                 setIds.add(r.Id);
                 setIds.addAll(mapParent.get(r.ParentRoleId));
                 mapParent.put(r.ParentRoleId,setIds );
            }
                
            
        }
        return mapParent;
    }
    public static map<string,boolean> getIsChild(Id rid, map<Id,UserRole> mapRole,map<Id,Set<Id>> mapChilds,map<string,boolean> mapIsChild){        
        mapIsChild.put(rid,true);
        if(mapRole.containsKey(rid) && mapRole.get(rid).ParentRoleId <> null){
            getIsChild(mapRole.get(rid).ParentRoleId,mapRole,mapChilds,mapIsChild);
        }
        return mapIsChild;
    }
    public static void getDepth(map<Id,UserRole> mapRole,map<Id,Set<Id>> mapChilds,set<Id> Childs,string prefix){
        
        Integer count = 1;
        for(Id cId : Childs){
            Integer d = (prefix+''+count).length();
            if(d > RoleDepth){
                RoleDepth = d;
            }
            if(mapChilds.containsKey(cId) && mapChilds.get(cId).size()>0){               
                getDepth(mapRole,mapChilds,mapChilds.get(cId),prefix+''+count);
            }
            count++;
        }
    }
    public static string getRoles2(Id pcId,map<Id,UserRole> mapRole,map<Id,Set<Id>> mapChilds,string strRole, set<Id> Childs,string prefix,map<string,List<TableValue>> mapOwner,map<string,boolean> mapIsChild,map<string,Integer> mapRecordCount,map<string,string> mapRecordTotal,String userAgent){
        
        Integer count = 1;
        if(mapIsChild.get(pcId))strRole += '<ul>';
        if(mapOwner.containsKey(pcId) && mapOwner.get(pcId).size() > 0){
            strRole += '<li>';
            
                Integer mleft = 45;
                
                if (userAgent <> null && userAgent.contains('Mobile'))mleft  = 30;
                
        
        
                integer ml = ((RoleDepth - (prefix.length())) * mleft  );
                integer tw = 945;
                strRole += '<table style="margin-left: '+ml+'px;width:'+tw+'px;" >';
                    List<TableValue> tlist = mapOwner.get(pcId);
                    tlist.sort();
                    integer Rcount = 1;
                    string AccountOwner = '';
                    for(TableValue t : tlist){
                        AccountOwner = t.AccountOwner;
                        if(Rcount == 1){
                            strRole += '<tr><td colspan="7" style="height:15px;"></td></tr>';
                            strRole += '<tr style="border-bottom: 1px solid black;">';                            
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:130px;">Owner</td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:150px;">Account</td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:left;width:250px;">Opportunity </td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:110px;">Revenue Start Date</td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:90px;">Contract value</td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:95px;">Contract Term</td>';
                                strRole += '<td colspan="1" style="font-weight:bold;text-align:right;width:100px;">Backlog Amount</td>';
                            strRole += '</tr>';
                            strRole += '<tr><td colspan="7"></td></tr>';
                        }
                        strRole += '<tr>';                            
                            strRole += '<td style="width:130px;">'+t.AccountOwner+'</td>';
                            strRole += '<td style="width:150px;">'+t.AccName+'</td>';
                            strRole += '<td style="width:250px;color:'+t.oppColor+'"><b>'+t.OppName+'</b></td>';
                            strRole += '<td style="width:110px;text-align:right;">'+t.S_Rdateopp+'</td>';
                            strRole += '<td style="width:90px;text-align:right;">'+t.S_Contractvalue+'</td>';
                            strRole += '<td style="width:95px;text-align:right;">'+t.ContractTerm+'</td>';
                            strRole += '<td style="width:100px;text-align:right;">'+t.s_ClosingTotal+'</td>';
                        strRole += '</tr>';
                        if(mapRecordCount.get(t.AccountOwnerId) == Rcount){
                            Rcount = 0;
                            strRole += '<tr style="border-top: 1px solid black;">';                            
                                strRole += '<td colspan="4"></td>';
                                strRole += '<td colspan="2" style="font-weight:bold;text-align:right">'+AccountOwner+' Total</td>';
                                strRole += '<td colspan="1" style="width:80px;font-weight:bold;text-align:right">'+mapRecordTotal.get(t.AccountOwnerId)+'</td>';
                            strRole += '</tr>';
                            strRole += '<tr><td colspan="7"></td></tr>';
                        }
                        Rcount++;
                        
                    }
                    
                strRole += '</table>';
            strRole += '</li>';
        }
        if(mapIsChild.get(pcId))
        {
            for(Id cId : Childs){
                string s = '';
                //if(mapChilds.containsKey(cId) && mapChilds.get(cId).size() == 0)strRole += '<li><span><i class="icon-leaf"></i>'+mapRole.get(cId).Name+'</span></li>';            
                if(mapIsChild.get(cid)){  
                    strRole += '<li><span><i class="icon-minus-sign"></i>'+mapRole.get(cId).Name+'</span>';
                    s += getRoles2(cId,mapRole,mapChilds,s,mapChilds.get(cId),prefix+''+count ,mapOwner,mapIsChild,mapRecordCount,mapRecordTotal,userAgent);
                    s += '</li>';
                }
                count++;
                strRole += s;
            }
        }
        if(mapIsChild.get(pcId))strRole += '</ul>';
        return strRole;
    }
}