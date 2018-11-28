@isTest
public class TestCaseBarrierMultiPickController{
    static testMethod void CaseBarrierMultiPickTestMethod(){
    
        Test.startTest();
        
        Account accNew = new Account();        
        accNew.Name = ' College Planning Services';
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
        
        Case_Barrier__c barrier1 = new Case_Barrier__c();
        barrier1.Name = 'Test';
        barrier1.Case__c = casevalue.id;
        barrier1.Sort_Order_No__c = 7 ;
        insert barrier1;
        
        PageReference pageRef = Page.CaseBarrierMultiPick;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',casevalue.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(casevalue);
        CaseBarrierMultiPickController controller = new CaseBarrierMultiPickController();
        controller.message = '';
        controller.PrimaryMessage = '';
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
}