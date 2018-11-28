trigger GetDetailsFromProduct on SALT_Record__c (before insert) {

    Map<String, SALT_Product__C> mapProduct= new Map<String, SALT_Product__C>();
    Set<String> oeSet=new  Set<String>();         
                                                                      
    for(SALT_Record__c srTemp : Trigger.new)
    {
        // get all the account records which will be worked upon based on OEcode
           if((srTemp.OE_Code__c!='')&&(srTemp.OE_Code__c!=null))
                   oeSet.add(srTemp.OE_Code__c);
    }
    
    Map<String,Account> mapAccount=new Map<String,Account>();
    List<Account> accList=[select id, name,OE_Code__c from account where OE_Code__c in :oeSet];
    List<SALT_Product__C> productList=[select id, name,family__c, cost__c, active__c,ShortDescription__c from SALT_Product__C where active__c=true];
        
    for(Account accTemp : accList)
    {
        mapAccount.put(accTemp.OE_Code__c, accTemp);
    
    }
    
    for(SALT_Product__C spTemp : productList)
    {
        
          mapProduct.put(spTemp.name,spTemp);
    }
   
    
 
      for(SALT_Record__c srTemp : Trigger.new)
    {
      
       if( mapProduct.get(srTemp.ItemCode__c)!=null)
       {
        if(mapAccount.get(srTemp.OE_Code__c)!=null)
        {
            srTemp.account__c=mapAccount.get(srTemp.OE_Code__c).id;
            
            srTemp.SALT_Product__c=mapProduct.get(srTemp.ItemCode__c).id; 
            srTemp.cost__c=mapProduct.get(srTemp.ItemCode__c).cost__c * srTemp.Quantity__c; 
            srTemp.ListPrice__c=mapProduct.get(srTemp.ItemCode__c).cost__c;
            srTemp.ProductLine__c=mapProduct.get(srTemp.ItemCode__c).Family__c;
            srTemp.ShortDescription__c=mapProduct.get(srTemp.ItemCode__c).ShortDescription__c;
            srTemp.name=srTemp.ItemCode__c;
        }
        else
        {
            srTemp.addError('Unable to find account with OE Code '+  srTemp.OE_Code__c);
        
        }
       }
       else
       {
           srTemp.addError('Product '+  srTemp.ItemCode__c +' is either inactive or not added to SALT Products');
       
       }
       
    }

}