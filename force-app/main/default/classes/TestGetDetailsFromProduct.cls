@istest
public class TestGetDetailsFromProduct{

    public static testMethod void unitTest()
    {
        Test.startTest();
        SALT_Product__C pTemp=new SALT_Product__C();
        pTemp.name='Item';
        pTemp.cost__c=1;
        pTemp.Description__c='Item Description';
        pTemp.Family__c='TestFamily';
        
        insert pTemp;
        
        Account acc=new Account();
        acc.name='test Account';
        acc.OE_Code__c='1234';
        insert acc;
        
        SALT_Record__c rTemp=new SALT_Record__c();
        rTemp.name='Item';
        rTemp.itemCode__c='Item';
        rTemp.ShipDate__c=System.today();
        rTemp.Quantity__C=1;
        rTemp.ProductLine__c='TestFamily';
        rTemp.OE_Code__c='1234';
        insert rTemp;
    
        SALT_Record__c rTemp2=new SALT_Record__c();
        rTemp2.name='Item';
        rTemp.itemCode__c='Item';
        rTemp2.ShipDate__c=System.today();
        rTemp2.Quantity__C=1;
        rTemp2.ProductLine__c='TestFamily';
        rTemp2.OE_Code__c='12345';
       try
       {
        insert rTemp2;
       }
       catch(exception e)
       {
           system.assertEquals(e.getMessage().contains('exception'),true);
       } 
     
       Test.stopTest();
        
    }
}