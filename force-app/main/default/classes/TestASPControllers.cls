@isTest

private class TestASPControllers {

    static testMethod void testpcaCtrl() {
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='stsyuser@sfdc.com');
                                                      
            insert u;
            
            User unew = new User(Alias = 'standtn', Email='standardusernew@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='stsyusernew@sfdc.com');
                                                      
            insert unew;
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GS',OwnerId = u.Id);
            insert asp;
            
            RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference'];
            
            Campaign camp = new Campaign(Name='Campaign1',RecordTypeId= rt.id,Location__c='Test loc',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing;Testingnew',Presenting__c='Testingnew',isActive=true);             
            insert camp;

            Annual_Sales_Plan_Items__c pca = new Annual_Sales_Plan_Items__c(PCA_Record__c = true);
            pca.Annual_Sales_Plan__c = asp.Id; 
            pca.Conference_Name_Presentation_Proposed__c= camp.id;
            insert pca;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(asp);
            ProposedConferenceAttendanceController  newpcaController = new ProposedConferenceAttendanceController (sc);
            
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            
            newpcaController.showPCARelatedlist = 'true';
            newpcaController.preparePCAList();
            
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            newpcaController.addRows();
                          
            PageReference pageRef = Page.ProposedConferenceAttendancePage;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(asp);
            ProposedConferenceAttendanceController newpcaController1 = new ProposedConferenceAttendanceController(sc1);
            
            newpcaController1.showPCARelatedlist = 'false';
            newpcaController1.preparePCAList();
            
            newpcaController1.showPCARelatedlist = 'true';
            newpcaController1.preparePCAList();
            newpcaController1.addRows();
            
            //new button and save test
            newpcaController1.showPCARelatedlist = 'false';
            newpcaController1.preparePCAList();
            newpcaController1.addRows();

            Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
            insert asp1;
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(asp1);
            ProposedConferenceAttendanceController  newpcaController2 = new ProposedConferenceAttendanceController (sc2);
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'true';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            newpcaController2.addRows();
          
            Campaign camp1 = new Campaign (Name='Campaign2',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testingnew',Presenting__c='Testing;Testingnew',isActive=true);
            insert camp1;
            
            camp1.BDAttending__c='Testing';
            update camp1;

            Annual_Sales_Plan_Items__c pca1 = new Annual_Sales_Plan_Items__c(PCA_Record__c = true);
            pca1.Annual_Sales_Plan__c = asp1.Id; 
            pca1.Conference_Name_Presentation_Proposed__c= camp1.id;
            insert pca1;       
            
            PageReference pageRef1 = Page.ProposedConferenceAttendancePage;
            Test.setCurrentPage(pageRef1);
            ApexPages.Standardcontroller sc3= new ApexPages.Standardcontroller(asp1);
            ProposedConferenceAttendanceController newpcaController3= new ProposedConferenceAttendanceController(sc3);
            
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();
            
            newpcaController3.showPCARelatedlist = 'true';
            newpcaController3.preparePCAList();
            newpcaController3.addRows();
            
            //new button and save test
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();
            newpcaController3.addRows();

            Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
            insert asp2;
            
            ApexPages.StandardController sc4 = new ApexPages.StandardController(asp2);
            ProposedConferenceAttendanceController  newpcaController4 = new ProposedConferenceAttendanceController (sc4);
            
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            
            newpcaController4.showPCARelatedlist = 'true';
            newpcaController4.preparePCAList();
            
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            newpcaController4.addRows();
          
            Campaign camp2 = new Campaign (Name='Campaign3',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing',Presenting__c='Testingnew',isActive=true);
            insert camp2;
            camp2.BDAttending__c='Testingnew';
            update camp2;

            Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c(PCA_Record__c = true);
            pca2.Annual_Sales_Plan__c = asp2.Id; 
            pca2.Conference_Name_Presentation_Proposed__c= camp2.id;
            insert pca2;     
            
            PageReference pageRef3 = Page.ProposedConferenceAttendancePage;
            Test.setCurrentPage(pageRef3);
            ApexPages.Standardcontroller sc5= new ApexPages.Standardcontroller(asp2);
            ProposedConferenceAttendanceController newpcaController5 = new ProposedConferenceAttendanceController(sc5);
            
            newpcaController5.showPCARelatedlist = 'false';
            newpcaController5.preparePCAList();
            
            newpcaController5.showPCARelatedlist = 'true';
            newpcaController5.preparePCAList();
            newpcaController5.addRows();
            
            //new button and save test
            newpcaController5.showPCARelatedlist = 'false';
            newpcaController5.preparePCAList();
            newpcaController5.addRows();
        }
    }
        
        static testMethod void testpcaCtrl2() {
        
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser) {
            
                    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='stsyuser@sfdc.com');
                                                          
                    insert u;
                
                    User unew = new User(Alias = 'standtn', Email='standardusernew@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='stsyusernew@sfdc.com');
                                                          
                    insert unew;
                    Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GS',OwnerId = u.Id);
                    insert asp;
                    
                    RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference'];
            
                    Campaign camp = new Campaign(Name='Campaign1',RecordTypeId= rt.id,Location__c='Test loc',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing;Testingnew',Presenting__c='Testing',isActive=true);         
                    insert camp;
                    
                    Annual_Sales_Plan_Items__c pca = new Annual_Sales_Plan_Items__c(PCA_Record__c = true);
                    pca.Annual_Sales_Plan__c = asp.Id; 
                    pca.Conference_Name_Presentation_Proposed__c= camp.id;
                    insert pca;            
                    
                    Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
                    insert asp1;
                    
                    ApexPages.StandardController sc = new ApexPages.StandardController(asp);
                    ProposedConferenceAttendanceController newpcaController = new ProposedConferenceAttendanceController(sc);
                    
                    //new button test
                    newpcaController.showPCARelatedlist  = 'true';
                    newpcaController.preparePCAList();
                    newpcaController.addRows();
                               
                    //remove rows test
                    newpcaController.showPCARelatedlist = pca.Id;
                    newpcaController.removeRows();
                    newpcaController.savePCA();
                   
                    Campaign camp1 = new Campaign (Name='Campaign2',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testingnew',Presenting__c='Testing;Testingnew',isActive=true);
                    insert camp1;
                
                    camp1.BDAttending__c='Testing';
                    update camp1;

                    Annual_Sales_Plan_Items__c pca1 = new Annual_Sales_Plan_Items__c(PCA_Record__c = true);
                    pca1.Annual_Sales_Plan__c = asp1.Id; 
                    pca1.Conference_Name_Presentation_Proposed__c= camp1.id;
                    insert pca1; 
                    
                    ApexPages.StandardController sc1 = new ApexPages.StandardController(asp1);
                    ProposedConferenceAttendanceController newpcaController1 = new ProposedConferenceAttendanceController(sc1);
                    
                    //new button test
                    newpcaController1.showPCARelatedlist  = 'true';
                    newpcaController1.preparePCAList();
                    newpcaController1.addRows();
                    
                    //remove rows test
                    newpcaController1.showPCARelatedlist = pca1.Id;
                    newpcaController1.removeRows();
                    newpcaController1.savePCA();
                                       
                    Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
                    insert asp2;
                    
                    Campaign camp2 = new Campaign (Name='Campaign3',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today()+5,BDAttending__c='Testing',Presenting__c='Testingnew',isActive=true);
                    insert camp2;
                    camp2.BDAttending__c='Testingnew';
                    update camp2;
            
                    Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c();
                    pca2.Annual_Sales_Plan__c = asp2.Id; 
                    pca2.Conference_Name_Presentation_Proposed__c= camp2.id;
                    insert pca2;
                    
                    ApexPages.StandardController sc2 = new ApexPages.StandardController(asp2);
                    ProposedConferenceAttendanceController newpcaController2 = new ProposedConferenceAttendanceController(sc2);
                                        
                    //new button test
                    newpcaController2.showPCARelatedlist  = 'true';
                    newpcaController2.preparePCAList();
                    newpcaController2.addRows();
                    
                    //remove rows test
                    newpcaController2.showPCARelatedlist = pca2.Id;
                    newpcaController2.removeRows();
                    newpcaController2.savePCA();
                    
                    Annual_Sales_Plan__c asp3 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
                    insert asp3;
                    
                    Campaign camp3 = new Campaign (Name='Campaign3',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today().addDays(5),BDAttending__c='Testing',Presenting__c='Testingnew',isActive=true);
                    insert camp3;
                    camp3.BDAttending__c='Testingnew';
                    update camp3;

                    ApexPages.StandardController sc3 = new ApexPages.StandardController(asp3);
                    ProposedConferenceAttendanceController newpcaController3 = new ProposedConferenceAttendanceController(sc3);
                                  
                    //new button test
                    for(ProposedConferenceAttendanceController.PCAWrapper pcawTemp : newpcaController3.listPCA) {
                        pcawTemp.pca.Annual_Sales_Plan__c = asp3.Id; 
                        pcawTemp.pca.Conference_Name_Presentation_Proposed__c = camp3.id;
                    }
                    newpcaController3.savePCA();                    
                    
                }
            }
            
            static testMethod void savePCA(){
                User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
                RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Campaign' AND Name='Conference'];
                System.runAs (thisUser) {
            
                    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='stsyuser@sfdc.com');
                                                          
                    insert u;
                    
                    Annual_Sales_Plan__c asp3 = new Annual_Sales_Plan__c(Name='BusDev Plan FY2017 DTeam@GSnew',OwnerId = u.Id);
                    insert asp3;
                    
                    Campaign camp3 = new Campaign (Name='Campaign3',RecordTypeId=rt.id,Location__c='Test loc1',StartDate=System.today(),EndDate=System.today().addDays(5),BDAttending__c='Testing',Presenting__c='Testingnew',isActive=true);
                    insert camp3;
                    camp3.BDAttending__c='Testingnew';
                    update camp3;
                    
                    ApexPages.StandardController sc3 = new ApexPages.StandardController(asp3);
                    ProposedConferenceAttendanceController newpcaController3 = new ProposedConferenceAttendanceController(sc3);
                    ProposedConferenceAttendanceController.PCAWrapper wrapper = new ProposedConferenceAttendanceController.PCAWrapper();
                    wrapper.pca = new Annual_Sales_Plan_Items__c(Annual_Sales_Plan__c = asp3.Id);
                    newpcaController3.listPCA.add(wrapper) ;              
                    //new button test
                    for(ProposedConferenceAttendanceController.PCAWrapper pcawTemp : newpcaController3.listPCA) {
                        pcawTemp.pca.Annual_Sales_Plan__c = asp3.Id; 
                        pcawTemp.pca.Conference_Name_Presentation_Proposed__c = camp3.id;
                    }
                    newpcaController3.savePCA();     
                }
            }
            
            static testMethod void testApprovedAggController() {
            
                Test.startTest();
                
                Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c();
                asp.Name = 'test asp1';
                insert asp;
                
                ApexPages.StandardController sc2 = new ApexPages.StandardController(asp);
                ApprovedAggController newpcaController2 = new ApprovedAggController(sc2);
                
                newpcaController2.showPCARelatedlist = 'false';
                newpcaController2.preparePCAList();
                
                newpcaController2.showPCARelatedlist = 'true';
                newpcaController2.preparePCAList();
                
                newpcaController2.showPCARelatedlist = 'false';
                newpcaController2.preparePCAList();
                newpcaController2.addRows();
                
                Account acc = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId() ,Name = 'acc1', Type = 'Aggregator', Approved__c = 'Yes');
                insert acc;
                
                Annual_Sales_Plan_Items__c pcaNew = new Annual_Sales_Plan_Items__c();
                pcaNew.Approved_Aggregator_Name__c= acc.id;
                pcaNew.Annual_Sales_Plan__c = asp.id;
                insert pcaNew;
                
                PageReference pageRef = Page.Current_Aggregators_Page;
                Test.setCurrentPage(pageRef);
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(asp);
                ApprovedAggController newpcaController = new ApprovedAggController(sc);
                
                newpcaController.showPCARelatedlist = 'false';
                newpcaController.preparePCAList();
                
                newpcaController.showPCARelatedlist = 'true';
                newpcaController.preparePCAList();
                newpcaController.addRows();
                
                //new button and save test
                newpcaController.showPCARelatedlist = 'false';
                newpcaController.preparePCAList();
                newpcaController.addRows();
            Test.stopTest();
        }
        
        static testMethod void testApprovedAggController2() {
        
            Test.startTest();
            //user test data
           
            //asp test data
            Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c();
            asp2.Name = 'test asp New';
            insert asp2;
            
            Account acc = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId() ,Name = 'acc1', Type = 'Aggregator', Approved__c = 'Yes');
            insert acc;
            
            Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c();
            pca2.Annual_Sales_Plan__c = asp2.Id; 
            pca2.Approved_Aggregator_Name__c= acc.id;
            insert pca2;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(asp2);
            ApprovedAggController newpcaController = new ApprovedAggController(sc);
            
            //new button test
            newpcaController.showPCARelatedlist  = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //remove rows test
            newpcaController.showPCARelatedlist = pca2.Id;
            newpcaController.removeRows();
            newpcaController.saveCurrentAgg();
            
            Test.stopTest();
        }
        
