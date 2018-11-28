@isTest
public class TestUpdateInPersonMeetings {
    static testMethod void updateMeetingsTest()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='stsyuser@sfdc.com');
            insert u;
            
            Account acc = new Account(Name = 'Test Acc', OwnerId = u.Id);
            insert acc;
            
            Event evnt1 = new Event(OwnerId=u.Id, Type='In-Person Meeting', StartDateTime=System.today(), EndDateTime=System.Today()+5, Subject= 'describe event',WhatId = acc.Id);
            insert evnt1;
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name = 'Test asp');
            insert asp;
            
            Mutually_Agreed_to_Objectives__c m2o1 = new Mutually_Agreed_to_Objectives__c(Name = 'm2o test1', Regional_Manager__c = u.Id, objective_plan_date__c = System.today(),Targeted_Substantive_Visits_for_Month__c= 10,Number_of_Expected_Contracts__c = 10,Annual_Sales_Plan__c=asp.Id);
            insert m2o1;
            
            delete m2o1;
        }  
    }
}