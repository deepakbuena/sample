/*
@Name                : LeadTriggerHandler 
@Author              : GS Dev Team
@Date                : January 7, 2016
@Description         : Handler class for LeadTrigger to populate 'ConvertedLeadId__c' and 'ConvertedLeadEmail__c' fields on Opportunity on Lead Conversion
*/

public class LeadTriggerHandler {

    // when lead is converted and its 'convertedOpportunityId' is not null then the 'ConvertedLeadId__c' and 'ConvertedLeadEmail__c' fields on Opportunity should be populated on the basis of Lead Id and Lead Email   
    public static void populateConvertedLeadIdOnOpp(List<Lead> leadList, Map<Id,Lead> leadMap){
        try{
            List<Opportunity> oppList = new List<Opportunity>();
            for(Lead leadTemp: leadList){
                if(leadTemp.isConverted == true && leadTemp.ConvertedOpportunityId != NULL && leadMap.get(leadTemp.ID).isConverted == false){
                    oppList.add(new Opportunity(id = leadTemp.convertedOpportunityId, ConvertedLeadId__c = leadTemp.Id, ConvertedLeadEmail__c = leadTemp.Email));
                }
            }
            if(oppList.size()>0){
                Database.update (oppList);
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    
    //Method to copy the new owner of the Lead to it's tasks
    public static void copyLeadOwnerToTask(Map<Id,Lead> mapIdToLeadNew, Map<Id,Lead> mapIdToLeadOld){
        try{
            Set<String> setValidTaskSubject = new Set<String>{'Use Resources','Advising Session'};
            Set<String> setProfileName = new Set<String>{'CPS - EOC','CPS - EOC Admin'};
            Set<String> setValidProfileId = new Set<String>();
            for(Profile objProfile : [select id from profile where name in : setProfileName]){
                setValidProfileId.add(objProfile.id);
            }
            System.debug('setValidProfileId>>>>>'+setValidProfileId);
            
            Set<Id> setLeadId = new Set<id>();
            for(Lead objLead :  mapIdToLeadNew.values()){
                if(objLead.Ownerid != mapIdToLeadOld.get(objLead.id).OwnerId){
                    setLeadId.add(objLead.id);
                }
            }
            System.debug('setLeadId>>>>>'+setLeadId);
            
            Set<Id> setLeadId2 = new Set<id>();
            for(Lead objLead : [Select id 
                                from Lead 
                                where id in : setLeadId 
                                AND Owner.ProfileId in : setValidProfileId]){
                setLeadId2.add(objLead.id);
            }
            System.debug('setLeadId2>>>>>'+setLeadId2);
            
            List<Task> lstTaskToUpdate = new List<Task>();
            for(Task objTask : [select id,whoid
                                from Task 
                                where Subject in : setValidTaskSubject 
                                AND Status = 'In Progress'
                                AND whoid in : setLeadId2]){
                objTask.OwnerId = mapIdToLeadNew.get(objTask.whoId).OwnerId;
                lstTaskToUpdate.add(objTask);
                System.debug('lstTaskToUpdate>>>>>'+lstTaskToUpdate);
            }
            
            if(lstTaskToUpdate.size()>0){
                Database.update(lstTaskToUpdate);
            }
        }
        catch(Exception ex){
            System.debug('ex>>>>>>'+ex);
        }
    }
}