/**
@Name            : CPSCampaignInputControllerTest
@Description     : Test class for 'CPSCampaignInputController' Class 
**/

@isTest
public class CPSCampaignInputControllerTest{
    @isTest
    public static void unitTest(){
        id campRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CPS Group Event').getRecordTypeId();
    
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        objCamp.recordTypeId = campRTId!=null?campRTId:null;
        objCamp.Type = 'Email';
        objCamp.CPS_Center_Affiliation_Intake_Location__c = 'EOC Boston';
        insert objCamp;
        
        Campaign objCamp2 = new Campaign();
        objCamp2.Name = 'Test Campaign 2';
        objCamp2.IsActive = TRUE;
        objCamp2.Start_DateTime__c = Date.today().addDays(1);
        objCamp2.recordTypeId = campRTId!=null?campRTId:null;
        objCamp2.Type = 'Email';
        objCamp2.CPS_Center_Affiliation_Intake_Location__c = 'EOC Boston';
        insert objCamp2;
        
        Campaign objCamp3 = new Campaign();
        objCamp3.Name = 'Test Campaign 2';
        objCamp3.IsActive = TRUE;
        objCamp3.Start_DateTime__c = Date.today().addDays(1);
        objCamp3.recordTypeId = campRTId!=null?campRTId:null;
        objCamp3.Type = 'Email';
        objCamp3.CPS_Center_Affiliation_Intake_Location__c = 'EOC Boston';
        insert objCamp3;
        
        Campaign objRecord = [SELECT Id,Name,recordType.name,type FROM Campaign WHERE Id =: objCamp.Id];
        System.debug('objRecord>>>>'+objRecord);
        System.debug('recordType.name>>>>'+recordType.name);
        
        CPSCampaignInputController objCPSCampInputCon = new CPSCampaignInputController();
        objCPSCampInputCon.fetchLocationName();
        objCPSCampInputCon.selectedDate = Date.today();
        objCPSCampInputCon.searchCampaign();
        
        objCPSCampInputCon.selectedLocation = 'EOC Boston';
        objCPSCampInputCon.searchCampaign();
        
        objCPSCampInputCon.selectedDate = null;
        objCPSCampInputCon.searchCampaign();
        
        objCPSCampInputCon.selectedLocation = null;
        objCPSCampInputCon.searchCampaign();
    }
 }