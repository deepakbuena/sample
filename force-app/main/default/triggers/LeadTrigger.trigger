/*
@Name                : LeadTrigger 
@Author              : GS Dev Team
@Date                : January 7, 2016
@Description         : Trigger to populate 'ConvertedLeadId__c' and 'ConvertedLeadEmail__c' fields on Opportunity on Lead Conversion and to populate Lead on ReadyTalk Meeting Member object.
*/

trigger LeadTrigger on Lead (after insert,after update) {
    
    if(trigger.isUpdate){
        LeadTriggerHandler.populateConvertedLeadIdOnOpp(Trigger.new, Trigger.oldMap); 
        LeadTriggerHandler.copyLeadOwnerToTask(Trigger.newMap, Trigger.oldMap);
    }
    
    if(trigger.isInsert){
        UpdateLeadOnRTMeetMemHandlerCls.updateLeadOnRTMeetMem(Trigger.new);
    }
}