global class BatchAccountTeamOnAccount implements Database.Batchable<sObject>, Schedulable{
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Name,OwnerId,Campus_Consultant__c,Regional_Account_Executive__c,(Select AccountId,TeamMemberRole,UserId From AccountTeamMembers) From Account';
        return Database.getQueryLocator(query);
    }
    
    // Execute Method
    global void execute(Database.BatchableContext BC, List<Account> accList){
        try{
            Map<Id,Account> accMap = new Map<Id,Account>();
            
            for(Account accTemp : accList){
                if(accTemp.AccountTeamMembers.size()>0){
                    Boolean ccTeamRoleExist = false;
                    Boolean raeTeamRoleExist = false;    
                    for(AccountTeamMember teamMem : accTemp.AccountTeamMembers){
                        if(teamMem.TeamMemberRole == 'Campus Consultant'){
                            ccTeamRoleExist = true;    
                        }
                        if(teamMem.TeamMemberRole == 'Business Development AE'){
                            raeTeamRoleExist = true;    
                        }
                    }
                    
                    for(AccountTeamMember teamMemTemp : accTemp.AccountTeamMembers){
                        if(teamMemTemp.TeamMemberRole == 'School Client Manager' && accTemp.OwnerId != teamMemTemp.UserId){
                            if(!accMap.containsKey(teamMemTemp.AccountId)){
                                accMap.put(teamMemTemp.AccountId,new Account(Id=teamMemTemp.AccountId,OwnerId = teamMemTemp.UserId));
                            } else{
                                accMap.get(teamMemTemp.AccountId).OwnerId = teamMemTemp.UserId;
                            }
                        }
                        if(teamMemTemp.TeamMemberRole == 'Campus Consultant' && accTemp.Campus_Consultant__c != teamMemTemp.UserId){
                            if(!accMap.containsKey(teamMemTemp.AccountId)){
                                accMap.put(teamMemTemp.AccountId,new Account(Id=teamMemTemp.AccountId,Campus_Consultant__c = teamMemTemp.UserId));
                            } else{
                                accMap.get(teamMemTemp.AccountId).Campus_Consultant__c = teamMemTemp.UserId;
                            } 
                        } 
                        if(teamMemTemp.TeamMemberRole == 'Business Development AE' && accTemp.Regional_Account_Executive__c != teamMemTemp.UserId){
                            if(!accMap.containsKey(teamMemTemp.AccountId)){
                                accMap.put(teamMemTemp.AccountId,new Account(Id=teamMemTemp.AccountId,Regional_Account_Executive__c = teamMemTemp.UserId));
                            } else{
                                accMap.get(teamMemTemp.AccountId).Regional_Account_Executive__c = teamMemTemp.UserId;
                            }  
                        }
                        if(accTemp.Campus_Consultant__c != null && !ccTeamRoleExist){
                            if(!accMap.containsKey(teamMemTemp.AccountId)){
                                accMap.put(teamMemTemp.AccountId,new Account(Id=teamMemTemp.AccountId,Campus_Consultant__c = null));
                            } else{
                                accMap.get(teamMemTemp.AccountId).Campus_Consultant__c = null;
                            } 
                        }
                        if(accTemp.Regional_Account_Executive__c != null && !raeTeamRoleExist){
                            if(!accMap.containsKey(teamMemTemp.AccountId)){
                                accMap.put(teamMemTemp.AccountId,new Account(Id=teamMemTemp.AccountId,Regional_Account_Executive__c = null));
                            } else{
                                accMap.get(teamMemTemp.AccountId).Regional_Account_Executive__c = null;
                            }       
                        }
                    }
                }else{
                     if(accTemp.Campus_Consultant__c != null || accTemp.Regional_Account_Executive__c != null){
                         if(!accMap.containsKey(accTemp.Id)){
                                accMap.put(accTemp.Id,new Account(Id=accTemp.Id,Regional_Account_Executive__c = null,Campus_Consultant__c = null));
                            } else{
                                accMap.get(accTemp.Id).Campus_Consultant__c = null;
                                accMap.get(accTemp.Id).Regional_Account_Executive__c = null;
                            } 
                     }  
                }
            }
            Database.update (accMap.values(),false);
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    //Schedule Method
    global void execute(SchedulableContext sc) {
        BatchAccountTeamonAccount b1 = new BatchAccountTeamonAccount();
        ID batchprocessid = Database.executeBatch(b1);    
    }
    
    // Finish Method      
    global void finish(Database.BatchableContext BC){
            
    }
}