trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {

	Set<Id> opptyList = new Set<Id>();

	if(Trigger.isAfter){

		if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){

			OpportunityLineItem[] lineItemList;

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
}