/**
@Name            : EventCheckInFormControllerTest
@Author          : Ashutosh
@Date            : July 5 2018
@Description     : Test class for 'EventCheckInFormController' Class 
**/
@isTest

private class EventCheckInFormControllerTest
{
    static testmethod void TestEventCheckInFormController() {
        Test.startTest();
        
        RecordType camprt = [SELECT Id,Name FROM RecordType WHERE SobjectType='contact' AND Name='CPS - EOC']; 
        RecordType camprt2 = [SELECT Id,Name FROM RecordType WHERE SobjectType='contact' AND Name='CPS - TS']; 
         
        Account accNew = new Account();     
        accNew.name='College Planning Services '+system.today().year();        
        insert accNew;
    
        Contact conNew = new Contact(LastName = 'Test Con1',FirstName ='test First',BirthDate_Text__c= 'date.today()-2220',AccountId = accNew.Id, Title = 'Test',recordTypeId =camprt.Id);
        insert conNew;
        
        Contact conRecord = [SELECT Id,LastName FROM Contact WHERE Id =: conNew.Id];
        System.assertEquals('Test Con1',conRecord.LastName); 
        
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference'];
        
        Campaign camp = new Campaign(Name='Campaign1',RecordTypeId= rt.id,Location__c='Test loc',CPS_Center_Affiliation_Intake_Location__c = 'EOC Boston',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing;Testingnew',Presenting__c='Testingnew',isActive=true);             
        insert camp;
        
        Campaign campRecord = [SELECT Id,Name FROM Campaign WHERE Id =: camp.Id];
        System.assertEquals('Campaign1',campRecord.Name);
        
        
        Cookie cookie = new Cookie('campId', camp.id, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        
        EventCheckInFormController aCtrl=new EventCheckInFormController ();
        
        aCtrl.firstName = 'test First';
        aCtrl.lastName= 'Test Con2';
        aCtrl.studentId = '456852';
        aCtrl.birthDate = Date.newInstance(2016, 12, 9);
        aCtrl.email = 'test@gmail.com';
        aCtrl.mobilePhone = '9999999999';
        //aCtrl.CPS_Center_Affiliation_Intake_Location__c = 'EOC Boston';
        aCtrl.createRecords();
        aCtrl.createContact();
        aCtrl.okPopUp();
        aCtrl.cancelPopUp();
        aCtrl.createCampaignMember(conNew.Id);
        
        PageReference pageRef = Page.EventCheckIn;
        Test.setCurrentPage(pageRef);
        Test.stopTest();
    }
    
    static testmethod void TestEventCheckInFormController2() {
        Test.startTest();
        
            RecordType camprt = [SELECT Id,Name FROM RecordType WHERE SobjectType='contact' AND Name='CPS - EOC']; 
            RecordType camprt2 = [SELECT Id,Name FROM RecordType WHERE SobjectType='contact' AND Name='CPS - TS']; 
            system.debug('=========camprt2'+camprt2);
             
            Account accNew = new Account();     
            accNew.name='College Planning Services '+system.today().year();       
            insert accNew;
        
            
            Contact conNew2 = new Contact(LastName = 'Test Con11',FirstName ='test First1',BirthDate_Text__c= 'date.today()-2220',AccountId = accNew.Id, Title = 'Test',recordTypeId =camprt2.Id);
            insert conNew2;
            
            Contact conRecord2 = [SELECT Id,LastName FROM Contact WHERE Id =: conNew2.Id];
            System.assertEquals('Test Con11',conRecord2.LastName);  
            
            
            RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference'];
            
            Campaign camp = new Campaign(Name='Campaign1',RecordTypeId= rt.id,Location__c='Test loc',CPS_Center_Affiliation_Intake_Location__c = 'TS Boston',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing;Testingnew',Presenting__c='Testingnew',isActive=true);             
            insert camp;
            
            Campaign campRecord2 = [SELECT Id,Name FROM Campaign WHERE Id =: camp.Id];
            System.assertEquals('Campaign1',campRecord2.Name);
            
            
            Cookie cookie = new Cookie('campId', camp.id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookie});
            
            //ApexPages.CurrentPage().getCookies().put('campId',new Cookie(cookie));
            EventCheckInFormController aCtrl=new EventCheckInFormController ();
            
            aCtrl.redirectToHome();
            //aCtrl.createCampaignMember();
             aCtrl.firstName = 'test First2111';
            aCtrl.lastName= 'test last name 001';
            aCtrl.studentId = '456852';
            aCtrl.birthDate = Date.newInstance(2016, 12, 9);
            aCtrl.email = 'test@gmail.com';
            aCtrl.mobilePhone = '9999999999';
            aCtrl.createRecords();
            //aCtrl.createContact();
            aCtrl.okPopUp();
            aCtrl.cancelPopUp();
            aCtrl.createCampaignMember(conNew2.Id);
            
            PageReference pageRef = Page.EventCheckIn;
            //pageRef.getParameters().put('campId', aCtrl.campId);
            Test.setCurrentPage(pageRef);
            
            
            Test.stopTest();
    }
}