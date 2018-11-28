//
// (c) 2017 Appirio, Inc.
//
// Test Class Name  : CPS_ContactTriggerHandler_Test
// Trigger Name     : CPS_ContactTriggerHandler
// Description     : This is a Test class for CPS_ContactTriggerHandler.
//
// 11th October 2017  Abhimanyu Singh Tanwar  Original (Task # T-637587) - Please see the task description for more details.
//
@isTest
private class CPS_ContactTriggerHandler_Test {
    private static testMethod void validateBirthdateToText() {
    Account acct1 = new Account();
    acct1.Name = 'College Planning Services';
    insert acct1;
    
    List<Contact> conList = CPS_TestUtility.createContacts(false,10,null);
    for(Contact con : conList) {
      con.Birthdate = System.Today();      
      con.AccountId = acct1.Id;
    }
    insert conList;
    
    conList = [SELECT Birthdate,Birthdate_Text__c FROM Contact WHERE Birthdate =:System.Today()];
    for(Contact con : conList) {
      System.assert((con.Birthdate != null ? con.Birthdate+'': '') == con.Birthdate_Text__c) ;
    }
    }
    
    private static testMethod void validateMerge() {
    
    Account acct1 = new Account();
    acct1.Name = 'College Planning Services';
    insert acct1;
    
    List<Contact> conList = CPS_TestUtility.createContacts(false,2,null);
    Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - EOC').getRecordTypeId();
    //conList[0].Ethnicity__c = '';      
    conList[0].AccountId = acct1.Id;
    conList[0].recordTypeId = RecordTypeIdContact;
    
    conList[1].Ethnicity__c = 'Two or more races (NonH/L)';      
    conList[1].AccountId = acct1.Id;
    conList[1].recordTypeId = RecordTypeIdContact;
    
    insert conList;
    
    Database.MergeResult results = Database.merge(conList[0], conList[1], false);
    
    //conList = [SELECT Birthdate,Birthdate_Text__c FROM Contact WHERE Birthdate =:System.Today()];
    String errorMessage = 'Careful merging Contacts - you were about to overwrite Intake Form Data with the limited data from the Sign On Form. Be sure to Select All on the EXISTING Contact record when merging, then select only updates, if any, from the Sign On Contact!!';
    System.assert(errorMessage == results .getErrors()[0].getMessage()) ;
    
    }
}