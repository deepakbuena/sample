/*
@Name                : BatchCreateCampaignAttendee
@Author              : Monika Conam
@Date                : Dec 28, 2016
@Description         : Batch class to Create AttendeeFeeback object for Campaign Object .
*/
global class BatchCreateCampaignAttendee implements Database.Batchable<sObject> { 
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select Id,Name,Primary_BD__c,BDAttending__c,Presenting__c,(Select Id,ASA_Attendee__r.Name from Campaign_Email_Surveys__r) from Campaign where Enddate > today and Recordtype.Name=\'Conference\' and (Primary_BD__c!= null OR BDAttending__c!= null OR Presenting__c!= null)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Campaign> campList){       
        try{ 
            List<Campaign_ASA_Attendees__c> newAttendee = new List<Campaign_ASA_Attendees__c>();
            Set<String> attendiesshouldexist = new Set<String>();
            Set<String> existingattendies = new Set<String>(); 
            
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
                for(Campaign_ASA_Attendees__c Camp1 : c.Campaign_Email_Surveys__r){
                    existingattendies.add(Camp1.ASA_Attendee__r.Name);
                }
                for(String str1 : attendiesshouldexist){
                    Boolean exist = false;
                    for(String str2 : existingattendies){
                        if(str2 == str1){
                            exist = true;    
                        }
                    }
                    if(!exist){
                        Campaign_ASA_Attendees__c campAttendee = new Campaign_ASA_Attendees__c();
                        campAttendee.Campaign__c = c.id;
                        if(userIdMap.containsKey(str1)){
                            campAttendee.ASA_Attendee__c = userIdMap.get(str1); 
                        }
                        if(campAttendee.ASA_Attendee__c != null){       
                            newAttendee.add(campAttendee); 
                        }  
                    }
                } 
            }
            if(newAttendee.size()>0){
                insert newAttendee;
            }
        }  
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - '  + e.getLineNumber());
        }
    }           
    
    global void finish(Database.BatchableContext BC){
    }
}