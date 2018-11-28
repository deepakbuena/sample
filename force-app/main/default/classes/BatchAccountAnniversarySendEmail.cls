global class BatchAccountAnniversarySendEmail Implements Database.Batchable<sObject>,Schedulable {

    global void execute(SchedulableContext ctx) {
        BatchAccountAnniversarySendEmail batch1 = new BatchAccountAnniversarySendEmail();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select AccountId, Account.Name, EndDate, ContractNumber, StartDate From Contract Where EndDate >= Today';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Contract> conList) {
         
        try{
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List<Contract> conListNew = new List<Contract>();
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            Set<Id> accIds = new Set<Id>();
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
             
            for(Contract con : conList){
                accIds.add(con.AccountId);        
            }
             
            if(accIds.size()>0){
                List<Account> accList = [Select Id, Name,(Select Id,name From Opportunities Where StageName = 'Implementation' OR StageName = 'In Production' OR StageName = 'Closed - Won' ORDER BY LastModifiedDate DESC LIMIT 1) From Account Where Id In : accIds];
                for(Account acc : accList){
                    if(acc.Opportunities.size()>0){
                        oppMap.put(acc.Id, acc.Opportunities.get(0)); 
                    }   
                }
            }
            
            String log = '';
            log = log + '<br />';
            log = log + '<table style="border: 1px solid black;">';
            
            log = log + '<tr style="border: 1px solid black;">';
            log = log + '<td style="border: 1px solid black;">';
            log = log + '<b>Contract Number</b>';
            log = log + '</td>';
            
            log = log + '<td style="border: 1px solid black;">';
            log = log + '<b>Account</b>';
            log = log + '</td>';
            
            log = log + '<td style="border: 1px solid black;">';
            log = log + '<b>Contract Start Date</b>';
            log = log + '</td>';
               
            log = log + '<td style="border: 1px solid black;">';
            log = log + '<b>Contract End Date</b>';
            log = log + '</td>';
                    
            log = log + '<td style="border: 1px solid black;">';
            log = log + '<b>Recent Won Opportunity</b>';
            log = log + '</td>';
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            for(Contract con : conList){
                String noOfYears = String.valueOf(con.StartDate.monthsBetween(con.EndDate) / 12);
                Integer months = Integer.valueOf(Date.Today().Month()) + 1;
                
                String dateToday = String.valueOf(Date.Today()).substring(5,10);
                String startDate = String.valueOf(con.StartDate.addMonths(-1).addDays(-1)).substring(5,10);
                
                if(Integer.valueOf(noOfYears) >= 1 && con.StartDate.Month() == months && dateToday == startDate){
                    
                    List<String> toAddresses = new List<String>{'jdamico@asa.org'};
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Account(s) approaching anniversary !');
                    
                    log = log + '<tr style="border: 1px solid black;">';
            
                    log = log + '<td style="border: 1px solid black;">';
                    log = log + '<a style="text-decoration: none;" href="'+ sfdcBaseURL + '/' +  con.Id + '">' + con.ContractNumber + '</a>';
                    log = log + '</td>';
                    
                    log = log + '<td style="border: 1px solid black;">';
                    log = log + '<a style="text-decoration: none;" href="'+ sfdcBaseURL + '/' +  con.AccountId + '">' + con.Account.Name + '</a>';
                    log = log + '</td>';
                    
                    log = log + '<td style="border: 1px solid black;">';
                    log = log + con.StartDate.format();
                    log = log + '</td>';
                    
                    log = log + '<td style="border: 1px solid black;">';
                    log = log + con.EndDate.format();
                    log = log + '</td>';
                    
                    log = log + '<td style="border: 1px solid black;">';
                    log = log + '<a style="text-decoration: none;" href="' + sfdcBaseURL + '/' +  oppMap.get(con.AccountId).Id + '">' + oppMap.get(con.AccountId).Name + '</a>';
                    log = log + '</td>';
                        
                    log = log + '</tr>';
                }
            }
            log = log + '</table>'; 
            mail.setHtmlBody('Please look at the following Account(s) approaching Anniversary:\r\n\r\n' + log);
            mails.add(mail);
            
            Messaging.sendEmail(mails);    
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
     
    global void finish(Database.BatchableContext bc) {}
}