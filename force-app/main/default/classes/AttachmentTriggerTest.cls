@isTest
private class AttachmentTriggerTest{
    //Method to test the deletion of attachments related to incoming Email Message
    @isTest static void testAttDeletion() {
        Case objCase = new Case();
        objCase.Status = 'New';
        objCase.Priority = 'Medium';
        objCase.Origin = 'Email';
        objCase.Description = 'Test description';
        objCase.Subject = 'Test subject';
        insert objCase;
        
        EmailMessage objEmailMessage = new EmailMessage();
        objEmailMessage.Incoming = true;
        objEmailMessage.Status = '1';
        objEmailMessage.FromAddress = 'test@test.com';
        objEmailMessage.FromName = 'test from';
        objEmailMessage.ToAddress = 'test2@test.com';
        objEmailMessage.Subject = 'Test Subject';
        objEmailMessage.TextBody = 'Test Body';
        objEmailMessage.ParentId = objCase.id;
        insert objEmailMessage;
        
        Attachment objAttachment = new Attachment();    
        objAttachment.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objAttachment.body = bodyBlob;
        objAttachment.parentId = objEmailMessage.id;
        insert objAttachment;
        
        
        List<Attachment> lstAttToCheck = new List<Attachment>();
        lstAttToCheck = [select id from attachment where id =: objAttachment.id];
        System.assertEquals(0,lstAttToCheck.size());
    }
}