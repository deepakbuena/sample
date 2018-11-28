public class CampaignSurveyController{

    public Campaign_ASA_Attendees__c campsurvey{get;set;}
    
    public CampaignSurveyController(){
    
        campsurvey = new Campaign_ASA_Attendees__c();
        String campId = ApexPages.CurrentPage().getParameters().get('campId');
        String assignedTo = ApexPages.CurrentPage().getParameters().get('assignedTo'); 
        campsurvey = [Select Campaign__c,ASA_Attendee__c,Recommendation_for_Next_Year_s_Show__c,Total_Cost_of_Attendance__c,Why_did_they_attend__c From Campaign_ASA_Attendees__c Where Campaign__c =: campId AND ASA_Attendee__c =: assignedTo];
    }
    
    public PageReference saveSurvey(){
        try{
            update campsurvey;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your changes have been saved successfully.'));
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
        return null;
    }       
}