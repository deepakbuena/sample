/*
@Name             : UpdateAccountPrimaryRiskReason
@Date             : June 04, 2015
@Created By       : GS Development Team
@Description      : This class is part of Sprint 6 and is used to populate the Primary Risk\Lost Reason and the Secondary Risk\Lost Reason
                    on Account and create the records in the Secondary Risk Lost Reason with the order in which they are selected. 
@Revision History : 
06/23/2015        : Modifed to use the At Risk Lost Reason instead of Secondary Risk\Lost Reason from Account.


*/
global class UpdateAccountPrimaryRiskReason implements Database.Batchable<sobject>, Database.stateful
{
    global integer recordCount;
    global Set<String> allCategory=new Set<String>();
    global DataBase.querylocator start(Database.BatchableContext bc) 
    {
        recordCount=0;
        return Database.getQueryLocator('SELECT ID,Why_at_Risk__c from account');
    }

    global void execute(Database.BatchableContext bc ,List<sobject> scope)
    {
        List<Secondary_Risk_Lost_Reason__c> cList =new List<Secondary_Risk_Lost_Reason__c>();
        List<Account> aList =new List<Account>();
        for(Sobject s: scope)
        {
            Account aTemp=(Account) s;
            if((aTemp.Why_at_Risk__c!=null)&&(aTemp.Why_at_Risk__c!=''))
            {
                aTemp.Primary_Risk_Lost_Reason__c='';
                aTemp.secondary_risk_lost_reason__c='';     
                            
                String newS=aTemp.Why_at_Risk__c;
                System.debug('XXXXXXXXXXXX '+ aTemp.Why_at_Risk__c);
                List<String> secondTemp=new List<String>() ;
                if(newS.contains(';'))
                    secondTemp=newS.split(';');
                else
                    secondTemp.add(newS);
                
                Boolean first=true;
                integer count=0;
                String message='';
                for(String sx : secondTemp)
                {
                    System.debug(' values are '+sx);
                    Secondary_Risk_Lost_Reason__c cTemp =new Secondary_Risk_Lost_Reason__c();
                    if(first)
                    {
                        count++;
                        cTemp.name=sx;
                        cTemp.ParentId__c=aTemp.id;
                        cTemp.Sort_Order__c=count;
                        
                        aTemp.Primary_Risk_Lost_Reason__c=sx;
                        first=false;
                        
                        recordCount++;
                        allCategory.add(sx);
                    }
                    else
                    {
                        count++;
                        cTemp.name=sx;
                        cTemp.ParentId__c=aTemp.id;
                        cTemp.Sort_Order__c=count;
                        
                        message+= ';' +sx;
                        
                        allCategory.add(sx);
                        recordCount++;
                    
                    }
                    cList.add(cTemp);
                }
                aTemp.secondary_risk_lost_reason__c=message;
                aList.add(aTemp);
                
             }
             else
             {
             System.debug('Account id2 '+aTemp); 
             }
        }
        
        System.debug('An cList '+cList);
        
        try
            {
                if(aList.size()>0)
                    update aList;
                if(cList.size()>0)
                    insert cList;
            }
            catch(Exception e)
            {
                System.debug('An exception has occured '+e.getMessage()+'-'+e.getLineNumber());
            
            }
    
    }
    
    global void finish(Database.BatchableContext bc)
    {
        System.debug('Total count of records is '+recordCount);
        System.debug('Total name of records is '+allCategory);
        for(String s : allCategory)
            System.debug('Ivalue '+s);
    }
    

}