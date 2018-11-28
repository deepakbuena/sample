Trigger Create_ProServiceOffering on CSARequests__c (after insert,after update) {

    List<Pro_Services_Offering__c> ListProServiceOffering =  new List<Pro_Services_Offering__c >();
    
    ID rectypeid = Schema.SObjectType.Pro_Services_Offering__c.getRecordTypeInfosByName().get('Conference Presentation').getRecordTypeId();
    ID rectypeid2 = Schema.SObjectType.Pro_Services_Offering__c.getRecordTypeInfosByName().get('Pre-Sales Support').getRecordTypeId();
    
    List<User> users = [Select Id,Name from User where Name='Jonathan Sparling'];
    List<Attachment> attachmentInsertList=new List<Attachment>();
    map<Id,Id> csaProIdMap = new map<Id,Id>();
    Id RecId = Schema.SObjectType.CSARequests__c.getRecordTypeInfosByName().get('Pro Services Request').getRecordTypeId();
    if(checkRecursive.firstRun){
        for(CSARequests__c  objCSARequest : trigger.new){
            if(objCSARequest.recordtypeid==RecId && objCSARequest.Engagement_Partner_Request__c == false && (objCSARequest.CSA_Request__c == 'Conference Presentation Proposal'|| objCSARequest.CSA_Request__c == 'Pre-Sales Meeting / In-Person Support'|| objCSARequest.CSA_Request__c == 'Salt Demo / Webinar'|| objCSARequest.CSA_Request__c == 'Presentation Content Assistance') && (trigger.isinsert || (trigger.isupdate && objCSARequest.CSA_Request__c != Trigger.oldMap.get(objCSARequest.Id).CSA_Request__c ))){
                Pro_Services_Offering__c objProService = new Pro_Services_Offering__c();
                objProService.Name = objCSARequest.Name;
                
                if(objCSARequest.CSA_Request__c == 'Conference Presentation Proposal'){
                    objProService.RecordTypeid = rectypeid;
                    if(users.size()>0){
                        objProService.PS_OfferingAssignedTo__c=users.get(0).Id;  
                    }   
                }else{
                    objProService.RecordTypeid = rectypeid2; 
                }
                
                objProService.PS_OfferingAccount__c = objCSARequest.Account__c ;
                objProService.PS_OfferingCampaign__c= objCSARequest.Campaign__c;
                objProService.Case__c = objCSARequest.Case__c;
                objProService.PS_OfferingCity__c = objCSARequest.City__c;
                objProService.End_Date__c= objCSARequest.Conference_End_Date__c;
                objProService.Expected_Attendees__c= objCSARequest.Expected_Attendees__c ;
                objProService.PS_OfferingOpportunity__c = objCSARequest.Opportunity__c;
                objProService.Proposed_Presenter__c= objCSARequest.Proposed_Presenter__c;
                objProService.Start_Date__c= objCSARequest.Conference_Start_Date__c;
                objProService.PS_OfferingStatus__c = objCSARequest.Status__c;
                objProService.PS_OfferingState__c= objCSARequest.State__c;
                objProService.Submission_Deadline__c= objCSARequest.Due_Date__c;
                objProService.Suggested_Topic__c= objCSARequest.Suggested_Topic__c;    
                objProService.PS_OfferingRequestedBy__c= objCSARequest.OwnerID;   
                objProService.PS_OfferingTargetDate__c= objCSARequest.Conference_Start_Date__c;
                objProService.Proposal_Submission_Details__c= objCSARequest.Details__c; 
                            
                checkRecursive.firstRun = false;    
                ListProServiceOffering.add(objProService);           
            }       
        }
    }
    if(ListProServiceOffering.size() > 0 ){
        insert ListProServiceOffering;
    }
        
    List<Pro_Services_Offering__c> proLst =[Select Id,PS_OfferingAccount__c,Name From Pro_Services_Offering__c  where Id In :ListProServiceOffering];
    for(CSARequests__c  objCSARequest1 : trigger.new){
        if((trigger.isUpdate && objCSARequest1.CSA_Request__c != Trigger.oldMap.get(objCSARequest1.Id).CSA_Request__c) && objCSARequest1.recordtypeid==RecId && objCSARequest1.Engagement_Partner_Request__c == false && (objCSARequest1.CSA_Request__c == 'Conference Presentation Proposal'|| objCSARequest1.CSA_Request__c == 'Pre-Sales Meeting / In-Person Support'|| objCSARequest1.CSA_Request__c == 'Salt Demo / Webinar'|| objCSARequest1.CSA_Request__c == 'Presentation Content Assistance')){
            for(Pro_Services_Offering__c pso : proLst){
                if(objCSARequest1.Name == pso.Name && objCSARequest1.Account__c == pso.PS_OfferingAccount__c){
                  csaProIdMap.put(objCSARequest1.id,pso.id);
                }
            }
        }       
    } 
    List<Attachment> attList = [Select Id,ParentId,Description, name, body from Attachment where ParentId IN: csaProIdMap.keySet()]; 
    for(Attachment atch : attList){
        attachmentInsertList.add(new Attachment(Name = atch.name, Description = atch.Description, Body = atch.body, ParentId = csaProIdMap.get(atch.ParentId)));
    }  
    Database.insert(attachmentInsertList,false);
}