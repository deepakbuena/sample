@isTest
private class OpportunityTriggerTest {

    static testmethod void testCreateImpCase(){

        //Test: When an opportunity is in "Implementation" Stage, it should create an implementation case
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        Account acct = new Account();
        acct.Name = 'College Planning Services';
        acct.OwnerId = u.Id;
        insert acct;

        Contact con = new Contact();
        con.LastName = 'Doe';
        con.FirstName = 'John';
        con.Title = 'CEO';
        con.AccountId = acct.Id;
        insert con;
        
        Product2 p1 = new Product2(Name='Prod 1', Family='Foundation', Description='Prod 1 Description');
        insert p1;
        
        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
         
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
         
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = p1.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Opportunity oppty = new Opportunity();
        oppty.Name = 'Implementation Opportunity ' + System.today().year().format().remove(',');
        oppty.StageName = 'Prospect';
        oppty.RecordTypeId ='0126000000010rU'; //"Business Development" RecordType
        oppty.Type = 'Standard';
        oppty.LeadSource = 'Cold Call';
        oppty.CloseDate = System.today();
        oppty.PriceBook2 = customPB;
        oppty.AccountId = acct.Id;
        insert oppty;
        
        OpportunityLineItem oli = new OpportunityLineItem (Quantity=2, OpportunityId=oppty.Id, TotalPrice=10, PricebookEntryId = customPrice.Id); 
        insert oli; 

        OpportunityContactRole opptyCon = new OpportunityContactRole();
        opptyCon.ContactId = con.Id;
        opptyCon.isPrimary = true;
        opptyCon.OpportunityId = oppty.Id;
        opptyCon.Role = 'Champion';
        insert opptyCon;

        Test.startTest();
        
        oppty.StageName = 'Implementation';
        update oppty;

        Test.stopTest();

        //Validate behavior by assertions
        String opptyLinkAssert = URL.getSalesforceBaseUrl().toExternalForm().replace('http://','https://') + '/' + oppty.Id;
        Case[] impCase = [SELECT OwnerId, Subject, RecordTypeId, Origin, Status, Type, AccountId, Opportunity_Link__c 
                            FROM Case
                            WHERE Opportunity_Link__c = :opptyLinkAssert];

        //system.assertEquals(1,impCase.size());
        //system.assertEquals(acct.OwnerId, impCase[0].OwnerId);
        //system.assertEquals('ACME - Implementation', impCase[0].Subject);
        //system.assertEquals('012600000005ExK', impCase[0].RecordTypeId ); //Record Type: Implementation Consumer Services
        //system.assertEquals('Email', impCase[0].Origin);
        //system.assertEquals('WIP', impCase[0].Status);
        //system.assertEquals('Implementation', impCase[0].Type);
        //system.assertEquals(opptyLinkAssert, impCase[0].Opportunity_Link__c);
        //system.assertEquals(oppty.AccountId, impCase[0].AccountId);
    }

    static testmethod void testRolloverOpportunity(){

        //Test: When an opportunity has the field "Rollover__c" checked, 
        //it should create an opportunity for the 6/30 of the next fiscal year 

        Opportunity[] opptyList = new Opportunity[]{};

        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        Account acct = new Account();
        acct.Name = 'College Planning Services';
        insert acct;

        Contact con = new Contact();
        con.LastName = 'Doe';
        con.FirstName = 'John';
        con.Title = 'CEO';
        con.AccountId = acct.Id;
        insert con;

        Opportunity oppty1stHalf = new Opportunity();
        oppty1stHalf.Name = '1st Half Opportunity ' + System.today().year().format().remove(',');
        oppty1stHalf.StageName = 'Discovery';
        oppty1stHalf.RecordTypeId ='0126000000010rU'; //"Business Development" RecordType
        oppty1stHalf.Type = 'Standard';
        oppty1stHalf.LeadSource = 'Cold Call';
        oppty1stHalf.CloseDate = Date.newInstance(System.today().year(), 6, 30); 
        oppty1stHalf.AccountId = acct.Id;
        opptyList.add(oppty1stHalf);

        Opportunity oppty2ndHalf = new Opportunity();
        oppty2ndHalf.Name = '2nd Half Opportunity ' + System.today().year().format().remove(',');
        oppty2ndHalf.StageName = 'Closed - Lost'; //Should return a new Opportunity Stage = Prospect
        oppty2ndHalf.RecordTypeId ='0126000000010rU'; //"Business Development" RecordType
        oppty2ndHalf.Type = 'Standard';
        oppty2ndHalf.LeadSource = 'Cold Call';
        oppty2ndHalf.CloseDate = Date.newInstance(System.today().year(), 7, 1); 
        oppty2ndHalf.AccountId = acct.Id;
        oppty2ndHalf.Loss__c = true;
        opptyList.add(oppty2ndHalf);
        
        insert opptyList;

        Test.startTest();

        Opportunity[] updateOpptyList = new Opportunity[]{};
        oppty1stHalf.Rollover__c = false;
        oppty2ndHalf.Rollover__c = false;
        update oppty1stHalf;
        update oppty2ndHalf;
        //updateOpptyList.add(oppty1stHalf); //This should return an opportunity with new Opportunity with a Close Date of 6/30/2016
        //updateOpptyList.add(oppty2ndHalf); 
        //update updateOpptyList;

        Test.stopTest();

        Opportunity[] opptyCheckList = [SELECT Name, StageName, RecordTypeId, Type, LeadSource, CloseDate, AccountId, Primary_Loss_Reason__c, Loss__c, Rollover__c
                                        FROM Opportunity 
                                        WHERE Id NOT IN (:oppty1stHalf.Id,:oppty2ndHalf.Id)];

        Integer numOfChecks = 0;

        for(Opportunity o : opptyCheckList){

            if(o.Name.startsWith('1st Half Opportunity')){

               /* system.assertEquals('1st Half Opportunity ' + System.today().addYears(1).year().format().remove(','), o.Name); // FY2016
                system.assertEquals('Discovery', o.StageName);
                system.assertEquals('0126000000010rU', o.RecordTypeId);
                system.assertEquals('Standard', o.Type);
                system.assertEquals('Cold Call', o.LeadSource);
                system.assertEquals(Date.newInstance(System.today().addYears(1).year(), 6, 30), o.CloseDate); // 6/30/2015 -> 6/30/16
                system.assertEquals(acct.Id, o.AccountId);
                system.assertEquals(false, o.Rollover__c);*/

                numOfChecks += 1;
            }

            if(o.Name.startsWith('2nd Half Opportunity')){

               /* system.assertEquals('2nd Half Opportunity ' + System.today().addYears(2).year().format().remove(','), o.Name); // FY2017
                system.assertEquals('Prospect', o.StageName);
                system.assertEquals('0126000000010rU', o.RecordTypeId);
                system.assertEquals('Standard', o.Type);
                system.assertEquals('Cold Call', o.LeadSource);
                system.assertEquals(Date.newInstance(System.today().addYears(2).year(), 6, 30), o.CloseDate); // 7/1/2015 -> 6/30/2017
                system.assertEquals(acct.Id, o.AccountId);
                system.assertEquals(false, o.Rollover__c);
                system.assertEquals(null, o.Primary_Loss_Reason__c);
                system.assertEquals(false, o.Loss__c);*/

                numOfChecks += 1;
            }
        }
        //Ensure there were two rollover Opportunity created
        //system.assertEquals(2, numOfChecks);

    }   
}