trigger CalculateSPEndDate on c2g__codaInvoice__c (before insert, before update) {
    
    Map<Id,Contract> conMap = new Map<Id,Contract>();
    
    Set<Id> conIds = new Set<Id>();
    
    for(c2g__codaInvoice__c siTemp : Trigger.new){
        conIds.add(siTemp.Contract__c);   
    }
    
    List<Contract> conList = [Select Id, Remaining_Invoices__c, Next_Invoice_Date__c, Invoice_Frequency__c, EndDate  From Contract Where Id In : conIds];
    
    if(conList.size()>0){
        for(Contract conTemp : conList){
            conMap.put(conTemp.Id, conTemp);   
        }
        for(c2g__codaInvoice__c siTemp : Trigger.new){
            if(conMap.containsKey(siTemp.Contract__c)){ 
                if(trigger.isInsert){
                    if(conMap.get(siTemp.Contract__c).Remaining_Invoices__c > 1 ){
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 3){
                            siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).Next_Invoice_Date__c.addMonths(3).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 1){
                            siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).Next_Invoice_Date__c.addMonths(1).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 6){
                            siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).Next_Invoice_Date__c.addMonths(6).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 12){
                            siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).Next_Invoice_Date__c.addMonths(12).addDays(-1);
                        }
                    }
                    else{
                        siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).EndDate;   
                    }
                }
                
                if(trigger.isUpdate){
                    if(conMap.get(siTemp.Contract__c).Remaining_Invoices__c > 0 ){
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 3){
                            siTemp.Service_Period_End_Date__c = siTemp.Service_Period_Start_Date__c.addMonths(3).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 1){
                            siTemp.Service_Period_End_Date__c = siTemp.Service_Period_Start_Date__c.addMonths(1).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 6){
                            siTemp.Service_Period_End_Date__c = siTemp.Service_Period_Start_Date__c.addMonths(6).addDays(-1);
                        }
                        if(conMap.get(siTemp.Contract__c).Invoice_Frequency__c == 12){
                            siTemp.Service_Period_End_Date__c = siTemp.Service_Period_Start_Date__c.addMonths(12).addDays(-1);
                        }
                    }
                    else{
                        siTemp.Service_Period_End_Date__c = conMap.get(siTemp.Contract__c).EndDate;   
                    }
                }
            }
        }
    }    
}