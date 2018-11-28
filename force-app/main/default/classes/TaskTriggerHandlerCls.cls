public class TaskTriggerHandlerCls{

    public static void taskFlagCheck(List<Task> taskList){
    
        Set<String> whatIDs = new Set<String>();
        List<Task> tList = new List<Task>();
        
        for(Task t : taskList){
            if(t.whatId != null){
                Schema.SObjectType tType= t.whatId.getSObjectType();
                if(tType == Opportunity.Schema.SObjectType){
                    tList.add(t);
                    whatIds.add(t.WhatId);
                }
            }
        }
        if(whatIds.size()>0){
            List<Opportunity> opplist = [SELECT Id,OwnerId,Name FROM Opportunity WHERE Id IN:whatIDs];
            
            for(Task tsk : tList){
                for(integer i=0;i<oppList.size();i++){
                    if((tsk.WhatId == oppList[i].Id) && (tsk.OwnerId == oppList[i].OwnerId)){
                        tsk.Assigned_to_Opty_Owner__c = true;
                        tsk.Related_to_Opportunity__c = true;
                    }
                }
            }
        }
    }
    
    public static void taskTrigger(List<Task> tskList, Map<Id,Task> taskMap){
    
        String opptyIdPrefix = Schema.SObjectType.Opportunity.getKeyPrefix();
        
        //Look for 'Beging Propsal Process' Task with a Status change to Completed and related to Opportunity        
        List<Task> taskList = new List<Task>();
        
        for(Task newTask : tskList){
            String whatIdString = newTask.WhatId;
            
            if(newTask.Subject == 'Begin Proposal Process'
            && whatIdString.startsWith(opptyIdPrefix)
            && taskMap.get(newTask.Id).Status != 'Completed'
            && newTask.Status == 'Completed'){
            
                taskList.add(newTask);
            }
        }
        TaskTriggerHandler.completeProposalEmail(taskList);
    }
    
    public static void noActivityOnOppTask(List<Task> tskList){
    
        Set<ID> oppId = new Set<ID>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Task t : tskList){  
            if(t.Whatid !=null && t.WhatId.getSobjectType() == Schema.Opportunity.sObjectType)      
                oppId.add(t.Whatid) ;       
        }
        if(oppId.size()>0){
            for(Opportunity o : [SELECT StageName_Changed_Date__c FROM Opportunity WHERE Id IN :oppId]){
                o.StageName_Changed_Date__c = System.Today() ;
                oppList.add(o);
            }
        }    
        if(oppList.size()>0){
            Database.update(oppList,false);
        }    
    }
}