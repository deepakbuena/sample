public class CampaignTriggerHandler{

    public static void materialsRecDateReminder(List<Campaign> campList, Map<Id,Campaign> campOldMap){
    
        String sender = 'Ryan Pugliares';   
        String messageBody = '<html><body>Hello,<br/><br/>';
        messageBody += 'These materials of the following Campaign do not have their Received Date populated: <br/><br/>';
        messageBody += '<b>Campaign -</b> ';
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Id campRecTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Conference').getRecordTypeId();
        
        Map<String,String> primaryBDMap = new Map<String,String>();
        Map<String,String> addCCMap = new Map<String,String>();
        Map<String,String> senderEmailMap = new Map<String,String>();
        List<String> recipientEmailMap_10Days = new List<String>();
        List<String> recipientEmailMap_20Days = new List<String>();
        
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        Boolean blankFlag = false ;
        Boolean sendEmail = false;
        
        Set<String> primaryBD = new Set<String>();
        primaryBD.add(sender);
        primaryBD.add('Ryan Pugliares');
        primaryBD.add('Jill Marr');
        primaryBD.add('Michael Friedman');
        primaryBD.add('Julie Esau');
        
        for(Campaign c : campList){
            if(c.RecordTypeId == campRecTypeId && ((campOldMap.get(c.Id).X10_Days_Date_Received_Reminder__c == false && c.X10_Days_Date_Received_Reminder__c == true) || (campOldMap.get(c.Id).X20_Days_Date_Received_Reminder__c == false && c.X20_Days_Date_Received_Reminder__c == true))){
                primaryBD.add(c.Primary_BD__c);
                sendEmail = true;
            }
        }
        
        if(sendEmail){
            for(User userList : [Select Email,name from user where name IN :primaryBD]){
                primaryBDMap.put(userList.Name,userList.Email);
                if(userList.Name == sender){
                    senderEmailMap.put(userList.Name,userList.Email);
                }
                if(userList.Name == 'Jill Marr'){
                    addCCMap.put(userList.Name,userList.Email);
                }
                       
                if(userList.Name == 'Ryan Pugliares' || userList.Name == 'Jill Marr'){
                    recipientEmailMap_10Days.add(userList.Email);
                    recipientEmailMap_20Days.add(userList.Email);
                }
                if(userList.Name == 'Michael Friedman' || userList.Name == 'Julie Esau'){
                    recipientEmailMap_20Days.add(userList.Email);
                }
            }
            
            for(Campaign c : campList){  
                
                Campaign oldCampRec = campOldMap.get(c.Id);
                if(c.RecordTypeId == campRecTypeId && ((oldCampRec.X10_Days_Date_Received_Reminder__c == false && c.X10_Days_Date_Received_Reminder__c == true)||(oldCampRec.X20_Days_Date_Received_Reminder__c == false && c.X20_Days_Date_Received_Reminder__c == true))){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
                    mail.setSenderDisplayName(sender); 
                    String[] ccAddresses = new String[] {addCCMap.get('Jill Marr')};                
                    mail.setCCAddresses(ccAddresses);
                    mail.setReplyTo(senderEmailMap.get(sender));           
                    messageBody += '<a href='+baseUrl+'/'+c.id+'>'+c.Name +'</a><br/><br/>'; 
                    messageBody += '<b>Materials are :</b><br/>' ;    
                    String subject = 'Materials do not have Date Received for Campaign - ' + c.Name;
                  
                    mail.setSubject(subject);
                    
                    if(oldCampRec.X10_Days_Date_Received_Reminder__c == false && c.X10_Days_Date_Received_Reminder__c == true){
                        if(primaryBDMap.get(c.Primary_BD__c) != null){
                            recipientEmailMap_10Days.add(primaryBDMap.get(c.Primary_BD__c));
                        }
                        mail.setToAddresses(recipientEmailMap_10Days);
                    }
        
                    if(oldCampRec.X20_Days_Date_Received_Reminder__c == false && c.X20_Days_Date_Received_Reminder__c == true){
                        if(primaryBDMap.get(c.Primary_BD__c) != null){
                            recipientEmailMap_20Days.add(primaryBDMap.get(c.Primary_BD__c));
                        }
                        mail.setToAddresses(recipientEmailMap_20Days);
                    }
                    if(c.X10X10_Booth_Received_Date__c == null){
                        messageBody += '10X10 Booth<br/>';
                        blankFlag = true ;
                    }
                    if(c.Banner_Received_Date__c == null){
                        messageBody += 'Banner <br/>';
                        blankFlag = true ;
                    }
                    if(c.Business_Card_Holder_Received_Date__c == null){
                        messageBody += 'Business Card<br/>';
                        blankFlag = true ;
                    }
                    if(c.Collateral_Holder_Received_Date__c == null){
                        messageBody += 'Collateral Holder<br/>';
                        blankFlag = true ;
                    }
                    if(c.iPad_Stand_Received_Date__c == null){
                        messageBody += 'iPad Stand<br/>';
                        blankFlag = true ;
                    }
                    if(c.Tablecloth_Received_Date__c == null){
                        messageBody += 'Tablecloth<br/>';
                        blankFlag = true ;
                    }
                    messageBody += '</body></html>';
                    mail.setHtmlBody(messageBody);
                    mails.add(mail);
                }
            } 
        }  
        if(blankFlag == true ){
            Messaging.sendEmail(mails);
        }    
    }
    
    public static void asaAttendeesTrg(List<Campaign> campList, Map<Id,Campaign> campOldMap){
    
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<Id> campId = new Set<Id>();
        Set<Id> campIdForReminder = new Set<Id>();
        Map<String,String> asaAttendees = new Map<String,String>();
        Set<String> asaAttendeesOld = new Set<String>();
        Set<String> asaAttendeesRemoved = new Set<String>();
        Set<String> asaAttendeesAdded = new Set<String>();
        Set<String> campIdsDel = new Set<String>();
        
        try{
            for(Campaign camp : campList){
                if(Trigger.isUpdate && camp.Flag__c != campOldMap.get(camp.Id).Flag__c && camp.Flag__c == true){
                    campId.add(camp.Id);
                }
                if(Trigger.isUpdate && camp.Reminder_Email_Flag__c != campOldMap.get(camp.Id).Reminder_Email_Flag__c && camp.Reminder_Email_Flag__c == true){
                    campIdForReminder.add(camp.Id);   
                }
                if(camp.Primary_BD__c != null ){
                    asaAttendees.put(camp.Primary_BD__c,camp.Id);
                }
                if(Trigger.isUpdate && campOldMap.get(camp.Id).Primary_BD__c != null){
                    asaAttendeesOld.add(campOldMap.get(camp.Id).Primary_BD__c);
                    campIdsDel.add(camp.Id);
                }
                if(camp.BDAttending__c != null){ 
                    if(camp.BDAttending__c.contains(';')){
                        List<String> bdAttndng = camp.BDAttending__c.split(';');
                        for(String s : bdAttndng){
                            asaAttendees.put(s,camp.Id);
                        }
                    } else {
                        asaAttendees.put(camp.BDAttending__c,camp.Id);
                    }
                }
                if(Trigger.isUpdate && campOldMap.get(camp.Id).BDAttending__c != null){
                    if(campOldMap.get(camp.Id).BDAttending__c.contains(';')){
                        List<String> bdAttndngold = campOldMap.get(camp.Id).BDAttending__c.split(';');
                        for(String s : bdAttndngold){
                            asaAttendeesOld.add(s);
                        }
                    } else {
                        asaAttendeesOld.add(campOldMap.get(camp.Id).BDAttending__c);
                    }
                    campIdsDel.add(camp.Id);
                }
                if(camp.Presenting__c != null){
                    if(camp.Presenting__c.contains(';')){
                        List<String> presenting = camp.Presenting__c.split(';');
                        for(String s : presenting){
                            asaAttendees.put(s,camp.Id);
                        } 
                    } else {
                        asaAttendees.put(camp.Presenting__c,camp.Id);
                    }
                }
                if(Trigger.isUpdate && campOldMap.get(camp.Id).Presenting__c != null){
                    if(campOldMap.get(camp.Id).Presenting__c.contains(';')){
                        List<String> presentingold = campOldMap.get(camp.Id).Presenting__c.split(';');
                        for(String s : presentingold){
                            asaAttendeesOld.add(s);
                        }
                    } else {
                        asaAttendeesOld.add(campOldMap.get(camp.Id).Presenting__c);
                    }
                    campIdsDel.add(camp.Id);
                }
            }
            
            for(String s : asaAttendeesOld){
                Boolean exist = false;
                for(String str : asaAttendees.keyset()){
                    if(str == s){
                        exist = true;    
                    }
                }
                if(!exist){
                    asaAttendeesRemoved.add(s);   
                }
            }
            
            for(String s : asaAttendees.keyset()){
                Boolean exist = false;
                for(String str : asaAttendeesOld){
                    if(str == s){
                        exist = true;    
                    }
                }
                if(!exist){
                    asaAttendeesAdded.add(s);   
                }
            }
                
            if(asaAttendees.keyset().size()>0 || asaAttendeesOld.size()>0){
                List<Campaign_ASA_Attendees__c> attendeeList = [Select Id,Campaign__c,ASA_Attendee__c From Campaign_ASA_Attendees__c Where ASA_Attendee__r.Name In : asaAttendees.keyset()];    
                
                Map<String,Id> userIdMap = new Map<String,Id>();
                List<User> usrList = [Select Id,Name From User Where Name In : asaAttendees.keyset()];
                for(User usrTemp : usrList){
                    userIdMap.put(usrTemp.Name,usrTemp.Id);   
                }
                
                List<Campaign_ASA_Attendees__c> newAttendee = new List<Campaign_ASA_Attendees__c>();
                            
                for(String str : asaAttendeesAdded){
                    Campaign_ASA_Attendees__c campAttendee = new Campaign_ASA_Attendees__c();
                    campAttendee.Campaign__c = asaAttendees.get(str);
                    if(userIdMap.containsKey(str)){
                        campAttendee.ASA_Attendee__c = userIdMap.get(str); 
                    }
                    if(campAttendee.ASA_Attendee__c != null){       
                        newAttendee.add(campAttendee); 
                    }  
                }  
                if(newAttendee.size()>0){
                    Database.insert(newAttendee,false);
                }
            }
                    
            if(asaAttendeesRemoved.size()>0){
                List<Campaign_ASA_Attendees__c> attendeeToRem = [Select Id,Campaign__c,ASA_Attendee__c From Campaign_ASA_Attendees__c Where Campaign__c IN :campIdsDel AND ASA_Attendee__r.Name In : asaAttendeesRemoved];
                Database.delete(attendeeToRem,false);
            }
            
            if(campId.size()>0){
                List<Campaign_ASA_Attendees__c> campAttendeesList = [Select ASA_Attendee__c,Campaign__r.Name,ASA_Attendee__r.FirstName,ASA_Attendee__r.Email,Campaign__c From Campaign_ASA_Attendees__c Where Campaign__c In : campId AND (Recommendation_for_Next_Year_s_Show__c=NULL OR Total_Cost_of_Attendance__c=NULL OR Why_did_they_attend__c=NULL)];
                if(campAttendeesList.size()>0){            
                    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                
                    for(Campaign_ASA_Attendees__c campAttendee : campAttendeesList){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(campAttendee.ASA_Attendee__r.Email);
                        mail.setToAddresses(sendTo);
                        mail.setSubject('Campaign Survey');
                        String url = sfdcBaseURL + '/apex/CampaignSurveyPage?campId=' + campAttendee.Campaign__c + '&assignedTo=' + campAttendee.ASA_Attendee__c;
                        String body = 'Hello ' + campAttendee.ASA_Attendee__r.FirstName + ', <br/><br/>' ;
                        body += 'Please provide your feedback for ' + campAttendee.Campaign__r.Name + ' by clicking on the button below: <br/><br/></br/>'; 
                        body += '<center><table cellspacing="0" cellpadding="0"><tr><td align="center" width="100"/><td align="center" width="200" height="40" bgcolor="#51a351" style="-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; color: #ffffff; display: block;"><a href="'+url;
                        body += '" style="color: #ffffff; font-size:16px; font-weight: bold; font-family: Helvetica, Arial, sans-serif; text-decoration: none; line-height:40px; width:100%; display:inline-block">Survey</a></td></tr></table></center> <br/>';
                        body += 'Thanks!';
                        
                        mail.setHtmlBody(body);
                        mails.add(mail);
                    }
                    Messaging.sendEmail(mails);
                }
            }
            if(campIdForReminder.size()>0){
                List<Campaign_ASA_Attendees__c> campAttListRem = [Select ASA_Attendee__c,Campaign__r.Name,ASA_Attendee__r.FirstName,ASA_Attendee__r.Email,ASA_Attendee__r.Manager.Email,Campaign__c From Campaign_ASA_Attendees__c Where Campaign__c In : campIdForReminder AND (Recommendation_for_Next_Year_s_Show__c=NULL OR Total_Cost_of_Attendance__c=NULL OR Why_did_they_attend__c=NULL)];
                if(campAttListRem.size()>0){            
                    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                
                    for(Campaign_ASA_Attendees__c campAttendee : campAttListRem){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(campAttendee.ASA_Attendee__r.Email);
                        List<String> ccTo = new List<String>();
                        ccTo.add(campAttendee.ASA_Attendee__r.Manager.Email);
                        mail.setccAddresses(ccTo);
                        mail.setToAddresses(sendTo);
                        mail.setSubject('Campaign Survey Reminder Notification');
                        String url = sfdcBaseURL + '/apex/CampaignSurveyPage?campId=' + campAttendee.Campaign__c + '&assignedTo=' + campAttendee.ASA_Attendee__c;
                        String body = 'Hello ' + campAttendee.ASA_Attendee__r.FirstName + ', <br/><br/>' ;
                        body += 'This is a reminder email as you have not completed the survey yet.<br/><br/>';
                        body += 'Please provide your feedback for ' + campAttendee.Campaign__r.Name + ' by clicking on the button below: <br/><br/></br/>'; 
                        body += '<center><table cellspacing="0" cellpadding="0"><tr><td align="center" width="100"/><td align="center" width="200" height="40" bgcolor="#51a351" style="-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; color: #ffffff; display: block;"><a href="'+url;
                        body += '" style="color: #ffffff; font-size:16px; font-weight: bold; font-family: Helvetica, Arial, sans-serif; text-decoration: none; line-height:40px; width:100%; display:inline-block">Survey</a></td></tr></table></center> <br/>';
                        body += 'Thanks!';
                        
                        mail.setHtmlBody(body);
                        mails.add(mail);
                    }
                    Messaging.sendEmail(mails);
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occured: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public static void attendeeFeedbackItemNotCreated(List<Campaign> campNewList, Map<Id,Campaign> campOldMap){
    
        Set<Id> campId = new Set<Id>();
        Set<String> attendiesshouldexist = new Set<String>();
        Set<String> existingattendies = new Set<String>();
        List<String> usrlst =new List<String>();      
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        for(Campaign camp : campNewList){
            if(camp.X10_Days_Date_Received_Reminder__c != campOldMap.get(camp.id).X10_Days_Date_Received_Reminder__c && camp.X10_Days_Date_Received_Reminder__c==true){
                campId.add(camp.Id);
            }       
        }
        List<Campaign> campList = [Select Id,Name,Primary_BD__c,BDAttending__c,Presenting__c,Owner.Name,(Select Id,ASA_Attendee__r.Name From Campaign_Email_Surveys__r) From Campaign Where Id In : campId AND (Primary_BD__c!=null OR BDAttending__c!=null OR Presenting__c!=null)];
        for(Campaign c: campList){
            if(c.Primary_BD__c!=null ){
                attendiesshouldexist.add(c.Primary_BD__c);
            }
            if(c.BDAttending__c!=null ){
                if(c.BDAttending__c.contains(';')){
                    List<String> BDAttending = c.BDAttending__c.split(';');
                    for(String s : BDAttending){
                        attendiesshouldexist.add(s);
                    }
                } 
                else{
                    attendiesshouldexist.add(c.BDAttending__c); 
                }
            }
            if(c.Presenting__c!=null){
                if(c.Presenting__c.contains(';')){
                    List<String> Presenting= c.Presenting__c.split(';');
                        for(String s : Presenting){
                            attendiesshouldexist.add(s);
                        }
                } 
                else{
                    attendiesshouldexist.add(c.Presenting__c);
                }
            } 
        }    
            
        Map<String,Id> userIdMap = new Map<String,Id>();
        List<User> usrList = [Select Id,Name From User Where Name In : attendiesshouldexist];
        for(User usrTemp : usrList){
            userIdMap.put(usrTemp.Name,usrTemp.Id);   
        }
        List<User> usrnewlist = [Select Id,Email From User Where (Name ='Michael Friedman' OR Name ='Julie Esau')] ;  
        for(User usrTemp1 : usrnewlist){
            usrlst.add(usrTemp1.Email);   
        }
             
        for(Campaign c: campList){ 
            attendiesshouldexist = new Set<String>();
            existingattendies = new Set<String>();    
            if(c.Primary_BD__c!=null ){
                attendiesshouldexist.add(c.Primary_BD__c);
            }
            if(c.BDAttending__c!=null ){
                if(c.BDAttending__c.contains(';')){
                    List<String> BDAttending = c.BDAttending__c.split(';');
                    for(String s : BDAttending){
                        attendiesshouldexist.add(s);
                    }
                } 
                else{
                    attendiesshouldexist.add(c.BDAttending__c); 
                }
            }
            if(c.Presenting__c!=null){
               if(c.Presenting__c.contains(';')){
                   List<String> Presenting= c.Presenting__c.split(';');
                   for(String s : Presenting){
                       attendiesshouldexist.add(s);
                   }
                } 
                else{
                    attendiesshouldexist.add(c.Presenting__c);
                }
            }   
            for(Campaign_ASA_Attendees__c CampEmail : c.Campaign_Email_Surveys__r){
                existingattendies.add(CampEmail.ASA_Attendee__r.Name);
            }
            for(String str1 : attendiesshouldexist){
                Boolean exist = false;
                for(String str2 : existingattendies){
                    if(str2 == str1){
                        exist = true;    
                    }
                }
                if(!exist){                
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                    mail.setToAddresses(usrlst);
                    mail.setSubject('Attendee Feedback items not completed');                
                    String body = 'Campaign feedback for'+' '+ c.Name + ', ';
                    body += 'owned by'+' '+ c.owner.name + ' has not been completed.<br/><br/>';
                    body += 'Link : <a href='+sfdcBaseURL +'/'+c.id+'>'+c.Name +'</a><br/><br/>'; 
                    body += 'Thanks!';
                    
                    mail.setHtmlBody(body);
                    mails.add(mail);
               }
            } 
        }
        Messaging.sendEmail(mails);
    }
}