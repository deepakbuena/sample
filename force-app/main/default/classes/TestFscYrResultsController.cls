@isTest
private class TestFscYrResultsController {
    static testMethod void validateFscYrResultsController(){
       
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='stsyuser@sfdc.com');
                                                      
            insert u;
                              
            Account acc = new Account(Name = 'Test Acc', Regional_Account_Executive__c =u.id);
            insert acc;
    
            Annual_Sales_Plan__c ann  = new Annual_Sales_Plan__c (Name='BusDev Plan FY2017 DTeam@GS',OwnerId = u.Id);
            insert ann;
            
            RFP_Process__c rfp= new RFP_Process__c(Name='Test',RFP_Account__c=acc.id,RFP_Value__c=200.00);
            insert rfp;
          
    
            
            ApexPages.StandardController apsc = new ApexPages.StandardController(ann);
            FscYrResultsController fsc =  new FscYrResultsController(apsc);
        }
        
    }
}