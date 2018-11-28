/**
@Name            : ConfirmationControllerTest
@Description     : Test class for 'ConfirmationController' Class 
**/
@isTest
public class ConfirmationControllerTest{
    @isTest
    public static void confirmationPageTest(){
        ConfirmationController controller= new ConfirmationController();
        controller.pageOrigin= 'eoc';
        controller.redirectToSignOn();
        PageReference pageRef = Page.ConfirmationPage;
        pageRef.getParameters().put('pageOrigin', controller.pageOrigin);
        Test.setCurrentPage(pageRef);
        System.assertEquals('eoc', controller.pageOrigin);

       }
       
    @isTest
    public static void confirmationPage1Test(){
        ConfirmationController controller= new ConfirmationController();
        controller.pageOrigin= 'ts';
        controller.redirectToSignOn();
        PageReference pageRef = Page.ConfirmationPage;
        pageRef.getParameters().put('pageOrigin', controller.pageOrigin);
        Test.setCurrentPage(pageRef);
        System.assertEquals('ts', controller.pageOrigin);

    
    
    }
    
}