@isTest

private class TestEmailSurvey{

    static testMethod void surveyTest(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='stdarduser@testog.com');
            insert u1;
                            
            Campaign camp = new Campaign(Name = 'Test Campaign',IsActive = true);
            insert camp;
            
            Campaign camp2 = new Campaign(Name = 'Test Campaign2',IsActive = true,Presenting__c = 'Casey Wallen');
            insert camp2;
            
            Campaign camp3 = new Campaign(Name = 'Test Campaign3',IsActive = true,Presenting__c = 'Casey Wallen;Bob Cole');
            insert camp3;
            
            Pro_Services_Topic__c pst = new Pro_Services_Topic__c(Name = 'Test', PS_TopicDescription__c = 'Test...');
            insert pst;
            
            Pro_Services_Offering__c pso = new Pro_Services_Offering__c(PS_OfferingStatus__c = 'Approved',PS_OfferingAssignedTo__c = u1.Id, 
                                                                        PS_OfferingCampaign__c = camp.Id,PS_OfferingRequestedBy__c = u1.Id,
                                                                        PS_OfferingTargetDate__c = System.Today(),Name = 'MASFAA (MS)-Newsletter Article-Fall 2015',
                                                                        PS_OfferingTopic__c = pst.Id,PS_OfferingCity__c = 'New York City',PS_OfferingState__c = 'NY');
            insert pso;
            
            Pro_Services_Offering__c pso2 = new Pro_Services_Offering__c(PS_OfferingStatus__c = 'Approved',PS_OfferingAssignedTo__c = u1.Id, 
                                                                        PS_OfferingCampaign__c = camp2.Id,PS_OfferingRequestedBy__c = u1.Id,
                                                                        PS_OfferingTargetDate__c = System.Today(),Name = 'MASFAA (MS)-Newsletter Article-Fall 2016',
                                                                        PS_OfferingTopic__c = pst.Id,PS_OfferingCity__c = 'New York City',PS_OfferingState__c = 'NY');
            insert pso2;
            
            Pro_Services_Offering__c pso3 = new Pro_Services_Offering__c(PS_OfferingStatus__c = 'Approved',PS_OfferingAssignedTo__c = u1.Id, 
                                                                        PS_OfferingCampaign__c = camp3.Id,PS_OfferingRequestedBy__c = u1.Id,
                                                                        PS_OfferingTargetDate__c = System.Today(),Name = 'MASFAA (MS)-Newsletter Article-Fall 2014',
                                                                        PS_OfferingTopic__c = pst.Id,PS_OfferingCity__c = 'New York City',PS_OfferingState__c = 'NY');
            insert pso3;
                    
            Campaign_ASA_Attendees__c cASA = new Campaign_ASA_Attendees__c(ASA_Attendee__c = u1.Id, Campaign__c = camp2.Id);
            insert cASA;
            
            camp2.Flag__c = true;
            update camp2;
            try{
                PageReference newPageRef = Page.CampaignSurveyPage;
                Test.setCurrentPage(newPageRef);
                ApexPages.CurrentPage().getParameters().put('campId', camp2.Id);
                ApexPages.CurrentPage().getParameters().put('assignedTo', u1.Id);
                
                CampaignSurveyController csctrl = new CampaignSurveyController();               
                csctrl.saveSurvey();
            }
            catch(Exception e){
                System.debug('An exception has occurred: ' + e.getMessage() + '-' + e.getLineNumber());
            }
        }
        
    }
}