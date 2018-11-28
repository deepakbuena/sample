trigger MasterM2OTrigger on Mutually_Agreed_to_Objectives__c (before insert, before update, after insert, after update, after delete, after undelete){

    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate){
            M2OTriggerHandler.updateInPersonMeetings(Trigger.new);
        }
        if(Trigger.isDelete){
            M2OTriggerHandler.updateInPersonMeetings(Trigger.old);    
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            M2OTriggerHandler.reCalcM2O(Trigger.new);
            M2OTriggerHandler.validateM20ForASPFiscalYear(Trigger.new,Trigger.oldMap);
        }
        
        if(!Utilities.setExecuted.contains('MasterEventTrigger')){
            if(Trigger.isInsert){
                M2OTriggerHandler.AutomateNoOfContractRcvdInsert(Trigger.new);    
            }
            if(Trigger.isUpdate){
                M2OTriggerHandler.AutomateNoOfContractRcvdUpdate(Trigger.new,Trigger.oldMap);  
                //M2OTriggerHandler.validateM20ForASPFiscalYear(Trigger.new,Trigger.oldMap);
            }
        }
    }
}