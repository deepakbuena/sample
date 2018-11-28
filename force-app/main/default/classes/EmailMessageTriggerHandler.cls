public class EmailMessageTriggerHandler{
    //Method for Before Insert Event
    public static void onBeforeInsert(List<EmailMessage> lstEmailMsg){
        EmailMessageTriggerHelper.maskValues(lstEmailMsg);
    }
    
    //Method for After Insert Event
    public static void onAfterInsert(List<EmailMessage> lstEmailMsg){
        EmailMessageTriggerHelper.updateCase(lstEmailMsg);
    }
    
}