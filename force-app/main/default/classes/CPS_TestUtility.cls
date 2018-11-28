//
// (c) 2017 Appirio, Inc.
//
// Apex Class Name: CPS_TestUtility
// Description: This is a utility class to generate test data.
//
// 11th October 2017  Abhimanyu Singh Tanwar  Original (Task # T-637587) - Please see the task description for more details.
//
@isTest
public class CPS_TestUtility {
  
  // This method is used to insert/instantiate "Account" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Account> toBeInserted
  /*public static List<Account> createAccounts( Boolean isInsert, Integer counter ) {
    List<Account> toBeInserted = new List<Account>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Account(
        Name = 'Test Account #' + (i + 1),
        BillingCity = 'Test City',
        BillingPostalCode = '123', 
        BillingStreet = 'Mariff Street'
      ));
    }

    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }*/
  
  // This method is used to insert/instantiate "Contact" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Contact> toBeInserted
  public static List<Contact> createContacts( Boolean isInsert, Integer counter,Id AccountId ) {
    List<Contact> toBeInserted = new List<Contact>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Contact(
        FirstName = 'First #' + (i + 1),
        LastName = 'Last',
        AccountId = AccountId
      ));
    }

    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }
  
  // This method is used to insert/instantiate "Campaign" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Campaign> toBeInserted
  public static List<Campaign> createCampaign( Boolean isInsert, Integer counter ) {
    List<Campaign> toBeInserted = new List<Campaign>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Campaign(
        Name = 'First #' + (i + 1)
      ));
    }
    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }
  
  // This method is used to insert/instantiate "CampaignMember" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<CampaignMember> toBeInserted
  public static List<CampaignMember> createCampaignMember( Boolean isInsert, Integer counter, Id campaignId, Id contactId ) {
    List<CampaignMember> toBeInserted = new List<CampaignMember>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new CampaignMember(
        CampaignId = campaignId,
        contactId = contactId,
        Status = 'Sent',
        Active__c = true
      ));
    }
    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }
  
  // This method is used to insert/instantiate "Targeted_School__c" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Targeted_School__c> toBeInserted
  public static List<Targeted_School__c> createTargetedSchool( Boolean isInsert, Integer counter, Id SchoolId ) {
    List<Targeted_School__c> toBeInserted = new List<Targeted_School__c>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Targeted_School__c(
        Name = 'First #' + (i + 1),
        Secondary_School__c = SchoolId,
        Is_Active__c = true,
        Is_Target_School_for_Program_s__c = 'TS Boston'
      ));
    }
    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }
  
  // This method is used to insert/instantiate "Secondary_School_Name__c" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Secondary_School_Name__c> toBeInserted
  public static List<Secondary_School__c> createSecondarySchool( Boolean isInsert, Integer counter ) {
    List<Secondary_School__c> toBeInserted = new List<Secondary_School__c>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Secondary_School__c(
        Name = 'First #' + (i + 1)
      ));
    }
    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }
  
  /* 
  // This method is used to insert/instantiate "Opportunity" records.
  // @param   Boolean isInsert, Integer counter
  // @return  List<Opportunity> toBeInserted
  public static List<Opportunity> createOpportunities(Boolean isInsert, Integer counter) {
    return createOpportunities(isInsert,counter,null);
  }
  
  // This method is used to insert/instantiate "Opportunity" records.
  // @param   Boolean isInsert, Integer counter, Id accountId
  // @return  List<Opportunity> toBeInserted
  public static List<Opportunity> createOpportunities( Boolean isInsert, Integer counter, Id accountId ) {
    List<Opportunity> toBeInserted = new List<Opportunity>();
    for(Integer i = 0;i < counter;i++) {
      toBeInserted.add(new Opportunity(
        Name = 'Test Opportunity #' + (i + 1),
        CloseDate = System.Today(),
        StageName = 'New',
        AccountId = accountId
      ));
    }

    if(isInsert) {
      insert toBeInserted;
    }
    return toBeInserted;
  }*/
}