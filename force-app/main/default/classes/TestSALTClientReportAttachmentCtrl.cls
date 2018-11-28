@isTest
private class TestSALTClientReportAttachmentCtrl
{

    @isTest(SeeAllData=true)
    static void SALTClientReportAttachmentCtrl() {
        Test.startTest();
        //Contact con = new Contact(LastName='TestCon',AccountId=acc.id);
        //insert con;
                
        //Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
            
        //User userName = [Select id,Email,UserName,ContactId from User where Name='Nancy Agresti'];
        Salt_Client_Reports__c saltreport;
        EntitySubscription es;
        Attachment attch;
        User user ;
        
        UserRole r = new UserRole(DeveloperName = 'System_Administrator', Name = 'System Administrator');
        insert r;
        
        
        User u3 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.Id
        );
        
        
        system.runAs(u3){
           
           
            //UserRole r = new UserRole(DeveloperName = 'PartenaireResponsable', Name = 'PartenaireResponsable');
            //insert r;
            
          Account a = new Account(Name=' College Planning Services');
          insert a;
         
          Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id,FirstName = 'First Name');
          insert c;
 
          user = new User();
          user.ProfileID = [Select Id From Profile Where Name='Customer Community User'].id;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test@appirio.com';   
          user.CommunityNickname = 'testUser123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = c.Id;
         
