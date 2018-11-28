trigger MasterSalesInvoiceTrg on c2g__codaInvoice__c (after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            EmailTrackingOnSalesInvoice.trackEmailonInvoice(Trigger.new,Trigger.oldMap);
        }
    }
}