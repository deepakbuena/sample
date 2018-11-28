@isTest

private class TestBatchCreateRolloverOppty {

    static testmethod void testBatchCreateOppty() {
        
        Test.startTest();
        
        Account acc = new Account(Name = 'Account 2016',Full_Time_Enrollment__c = 1);
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'Oppty-2016',Rollover__c = true, Create_Rollover_Oppty__c = false,AccountId = acc.Id,CloseDate = System.Today(),StageName = 'Prospect',LeadSource = 'Other');
        insert opp;
        
        BatchCreateRolloverOppty batch1 = new BatchCreateRolloverOppty();
        ID batchprocessid = Database.executeBatch(batch1);
        
        Test.stopTest();
    }
}