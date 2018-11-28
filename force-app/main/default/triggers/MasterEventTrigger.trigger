trigger MasterEventTrigger on Event (before insert, before update, after insert, after update, after delete) {

    if(Trigger.isBefore){
        EventTriggerHandler.eventFlagCheck(Trigger.new);
    }
    
    if(Trigger.isAfter){
        if(Trigger.isDelete){
            EventTriggerHandler.recalcSubstantiveVisitsM2O(Trigger.old);    
        }
        else if(Trigger.isInsert || Trigger.isUpdate){
            EventTriggerHandler.recalcSubstantiveVisitsM2O(Trigger.new);   
        }
        if(Trigger.isInsert){
            EventTriggerHandler.noActivityOnOpp(Trigger.new);
        }
    }
}