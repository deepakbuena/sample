@isTest

private class TestUpdateAccountPrimaryRiskReason {
 
    static testmethod void testAccountPrimaryRiskReason() {
        
        Account acc1 = new Account();
        acc1.Name = 'test Account';
        acc1.Secondary_Risk_Lost_Reason__c = 'Competition'+ ';'+'SALT Customer Service Issues' + ';' + 'SALT Product Issues'+ ';' ;
        acc1.Why_at_Risk__c = 'SALT Outcomes;Competition';
        insert acc1;
                        
        /*Account acc2 = new Account();
        acc2.Name = 'test Account2';
        acc2.Secondary_Risk_Lost_Reason__c = 'Competition';
        insert acc2;*/
        
        //List<Account> acclist = [select id,Name,Secondary_Risk_Lost_Reason__c,Primary_Risk_Lost_Reason__c from Account where id =: acc1.id OR id =: acc2.id]; 
        
            test.startTest();
            try{             
                UpdateAccountPrimaryRiskReason BatchObj1 = new UpdateAccountPrimaryRiskReason();
                ID batch_processId=Database.executebatch(BatchObj1, 2);
                system.debug('batch_processId' + batch_processId);  
                system.debug('Database.executebatch(BatchObj1, 2)' + Database.executebatch(BatchObj1, 2));  
                UpdateAccountPrimaryRiskReason m = new UpdateAccountPrimaryRiskReason ();
            }
            catch(Exception ex){}
            test.stopTest();
    
        }
    
}