@isTest

private class TestAnnualSalesPlanNewButton{

    static testMethod void aspButtonTest(){
    
        Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c();
        ApexPages.StandardController apsc = new ApexPages.StandardController(asp);
        AnnualSalesPlanNewButton aspButton = new AnnualSalesPlanNewButton(apsc);
        aspButton.init();
    }
}