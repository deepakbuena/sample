/*
@Name                : CreateLeadForAttendeesTrg
@Author              : GS Dev Team
@Date                : September 26, 2016
@Description         : Trigger to create a new lead record if ReadyTalk Meeting Member status becomes 'Attended'.
*/

trigger CreateLeadForAttendeesTrg on RT1__ReadyTalkMeetingMember__c (after insert, after update) {
    
    try{
        List<Lead> ldNewList = new List<Lead>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id From Contact Where AccountId = null OR Account.Contract_End__c <: System.Today()]);
        
        for(RT1__ReadyTalkMeetingMember__c meetMem : Trigger.new){
        
            if((trigger.isInsert ||(trigger.isUpdate && meetMem.RT1__Status__c != Trigger.oldMap.get(meetMem.Id).RT1__Status__c)) && meetMem.RT1__Status__c == 'Attended' && meetMem.RT1__Lead__c == null){
                if(meetMem.RT1__Contact__c == null || contactMap.containsKey(meetMem.RT1__Contact__c)){
                    Lead ld = new Lead();
                    ld.FirstName = meetMem.RT1__RegistrationFirstName__c ;
                    ld.LastName =  meetMem.RT1__RegistrationLastName__c ;
                    ld.Email = meetMem.RT1__RegistrationEmail__c ; 
                    ld.Company =  meetMem.RT1__RegistrationCompany__c ;
                    ld.Status = 'Open';
                    ldNewList.add(ld); 
                }
            }
        }
        if(ldNewList.size()>0){
            Database.insert(ldNewList,false);
        }
    }
    catch(Exception e){
        System.debug('An exception has occurred: '+e.getMessage() + ' - ' + e.getLineNumber());
    }
}