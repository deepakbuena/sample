@isTest
public class TestBatchAccountAnniversarySendEmail {
    public testmethod static void TestBatchAccountAnniversarySendEmailTest(){
        Test.startTest();
        Account a = new Account();     
        a.name='College Planning Services';        
        insert a;
        Contact ct = new Contact(LastName = 'Test Con',AccountId = a.Id, Title = 'Test',FirstName = 'FirstName');
        insert ct;
        Opportunity o = new Opportunity();
        o.StageName = 'Closed - Won';
        o.CloseDate = System.today();
        o.Name = 'abc 2015';        
        o.AccountId = a.id;
        insert o; 
        Contract contr = new Contract();
        contr.name = 'abc';
        contr.Status = 'Agreement Executed';
        contr.StartDate = System.today().addYears(-2).addMonths(1).addDays(1);
        contr.EndDate = System.today().addDays(30);
        contr.Contact_Name__c = ct.Id;
        contr.ContractTerm = 13;
        contr.AccountId = a.Id;
        insert contr;
        
        BatchAccountAnniversarySendEmail baas = new BatchAccountAnniversarySendEmail();
        ID batchprocessid = Database.executeBatch(baas);
        System.schedule('test Schedule', '0 0 0 15 3 ? 2022',new BatchAccountAnniversarySendEmail());
        Test.stopTest();
    }
}