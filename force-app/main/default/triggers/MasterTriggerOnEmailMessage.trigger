trigger MasterTriggerOnEmailMessage on EmailMessage(before insert,after insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        EmailMessageTriggerHandler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        EmailMessageTriggerHandler.onAfterInsert(Trigger.new);
    }
}