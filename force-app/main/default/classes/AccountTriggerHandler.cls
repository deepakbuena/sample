public class AccountTriggerHandler{
    
    public static void clearLostAsOfAcc(List<Account> accList, Map<Id,Account> accMap){
        
        for(Account accTemp : accList){
            if(accMap.get(accTemp.Id).Contract_End__c != null && accTemp.Contract_End__c != null && accTemp.Contract_End__c != accMap.get(accTemp.Id).Contract_End__c && accTemp.Contract_End__c >= accMap.get(accTemp.Id).Contract_End__c){
                accTemp.Lost_as_of__c = null;    
            }
        }
    }
    
    public static void oppProprietaryCheckAcc(List<Account> accList, Map<Id,Account> accMap){
    
        try{
    
            Set<Id> accIds = new Set<Id>();
            List<Opportunity> oppList = new List<Opportunity>();
            
            for(Account accTemp : accList){
                if(accTemp.Type != accMap.get(accTemp.Id).Type && accTemp.Type == 'School  - Proprietary'){
                    accIds.add(accTemp.Id);
                }
            }  
            
            if(accIds.size() > 0){  
                for(Opportunity oppTemp : [Select Id , AccountId , Proprietary__c from Opportunity where AccountId IN : accIds]){
                    oppTemp.Proprietary__c = True;
                    oppList.add(oppTemp);
                }
                Database.Update(oppList,false);
            }
        }
        catch(Exception e){
            System.debug('An Exception has occured -' + e.getMessage() + '-' + e.getLineNumber());
        }
    }
}