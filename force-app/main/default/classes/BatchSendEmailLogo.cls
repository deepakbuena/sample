global class BatchSendEmailLogo implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    public Integer count = 0;
    
    global void execute(SchedulableContext ctx) {
        BatchSendEmailLogo batch1 = new BatchSendEmailLogo();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<string> myString = new Set<String>{'image/jpeg', 'image/gif', 'image/png', 'image/jpg', 'image/bmp'};
        String query = 'SELECT BodyLength,ContentType,Id,Name FROM Attachment where Description = null AND ContentType LIKE : myString AND Name Like \'image00%\' AND BodyLength < 20480 Order By CreatedDate ASC LIMIT 1000';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        for(Attachment a : (List<Attachment>)scope){
            count++;
        }
    }
    
    /*
    @Name :finish
    @Description :finish method
    */
    global void finish(Database.BatchableContext BC) {
        if(count>0){
            //get the vf page content into blob
            PageReference pdf = Page.AttachmentImagePage;
            Blob body;
            
            if (Test.IsRunningTest()){
                body=Blob.valueOf('UNIT.TEST');
            }else{
                body=pdf.getContent();
            } 
            
            //prepare an email file attachment to show the logos
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('LogoFiles.pdf');
            attach.setInline(true);
            attach.Body = body;
            
            //send an email
            List<String> toAddresses = new List<String>{'matt@gilbuenasaxena.com','jdamico@asa.org','kelly@asa.org'};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Logo/Image files to be deleted');
            mail.setHTMLBody('');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}