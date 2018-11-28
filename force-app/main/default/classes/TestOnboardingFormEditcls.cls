@isTest
private class TestOnboardingFormEditcls{

    static testmethod void testMethod1() {
      
              
            RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='School'];           
            Account acc = new Account(Name = 'Onboarding Test Acc',RecordTypeId=rt.id,Type='School - 3 Year School');
            insert acc;
            
            Account acc1 = new Account(Name = 'Onboarding Test Acc1',RecordTypeId=rt.id,Type='School - 4 Year School');
            insert acc1;
                                 
            Onboarding_Form__c onn = new Onboarding_Form__c(School_Name__c = acc.Id);
            Onboarding_Form__c onn1 = new Onboarding_Form__c(School_Name__c = acc1.Id);
                 
            OnboardingFormEditcls obj = new OnboardingFormEditcls (new ApexPages.StandardController(onn));
            obj.saveOff();
            OnboardingFormEditcls obj1 = new OnboardingFormEditcls (new ApexPages.StandardController(onn1));
            obj1.saveOff();
            
            
    }
}