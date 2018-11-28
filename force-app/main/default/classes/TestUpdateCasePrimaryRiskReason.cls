@isTest

private class TestUpdateCasePrimaryRiskReason {
 
    static testmethod void testUpdateCasePrimaryRiskReason() {
    
        String query = 'select id, BARRIER_TO_IMPLEMENTATION__C ,BARRIER__C from case where BARRIER_TO_IMPLEMENTATION__C!=\'\' AND Id =:cs.id' ;
        Account acc = new Account();
        acc.Name = ' College Planning Services';
        insert acc;
        
        Contact ct = new Contact();
        ct.AccountId = acc.Id;
        ct.LastName = 'test Name';
        ct.title = 'test';
        ct.FirstName = 'First Name';
        insert ct;
        
        Case cs = new Case();
        cs.ContactId = ct.id;
        cs.Origin = 'Email';
        cs.Status = 'WIP';
        cs.Type = 'Implementation';
        cs.Barrier__c = 'Connect Date Set'+ ';'+'Demographic File' + ';' + 'Lack Of Campus Support'+ ';' ;
        cs.BARRIER_TO_IMPLEMENTATION__C = 'Connect Date Set';
        insert cs;
        
        Case_Barrier__c csbar = new Case_Barrier__c();
        csbar.Case__c = cs.Id;
        insert csbar;
        test.startTest();
        
        try{             
                UpdateCasePrimaryRiskReason BatchObj1 = new UpdateCasePrimaryRiskReason();
                ID batch_processId=Database.executebatch(BatchObj1, 2);
                system.debug('batch_processId' + batch_processId);  
                system.debug('Database.executebatch(BatchObj1, 2)' + Database.executebatch(BatchObj1, 2));  
                UpdateCasePrimaryRiskReason m = new UpdateCasePrimaryRiskReason ();
            }
            catch(Exception e){
                System.assert( e.getMessage().contains('An exception has occured '+e.getMessage()+'-'+e.getLineNumber()), e.getMessage() );
            }
            test.stopTest();
        
    }
}