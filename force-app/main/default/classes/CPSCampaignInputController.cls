/*
TestClassName- CPSCampaignInputControllerTest
*/

public class CPSCampaignInputController{

    public String selectedCampaign {get; set;}
    public List<SelectOption> campaignList {get; set;}
    public List<SelectOption> campaignListBackup;
    public Boolean renderPgMsgBox{get;set;} //to render pagemessage box on the page
    public Date selectedDate{get;set;}
    Map<Date,List<Campaign>> mapDateToLstCampaign = new Map<Date,List<Campaign>>();
    public String selectedLocation{get;set;} //Added on 24 Oct 2018, by Aj
    List<Campaign> lstCampaign = new List<Campaign>(); //Added on 24 Oct 2018, by Aj
    public List<SelectOption> campLocationsOptions{get;set;} //Added on 25 Oct 2018, by Aj
    public boolean showNoRecordsFound{get;set;} //Added on 14 Nov 2018, by Aj
    
    public cPSCampaignInputController(){ 
        try{
            Id validCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CPS Group Event').getRecordTypeId();
            renderPgMsgBox = false;
            campaignList = new List<SelectOption>();
            campaignListBackup = new List<SelectOption>();
            
            campLocationsOptions = new List<SelectOption>(); //Added on 25 Oct 2018, by Aj
            campLocationsOptions.add(new selectOption('','')); //Added on 25 Oct 2018, by Aj
            campLocationsOptions.addAll(getPicklistValues('Campaign','CPS_Center_Affiliation_Intake_Location__c')); //Added on 25 Oct 2018, by Aj
            List<SelectOption> campaignListToday = new List<SelectOption>(); //Added on 30 Oct 2018, by Aj
            showNoRecordsFound = false; //Added on 14 Nov 2018, by Aj
            
            /*** Commented on 30 Oct 2018, by Aj ***
            Set<id> setCampaignId = new Set<Id>();
            List<Campaign> lstTodayCampaign = [select Id,Name,Start_DateTime__c 
                                               from Campaign 
                                               where RecordTypeId =: validCampRecordTypeId
                                               AND Type != 'CPS TRIO Program'
                                               AND Start_DateTime__c = today limit 1];
            if(lstTodayCampaign!=null && lstTodayCampaign.size()>0){
                campaignList.add(new selectOption(lstTodayCampaign[0].id,lstTodayCampaign[0].Name+' ('+lstTodayCampaign[0].Start_DateTime__c.month()+'/'+lstTodayCampaign[0].Start_DateTime__c.day()+'/'+lstTodayCampaign[0].Start_DateTime__c.year()+')'));
                setCampaignId.add(lstTodayCampaign[0].id);
                //campaignListBackup.add(new selectOption('','Select Campaign'));
            }
            else{
                campaignList.add(new selectOption('','Select Campaign'));
            }
            */
            
            campaignList.add(new selectOption('','Select Campaign'));
            for(Campaign objCamp : [SELECT Id,Name,CPS_Center_Affiliation_Intake_Location__c,Start_DateTime__c
                                    FROM Campaign
                                    where RecordTypeId =: validCampRecordTypeId
                                    AND Type != 'CPS TRIO Program' order by Start_DateTime__c desc]){
                System.debug('objCamp.id>>>>>>>>>>>'+objCamp.id);
                System.debug('objCamp.Name>>>>>>>>>>>'+objCamp.Name);
                
                lstCampaign.add(objCamp); //Added on 24 Oct 2018, by Aj
                
                String campName = objCamp.Name;
                if(objCamp.Start_DateTime__c != null){
                    campName += ' ('+objCamp.Start_DateTime__c.month()+'/'+objCamp.Start_DateTime__c.day()+'/'+objCamp.Start_DateTime__c.year()+')';
                }
                
                /*** Commented on 30 Oct 2018, by Aj ***
                if(!setCampaignId.contains(objCamp.id)){
                    campaignList.add(new selectOption(objCamp.id,campName));
                    setCampaignId.add(objCamp.id);
                }
                */
                campaignList.add(new selectOption(objCamp.id,campName)); //Added on 30 Oct 2018, by Aj
                
                if(objCamp.Start_DateTime__c != null){
                    if(mapDateToLstCampaign.containsKey(date.newInstance(objCamp.Start_DateTime__c.year(),objCamp.Start_DateTime__c.month(),objCamp.Start_DateTime__c.day()))){
                        mapDateToLstCampaign.get(date.newInstance(objCamp.Start_DateTime__c.year(),objCamp.Start_DateTime__c.month(),objCamp.Start_DateTime__c.day())).add(objCamp);
                    }
                    else{
                        mapDateToLstCampaign.put(date.newInstance(objCamp.Start_DateTime__c.year(),objCamp.Start_DateTime__c.month(),objCamp.Start_DateTime__c.day()),new List<Campaign> {objCamp});
                    }
                    
                    //Added on 30 Oct 2018, by Aj***
                    if(Date.newInstance(objCamp.Start_DateTime__c.year(),objCamp.Start_DateTime__c.month(),objCamp.Start_DateTime__c.day()) == Date.newInstance(Date.today().year(),Date.today().month(),Date.today().day())){
                        campaignListToday.add(new selectOption(objCamp.id,campName));
                    }
                    //***
                }
            }
            campaignListBackup.addAll(campaignList);
            
            //Added on 30 Oct 2018, by Aj***
            if(campaignListToday.size()>0){
                selectedDate = Date.today();
                campaignList = campaignListToday;
            }
            //***
            
            System.debug('campaignListBackup>>>>'+campaignListBackup);
        }catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in eOCFormController method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
        }
    }
    
    public pagereference fetchLocationName(){
        try{
            Cookie campId = new Cookie('campId', selectedCampaign, null, -1, false);
            PageReference eventCheckIn = new PageReference('/apex/EventCheckIn');
            eventCheckIn.setCookies(new Cookie[] {campId});
            eventCheckIn.setRedirect(true);
            return eventCheckIn;
        }catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in registerIntakeLead method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            return null;
        }    
    }
    
    
    
    public void searchCampaign(){
        System.debug('mapDateToLstCampaign>>>>>>>>>>>>'+mapDateToLstCampaign);
        system.debug('*****campaignList'+campaignList);
        system.debug('========selectedDate'+selectedDate);
        System.debug('campaignListBackup222>>>>'+campaignListBackup);
        campaignList.clear();
        if(selectedDate != Null){
            if(mapDateToLstCampaign.containsKey(date.newInstance(selectedDate.year(),selectedDate.month(),selectedDate.day()))){
                for(Campaign objCamp : mapDateToLstCampaign.get(selectedDate)){
                    system.debug('mapDateToLstCampaign.get(selectedDate)'+mapDateToLstCampaign.get(selectedDate));
                    
                    //Added on 30 Oct 2018, by Aj***
                    String campName = objCamp.Name;
                    if(objCamp.Start_DateTime__c != null){
                        campName += ' ('+objCamp.Start_DateTime__c.month()+'/'+objCamp.Start_DateTime__c.day()+'/'+objCamp.Start_DateTime__c.year()+')';
                    }
                    //***
                    
                    if(String.isNotBlank(selectedLocation)){ //Added on 25 Oct 2018, by Aj
                        if(objCamp.CPS_Center_Affiliation_Intake_Location__c != null && objCamp.CPS_Center_Affiliation_Intake_Location__c.equalsIgnoreCase(selectedLocation)){  //Added on 25 Oct 2018, by Aj
                            campaignList.add(new selectOption(objCamp.id,campName)); //Added on 25 Oct 2018, by Aj
                        }
                    }
                    else{
                        campaignList.add(new selectOption(objCamp.id,campName));
                    }
                }
            }  
            system.debug('=======campaignList'+campaignList);
        }
        else if(String.isNotBlank(selectedLocation)){ //Added on 25 Oct 2018, by Aj
            for(Campaign objCamp : lstCampaign){
                
                //Added on 30 Oct 2018, by Aj***
                String campName = objCamp.Name;
                if(objCamp.Start_DateTime__c != null){
                    campName += ' ('+objCamp.Start_DateTime__c.month()+'/'+objCamp.Start_DateTime__c.day()+'/'+objCamp.Start_DateTime__c.year()+')';
                }
                //***
                
                if(objCamp.CPS_Center_Affiliation_Intake_Location__c != null && objCamp.CPS_Center_Affiliation_Intake_Location__c.equalsIgnoreCase(selectedLocation)){
                    campaignList.add(new selectOption(objCamp.id,campName));
                }
            }
        }
        else{
            campaignList = campaignListBackup.clone();
            System.debug('campaignList222>>>>'+campaignList);
        }
        
        //Added on 14 Nov 2018, by Aj *****
        if(campaignList.size()<=0){
            showNoRecordsFound = true;
            System.debug('showNoRecordsFound>>>>'+showNoRecordsFound);
        }
        else{
            showNoRecordsFound = false;
        }
        //***************
    } 

    //Added on 25 Oct 2018, by Aj
    public static List<SelectOption> getPicklistValues(String objectApiName,String fieldName){ 
        List<SelectOption> lstOption = new List<SelectOption>();
        
        Schema.SObjectType objSObjectType = Schema.getGlobalDescribe().get(objectApiName);//From the Object Api name retrieving the SObject
        //Sobject objSObject = objSObjectType.newSObject();
        //Schema.sObjectType sobject_type = objSObject.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobjectDescribe = objSObjectType.getDescribe(); //describe the sobject
        Map<String,Schema.SObjectField> mapField = sobjectDescribe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> lstPicklistValues = mapField.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for(Schema.PicklistEntry pickVal : lstPicklistValues) { //for all values in the picklist list
            lstOption.add(new SelectOption(pickVal.getLabel(), pickVal.getValue()));
        }
        return lstOption;
    }
}