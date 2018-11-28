trigger AttachmentTrigger on Attachment (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AttachmentTriggerHandler.onAfterInsert(Trigger.newMap);
        }
    }
}