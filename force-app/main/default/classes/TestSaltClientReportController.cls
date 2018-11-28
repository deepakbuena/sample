@isTest(seeAllData=true)
private class TestSaltClientReportController
{
    static testmethod void SaltClientReportController() {
        Test.startTest();
            
        Account acc = new Account(Name='Acc1');
        insert acc;
                
        //Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
            
        //User userName = [Select id,Email,UserName,ContactId from User where Name='Kelly Matera'];
        
         Account a = new Account(Name=' College Planning Services');
          insert a;
         
          Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id,FirstName = 'First Name');
          insert c;
 
          user user = new User();
          user.ProfileID = [Select Id From Profile Where Name='Customer Community User'].id;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test@appirio.com';   
          user.CommunityNickname = 'testUser123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = c.Id;
         insert user;
                
        Salt_Client_Reports__c saltreport = new Salt_Client_Reports__c(Name='Salt Report',Account__c= acc.id);
        insert saltreport;
        
        Id loginRecordTypeId=Schema.SObjectType.Tracking_Detail__c.getRecordTypeInfosByName().get('Login').getRecordTypeId();
        
        Tracking_Detail__c tDetail = new Tracking_Detail__c();
        tDetail.Login_Time__c = System.now();
        tDetail.Logged_In_User__c = user .Id;
        tDetail.RecordTypeId = loginRecordTypeId;
        tDetail.Account__c = acc.Id;
        insert tDetail; 
        
        SF_Community__c sfComm = new  SF_Community__c();
        sfComm.Community_Url__c='abc.com';
        sfComm.Name='url';
        insert sfComm;
                
        System.runAs(user) {
            SaltClientReportController.hasCreatePermission();
            SaltClientReportController.getUserId();
            SaltClientReportController.findAll();
            SaltClientReportController.getColumns();
            SaltClientReportController.getURL();
            SaltClientReportController.sortByCreatedDate();
            SaltClientReportController.getCurrentSortedByName();
            SaltClientReportController.saveRecord(saltreport.id);
            SaltClientReportController.getAvailableListviews();
        }        
        Test.stopTest();
    }
    
    static testmethod void SaltClientReportController2() {
        Test.startTest();
            
        Account acc = new Account(Name=' College Planning Services');
        insert acc;
        
        Contact con=new Contact();
        con.lastname='Doe';
        con.accountId=acc.id;
        con.FirstName = 'First Name';
        insert con;
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
            
      //  User userName = [Select id,Email,UserName,ContactId from User where Name='Kelly Matera'];
        User u = new User(Alias = 'standt', Email='standarduser@testasaorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testingasas', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, contactId=con.id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testasaorg.com');
      
           
        Salt_Client_Reports__c saltreport = new Salt_Client_Reports__c(Name='Salt Report',Account__c= acc.id);
        insert saltreport;
                
        System.runAs(u) {
            SaltClientReportController.getUserId();
        }        
        Test.stopTest();
    }
    
    
    
}