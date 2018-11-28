@isTest

private class TestUpdateEnrollmentActual {

    static testmethod void EnrollmentActualASPTest() {
       
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
        
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing',FirstName='User', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='stanser@testorg.com');
            insert u;
            
            Account acc = new Account(Name = 'Account New');
            insert acc;
            
            Opportunity opp = new Opportunity(Name='OppASP-2014',AccountId=acc.Id,Type='Standard',StageName='Closed - Won',LeadSource='Web',CloseDate=System.Today(),Total_in_Enrollment__c=10,OwnerId =  u.Id);
            insert opp;
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name='BusDev Plan FY2016 UTesting',OwnerId = u.Id);
            insert asp;
            
            opp.Total_in_Enrollment__c = 20;
            update opp;
            
            Opportunity opp2 = new Opportunity(Name='OppASP-2015',AccountId=acc.Id,Type='Standard',StageName='Closed - Won',LeadSource='Web',CloseDate=System.Today(),Total_in_Enrollment__c=20,OwnerId =  u.Id);
            insert opp2;
                        
        }
    }
}