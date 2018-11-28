trigger MasterAccountPlanningTrigger on Account_Planning__c (before insert){
    
    AccountPlanningTriggerHandler.populate_fields_from_account(Trigger.new);
}