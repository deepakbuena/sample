/*
@Name                : UpdateLeadOnRTMeetMemHandlerCls
@Author              : GS Dev Team
@Date                : September 26, 2016
@Description         : Handler class to populate Lead on ReadyTalk Meeting Member object. This class is being used in LeadTrigger.
*/

public class UpdateLeadOnRTMeetMemHandlerCls{

    public static void updateLeadOnRTMeetMem(List<Lead> leadList){

        try{    
            Map<String,Lead> ldMap= new Map<String,Lead>();
            
            for(Lead ld : leadList){
                if(ld.Email != null){
                    ldMap.put(ld.Email,ld);
                }
            }
            if(ldMap.keySet().size()>0){
                Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id From Contact Where AccountId = null OR Account.Contract_End__c <: System.Today()]);
                List<RT1__ReadyTalkMeetingMember__c> rtmList = [Select id,RT1__Contact__c,RT1__RegistrationEmail__c,RT1__Lead__c,RT1__Status__c From RT1__ReadyTalkMeetingMember__c Where RT1__Status__c ='Attended'];
                List<RT1__ReadyTalkMeetingMember__c> rtmNewList = new List<RT1__ReadyTalkMeetingMember__c>();
                
                for(RT1__ReadyTalkMeetingMember__c rt : rtmList){
                    if(ldMap.containsKey(rt.RT1__RegistrationEmail__c) && (rt.RT1__Contact__c == null || contactMap.containsKey(rt.RT1__Contact__c)) && rt.RT1__Lead__c == null){                    
                        rt.RT1__Lead__c = ldMap.get(rt.RT1__RegistrationEmail__c).Id; 
                        rtmNewList.add(rt);                     
                    }
                }
                if(rtmNewList.size()>0){
                    Database.update(rtmNewList,false);
                }
            }
            
        }
        catch(Exception e){
             System.debug('An exception has occurred: ' + e.getMessage() + ' - '  + e.getLineNumber());
        }
    }
}