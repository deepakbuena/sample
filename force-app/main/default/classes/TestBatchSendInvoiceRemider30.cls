@istest(seeAllData=true)
private class TestBatchSendInvoiceRemider30
{
    static c2g__codaCompany__c company;
    
    static testMethod void unitTest()
    {
        Test.startTest();
        
        try
        {   
            User usr = [Select Id,Name From User Where Name = 'Andrew Marley' And Profile.Name = 'System Administrator' LIMIT 1];
            
            System.runAs(usr){
                company = [SELECT ID FROM c2g__codaCompany__c LIMIT 1];
                System.debug('====System.Today().addDays(-30);'+System.now().addDays(-30).format('yyyy-MM-dd'));
              
                Account acc=new Account();
                acc.Name='College Planning Services';    
                insert acc;
                
                Contact cUser1=new Contact();
                cUser1.firstName='Mark';
                cUser1.LastName='Bannings';
                cUser1.accountID=acc.id;
                cUser1.Title='Mr.';
                insert cUser1;
                
                Contact cUser2=new Contact();
                cUser2.firstName='Tony';
                cUser2.LastName='Stark';
                cUser2.accountID=acc.id;
                cUser2.Title='Mr.';
                insert cUser2;
                
                Contact cUser3=new Contact();
                cUser3.firstName='Captain';
                cUser3.LastName='America';
                cUser3.accountID=acc.id;
                cUser3.Title='Mr.';
                insert cUser3;
                
                
                acc.c2g__CODAInvoiceEmail__c='tonystark@shield.com';
                acc.Invoice_Email_2__c='captainamerica@shield.com';
                acc.Invoice_Email_3__c='hulk@shield.com';
                acc.c2g__CODAFinanceContact__c=cUser1.id;
                acc.Finance_Contact_2__c=cUser2.id;
                acc.Finance_Contact_3__c=cUser3.id;
                
                update acc;
                
                Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',isActive = true);
                insert prod;
            
                Id pricebookId = Test.getStandardPricebookId();
            
                PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                
                c2g__codaInvoice__c slInv= new c2g__codaInvoice__c();
                slInv.c2g__InvoiceDate__c=System.Today().addDays(-32);
                slInv.c2g__DueDate__c=System.today().addDays(-30);
                slInv.c2g__OwnerCompany__c = company.id;
                slInv.c2g__Account__c=acc.id;
                insert slInv;
                
                c2g__codaInvoiceLineItem__c sItem=new c2g__codaInvoiceLineItem__c();
                siTem.c2g__Product__c=prod.id;
                sItem.c2g__Invoice__c=slInv.id;
                sItem.c2g__UnitPrice__c=500;
                sItem.c2g__Quantity__c=1;
                
                insert sItem;
                
                System.debug('XXXXXXXXXXXXXXXXXX'+slInv.id+' '+slInv.c2g__DueDate__c);
                
                DataBase.executeBatch(new BatchSendInvoiceRemider30(),200);
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage()+'-'+e.getLineNumber());
        }
        Test.stopTest();
    }
}