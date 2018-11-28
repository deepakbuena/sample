/**
@Name            : TestCreateLeadForRTAttendees
@Author          : GS Dev Team
@Date            : Sept 26 2016
@Description     : Test class for 'CreateLeadForAttendeesTrg' and 'LeadTrigger' triggers
**/
@isTest

private class TestCreateLeadForRTAttendees
{
    static testmethod void CreateLdForAttendeesTrg() {
    Test.startTest();
 
        try{
            Account acc = new Account(name = 'College Planning Services',Contract_End__c=System.Today().addDays(-2));
            insert acc;
            
            Contact con= new Contact(FirstName='Joe',LastName='John',AccountId=acc.id,Email='test1conam@gmail.com');
            insert con;
            
            RT1__ReadyTalkMeeting__c rtm = new RT1__ReadyTalkMeeting__c();
            insert rtm;
            
            RT1__ReadyTalkMeetingMember__c rtmm = new RT1__ReadyTalkMeetingMember__c(RT1__RegistrationFirstName__c='Rachel',RT1__RegistrationLastName__c='Jons',RT1__Status__c='Attended',RT1__RegistrationEmail__c='xyzconam@gmail.com',RT1__RegistrationCompany__c='LCC',RT1__ReadyTalkMeeting__c=rtm.id);
            insert rtmm;
            
            RT1__ReadyTalkMeeting__c rtm1 = new RT1__ReadyTalkMeeting__c();
            insert rtm1;
            
            RT1__ReadyTalkMeetingMember__c rtmm1 = new RT1__ReadyTalkMeetingMember__c(RT1__RegistrationFirstName__c='Rachel1',RT1__RegistrationLastName__c='Jons1',RT1__Status__c='Confirmed',RT1__RegistrationEmail__c='test1conam@gmail.com',RT1__RegistrationCompany__c='LCC',RT1__ReadyTalkMeeting__c=rtm1.id,RT1__Contact__c =con.id);
            insert rtmm1;
            
            rtmm1.RT1__Status__c='Attended';
            update rtmm1;
            
            
        }        
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
             
        Test.stopTest();
    }
 }