@isTest
public class CPSQRCodeReaderTest
{
    @isTest
    public static void QRReader()
    {
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        insert objCamp;
        
        Campaign campRec = [Select Id,QR_Code_Valid_From__c,QR_Code_Valid_Until__c from Campaign Where Id =: objCamp.Id];
        System.assertEquals(campRec.QR_Code_Valid_From__c,Null);
        System.assertEquals(campRec.QR_Code_Valid_Until__c,Null);
        
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',objCamp.Id);
        Cookie campId = new Cookie('campId', objCamp.Id, null, -1, false);
        Pagereference pr = new PageReference('/apex/EventCheckIn');
        pr.setCookies(new Cookie[] {campId});
        CPSQRCodeReader objQRReader = new CPSQRCodeReader();
        objQRReader.redirectToQRLink();
        Test.StopTest();
    }
    
    @isTest
    public static void QRReaderSTDT()
    {
        Campaign objCamp = new Campaign();
        objCamp.Name = 'Test Campaign';
        objCamp.IsActive = TRUE;
        objCamp.Start_DateTime__c = Date.today();
        insert objCamp;
        
        Timezone tz = Timezone.getTimeZone('America/New_York');
        Long st = DateTime.now().addMinutes(-30).getTime();
        Long dt = DateTime.now().addMinutes(30).getTime();
        
        System.debug('ST @@'+st);
        System.debug('DT @@'+dt);
        
        
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id', objCamp.Id);
        ApexPages.currentPage().getParameters().put('st',String.valueOf(st));
        ApexPages.currentPage().getParameters().put('dt',String.valueOf(dt));
        Cookie campId = new Cookie('campId', objCamp.Id, null, -1, false);
        Pagereference pr = new PageReference('/apex/EventCheckIn');
        pr.setCookies(new Cookie[] {campId});
        CPSQRCodeReader objQRReader = new CPSQRCodeReader();
        objQRReader.redirectToQRLink();
        Test.StopTest();

    } 
}