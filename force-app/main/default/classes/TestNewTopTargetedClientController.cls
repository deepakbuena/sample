/*
@Name                : TestNewTopTargetedClientController 
@Author              : GS Dev Team
@Date                : January 12, 2016
@Description         : Test class for NewTopTargetedClientController class
*/ 

@isTest

private class TestNewTopTargetedClientController{

    static testMethod void NewTopTargetedClientTest() {
        
        Test.startTest();
        //user test data
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        //m2o test data
        Mutually_Agreed_to_Objectives__c m2o1 = new Mutually_Agreed_to_Objectives__c();
        m2o1.Name = 'test m2o1';
        m2o1.Regional_Manager__c = u.Id;
        m2o1.objective_plan_date__c = Date.parse('1/1/2016');
        m2o1.Targeted_Substantive_Visits_for_Month__c = 10;
        m2o1.Number_of_Expected_Contracts__c = 10;
        m2o1.Regional_Account_Executive__c = u.id;
        insert m2o1;
        
        //account test data
        Account acc1 = new Account(name='test acc1');
        insert acc1;
        
        Account acc2 = new Account(name='test acc2');
        insert acc2;
        
        Account acc3 = new Account(name='test acc3');
        insert acc3;
        
        Account acc4 = new Account(name='test acc4');
        insert acc4;
        
        //Without top target records test
        ApexPages.StandardController sc2 = new ApexPages.StandardController(m2o1);
        NewTopTargetedClientController newTtcController2 = new NewTopTargetedClientController(sc2);
        
        //new button test
        newTtcController2.showTtcRelatedlist = 'false';
        newTtcController2.prepareTopTargetList();
        
        //cancel button test
        newTtcController2.showTtcRelatedlist = 'true';
        newTtcController2.prepareTopTargetList();
        
        //new button and save test
        newTtcController2.showTtcRelatedlist = 'false';
        newTtcController2.prepareTopTargetList();
        newTtcController2.addRows();
        for(NewTopTargetedClientController.TopTargetedWrapper tmp : newTtcController2.listTopTargeted){
            if(tmp.index=='1'){
                tmp.tts.Account__c = acc4.Id;
            }
        }
        
        //fail save with 3 account validation
        newTtcController2.saveTargetClient();
        
        //Top_Targeted_School__c test data
        Top_Targeted_School__c target1 = new Top_Targeted_School__c();
        target1.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target1.Account__c = acc1.Id; 
        insert target1;
        
        Top_Targeted_School__c target2 = new Top_Targeted_School__c();
        target2.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target2.Account__c = acc2.Id; 
        insert target2;
        
        Top_Targeted_School__c target3= new Top_Targeted_School__c();
        target3.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target3.Account__c = acc3.Id; 
        insert target3;
        
        
        PageReference pageRef = Page.NewTopTargetedClient;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(m2o1);
        NewTopTargetedClientController newTtcController = new NewTopTargetedClientController(sc);
        
        //new button test
        newTtcController.showTtcRelatedlist = 'false';
        newTtcController.prepareTopTargetList();
        
        //cancel button test
        newTtcController.showTtcRelatedlist = 'true';
        newTtcController.prepareTopTargetList();
        
        //new button and save test
        newTtcController.showTtcRelatedlist = 'false';
        newTtcController.prepareTopTargetList();
        newTtcController.addRows();
        for(NewTopTargetedClientController.TopTargetedWrapper tmp : newTtcController.listTopTargeted){
            if(tmp.index=='4'){
                tmp.tts.Account__c = acc4.Id;
            }
            if(tmp.index=='5'){
                tmp.tts.Account__c = acc4.Id;
            }
        }
        
        //fail save with unique account validation
        newTtcController.saveTargetClient();
        
        for(NewTopTargetedClientController.TopTargetedWrapper tmp : newTtcController.listTopTargeted){
            if(tmp.index=='4'){
                tmp.tts.Account__c = acc4.Id;
            }
            if(tmp.index=='5'){
                tmp.tts.Account__c = null;
            }
        }
        
        //save exception test
        newTtcController.saveTargetClient();
        
        ApexPages.currentPage().getParameters().put('id',m2o1.id);
        //save test
        newTtcController.saveTargetClient();
        
        Test.stopTest();
    }
    
    static testMethod void NewTopTargetedClientTest2() {
        
        Test.startTest();
        //user test data
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        //m2o test data
        Mutually_Agreed_to_Objectives__c m2o1 = new Mutually_Agreed_to_Objectives__c();
        m2o1.Name = 'test m2o1';
        m2o1.Regional_Manager__c = u.Id;
        m2o1.objective_plan_date__c = Date.parse('1/1/2016');
        m2o1.Targeted_Substantive_Visits_for_Month__c = 10;
        m2o1.Number_of_Expected_Contracts__c = 10;
        m2o1.Regional_Account_Executive__c = u.id;
        insert m2o1;
        
        //account test data
        Account acc1 = new Account(name='test acc1');
        insert acc1;
        
        Account acc2 = new Account(name='test acc2');
        insert acc2;
        
        Account acc3 = new Account(name='test acc3');
        insert acc3;
        
        Account acc4 = new Account(name='test acc4');
        insert acc4;
        
        //Top_Targeted_School__c test data
        Top_Targeted_School__c target1 = new Top_Targeted_School__c();
        target1.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target1.Account__c = acc1.Id; 
        insert target1;
        
        Top_Targeted_School__c target2 = new Top_Targeted_School__c();
        target2.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target2.Account__c = acc2.Id; 
        insert target2;
        
        Top_Targeted_School__c target3= new Top_Targeted_School__c();
        target3.Mutually_Agreed_to_Objectives__c = m2o1.Id; 
        target3.Account__c = acc3.Id; 
        insert target3;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(m2o1);
        NewTopTargetedClientController newTtcController = new NewTopTargetedClientController(sc);
        
        //new button test
        newTtcController.showTtcRelatedlist = 'true';
        newTtcController.prepareTopTargetList();
        newTtcController.addRows();
        for(NewTopTargetedClientController.TopTargetedWrapper tmp : newTtcController.listTopTargeted){
            if(tmp.index=='4'){
                tmp.tts.Account__c = acc4.Id;
            }
        }
        //remove rows test
        newTtcController.numberOfRowToRemove = target1.Id;
        newTtcController.removeRows();
        newTtcController.saveTargetClient();
        
        Test.stopTest();
    }
}