          insert user;
        }
        
        
        User u1 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             //UserRoleId = r.Id
        );
        system.runAs(u1){
        
             Account acc = new Account(Name='Acc1');
            insert acc;
            Network net = [Select Id,Name from Network where Name='Salt Administrator Portal'];
            
            saltreport = new Salt_Client_Reports__c(Name='Salt Report',Account__c= acc.id);
            insert saltreport;
            
             attch = new Attachment(parentid=saltreport.id,Name='Test Attachment',body=Blob.valueOf('123'));
            insert attch;
            
            //es = new EntitySubscription(ParentId=saltreport.id,SubscriberId=u.id,NetworkId=net.id);
            //insert es;
        
        
        }
        
        
        System.runAs(user ) {

            SALTClientReportAttachmentCtrl.deleteRecord(saltreport.id);
            SALTClientReportAttachmentCtrl.hasUploadPermission();
            SALTClientReportAttachmentCtrl.isRecordFollowed(saltreport.id);
            //SALTClientReportAttachmentCtrl.followRecord(saltreport.id);
            system.debug(saltreport.id);
            SALTClientReportAttachmentCtrl.getAttachmentInfo(saltreport.id);
            //SALTClientReportAttachmentCtrl.getPDFData(attch.id);
            SALTClientReportAttachmentCtrl.saveDownloadSF(attch.id);
            SALTClientReportAttachmentCtrl.getIconName('msword');
            SALTClientReportAttachmentCtrl.getIconName('vnd.openxmlformats-officedocument.wordprocessingml');
            SALTClientReportAttachmentCtrl.getIconName('vnd.ms-word');
            SALTClientReportAttachmentCtrl.getIconName('x-msword');
            SALTClientReportAttachmentCtrl.getIconName('doc');
            SALTClientReportAttachmentCtrl.getIconName('dot');
            SALTClientReportAttachmentCtrl.getIconName('docx');
            SALTClientReportAttachmentCtrl.getIconName('dotx');
            SALTClientReportAttachmentCtrl.getIconName('docm');
            SALTClientReportAttachmentCtrl.getIconName('dotm');
            SALTClientReportAttachmentCtrl.getIconName('vnd.ms-excel');
            SALTClientReportAttachmentCtrl.getIconName('vnd.openxmlformats-officedocument.spreadsheetml');
            SALTClientReportAttachmentCtrl.getIconName('xls');
            SALTClientReportAttachmentCtrl.getIconName('xlt');
            SALTClientReportAttachmentCtrl.getIconName('xla');
            SALTClientReportAttachmentCtrl.getIconName('xltx');
            SALTClientReportAttachmentCtrl.getIconName('xlsm');
            SALTClientReportAttachmentCtrl.getIconName('xltm');
            SALTClientReportAttachmentCtrl.getIconName('xlam');
            SALTClientReportAttachmentCtrl.getIconName('xlsb');
            SALTClientReportAttachmentCtrl.getIconName('xlsx');
            SALTClientReportAttachmentCtrl.getIconName('vnd.ms-powerpoint');
            SALTClientReportAttachmentCtrl.getIconName('x-mspowerpoint');
            SALTClientReportAttachmentCtrl.getIconName('vnd.openxmlformats-officedocument.presentationml');
            SALTClientReportAttachmentCtrl.getIconName('ppt');
            SALTClientReportAttachmentCtrl.getIconName('pot');
            SALTClientReportAttachmentCtrl.getIconName('pps');
            SALTClientReportAttachmentCtrl.getIconName('ppa');
            SALTClientReportAttachmentCtrl.getIconName('pptx');
            SALTClientReportAttachmentCtrl.getIconName('potx');
            SALTClientReportAttachmentCtrl.getIconName('ppsx');
            SALTClientReportAttachmentCtrl.getIconName('ppam');
            SALTClientReportAttachmentCtrl.getIconName('potm');
            SALTClientReportAttachmentCtrl.getIconName('ppsm');
            SALTClientReportAttachmentCtrl.getIconName('pptm');
            SALTClientReportAttachmentCtrl.getIconName('octet-stream');
            SALTClientReportAttachmentCtrl.getIconName('x-zip-compressed');
            SALTClientReportAttachmentCtrl.getIconName('rtf');
            SALTClientReportAttachmentCtrl.getIconName('pdf');
            SALTClientReportAttachmentCtrl.getIconName('xml');
            SALTClientReportAttachmentCtrl.getIconName('eps');
            SALTClientReportAttachmentCtrl.getIconName('bmp');
            SALTClientReportAttachmentCtrl.getIconName('gif');
            SALTClientReportAttachmentCtrl.getIconName('png');
            SALTClientReportAttachmentCtrl.getIconName('img');
            SALTClientReportAttachmentCtrl.getIconName('jpg');
            SALTClientReportAttachmentCtrl.getIconName('html');
            SALTClientReportAttachmentCtrl.getIconName('csv');
            SALTClientReportAttachmentCtrl.getIconName('plain');
            SALTClientReportAttachmentCtrl.getIconName('mp3');
            SALTClientReportAttachmentCtrl.getIconName('wav');
            SALTClientReportAttachmentCtrl.getIconName('mpeg');
            SALTClientReportAttachmentCtrl.getIconName('mp4');
            SALTClientReportAttachmentCtrl.getIconName('vnd.google-apps.document');
            SALTClientReportAttachmentCtrl.getIconName('vnd.google-apps.folder');
            SALTClientReportAttachmentCtrl.getIconName('vnd.google-apps.spreadsheet');
            
            SALTClientReportAttachmentCtrl.onFollowRecord(saltreport.id);
            SALTClientReportAttachmentCtrl.getRecordFollow(saltreport.id);
            SALTClientReportAttachmentCtrl.visitedRecord(saltreport.id);
        }
        
        
        
       
        
        
        Test.stopTest();
    }

    static testMethod void unitTest2()
    {
        Test.startTest();
            
        Account acc = new Account(Name='Acc1');
        insert acc;
                
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
            
        User userName = [Select id,Email,UserName,ContactId from User where Name='Kelly Matera'];
        
        Network net = [Select Id,Name from Network where Name='Salt Administrator Portal'];
        
        Salt_Client_Reports__c saltreport = new Salt_Client_Reports__c(Name='Salt Report',Account__c= acc.id);
        insert saltreport;
        
        Attachment attch = new Attachment(parentid=saltreport.id,Name='Test Attachment',body=Blob.valueOf('123'));
        insert attch;
        
        ContentVersion cd=new ContentVersion ();

        cd.Description='test';
        cd.NetworkId=net .id;
        cd.Title='test.txt';
        cd.PathOnClient='c:\\test.txt';
        cd.VersionData=Blob.valueOf('123');
        cd.Origin='H';
        insert cd;
        
        ContentVersion cvRes = [select id, ContentDocument.id, ContentDocument.title from ContentVersion where id= :cd.id];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=saltreport.id;
        contentlink.contentdocumentid=cvRes.ContentDocument.id;
        contentlink.ShareType='V';
        insert contentlink;
        
        
        
        system.debug(saltreport.id);
        SALTClientReportAttachmentCtrl.getAttachmentInfo(saltreport.id);
        SALTClientReportAttachmentCtrl.followRecord(saltreport.id);
        
        try
        {
            SALTClientReportAttachmentCtrl.deleteRecord(cvRes.id);
            SALTClientReportAttachmentCtrl.deleteRecord(attch.id);
        }
        catch(exception e)
        {
            System.debug(e.getMessage());
        }
         
        
        Test.stopTest();
    }
}