/*************************************************************************************************
Created By:    Gagandeep Kaur
Date:          Feb 10, 2016
Description  : Contains Methods for creating Test Data
Name         : TestUtility
 **************************************************************************************************/
public class TestUtility {
    //method to create User record
    public static User createUser(String profileName, Boolean isInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
        User us = new User(ProfileId = p.Id,
                            alias = 'usr1', 
                            email = 'user1@test.com', 
                            emailencodingkey = 'UTF-8', 
                            lastname = 'Testing1', 
                            languagelocalekey = 'en_US', 
                            localesidkey = 'en_US', 
                            timezonesidkey = 'America/Los_Angeles', 
                            username = 'user_1_EmpComm' + '@test.com');
        if(isInsert) {
            insert us;
        }
        return us;
    }
    
    //method to get Recordtype Id of an object
    public static String getRecordTypeId(String objectType, String recordType) {
        Map < String, Schema.RecordTypeInfo > rtMapByName = null;
        if (rtMapByName == null) {
          Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
          Schema.SObjectType ctype = gd.get(objectType);
          Schema.DescribeSObjectResult d1 = ctype.getDescribe();
          rtMapByName = d1.getRecordTypeInfosByName();
        }
        
        Schema.RecordTypeInfo recordTypeDetail = rtMapByName.get(recordType);
        if (recordTypeDetail != null) {
          return recordTypeDetail.getRecordTypeId();
        } else {
          return null;
        }
    }
    
    //method to create Account Record
    public static Account createAccount(String recordTypeId, String name, Boolean isInsert ){
        Account ac = new Account();
        ac.Name = name;
        ac.RecordTypeId = recordTypeId;
        if(isInsert){
            insert ac;
        }
        return ac;
    }
    
    //Method to create Contact record
    public static Contact createContact(Id accountId, Boolean isInsert) {
        Contact con = new Contact(LastName = 'Test', AccountId = accountId,FirstName = 'FirstName');
        if(isInsert) {
            insert con;
        }
        return con;
    }
    
    //method to create Portal User record
    public static User createPortalUser(Id contactId){
        User user = new User(); 
            //Create portal user with given portal profile
            Profile p = [SELECT Id FROM Profile WHERE UserType = 'CSPLitePortal' LIMIT 1];
            user = new User(
                    Username = System.now().millisecond() + 'test12345@test.com',
                    ContactId = contactId,
                    ProfileId = p.Id,
                    Alias = 'test123',
                    Email = 'test12345@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty',
                    CommunityNickname = 'test12345'+Math.random()*10,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'

                    );
        insert user;
        return user;
    }
}