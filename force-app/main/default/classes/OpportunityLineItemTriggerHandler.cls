public with sharing class OpportunityLineItemTriggerHandler{
    
    // Ensure trigger only run once
    public static Boolean runOnce = false;

    public static void applyDiscount(Set<Id> opptyList){

        runOnce = true;
        Set<String> discountProductCodes = new Set<String>{'STATE-DISC','ASSOC-DISC-10','ASSOC-DISC','MUTLI-YR-DISC','ACT-DISC'};
        
        List<OpportunityLineItem> opptyLineItemUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> prodLineItemUpdate =  new List<OpportunityLineItem>();
        
        Map<Id, double> discountRate = new Map<Id, double>();
        
        try{
            // SELECT only OpportunityLineItems that has a discount lineitem and eligible for discount
            List<Opportunity> opptyDetailList = [SELECT Id,account.type ,Activation_Reward_Discount__c,                      
                                                    (SELECT Quantity,
                                                    UnitPrice,
                                                    ProductCode,
                                                    Product2.Discount_Eligible__c,
                                                    PricebookEntry.UnitPrice,OpportunityId,
                                                    ListPrice    
                                                    FROM OpportunityLineItems
                                                    WHERE Product2.Discount_Eligible__c = true
                                                    OR ProductCode IN :discountProductCodes
                                                    ORDER BY UnitPrice ASC)
                                                FROM Opportunity
                                                WHERE Id IN (SELECT OpportunityId 
                                                    FROM OpportunityLineItem 
                                                    WHERE ProductCode IN :discountProductCodes
                                                    AND OpportunityId IN :opptyList)];
            
            if(opptyDetailList.size() > 0){
                for(Opportunity oppty : opptyDetailList){        
                    discountRate.put(oppty.id, oppty.Activation_Reward_Discount__c );
                }
            }     
                    
            if(opptyDetailList.size() > 0){
    
                for(Opportunity oppty : opptyDetailList){
                    Boolean discountItemFound = false;
                    OpportunityLineItem[] discountItems = new OpportunityLineItem[]{};
                    OpportunityLineItem productLineItem;
                    
                    for(OpportunityLineItem oLineItem : oppty.OpportunityLineItems){
                    
                        // Find the first discount product item
                        if(discountProductCodes.contains(oLineItem.ProductCode)){
                            discountItems.add(oLineItem);
                        }
                        
                        // Find the first item that is not a discount line item
                        if(discountProductCodes.contains(oLineItem.ProductCode) == false && discountItemFound == false){
                            productLineItem = oLineItem;
                            discountItemFound = true;
                        }
                    }
                    
                    if(discountItems.size() > 0 && productLineItem != null){
                        
                        for(OpportunityLineItem discountLineItem : discountItems){
                            if(discountLineItem.ProductCode == 'STATE-DISC' || discountLineItem.ProductCode == 'ASSOC-DISC'){
                            
                                // When products "Discount:  Association" or "Discount:  State" is added, 
                                // set the 'Sales Price' amount to negative 15% of the discount eligible products.
                                discountLineItem.Quantity = 1;
                                discountLineItem.UnitPrice = productLineItem.Quantity * productLineItem.UnitPrice * -0.15;
                                opptyLineItemUpdate.add(discountLineItem);
                            }
                            if(discountLineItem.ProductCode == 'ASSOC-DISC-10'){
                                
                                // When products "Discount:  Association" or "Discount:  State" is added, 
                                // set the 'Sales Price' amount to negative 15% of the discount eligible products.
                                discountLineItem.Quantity = 1;
                                discountLineItem.UnitPrice = productLineItem.Quantity * productLineItem.UnitPrice * -0.10;
                                opptyLineItemUpdate.add(discountLineItem);
                            }
                            
                            if(discountLineItem.ProductCode == 'MUTLI-YR-DISC'){
                                discountLineItem.Quantity = 1;
                                
                                // When any of the above product's list price is equal or below $15,000
                                // set the value of OpportunityProductLineItem Sale Price amount to negative $2,500; 
                                if(productLineItem.UnitPrice <= 15000){
                                    discountLineItem.UnitPrice = -2500;
                                }
                                
                                // When any of the above product's list price above $15,000
                                // set the value of OpportunityProductLineItem Sale Price amount to negative $5,000
                                if(productLineItem.UnitPrice > 15000){
                                    discountLineItem.UnitPrice = -5000;
                                }
                                opptyLineItemUpdate.add(discountLineItem);
                            }
                        }
                    }
                }
            }
            
            if(opptyDetailList.size() > 0){
            
                for(Opportunity oppty : opptyDetailList){
                    List<OpportunityLineItem> discountItems = new List<OpportunityLineItem>();
                    List<OpportunityLineItem> prodLineItem=new List<OpportunityLineItem>();
                    
                    for(OpportunityLineItem oLineItem : oppty.OpportunityLineItems){
                    
                        // Find the first discount product item
                        if(oLineItem.ProductCode=='ACT-DISC'){
                            discountItems.add(oLineItem);
                        }
                        
                        // Find the first item that is not a discount line item
                        if(!discountProductCodes.contains(oLineItem.ProductCode)){
                            prodLineItem.add(oLineItem);
                        }
                    }
                    
                    if(discountItems.size() > 0 && prodLineItem!= null){    
                    
                        for(OpportunityLineItem discountLineItem : discountItems){
                            if(discountLineItem.ProductCode == 'ACT-DISC'){
                                Double discount= discountRate.get(discountLineItem.opportunityID)!= null ? discountRate.get(discountLineItem.opportunityID) :0; 
                                discountLineItem.Quantity = 1;
                                Double totalDiscount=0;
                                
                                for(OpportunityLineItem pliTemp : prodLineItem){
                                    totalDiscount+=((discount/100) * pliTemp.ListPrice)*pliTemp.Quantity;
                                }
                                if(totalDiscount>0)
                                totalDiscount= totalDiscount*-1;
                                
                                discountLineItem.UnitPrice = totalDiscount;
                                prodLineItemUpdate.add(discountLineItem);  
                            }
                        } 
                    }
                }
            }
            
            if(opptyLineItemUpdate.size() > 0){
                Database.update(opptyLineItemUpdate,false);
            }
            
            if(prodLineItemUpdate.size() > 0){
                Database.update(prodLineItemUpdate,false);
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public static void updateListPriceFromOpportunity(List<OpportunityLineItem> oliList){
    
        Set<Id> oppIds = new Set<Id>();
        Map<Id,Decimal> oppListPriceMap = new Map<Id,Decimal>();
        Set<Id> pbEntryIds = new Set<Id>();
        
        try{
            List<PricebookEntry> pbEntryList = [Select Id, Pricebook2.Name From PricebookEntry Where Pricebook2.Name = 'Credit Union'];
            for(PricebookEntry pbETemp : pbEntryList){
                pbEntryIds.add(pbETemp.Id);      
            }
            if(pbEntryIds.size()>0){
                for(OpportunityLineItem oliTemp : oliList){
                    if(pbEntryIds.contains(oliTemp.PricebookEntryId)){
                        oppIds.add(oliTemp.OpportunityId); 
                    }   
                }
                
                if(oppIds.size()>0){
                    List<Opportunity> oppList = [Select Id, List_Price__c From Opportunity Where Id In : oppIds AND Type = 'Credit Union' AND RecordType.Name = 'Strategic Partnership'];
                    for(Opportunity oppTemp : oppList){
                        oppListPriceMap.put(oppTemp.Id,oppTemp.List_Price__c);    
                    }
                    for(OpportunityLineItem oliTemp : oliList){
                        if(oppListPriceMap.containsKey(oliTemp.OpportunityId) && oppListPriceMap.get(oliTemp.OpportunityId)!=null){
                            oliTemp.UnitPrice = oppListPriceMap.get(oliTemp.OpportunityId); 
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }       
    }
}