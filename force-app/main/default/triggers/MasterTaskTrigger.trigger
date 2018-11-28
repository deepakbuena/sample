trigger MasterTaskTrigger on Task (before Insert, before Update, after Insert ,after Update) {

    if(Trigger.isBefore){
        TaskTriggerHandlerCls.taskFlagCheck(Trigger.new);
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            TaskTriggerHandlerCls.taskTrigger(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isInsert){
            TaskTriggerHandlerCls.noActivityOnOppTask(Trigger.new);
        }   
    }
}