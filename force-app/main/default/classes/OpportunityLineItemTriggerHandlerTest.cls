@isTest(SeeAllData=true)
public with sharing class OpportunityLineItemTriggerHandlerTest {

    testMethod static void OpportunityLineItemTriggerHandlerTest() {

        Map<String, PriceBookEntry> discountMap = new Map<String, PriceBookEntry>();
        Map<Decimal, PriceBookEntry> productMap = new Map<Decimal, PriceBookEntry>();

        Set<String> discountProductCodes = new Set<String>{'STATE-DISC','ASSOC-DISC','MUTLI-YR-DISC'};
        PriceBookEntry[] pBookEntryProduct = [SELECT Id, Product2Id, ProductCode, UnitPrice, Pricebook2Id 
                                                FROM PriceBookEntry 
                                                WHERE Product2.Discount_Eligible__c = true
                                                    AND Pricebook2Id = '01s60000000AaFH'];

        for(PriceBookEntry pbEntry : pBookEntryProduct){

            productMap.put(pbEntry.UnitPrice, pbEntry);
        }           


        PriceBookEntry[] pBookEntryDiscount = [SELECT Id, Product2Id, ProductCode, PriceBook2Id 
                                                FROM PriceBookEntry 
                                                WHERE ProductCode IN :discountProductCodes
                                                    AND Pricebook2Id = '01s60000000AaFH'];

        for(PriceBookEntry pbEntry : pBookEntryDiscount){

            discountMap.put(pbEntry.ProductCode, pbEntry);
        }

        Account acct = [SELECT Id FROM Account LIMIT 1];

        Opportunity newOppty = new Opportunity();
        newOppty.Name = 'Discount Oppty 2015';
        newOppty.CloseDate = System.today().addDays(30);
        newOppty.AccountId = acct.Id;
        newOppty.StageName = 'Prospect';
        newOppty.PriceBook2Id = '01s60000000AaFH'; // Salt Services PriceBook

        insert newOppty;

        system.debug('Oppty Id: ' + newOppty.Id);

        OpportunityLineItem[] opptyLineItems = new OpportunityLineItem[]{};

        OpportunityLineItem discount = new OpportunityLineItem();
        discount.OpportunityId = newOppty.Id;
        discount.PriceBookEntryId = discountMap.get('STATE-DISC').Id;
        discount.Quantity = 1;
        discount.UnitPrice = 1;
        opptyLineItems.add(discount);

        OpportunityLineItem discount2 = new OpportunityLineItem();
        discount2.OpportunityId = newOppty.Id;
        discount2.PriceBookEntryId = discountMap.get('ASSOC-DISC').Id;
        discount2.Quantity = 1;
        discount2.UnitPrice = 1;
        opptyLineItems.add(discount2);

        OpportunityLineItem discount3 = new OpportunityLineItem();
        discount3.OpportunityId = newOppty.Id;
        discount3.PriceBookEntryId = discountMap.get('MUTLI-YR-DISC').Id;
        discount3.Quantity = 1;
        discount3.UnitPrice = 1;
        opptyLineItems.add(discount3);

        OpportunityLineItem item = new OpportunityLineItem();
        item.OpportunityId = newOppty.Id;
        item.PriceBookEntryId = pBookEntryProduct[0].Id;
        item.Quantity = 1;
        item.UnitPrice = pBookEntryProduct[0].UnitPrice;
        opptyLineItems.add(item);

    }
}