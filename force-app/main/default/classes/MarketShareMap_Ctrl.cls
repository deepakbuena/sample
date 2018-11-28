public class MarketShareMap_Ctrl
{


   public static Account acc{get;set;}
   public static String dateParam;
   public static List<String> zipco{get;set;}
   public String dataString{get;set;}
   public String dateP{get;set;}
   public String stateP{get;set;}
   public SelectOption[] allTypes { get;set;}
   public SelectOption[] selectedTypes { get;set;}
   public String message { get; set; }
   public String fullState{get;set;}   // to get the fullname for state from js
   
   Public List<DataWrapper>dList {get;set;}
   
    public MarketShareMap_Ctrl()
    {   
        allTypes = new List <SelectOption> ();
        selectedTypes = new List <SelectOption> ();
        
        for (School_Type__c scObj:  School_Type__c.getAll().values()) {
            allTypes.add(new SelectOption(scObj.Name, scObj.Name));
        }
         
        String dateVal=apexpages.currentpage().getparameters().get('date');
        String selectedType=apexpages.currentpage().getparameters().get('selType');
        dList=new List<DataWrapper>();
        if(dateVal!=null )
        {
           GenerateMapPDF();
        }
        
    
    }  
      
    public void GenerateMapPDF()
    {
        String dateVal=apexpages.currentpage().getparameters().get('date');
        String selectedSchoolTypes=apexpages.currentpage().getparameters().get('selType');
        String stAcr=apexpages.currentpage().getparameters().get('st');
        String stFull=apexpages.currentpage().getparameters().get('full');
        system.debug(dateVal);
        
        String month=dateVal.substring(0,dateVal.indexof('/'));
        String day=dateVal.substring(dateVal.indexof('/')+1,dateVal.lastindexof('/'));
        String year=dateVal.substring(dateVal.lastindexof('/')+1,dateVal.length());
        
        system.debug(year+'-'+month+'-'+day);
        
       Date dParam=Date.NewInstance(Integer.valueOF(year),Integer.valueOF(month),Integer.valueOF(day));
        
        //Date dParam=Date.Parse(year+'-'+month+'-'+day);
        id rTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();

        Set<String> selTypesSet =  new Set<String> ();
        if(selectedSchoolTypes!=null && selectedSchoolTypes!='' && selectedSchoolTypes.length()>0){
            for(String st : selectedSchoolTypes.split(';'))
            {
                selTypesSet.add(st);
            }
        }
        
        //List<AggregateResult> lcount;
        String lcountQ;
        String mcountQ;
        if(selTypesSet.Size() > 0){
            lcountQ='select count(id),billingstate from account where recordtypeid=\''+rTypeId+'\' and Contract_End__c!=null and Contract_End__c>:dParam and Contract_Start__c<:dParam and createdDate< :dParam and type not in (\'School  - Proprietary\',\'School - Voc or Tech\') and BillingState!=\'FC\' and Type IN :selTypesSet';
            mcountQ='select count(id),billingstate from account where recordtypeid=\''+rTypeId+'\' and createdDate<:dParam and type not in (\'School  - Proprietary\',\'School - Voc or Tech\') and BillingState!=\'FC\' and Type IN :selTypesSet';
        }else{
            lcountQ='select count(id),billingstate from account where recordtypeid=\''+rTypeId+'\' and Contract_End__c!=null and Contract_End__c>:dParam and Contract_Start__c<:dParam and createdDate< :dParam and type not in (\'School  - Proprietary\',\'School - Voc or Tech\') and BillingState!=\'FC\' ';
            mcountQ='select count(id),billingstate from account where recordtypeid=\''+rTypeId+'\' and createdDate<:dParam and type not in (\'School  - Proprietary\',\'School - Voc or Tech\') and BillingState!=\'FC\'';
        }
        system.debug(stAcr+'-'+stFull);
       
        lcountQ+=' group by billingstate Limit 10000';
        mcountQ+=' group by billingstate Limit 10000';
        

        Set<String> USstates=new Set<String>{'AZ','CO','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','MD','ME','MA','MN','MI','MS','MO','MT','NC','NE','NV','NH','NJ','NY','ND','NM','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','WI','VA','VT','WA','WV','WY','CA','CT','AK','AR','AL'};
        Set<String> statePresent=new Set<String>();
        dataString='';
       
        
        List<AggregateResult> lcount=Database.query(lcountQ);
        List<AggregateResult> masterlcount=Database.query(mcountQ);
        system.debug(lcount);
                system.debug(masterlcount);
        
        System.debug(lcount);
        System.debug(masterlcount);
        Map<String,Decimal> stateSchMap=new Map<String,Decimal>();
        Map<String,Decimal> stateMasterSchMap=new Map<String,Decimal>();
        
        for(AggregateResult r: masterlcount)
        {

            stateMasterSchMap.put(String.valueof(r.get('billingstate')),Decimal.valueof(String.valueof(r.get('expr0'))));
        }
        
        
        for(AggregateResult r: lcount)
        {
           
            stateSchMap.put(String.valueof(r.get('billingstate')),Decimal.valueof(String.valueof(r.get('expr0'))));
        }
        
        System.debug(stateSchMap);
                System.debug(stateMasterSchMap);
        
        if(stateSchMap.size()>0 && stateMasterSchMap.size()>0)
        {
            for(String s : stateSchMap.keyset())
            {
                 if(USstates.contains(s))
                   {
                       statePresent.add(s);
                       String grp;
                       if(stateMasterSchMap.get(s)>0)
                       {
                           Double val=((stateSchMap.get(s)/stateMasterSchMap.get(s))*100).setScale(2);
                           if(val>0 && val<=10)
                            grp='Group1';
                           else if(val>10 && val<=20)
                            grp='Group2';
                           else if(val>20 && val<=30)
                            grp='Group3';
                            
                           else if(val>30 && val<=40)
                            grp='Group4';
                           else if(val>40 && val<=50)
                            grp='Group5';
                           else
                            grp='Group6';
                            
                          dataString=dataString +'"'+s+'":{"fillKey":"'+grp+'","percent": '+val+'},'; 
                       }
                   }
            
            }
        
        }
        
               USstates.removeall(statePresent);

               
               for(String s : USstates)
               {
                dataString=dataString +'"'+s+'":{"fillKey":"NoData","percent": 0},'; 
               
               }
               
               if(dataString.length()>0)
               {
                   System.debug(dataString);
                   dataString=dataString.substring(0,dataString.length()-1);
                   
               }
               
                if(stAcr!='' && stAcr!=null)
                {
                    dateP=dateVal;
                    stateP=stAcr;
                    generateTable();
                }
    }    
   

   
   @RemoteAction
    public Static String generateMap(String dateVal,String selectedSchoolTypes)
    {
        acc=new Account();
        system.debug(dateVal);
        system.debug('====selectedSchoolTypes'+selectedSchoolTypes);
        dateParam=dateVal;
        system.debug(' dateParam' +dateParam);
        String month=dateVal.substring(0,dateVal.indexof('/'));
        String day=dateVal.substring(dateVal.indexof('/')+1,dateVal.lastindexof('/'));
        String year=dateVal.substring(dateVal.lastindexof('/')+1,dateVal.length());
        
        system.debug(day+'-'+month+'-'+year);
        
     
        
        Date dParam=Date.NewInstance(Integer.valueOF(year),Integer.valueOF(month),Integer.valueOF(day));
        //Date dParam=Date.NewInstance(2015,17,4);
        System.debug(dParam);
        Set<String> USstates=new Set<String>{'AZ','CO','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','MD','ME','MA','MN','MI','MS','MO','MT','NC','NE','NV','NH','NJ','NY','ND','NM','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','WI','VA','VT','WA','WV','WY','CA','CT','AK','AR','AL'}; 
        Set<String> statePresent=new Set<String>();
        String dataString='';
       
        id rTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        
        Set<String> selTypesSet =  new Set<String> ();
        if(selectedSchoolTypes!=null && selectedSchoolTypes!='' && selectedSchoolTypes.length()>0){
            for(String st : selectedSchoolTypes.split(';'))
            {
                selTypesSet.add(st);
            }
        }
        
        List<AggregateResult> lcount;
        List<AggregateResult> masterlcount;
        
        if(selTypesSet.size()>0){
            lcount=[select Count(id),billingstate from account where recordtypeid=:rTypeId and Contract_End__c!=null and Contract_End__c>:dParam and Contract_Start__c<:dParam and createdDate< :dParam and type not in ('School  - Proprietary','School - Voc or Tech') and BillingState!='FC' and Type IN: selTypesSet group by billingstate];
            masterlcount=[select count(id),billingstate from account where recordtypeid=:rTypeId and createdDate< :dParam and type not in ('School  - Proprietary','School - Voc or Tech') and BillingState!='FC' and Type IN: selTypesSet group by billingstate];
        }else{
            lcount=[select Count(id),billingstate from account where recordtypeid=:rTypeId and Contract_End__c!=null and Contract_End__c>:dParam and Contract_Start__c<:dParam and createdDate< :dParam and type not in ('School  - Proprietary','School - Voc or Tech') and BillingState!='FC' group by billingstate];
            masterlcount=[select count(id),billingstate from account where recordtypeid=:rTypeId and createdDate< :dParam and type not in ('School  - Proprietary','School - Voc or Tech') and BillingState!='FC' group by billingstate];
        }
        
        Map<String,Decimal> stateSchMap=new Map<String,Decimal>();
        Map<String,Decimal> stateMasterSchMap=new Map<String,Decimal>();
        
        for(AggregateResult r: masterlcount)
        {

            stateMasterSchMap.put(String.valueof(r.get('billingstate')),Decimal.valueof(String.valueof(r.get('expr0'))));
        }
        
        
        for(AggregateResult r: lcount)
        {
           
            stateSchMap.put(String.valueof(r.get('billingstate')),Decimal.valueof(String.valueof(r.get('expr0'))));
        }
        
        System.debug(stateSchMap);
                System.debug(stateMasterSchMap);
        
        if(stateSchMap.size()>0 && stateMasterSchMap.size()>0)
        {
            for(String s : stateSchMap.keyset())
            {
                 if(USstates.contains(s))
                   {
                       statePresent.add(s);
                       String grp;
                       if(stateMasterSchMap.get(s)>0)
                       {
                           Double val=((stateSchMap.get(s)/stateMasterSchMap.get(s))*100).setScale(2);
                           System.debug(' state s: '+ s);
                           System.debug(' state u: '+ stateSchMap.get(s));
                           System.debug(' state d: '+ stateMasterSchMap.get(s));
                           System.debug(' val '+ val);
                           
                           if(val<=0)
                              grp='NoData'; 
                           else if(val>0 && val<=10)
                            grp='Group1';
                           else if(val>10 && val<=20)
                            grp='Group2';
                           else if(val>20 && val<=30)
                            grp='Group3';
                            
                           else if(val>30 && val<=40)
                            grp='Group4';
                           else if(val>40 && val<=50)
                            grp='Group5';
                           else
                            grp='Group6';
                            
                          dataString=dataString +'"'+s+'":{"fillKey":"'+grp+'","percent": '+val+'},'; 
                       }
                   }
            
            }
        
        }
        
               USstates.removeall(statePresent);

               
               for(String s : USstates)
               {
                dataString=dataString +'"'+s+'":{"fillKey":"NoData","percent": 0},'; 
               
               }
               
               if(dataString.length()>0)
               {
                   System.debug(dataString);
                   dataString=dataString.substring(0,dataString.length()-1);
                   
               }
         return dataString;   
    }    

    public Pagereference generateTable()
    {
        system.debug(dateP+'     '+ stateP);
        String dateVal=dateP;
        
        dList=new List<DataWrapper>();
        
        String month=dateVal.substring(0,dateVal.indexof('/'));
        String day=dateVal.substring(dateVal.indexof('/')+1,dateVal.lastindexof('/'));
        String year=dateVal.substring(dateVal.lastindexof('/')+1,dateVal.length());
        
        system.debug(day+'-'+month+'-'+year);
        
        Date dParam=Date.NewInstance(Integer.valueOF(year),Integer.valueOF(month),Integer.valueOF(day));
        id rTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        List<Account> accRecords=[select billingpostalcode ,name,id  from account where recordtypeid=:rTypeId and Contract_End__c!=null and Contract_End__c>:dParam and Contract_Start__c<:dParam and billingstate=:stateP and createddate<:dParam order by name];
        
                
       if(accRecords.size()>0)
        {
            for(Account accTemp : accRecords)
            {
                DataWrapper dTemp=new DataWrapper();
                dTemp.name=accTemp.name;
                dTemp.zipcode=accTemp.billingpostalcode;
                //dTemp.activeSchool=zipSchMap.get(s);
                //dTemp.totalSchool=zipMasterSchMap.get(s);
                //dtemp.div=zipMasterSchMap.get(s)!=0? dtemp.activeSchool/dtemp.totalSchool : 0;
                
                dList.add(dTemp);
            }
            
        }
                
        return null;
    }
    
   public class DataWrapper
    {
        public String name{get;set;}
        public String zipcode{get;set;}
        public Decimal activeSchool{get;set;}
        public Decimal totalSchool{get;set;}
        public Decimal div;
    
    }
 
}