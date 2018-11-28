@isTest
public class TestCaseBarrierController {
static testMethod void CaseBarrierMultiPickTestMethod(){
        
        Test.startTest();
        Account accNew = new Account();        
        accNew.Name = 'College Planning Services';
        insert accNew;

        Contact contactA = new Contact();
        contactA.FirstName = 'John';
        contactA.Lastname = 'Doe';
        contactA.AccountId = accNew.Id;
        insert contactA;
    
        Case casevalue = new Case();
        casevalue.AccountId = accNew.Id;
        casevalue.Origin = 'Email';
        casevalue.Subject = 'Test';
        casevalue.Status = 'WIP';
        casevalue.Type = 'Implementation';
        casevalue.ContactId = contactA.Id;
        casevalue.Barrier__c = 'No Implementation Call' + ';' + 'Demographic File' + ';' ;
        casevalue.Barrier_to_Implementation__c = '';
        Insert casevalue;
        System.debug('casevalue '+casevalue);
        
        CaseBarrier__c cb1 =NEW CaseBarrier__c();
        cb1.name='Reason1';
        insert cb1;
       
        CaseBarrier__c cb2 =NEW CaseBarrier__c();
        cb2.name='Reason12';
        insert cb2;

        CaseBarrier__c cb3 =NEW CaseBarrier__c();
        cb3.name='Reason3';
        insert cb3;
       
       List<Case_Barrier__c> barrier = new List<Case_Barrier__c>{};
      for(Integer i = 0; i < 30; i++){
        Case_Barrier__c bar = new Case_Barrier__c(Name = 'Test Case Barrier ' + i , Case__c = casevalue.id , Sort_Order_No__c = 7 );
        barrier.add(bar);
      }
        insert barrier;
        System.debug('barrier'+barrier);
        
        PageReference pageRef = Page.CaseBarrier;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',casevalue.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(casevalue);
        CaseBarrierController controller = new CaseBarrierController(sc);
        MultiselectController mCtrl=new MultiselectController ();
        mCtrl.accountId=accNew.id;
        mCtrl.leftOptions= new List<SelectOption>();
        mCtrl.rightOptions=new List<SelectOption>();
        mCtrl.leftOptions.add(new SelectOption('Reason1','Reason1'));
        mCtrl.rightOptions.add(new SelectOption('Reason2','Reason2'));
        mCtrl.rightOptionsHidden='Reason2&Reason2';
        mCtrl.leftOptionsHidden='Reason1&Reason1';
        mCtrl.accid=casevalue.id;
        mCtrl.sobjType='Case';
        mCtrl.saveCase();
        
        Test.stopTest();
        }
        
       static testMethod void myUnitTest2() {
        
        Test.startTest();
        Account accNew = new Account();        
        accNew.Name = 'College Planning Services';
        insert accNew;

        Contact contactA = new Contact();
        contactA.FirstName = 'John';
        contactA.Lastname = 'Doe';
        contactA.AccountId = accNew.Id;
        insert contactA;
    
        Case casevalue = new Case();
        casevalue.AccountId = accNew.Id;
        casevalue.Origin = 'Email';
        casevalue.Subject = 'Test';
        casevalue.Status = 'WIP';
        casevalue.Type = 'Implementation';
        casevalue.ContactId = contactA.Id;
        Insert casevalue;
        System.debug('casevalue '+casevalue);
        
        PageReference pNew=Page.AccountRiskReasons;
        Test.setCurrentPage(pNew);
        ApexPages.CurrentPage().getParameters().put('id',casevalue.id);
        ApexPages.standardController controller = new ApexPages.standardController(casevalue);
        CaseBarrierController caseCtrl = new CaseBarrierController(controller );
        
        Test.stopTest();
   
    }
}