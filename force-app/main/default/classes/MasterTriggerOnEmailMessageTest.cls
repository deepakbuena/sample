@isTest 
private class MasterTriggerOnEmailMessageTest{

    static testMethod void testSSNRoutingMasking(){
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        Case objCase = new Case();
        objCase.Status = 'New';
        objCase.Priority = 'Medium';
        objCase.Origin = 'Email';
        objCase.Description = 'This is to test Social Security 123456789. bank routing number 1234-1234-1,123456789.';
        objCase.Subject = 'This is to test Social Security 123456789.';
        insert objCase;
        
        EmailMessage objEmailMsg = new EmailMessage();
        objEmailMsg.FromAddress = 'test@test.com'; 
        objEmailMsg.FromName = 'Test';
        objEmailMsg.Incoming = true;
        objEmailMsg.Parentid = objCase.id;
        objEmailMsg.Subject = 'Test Subject Social Security 123-45-6789';
        objEmailMsg.TextBody = 'Test my Social Security 123-45-6789, 123 45 6789, 123456789, 123.45.6789. bank routing number 1234-1234-1,123456789.';
        objEmailMsg.HTMLBody = 'This is to test Social Security 123456789.';
        objEmailMsg.ToAddress = 'testto@test.com';
        objEmailMsg.Status = '1';
        insert objEmailMsg;
               
            Case objCaseToCheck = [select subject,Description from Case where id =: objCase.id];
            System.AssertEquals(false,objCaseToCheck.Description.contains('123456789'));
            System.AssertEquals(false,objCaseToCheck.Description.contains('1234-1234-1'));
            System.AssertEquals(false,objCaseToCheck.Subject.contains('123456789'));
            
            EmailMessage objEmailMsgToCheck = [select subject,textBody,HTMLBody from EmailMessage where id =: objEmailMsg.id]; 
            System.AssertEquals(false,objEmailMsgToCheck.Subject.contains('123-45-6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123-45-6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123 45 6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123456789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123.45.6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('1234-1234-1'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123456789'));
            //System.AssertEquals(false,objEmailMsgToCheck.HTMLBody.contains('123456789'));
        
    }
    
