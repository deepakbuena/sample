public class AccountPlanningTriggerHandler{

    public static void populate_fields_from_account(List<Account_Planning__c> apList){
    
        Set<Id> accId = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        
        try{
            for(Account_Planning__c apTemp : apList){
                if(apTemp.Account_Name_2__c != null){
                    accId.add(apTemp.Account_Name_2__c);
                }
            }
            if(accId.size()>0){
                List<Account> accList = [Select Id,Campus_Consultant__c,OwnerId,Regional_Account_Executive__c,Contract_Start__c,OE_Code__c From Account Where Id IN : accId];
                for(Account acc : accList){
                    accMap.put(acc.Id,acc);
                }
                for(Account_Planning__c ap: apList){
                    if(ap.Account_Name_2__c != null){
                        if(accMap.containsKey(ap.Account_Name_2__c)){
                            ap.Contract_Start_Date__c = accMap.get(ap.Account_Name_2__c).Contract_Start__c;
                            ap.OE_Code__c = accMap.get(ap.Account_Name_2__c).OE_Code__c;
                            ap.regional_account_executive__c = accMap.get(ap.Account_Name_2__c).Regional_Account_Executive__c;
                            ap.account_owner_client_manager__c = accMap.get(ap.Account_Name_2__c).OwnerId;
                            ap.Campus_Consultant__c = accMap.get(ap.Account_Name_2__c).Campus_Consultant__c;
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
}