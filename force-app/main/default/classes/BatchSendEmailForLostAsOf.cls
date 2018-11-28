global class BatchSendEmailForLostAsOf Implements Database.Batchable<sObject>,Schedulable {

    global void execute(SchedulableContext ctx) {
        BatchSendEmailForLostAsOf batch1 = new BatchSendEmailForLostAsOf();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, Name, Lost_as_of__c, Contract_End__c From Account Where Contract_End__c <= TODAY AND RecordType.Name = \'School\'';
        return Database.getQueryLocator(query);
    }
    
     global void execute(Database.BatchableContext BC, list<Account> accList) {
         
         try{
             String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
             List<Account> accToUpdate = new List<Account>();
             List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
             
             for(Account accTemp : accList){
                 if(accTemp.Contract_End__c != accTemp.Lost_as_of__c){
                     
                     accTemp.Lost_as_of__c = accTemp.Contract_End__c;
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     List<String> toAddresses = new List<String>{'rpugliares@asa.org','jdamico@asa.org'};
                     mail.setToAddresses(toAddresses);
                     String sub = accTemp.Name + ' lost as of ' + accTemp.Lost_as_of__c.format();
                     mail.setSubject(sub);
                     String body = '<a style="text-decoration: none;" href="' + sfdcBaseURL + '/' +  accTemp.Id + '">' + accTemp.Name + '</a>';
                     body += ' is lost as of ' + accTemp.Lost_as_of__c.format()+ '. The record has been updated with this date.' ;
                     mail.setHtmlBody(body);
                     mails.add(mail);  
                     
                     accToUpdate.add(accTemp); 
                 }  
             }
             Messaging.sendEmail(mails);
             if(accToUpdate.size()>0){
                 update accToUpdate;
             }
         }
         catch(Exception e){
             System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
         }
     }
     
     global void finish(Database.BatchableContext bc) {}
}