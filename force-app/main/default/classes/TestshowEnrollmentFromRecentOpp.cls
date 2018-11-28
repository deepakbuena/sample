@isTest
private class TestshowEnrollmentFromRecentOpp
{
    static testmethod void showEnrollmentFromRecentOpp() {
        
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='School'];
            
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rt1.id;
        insert acc;
      
        Opportunity opp = new Opportunity();  
        opp.name = 'Test2014' ;     
        opp.Type = 'Standard' ;
        opp.Accountid = acc.id ;
        opp.LeadSource = 'Web' ;
        opp.StageName = 'Prospect' ;
        opp.CloseDate = date.Today() ;
        opp.Total_in_Enrollment__c=7;
        insert opp ;  
            
        Datetime yesterday = Datetime.now().addDays(-14);
        Test.setCreatedDate(opp.Id, yesterday);
        
        Opportunity opp1 = new Opportunity();  
        opp1.name = 'Test2014' ;     
        opp1.Type = 'Standard' ;
        opp1.Accountid = acc.id ;
        opp1.LeadSource = 'Web' ;
        opp1.StageName = 'Prospect' ;
        opp1.CloseDate = date.Today() ;
        opp1.Total_in_Enrollment__c=12;
        insert opp1 ;  
            
        Datetime yesterday1 = Datetime.now();
        Test.setCreatedDate(opp1.Id, yesterday1);
     }
}