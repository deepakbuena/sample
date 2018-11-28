//
// (c) 2017 Appirio, Inc.
//
// Class Name  : CPS_ContactTriggerHandler
// Trigger Name: CPS_ContactTrigger
// Description: This is a handler class updates Birthdate_Text__c on insert and update of contact record.
//
// 11th October 2017  Abhimanyu Singh Tanwar  Original (Task # T-637587) - Please see the task description for more details.
//
public class CPS_ContactTriggerHandler {
    public static List<Id> mergeRecIds = new List<Id>();
    
    public static void updateFields(List<Contact> newList) {    
        for(Contact con : newList) {
          con.Birthdate_Text__c = (con.Birthdate != null ? con.Birthdate + '' : '');
        }
    }
    
    public static void beforeMerge(List<Contact> OldConLst)
    {
        Set<Id>  redTypeIds = new Set<Id>();
        for(Recordtype redType : [Select Id From RecordType where Name IN ('CPS - EOC','CPS - TS','CPS - UB') AND SobjectType='Contact'])
        {
            redTypeIds.add(redType.Id);   
        }        
        
        for(contact con : OldConLst)
        {
            if(con.MasterRecordId!=Null && con.Ethnicity__c!=NuLL && redTypeIds.contains(con.RecordTypeId))
            mergeRecIds.add(con.MasterRecordId);
        }        
    }
    
    public static void afterMerge(List<Contact> nwConLst)
    {
        for(contact con : nwConLst)
        {
            
            if(mergeRecIds.contains(con.Id) && con.MasterRecordId==NuLL && con.Ethnicity__c==NuLL )
            {
                con.addError('Careful merging Contacts - you were about to overwrite Intake Form Data with the limited data from the Sign On Form. Be sure to Select All on the EXISTING Contact record when merging, then select only updates, if any, from the Sign On Contact!!');       
            }
        }
    }
    
}