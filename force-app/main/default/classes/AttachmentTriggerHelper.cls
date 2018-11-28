public class AttachmentTriggerHelper{
    public static void deleteEmailMessageAttachments(List<Attachment> lstAttachment){
        List<Attachment> lstAttachmentToDelete = new List<Attachment>();
        Set<Id> setEmailMsgId = new Set<Id>();
        
        for(Attachment objAttachment : lstAttachment){
            if(objAttachment.ParentId != null){
                setEmailMsgId.add(objAttachment.ParentId);
            }
        }
        Map<Id,EmailMessage> mapIdToEmailMsg = new Map<Id,EmailMessage>([select id 
                                                                         from EmailMessage 
                                                                         where id in : setEmailMsgId and Incoming = true]);
        
        for(Attachment objAttachment : lstAttachment){
            if(mapIdToEmailMsg.containsKey(objAttachment.ParentId)){
                Attachment objAtt = new Attachment();
                objAtt.id = objAttachment.id;
                lstAttachmentToDelete.add(objAtt);
            }
        }
        
        if(lstAttachmentToDelete.size()>0){
            delete lstAttachmentToDelete;
            System.debug('lstAttachmentToDelete>>>>>>>'+lstAttachmentToDelete);
        }
    }
}