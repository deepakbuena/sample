/*************************************************************************************************
Created By:    Gagandeep Kaur
Date:          Feb 10, 2016
Description  : Test class for LiveAgentChatButtonController
Name                 : LiveAgentChatButtonControllerTest
 **************************************************************************************************/
@isTest(seeAllData = false) 
public class LiveAgentChatButtonControllerTest {
    static User portalUser;
    static User sysAdmin;
    static Contact con;
    static testMethod void testControllerGetContact() {
        sysAdmin = TestUtility.createUser('System Administrator', true);
        system.runAs(sysAdmin){
            createTestData();
            system.runAs(portalUser) {
                System.assertEquals(con.Id, LiveAgentChatButtonController.getContact(null).Id);
                //System.assertEquals(true, LiveAgentChatButtonController.getCaseRecordTypeId() != null);
                LiveAgentChatButtonController.getCaseRecordTypeId();
            }
            //With Manager Profile
            list<User> userList = [SELECT Id FROM User WHERE Profile.Name LIKE '%Manager%' AND UserType = 'CSPLitePortal' LIMIT 1];
            if(userList.size() > 0) {
                system.runAs(userList.get(0)) {
                    System.assertEquals(true, LiveAgentChatButtonController.getCaseRecordTypeId() != null);
                }
            }
            //User.contactId = null
            System.assertNotEquals(con.Id, LiveAgentChatButtonController.getContact(null).Id);
        }
    }
    
    static public void createTestData() {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        sysAdmin.UserRoleId = portalRole.Id;
        update sysAdmin;
        //String recTypeName = TestUtility.getRecordTypeId('Account', 'Employer Mkt');
        String recTypeName = TestUtility.getRecordTypeId('Account', 'Foundation');
            //Create account
            Account portalAccount = TestUtility.createAccount(recTypeName, 'College Planning Services', true);
            
            //Create contact
            con = TestUtility.createContact(portalAccount.Id, false);
            con.Email = System.now().millisecond() + 'test@test.com';
            insert(con);

        portalUser = TestUtility.createPortalUser(con.Id);
    }
}