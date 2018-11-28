@isTest
public class TestNoActivityOnOppReminderTrg{

    Static testMethod void NoActivityOnOppReminderTrgTest(){
        Test.StartTest();
        User us = [select id from user where Name = 'Buena Cloud Development' and IsActive = True LIMIT 1];
        Boolean task60Days = true;
        Boolean event60Days = true;
        Boolean task90Days = true;
        Boolean event90Days = true;
        
        Account a = new Account();
        a.name = 'TestAccount' ;
        a.Contract_End__c = date.Today() ;
        insert a ;
        
        Opportunity o = new Opportunity();  
        o.name = 'Test2014' ;     
        o.Type = 'Standard' ;
        o.Accountid = a.id ;
        o.LeadSource = 'Web' ;
        o.StageName = 'Prospect' ;
        o.CloseDate = date.Today() ;
        o.X60_days_No_Activity_Reminder__c = false ;
        o.X90_days_No_Activity_Reminder__c = false ;
        insert o ;  
        
        o.X60_days_No_Activity_Reminder__c = true ;
        o.X90_days_No_Activity_Reminder__c = false;
        update o ;               
        
        o.X90_days_No_Activity_Reminder__c = true ;
        update o ;
        
        Event e = new Event();
        e.Ownerid = us.id ;
        e.Subject = 'describe task' ;
        e.Type = 'Email' ;
        e.StartDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        e.EndDateTime = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        e.WhatId = o.id ;
        insert e ;
        
        Task t = new Task();
        t.Ownerid = us.id ;
        t.Subject = 'describe task' ; 
        t.Type = 'Email' ;
        t.Status = 'In Progress' ;
        t.Priority = 'Normal' ;
        t.WhatId = o.id ;              
        insert t ;                                    
                                    
        Test.StopTest();  
    
    
    }

}