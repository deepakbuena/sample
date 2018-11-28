trigger AttachmentCpyonProSrvOff on Attachment (after insert) {
   
   Set<Id> attachId = new Set<Id>();
   Map<String,CSARequests__c> mapcsa= new Map<String,CSARequests__c>();
   Set<Id> csaAccountId = new Set<Id>();
   try{
       for (Attachment a : trigger.new){
           String parentIdString = String.valueOf(a.parentId);
           if (parentIdString.substring(0,3) == CSARequests__c.sobjecttype.getDescribe().getKeyPrefix()){
               attachId.add(a.parentId);    
           }  
       } 
       if(attachId.size()>0){   
           for(CSARequests__c csaList : [Select Id,Name,Account__c from CSARequests__c where id in :attachId]){
              csaAccountId.add(csaList.Account__c) ;    
               mapcsa.put(csaList.Name,csaList);
           }  
           List<Pro_Services_Offering__c> lstPro = [Select id,PS_OfferingAccount__c,Name from Pro_Services_Offering__c where PS_OfferingAccount__c in : csaAccountId];
           List<Attachment> attList = new List<Attachment>();
           for(Attachment a : trigger.new){
               for(Pro_Services_Offering__c pso : lstPro ){                      
                   if (mapcsa.containskey(pso.Name)){
                       Attachment newA = new Attachment(Name = a.Name,Body = a.Body,Description = a.description,ParentId = pso.id);               
                       attList.add(newA);
                   } 
               }
            }
            if(attList.size()>0){
                Database.insert(attList,false);
            }    
        }
    }
    catch(Exception e){
        System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
    }
}