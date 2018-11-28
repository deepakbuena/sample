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
public class TestTaskFlagCheckTrigger {
    static testMethod void TaskFlagCheckTriggerTestMethod()
   {     
        test.starttest();
            Account acct1 = new Account();        
            acct1.Name = 'acct1';
            insert acct1;
    
            Opportunity opp = new Opportunity();
            opp.AccountId = acct1.id;
            opp.Name = 'Test 2017';
            opp.Type = 'For-Profit School';
            opp.LeadSource = 'Advertisement';
            opp.CloseDate = Date.today() + 90  ;
            opp.StageName = 'Prospect';
            insert opp;
       
            Task tsk = new Task();
            tsk.OwnerId = UserInfo.getUserId();
            tsk.Subject='Test';
            tsk.Status='Not Started';
            tsk.Priority='Normal';
            tsk.Type = 'Email';
            tsk.WhatId = opp.id;
            insert tsk;
        test.stopTest();
    }

}