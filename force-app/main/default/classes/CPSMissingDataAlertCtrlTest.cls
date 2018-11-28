@isTest
public class CPSMissingDataAlertCtrlTest
{
    @isTest
    public static void unitTest()
    {
        Account acc = new Account();
        acc.Name = 'College Planning Services 2018';
        insert acc;
        
        Id recTypeCPS_EOC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - EOC').getRecordTypeId();
        Id recTypeCPS_UB = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - UB').getRecordTypeId();
        Contact conRec = new Contact();
        conRec.LastName = 'Doe';
        conRec.FirstName = 'John';
        conRec.Title = 'CEO';
        conRec.AccountId = acc.Id;
        conRec.recordTypeID=recTypeCPS_EOC ;
        conRec.Secondary_School_at_Intake_Picklist__c = 'Brockton High School';
        conRec.Are_you_a_US_Citizen__c= 'No';
        conRec.Resident_Alien_Resident_ID__c = '';
        conRec.Mailingstreet = 'abs';
        conRec.MailingCity   = 'New Yourk';
        conRec.MailingState  = 'New Yourk';
        conRec.MailingCountry ='USA';
        conRec.MailingPostalCode ='23232';
        conRec.Permanent_Resident_ID_Text__c = '3333';
        conRec.Permanent_Resident_ID_Verified__c = false;
        insert conRec;
        
        List<String> lstErrorMsg1 = CPSMissingDataAlertCtrl.getTargetInfo(conRec.id);
        System.assertEquals('ALERT! This Client is attending a Talent Search Target School.',lstErrorMsg1[0]);
        List<String> lstErrorMsg2 = CPSMissingDataAlertCtrl.getAllMissingInfo(conRec.id);
        System.assertEquals(true,String.valueOf(lstErrorMsg2).contains('Income Source'));
        
        conRec.MobilePhone = '125487965';
        conRec.Intake_Location__c = 'UB Brockton';
        conRec.recordTypeID = recTypeCPS_UB;
        update conRec;
        
        List<String> lstErrorMsg3 = CPSMissingDataAlertCtrl.getAllMissingInfo(conRec.id);
        for(String str : lstErrorMsg3){
            System.debug('str>>>>>>>'+str);
        }
        System.assertEquals(true,String.valueOf(lstErrorMsg3).contains('Annual Taxable Income'));
    }
}