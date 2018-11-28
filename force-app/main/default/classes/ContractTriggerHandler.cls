public without sharing class ContractTriggerHandler {

    public static boolean runOnce_createRenewalOpportunity = false;
    
    public static void createRenewalOpportunity(List<Contract> listOfContracts){

        List<Opportunity> newOppty = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> mailingList = new List<Messaging.SingleEmailMessage>();
        Map<Contract,Opportunity> ctrctNewOppty = new Map<Contract,Opportunity>();

        List<Contract> ctrctDetails = [SELECT EndDate,
                                        Opportunity__r.OwnerId,
                                        Opportunity__r.Owner.Name,
                                        Opportunity__r.Owner.isActive,
                                        Opportunity__r.Owner.Email,
                                        Opportunity__r.Owner.ManagerId,
                                        Opportunity__r.Owner.Manager.isActive,
                                        Opportunity__r.Owner.Manager.Email,
                                        Opportunity__r.AccountId,
                                        Opportunity__r.Account.OwnerId,
                                        Opportunity__r.Account.Owner.isActive,
                                        Opportunity__r.Account.Owner.Email,
                                        Opportunity__r.Account.Name,
                                        Opportunity__r.Account.Owner.ManagerId,
                                        Opportunity__r.Account.Owner.Manager.isActive,
                                        Opportunity__r.Account.Owner.Manager.Email,
                                        Opportunity__r.RecordTypeId
                                    FROM Contract
                                    WHERE Id IN :listOfContracts];
        
        try{
            for(Contract ctrct : ctrctDetails){
                Opportunity renewalOppty = new Opportunity();
                String nextFY;
    
                if(ctrct.EndDate < Date.newInstance(ctrct.EndDate.year(),7,1)){
                    //This FY
                    nextFY = ctrct.EndDate.year().format().remove(',');
                } else{
                    //Next FY
                    nextFY = ctrct.EndDate.addYears(1).year().format().remove(',');
                }
                renewalOppty.Name = ctrct.Opportunity__r.Account.Name + ' - Renewal - FY' + nextFY;
                renewalOppty.CloseDate = ctrct.EndDate;
                renewalOppty.RecordTypeId = ctrct.Opportunity__r.RecordTypeId;
                renewalOppty.Renewal_Opp__c = true;
                renewalOppty.StageName = 'Prospect';
                renewalOppty.LeadSource = 'Contract Renewal';
                renewalOppty.AccountId = ctrct.Opportunity__r.AccountId;
    
                if(ctrct.Opportunity__r.Account.Owner.isActive){
                    renewalOppty.OwnerId = ctrct.Opportunity__r.Account.OwnerId;
                } else{
                    if(ctrct.Opportunity__r.Account.Owner.Manager.isActive && ctrct.Opportunity__r.Account.Owner.Manager != null){
                        renewalOppty.OwnerId = ctrct.Opportunity__r.Account.Owner.ManagerId;
                    }
                }
                newOppty.add(renewalOppty);
                ctrctNewOppty.put(ctrct,renewalOppty);
            }
            if(newOppty.size()>0){
                Database.insert(newOppty,false);
            }
            for(Contract ctrct : ctrctNewOppty.KeySet()){
    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> toAddress = new List<String>();
                List<String> ccAddress = new List<String>();            
                if(ctrct.Opportunity__r.Account.Owner.isActive){ 
                    toAddress.add(ctrct.Opportunity__r.Account.Owner.Email); 
                } 
                else{
                    if(ctrct.Opportunity__r.Account.Owner.Manager != null){
                        toAddress.add(ctrct.Opportunity__r.Account.Owner.Manager.Email); 
                    } else{
                        toAddress.add(ctrct.Opportunity__r.Account.Owner.Email);
                    }
                }
                if(ctrct.Opportunity__r.Account.Owner.isActive && ctrct.Opportunity__r.Account.Owner.Manager != null){ 
                    ccAddress.add(ctrct.Opportunity__r.Account.Owner.Manager.Email); 
                }
                mail.setToAddresses(toAddress);
                mail.setCCAddresses(ccAddress); //CC BD Manager and Acount Owner
                mail.setSenderDisplayName('DO NOT REPLY');
                mail.setSaveAsActivity(false);
                mail.setSubject(ctrct.Opportunity__r.Account.Name + ' has had a renewal opportunity created.');
                
                String emailBody = ctrct.Opportunity__r.Account.Name + ' has had a renewal opportunity created. \n\n'  
                + 'Opportunity Link: ' + URL.getSalesforceBaseUrl().toExternalForm().replace('http://','https://') + '/' + ctrctNewOppty.get(ctrct).Id + '\n\n';
                
                if(ctrct.Opportunity__r.Account.Owner.isActive){
                    emailBody += 'Please update the Opportunity to make it as complete as possible; i.e. add product(s) and discount(s), estimate the close date, etc.';
                } else{
                    emailBody += 'Client Manager (Account Owner) is no longer an active user, please reassign Opportunity';
                }
                mail.setPlainTextBody(emailBody);
                mailingList.add(mail);
            }
    
            Messaging.sendEmail(mailingList);
            runOnce_createRenewalOpportunity = true;
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
}