trigger LiveDateChangedTrg on Case (after update) {
    
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    Set<Id> accIds = new Set<Id>();
    Set<Id> ownerIds = new Set<Id>();
    Map<Id,String> accNamesMap = new Map<Id,String>();
    Map<Id,String> ownerNamesMap = new Map<Id,String>();
    
    for(Case caseTemp : Trigger.new){
        if(caseTemp.AccountId != null){
            accIds.add(caseTemp.AccountId); 
            ownerIds.add(caseTemp.OwnerId);  
        }
    }
    if(accIds.size()>0){
        List<Account> accList = [Select Id,Name From Account Where Id In : accIds];
        List<User> usrList = [Select Id,Name From User Where Id In : ownerIds];
        for(Account acc : accList){
            accNamesMap.put(acc.Id,acc.Name);    
        }
        for(User usr : usrList){
            ownerNamesMap.put(usr.Id,usr.Name);    
        }
    }
    
    for(Case caseTemp : Trigger.new){
    
        if(caseTemp.Actual_Go_Live_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c || caseTemp.Actual_Alumni_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c || caseTemp.Actual_Enrolled_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>{'dgibbons@asa.org','jdamico@asa.org'};
            mail.setToAddresses(toAddresses);
            String subject = accNamesMap.get(caseTemp.AccountId) + ' - Live Date Changed' ;
            mail.setSubject(subject);
            String body = 'The Live Date has been changed for the Case linked to the <b>Account:</b> ' + '<b>' + accNamesMap.get(caseTemp.AccountId) + '</b>' + ' for the field/fields <br/><br/>';
            
            if(caseTemp.Actual_Go_Live_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c && Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c != null && caseTemp.Actual_Go_Live_Date__c != null){
                body += '<b>Go-Live Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c.format() + ' <b>To</b> ' + caseTemp.Actual_Go_Live_Date__c.format() + '<br/>';
            }else if(caseTemp.Actual_Go_Live_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c && Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c == null){
                body += '<b>Go-Live Date: From</b> blank value <b>To</b> ' +  caseTemp.Actual_Go_Live_Date__c.format() + '<br/>';  
            }else if(caseTemp.Actual_Go_Live_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c && caseTemp.Actual_Go_Live_Date__c == null){
                body += '<b>Go-Live Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Go_Live_Date__c.format() + ' <b>To</b> blank value <br/>';
            }
            if(caseTemp.Actual_Alumni_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c  && Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c != null && caseTemp.Actual_Alumni_SALT_Connect_Date__c != null){
                body += '<b>(Alumni) SALT Connect Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c.format()  + ' <b>To</b> ' + caseTemp.Actual_Alumni_SALT_Connect_Date__c.format() + '<br/>';
            }else if(caseTemp.Actual_Alumni_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c  && Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c == null){
                body += '<b>(Alumni) SALT Connect Date: From</b> blank value <b>To</b> ' +  caseTemp.Actual_Alumni_SALT_Connect_Date__c.format() + '<br/>';  
            }else if(caseTemp.Actual_Alumni_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c && caseTemp.Actual_Alumni_SALT_Connect_Date__c == null){
                body += '<b>(Alumni) SALT Connect Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Alumni_SALT_Connect_Date__c.format() + ' <b>To</b> blank value <br/>';
            }
            if(caseTemp.Actual_Enrolled_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c && Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c != null && caseTemp.Actual_Enrolled_SALT_Connect_Date__c != null){
                body += '<b>(Enrolled) SALT Connect Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c.format()  + ' <b>To</b> ' + caseTemp.Actual_Enrolled_SALT_Connect_Date__c.format() + '<br/>';
            }else if(caseTemp.Actual_Enrolled_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c && Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c == null){
                body += '<b>(Enrolled) SALT Connect Date: From</b> blank value <b>To</b> ' +  caseTemp.Actual_Enrolled_SALT_Connect_Date__c.format() + '<br/>' ;  
            }else if(caseTemp.Actual_Enrolled_SALT_Connect_Date__c != Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c && caseTemp.Actual_Enrolled_SALT_Connect_Date__c == null){
                body += '<b>(Enrolled) SALT Connect Date: From</b> ' + Trigger.oldMap.get(caseTemp.Id).Actual_Enrolled_SALT_Connect_Date__c.format() + ' <b>To</b> blank value <br/>';
            }
            
            body += '<b>Case Owner:</b> ' + ownerNamesMap.get(caseTemp.OwnerId) + '<br/>';
            body += '<b>Case Link:</b> ' + sfdcBaseURL + '/'+ caseTemp.Id + '<br/>';
            body += '<b>Customer Code:</b> ' + caseTemp.Customer_Code__c + '<br/><br/>';
            body += 'Thanks';
            
            mail.setHtmlBody(body);
            mails.add(mail);    
        }
    }
    Messaging.sendEmail(mails);  
}