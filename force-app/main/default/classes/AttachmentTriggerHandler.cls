public class AttachmentTriggerHandler{
    //Method for After Insert Event
    public static void onAfterInsert(Map<Id,Attachment> mapIdToAttachment){
        AttachmentTriggerHelper.deleteEmailMessageAttachments(mapIdToAttachment.values());
    }
}