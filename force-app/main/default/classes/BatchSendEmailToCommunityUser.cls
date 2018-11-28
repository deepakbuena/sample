global class BatchSendEmailToCommunityUser implements Database.Batchable<sObject>,Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'Select Id, Name, ParentId From Attachment Where CreatedDate = today';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Attachment> attList)
    {
        try
        {
            Schema.DescribeSObjectResult r = Salt_Client_Reports__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            Set<Id> attSet = new Set<Id>();
                        
            for(Attachment att : attList){
                if(String.valueOf(att.ParentId).startsWith(keyPrefix)){
                    attSet.add(att.ParentId);       
                }  
            }
            
            Map<Id,Set<String>> attNamesMap = new Map<Id,Set<String>>();
            List<Salt_Client_Reports__c> saltList = [Select Id, Account__c,(Select Name From Attachments Where CreatedDate = today) From Salt_Client_Reports__c Where Id In : attSet]; 
            
            for(Salt_Client_Reports__c saltTemp : saltList)
            {
                //Set<String> nameSet = new Set<String>();
                for(Attachment att : saltTemp.Attachments)
                {
                    //nameSet.add(att.Name);   
                    if(attNamesMap.containsKey(saltTemp.Account__c)){
                        attNamesMap.get(saltTemp.Account__c).add(att.Name);
                    }
                    else{
                        attNamesMap.put(saltTemp.Account__c,new Set<String>{att.Name});
                    }
                }
                //attNamesMap.put(saltTemp.Account__c,nameSet);
            }
              
            List<User> usrList = [Select Id,ContactId,Email From User Where Profile.Name = 'Customer Community User' AND ContactId != null AND IsActive=true];
            Map<Id,String> usrMap = new Map<Id,String>();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            if(usrList.size()>0)
            {
                for(User usrTemp : usrList)
                {
                    usrMap.put(usrTemp.ContactId,usrTemp.Email);        
                }
            }
            
            List<Contact> conList= [Select Id,AccountId,Account.Name,Account.OwnerId,Account.Owner.IsActive,Name,Email,OwnerId From Contact Where AccountId In : attNamesMap.keySet() AND Id In : usrMap.keySet()];
            system.debug('conList@@@@'+conList.size());
            Organization org = [Select IsSandbox From Organization Limit 1];
            String communityURL = '';

            communityURL =org.isSandbox ?'https://full-saltmoney.cs60.force.com/customers': 'https://saltmoney.force.com/customers'; 
            String body = '';
            OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress Where Address = 'schoolmanagement@asa.org'];
            
            // Map of contact Ids and List of all sent mails
            Map<Id,List<Messaging.SingleEmailMessage>> mapConIdSentEmail = new Map<Id,List<Messaging.SingleEmailMessage>>();
            // Map of ContactId as key and Account owner as Value
            Map<Id,Id> mapConIdAccOwnerId = new Map<Id,Id>();
            
            if(conList.size()>0)
            {
                for(Contact con : conList)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> toAddresses = new List<String>{usrMap.get(con.Id)};
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Reports have been posted');
                    mail.setOrgWideEmailAddressId(owa.id);
                                        
                    body = 'Hi ' + con.Name + ',<br/><br/>';
                    body += 'The new Salt report(s) have been posted to your account <b>' + con.Account.Name + '</b> on the Salt Admin Portal.<br/>';
                    body += '<br/><b>Portal Login URL: </b> <a href="' +  communityURL + '"> Salt Administrator Portal </a>';
                    body += '<br/><b>Report(s) Name: </b><br/>'; 
                    for(String s : attNamesMap.get(con.AccountId)){
                        body += s +'<br/>';
                    }
                    body += '<br/> Thanks,<br/>Your Salt Client Management Team';
                     
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    
                    if(mapConIdSentEmail.containsKey(con.Id))
                    {
                         mapConIdSentEmail.get(con.Id).add(mail); 
                    }
                    else
                    {
                        mapConIdSentEmail.put(con.Id, new List<Messaging.SingleEmailMessage>{mail});
                    }
                    
                        if(con.Account.Owner.IsActive)
                        {
                            mapConIdAccOwnerId.put(con.Id,con.Account.OwnerId);
                        }
                    
                }
                system.debug('mails@@@@'+mails.size());
                if(mails.size() > 0)
                {
                    Messaging.sendEmail(mails);
                    List<Task> listTask = new List<Task>();
                    
                    for(Id conId : mapConIdSentEmail.keyset())
                    {
                        for(Messaging.SingleEmailMessage mail : mapConIdSentEmail.get(conId))
                        {
                            
                            String htmlBody = String.valueOf(mail.getHtmlBody());
                            htmlBody = htmlBody.replace('<br/>','\r\n');
                            
                            //DateTime dt = system.today();
                            DateTime dt = DateTime.Now();
                            system.debug('dt @@@@'+dt);
                            //String formattedDate = dt.format('MM-dd-YYYY');
                            String formattedDate = dt.format('MM-dd-YYYY');
                            system.debug('formattedDate @@@@'+formattedDate);
                            
                            if(mapConIdAccOwnerId.containsKey(conId) && mapConIdAccOwnerId.get(conId) != Null)
                            {
                                Task newTask = new Task();
                                newTask.Subject = 'Report posted on ' + formattedDate;
                                newTask.Status = 'Completed';
                                newTask.Description = htmlBody;
                                newTask.WhoId = conId;
                                newTask.type = 'Email';
                                newTask.OwnerId = mapConIdAccOwnerId.get(conId); 
                                newTask.ActivityDate = system.today();
                                listTask.add(newTask);
                           }
                        }
                    }
                    System.debug('listTask@@@'+listTask.size());
                    if(listTask.size()>0){
                       insert listTask;
                   }
                }
            }           
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }   
    }
    
    global void execute(SchedulableContext ctx) {
        BatchSendEmailToCommunityUser batch1 = new BatchSendEmailToCommunityUser();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void finish(Database.BatchableContext bc) {}
}