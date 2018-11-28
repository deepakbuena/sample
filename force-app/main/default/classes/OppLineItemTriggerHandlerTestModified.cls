@isTest
public with sharing class OppLineItemTriggerHandlerTestModified {
    
    testMethod static void OppLineItemTriggerHandlerTestModified() {
        
        Product2 p2 = new Product2(Name='pro01',ProductCode='STATE-DISC',Discount_Eligible__c = true);
        insert p2;
        
        Product2 p3 = new Product2(Name='pro02',ProductCode='ASSOC-DISC',Discount_Eligible__c = true);
        insert p3;
        
        Product2 p4 = new Product2(Name='pro03',ProductCode='MUTLI-YR-DISC',Discount_Eligible__c = true);
        insert p4;
        
        Product2 p5 = new Product2(Name='pro05',ProductCode='test product',Discount_Eligible__c = true);
        insert p5;
        
        Product2 p6 = new Product2(Name='pro06',ProductCode='ACT-DISC',Discount_Eligible__c = true);
        insert p6;
        
        Product2 p7 = new Product2(Name='pro07',ProductCode='test product2',Discount_Eligible__c = true);
        insert p7;
        
        Product2 p8 = new Product2(Name='pro08',ProductCode='MUTLI-YR-DISC',Discount_Eligible__c = true);
        insert p8;
        
        Id pricebookId = Test.getStandardPricebookId();
        Id pricebookId2 = Test.getStandardPricebookId();
        Id pricebookId3 = Test.getStandardPricebookId();
        Id pricebookId4 = Test.getStandardPricebookId();
        Id pricebookId5 = Test.getStandardPricebookId();
        Id pricebookId6 = Test.getStandardPricebookId();
        Id pricebookId7 = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p2.Id,
            UnitPrice = 25000, IsActive = true);
        insert standardPrice;
        
        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId2, Product2Id = p3.Id,
            UnitPrice = 25000, IsActive = true);
        insert standardPrice2;
        
        PricebookEntry standardPrice3 = new PricebookEntry(
            Pricebook2Id = pricebookId3, Product2Id = p4.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice3;
        
        PricebookEntry standardPrice4 = new PricebookEntry(
            Pricebook2Id = pricebookId4, Product2Id = p5.Id,
            UnitPrice = 24000, IsActive = true);
        insert standardPrice4;
        
        PricebookEntry standardPrice5 = new PricebookEntry(
            Pricebook2Id = pricebookId5, Product2Id = p6.Id,
            UnitPrice = 30000, IsActive = true);
        insert standardPrice5;
        
        PricebookEntry standardPrice6 = new PricebookEntry(
            Pricebook2Id = pricebookId6, Product2Id = p7.Id,
            UnitPrice = 30000, IsActive = true);
        insert standardPrice6;
        
        PricebookEntry standardPrice7 = new PricebookEntry(
            Pricebook2Id = pricebookId7, Product2Id = p8.Id,
            UnitPrice = 30000, IsActive = true);
        insert standardPrice7;

        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p2.Id,
            UnitPrice = 25000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice2 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p3.Id,
            UnitPrice = 25000, IsActive = true);
        insert customPrice2;
        
        PricebookEntry customPrice3 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p4.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice3;
        
        PricebookEntry customPrice4 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p5.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice4;
        
        PricebookEntry customPrice5 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p6.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice5;
        
        PricebookEntry customPrice6 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p7.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice6;
        //new
        PricebookEntry customPrice7 = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p8.Id,
            UnitPrice = 20000, IsActive = true);
        insert customPrice7;
        //
        Map<String, PriceBookEntry> discountMap = new Map<String, PriceBookEntry>();
        Map<Decimal, PriceBookEntry> productMap = new Map<Decimal, PriceBookEntry>(); 

        Set<String> discountProductCodes = new Set<String>{'STATE-DISC','ASSOC-DISC','MUTLI-YR-DISC','ACT-DISC'};
        
        PriceBookEntry[] pBookEntryProduct = [SELECT Id, Product2Id, ProductCode, UnitPrice, Pricebook2Id  FROM PriceBookEntry WHERE Pricebook2Id =:customPB.Id AND Product2.Discount_Eligible__c = true ];
        
        for(PriceBookEntry pbEntry : pBookEntryProduct){

            productMap.put(pbEntry.UnitPrice, pbEntry);
            
        } 
        System.debug('productMap' +productMap);
        
        PriceBookEntry[] pBookEntryDiscount = [SELECT Id, Product2Id, ProductCode, PriceBook2Id 
                                               FROM PriceBookEntry 
                                               WHERE ProductCode IN :discountProductCodes
                                               AND Pricebook2Id =:customPB.id ];

        for(PriceBookEntry pbEntry : pBookEntryDiscount){

            discountMap.put(pbEntry.ProductCode, pbEntry);
        }
        
        System.debug('discountMap' +discountMap);
        
        Account acct = new Account(name = 'test Account');
        insert acct;
        
        Opportunity newOppty = new Opportunity(name = 'Opportunity 2015');
        newOppty.CloseDate = System.today().addDays(30);
        newOppty.AccountId = acct.Id;
        newOppty.StageName = 'Prospect';
        newOppty.PriceBook2Id = customPB.id ; 
        insert newOppty;
        
        System.debug('newOppty' + newOppty);
        
        Opportunity newOppty2 = new Opportunity(name = 'Opportunity 2016');
        newOppty2.CloseDate = System.today().addDays(30);
        newOppty2.AccountId = acct.Id;
        newOppty2.StageName = 'Prospect';
        newOppty2.PriceBook2Id = customPB.id ; 
        insert newOppty2;
        
        System.debug('newOppty2' + newOppty2);
        
        Opportunity newOppty3 = new Opportunity(name = 'Opportunity 2014');
        newOppty3.CloseDate = System.today().addDays(30);
        newOppty3.AccountId = acct.Id;
        newOppty3.StageName = 'Prospect';
        newOppty3.PriceBook2Id = customPB.id ;
        insert newOppty3;
        
        System.debug('newOppty3' + newOppty3);
        
        Opportunity newOppty4 = new Opportunity(name = 'testOpportunity 2015');
        newOppty4.CloseDate = System.today().addDays(30);
        newOppty4.AccountId = acct.Id;
        newOppty4.StageName = 'Prospect';
        newOppty4.PriceBook2Id = customPB.id ; 
        insert newOppty4;
        
        system.debug('newOppty4 ' + newOppty4);
        
        Opportunity newOppty5 = new Opportunity(name = 'testOpportunity 2014');
        newOppty5.CloseDate = System.today().addDays(30);
        newOppty5.AccountId = acct.Id;
        newOppty5.StageName = 'Prospect';
        newOppty5.PriceBook2Id = customPB.id ; 
        insert newOppty5;

        OpportunityLineItem[] opptyLineItems = new OpportunityLineItem[]{};

        OpportunityLineItem discount = new OpportunityLineItem();
        discount.OpportunityId = newOppty.Id;
        discount.PriceBookEntryId = discountMap.get('STATE-DISC').Id;
        discount.Quantity = 1;
        discount.UnitPrice = 1;
        opptyLineItems.add(discount);

        OpportunityLineItem discount2 = new OpportunityLineItem();
        discount2.OpportunityId = newOppty2.Id;
        discount2.PriceBookEntryId = discountMap.get('ASSOC-DISC').Id;
        discount2.Quantity = 1;
        discount2.UnitPrice = 1;
        opptyLineItems.add(discount2);

        OpportunityLineItem discount3 = new OpportunityLineItem();
        discount3.OpportunityId = newOppty3.Id;
        discount3.PriceBookEntryId = discountMap.get('MUTLI-YR-DISC').Id;
        discount3.Quantity = 1;
        discount3.UnitPrice = -2500;
        opptyLineItems.add(discount3);
        
        OpportunityLineItem discount4 = new OpportunityLineItem();
        discount4.OpportunityId = newOppty5.Id;
        discount4.PriceBookEntryId = discountMap.get('ACT-DISC').Id;
        discount4.Quantity = 1;
        discount4.UnitPrice = 1;
        opptyLineItems.add(discount4);
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.OpportunityId = newOppty4.Id;
        item.PriceBookEntryId = pBookEntryProduct[2].Id;
        item.Quantity = 1;
        item.UnitPrice = pBookEntryProduct[2].UnitPrice;
        opptyLineItems.add(item);

        Test.startTest();

        insert opptyLineItems;
        System.debug('pBookEntryProduct list' + pBookEntryProduct);
        for(OpportunityLineItem oLine : [SELECT ProductCode, UnitPrice, Quantity FROM OpportunityLineItem WHERE OpportunityId =:newOppty.Id OR OpportunityId =:newOppty2.Id]){

            if(oLine.ProductCode == 'STATE-DISC'|| oLine.ProductCode == 'ASSOC-DISC'){

                system.assertEquals(1, oLine.Quantity);
               // system.assertEquals(item.Quantity * item.UnitPrice * -0.15 , oLine.UnitPrice);
            }
            
            system.debug('oLine.ProductCode' + oLine.ProductCode);
            if(oLine.ProductCode == 'MUTLI-YR-DISC'){

                system.assertEquals(1, oLine.Quantity);
                
                if(pBookEntryProduct[7].UnitPrice > 15000){
                    
                    system.assertEquals(-2500 , oLine.UnitPrice);
                } else {

                    system.assertEquals(-5000 , oLine.UnitPrice);
                }
            }
        }   

        // DELETE line items and use a different discount/product <-> Clear the list of line items
        delete opptyLineItems;
        opptyLineItems.clear();
        OpportunityLineItemTriggerHandler.runOnce = false; // Reset Handler

        discount = new OpportunityLineItem();
        discount.OpportunityId = newOppty3.Id;
        discount.PriceBookEntryId = discountMap.get('MUTLI-YR-DISC').Id;
        discount.Quantity = 1;
        discount.UnitPrice = -2500;
        opptyLineItems.add(discount);


        item = new OpportunityLineItem();
        item.OpportunityId = newOppty3.Id;
        item.PriceBookEntryId = productMap.get(10000.00).Id;
        item.Quantity = 1;
        item.UnitPrice = productMap.get(10000.00).UnitPrice;
        opptyLineItems.add(item);

        insert opptyLineItems;

        // VALIDATE: Multi-year discount 
        for(OpportunityLineItem oLine : [SELECT ProductCode, UnitPrice, Quantity FROM OpportunityLineItem WHERE OpportunityId = :newOppty3.Id]){
            system.debug('oLine 10000: ' + oLine);
            if(oLine.ProductCode == 'MUTLI-YR-DISC'){

                system.assertEquals(1, oLine.Quantity);
                system.assertEquals(-2500.00, oLine.UnitPrice);
            }
        }

        // DELETE line items and use a different discount/product <-> Clear the list of line items
        delete opptyLineItems;
        opptyLineItems.clear();
        OpportunityLineItemTriggerHandler.runOnce = false; // Reset Handler

        discount = new OpportunityLineItem();
        discount.OpportunityId = newOppty2.Id;
        discount.PriceBookEntryId = discountMap.get('ASSOC-DISC').Id;
        discount.Quantity = 1;
        discount.UnitPrice = 1;
        opptyLineItems.add(discount);

        item = new OpportunityLineItem();
        item.OpportunityId = newOppty2.Id;
        item.PriceBookEntryId = productMap.get(25000.00).Id;
        item.Quantity = 1;
        item.UnitPrice = productMap.get(25000.00).UnitPrice;
        opptyLineItems.add(item);

        insert opptyLineItems;

        for(OpportunityLineItem oLine : [SELECT ProductCode, UnitPrice, Quantity FROM OpportunityLineItem WHERE OpportunityId =:newOppty3.Id]){
            system.debug('oLine 25000: ' + oLine);
            if(oLine.ProductCode == 'MUTLI-YR-DISC'){

                system.assertEquals(1, oLine.Quantity);
                system.assertEquals(-5000.00 , oLine.UnitPrice);
            }
        }   

        Test.stopTest();
        
    }
}