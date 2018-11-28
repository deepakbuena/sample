/**
@Name            : TSFormControllerTest
@Description     : Test class for 'TSFormController' Class 
**/

@isTest
public class TSFormControllerTest{
    @isTest
    public static void unitTest(){
     Cookie locName = new Cookie('locname', 'TS Boston', null, -1, false);
        Pagereference pr = new PageReference('/apex/TSSignOn');
        pr.setCookies(new Cookie[] {locName });
        TSFormController objTSFormController = new TSFormController();  
        objTSFormController.firstName = 'Jon';
        objTSFormController.lastName = 'Carter';
        objTSFormController.street = 'Test';
        objTSFormController.zipCode = '45678';
        objTSFormController.city = 'Test';
        objTSFormController.country = 'Test';
        objTSFormController.state = 'Test';
        objTSFormController.preferredPhoneType = 'Home';
        objTSFormController.isMobileParentGuardians = True;
        objTSFormController.homePhone = '9871876934';
        objTSFormController.isMobileOktoText = 'yes';
        objTSFormController.isHomeParentGuardians = True;
        objTSFormController.otherPhone = '9805552345';
        objTSFormController.isOtherParentGuardians = False;
        objTSFormController.genderIdentity = 'Male';
        objTSFormController.school = 'Charlestown High School';
        objTSFormController.ethnicity = 'Asian (NonH/L)';
        objTSFormController.schoolOther = 'Test';
        objTSFormController.usCitizen = 'Yes';
        objTSFormController.currentGradeLevel = '12th grade';
        objTSFormController.permanentResidentId = '56789';
        objTSFormController.socialSecurityNumber = '000';
        objTSFormController.motherGuardian1FirstName = 'Test';
        objTSFormController.motherGuardian1LastName = 'Test';
        objTSFormController.fatherGuardian2FirstName = 'Test';
        objTSFormController.fatherGuardian2LastName = 'Test';
        objTSFormController.parentEmail = 'test@gmail.com';
        objTSFormController.isMotherCollgGrad = 'Yes';
        objTSFormController.isFatherCollgGrad = 'Yes';
        objTSFormController.motherCollg = 'test';
        objTSFormController.fatherCollg = 'test';
        objTSFormController.annualTaxIncome = '$18,211 – 24,690 (2018)';
        objTSFormController.houseHoldSize = 5;
        objTSFormController.email = 'test@gmail.com';
        objTSFormController.mobilePhone = '9874563845';
        objTSFormController.birthDate = System.Today();
        objTSFormController.middleInitials = 'K';
        objTSFormController.isOtherParentGuardians = False;
        objTSFormController.otherPrograms = 'Test';
        objTSFormController.tutorialTopic = 'test';
        objTSFormController.studentId ='0000';
        objTSFormController.statementOfNeed = 'Academic Advising';
        objTSFormController.purposeOfVisit = 'Test';
        objTSFormController.purposeofVisitOther = 'Test';
        
        objTSFormController.registerContact();
        objTSFormController.registerIntakeContact();
    }
    
     @isTest
    public static void lastMatchedContact() {
        Id recTypeCPS_TS = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - TS').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'College Planning Services';
        insert acc;
        
        Contact conRec = new Contact();
        conRec.LastName = 'Stewart';
        conRec.FirstName = 'John';
        conRec.Student_ID__c = '123456';
        conRec.AccountId = acc.Id;
        conRec.Email = 'Test@gmail.com';
        conRec.birthDate = System.Today();
        conRec.recordTypeID=recTypeCPS_TS ;
        conRec.Intake_Location__c = 'TS Boston';
        conRec.Intake_Date__c = Date.newInstance(2018, 1, 1);
        insert conRec;
        
        Contact contactRec = [Select Id,LastName from Contact Where Id =: conRec.Id];
        System.assertEquals(contactRec.LastName,'Stewart');
        
        Cookie locName = new Cookie('locname', 'TS Boston', null, -1, false);
        Pagereference pr = new PageReference('/apex/TSSignOn');
        pr.setCookies(new Cookie[] {locName });
        TSFormController objTSFormController = new TSFormController();
        objTSFormController.currentDate = System.today();
        objTSFormController.LastName = 'Stewart';
        objTSFormController.FirstName = 'John';
        objTSFormController.Email = 'Test@gmail.com';
        objTSFormController.birthDate = System.today();
        objTSFormController.studentId = '0000';
         
        objTSFormController.registerContact();
    }
    
    @isTest
    public static void lastMatchedExpContact() {
        Id recTypeCPS_TS = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - TS').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'College Planning Services';
        insert acc;
        
        Contact conRec = new Contact();
        conRec.LastName = 'Stewart';
        conRec.FirstName = 'John';
        conRec.Student_ID__c = '123456';
        conRec.AccountId = acc.Id;
        conRec.Email = 'Test@gmail.com';
        conRec.birthDate = System.Today();
        conRec.recordTypeID=recTypeCPS_TS ;
        insert conRec;
        
        Contact contactRec = [Select Id,LastName from Contact Where Id =: conRec.Id];
        System.assertEquals(contactRec.LastName,'Stewart');
        
        Cookie locName = new Cookie('locname', 'TS Boston', null, -1, false);
        Pagereference pr = new PageReference('/apex/TSSignOn');
        pr.setCookies(new Cookie[] {locName });
        TSFormController objTSFormController = new TSFormController();
        objTSFormController.currentDate = Date.newInstance(1800, 1, 1);
        objTSFormController.LastName = 'Stewart';
        objTSFormController.FirstName = 'John';
        objTSFormController.Email = 'Test@gmail.com';
        objTSFormController.birthDate = System.today();
        objTSFormController.studentId = '0000'; 
        objTSFormController.registerContact();
    }
    
}