@isTest
public class TestBatchSendEmailForLostAsOf {
   public testmethod static void testBatchSendEmailForLostAsOfTest(){
       Test.startTest();
       RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='School'];
       Account a = new Account();
       a.Name = 'abc';
       a.RecordTypeId = rt.Id;
       a.Contract_End__c = system.today().addDays(-3);
       insert a;
       
       String cronExp = '0 0 0 15 3 ? 2022';
       BatchSendEmailForLostAsOf bsce = new BatchSendEmailForLostAsOf();
       ID batchprocessid = Database.executeBatch(bsce);
       System.schedule('test Schedule', cronExp,new BatchSendEmailForLostAsOf());
       Test.stopTest();
           
   }
   public testmethod static void testClearLostAsOfTrg(){
   
       Account a = new Account();
       a.Name = 'Test acc';
       a.Contract_End__c = system.today().addDays(-3);
       insert a;
       
       a.Contract_End__c = system.today().addDays(5);
       update a;
   }
   
}