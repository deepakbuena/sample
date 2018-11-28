@isTest
private class TestvalidateM20ForASPFiscalYear {
    static testmethod void validateM20ForASPFiscalYear() {
    
        Datetime myDateTime1 = Datetime.newInstance(2017, 07, 01);
        Datetime myDateTime2 = Datetime.newInstance(2019, 06, 30);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
            
        Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name='BusDev Plan FY2018 DTeam@GS',Start_Date__c = myDateTime1.date(),End_Date__c = myDateTime2.date());
        insert asp;
           
        Mutually_Agreed_to_Objectives__c mutualObj =  new Mutually_Agreed_to_Objectives__c();
        mutualObj.Name='Test M20 2';
        mutualObj.Targeted_Substantive_Visits_for_Month__c = 12;
        mutualObj.Number_of_Expected_Contracts__c = 10;
        mutualObj.objective_plan_date__c= system.today();
        mutualObj.Regional_Account_Executive__c=u.id;
        mutualObj.Annual_Sales_Plan__c= asp.id;
        insert mutualObj;
                
        Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2018 DTeam@GS',Start_Date__c = System.today(),End_Date__c = System.today().addmonths(7));
        insert asp1;
        
        try{
            mutualObj.Annual_Sales_Plan__c= asp1.id;
            update mutualObj;
        }
        catch(Exception e){
        }
        
     }
}