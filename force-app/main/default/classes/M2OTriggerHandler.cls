public class M2OTriggerHandler{

    public static void updateInPersonMeetings(List<Mutually_Agreed_to_Objectives__c> m2oList){
    
        try{
            Set<Id> updateAnnualIds = new Set<Id>();
              
            for(Mutually_Agreed_to_Objectives__c m2oTemp:  m2oList){
                updateAnnualIds.add(m2oTemp.Annual_Sales_Plan__c);
            }
            
            updateAnnualIds.remove(null);
            
            if(updateAnnualIds.size()>0){ 
                List<Annual_Sales_Plan__c> aspListToUpdate = new List<Annual_Sales_Plan__c>();
                List<Annual_Sales_Plan__c> aspList = [SELECT Id,In_Person_Meetings__c,(SELECT Actual_Substantive_Visits_for_Month__c,Annual_Sales_Plan__c FROM Mutually_Agreed_to_Objectives__r) FROM Annual_Sales_Plan__c WHERE Id IN : updateAnnualIds];
                
                for(Annual_Sales_Plan__c asp : aspList){  
                    asp.In_Person_Meetings__c = 0;
                    for(Mutually_Agreed_to_Objectives__c m2oTemp : asp.Mutually_Agreed_to_Objectives__r){
                        if(m2oTemp.Actual_Substantive_Visits_for_Month__c == null){
                            m2oTemp.Actual_Substantive_Visits_for_Month__c = 0;  
                        }
                        asp.In_Person_Meetings__c += m2oTemp.Actual_Substantive_Visits_for_Month__c;
                    }
                    aspListToUpdate.add(asp);
                }
                Database.update(aspListToUpdate,false);
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public static void reCalcM2O(List<Mutually_Agreed_to_Objectives__c> m2oList){
    
        //Any update to Mutually_Agreed_to_Objectives__c will recalculate M2O Substantive Visits
        Id[] listOfAE = new Id[]{};
        Integer[] listOfYears = new Integer[]{};
        Integer[] listOfMonths = new Integer[]{};
    
        //Create list of AE and months/years to minimize query results
        for(Mutually_Agreed_to_Objectives__c m2o : m2oList){
    
            listOfAE.add(m2o.Regional_Account_Executive__c);
            listOfMonths.add(m2o.objective_plan_date__c.month());
            listOfYears.add(m2o.objective_plan_date__c.year());
        }
    
        //Select only Account or Opportunity Events that is assigned to the m2o.Regional_Account_Executive__c
        List<Event> listOfEvents = [SELECT StartDateTime, OwnerId,Type
                                FROM Event
                                WHERE OwnerId IN :listOfAE AND
                                    What.Type IN ('Account','Opportunity') AND
                                    CALENDAR_MONTH(StartDateTime) IN :listOfMonths AND
                                    CALENDAR_YEAR(StartDateTime) IN :listOfYears];
    
        // For each m2o, look at the Events and tally up the events for the AE of that month
        for(Mutually_Agreed_to_Objectives__c m2o : m2oList){
    
           //Modified By :   GS Dev Team
           //Modified Date : January 7, 2016
            m2o.Actual_Substantive_Visits_for_Month__c = 0;
            m2o.Substantive_Visits_Score__c = 0;  // modified
            m2o.Secondary_Visits_Score__c = 0;    // modified
    
            for(Event e : listOfEvents){
    
                if(e.OwnerId == m2o.Regional_Account_Executive__c && 
                    e.StartDateTime.date().toStartOfMonth() == m2o.objective_plan_date__c.toStartOfMonth()){
                    m2o.Actual_Substantive_Visits_for_Month__c += 1;
                    
                    // To update “Substantive Visits Score” and “Secondary Visits Score” fields value based on the appropriate event type values
                    if(e.Type == 'Online Meeting' || e.Type == 'In-Person Meeting'){
                       m2o.Substantive_Visits_Score__c += 2;     
                    }
                    if(e.Type == 'Substantive Call' || e.Type == 'Conference Meeting' || e.Type == 'Booth Meeting' || e.Type == 'Collateral Drop Off'){
                        m2o.Secondary_Visits_Score__c += 1;
                    }
                }
            }
        }    
    }
    
    public static void AutomateNoOfContractRcvdInsert(List<Mutually_Agreed_to_Objectives__c> m2oList){
    
        for(Mutually_Agreed_to_Objectives__c M2O : m2oList){
            if(M2O.Number_of_Contracts_Received__c == null){
                M2O.Number_of_Contracts_Received__c = 0;
            }
            if(M2O.Expected_Contract_1_Recv_d_Closed__c == true){
                M2O.Number_of_Contracts_Received__c += 1 ;                          
            }                      
            if(M2O.Expected_Contract_2_Recv_d_Closed__c == true){
                M2O.Number_of_Contracts_Received__c += 1 ;                         
            }           
            if(M2O.Expected_Contract_3_Recv_d_Closed__c == true){
               M2O.Number_of_Contracts_Received__c += 1 ;                      
            }           
        }
    }
            
    public static void AutomateNoOfContractRcvdUpdate(List<Mutually_Agreed_to_Objectives__c> m2oList, Map<Id,Mutually_Agreed_to_Objectives__c> m2oMap){
    
        for(Mutually_Agreed_to_Objectives__c M2O : m2oList){ 
            
            Integer noOfChecked = 0;
            if(M2O.Expected_Contract_1_Recv_d_Closed__c == true){
                noOfChecked += 1 ;
            }
            if(M2O.Expected_Contract_2_Recv_d_Closed__c == true){
                noOfChecked += 1 ;
            }
            if(M2O.Expected_Contract_3_Recv_d_Closed__c == true){
                noOfChecked += 1 ;
            }            
                                     
            Mutually_Agreed_to_Objectives__c oldM2ORec = m2oMap.get(M2O.Id); 
            
            if(M2O.Number_of_Contracts_Received__c == null){
                M2O.Number_of_Contracts_Received__c = 0;
            }                        
            if(oldM2ORec.Expected_Contract_1_Recv_d_Closed__c == true && M2O.Expected_Contract_1_Recv_d_Closed__c == false){
                M2O.Number_of_Contracts_Received__c -= 1;  
            }
            if(oldM2ORec.Expected_Contract_2_Recv_d_Closed__c == true && M2O.Expected_Contract_2_Recv_d_Closed__c == false){
                M2O.Number_of_Contracts_Received__c -= 1;   
            }
            if(oldM2ORec.Expected_Contract_3_Recv_d_Closed__c == true && M2O.Expected_Contract_3_Recv_d_Closed__c == false){
                M2O.Number_of_Contracts_Received__c -= 1;   
            }
            if(oldM2ORec.Expected_Contract_1_Recv_d_Closed__c == false && M2O.Expected_Contract_1_Recv_d_Closed__c == true){                
                M2O.Number_of_Contracts_Received__c += 1 ;  
            }
            if(oldM2ORec.Expected_Contract_2_Recv_d_Closed__c == false && M2O.Expected_Contract_2_Recv_d_Closed__c == true){                
                M2O.Number_of_Contracts_Received__c += 1 ;  
            }
            if(oldM2ORec.Expected_Contract_3_Recv_d_Closed__c == false && M2O.Expected_Contract_3_Recv_d_Closed__c == true){                
                M2O.Number_of_Contracts_Received__c += 1  ; 
            }  
            if(M2O.Number_of_Contracts_Received__c < noOfChecked){
                M2O.addError('The value of "Number of Contracts Received" cannot be less than the number of checked "Expected Contract Received/Closed?"');
            }                          
        }
    }
    public static void validateM20ForASPFiscalYear(List<Mutually_Agreed_to_Objectives__c> m2oList, Map<Id,Mutually_Agreed_to_Objectives__c> oldMap){
    
        Set<Id> aspIds = new Set<Id>();
        
        for(Mutually_Agreed_to_Objectives__c m2o : m2oList){
            if(Trigger.isInsert || (Trigger.isUpdate && m2o.Annual_Sales_Plan__c != null && m2o.Annual_Sales_Plan__c != oldMap.get(m2o.Id).Annual_Sales_Plan__c)){
                if(m2o.Annual_Sales_Plan__c != null){
                    aspIds.add(m2o.Annual_Sales_Plan__c);    
                }
            }   
        }
        
        if(aspIds.size()>0){
            List<Annual_Sales_Plan__c> aspList = [Select Id,CreatedDate,Start_Date__c,End_Date__c From Annual_Sales_Plan__c Where Id In : aspIds];
                    
            Map<Id,Date> aspMapStartDate = new Map<Id,Date>();
            Map<Id,Date> aspMapEndDate = new Map<Id,Date>();
            
            for(Annual_Sales_Plan__c aspTemp : aspList){
                aspMapStartDate.put(aspTemp.Id,aspTemp.Start_Date__c);
                aspMapEndDate.put(aspTemp.Id,aspTemp.End_Date__c);   
            }
            
            for(Mutually_Agreed_to_Objectives__c m2oTemp : m2oList){
                if(Trigger.isInsert || (Trigger.isUpdate && m2oTemp.Annual_Sales_Plan__c != null && m2oTemp.Annual_Sales_Plan__c != oldMap.get(m2oTemp.Id).Annual_Sales_Plan__c)){
                    Date dt;
                    if(Trigger.isInsert){
                        dt = Date.Today();
                    }else{
                        dt = m2oTemp.CreatedDate.date();
                    }
                                        
                    if((dt <= aspMapStartDate.get(m2oTemp.Annual_Sales_Plan__c) && dt <= aspMapEndDate.get(m2oTemp.Annual_Sales_Plan__c)) || (dt >= aspMapStartDate.get(m2oTemp.Annual_Sales_Plan__c) && dt >= aspMapEndDate.get(m2oTemp.Annual_Sales_Plan__c))){
                        m2oTemp.addError('Please select the Annual Sales Plan for the current Fiscal Year.');
                    }
                }
            }
        }
    }
}