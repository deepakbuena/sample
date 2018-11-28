//
// (c) 2017 Appirio, Inc.
//
// Trigger Name: CPS_ContactTrigger
// Description: This Trigger updates Birthdate_Text__c on insert and update of contact record.
//
// 11th October 2017  Abhimanyu Singh Tanwar  Original (Task # T-637587) - Please see the task description for more details.
//
trigger CPS_ContactTrigger on Contact (before update, before insert,after delete) {  
   
  if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert) ) {
    //Update Birthdate_Text__c with Birthdate in string format.
    CPS_ContactTriggerHandler.updateFields(Trigger.new);
    if(trigger.isUpdate)
    {
        CPS_ContactTriggerHandler.afterMerge(trigger.new); 
    }  
    
  }
  if(trigger.isAfter)
  {
      if(trigger.isDelete){
          CPS_ContactTriggerHandler.beforeMerge(trigger.Old);  
      }
        
  }
}