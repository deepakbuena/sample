public with sharing class CaseBarrierMultiPickController {

     public String id;
     public String message { get; set; }
     public SelectOption[] selectedBarriers { get; set; }
     public SelectOption[] allBarriers { get; set; }
     public String PrimaryMessage { get; set; }
     public Map<Decimal,String> sortMap;

    public CaseBarrierMultiPickController () {
   
        id=Apexpages.currentPage().getParameters().get('id');// Account Id     
        if(id!=null)
        {   
        sortMap=new Map<Decimal,String>();
        selectedBarriers = new List<SelectOption>();

        List<String> barrier = generateList([SELECT name FROM CaseBarrier__c]);
        List<String> barrierByCase=generateList([select id,Name from Case_Barrier__C where case__C=:id order by sort_Order_No__C ASC]);
        
        for(Case_Barrier__C sTemp :  [ select Sort_Order_No__c, name from Case_Barrier__C where Case__c= : id  order by Sort_Order_No__c ASC ])
        {
                    
            sortMap.put(sTemp.sort_Order_no__C,sTemp.name);
            
        }       
        
        //create set to remove selected element
        Set<String> setBarriers=new Set<String>();
        setBarriers.addAll(barrier);
        
        Set<String> setBarrierByCase=new Set<String>();
        setBarrierByCase.addAll(barrierByCase);
        
        setBarriers.removeAll(setBarrierByCase);
        
       
     
        allBarriers = new List<SelectOption>();
        for ( String c : setBarriers) {
            allBarriers.add(new SelectOption(c, c));
        }
        
        
         
        list<decimal> ranksList = new list<decimal>();
        ranksList.addAll(sortMap.keySet());

            //now sort them
            ranksList.sort();
            
            system.debug('keys sorted '+ ranksList);
            
            for(Decimal dTemp : ranksList)
            {
                String sTemp=sortMap.get(dTemp);
               system.debug('keys sorted values '+ sTemp);
                selectedBarriers.add(new SelectOption(sTemp, sTemp));
            
            }
       
       /*
       DEV1 
        for ( String c : setBarrierByCase) {
        System.debug(' setBarrierByCase val '+c);
            if((c!=null)&&(c!=''))
            {
                List<String> cTemp=c.split(';',0);
                for(String s :cTemp)
                    {
                    selectedBarriers.add(new SelectOption(s, s));
                    }
                
             }
        }
        */
        
         
      }
    }

    private List<String> generateList(List<sobject> sobj)
    {
    
        List<String> retStr=new List<String>();
        
        for(sobject sTemp : sobj)
        {
            if (sTemp.getSObjectType() == CaseBarrier__c.sObjectType)
            {
                sTemp  = (CaseBarrier__c)sTemp ;
                retStr.add(String.valueOf(sTemp.get('Name')));
            }
            else if (sTemp.getSObjectType() == Case_Barrier__C.sObjectType)
            {
                sTemp = (Case_Barrier__C)sTemp ;
                retStr.add(String.valueOf(sTemp.get('Name')));
            }
             
          
        }
        return retStr;
        
    
    }
}