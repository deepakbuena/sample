@isTest
private class TestQuarterlyResultsController {
    static testMethod void validateQuarterlyResultsController(){
        Test.startTest();
        Date dt = date.today();
        Account acc1 = new Account(Name = 'a1');
        insert acc1;
        Account acc2 = new Account(Name = 'a2');
        insert acc2;
        
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity(Name = 'o1_2016', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.today()+90, StageName = 'Implementation');
        oppList.add(opp1);
        Opportunity opp2 = new Opportunity(Name = 'o2_2016', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.today()+91, StageName = 'In Production');
        oppList.add(opp2);
        Opportunity opp3 = new Opportunity(Name = 'o3_2016', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'Advertisement', CloseDate = Date.today().addDays(30), StageName = 'Verbal Committment');
        oppList.add(opp3);
        Opportunity opp4 = new Opportunity(Name = 'o4_2016', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'Advertisement', CloseDate = Date.today()+92, StageName = 'Closed - Won');
        oppList.add(opp4);
        insert oppList; 
        
        Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name = 'asp1',Start_Date__c=Date.Today(),End_Date__c=Date.Today().addDays(60));
        insert asp1;
        
        ApexPages.StandardController apsc = new ApexPages.StandardController(asp1);
        QuarterlyResultsController qtr =  new QuarterlyResultsController(apsc);
        Test.stopTest();

    }

}