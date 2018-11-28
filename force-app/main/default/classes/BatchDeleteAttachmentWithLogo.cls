global class BatchDeleteAttachmentWithLogo Implements Database.Batchable<sObject>,Schedulable {

    global void execute(SchedulableContext ctx) {
        BatchDeleteAttachmentWithLogo batch1 = new BatchDeleteAttachmentWithLogo();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<string> myString = new Set<String>{'image/jpeg', 'image/gif', 'image/png', 'image/jpg', 'image/bmp'};
        String query = 'SELECT BodyLength,ContentType,Description,Id,Name FROM Attachment where Description = null AND ContentType LIKE : myString AND Name Like \'image00%\' AND BodyLength < 20480 Order By CreatedDate ASC LIMIT 1000';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Attachment> attList) {
        try{
            List<Attachment> toBeDel = new List<Attachment>();
            for(Attachment attTemp : attList){
                toBeDel.add(attTemp); 
            }
            if(toBeDel.size()>0){
                Database.delete(toBeDel);
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
 }