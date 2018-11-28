@isTest
public class TestLiveDateChangedTrg {
    public testmethod Static void TestLiveDateChangedTrgTest(){
        Test.startTest();
        account a = new Account();
        a.Name = 'abc';
        insert a;   
        Case c = new Case();
        c.Status = 'new';
        c.Origin = 'phone';
        c.Actual_Go_Live_Date__c = System.today().addDays(-3);
        c.Actual_Alumni_SALT_Connect_Date__c = System.today().addDays(-2);
        c.Actual_Enrolled_SALT_Connect_Date__c = System.today();
        c.AccountId = a.id;
        insert c;         
        c.Actual_Go_Live_Date__c = System.today().addDays(-6);
        c.Actual_Alumni_SALT_Connect_Date__c = System.today().addDays(-3);
        c.Actual_Enrolled_SALT_Connect_Date__c = System.today().addDays(-4);
        c.Actual_Go_Live_Date__c = null;
        c.Actual_Alumni_SALT_Connect_Date__c = null;
        c.Actual_Enrolled_SALT_Connect_Date__c = null;         
        update c;
        Test.stopTest();
    }
}