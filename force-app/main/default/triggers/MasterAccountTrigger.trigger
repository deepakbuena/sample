Trigger MasterAccountTrigger on Account (before Update, after Update) {

    if(Trigger.isBefore){
        AccountTriggerHandler.clearLostAsOfAcc(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isAfter){
        AccountTriggerHandler.oppProprietaryCheckAcc(Trigger.new,Trigger.oldMap);
    }
}