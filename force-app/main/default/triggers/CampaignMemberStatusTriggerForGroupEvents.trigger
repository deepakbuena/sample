trigger CampaignMemberStatusTriggerForGroupEvents on Campaign (after insert) {
    
    List<RecordType> recs = [SELECT Id FROM RecordType WHERE Name = 'CPS Group Event' AND SobjectType = 'Campaign'];

    List<Campaign> newCamps = [select Id from Campaign where Id IN :trigger.new AND 
    RecordTypeId IN :recs];
    List<CampaignMemberStatus> cms = new List<CampaignMemberStatus>();
    Set<Id> camps = new Set<Id>();
    List<CampaignMemberStatus> cms2Delete = new List<CampaignMemberStatus>();
    List<CampaignMemberStatus> cms2Insert = new List<CampaignMemberStatus>();
    
    for(Campaign camp : newCamps){
       
            camps.add(camp.Id);
    }   
    
    
    for(CampaignMemberStatus cm : [select Id, Label, CampaignId from CampaignMemberStatus where CampaignId IN :camps]) {
            if(cm.Label == 'Responded') {             
                 cms2Delete.add(cm);                 
            }     
            
             CampaignMemberStatus cms3 = new CampaignMemberStatus(CampaignId = cm.CampaignId, HasResponded=false,
             Label = 'Will Attend', SortOrder = 3);
             cms2Insert.add(cms3); 
             
CampaignMemberStatus cms4 = new CampaignMemberStatus(CampaignId = cm.CampaignId, HasResponded=true,
             Label = 'Attended', SortOrder = 4);
             cms2Insert.add(cms4);

            CampaignMemberStatus cms5 = new CampaignMemberStatus(CampaignId = cm.CampaignId, HasResponded=false,
             Label = 'Did Not Attend', SortOrder = 5);
             cms2Insert.add(cms5); 
             
    }
    

    insert cms2Insert;
    delete cms2Delete;
}