        static testMethod void testTargetESSSController() {
        
            Test.startTest();
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name = 'test asp1',Start_Date__c=Date.newInstance(System.today().year(), 2, 1),End_Date__c=Date.newInstance(System.today().year(), 2, 17));
            insert asp;
            
            
            Account acc = new Account(name = 'acc1');
            insert acc;  
            
            List<Opportunity> oppList = new List<Opportunity>();
            Opportunity opp1 = new Opportunity(Name = 'Opp 2015', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate =Date.newInstance(System.today().year(), 2, 14), StageName = 'Prospecting');
            oppList.add(opp1);
                    
            Opportunity opp2 = new Opportunity(Name = 'Opp 2016', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate =Date.newInstance(System.today().year(), 2, 18), StageName = 'Prospecting');
            oppList.add(opp2);
            
            Insert oppList; 
            
            Annual_Sales_Plan_Items__c pcaNew = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target ESSS Schools');
            pcaNew.School_Name__c= acc.id;
            pcaNew.Annual_Sales_Plan__c = asp.id;
            insert pcaNew;          
            
            
            Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name = 'test asp1',Start_Date__c=System.today(),End_Date__c=System.today()+15);
            insert asp1; 
            
            RecordType rtAccount = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Association'];
            
            Account acc1 = new Account(name = 'acc1',recordtypeId = rtAccount.id);
            insert acc1;  
            
            List<Opportunity> oppList1 = new List<Opportunity>();
            Opportunity opp3 = new Opportunity(Name = 'Opp 2015', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+5, StageName = 'Prospecting');
            oppList1.add(opp3);
                    
            Opportunity opp4 = new Opportunity(Name = 'Opp 2016', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+16, StageName = 'Prospecting');
            oppList1.add(opp4);
            
            Insert oppList1; 
            
            Annual_Sales_Plan_Items__c pcaNew1 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target ESSS Schools');
            pcaNew1.School_Name__c= acc1.id;
            pcaNew1.Annual_Sales_Plan__c = asp1.id;
            insert pcaNew1; 
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(asp);
            TargetESSSController newpcaController2 = new TargetESSSController(sc2);
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'true';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            newpcaController2.addRows();
                       
            
            PageReference pageRef = Page.Target_Schools_Page;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(asp);
            TargetESSSController newpcaController = new TargetESSSController(sc);
            
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            
            newpcaController.showPCARelatedlist = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //new button and save test
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            
            ApexPages.StandardController sc3 = new ApexPages.StandardController(asp1);
            TargetESSSController newpcaController3 = new TargetESSSController(sc3);
            
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();
            
            newpcaController3.showPCARelatedlist = 'true';
            newpcaController3.preparePCAList();
            
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();
            newpcaController3.addRows();
                       
            
            PageReference pageRef1 = Page.Target_Schools_Page;
            Test.setCurrentPage(pageRef1);
            ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(asp1);
            TargetESSSController newpcaController4 = new TargetESSSController(sc4);
            
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            
            newpcaController4.showPCARelatedlist = 'true';
            newpcaController4.preparePCAList();
            newpcaController4.addRows();
            
            //new button and save test
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            newpcaController4.addRows();
            Test.stopTest();
        }
        
        static testMethod void testTargetESSSController2() {
        
            Test.startTest();
           //user test data
           
            //asp test data
            Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c(Name = 'test asp New',Start_Date__c=System.today()-2,End_Date__c=System.today()+15);
            insert asp2;
            
            Account acc2 = new Account(name = 'acc2');
            insert acc2;
            
            List<Opportunity> oppListnew = new List<Opportunity>();
            Opportunity opp1 = new Opportunity(Name = 'Opp 2016', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+5, StageName = 'Prospecting');
            oppListnew.add(opp1);
                    
            Opportunity opp2 = new Opportunity(Name = 'Opp 2014', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+16, StageName = 'Prospecting');
            oppListnew.add(opp2);
            
            Insert oppListnew;      
            
            Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target ESSS Schools');
            pca2.Annual_Sales_Plan__c = asp2.Id; 
            pca2.School_Name__c= acc2.id;
            insert pca2;
            
            Annual_Sales_Plan__c asp3 = new Annual_Sales_Plan__c(Name = 'test asp New',Start_Date__c=System.today()-2,End_Date__c=System.today()+15);
            insert asp3;
            
            Account acc3 = new Account(name = 'acc3');
            insert acc3;
            
            List<Opportunity> oppListnew1 = new List<Opportunity>();
            Opportunity opp3 = new Opportunity(Name = 'Opp 2016', AccountId = acc3.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+5, StageName = 'Prospecting');
            oppListnew.add(opp3);
                    
            Opportunity opp4 = new Opportunity(Name = 'Opp 2014', AccountId = acc3.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+16, StageName = 'Prospecting');
            oppListnew.add(opp4);
            
            Insert oppListnew1;      
            
            Annual_Sales_Plan_Items__c pca3 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target School');
            pca3.Annual_Sales_Plan__c = asp3.Id; 
            pca3.School_Name__c= acc3.id;
            insert pca3;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(asp2);
            TargetESSSController newpcaController = new TargetESSSController(sc);
            
            //new button test
            newpcaController.showPCARelatedlist  = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
        
            
            //remove rows test
            newpcaController.showPCARelatedlist = pca2.Id;
            newpcaController.removeRows();
            newpcaController.saveTargetESSS();
            for(TargetESSSController.PCAWrapper p : newpcaController.listPCA){
                p.pca.School_Name__c = acc2.Id;
                newpcaController.selIndex = String.valueOf(p.index);
                newpcaController.selAccId  = acc2.Id;
            }
            newpcaController.retrieveOpps();
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(asp3);
            TargetESSSController newpcaController1 = new TargetESSSController(sc1);
            
            //new button test
            newpcaController1.showPCARelatedlist  = 'true';
            newpcaController1.preparePCAList();
            newpcaController1.addRows();
    
            
            //remove rows test
            newpcaController1.showPCARelatedlist = pca3.Id;
            newpcaController1.removeRows();
            newpcaController1.saveTargetESSS();
            
            
            Test.stopTest();
        }
        
        static testMethod void testTargetAggController() {
        
            Test.startTest();
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c();
            asp.Name = 'test asp1';
            insert asp;
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(asp);
            TargetAggController newpcaController2 = new TargetAggController(sc2);
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'true';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            newpcaController2.addRows();
            
            Account acc = new Account(name = 'acc1');
            insert acc;
            
            Annual_Sales_Plan_Items__c pcaNew = new Annual_Sales_Plan_Items__c();
            pcaNew.Target_Aggregator_Name__c= 'Tar Aggregator 1';
            pcaNew.Annual_Sales_Plan__c = asp.id;
            insert pcaNew;
            
            PageReference pageRef = Page.Target_Aggregators_Page;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(asp);
            TargetAggController newpcaController = new TargetAggController(sc);
            
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            
            newpcaController.showPCARelatedlist = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //new button and save test
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            Test.stopTest();
        }
        
        static testMethod void testTargetAggController2() {
        
            Test.startTest();
            //user test data
           
            //asp test data
            Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c();
            asp2.Name = 'test asp New';
            insert asp2;
            
            Account acc = new Account(name = 'acc1');
            insert acc;
            
            Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c();
            pca2.Annual_Sales_Plan__c = asp2.Id; 
            pca2.Target_Aggregator_Name__c= 'Tar Agg 2';
            insert pca2;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(asp2);
            TargetAggController newpcaController = new TargetAggController(sc);
            
            //new button test
            newpcaController.showPCARelatedlist  = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //remove rows test
            newpcaController.showPCARelatedlist = pca2.Id;
            newpcaController.removeRows();
            newpcaController.saveTargetAgg();
            
            Test.stopTest();
        }
        
        static testMethod void testTargetSchoolController() {
        
            Test.startTest();
            
            Annual_Sales_Plan__c asp = new Annual_Sales_Plan__c(Name = 'test asp1',Start_Date__c=Date.newInstance(System.today().year(), 2, 1),End_Date__c=Date.newInstance(System.today().year(), 2, 17));
            insert asp;
            
             
            Account acc = new Account(name = 'acc1');
            insert acc;  
            
            List<Opportunity> oppList = new List<Opportunity>();
            Opportunity opp1 = new Opportunity(Name = 'Opp 2015', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate =Date.newInstance(System.today().year(), 2, 14), StageName = 'Prospecting');
            oppList.add(opp1);
                    
            Opportunity opp2 = new Opportunity(Name = 'Opp 2016', AccountId = acc.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate =Date.newInstance(System.today().year(), 2, 18), StageName = 'Prospecting');
            oppList.add(opp2);
            
            Insert oppList; 
            
            Annual_Sales_Plan_Items__c pcaNew = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target School');
            pcaNew.School_Name__c= acc.id;
            pcaNew.Annual_Sales_Plan__c = asp.id;
            insert pcaNew;          
            
            
            Annual_Sales_Plan__c asp1 = new Annual_Sales_Plan__c(Name = 'test asp1',Start_Date__c=System.today(),End_Date__c=System.today()+15);
            insert asp1; 
            
            RecordType rtAccount = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Association'];
            
            Account acc1 = new Account(name = 'acc1',RecordTypeId = rtAccount.Id);
            insert acc1;  
            
            List<Opportunity> oppList1 = new List<Opportunity>();
            Opportunity opp3 = new Opportunity(Name = 'Opp 2015', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+5, StageName = 'Prospecting');
            oppList1.add(opp3);
                    
            Opportunity opp4 = new Opportunity(Name = 'Opp 2016', AccountId = acc1.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+16, StageName = 'Prospecting');
            oppList1.add(opp4);
            
            Insert oppList1; 
            
            Annual_Sales_Plan_Items__c pcaNew1 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target School');
            pcaNew1.School_Name__c= acc1.id;
            pcaNew1.Annual_Sales_Plan__c = asp1.id;
            insert pcaNew1; 
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(asp);
            TargetSchoolsController newpcaController2 = new TargetSchoolsController(sc2);
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'true';
            newpcaController2.preparePCAList();
            
            newpcaController2.showPCARelatedlist = 'false';
            newpcaController2.preparePCAList();
            newpcaController2.addRows();
            
            PageReference pageRef = Page.Target_Schools_Page;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(asp);
            TargetSchoolsController newpcaController = new TargetSchoolsController(sc);
            
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            
            newpcaController.showPCARelatedlist = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //new button and save test
            newpcaController.showPCARelatedlist = 'false';
            newpcaController.preparePCAList();
            newpcaController.addRows();            
            
            ApexPages.StandardController sc3 = new ApexPages.StandardController(asp1);
            TargetSchoolsController newpcaController3 = new TargetSchoolsController(sc3);
            
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();           
            
            newpcaController3.showPCARelatedlist = 'true';
            newpcaController3.preparePCAList();           
            
            newpcaController3.showPCARelatedlist = 'false';
            newpcaController3.preparePCAList();
           
            newpcaController3.addRows();
                       
            
            PageReference pageRef1 = Page.Target_Schools_Page;
            Test.setCurrentPage(pageRef1);
            ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(asp1);
            TargetSchoolsController newpcaController4 = new TargetSchoolsController(sc4);
            
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            
            
            newpcaController4.showPCARelatedlist = 'true';
            newpcaController4.preparePCAList();
            newpcaController4.addRows();            
            
            //new button and save test
            newpcaController4.showPCARelatedlist = 'false';
            newpcaController4.preparePCAList();
            newpcaController4.addRows();
            
            
            Test.stopTest();
        }
        
 static testMethod void testTargetSchoolsController2() {
        
            Test.startTest();
            //user test data
           
            //asp test data
            Annual_Sales_Plan__c asp2 = new Annual_Sales_Plan__c(Name = 'test asp New',Start_Date__c=Date.newInstance(System.today().year(), 5, 1),End_Date__c=Date.newInstance(System.today().year(), 5,20));
            insert asp2;
            
            Account acc2 = new Account(name = 'acc2');
            insert acc2;
            
            List<Opportunity> oppListnew = new List<Opportunity>();
            Opportunity opp1 = new Opportunity(Name = 'Opp 2016', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.newInstance(System.today().year(), 5, 10), StageName = 'Prospecting');
            oppListnew.add(opp1);
                    
            Opportunity opp2 = new Opportunity(Name = 'Opp 2014', AccountId = acc2.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = Date.newInstance(System.today().year(), 5, 21), StageName = 'Prospecting');
            oppListnew.add(opp2);
            
            Insert oppListnew;      
            
            Annual_Sales_Plan_Items__c pca2 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target School');
            pca2.Annual_Sales_Plan__c = asp2.Id; 
            pca2.School_Name__c= acc2.id;
            insert pca2;
            
            Annual_Sales_Plan__c asp3 = new Annual_Sales_Plan__c(Name = 'test asp New',Start_Date__c=System.today()-2,End_Date__c=System.today()+15);
            insert asp3;
            
            Account acc3 = new Account(name = 'acc3');
            insert acc3;
            
            List<Opportunity> oppListnew1 = new List<Opportunity>();
            Opportunity opp3 = new Opportunity(Name = 'Opp 2016', AccountId = acc3.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+5, StageName = 'Prospecting');
            oppListnew1.add(opp3);
                    
            Opportunity opp4 = new Opportunity(Name = 'Opp 2014', AccountId = acc3.Id, Type = 'Standard', LeadSource = 'RFI', CloseDate = System.today()+16, StageName = 'Prospecting');
            oppListnew1.add(opp4);
            
            Insert oppListnew1;      
            
            Annual_Sales_Plan_Items__c pca3 = new Annual_Sales_Plan_Items__c(Target_Record__c = 'Target School');
            pca3.Annual_Sales_Plan__c = asp3.Id; 
            pca3.School_Name__c= acc3.id;
            insert pca3;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(asp2);
            TargetSchoolsController newpcaController = new TargetSchoolsController(sc);
            
            //new button test
            newpcaController.showPCARelatedlist  = 'true';
            newpcaController.preparePCAList();
            newpcaController.addRows();
            
            //remove rows test
            newpcaController.showPCARelatedlist = pca2.Id;
            newpcaController.removeRows();
            newpcaController.saveTargetESSS();
            
            for(TargetSchoolsController.PCAWrapper p : newpcaController.listPCA){
                p.pca.School_Name__c = acc3.Id;
                newpcaController.selIndex = String.valueOf(p.index);
                newpcaController.selAccId  = acc3.Id;
            }
            newpcaController.retrieveOpps();
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(asp3);
            TargetSchoolsController newpcaController1 = new TargetSchoolsController(sc1);
            
            //new button test
            newpcaController1.showPCARelatedlist  = 'true';
            newpcaController1.preparePCAList();
            newpcaController1.addRows();            
            
            //remove rows test
            newpcaController1.showPCARelatedlist = pca3.Id;
            newpcaController1.removeRows();
            newpcaController1.saveTargetESSS();
           
            Test.stopTest();
        }
}