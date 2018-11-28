@isTest

public class TestBatchAccountTeamOnAccount{

     static testMethod void testBatchAccountTeam(){ 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u1 = new User(Alias = 'standt1',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', Email='standarduser1@testorg.com', LastName='Testing1', ProfileId = p.Id, UserName='stsy2@testorg.com',Cost_Center__c = '16350');
            insert u1;
             
            User u2 = new User(Alias = 'standt',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', Email='standarduser1@testorg.com', LastName='Testing2', ProfileId = p.Id, UserName='stsy3@testorg.com',Cost_Center__c = '16350');
            insert u2;
            
            User u3 = new User(Alias = 'standt',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', Email='standarduser1@testorg.com', LastName='Testing2', ProfileId = p.Id, UserName='stsy4@testorg.com',Cost_Center__c = '16350');
            insert u3;
            
            Account acc = new Account();    
            acc.Name = 'Test Acc Team';
            insert acc;
            
            Account acc2 = new Account();    
            acc2.Name = 'Test Acc Team2';
            insert acc2;
            
            Account acc3 = new Account();    
            acc3.Name = 'Test Acc Team3';
            acc3.Campus_Consultant__c = u1.Id;
            acc3.Regional_Account_Executive__c = u2.Id;
            insert acc3;
            
            Account acc4 = new Account();    
            acc4.Name = 'Test Acc Team4';
            acc4.Campus_Consultant__c = u1.Id;
            acc4.Regional_Account_Executive__c = u2.Id;
            insert acc4;
            
            
            
            Account acc5 = new Account();    
            acc5.Name = 'Test Acc Team5';
            insert acc5;
            
            AccountTeamMember accTeamMem = new AccountTeamMember();
            accTeamMem.AccountId = acc.Id;
            accTeamMem.TeamMemberRole = 'Campus Consultant';
            accTeamMem.UserId = u1.Id;
            insert accTeamMem;
            
            AccountTeamMember accTeamMem2 = new AccountTeamMember();
            accTeamMem2.AccountId = acc2.Id;
            accTeamMem2.TeamMemberRole = 'Business Development AE';
            accTeamMem2.UserId = u2.Id;
            insert accTeamMem2;
            
            AccountTeamMember accTeamMem3 = new AccountTeamMember();
            accTeamMem3.AccountId = acc3.Id;
            accTeamMem3.TeamMemberRole = 'School Client Manager';
            accTeamMem3.UserId = u3.Id;
            insert accTeamMem3;
            
            BatchAccountTeamOnAccount  bObj = new BatchAccountTeamOnAccount ();
            /*String seconds = '0'; //Execute at Zero Seconds
            String minutes = '30'; //Execute at every 30th minute of hour
            String hours = '*'; // Execute Every Hour
            String dayOfMonth = String.valueOf(Datetime.now().day()); // Execute on current Day of the current Month
            String month = String.valueOf(Datetime.now().month()); //Execute current Month
            String dayOfWeek = '';
            String year = '';
            String sch = seconds + ' ' + minutes + ' ' + hours + ' ' + dayOfMonth + ' ' + month + ' ' +dayOfWeek;
            System.schedule('Account Team Job', sch, bObj);
            
            String sch = '0 0 30 3 9 ? 2022';
            String jobID = system.schedule('Acc Team Job', sch, bObj );*/
            Database.executeBatch(bObj,10);   
        
        }   
   }
}