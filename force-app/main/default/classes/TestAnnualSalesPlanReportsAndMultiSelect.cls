@isTest
public class TestAnnualSalesPlanReportsAndMultiSelect{ 
    
    @isTest(SeeAllData='true')
    static void annualSalesPlanReports() {

        Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GS',OwnerId = UserInfo.getUserId(),Start_Date__c = System.Today().addMonths(11),End_Date__c = System.Today());
        insert asp;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(asp);
        AnnualSalesPlanReports aspReports = new AnnualSalesPlanReports(sc);
        
    }
    
    static testmethod void multiselectControllerType() {

        MultiselectControllerType mct = new MultiselectControllerType();
        mct.leftOptions = new List<SelectOption>();
        mct.leftOptions.add(new SelectOption('abc','abc'));
        mct.rightOptions = new List<SelectOption>();
        mct.rightOptions.add(new SelectOption('abc','abc'));
        mct.leftOptionsHidden = 'abc&def';
        mct.rightOptionsHidden = 'abc&def';
    }
}