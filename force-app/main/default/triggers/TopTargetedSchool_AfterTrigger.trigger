trigger TopTargetedSchool_AfterTrigger on Top_Targeted_School__c (after insert, after update, before delete) {
    
    //modified code for before delete - GS DEV TEAM
    if(trigger.isDelete){
        Map<Id,Integer> ttcToBeDelMap = new Map<Id,Integer>();
        Map<Id,Decimal> ttcCountMap = new Map<Id,Decimal>();
        
        for(Top_Targeted_School__c s : trigger.old){
            if(!ttcToBeDelMap.containsKey(s.Mutually_Agreed_to_Objectives__c)){
                ttcToBeDelMap.put(s.Mutually_Agreed_to_Objectives__c,0);
            }
            ttcToBeDelMap.put(s.Mutually_Agreed_to_Objectives__c,ttcToBeDelMap.get(s.Mutually_Agreed_to_Objectives__c)+1);
        }
        
        List<Mutually_Agreed_to_Objectives__c> m2OList = [Select Id,Top_Targeted_School_Count__c From Mutually_Agreed_to_Objectives__c Where Id IN :ttcToBeDelMap.keySet()];
        
        for(Mutually_Agreed_to_Objectives__c m2O : m2OList){
            ttcCountMap.put(m2O.Id,m2O.Top_Targeted_School_Count__c); 
            if(ttcToBeDelMap.containsKey(m2O.Id)){
                ttcCountMap.put(m2O.Id,m2O.Top_Targeted_School_Count__c-ttcToBeDelMap.get(m2O.Id)); 
            }          
        }
        for(Top_Targeted_School__c s : trigger.old){
            if(ttcCountMap.containsKey(s.Mutually_Agreed_to_Objectives__c) && ttcCountMap.get(s.Mutually_Agreed_to_Objectives__c)<3){
                s.addError('You cannot delete this record.'); 
            } 
        }
    } else {
        //Top_Targeted_School__c[] schoolLoop = new Top_Targeted_School__c[]{};
        Id[] acctListId = new Id[]{}; 
    
        for(Top_Targeted_School__c s : trigger.new){
    
            acctListId.add(s.Account__c);
        }
    
        //Only recalculate substantive visits if there are Account Activities and provid the range of dates
        if(acctListId.size() > 0 && CalculateSubstantiveVisits.firstRun == true){ 
    
            CalculateSubstantiveVisits.firstRun = false;
            CalculateSubstantiveVisits.reCalcVisits(acctListId);
        }
    }
    
}