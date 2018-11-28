public class EventTriggerHandler{
    
    public static void eventFlagCheck(List<Event> evntList){
        
        try{
            Set<String> whatIDs = new Set<String>();
            List<Event> tList = new List<Event>();
           
            for(Event e : evntList){
                if(e.whatId != null){
                    Schema.SObjectType tType = e.whatId.getSObjectType();
                    if(tType == Opportunity.Schema.SObjectType){
                        tList.add(e);
                        whatIds.add(e.WhatId);
                    }
                }
            }
            if(whatIds.size()>0){
                List<Opportunity> opplist = [SELECT Id,OwnerId,Name FROM Opportunity WHERE Id In : whatIDs];
            
                for(Event eve : tList){
                    for(integer i=0;i<oppList.size();i++){
                        if((eve.WhatId == oppList[i].Id) && (eve.OwnerId == oppList[i].OwnerId)){
                            eve.Assigned_to_Opty_Owner__c = true;
                            eve.Related_to_Opportunity__c = true;
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }    
    }
    
    public static void recalcSubstantiveVisitsM2O(List<Event> evntList){
    
        Id[] acctListId = new Id[]{}; 
        Id[] userListId = new Id[]{};
        Date lastYear = System.today().addYears(-1);
        
        try{
            //Filter only events that is related to Accounts & Opportunities
            for(Event e : evntList){
        
                //Minimize the # of Events to recalculate - Filter for Account, Opportunity Events
                if(e.AccountId != null && e.WhatId != null &&
                    (e.Type == 'Substantive Call' ||
                    e.Type == 'In-Person Meeting' ||
                    e.Type == 'Booth Meeting' ||
                    e.Type == 'Collateral Drop Off' ||
                    e.Type == 'Online Meeting' ||
                    e.Type == 'Conference Meeting')){
        
                    if(e.WhatId.getSObjectType() == Schema.Account.getSobjectType() 
                        || e.WhatId.getSObjectType() == Schema.Opportunity.getSobjectType()){
        
                        acctListId.add(e.AccountId);
                        userListId.add(e.OwnerId);
                    }
                }
            }
        
            //Recalculate Top Targeted Schools and Mutually Agreed to Objectives
            if(acctListId.size() > 0){ 
                    
                //CalculateSubstantiveVisits.firstRun = false;
                CalculateSubstantiveVisits.reCalcVisits(acctListId);
                List<Mutually_Agreed_to_Objectives__c> m2o = [SELECT Id 
                                                            FROM Mutually_Agreed_to_Objectives__c 
                                                            WHERE objective_plan_date__c >= :lastYear AND 
                                                                    Regional_Account_Executive__c In : userListId];
                                                                    
                Utilities.SetExecuted.add('MasterEventTrigger');                                                    
                Database.update(m2o,false);
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }    
    }
    
    public static void noActivityOnOpp(List<Event> evntList){
    
        Set<ID> oppId = new Set<ID>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        try{
            for(Event e : evntList){  
                if(e.Whatid !=null && e.WhatId.getSobjectType() == Schema.Opportunity.sObjectType)      
                oppId.add(e.Whatid) ;       
            }
            if(oppId.size()>0){
                for(Opportunity o : [SELECT StageName_Changed_Date__c FROM Opportunity WHERE Id In :oppId]){
                    o.StageName_Changed_Date__c = System.Today() ;
                    oppList.add(o);
                }
            }    
            if(oppList.size()>0)
                Database.update(oppList,false);    
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());    
        }
    }
}