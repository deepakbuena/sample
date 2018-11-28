trigger MasterCampaignTrigger on Campaign (after insert,after Update) {
    
    if(Trigger.isUpdate){
        CampaignTriggerHandler.materialsRecDateReminder(Trigger.new, Trigger.oldMap);
        CampaignTriggerHandler.attendeeFeedbackItemNotCreated(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isInsert || Trigger.isUpdate){
        CampaignTriggerHandler.asaAttendeesTrg(Trigger.new, Trigger.oldMap);    
    }  
}