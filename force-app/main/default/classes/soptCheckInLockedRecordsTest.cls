@IsTest(seealldata=true)
public class soptCheckInLockedRecordsTest {

   static testmethod void test() 
   {
   account a =new account();
   a.name='tst';
   insert a;
   Account_Planning__c aa =new Account_Planning__c ();
   aa.Account_Name_2__c=a.id;
   aa.name='2013 name';
   insert aa;
   }
}