/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAccountRiskReasonsController {

    static testMethod void myUnitTest() {
        
        Account accNew=new Account(Name='Test');
        insert accNew;
        
        integer sortNo=1;
        SecondaryRisk__c sTemp =NEW SecondaryRisk__c();
        sTemp.name='Reason1';
       
        SecondaryRisk__c sTemp2 =NEW SecondaryRisk__c();
        sTemp2.name='Reason12';

        SecondaryRisk__c sTemp3 =NEW SecondaryRisk__c();
        sTemp3.name='Reason3';
        
        insert sTemp;
        insert sTemp2;
        insert sTemp3;
        
        Secondary_Risk_Lost_Reason__c sNew=new Secondary_Risk_Lost_Reason__c();
        sNew.Name='Reason1';
        sNew.sort_Order__C=1;
        sNew.ParentId__C=accNew.id;
        
        Secondary_Risk_Lost_Reason__c sNew2=new Secondary_Risk_Lost_Reason__c();
        sNew2.Name='Reason1';
        sNew2.sort_Order__C=1;
        sNew2.ParentId__C=accNew.id;
        
        insert sNew;
        insert sNew2;
        
        PageReference pNew=Page.AccountRiskReasons;
        Test.setCurrentPage(pNew);
        ApexPages.CurrentPage().getParameters().put('id',accNew.id);
        ApexPages.standardController controller = new ApexPages.standardController(accNew);
        AccountRiskReasonsController aCtrl=new AccountRiskReasonsController(controller );

    }
    
        static testMethod void myUnitTest2() {
        
        Account accNew=new Account(Name='Test');
        insert accNew;        
        
        PageReference pNew=Page.AccountRiskReasons;
        Test.setCurrentPage(pNew);
        ApexPages.CurrentPage().getParameters().put('id',accNew.id);
        ApexPages.standardController controller = new ApexPages.standardController(accNew);
        AccountRiskReasonsController aCtrl=new AccountRiskReasonsController(controller );

    }
}