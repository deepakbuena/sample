public class CaseBarrierController
{
    public SelectOption[] selectedRisks { get; set; }
    public SelectOption[] allRisks { get; set; }
    public String id;
    public String outputMessage { 
    get{
           if(outputMessage!=null)
           {
            IF(outputMessage.length()>100)
                outputMessage=outputMessage.subString(0,100)+'...';
           }
            return outputMessage;
          
       }
     set; }
    public Boolean show{ get; set; }
    public Boolean showLink{ get; set; }

      public CaseBarrierController(ApexPages.StandardController controller) {
    outputMessage='';
    
   
    
    
    Boolean fTime=false;
    String url=ApexPages.currentPage().getUrl();
     System.debug('url '+url);
        id=Apexpages.currentPage().getParameters().get('id');// Account Id
        
        if(id!=null)
        {
          
            selectedRisks = new List<SelectOption>();
            
            List<String> risks = generateList([SELECT name FROM CaseBarrier__c]);
            List<String> riskByCase= generateList([select id,Name from Case_Barrier__C where case__c=:id order by sort_order_no__C asc]);
                   
            
            //create set to remove selected element
            Set<String> setRisks=new Set<String>();
            setRisks.addAll(risks);
            System.debug('setRisks '+setRisks);
            
            Set<String> setRiskByCase=new Set<String>();
            setRiskByCase.addAll(riskByCase);
            System.debug('setRiskByCase '+setRiskByCase);
             
            setRisks.removeAll(setRiskByCase);
            System.debug('setRiskByCase '+setRiskByCase);
         
            allRisks = new List<SelectOption>();
            for ( String c : setRisks) {

                allRisks.add(new SelectOption(c, c));
            }
            
            for ( String c : setRiskByCase) {
                if((c!=null)&&(c!=''))
                    selectedRisks.add(new SelectOption(c, c));
            }
    
             List<Case_Barrier__C> tempList=[select id,name from Case_Barrier__C where case__c=:id order by sort_order_no__C asc ];
             for(Case_Barrier__C scTemp : tempList)
             {
                 if(fTime==false)
                 {
                     outputMessage=scTemp.Name;
                     fTime=true;
                 }
                 else
                 {
                     outputMessage+=';'+scTemp.Name;
                 }
                 
             }
             
                if((outputMessage=='')||(outputMessage==null))
                {
                    show=False;
                    showLink=true;
                    outputMessage='Select Barrier';
                }
                else
                {
                    show=true;
                    showLink=False;
                }
          }
    }
    
    private List<String> generateList(List<sObject> sobj)
    {
    
        List<String> retStr=new List<String>();
        
        for(SObject sTemp : sobj)
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