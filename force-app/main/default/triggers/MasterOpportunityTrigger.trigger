trigger MasterOpportunityTrigger on Opportunity (after Insert, after Update, before Insert,before Update){
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OppTriggerHandler.noActivityOnOppReminderTrg(Trigger.new, Trigger.oldMap);
        }
        OppTriggerHandler.showEnrollmentFromRecentOpp(Trigger.new, Trigger.oldMap);
        OppTriggerHandler.updateEnrollmentActual(Trigger.new, Trigger.oldMap);    
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            OppTriggerHandler.updateFullTimeEnrollmentOnOpp(Trigger.new);
            OppTriggerHandler.updateProprietary(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            OppTriggerHandler.rollOverOppty(Trigger.new, Trigger.oldMap);
            OppTriggerHandler.productExistValidation(Trigger.new, Trigger.oldMap);
        }
    }
}