public with sharing class LiveAgentChatButtonController {

    @AuraEnabled
    public static Contact getContact(Id contactId) {
        Contact c=null;
        User usr = [Select ContactId from User where Id=: UserInfo.getUserId()];
        if(usr.ContactId !=null){
            c = [
                    SELECT Id, Name, Email, Phone
                    FROM Contact
                    WHERE Id =:usr.ContactId
                ];
        }else{
            c = new Contact(FirstName='she');
        }
        return c;
    }
    
    //Created by Gagandeep Kaur - 
    @AuraEnabled
    public static String getCaseRecordTypeId() {
    	Map < String, Schema.RecordTypeInfo > rtMapByName = null;
        if (rtMapByName == null) {
          Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
          Schema.SObjectType ctype = gd.get('Case');
          Schema.DescribeSObjectResult d1 = ctype.getDescribe();
          rtMapByName = d1.getRecordTypeInfosByName();
        }
        User usr = [Select Profile.Name from User where Id=: UserInfo.getUserId()];
        String recTypeName = '';
        if(usr.Profile.Name.contains('Manager')) {
            recTypeName = 'Employer Community Case: From HR Manager';
        } else {
            recTypeName = 'Employer Community Case: From Employee';
        }
        Schema.RecordTypeInfo recordTypeDetail = rtMapByName.get(recTypeName);
        if (recordTypeDetail != null) {
          return recordTypeDetail.getRecordTypeId();
        } else {
          return null;
        }
    }
}