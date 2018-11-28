@isTest
public class TestBatchSendEmailToCommunityUser{

    @testsetup
    public static void setup()
    {
        User u = new User(Alias = 'stuser', Email='stanxxxarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',IsActive = true,
            LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='standarduMXs@testorg.com',
            profileId=[select id from profile where name='Standard user'].id,
            userroleid=[select id from userrole limit 1].id);
        insert u;
    }

    public testmethod static void testSendEmail(){
        
        Test.startTest();
        
        Account accNew = new Account();     
        accNew.name='College Planning Services';        
        insert accNew;
        
        Account acc=[SELECT id,Name FROM Account WHERE Id=:accNew.Id];
        System.assertEquals(acc.Name, 'College Planning Services');
        
        Contact conNew = new Contact(LastName = 'Test Con',AccountId = accNew.Id, Title = 'Test',FirstName = 'First Name');
        insert conNew;
        
        Contact con = [SELECT Id,LastName FROM Contact WHERE Id =: conNew.Id];
        System.assertEquals(con.LastName,'Test Con');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',IsActive = true, 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertttssss@testorg.com',ContactId = conNew.Id);
        
        insert u;
        
        User user = [SELECT Id,LastName,IsActive FROM User WHERE Id =: u.Id];
        System.assertEquals(user.LastName,'Testing');
        system.assert(user.IsActive == True);
        
        Salt_Client_Reports__c scr = new Salt_Client_Reports__c();
        scr.Name = 'Test Reports';
        scr.Account__c = accNew.Id;
        insert scr;
        
        Salt_Client_Reports__c salt_rpt = [SELECT Id,Name FROM Salt_Client_Reports__c WHERE Id =: scr.Id];
        System.assertEquals(salt_rpt.Name,'Test Reports');
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=scr.id;
        insert attach;
        
        Attachment attachment = [SELECT Id,Name FROM Attachment WHERE Id =: attach.Id];
        System.assertEquals(attachment.Name,'Unit Test Attachment');
        
        BatchSendEmailToCommunityUser batch = new BatchSendEmailToCommunityUser();
        ID batchprocessid = Database.executeBatch(batch);
        
        System.schedule('test Schedule', '0 0 0 15 3 ? 2022',new BatchSendEmailToCommunityUser());
        
        Test.stopTest();
        List<Task> tskList=[select id,subject from task where whoId =: conNew.Id];
        //System.assertEquals(tskList.size(),1);
    }

    public testmethod static void testSendEmail2()
    {
        Test.startTest();
        
        USer utemp=[select id from user where username='standarduMXs@testorg.com' Limit 1];
        Account accNew = new Account();     
        accNew.name='College Planning Services';        
        accNew.ownerId=utemp.id;        
        insert accNew;
        
        Account acc=[SELECT id,Name,ownerID FROM Account WHERE Id=:accNew.Id];
        system.debug(Acc);
        System.assertEquals(acc.ownerID , utemp.id);
        
        Contact conNew = new Contact(LastName = 'Test Con',AccountId = accNew.Id, Title = 'Test',FirstName = 'First Name');
        insert conNew;
        
        Contact con = [SELECT Id,LastName,ownerID FROM Contact WHERE Id =: conNew.Id];
        System.assertEquals(con.LastName,'Test Con');
        System.assertNotEquals(con.ownerID ,utemp.id);
        system.debug(conNew );
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',IsActive = true, 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertttssss@testorg.com',ContactId = conNew.Id);
        insert u;
        
        User user = [SELECT Id,LastName,IsActive FROM User WHERE Id =: u.Id];
        System.assertEquals(user.LastName,'Testing');
        system.assert(user.IsActive == True);
        
        Salt_Client_Reports__c scr = new Salt_Client_Reports__c();
        scr.Name = 'Test Reports';
        scr.Account__c = accNew.Id;
        insert scr;
        
        Salt_Client_Reports__c salt_rpt = [SELECT Id,Name FROM Salt_Client_Reports__c WHERE Id =: scr.Id];
        System.assertEquals(salt_rpt.Name,'Test Reports');
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=scr.id;
        insert attach;
        
        Attachment attachment = [SELECT Id,Name FROM Attachment WHERE Id =: attach.Id];
        System.assertEquals(attachment.Name,'Unit Test Attachment');
        
        BatchSendEmailToCommunityUser batch = new BatchSendEmailToCommunityUser();
        ID batchprocessid = Database.executeBatch(batch);
        
        System.schedule('test Schedule', '0 0 0 15 3 ? 2022',new BatchSendEmailToCommunityUser());
        
        Test.stopTest();
        List<Task> tskList=[select id,subject,ownerId from task where whoId =: conNew.Id];
        //System.assertEquals(tskList.size(),1);
        //System.assertEquals(tskList.get(0).ownerId,utemp.id);
        //System.assertNotEquals(tskList.get(0).ownerId,con.ownerid);
    }
}