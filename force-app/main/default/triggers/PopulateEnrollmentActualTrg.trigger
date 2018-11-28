trigger PopulateEnrollmentActualTrg on Annual_Sales_Plan__c (before insert) {

    Set<Id> aspOwnerIds = new Set<Id>();
    Map<Id,Decimal> mapTotEnrollment = new Map<Id,Decimal>();
    Set<String> fYearSet = new Set<String>();
    Map<Id,Annual_Sales_Plan__c> aspMap = new Map<Id,Annual_Sales_Plan__c>();
        
    for(Annual_Sales_Plan__c aspTemp : Trigger.new){
        aspOwnerIds.add(aspTemp.OwnerId);
        aspMap.put(aspTemp.OwnerId,aspTemp);
    }
    List<Opportunity> oppList = [Select OwnerId,CloseDate,Total_in_Enrollment__c From Opportunity Where (StageName = 'Closed - Won' OR StageName = 'In Production' OR StageName = 'Implementation') AND OwnerId In : aspOwnerIds];
    
    for(Opportunity oppTemp : oppList){
        if(oppTemp.CloseDate >= aspMap.get(oppTemp.OwnerId).Start_Date__c && oppTemp.CloseDate <= aspMap.get(oppTemp.OwnerId).End_Date__c){
            if(!mapTotEnrollment.containsKey(oppTemp.OwnerId)){
                mapTotEnrollment.put(oppTemp.OwnerId,0); 
            }
            if(oppTemp.Total_in_Enrollment__c!=null){
                mapTotEnrollment.put(oppTemp.OwnerId,mapTotEnrollment.get(oppTemp.OwnerId)+oppTemp.Total_in_Enrollment__c);
            }
        }
    }
    for(Annual_Sales_Plan__c asp : Trigger.new){
        if(Date.Today() >= asp.Start_Date__c && Date.Today() <= asp.End_Date__c){
            if(mapTotEnrollment.containsKey(asp.OwnerId)){
                asp.Enrollment_Actual__c =  mapTotEnrollment.get(asp.OwnerId);
            }
        }
    }
}