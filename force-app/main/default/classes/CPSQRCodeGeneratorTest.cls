@isTest
public class CPSQRCodeGeneratorTest
{
    
    @isTest
    public static void generateQRFirstTime()
    {
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        insert objCamp;
        
        Campaign campRec = [Select Id,QR_Code_Valid_From__c,QR_Code_Valid_Until__c from Campaign Where Id =: objCamp.Id];
        System.assertEquals(campRec.QR_Code_Valid_From__c,Null);
        System.assertEquals(campRec.QR_Code_Valid_Until__c,Null);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCamp);
        CPSQRCodeGenerator objCodeGenerator = new CPSQRCodeGenerator(sc);
        objCodeGenerator.generateCode();
        
    }
    
    @isTest
    public static void generateQRConditionMeet()
    {
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        insert objCamp;
        
        Timezone tz = Timezone.getTimeZone('America/New_York');
        DateTime timeQRValidFrom = DateTime.newInstanceGMT(2018, 10, 1, 11, 0, 0);
        DateTime timeQRValidUntill = DateTime.newInstanceGMT(2019, 10, 1, 0, 0, 0);


        objCamp.QR_Code_Valid_From__c = timeQRValidFrom;
        objCamp.QR_Code_Valid_Until__c = timeQRValidUntill;
        update objCamp;
        
        Campaign campRec = [Select Id,QR_Code_Valid_From__c,QR_Code_Valid_Until__c from Campaign Where Id =: objCamp.Id];
        System.assertEquals(campRec.QR_Code_Valid_From__c,timeQRValidFrom);
        System.assertEquals(campRec.QR_Code_Valid_Until__c,timeQRValidUntill);
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCamp);
        CPSQRCodeGenerator objCodeGenerator = new CPSQRCodeGenerator(sc);
        objCodeGenerator.generateCode();
        
    }
    
    @isTest
    public static void generateQR()
    {
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        insert objCamp;
        
        Timezone tz = Timezone.getTimeZone('America/New_York');
        DateTime timeQRValidFrom = DateTime.newInstanceGMT(2018, 10, 1, 10, 0, 0);
        DateTime timeQRValidUntill = DateTime.newInstanceGMT(2019, 10, 1, 0, 0, 0);


        objCamp.QR_Code_Valid_From__c = timeQRValidFrom;
        objCamp.QR_Code_Valid_Until__c = timeQRValidUntill;
        update objCamp;
        
        Campaign campRec = [Select Id,QR_Code_Valid_From__c,QR_Code_Valid_Until__c from Campaign Where Id =: objCamp.Id];
        System.assertEquals(campRec.QR_Code_Valid_From__c,timeQRValidFrom);
        System.assertEquals(campRec.QR_Code_Valid_Until__c,timeQRValidUntill);
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCamp);
        CPSQRCodeGenerator objCodeGenerator = new CPSQRCodeGenerator(sc);
        objCodeGenerator.generateCode();
        
    }
}