@isTest
public class TestUpdateListPriceFromOpportunity {
    public testmethod static void TestUpdateListPriceFromOpportunityTest(){
        Test.startTest();
        
        Account acc = new Account(Name = 'Test Acc',Full_Time_Enrollment__c = 20);
        insert acc;
        
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' AND Name='Strategic Partnership'];
        
        Opportunity o = new Opportunity (Name='Opp1 2014',Type = 'Credit Union',StageName='Prospect',CloseDate=Date.today(),RecordTypeId = rt.Id,List_Price__c = 25000,AccountId = acc.Id);
        insert o;
        
        Id pricebookId = Test.getStandardPricebookId();      
        Pricebook2 pb2 = new Pricebook2();       
        pb2.name = 'Credit Union';
        insert pb2; 
        
        Product2 prod = new Product2();
        prod.Name = 'Product X';
        prod.ProductCode = 'Pro-X';
        prod.isActive = true;
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(); 
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = prod.Id;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        insert pbEntry;
        
        PricebookEntry pbEntry1 = new PricebookEntry(); 
        pbEntry1.Pricebook2Id = pb2.Id;
        pbEntry1.Product2Id = prod.Id;
        pbEntry1.UnitPrice = 100.00;
        pbEntry1.IsActive = true;
        insert pbEntry1;
        
        OpportunityLineItem olt = new OpportunityLineItem();
        olt.UnitPrice = 0.1;
        olt.TotalPrice = null;
        olt.PricebookEntryId = pbEntry1.id;
        olt.OpportunityId = o.id;
        olt.Quantity = 1;        
        insert olt; 
        
        Test.stopTest();
    }
}