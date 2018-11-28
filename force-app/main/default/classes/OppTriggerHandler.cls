public class OppTriggerHandler{

    public static void noActivityOnOppReminderTrg(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
    
        EmailTemplate template60Days = [Select Id,Body,Subject from EmailTemplate where name = 'Stalled Opportunity - 60 Day Notice'];
        EmailTemplate template90Days = [Select Id,Body,Subject from EmailTemplate where name = 'Stalled Opportunity - 90 Day Notice'];  
          
        List<Messaging.SingleEmailMessage> mails60Days = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> mails90Days = new List<Messaging.SingleEmailMessage>();
        
        Set<Id> oppOwnerId = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        Map<Id,User> usrEmailMap = new Map<Id,User>();
        Map<Id,User> usrEmailMap2 = new Map<Id,User>();
        Map<Id,Account> accNameMap = new Map<Id,Account>();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        ID foundationRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Foundation').getRecordTypeId();
        ID strtgcPartnershipRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Strategic Partnership').getRecordTypeId();
        for(Opportunity opp : oppList){
            if((opp.X60_days_No_Activity_Reminder__c != oppMap.get(opp.Id).X60_days_No_Activity_Reminder__c && opp.X60_days_No_Activity_Reminder__c == true) || (opp.X90_days_No_Activity_Reminder__c != oppMap.get(opp.Id).X90_days_No_Activity_Reminder__c && opp.X90_days_No_Activity_Reminder__c == true)){
                oppOwnerId.add(opp.OwnerId);
                accId.add(opp.AccountId);
            }
        }
        
        for(User usr : [Select Id,Name,Email From User Where Id In : oppOwnerId]){
            usrEmailMap.put(usr.Id,usr);    
            usrEmailMap2.put(usr.Id,usr);    
        }
        for(User usr : [Select Id,Name,Email From User Where Name In ('Julie Esau','Michael Friedman')]){
            usrEmailMap2.put(usr.Id,usr);    
        }
        for(Account acc : [Select Id,Name,Contract_End__c From Account Where Id In : accId]){
            accNameMap.put(acc.Id, acc);
        }
    
        for(Opportunity opp : oppList){
            if(opp.RecordTypeId != foundationRecType && opp.RecordTypeId != strtgcPartnershipRecType && opp.StageName != 'Contract/Amendment' && opp.StageName !='Closed - Won' && opp.StageName != 'Closed - Lost' && opp.StageName != 'Contract Expired/Terminated' && opp.StageName != 'Implementation' && opp.StageName != 'In Production' && ((opp.X60_days_No_Activity_Reminder__c != oppMap.get(opp.Id).X60_days_No_Activity_Reminder__c && opp.X60_days_No_Activity_Reminder__c == true) || (opp.X90_days_No_Activity_Reminder__c != oppMap.get(opp.Id).X90_days_No_Activity_Reminder__c && opp.X90_days_No_Activity_Reminder__c == true))){                        
                         
                if(opp.X60_days_No_Activity_Reminder__c == true && opp.X90_days_No_Activity_Reminder__c == false){
                                    
                    String temp = template60Days.Body;
                    temp = temp.replace('Hello,','Hello,<br/><br/>');
                    temp = temp.replace('{!Opportunity.Account}','<a href='+baseUrl+'/'+opp.AccountId+'>'+accNameMap.get(opp.AccountId).Name +'</a>');
                    temp = temp.replace('{!Opportunity.Link}',baseUrl+'/'+opp.Id);  
                    temp = temp.replace('{!Opportunity.of_days_stalled__c}',String.ValueOf(opp.of_days_stalled__c));
                    
                    String tempSubject = template60Days.Subject;
                    tempSubject = tempSubject.replace('{!Opportunity.Name}',opp.Name);
                    
                    List<String> toAddresses = new List<String>{usrEmailMap.get(opp.OwnerId).Email};
                    Messaging.SingleEmailMessage mail60DaysRem = new Messaging.SingleEmailMessage();
                    mail60DaysRem.setSubject(tempSubject);
                    mail60DaysRem.setHtmlBody(temp);
                    mail60DaysRem.setTargetObjectId(opp.OwnerId); 
                    mail60DaysRem.setToAddresses(toAddresses);
                    mail60DaysRem.setSaveAsActivity(false);
                    mails60Days.add(mail60DaysRem);
                }
                
                if(opp.X90_days_No_Activity_Reminder__c == true){
                    
                    String temp = template90Days.Body;
                    temp = temp.replace('Hello,','Hello,<br/><br/>');
                    temp = temp.replace('days ago.','days ago.<br/><br/>');
                    temp = temp.replace('{!Opportunity.Account}','<a href='+baseUrl+'/'+opp.AccountId+'>'+accNameMap.get(opp.AccountId).Name +'</a>');
                    temp = temp.replace('{!Opportunity.Link}',baseUrl+'/'+opp.Id);  
                    temp = temp.replace('{!Opportunity.of_days_stalled__c}',String.ValueOf(opp.of_days_stalled__c));
                    temp = temp.replace('{!Opportunity.OwnerFullName}',usrEmailMap.get(opp.OwnerId).Name + '<br/><br/>');
                    temp = temp.replace('renewal opportunity:','renewal opportunity:<br/><br/>');
                    
                    String tempSubject = template90Days.Subject;
                    tempSubject = tempSubject.replace('{!Opportunity.Name}',opp.Name);
                    
                    if(accNameMap.get(opp.AccountId).Contract_End__c != null){
                        temp = temp.replace('{!Account.Contract_End__c}',' '+ String.ValueOf(accNameMap.get(opp.AccountId).Contract_End__c));
                    } else{
                        temp = temp.replace('{!Account.Contract_End__c}',''); 
                    }
                
                    List<String> toAddresses = new List<String>{usrEmailMap2.get(opp.OwnerId).Email};
                    Messaging.SingleEmailMessage mail90DaysRem = new Messaging.SingleEmailMessage();
                    mail90DaysRem.setSubject(tempSubject);
                    mail90DaysRem.setHtmlBody(temp);
                    mail90DaysRem.setTargetObjectId(opp.OwnerId); 
                    mail90DaysRem.setToAddresses(toAddresses);
                    mail90DaysRem.setSaveAsActivity(false);
                    mails90Days.add(mail90DaysRem);
                }
            }
        }
        Messaging.sendEmail(mails60Days);
        Messaging.sendEmail(mails90Days);
    }
    
    public static void updateFullTimeEnrollmentOnOpp(List<Opportunity> oppList){
    
        Set<Id> accId = new Set<Id>();
        
        for(Opportunity opp : oppList){
            if(opp.AccountId != null){ 
                accId.add(opp.AccountId);
            }
        }
        if(accId.size()>0){
            Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Full_Time_Enrollment__c From Account Where Id In:accId]);
             
            for(Opportunity opp : oppList){
                opp.Full_time_enrollment__c = accMap.get(opp.AccountId).Full_Time_Enrollment__c;
            }
        }
    }
    
    public static void updateEnrollmentActual(List<Opportunity> oppListNew, Map<Id,Opportunity> oppOldMap){
    
        Map<String,Decimal> mapTotEnrollment = new Map<String,Decimal>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Period p = [Select StartDate,EndDate From Period Where type = 'Year' and StartDate = THIS_FISCAL_YEAR];
        List<Annual_Sales_Plan__c> annualList = [Select CreatedDate,Start_Date__c,End_Date__c,Name,OwnerId,Enrollment_Actual__c From Annual_Sales_Plan__c];
        
        try{
            for(Opportunity opp : oppListNew){
                if((opp.StageName == 'Closed - Won' || opp.StageName == 'Implementation' || opp.StageName == 'In Production') && (trigger.isInsert || (trigger.isUpdate && (opp.OwnerId != oppOldMap.get(opp.Id).OwnerId || opp.StageName != oppOldMap.get(opp.Id).StageName || opp.CloseDate != oppOldMap.get(opp.Id).CloseDate || opp.Total_in_Enrollment__c != oppOldMap.get(opp.Id).Total_in_Enrollment__c)))){
                    for(Annual_Sales_Plan__c aspTemp : annualList){
                        if(aspTemp.OwnerId == opp.OwnerId && opp.CloseDate >= aspTemp.Start_Date__c && opp.CloseDate <= aspTemp.End_Date__c){
                            if(!mapTotEnrollment.containsKey(String.valueOf(opp.OwnerId)+String.valueOf(aspTemp.Id))){
                                mapTotEnrollment.put(String.valueOf(opp.OwnerId)+String.valueOf(aspTemp.Id),0); 
                            }
                            if(opp.Total_in_Enrollment__c!=null){
                                mapTotEnrollment.put(String.valueOf(opp.OwnerId)+String.valueOf(aspTemp.Id),mapTotEnrollment.get(String.valueOf(opp.OwnerId)+String.valueOf(aspTemp.Id))+opp.Total_in_Enrollment__c);
                            }
                            ownerIds.add(opp.OwnerId);
                            oppIds.add(opp.Id);
                        }
                    }
                }
            }
            
            if(mapTotEnrollment.keySet().size()>0){
                List<Annual_Sales_Plan__c> aspList = [Select CreatedDate,Start_Date__c,End_Date__c,Name,OwnerId,Enrollment_Actual__c From Annual_Sales_Plan__c Where OwnerId In : ownerIds];
                    
                if(aspList.size()>0){
                    
                    List<Opportunity> oppList = [Select OwnerId,CloseDate,Total_in_Enrollment__c From Opportunity Where (StageName = 'Closed - Won' OR StageName = 'In Production' OR StageName = 'Implementation') AND OwnerId In : ownerIds AND Id Not In : oppIds];
            
                    for(Opportunity oppTemp : oppList){
                        for(Annual_Sales_Plan__c aspTemp : aspList){
                            if(aspTemp.OwnerId == oppTemp.OwnerId && oppTemp.CloseDate >= aspTemp.Start_Date__c && oppTemp.CloseDate <= aspTemp.End_Date__c){
                                if(!mapTotEnrollment.containsKey(String.valueOf(oppTemp.OwnerId)+String.valueOf(aspTemp.Id))){
                                    mapTotEnrollment.put(String.valueOf(oppTemp.OwnerId)+String.valueOf(aspTemp.Id),0); 
                                }
                                if(oppTemp.Total_in_Enrollment__c!=null){
                                    mapTotEnrollment.put(String.valueOf(oppTemp.OwnerId)+String.valueOf(aspTemp.Id),mapTotEnrollment.get(String.valueOf(oppTemp.OwnerId)+String.valueOf(aspTemp.Id))+oppTemp.Total_in_Enrollment__c);
                                }
                            }
                        }
                    }
                    List<Annual_Sales_Plan__c> newASPList = new List<Annual_Sales_Plan__c>();
                    for(Annual_Sales_Plan__c aspTemp : aspList){
                        if(aspTemp.CreatedDate >= aspTemp.Start_Date__c && aspTemp.CreatedDate <= aspTemp.End_Date__c){
                            if(mapTotEnrollment.containsKey(String.valueOf(aspTemp.OwnerId)+String.valueOf(aspTemp.Id))){
                                aspTemp.Enrollment_Actual__c =  mapTotEnrollment.get(String.valueOf(aspTemp.OwnerId)+String.valueOf(aspTemp.Id));
                                newASPList.add(aspTemp);
                            }
                        }
                    }
                    Database.update(newASPList,false);
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }       
    }
    
    public static void updateProprietary(List<Opportunity> oppListNew){
    
        try{
            Set<Id> accIds = new Set<Id>();
            Map<Id,Id> accMap = new Map<Id,Id>();
                        
            for(Opportunity newOpp : oppListNew){
                if(newOpp.AccountId != null){
                    accIds.add(newOpp.AccountId);
                }    
            }
            if(accIds.size()>0){
                List<Account> accList = [Select Id, Type From Account Where Id IN :accIds];
    
                for(Account accTemp : accList){
                    if(accTemp.Type == 'School  - Proprietary'){
                        accMap.put(accTemp.Id,accTemp.Id);
                    }
                }
                for(Opportunity opp : oppListNew){
                    if(accMap.containsKey(opp.AccountId)){
                        opp.Proprietary__c = True;
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('An Exception has occured -' + e.getMessage() + '-' + e.getLineNumber());
        }
    }
            
    public static void productExistValidation(List<Opportunity> oppListNew, Map<Id,Opportunity> oppMapOld){
        
        Set<Id> oppIds = new Set<Id>();
        Map<Id,Opportunity> oppLineItemsList = new Map<Id,Opportunity>();
        String recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();
        try{
            for(Opportunity newOpp : oppListNew){
                if(newOpp.StageName != oppMapOld.get(newOpp.Id).StageName && newOpp.RecordTypeId == recTypeId && (newOpp.StageName == 'Proposal' || 
                    newOpp.StageName == 'Contract' || newOpp.StageName == 'Implementation' || newOpp.StageName == 'In Production' || 
                    newOpp.StageName == 'Verbal Committment' || newOpp.StageName == 'Closed - Won')){
                    oppIds.add(newOpp.Id);
                }
                if(newOpp.StageName == 'Closed - Lost'){
                    newOpp.Loss_Stage__c = oppMapOld.get(newOpp.Id).StageName;
                }
            }
            if(oppIds.size() > 0){
                List<Opportunity> oppList = [SELECT Id, Name, StageName ,
                                                    (SELECT 
                                                        Id, PricebookEntry.Product2.Id 
                                                    FROM 
                                                        OpportunityLineItems) 
                                            FROM 
                                                Opportunity WHERE Id In: oppIds];
                
                for(Opportunity oppLineItmTemp : oppList){
                    oppLineItemsList.put(oppLineItmTemp.Id , oppLineItmTemp);
                } 
                for(Opportunity oppTemp : oppListNew){
                   if(oppLineItemsList.get(oppTemp.Id).OpportunityLineItems.size() == 0){
                       oppTemp.addError('If Stage is Proposal or higher then at least one product must exist');
                   }
                } 
            }
        }
        catch(Exception e){
            System.debug('An Exception has occured -' + e.getMessage() + '-' + e.getLineNumber());
        }
    }
    
    public static void rollOverOppty(List<Opportunity> oppListNew, Map<Id,Opportunity> oppMapOld){
    
        Set<Id> caseCreateId = new Set<Id>();
        List<Opportunity> rolloverOppty = new List<Opportunity>();
        List<Opportunity> renewalOppty = new List<Opportunity>();
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();

        for(Opportunity o : oppListNew){

            //Create Implementation Case: Record Type = Business Development AND Stage = Implementation BUT NOT Renewal = true
            if(oppMapOld.get(o.Id).StageName != 'Implementation' && o.StageName == 'Implementation' && o.RecordTypeId == recTypeId && o.Renewal_Opp__c == false ){
                caseCreateid.add(o.id);
            }

            if(oppMapOld.get(o.Id).Create_Rollover_Oppty__c == false && o.Create_Rollover_Oppty__c == true && o.Renewal_Opp__c == false){
                Opportunity oppClone = o.clone();
                oppClone.Unique_Opp__c = '';
                rolloverOppty.add(oppClone);
                o.StageName = 'Closed - Lost';
                o.Primary_Loss_Reason__c = 'Rolled Over to Next FY';
                o.Loss__c = true;
                o.ByPassRolloverWFRules__c=True; 
            }
        }

        //Create Implementation Case
        if(caseCreateId.size() > 0 && OpportunityTriggerHandler.runOnce_createImpCase == false){
            OpportunityTriggerHandler.createImpCase(caseCreateId);
        }

        //Create Rollover Opportunity
        if(rolloverOppty.size() > 0 && OpportunityTriggerHandler.runOnce_rolloverOpportunity == false){
            OpportunityTriggerHandler.rolloverOpportunity(rolloverOppty);
        }
    }
    
    public static void showEnrollmentFromRecentOpp(List<Opportunity> oppListNew, Map<Id,Opportunity> oppMapOld){
    
        try{
            Set<Id> oppIds = new Set<Id>();
            for(Opportunity opp : oppListNew){
                if(opp.Total_in_Enrollment__c != null && (Trigger.isInsert || (Trigger.isUpdate && (opp.Total_in_Enrollment__c != oppMapOld.get(opp.Id).Total_in_Enrollment__c)))){
                    oppIds.add(opp.Id);        
                }
            }
            if(oppIds.size()>0){
                Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId(); 
                List<Account> accList = [Select Id,Total_Enrollment_from_Recent_Oppty__c,(Select Id,Total_in_Enrollment__c From Opportunities Where Id In : oppIds Order By CreatedDate Desc) From Account Where RecordTypeId =: accRecType];
                List<Account> accUpdateList = new List<Account>();
                
                for(Account acc : accList){
                    if(acc.Opportunities.size()>0){
                        acc.Total_Enrollment_from_Recent_Oppty__c = acc.Opportunities.get(0).Total_in_Enrollment__c;
                        accUpdateList.add(acc);
                    }
                }
                if(accUpdateList.size()>0){
                    Database.update(accUpdateList,false);
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
}