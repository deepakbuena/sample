@isTest(seeAllData=true)
private class TestSchedulerBatchSendReminder30{

    public static String CRON_EXP = '0 0 1 * * ?';

    static testmethod void test() {
        Test.startTest();
        
        Account acc=new Account(Name='College Planning Services');
        insert acc;
        
        Contact con=new Contact(LastName='Doe',Ambassador_Account__c=acc.id,FirstName = 'First Name',AccountId = acc.id);
        insert con;
        
        Opportunity opp = new Opportunity(Name = 'Opp 2016', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.newInstance(System.today().year(), 5, 10), StageName = 'Prospecting');
        insert opp; 
        
        Contract cont = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
        insert cont;
        
        Contract_Lines__c conLines = new Contract_Lines__c();
        conLines.Contract__c = cont.Id;
        conLines.Total_number_invoices__c = 3;
        conLines.Invoice_Count__c = 2;
        conLines.Unit_Price__c = 50;
        conLines.Invoice_Freq__c = 3;
        insert conLines;
        
        User u1 = [SELECT Id FROM User WHERE Name='Andrew Marley' and isActive = true LIMIT 1];
            
        System.RunAs(u1){   
            c2g__codaInvoice__c newInvoice = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont.id,c2g__InvoiceDate__c = Date.today().addDays(-40),c2g__DueDate__c = System.today().addDays(-30));
            insert newInvoice;
        }
        
        Database.executeBatch(new BatchSendInvoiceRemider30(), 1000);
        
        Test.stopTest();
   }
}