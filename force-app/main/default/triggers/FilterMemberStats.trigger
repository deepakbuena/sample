trigger FilterMemberStats on Insight_Data_Storage__c (before insert, after insert, after Update){
	if(trigger.isBefore && trigger.isInsert){
		List<Insight_Data_Storage__c> exIds = new List<Insight_Data_Storage__c>([Select Id from Insight_Data_Storage__c where CreatedDate < N_Days_Ago:10]);
        if(exIds.size()>0){
            Failed_Insight_Data_Storage__c fids = [Select Id, Flag__c from Failed_Insight_Data_Storage__c where Name = 'Default'];
            if(fids.Flag__c){
                fids.Flag__c = False;
                update fids;
            }
        	delete exIds;
        }
    }
    if(trigger.isAfter){
        List<Member_Stats__c> newMbrSts = new List<Member_Stats__c>();
        List<String> cstCodes = new List<String>();
        List<String> oeCodes = new List<String>();
        List<Insight_Data_Storage__c> failIds = new List<Insight_Data_Storage__c>();
        for(Insight_Data_Storage__c i: trigger.new){
            if(i.Customer_Code__c != Null){
                CstCodes.add(i.Customer_Code__c);
            }
            if(i.OE_Code__c != Null){
                oeCodes.add(i.OE_Code__c);
            }
        }
        Map<String, Id> AccMap = new Map<String, Id>();
        for(Account a :[Select Id, Customer_Code__c, OE_Code__c from Account where Customer_Code__c IN :cstCodes or OE_Code__c IN :oeCodes]){
            if(a.Customer_Code__c != Null){
                AccMap.put(a.Customer_Code__c, a.Id);
            }
            if(a.OE_Code__c != Null){
                AccMap.put(a.OE_Code__c, a.Id);
            }
        }
        if(trigger.isInsert){
            for(Insight_Data_Storage__c ids :trigger.new){
                if(ids.Customer_Code__c != Null && AccMap.size()>0 && AccMap.containsKey(ids.Customer_Code__c)){
                    Member_Stats__c ms1 = new Member_Stats__c(Account__c = AccMap.get(ids.Customer_Code__c),
                                                            Avg_Course_Grade__c = ids.Avg_Course_Grade__c,
                                                            Avg_Duration_Minutes__c = ids.Avg_Duration_Minutes__c,
                                                            Avg_Page_Views__c = ids.Avg_Page_Views__c,
                                                            Total_Page_Views__c = ids.Total_Page_Views__c,
                                                            Members_Activated__c = ids.Members_Activated__c,
                                                            Members_Deactivated__c = ids.Members_Deactivated__c,
                                                            Members_Invited__c = ids.Members_Invited__c,
                                                            Month_End__c = ids.Month_End__c,
                                                            Number_Courses__c = ids.Number_Courses__c);
                    newMbrSts.add(ms1);
                }
                else if(ids.OE_Code__c != Null && AccMap.size()>0 && AccMap.containsKey(ids.OE_Code__c)){
                    Member_Stats__c ms2 = new Member_Stats__c(Account__c = AccMap.get(ids.OE_Code__c),
                                                            Avg_Course_Grade__c = ids.Avg_Course_Grade__c,
                                                            Avg_Duration_Minutes__c = ids.Avg_Duration_Minutes__c,
                                                            Avg_Page_Views__c = ids.Avg_Page_Views__c,
                                                            Total_Page_Views__c = ids.Total_Page_Views__c,
                                                            Members_Activated__c = ids.Members_Activated__c,
                                                            Members_Deactivated__c = ids.Members_Deactivated__c,
                                                            Members_Invited__c = ids.Members_Invited__c,
                                                            Month_End__c = ids.Month_End__c,
                                                            Number_Courses__c = ids.Number_Courses__c);
                    newMbrSts.add(ms2);
                }
                else{
                    Insight_Data_Storage__c ids1 = new Insight_Data_Storage__c(id= ids.Id, Failed__c = True);
                    failIds.add(ids1);
                }
            }
            if(newMbrSts.size()>0){
                insert newMbrSts;
            }
            if(failIds.size()>0){
                update failIds;
                Failed_Insight_Data_Storage__c fids = [Select Id, Flag__c from Failed_Insight_Data_Storage__c where Name = 'Default'];
                if(!fids.Flag__c){
                    fids.Flag__c = True;
                    update fids;
                    SendMail.failIds();
                }
            }
        }
        else if(trigger.isUpdate){
            List<Insight_Data_Storage__c> upIds = new List<Insight_Data_Storage__c>();
            for(Insight_Data_Storage__c ids:trigger.new){
                if(ids.Failed__c == True){
                    if(ids.Customer_Code__c != Null && AccMap.size()>0 && AccMap.containsKey(ids.Customer_Code__c)){
                        Insight_Data_Storage__c ids2 = new Insight_Data_Storage__c(id= ids.Id, Failed__c = False);
                    	upIds.add(ids2);
                        Member_Stats__c ms3 = new Member_Stats__c(Account__c = AccMap.get(ids.Customer_Code__c),
                                                            Avg_Course_Grade__c = ids.Avg_Course_Grade__c,
                                                            Avg_Duration_Minutes__c = ids.Avg_Duration_Minutes__c,
                                                            Avg_Page_Views__c = ids.Avg_Page_Views__c,
                                                            Total_Page_Views__c = ids.Total_Page_Views__c,
                                                            Members_Activated__c = ids.Members_Activated__c,
                                                            Members_Deactivated__c = ids.Members_Deactivated__c,
                                                            Members_Invited__c = ids.Members_Invited__c,
                                                            Month_End__c = ids.Month_End__c,
                                                            Number_Courses__c = ids.Number_Courses__c);
                    	newMbrSts.add(ms3);
                    }
                    else if(ids.OE_Code__c != Null && AccMap.size()>0 && AccMap.containsKey(ids.OE_Code__c)){
                    	Insight_Data_Storage__c ids3 = new Insight_Data_Storage__c(id= ids.Id, Failed__c = False);
                    	upIds.add(ids3);
                        Member_Stats__c ms4 = new Member_Stats__c(Account__c = AccMap.get(ids.OE_Code__c),
                                                            Avg_Course_Grade__c = ids.Avg_Course_Grade__c,
                                                            Avg_Duration_Minutes__c = ids.Avg_Duration_Minutes__c,
                                                            Avg_Page_Views__c = ids.Avg_Page_Views__c,
                                                            Total_Page_Views__c = ids.Total_Page_Views__c,
                                                            Members_Activated__c = ids.Members_Activated__c,
                                                            Members_Deactivated__c = ids.Members_Deactivated__c,
                                                            Members_Invited__c = ids.Members_Invited__c,
                                                            Month_End__c = ids.Month_End__c,
                                                            Number_Courses__c = ids.Number_Courses__c);
                    	newMbrSts.add(ms4);
                    }
                    if(newMbrSts.size()>0){
                        insert newMbrSts;
                    }
                    if(upIds.size()>0){
                        update upIds;
                    }
                }
            }
		}
    }
}