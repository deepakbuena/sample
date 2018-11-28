@isTest
private class TestCreate_ProServiceOffering{
  
    
    static testmethod void testOff(){
    
        Test.startTest();
        
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='CSARequests__c' AND Name='Pro Services Request'];
        
        Account acc = new Account(Name='TestAcc');
        insert acc;
        
        CSARequests__c csa=new CSARequests__c(Name='Mail',End_Date__c=System.today().addDays(5),Due_Date__c=System.today(),Details__c='test test test',Meeting_Date__c=system.today(),Recordtypeid=rt.id,CSA_Request__c='Conference Presentation Proposal',Engagement_Partner_Request__c=False,Account__c=acc.id,Expected_Attendees__c =54,Conference_Start_Date__c=system.today(),Conference_End_Date__c=system.today().addDays(3));
        insert csa;
               
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.Description= 'xyz';
        attach.parentId=csa.id;
        insert attach;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:csa.id];
        System.assertEquals(1, attachments.size());
        
        csa.CSA_Request__c='';
        update csa;
        csa.CSA_Request__c='Salt Demo / Webinar';
        update csa;
        
        Test.stopTest();
       
    }
}