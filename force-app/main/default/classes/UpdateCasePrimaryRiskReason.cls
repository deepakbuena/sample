global class UpdateCasePrimaryRiskReason implements Database.Batchable<sobject>
{

    global DataBase.querylocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select id, BARRIER_TO_IMPLEMENTATION__C ,BARRIER__C from case where BARRIER_TO_IMPLEMENTATION__C!=\'\' order by id');
    }

    global void execute(Database.BatchableContext bc ,List<sobject> scope)
    {
        List< Case_Barrier__c> cList =new List< Case_Barrier__c>();
        List<Case> aList =new List<case>();
        for(Sobject s: scope)
        {
            Case aTemp=(Case) s;
            System.debug('Account id '+aTemp);    
            String newS=aTemp.BARRIER_TO_IMPLEMENTATION__C;
            Boolean first=true;
            integer count=1;

            Case_Barrier__c cTemp =new Case_Barrier__c();
            cTemp.name=newS;
            cTemp.case__c=aTemp.id;
            cTemp.Sort_Order_No__c=count;
                    
            cList.add(cTemp);
        
        }
        
        System.debug('An cList '+cList);
        
        try
            {
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
    
    }
    

}