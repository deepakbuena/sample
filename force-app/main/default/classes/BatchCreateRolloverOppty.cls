global class BatchCreateRolloverOppty Implements Database.Batchable<sObject>,Schedulable {

    global void execute(SchedulableContext ctx) {
        BatchCreateRolloverOppty batch1 = new BatchCreateRolloverOppty();
        ID batchprocessid = Database.executeBatch(batch1);
        string sch = '0 0 1 1 7 ? *';
        system.schedule ('Batch RollOver 2017', sch, new BatchCreateRolloverOppty());
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
     
        // Do not Rollover the existing Rollovered Opportunities.
        Set<string> oldOpptyIds = new Set<String>{'0066000001MF271AAD','0066000000wctfDAAQ','00660000018HTypAAG','00660000018HUT7AAO','0066000001Ec1u4AAB','0066000001Ec1uiAAB','0066000001Ec1uxAAB',' 0066000001Ec1w5AAB','0066000001Ec9PpAAJ','0066000001EciSNAAZ','00660000018Kf9RAAS','0066000001Ec1wyAAB','0066000001MDlfqAAD','0066000000s8shrAAA','0066000000wbiWOAAY','0066000001Ec1wFAAR','0066000001Ec1ypAAB','0066000001Ec1zTAAR','0066000001Ec9YoAAJ','0066000001EciR8AAJ','0066000001EciWiAAJ','0066000001EcjN9AAJ','0066000001EcjSdAAJ','0066000001EcjZ1AAJ','0066000001MDkhWAAT','0066000001MEUxoAAH','0066000001MF1YEAA1','0066000001aMimGAAS','0063200000uO0noAAC','0066000000wbiV6AAI','00660000012KdCyAAK','00660000018HU4WAAW','0066000001EbMLbAAN','0066000001Ec9SoAAJ','0066000001EcjVsAAJ','0066000001MF259AAD','0066000001MF28TAAT','0066000001EcjQMAAZ',' 0066000001MDkXVAA1','00660000012M5HEAA0','0063200001iqcOhAAI','0063200001lRzj8AAC'};
        String query = 'Select Id,Rollover__c,Create_Rollover_Oppty__c From Opportunity Where Rollover__c = true AND Create_Rollover_Oppty__c = false AND Id NOT IN : oldOpptyIds AND Primary_Loss_Reason__c != \'Rolled Over to Next FY\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Opportunity> oppList) {
        
        try{
            List<Opportunity> toBeUpdated = new List<Opportunity>();
            for(Opportunity oppTemp : oppList){
                oppTemp.Create_Rollover_Oppty__c = true;
                toBeUpdated.add(oppTemp);  
            }
            if(toBeUpdated.size()>0){
                update toBeUpdated;
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }   
    }
    
    global void finish(Database.BatchableContext bc) {}
}