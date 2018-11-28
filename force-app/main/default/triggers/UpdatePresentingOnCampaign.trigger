trigger UpdatePresentingOnCampaign on Pro_Services_Offering__c (after insert, after update) {

    Set<Id> proCampId = new Set<Id>();
    for(Pro_Services_Offering__c pso : Trigger.new){
        if(pso.PS_OfferingStatus__c == 'Approved' && pso.PS_OfferingAssignedTo__c != null){
            proCampId.add(pso.PS_OfferingCampaign__c);
        }
    }
    
    List<Campaign> campList=[Select Id,Presenting__c,(Select Id,PS_OfferingAssignedTo__r.Name,PS_OfferingCampaign__c From PS_OfferingCampaign__r Where PS_OfferingStatus__c = 'Approved') From Campaign Where Id In : proCampId];
    Map<Id, Campaign> campMap = new Map<Id, Campaign>();
    Map<Id,String> psoMap = new Map<Id,String>();
    
    if(campList.size()>0){
        for(Campaign campTemp : campList){
            for(Pro_Services_Offering__c proTemp : campTemp.PS_OfferingCampaign__r){
                psoMap.put(proTemp.Id, proTemp.PS_OfferingAssignedTo__r.Name);
            }
            Set<String> campPresNames = new Set<String>();
            List<String> lstPresNames = new List<String>();
            if(campTemp.Presenting__c != null && campTemp.Presenting__c.contains(';')){
                lstPresNames = campTemp.Presenting__c.split(';');
            }else if(campTemp.Presenting__c != null){
                lstPresNames.add(campTemp.Presenting__c);   
            }
            campPresNames.addAll(lstPresNames);
            campMap.put(campTemp.Id,campTemp);
            for(Pro_Services_Offering__c pso : Trigger.new){
                if(campTemp.Presenting__c == null){
                    campMap.get(campTemp.Id).Presenting__c =  psoMap.get(pso.Id);
                }else if(!campPresNames.contains(psoMap.get(pso.Id))){
                    campMap.get(campTemp.Id).Presenting__c = campMap.get(campTemp.Id).Presenting__c + ';' + psoMap.get(pso.Id);
                }
            }
        } 
        if(campMap.size()>0){
            update campMap.values();
        }
    }
}