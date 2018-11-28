public with sharing class CPSQRCodeReader
{
    public String failureMsg{get;private set;}
    public PageReference redirectToQRLink()
    {
        PageReference eventCheckIn;
        
        if(ApexPages.currentPage().getParameters().containsKey('id'))
        {
            Id recordID=ApexPages.currentPage().getParameters().get('id');
            String keyPrefix=Campaign.SObjectType.getDescribe().getKeyPrefix();
            if(String.valueOf(recordID).startsWith(keyPrefix))
            {
                if((ApexPages.currentPage().getParameters().containsKey('st')) && (ApexPages.currentPage().getParameters().containsKey('dt')))
                {
                    String startTimeStr=ApexPages.currentPage().getParameters().get('st');
                    String endTimeStr=ApexPages.currentPage().getParameters().get('dt');
                    
                    //generete the query to find a matching record
                    if(startTimeStr!=null && endTimeStr!=null)
                    {
                        System.debug(DateTime.newInstance(Long.valueOf(startTimeStr)));
                       // TimeZone tz = UserInfo.getTimeZone();
                      //  System.debug(DateTime.newInstance(Long.valueOf(startTimeStr)) + tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0));
                       // System.debug((DateTime.newInstance(Long.valueOf(startTimeStr)) + tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0)).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'','America/New_York'));
                        System.debug(DateTime.newInstance(Long.valueOf(startTimeStr)).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'','GMT'));
                        
                        String startTime=DateTime.newInstance(Long.valueOf(startTimeStr)).format('yyyy-MM-dd\'T\'HH:mm:ss\'z\'','GMT');
                        String endTime=DateTime.newInstance(Long.valueOf(endTimeStr)).format('yyyy-MM-dd\'T\'HH:mm:ss\'z\'','GMT');
                        
                        System.debug(startTime+'>>>>>>'+endTime);
                        String query='select id,QR_Code_Valid_FRom__c,QR_Code_Valid_Until__c from campaign where id=\''+recordID+'\' and QR_Code_Valid_From__c> ='+startTime+' and QR_Code_Valid_Until__c<='+endTime+' Limit 1';
                        System.debug(query);
                        List<Campaign> campList=Database.query(query);
                        if(campList.size()>0 && (System.now() >= campList.get(0).QR_Code_Valid_From__c && System.now() <= campList.get(0).QR_Code_Valid_Until__c))
                        {
                            Cookie campId = new Cookie('campId', recordID, null, -1, false);
                            eventCheckIn = new PageReference('/apex/Mobile_Phone_Demo1');
                            eventCheckIn.setCookies(new Cookie[] {campId});
                            eventCheckIn.setRedirect(true);
                        }
                        else
                        {
                            eventCheckIn = new PageReference('/apex/CPS_Link_expired').setRedirect(true);    
                        }                      
                    }
                    else
                    {
                        // both param needs to have value
                        eventCheckIn = new PageReference('/apex/CPS_Link_expired').setRedirect(true);
                    }
                }
                else
                {
                    system.debug('something went wrong');
                    eventCheckIn = new PageReference('/apex/CPS_Link_expired').setRedirect(true);
                }
                
            }
        }
        return eventCheckIn;
    }
}