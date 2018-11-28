public with sharing class SALTClientReportAttachmentCtrl {
        
    @AuraEnabled
    public static String deleteRecord(String recordId)
    {
        System.debug('>>>>>>>>>>>>>>>>'+recordId);
        String result='';
        try
        {
            Map<String,String> keys = new Map<String,String>();
            Map<String,Schema.SobjectType> describe = Schema.getGlobalDescribe();
            
            for(String s:describe.keyset())
                keys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
            
            String objName=keys.get(String.valueOf(recordId).substring(0,3));
            
            System.debug('>>>>>>>>>>>>>> '+objName.toLowerCase());
            if(objName.toLowerCase()=='attachment')
            {
                delete [Select id from attachment where id =:recordId Limit 1];
            }
            else if(objName.toLowerCase()=='contentversion')
            {
                Id docId=[SELECT contentdocumentid FROM contentversion WHERE id=:recordId].contentdocumentid ;
                delete [Select id from contentdocument where id =:docId Limit 1];
            }
            result='success';
        }
        catch(Exception e)
        {
            result=e.getMessage();
        }
        return result;
    }    
    
    @AuraEnabled
    public static Boolean hasUploadPermission()
    {
        return Schema.SobjectType.Attachment.isCreateAble();
    }
    
    @AuraEnabled    
    public static String isRecordFollowed(String recordId)
    {
        System.debug('>>>>>>>>>>>>> '+recordId);
        String followed='';
        List<EntitySubscription> es=[Select id from EntitySubscription  where parentId=:recordId and subscriberId=:userInfo.getuserID() Limit 1];
        if(es.size()>0)
        {
            followed='followed';
        }
        
        return followed;
    }
    
    
    @AuraEnabled    
    public static String followRecord(String recordId)
    {
        System.debug('>>>>>>>>>>>>> '+recordId);
        String followed='exists';
        List<EntitySubscription> es=[Select id from EntitySubscription  where parentId=:recordId and subscriberId=:userInfo.getuserID() Limit 1];
        if(es.size()==0)
        {
            EntitySubscription newFollowing=new EntitySubscription();
            newFollowing.ParentId=recordId;
            newFollowing.subscriberId=UserInfo.getUserId();
            newFollowing.NetworkId = Network.getNetworkId();
            insert newFollowing;
            followed='success';
        }
        else
        {
            delete es;
        }
        
        return followed;
    }
    
    @AuraEnabled
    public static String getAttachmentInfo(Id iRecordId)
    {
        String jsonStr='';
        System.debug(iRecordId);
        Set<Id> contentDocumentIdSet=new Set<Id>();
        Map<id,ContentVersion> contentVersionMap=new Map<id,ContentVersion>();
        
        List<Salt_Client_Reports__c> reportList=[Select id, name from Salt_Client_Reports__c where id= : iRecordId Limit 1];
        
        
        if(reportList.size()>0)
        {
            List<Attachment> attachmentDetail=[Select
                                                id, name, lastModifiedDate,parent.name,bodyLength
                                        from
                                                Attachment
                                        where 
                                                parentid=:iRecordId];
            List<ContentDocumentLink> allContentsForUser=[Select 
                                                            ContentDocument.title, ContentDocument.FileExtension , 
                                                            ContentDocument.FileType , ContentDocument.ContentSize,
                                                            ContentDocumentId, ContentDocument.ContentModifiedDate,
                                                            ContentDocument.LatestPublishedVersionId
                                                    from 
                                                            ContentDocumentLink 
                                                    where 
                                                            LinkedEntityId=:iRecordId];
            for(ContentDocumentLink cTemp : allContentsForUser)
            {
                contentDocumentIdSet.add(cTemp.ContentDocumentId);
            }
            
            System.debug(contentDocumentIdSet);
            
            if(contentDocumentIdSet.size()>0)
            {
                for(ContentVersion cTemp : [Select VersionNumber,id,ContentDocumentId from ContentVersion where ContentDocumentId
                                                               in : contentDocumentIdSet and isLatest=True])
                {
                    contentVersionMap.put(cTemp.ContentDocumentId,cTemp);
                }
            }
            System.debug(contentVersionMap.size());
            System.debug(contentVersionMap);
            
            AttachmentParent parentInfo=new AttachmentParent();
            parentInfo.name=reportList.get(0).name;
            parentInfo.Id=reportList.get(0).id;
            
            List<AttachmentWrapper> allDocuments=new List<AttachmentWrapper>();
                                                 
            if(attachmentDetail.size()>0)
            {
                for(Attachment att : attachmentDetail)
                {
                    AttachmentWrapper newRecord=new AttachmentWrapper();
                    newRecord.name=att.name;
                    newRecord.recordid=att.id;
                    newRecord.createddate=att.lastModifiedDate;
                    if(att.bodyLength<1000000 & att.bodyLength>0)
                        newRecord.fileSize=(att.bodyLength/1000.0).setScale(2)+' KB';
                    else
                        newRecord.fileSize=(att.bodyLength/1000000.0).setScale(2)+' MB';
                    newRecord.fileType='Attachment';
                    newRecord.iconType='attachment';
                    newRecord.url='/customers/servlet/servlet.FileDownload?file='+att.id;
                    
                    allDocuments.add(newRecord);
                }
                
            }
            if(allContentsForUser.size()>0)
            {
                for(ContentDocumentLink conv : allContentsForUser)
                {
                    AttachmentWrapper newRecord=new AttachmentWrapper();
                    
                    newRecord.name=conv.ContentDocument.title;
                    System.debug('==========> '+conv.ContentDocumentId);
                    
                    newRecord.recordid=conv.ContentDocument.LatestPublishedVersionId;
                    newRecord.createddate=conv.ContentDocument.ContentModifiedDate;
                    
                    if(conv.ContentDocument.ContentSize<1000000 & conv.ContentDocument.ContentSize>0)
                        newRecord.fileSize=(conv.ContentDocument.ContentSize/1000.0).setScale(2)+' KB';
                    else
                        newRecord.fileSize=(conv.ContentDocument.ContentSize/1000000.0).setScale(2)+' MB';
                        
                    newRecord.fileType='ContentVersion';
                    
                    newRecord.contentVersion=contentVersionMap.get(conv.ContentDocumentId)!=null ? 
                        contentVersionMap.get(conv.ContentDocumentId).VersionNumber:'1';
                    
                    newRecord.iconType=getIconName(conv.ContentDocument.FileType);
                    
                    newRecord.url='/customers/sfc/servlet.shepherd/version/download/'+conv.ContentDocument.LatestPublishedVersionId +
                                        '?asPdf=false&operationContext=CHATTER';
                    
                    
                    allDocuments.add(newRecord);
                }
            }
            parentInfo.allDocs=allDocuments;
            System.debug(parentInfo);
            jsonStr=JSON.serialize(parentInfo);
        }
        return jsonStr;
    }
    
    /* @AuraEnabled
     public static String getPDFData(Id attachmentID)
     {
        String base64Data=null;
        Attachment att=[Select Body from Attachment where id =:attachmentID];
        
        if( att!=null)
            base64Data=EncodingUtil.base64Encode(att.Body);
        
        System.debug(base64Data);      
        return base64Data;
         
     }*/
     
     @AuraEnabled
     public static void saveDownloadSF(Id attachmentId)
     {
        Tracking_Detail__c newrecordDetails=new Tracking_Detail__c ();
        Id relatedContactId=[Select contactId from user where id=: userinfo.getUserId()].contactId;
        
        Contact relatedContact=[Select accountId from contact where id= : relatedContactId];
        if(relatedContact!=null)
        {
            newrecordDetails.account__c=relatedContact.accountId;
        }
        newrecordDetails.Clicked_By__c = userinfo.getUserId();
        newrecordDetails.Clicked_Time__c = DateTime.now();
        newrecordDetails.Clicked_Url__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+attachmentId; 
        newrecordDetails.type__c='Downloaded';
        upsert newrecordDetails;
    }
    
    @testvisible
    private static String getIconName(String fileExt)
    {
        String iconName;
        fileExt=fileExt.toLowerCase();
        System.debug('====================== fileExt '+fileExt);
        
        if(fileExt.contains('msword') || fileExt.contains('vnd.openxmlformats-officedocument.wordprocessingml') ||
            fileExt.contains('vnd.ms-word') || fileExt.contains('x-msword') || fileExt.contains('doc') || 
            fileExt.contains('dot') ||  fileExt.contains('docx') || fileExt.contains('dotx') || fileExt.contains('docm') || 
            fileExt.contains('dotm'))
                iconName='word';
        else if(fileExt.contains('vnd.ms-excel') || fileExt.contains('vnd.openxmlformats-officedocument.spreadsheetml') || 
            fileExt.contains('xls') || fileExt.contains('xlt') || fileExt.contains('xla') || fileExt.contains('xltx') || 
            fileExt.contains('xlsm') || fileExt.contains('xltm') || fileExt.contains('xlam') || fileExt.contains('xlsb') || 
            fileExt.contains('xlsx'))
                iconName='excel';
        else if(fileExt.contains('vnd.ms-powerpoint') || fileExt.contains('x-mspowerpoint') || 
            fileExt.contains('vnd.openxmlformats-officedocument.presentationml') || fileExt.contains('ppt') ||
            fileExt.contains('pot') || fileExt.contains('pps') || fileExt.contains('ppa') || fileExt.contains('pptx') || 
            fileExt.contains('potx') || fileExt.contains('ppsx') || fileExt.contains('ppam') ||  fileExt.contains('potm') || 
            fileExt.contains('ppsm') || fileExt.contains('pptm'))
                iconName='ppt';
        else if(fileExt.contains('octet-stream') || fileExt.contains('x-zip-compressed'))
                iconName='zip';
        else if(fileExt.contains('rtf'))
                iconName='rtf';
        else if(fileExt.contains('pdf'))
            iconName='pdf';
        else if(fileExt.contains('xml'))
                iconName='xml';
        else if(fileExt.contains('eps'))
            iconName='eps';
        else if(fileExt.contains('bmp') || fileExt.contains('gif') || fileExt.contains('png') || fileExt.contains('img') || fileExt.contains('jpg'))
            iconName='image';
        else if(fileExt.contains('html'))
            iconName='html';
        else if(fileExt.contains('csv'))
            iconName='csv';
        else if(fileExt.contains('plain'))
            iconName='txt';
        else if(fileExt.contains('mp3') || fileExt.contains('wav')) 
            iconName='audio';
        else if(fileExt.contains('mpeg'))
            iconName='video';
        else if(fileExt.contains('mp4'))
            iconName='mp4';
        else if(fileExt.contains('vnd.google-apps.document'))
            iconName='gdoc';
        else if(fileExt.contains('vnd.google-apps.folder'))
            iconName='folder';
        else if(fileExt.contains('vnd.google-apps.spreadsheet'))
            iconName='gsheet';
        else
            iconName='unknown';
        
        return iconName;
    }
    
    @AuraEnabled
    public static String onFollowRecord(String recordId)
    {
        String result='';
        try
        {
            Network net = [Select Id,Name from Network where Name='Salt Reports'];
            EntitySubscription es = new EntitySubscription();
            es.ParentId = recordId;
            es.SubscriberId = Userinfo.getUserId();
            es.networkid=net.id;
            insert es;
            result='success';
        }
        catch(Exception e)
        {
            result=e.getMessage();
        }
        return result;
    }

    
    @AuraEnabled
    public static String getRecordFollow(String recordId)
    {
        String resultStatus='';
        List<EntitySubscription> esRecord = [Select Id from EntitySubscription where ParentId =:recordId and SubscriberId =:UserInfo.getUserId() limit 1];
        if(esRecord.size()>0)
        {
            resultStatus='unfollow';
        }
        return resultStatus;
    }
    
    @AuraEnabled
    public static void visitedRecord (String recordId)
    {
        Tracking_Detail__c newrecordDetails=new Tracking_Detail__c ();
        Id relatedContactId=[Select contactId from user where id=: userinfo.getUserId()].contactId;
        
        Contact relatedContact=[Select accountId from contact where id= : relatedContactId];
        if(relatedContact!=null)
        {
            newrecordDetails.account__c=relatedContact.accountId;
        }
        
        newrecordDetails.Clicked_By__c = userinfo.getUserId();
        newrecordDetails.Clicked_Time__c = DateTime.now();
        newrecordDetails.Clicked_Url__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+recordId; 
        newrecordDetails.type__c='Visited'; 
        upsert newrecordDetails;
        
    }
}