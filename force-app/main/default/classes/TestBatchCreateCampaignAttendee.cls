/**
@Name            : TestBatchCreateCampaignAttendee
@Author          : Monika CONAM
@Date            : Jan 2 2017
@Description     : Test class for 'BatchCreateCampaignAttendee' Batch Class 
**/
@isTest

private class TestBatchCreateCampaignAttendee
{
    static testmethod void BatchCreateCampaignAttendee() {
        Test.startTest();
        
            RecordType camprt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference']; 
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User u = new User(Alias = 'standt', Email='standarduser@test.com', 
                     EmailEncodingKey='UTF-8',Firstname='Attendee', Lastname='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='testusr22@test.com');
            insert u;         
            User u1 = new User(Alias = 'standt2', Email='standarduser123@test1.com', 
                     EmailEncodingKey='UTF-8',Firstname='Attendee', Lastname='Test', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='usrtst111@testorg1.com');         
            insert u1;   
            
            System.runAs(u){    
                Campaign camp =new Campaign(Name='Camp1',Status='Completed',RecordTypeId=camprt.id,StartDate=system.today(),EndDate=system.today().addDays(2),BDAttending__c='Attendee Testing',Primary_BD__c='Attendee Testing',Presenting__c='Attendee Testing');
                insert camp;  
                
                Campaign camp2 =new Campaign(Name='Camp2',Status='Completed',RecordTypeId=camprt.id,StartDate=system.today(),EndDate=system.today().addDays(3),BDAttending__c='Attendee Testing;Attendee Test',Primary_BD__c='Attendee Testing',Presenting__c='Attendee Testing;Attendee Test');
                insert camp2;
                
                Campaign camp3 =new Campaign(Name='Camp3',Status='Completed',RecordTypeId=camprt.id,StartDate=system.today(),EndDate=system.today().addDays(3),BDAttending__c='Attendee Testing;Attendee Test',Primary_BD__c='Attendee Test',Presenting__c='Attendee Testing;Attendee Test');
                insert camp3;
                
                Campaign_ASA_Attendees__c campASA = new Campaign_ASA_Attendees__c(Campaign__c=camp3.id,ASA_Attendee__c=u.id);
                insert campASA; 
                    
                BatchCreateCampaignAttendee  objTest = new BatchCreateCampaignAttendee();
                Database.executebatch(objTest);
            }
        
        Test.stopTest();
    }
}