    static testMethod void testDLMaskingPositive(){
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        Case objCase = new Case();
        objCase.Status = 'New';
        objCase.Priority = 'Medium';
        objCase.Origin = 'Email';
        objCase.Description = 'This is to test DriverLic 1234 Utah.';
        objCase.Subject = 'This is to test DriverLic 1234567 ALABAMA.';
        insert objCase;
        
        EmailMessage objEmailMsg = new EmailMessage();
        objEmailMsg.FromAddress = 'test@test.com'; 
        objEmailMsg.FromName = 'Test';
        objEmailMsg.Incoming = true;
        objEmailMsg.Parentid = objCase.id;
        objEmailMsg.Subject = 'This is to test DriverLic 1234567 ALABAMA.';
        objEmailMsg.TextBody = 'This is to test DLS 1234567 AL.';
        objEmailMsg.HTMLBody = 'This is to test DriverLic 1234567 ALABAMA.';
        objEmailMsg.ToAddress = 'testto@test.com';
        objEmailMsg.Status = '1';
        insert objEmailMsg;
        
        
            Case objCaseToCheck = [select subject,Description from Case where id =: objCase.id];
            System.AssertEquals(false,objCaseToCheck.Description.contains('1234'));
            System.AssertEquals(false,objCaseToCheck.Subject.contains('1234567'));
        
            EmailMessage objEmailMsgToCheck = [select subject,textBody,HTMLBody from EmailMessage where id =: objEmailMsg.id]; 
            System.AssertEquals(false,objEmailMsgToCheck.Subject.contains('1234567'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('1234567'));
            System.AssertEquals(false,objEmailMsgToCheck.HTMLBody.contains('1234567'));
        
    }
    
    static testMethod void testDLMaskingNegative(){
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        Case objCase = new Case();
        objCase.Status = 'New';
        objCase.Priority = 'Medium';
        objCase.Origin = 'Email';
        objCase.Description = 'This is to test DriverLic xyz xyz xyz xyz xyz 1234567 Utah.';
        objCase.Subject = 'This is to test DriverLic 1234567 xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz Uttah.';
        insert objCase;
        
        EmailMessage objEmailMsg = new EmailMessage();
        objEmailMsg.FromAddress = 'test@test.com'; 
        objEmailMsg.FromName = 'Test';
        objEmailMsg.Incoming = true;
        objEmailMsg.Parentid = objCase.id;
        objEmailMsg.Subject = 'This is to test DriverLic xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz 1234567 ALABAMA.';
        objEmailMsg.TextBody = 'This is to test DLS 1234567 xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz xyz  xyz xyz xyz xyz AL.';
        objEmailMsg.HTMLBody = 'This is to test DriverLic 12345678 ALABAMA.';
        objEmailMsg.ToAddress = 'testto@test.com';
        objEmailMsg.Status = '1';
        insert objEmailMsg;
        
        Case objCaseToCheck = [select subject,Description from Case where id =: objCase.id];
        System.AssertEquals(true,objCaseToCheck.Description.contains('1234'));
        System.AssertEquals(true,objCaseToCheck.Subject.contains('1234567'));
        
        EmailMessage objEmailMsgToCheck = [select subject,textBody,HTMLBody from EmailMessage where id =: objEmailMsg.id]; 
        System.AssertEquals(true,objEmailMsgToCheck.textBody.contains('1234567'));
        System.AssertEquals(true,objEmailMsgToCheck.Subject.contains('1234567'));
        System.AssertEquals(true,objEmailMsgToCheck.HTMLBody.contains('12345678'));
    }
    
    static testMethod void testDLSSNRoutingMaskPositive(){
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        Case objCase = new Case();
        objCase.Status = 'New';
        objCase.Priority = 'Medium';
        objCase.Origin = 'Email';
        objCase.Description = 'This is to test DriverLic 1234 Utah.';
        objCase.Subject = 'This is to test DriverLic 1234567 ALABAMA.';
        insert objCase;
        
        EmailMessage objEmailMsg = new EmailMessage();
        objEmailMsg.FromAddress = 'test@test.com'; 
        objEmailMsg.FromName = 'Test';
        objEmailMsg.Incoming = true;
        objEmailMsg.Parentid = objCase.id;
        objEmailMsg.Subject = 'This is to test DriverLic 1234567 ALABAMA.';
        objEmailMsg.TextBody = 'This is to test DLS 1234567 AL. Test my Social Security 123-45-6789, 123 45 6789, 123456789, 123.45.6789. bank routing number 1234-1234-1,123456789.';
        objEmailMsg.HTMLBody = 'This is to test DriverLic 1234567 ALABAMA.';
        objEmailMsg.ToAddress = 'testto@test.com';
        objEmailMsg.Status = '1';
        insert objEmailMsg;
        
       
            Case objCaseToCheck = [select subject,Description from Case where id =: objCase.id];
            System.AssertEquals(false,objCaseToCheck.Description.contains('1234'));
            System.AssertEquals(false,objCaseToCheck.Subject.contains('1234567'));
        
            EmailMessage objEmailMsgToCheck = [select subject,textBody,HTMLBody from EmailMessage where id =: objEmailMsg.id]; 
            System.AssertEquals(false,objEmailMsgToCheck.Subject.contains('1234567'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('1234567'));
            System.AssertEquals(false,objEmailMsgToCheck.HTMLBody.contains('1234567'));
            
            System.AssertEquals(false,objEmailMsgToCheck.Subject.contains('123-45-6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123-45-6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123 45 6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123456789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123.45.6789'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('1234-1234-1'));
            System.AssertEquals(false,objEmailMsgToCheck.textBody.contains('123456789'));
            System.AssertEquals(false,objEmailMsgToCheck.HTMLBody.contains('123456789'));
        
    }

}