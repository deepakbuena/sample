public without sharing class CalculateSubstantiveVisits {
    
    public static boolean firstRun = true;

    public static void reCalcVisits(Id[] acctIdList) {

        DateTime lastYearDT = System.now().addYears(-1);

        Map<Id,Map<Date,Integer>> acctEventMap = new Map<Id,Map<Date,Integer>>();
        String[] typeOfEvents = new String[]{'Substantive Call','In-Person Meeting','Booth Meeting','Online Meeting', 'Collateral Drop Off','Conference Meeting'};

        // Select all Account & Opportunity events related to the Account
        Event[] eventList = [SELECT StartDateTime, AccountId, OwnerId 
                                FROM Event 
                                WHERE Type != null AND AccountId IN :acctIdList AND
                                        What.Type IN ('Account', 'Opportunity') AND
                                        StartDateTime >= :lastYearDT AND
                                        Type IN :typeOfEvents];


        Top_Targeted_School__c[] targetList = [SELECT Mutually_Agreed_to_Objectives__c,
                                                        Mutually_Agreed_to_Objectives__r.objective_plan_date__c,
                                                        Mutually_Agreed_to_Objectives__r.Regional_Account_Executive__c,
                                                        Account__c, 
                                                        Substantive_Visits__c
                                                FROM Top_Targeted_School__c 
                                                WHERE Account__c IN :acctIdList AND
                                                        Mutually_Agreed_to_Objectives__r.objective_plan_date__c >= :lastYearDT.date()];

        //If the objective date is after present date, it won't find the record because it only sees the last 365 days from that day

        //Loop through all events, count Events per Account, store in Map<Id,Map<Date,Integer>>
        for(Event e : eventList){

            if(acctEventMap.containsKey(e.AccountId)){

                //Check if the Account already have the a count on the month
                if(acctEventMap.get(e.AccountId).containsKey(e.StartDateTime.date().toStartOfMonth())){

                    //If the count for the month exist, increment by 1
                    acctEventMap.get(e.AccountId).put(e.StartDateTime.date().toStartOfMonth(), acctEventMap.get(e.AccountId).get(e.StartDateTime.date().toStartOfMonth()) + 1); 
                
                }else{

                    //If the count for the month exist, initialize it with 1
                    acctEventMap.get(e.AccountId).put(e.StartDateTime.date().toStartOfMonth(), 1);
                }

            } else{

                //If account doesn't it exist, initialize it with month and 1 event
                acctEventMap.put(e.AccountId, new Map<Date,Integer>{e.StartDateTime.date().toStartOfMonth() => 1});
            }

        }

        //Place all the # of Events for that Account according to the Top Target Schools records
        for(Top_Targeted_School__c t : targetList){

            t.Substantive_Visits__c = 0;

            for(Event e : eventList){

                if(e.AccountId == t.Account__c && 
                    e.OwnerId == t.Mutually_Agreed_to_Objectives__r.Regional_Account_Executive__c &&
                    e.StartDateTime.date().toStartOfMonth() == t.Mutually_Agreed_to_Objectives__r.objective_plan_date__c.toStartOfMonth()){

                    t.Substantive_Visits__c += 1;
                }
            }

        }

        update targetList;

    }
}