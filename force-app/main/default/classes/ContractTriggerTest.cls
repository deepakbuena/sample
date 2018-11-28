@isTest
private class ContractTriggerTest {
    
    static testmethod void testCreateRenewalOpportunity(){
    
        User activeUser = [SELECT Id FROM User WHERE isActive = true AND Manager.isActive = true LIMIT 1];

            Account acct1 = new Account();
                acct1.Name = 'College Planning Services';
                acct1.OwnerId = activeUser.Id;
                insert acct1;

                Account acct2 = new Account();
                acct2.Name = 'ACME';
                acct2.OwnerId = activeUser.Id;
                insert acct2;
                
            Contact con = new Contact();
            con.LastName = 'Doe';
            con.FirstName = 'John';
            con.Title = 'CEO';
            con.AccountId = acct1.Id;
            insert con;

            Opportunity[] opptylist = new Opportunity[]{};

                Opportunity oppty1 = new Opportunity();
                oppty1.Name = 'Renewal Opportunity 1st Half' + System.today().year().format().remove(',');
                oppty1.StageName = 'Closed - Won';
                oppty1.RecordTypeId ='0126000000010rU'; //"Business Development" RecordType
                oppty1.Type = 'Standard';
                oppty1.LeadSource = 'Cold Call';
                oppty1.CloseDate = System.today();
                oppty1.AccountId = acct1.Id;
                oppty1.OwnerId = activeUser.Id;
                oppty1.Contract_End_Date__c = Date.newInstance(System.today().addYears(-1).year(),6,30); // 6/30/2014 -> 6/30/2015
                opptyList.add(oppty1);

                Opportunity oppty2 = new Opportunity();
                oppty2.Name = 'Renewal Opportunity 2nd Half ' + System.today().year().format().remove(',');
                oppty2.StageName = 'Closed - Won';
                oppty2.RecordTypeId ='0126000000010rU'; //"Business Development" RecordType
                oppty2.Type = 'Standard';
                oppty2.LeadSource = 'Cold Call';
                oppty2.CloseDate = System.today();
                oppty2.AccountId = acct2.Id;
                oppty2.OwnerId = activeUser.Id;
                oppty2.Contract_End_Date__c = Date.newInstance(System.today().addYears(-1).year(),7,1); // 7/1/2014 -> 6/30/2016
                opptyList.add(oppty2);

                insert opptyList;

                Contract[] ctrctList = new Contract[]{};

                Contract ctrct1 = new Contract();
                ctrct1.AccountId = acct1.Id;
                ctrct1.Status = 'Contract Requested';
                ctrct1.StartDate = Date.newInstance(System.today().year(),1,1);
                ctrct1.EndDate = Date.newInstance(System.today().addYears(-1).year(),6,30);
                ctrct1.Contact_Name__c = con.Id;
                ctrct1.Opportunity__c = oppty1.Id;
                ctrctList.add(ctrct1);

                Contract ctrct2 = new Contract();
                ctrct2.AccountId = acct1.Id;
                ctrct2.Status = 'Contract Requested';
                ctrct2.StartDate = Date.newInstance(System.today().year(),1,1);
                ctrct2.EndDate = Date.newInstance(System.today().addYears(-1).year(),7,1);
                ctrct2.Contact_Name__c = con.Id;
        ctrct2.Opportunity__c = oppty2.Id;
                ctrctList.add(ctrct2);

                insert ctrctList;

            Test.startTest();

            ctrct1.Renewal_Opportunity_Created__c = true;
            ctrct2.Renewal_Opportunity_Created__c = true;
            update ctrctList;

            Test.stopTest();

                Opportunity[] opptyCheckList = [SELECT Name, StageName, RecordTypeId, Type, LeadSource, 
                                                        CloseDate, AccountId, OwnerId, Renewal_Opp__c            
                                                FROM Opportunity
                                                WHERE Id NOT IN (:oppty1.Id, :oppty2.Id)];

                Integer numOfChecks = 0;

                for(Opportunity o : opptyCheckList){

                        if(o.Name.startsWith(acct1.Name)){

                                system.assertEquals(acct1.Name + ' - Renewal - FY' + System.today().addYears(-1).year().format().remove(','), o.Name);
                                system.assertEquals('Prospect', o.StageName);
                                system.assertEquals('0126000000010rU', o.RecordTypeId);
                                system.assertEquals('Contract Renewal', o.LeadSource);
                                system.assertEquals(ctrct1.EndDate, o.CloseDate);
                                //system.assertEquals(Date.newInstance(System.today().year(),6,30), o.CloseDate);
                                system.assertEquals(acct1.Id, o.AccountId);
                                system.assertEquals(activeUser.Id, o.OwnerId);
                                system.assertEquals(true, o.Renewal_Opp__c);
                                
                                numOfChecks += 1;
                        }

                        if(o.Name.startsWith(acct2.Name)){

                                system.assertEquals(acct2.Name + ' - Renewal - FY' + System.today().year().format().remove(','), o.Name);
                                system.assertEquals('Prospect', o.StageName);
                                system.assertEquals('0126000000010rU', o.RecordTypeId);
                                system.assertEquals('Contract Renewal', o.LeadSource);
                                system.assertEquals(ctrct2.EndDate, o.CloseDate);
                                //system.assertEquals(Date.newInstance(System.today().addYears(1).year(),6,30), o.CloseDate);
                                system.assertEquals(acct2.Id, o.AccountId);
                                system.assertEquals(activeUser.Id, o.OwnerId);
                                system.assertEquals(true, o.Renewal_Opp__c);

                                numOfChecks += 1;
                        }

                }

                //system.assertEquals(2, numOfChecks);
    }
}