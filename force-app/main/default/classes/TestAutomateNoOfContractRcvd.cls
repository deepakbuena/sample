@isTest
public class TestAutomateNoOfContractRcvd {
        
     Static testMethod void AutomateNoOfContractRcvdTest(){
        Test.StartTest();
        Integer noOfChecked = -4; 
        User us = [select id from user where Profile.Name = 'System Administrator' and IsActive = True LIMIT 1];
        Mutually_Agreed_to_Objectives__c M2O = new Mutually_Agreed_to_Objectives__c();
        M2O.Number_of_Contracts_Received__c = null ;
        M2O.objective_plan_date__c = System.Today() ;
        M2O.Name = 'TestName' ;
        M2O.Regional_Manager__c = us.id ;
        M2O.Targeted_Substantive_Visits_for_Month__c = 1 ;
        M2O.Number_of_Expected_Contracts__c = 1;
        M2O.Expected_Contract_1_Recv_d_Closed__c = true ;
        M2O.Expected_Contract_2_Recv_d_Closed__c = true ;
        M2O.Expected_Contract_3_Recv_d_Closed__c = true ;
        insert M2O ;       
        
        M2O.Number_of_Contracts_Received__c = 4 ;
        M2O.Expected_Contract_1_Recv_d_Closed__c = false ;
        M2O.Expected_Contract_2_Recv_d_Closed__c = false ;
        M2O.Expected_Contract_3_Recv_d_Closed__c = false ;
        update M2O ;
        
        M2O.Number_of_Contracts_Received__c = null ;
        M2O.Expected_Contract_1_Recv_d_Closed__c = true ;
        M2O.Expected_Contract_2_Recv_d_Closed__c = true ;
        M2O.Expected_Contract_3_Recv_d_Closed__c = true ;
        update M2O ;        
        
        Test.StopTest();  
    }
}