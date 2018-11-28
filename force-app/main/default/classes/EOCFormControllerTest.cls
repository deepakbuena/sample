/**
@Name            : EOCFormControllerTest
@Description     : Test class for 'EOCFormController' Class 
**/
@isTest
public class EOCFormControllerTest{
    
    @testSetup static void setup() {
        List<CPS_Picklist_Config__c> lstPicklistConfig = new List<CPS_Picklist_Config__c>();
        
        CPS_Picklist_Config__c cpsPk1   = new CPS_Picklist_Config__c();
        cpspk1.Name                     = 'Suffix';
        cpspk1.Picklist_API_Name__c     = 'Suffix__c';
        cpsPk1.Valid_Values__c          = 'I;II;III;IV;V;Jr;Sr';
        cpsPk1.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpspk1);
        
        CPS_Picklist_Config__c cpsPk2   = new CPS_Picklist_Config__c();
        cpspk2.Name                     = 'Preferred_Phone_Type__c';
        cpspk2.Picklist_API_Name__c     = 'Preferred_Phone_Type__c';
        cpsPk2.Valid_Values__c          = 'Home;Mobile;Other';
        cpsPk2.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpspk2);
        
        CPS_Picklist_Config__c cpsPk3   = new CPS_Picklist_Config__c();
        cpspk3.Name                     = 'Is_Mobile_OK_to_Text__c';
        cpspk3.Picklist_API_Name__c     = 'Is_Mobile_OK_to_Text__c';
        cpsPk3.Valid_Values__c          = 'Yes;No';
        cpsPk3.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpspk3);
        
        CPS_Picklist_Config__c cpsPk4   = new CPS_Picklist_Config__c();
        cpspk4.Name                     = 'Preferred_language__c';
        cpspk4.Picklist_API_Name__c     = 'Preferred_language__c';
        cpsPk4.Valid_Values__c          = 'Cantonese;English;French-Creole;Hindi;Mandarin;Nepali;Other;Portuguese;Spanish;Vietnamese';
        cpsPk4.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpspk4);
        
        CPS_Picklist_Config__c cpsPk5   = new CPS_Picklist_Config__c();
        cpsPk5.Name                     = 'Primary_Purpose_of_Visit__c';
        cpsPk5.Picklist_API_Name__c     = 'Primary_Purpose_of_Visit__c';
        cpsPk5.Valid_Values__c          = 'Admission Application Support/Fee Waiver;Career Services/Exploration;Education Info;Essay Writing;Field Trip;Financial Aid Assistance;Interview Prep/Skills Development;Loan Assistance';
        cpsPk5.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk5);
        
        CPS_Picklist_Config__c cpsPk6   = new CPS_Picklist_Config__c();
        cpsPk6.Name                     = 'Gender__c';
        cpsPk6.Picklist_API_Name__c     = 'Gender__c';
        cpsPk6.Valid_Values__c          = 'Female;Male';
        cpsPk6.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk6);
        
        CPS_Picklist_Config__c cpsPk7   = new CPS_Picklist_Config__c();
        cpsPk7.Name                     = 'Ethnicity__c';
        cpsPk7.Picklist_API_Name__c     = 'Ethnicity__c';
        cpsPk7.Valid_Values__c          ='Amer. Indian or Alaska Native (NonH/L);Asian (NonH/L);Black or African American (NonH/L);Hispanic/Latino of any race;Native Hawaiian or Pac. Islander (N-H/L);White (NonH/L)';
        cpsPk7.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk7);
        
        CPS_Picklist_Config__c cpsPk8   = new CPS_Picklist_Config__c();
        cpsPk8.Name                     = 'Is_Father_4yr_U_S_College_Grad__c';
        cpsPk8.Picklist_API_Name__c     = 'Is_Father_4yr_U_S_College_Grad__c';
        cpsPk8.Valid_Values__c          = 'Yes;No (did not attend U.S. college);No (attended some U.S. college);No (completed 2-year U.S. college);No;Unknown';
        cpsPk8.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk8);
        
        CPS_Picklist_Config__c cpsPk9   = new CPS_Picklist_Config__c();
        cpsPk9.Name                     = 'Marital_Status__c';
        cpsPk9.Picklist_API_Name__c     = 'Marital_Status__c';
        cpsPk9.Valid_Values__c          = 'Married;Single;Divorced;Widowed;Separated';
        cpsPk9.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk9);
        
        CPS_Picklist_Config__c cpsPk10   = new CPS_Picklist_Config__c();
        cpsPk10.Name                     = 'Annual_Taxable_Income__c';
        cpsPk10.Picklist_API_Name__c     = 'Annual_Taxable_Income__c';
        cpsPk10.Valid_Values__c          = '$0 – 18,210;$18,211 – 24,690;$24,691 – 31,170;$31,171 – 37,650;$37,651 – 44,130;$44,131 – 50,610;$50,611 – 57,090;$57,091 – 63,570;Over $63,570;Unknown';
        cpsPk10.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk10);
        
        CPS_Picklist_Config__c cpsPk11   = new CPS_Picklist_Config__c();
        cpsPk11.Name                     = 'Is_Mother_4yr_U_S_College_Grad__c';
        cpsPk11.Picklist_API_Name__c     = 'Is_Mother_4yr_U_S_College_Grad__c';
        cpsPk11.Valid_Values__c          = 'Yes;No (did not attend U.S. college);No (attended some U.S. college);No (completed 2-year U.S. college);No;Unknown';
        cpsPk11.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk11);
        
        CPS_Picklist_Config__c cpsPk12   = new CPS_Picklist_Config__c();
        cpsPk12.Name                     = 'Are_you_a_US_Citizen__c';
        cpsPk12.Picklist_API_Name__c     = 'Are_you_a_US_Citizen__c';
        cpsPk12.Valid_Values__c          = 'Yes;No';
        cpsPk12.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk12);
        
        CPS_Picklist_Config__c cpsPk13   = new CPS_Picklist_Config__c();
        cpsPk13.Name                     = 'Primary_Income_Source__c';
        cpsPk13.Picklist_API_Name__c     = 'Primary_Income_Source__c';
        cpsPk13.Valid_Values__c          = 'Child support;No income;Signed Statement;Social Security;SSI or SSDI;TAFDC (welfare);Unemployment;Wages/salary;Other;Unknown';
        cpsPk13.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk13);
        
        CPS_Picklist_Config__c cpsPk14   = new CPS_Picklist_Config__c();
        cpsPk14.Name                     = 'Veteran_Status__c';
        cpsPk14.Picklist_API_Name__c     = 'Veteran_Status__c';
        cpsPk14.Valid_Values__c          = 'Child of Active Duty US Military;Spouse of Active Duty US Military;Active Duty US Military;US Veteran;Not a Veteran';
        cpsPk14.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk14);
        
        CPS_Picklist_Config__c cpsPk15   = new CPS_Picklist_Config__c();
        cpsPk15.Name                     = 'Talent_Search_School__c';
        cpsPk15.Picklist_API_Name__c     = 'Talent_Search_School__c';
        cpsPk15.Valid_Values__c          = 'Ashfield Middle School;Brighton High School;Brockton High School;Community Academy of Science & Health;Davis Middle School;East Middle School;Urban Science Academy;West Roxbury Academy;None of these';
        cpsPk15.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk15);
        
        CPS_Picklist_Config__c cpsPk16   = new CPS_Picklist_Config__c();
        cpsPk16.Name                     = 'Learned_About_Program__c';
        cpsPk16.Picklist_API_Name__c     = 'Learned_About_Program__c';
        cpsPk16.Valid_Values__c          = 'AACA;Attended a Workshop;BHCC;BPL;Call Line;College;Facebook;Flyer;Friend/Relative;High School;Info Session;Internet';
        cpsPk16.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk16);
        
        CPS_Picklist_Config__c cpsPk17   = new CPS_Picklist_Config__c();
        cpsPk17.Name                     = 'Student_Status__c ';
        cpsPk17.Picklist_API_Name__c     = 'Student_Status__c ';
        cpsPk17.Valid_Values__c          = 'Not Currently Attending;Middle School;High School;College Student;Graduate Student;ESL Student;GED/HiSET Student;Vocation/Training Student';
        cpsPk17.RecordTypeId             = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
        lstPicklistConfig.add(cpsPk17);
        
        insert lstPicklistConfig;
    }
    
    
    
    @isTest
    public static void unitTest(){
        Cookie locName = new Cookie('locname', 'Eoc Boston', null, -1, false);
        Cookie locName2 = new Cookie('satelliteloc', 'Copley Square BPL', null, -1, false);
        Pagereference pr = new PageReference('/apex/EOCSignOn');
        pr.setCookies(new Cookie[] {locName,locName2});
        Test.setCurrentPage(pr);       
              
        
        EOCFormController objEOCFormController = new EOCFormController();  
        objEOCFormController.firstName = 'Jon';
        objEOCFormController.lastName = 'Carter';
        objEOCFormController.GenderIdentity = 'Male';
        objEOCFormController.isMotherCollegeGrad = 'Yes';
        objEOCFormController.IsFatherCollegeGrad = 'Yes';
        objEOCFormController.ethnicity = 'Asian (NonH/L)';
        objEOCFormController.maritialStatus = 'Married';
        objEOCFormController.usCitizen = 'Yes';
        objEOCFormController.primaryIncomeSource = 'Social Security';
        objEOCFormController.annualTaxableIncome = '$18,211 – 24,690 (2018)';
        objEOCFormController.veteranStatus = 'Active Duty US Military';
        objEOCFormController.houseHoldSize = 4;
        objEOCFormController.school = 'Ashfield Middle School';
        objEOCFormController.learnAboutProgram = 'Attended a Workshop';
        objEOCFormController.schoolOther = 'Test';
        objEOCFormController.otherLearnedAboutProgram = 'Test';
        objEOCFormController.careerGoals= 'Test';
        objEOCFormController.parentEmail = 'Test@gmail.com';
        objEOCFormController.motherGuardian1FirstName = 'Test';
        objEOCFormController.motherGuardian1LastName = 'Test';
        objEOCFormController.fatherGuardian2FirstName = 'Test';
        objEOCFormController.fatherGuardian2LastName = 'Test';
        objEOCFormController.intakeLocation = 'EOC Boston';
        objEOCFormController.mddleInitials = 'T';
        objEOCFormController.email = 'Test@gmail.com';
        objEOCFormController.birthDate = System.Today().addYears(-50);
        objEOCFormController.preferredPhoneType = 'Home';
        objEOCFormController.mobilePhone = '9871248758';
        objEOCFormController.homePhone = '9871567849';
        objEOCFormController.isMobileParentGuardians = True;
        objEOCFormController.isHomeParentGuardians = false;
        objEOCFormController.isMobileOktoTest = 'yes';
        objEOCFormController.city = 'Test';
        objEOCFormController.state = 'Test';
        objEOCFormController.country = 'Test';
        objEOCFormController.haveAppoinment = True;
        objEOCFormController.preferredLanguage = 'English';
        objEOCFormController.meetAdvisor = True;
        objEOCFormController.additionalLanguage = 'Test';
        objEOCFormController.purposeofVisitOther = 'Test';
        objEOCFormController.isHomeParentGuardians = True;
        objEOCFormController.street = 'Test';
        objEOCFormController.zipCode = '12345';
        objEOCFormController.purposeofVisit = 'Test';
                       
        objEOCFormController.registerLead();
        objEOCFormController.registerIntakeLead();
        objEOCFormController.redirectToHome();
        objEOCFormController.redirectToSignOn();
        
    }
        
    @isTest
    public static void lstMatchedContact() {
        Id recTypeCPS_EOC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - EOC').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'College Planning Services';
        insert acc;
        
        Contact conRec = new Contact();
        conRec.LastName = 'Stewart';
        conRec.FirstName = 'John';
        conRec.AccountId = acc.Id;
        conRec.Email = 'Test@gmail.com';
        conRec.birthDate = System.Today().addYears(-50);
        conRec.recordTypeID=recTypeCPS_EOC;
        conRec.Intake_Location__c = 'EOC Boston';
        conRec.Intake_Date__c = System.Today().addYears(9);
        conRec.Parent_Signature_Needed_Received__c = 'Unknown';
        insert conRec;
        
        Contact contactRec = [Select Id,LastName from Contact Where Id =: conRec.Id];
        System.assertEquals(contactRec.LastName,'Stewart');
        
        Cookie locName = new Cookie('locname', 'Eoc Boston', null, -1, false);
        Cookie locName2 = new Cookie('satelliteloc', 'Copley Square BPL', null, -1, false);
        Pagereference pr = new PageReference('/apex/EOCSignOn');
        pr.setCookies(new Cookie[] {locName,locName2});
        
        EOCFormController objEOCFormController = new EOCFormController();  
        objEOCFormController.FirstName = 'John';
        objEOCFormController.LastName = 'Stewart';
        objEOCFormController.Email = 'Test@gmail.com';
        objEOCFormController.birthDate = System.Today().addYears(-50);
        
        objEOCFormController.registerLead();   
        //objEOCFormController.initializeNewTask('Test','Email',conRec.id,'EOC Bostan');
        
        objEOCFormController.intakeLocation= '';
        objEOCFormController.redirectToHome();
        objEOCFormController.intakeLocation= 'EEE';
        
        objEOCFormController.redirectToHome();
        
        PageReference pageRef = Page.CPS_Input_location;
        Test.setCurrentPage(pageRef);
    }
}