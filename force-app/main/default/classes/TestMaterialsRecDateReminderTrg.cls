@isTest
public class TestMaterialsRecDateReminderTrg {
        
     Static testMethod void MaterialsRecDateReminderTrgTest(){
        Test.StartTest();
        Boolean blankFlag = true ;
        Boolean sendEmail = true ;
        Id campRecTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Conference').getRecordTypeId();
        Campaign c = new Campaign();
        c.Name = 'Testing';
        c.RecordTypeId = campRecTypeId ;
        c.Primary_BD__c = 'Buena Cloud Development';
        c.X10_Days_Date_Received_Reminder__c = false;
        c.X20_Days_Date_Received_Reminder__c = false;
        insert c;
               
        c.X10_Days_Date_Received_Reminder__c = true;
        c.X20_Days_Date_Received_Reminder__c = true;
        update c; 
        
        Campaign c1 = new Campaign();
        c1.Name = 'Testing';
        c1.Primary_BD__c = 'Buena Cloud Development' ;        
        c1.X20_Days_Date_Received_Reminder__c = true ;
        c1.X10X10_Booth_Received_Date__c = null ;
        c1.Banner_Received_Date__c = null ;
        c1.Business_Card_Holder_Received_Date__c = null ;
        c1.Collateral_Holder_Received_Date__c = null ;
        c1.iPad_Stand_Received_Date__c = null ;
        c1.Tablecloth_Received_Date__c = null ;        
        insert c1;
                                      
        Test.StopTest();  
    }
}