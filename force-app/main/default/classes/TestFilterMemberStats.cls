@isTest
private class TestFilterMemberStats {
    static testMethod void testFailIds(){
     
        Test.startTest();
        Failed_Insight_Data_Storage__c fids = new Failed_Insight_Data_Storage__c (Name = 'Default', Flag__c = false);
        insert fids;
        
        List<Account> acc = new List<Account>();
        Account a1 = new Account(Name = 'acc1', Customer_Code__c = 't1');
        acc.add(a1);
        Account a2 = new Account(Name = 'acc2', OE_Code__c = '0124');
        acc.add(a2);
        Account a3 = new Account(Name = 'acc3', OE_Code__c = '01245', Customer_Code__c = 't2');
        acc.add(a3);
        Account a4 = new Account(Name = 'acc4', Customer_Code__c = '#0120');
        acc.add(a4);
        insert acc;
        
        List<Insight_Data_Storage__c> idsList = new List<Insight_Data_Storage__c>();
        Insight_Data_Storage__c ids1 = new Insight_Data_Storage__c(Customer_Code__c = 't1');
        idsList.add(ids1);
        Insight_Data_Storage__c ids2 = new Insight_Data_Storage__c(OE_Code__c = '0124');
        idsList.add(ids2);
        Insight_Data_Storage__c ids3 = new Insight_Data_Storage__c(OE_Code__c = '0125');
        idsList.add(ids3);
        Insight_Data_Storage__c ids4 = new Insight_Data_Storage__c(OE_Code__c = '01245',Customer_Code__c = 't2');
        idsList.add(ids4);
        Insight_Data_Storage__c ids5 = new Insight_Data_Storage__c(Customer_Code__c = '#0125');
        idsList.add(ids5);  
        
        insert idsList;
        
        ids3.OE_Code__c = '0124';
        update ids3;
        ids5.Customer_Code__c = '#0120';
        update ids5;
       
        Test.stopTest();
    }
}