@isTest

private class TestBatchDeleteAttachmentWithLogo {

    static testmethod void testBatchDelLogo() {
        
        Test.startTest();
        Account acc = new Account(Name = 'Test acc');
        insert acc;
    
        Attachment attach=new Attachment();    
        attach.Name = 'image005.jpeg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.ContentType = 'image/png';
        attach.parentId = acc.id;
        insert attach;
        
        ImageController imgctrl = new ImageController();
        
        BatchSendEmailLogo BatchObj = new BatchSendEmailLogo();
        ID batch_processId=Database.executebatch(BatchObj, 2);
        
        BatchSendEmailLogo myBatchClass = new BatchSendEmailLogo();   
        String chron2 = '0 0 23 * * ?';        
        system.schedule('Test Sched2', chron2, myBatchClass);
        
        BatchDeleteAttachmentWithLogo BatchObj1 = new BatchDeleteAttachmentWithLogo();
        ID batch_processId2=Database.executebatch(BatchObj1, 2);
        
        BatchDeleteAttachmentWithLogo myClass = new BatchDeleteAttachmentWithLogo();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        Test.stopTest();
    }
}