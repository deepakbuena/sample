public class TabInteractiveReports
{
    @AuraEnabled
    public static Boolean getAccessToInteractiveReportsTab()
    {
        Boolean returnValue=true;
        Map<String,Boolean> accessMap=new Map<String,Boolean>();
        
        List<Profile> currentPrf=[Select id,name from profile where id=:UserInfo.getProfileId()];
        
        for(Interactive_Tab__c onTabTemp : [Select name, Enabled__c from Interactive_Tab__c])
        {
            accessMap.put(onTabTemp.name,onTabTemp.Enabled__c);
        }
        System.debug(accessMap);
        System.debug(currentPrf.get(0).name);
        
        if(accessMap.get(currentPrf.get(0).name)!=null)
        {
            returnValue=accessMap.get(currentPrf.get(0).name);
            System.debug(accessMap.get(currentPrf.get(0).name));
        }
        return returnValue;
    }
 
    public Boolean showError{get; private set;}
    
}