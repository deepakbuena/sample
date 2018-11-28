/**
@Name            : TestcalculateSPEndDate 
@Author          : MONIKA CONAM
@Date            : Jan 23 2017
@Description     : Test class for 'CalculateSPEndDate' Trigger
**/
@isTest(seeAllData=true)
private class TestcalculateSPEndDate 
{   

    static final boolean softFail = false; //if true tests will fail softly - that is they will not be marked as failed but may not contribute full code coverage
    
    static testmethod void calculateSPEndDate() {
    Test.startTest();  

        try{
        
            Account acc=new Account(Name='College Planning Services');
            insert acc; 
            Account accRecord = [Select Id,Name from Account where Name = 'College Planning Services'];
            System.assertEquals('College Planning Services',accRecord.name);
            
            Account acc2=new Account(Name='College Planning Services 1');
            insert acc2;  
            
            Contact con=new Contact(LastName='Doe',Ambassador_Account__c=acc.id,FirstName = 'John',AccountId = acc.Id);
            insert con;
            
            Contact conRecord = [Select Id,Ambassador_Account__r.Name from Contact where Ambassador_Account__r.Name = 'College Planning Services'];
            System.assertEquals('College Planning Services',conRecord.Ambassador_Account__r.Name);
            
            Contact con2=new Contact(LastName='Doe2',Ambassador_Account__c=acc.id,FirstName = 'First Name',AccountId = acc.Id);
            insert con2;  
            
            Opportunity opp = new Opportunity(Name = 'Opp 2016', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.newInstance(System.today().year(), 5, 10), StageName = 'Prospecting');
            insert opp; 
            
            Opportunity opp2 = new Opportunity(Name = 'Opp 2017', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.newInstance(System.today().year(), 5, 10), StageName = 'Prospecting');
            insert opp2;
            
            Contract cont = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
            insert cont;
            
            Contract_Lines__c conLines = new Contract_Lines__c();
            conLines.Contract__c = cont.Id;
            conLines.Total_number_invoices__c = 3;
            conLines.Invoice_Count__c = 2;
            conLines.Unit_Price__c = 50;
            conLines.Invoice_Freq__c = 3;
            insert conLines;
            
            Contract cont2 = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
            insert cont2;
            
            Contract_Lines__c conLines2 = new Contract_Lines__c();
            conLines2.Contract__c = cont2.Id;
            conLines2.Total_number_invoices__c = 3;
            conLines2.Invoice_Count__c = 2;
            conLines2.Unit_Price__c = 50;
            conLines2.Invoice_Freq__c = 12;
            //conLines2.Next_Invoice_Date__c = Date.today().addDays(12);
            insert conLines2;
            
            Contract cont3 = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
            insert cont3;
            
            Contract_Lines__c conLines3 = new Contract_Lines__c();
            conLines3.Contract__c = cont3.Id;
            conLines3.Total_number_invoices__c = 3;
            conLines3.Invoice_Count__c = 2;
            conLines3.Unit_Price__c = 50;
            conLines3.Invoice_Freq__c = 6;
            //conLines3.Next_Invoice_Date__c = Date.today().addDays(12);
            insert conLines3;
            
            Contract cont4 = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
            insert cont4;
            
            Contract_Lines__c conLines4 = new Contract_Lines__c();
            conLines4.Contract__c = cont4.Id;
            conLines4.Total_number_invoices__c = 3;
            conLines4.Invoice_Count__c = 2;
            conLines4.Unit_Price__c = 50;
            conLines4.Invoice_Freq__c = 1;
            //conLines4.Next_Invoice_Date__c = Date.today().addDays(12);
            insert conLines4;
            
            Contract cont5 = new Contract(AccountId=acc.id,Contact_Name__c=con.id,Opportunity__c=opp.id);
            insert cont5;
            
            Contract_Lines__c conLines5 = new Contract_Lines__c();
            conLines5.Contract__c = cont5.Id;
            conLines5.Total_number_invoices__c = 2;
            conLines5.Invoice_Count__c = 2;
            conLines5.Unit_Price__c = 50;
            conLines5.Invoice_Freq__c = 6;
            //conLines5.Next_Invoice_Date__c = Date.today().addDays(12);
            insert conLines5;
            
            Contract cont6 = new Contract(AccountId=acc.id,Contact_Name__c=con2.id,Opportunity__c=opp2.id);
            insert cont6;
            
            Contract_Lines__c conLines6 = new Contract_Lines__c();
            conLines6.Contract__c = cont6.Id;
            conLines6.Total_number_invoices__c = 4;
            conLines6.Invoice_Count__c = 2;
            conLines6.Unit_Price__c = 50;
            conLines6.Invoice_Freq__c = 6;
            conLines6.Next_Invoice_Date__c = Date.today().addDays(12);
            insert conLines6;
            
            Contract_Lines__c conLines7 = new Contract_Lines__c();
            conLines7.Contract__c = cont6.Id;
            conLines7.Total_number_invoices__c = 4;
            conLines7.Invoice_Count__c = 2;
            conLines7.Unit_Price__c = 50;
            conLines7.Invoice_Freq__c = 6;
            conLines7.Next_Invoice_Date__c = Date.today().addDays(10);
            insert conLines7;
            
            User u1 = [SELECT Id FROM User WHERE Name='Andrew Marley' and isActive = true LIMIT 1];
            
            System.RunAs(u1){   
                c2g__codaInvoice__c newInvoice = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont.id,c2g__InvoiceDate__c = Date.today());
                insert newInvoice;
                
                c2g__codaInvoice__c newInvoice2 = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont2.id,c2g__InvoiceDate__c = Date.today());
                insert newInvoice2;
                
                c2g__codaInvoice__c newInvoice3 = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont3.id,c2g__InvoiceDate__c = Date.today());
                insert newInvoice3;
                
                c2g__codaInvoice__c newInvoice4 = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont4.id,c2g__InvoiceDate__c = Date.today());
                insert newInvoice4;
                
                c2g__codaInvoice__c newInvoice5 = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont5.id,c2g__InvoiceDate__c = Date.today());
                insert newInvoice5;
                
                
                c2g__codaInvoice__c newInvoice6 = new c2g__codaInvoice__c(c2g__Account__c = acc.id,Contract__c=cont6.id,c2g__InvoiceDate__c = Date.today(),
                                                                        Service_Period_Start_Date__c = Date.Today(),c2g__DueDate__c = Date.today().addDays(5));
                try{
                    insert newInvoice6;
                }
                catch(Exception e){
                    System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
                }
            }          
                  
        }
        catch(Exception e){
            if(softFail){
                System.debug(LoggingLevel.Error,'Soft fail enabled. Test marked as passed but it really failed with '+e.getMessage());
            }
            else{
                throw e;
            }
        }
           
    Test.stopTest();   
    }    
}