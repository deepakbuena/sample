trigger MasterOpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter){
        Set<Id> opptyList = new Set<Id>();
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
            List<OpportunityLineItem> lineItemList;
            if(Trigger.isInsert){
                lineItemList = Trigger.new;
            } else{
                lineItemList = Trigger.old;
            }
            if(!OpportunityLineItemTriggerHandler.runOnce){
                for(OpportunityLineItem opptylt : lineItemList){
                    opptyList.add(opptylt.OpportunityId);
                }
                OpportunityLineItemTriggerHandler.applyDiscount(opptyList);
            }
        }
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            OpportunityLineItemTriggerHandler.updateListPriceFromOpportunity(Trigger.new);
        }
    }
}