/*
TestClassName : CPSInputLocationCodeTest
*/

public class CPSInputLocationCode{
    public String cpsLocationCode {get;set;}
    public List<CPS_Location_Code__mdt> lstCpsData;
    public String locationName;
    public Boolean renderPgMsgBox{get;set;} //to render pagemessage box on the page
    //public String pageUrl {get;set;}
    //public Boolean eocFound;
    //public Boolean tsFound;
    //public string cookiesLoc {get;set;}
    //public string cookiesDate {get;set;}
    
    public String satelliteLocation{get; set;}  // satelliteLocation. Added by Ravinder 29082018
    public List<SelectOption> satelliteLocOptions{get; set;} // Added by Ravinder 29082018
    
    public String IntakeLoction {get; set;}
    public Boolean showSatellitePicklist {get; set;}
    public String preserveSatelliteLoc {get; set;}
    public Boolean satelliteLoc {get; set;}
    
    public CPSInputLocationCode(){
        lstCpsData = new List<CPS_Location_Code__mdt>();
        renderPgMsgBox = false;
        /*
        pageUrl = Apexpages.currentPage().getUrl();
        eocFound = pageUrl.contains('CPS_input_location_eoc');
        tsFound = pageUrl.contains('CPS_input_location_ts');
        System.debug('eocFound @@@'+eocFound);
        System.debug('tsFound @@@'+tsFound);
        */
        
        showSatellitePicklist = false;
        satelliteLoc = false;
        
        //Internal usage
        if(ApexPages.CurrentPage().getCookies() != null && ApexPages.currentPage().getCookies().containsKey('satelliteloc'))
        {
            preserveSatelliteLoc  = apexpages.currentPage().getCookies().get('satelliteloc').getValue();
            System.debug('Preserve Satellite Location>>>>>>>>>>'+preserveSatelliteLoc);
            if(preserveSatelliteLoc != '' || preserveSatelliteLoc != Null)
            {    
                satelliteLoc = true;
                showSatellitePicklist = true;
            }
        }
        
        
    }
    
    public void fetchIntakeLocation()
    {
        IntakeLoction = apexpages.currentPage().getParameters().get('inpval');
        System.debug('IntakeLoction@@@'+IntakeLoction);
        
        System.debug('Preserve Satellite Location @@@@'+preserveSatelliteLoc);
        
        // Added by Ravinder 29082018
        if(IntakeLoction.contains('EOC') || IntakeLoction.contains('eoc') || preserveSatelliteLoc != '')
        {
            showSatellitePicklist = true;
            try
            {
            System.debug('Contains EOC');
            //Get valid picklist values
                Id idRecordTypePicklistConfig = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
                Map<String,List<SelectOption>> mapFieldAPIToValues = new Map<String,List<SelectOption>>();
                for(CPS_Picklist_Config__c objPicklistConfig : [select Name,Picklist_API_Name__c,Valid_Values__c
                                                                from CPS_Picklist_Config__c where recordTypeId =: idRecordTypePicklistConfig]){
                    List<SelectOption> lstOptions = new List<SelectOption>();
                    for(String value : objPicklistConfig.Valid_Values__c.split(';')){
                        SelectOption option = new SelectOption(value,value);
                        lstOptions.add(option);
                    }
                    System.debug('objPicklistConfig.Picklist_API_Name__c>>>>>>>>>>'+objPicklistConfig.Picklist_API_Name__c);
                    System.debug('lstOptions>>>>>>'+lstOptions);
                    if(lstOptions.size()>0){
                        mapFieldAPIToValues.put(objPicklistConfig.Picklist_API_Name__c,lstOptions);
                    }
                }
                
                if(mapFieldAPIToValues.containsKey('Satellite_Intake_Location_EOC__c') && IntakeLoction == 'EOC Boston'){
                    
                    satelliteLocOptions = mapFieldAPIToValues.get('Satellite_Intake_Location_EOC__c');
                    if(preserveSatelliteLoc == '' || preserveSatelliteLoc == Null)
                    {
                        satelliteLocation = 'Copley Square BPL';
                    }
                    else if(preserveSatelliteLoc != '' || preserveSatelliteLoc != Null)
                    {
                        satelliteLocation = preserveSatelliteLoc;
                    }
                    satelliteLocOptions.add(0,new SelectOption('None','None'));
                }
                
                if(mapFieldAPIToValues.containsKey('Satellite_Intake_Location_EOC__c') && IntakeLoction == 'EOC Brockton'){
                    
                    satelliteLocOptions = mapFieldAPIToValues.get('Satellite_Intake_Location_EOC__c');
                    if(preserveSatelliteLoc == '' || preserveSatelliteLoc == Null)
                    {
                        satelliteLocation = 'Brockton EOC';
                    }
                    else if(preserveSatelliteLoc != '' || preserveSatelliteLoc != Null)
                    {
                        satelliteLocation = preserveSatelliteLoc;
                    }
                    satelliteLocOptions.add(0,new SelectOption('None','None'));
                    
                }
            }
            catch(Exception ex){
                renderPgMsgBox = true;
                system.debug('Exception in eOCFormController method>>>>>>>>>'+ex);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            }
        }
        
         
    }
    
    public pagereference fetchLocationName(){
        try{
            System.debug('cpsLocationCode@@@'+cpsLocationCode);
            System.debug('Satellite Location @@@'+satelliteLocation);
            if(String.isNotBlank(cpsLocationCode)){
                /*
                lstCpsData = [Select location_name__c,Location_Code__c 
                               from CPS_Location_Code__mdt 
                               where Location_Code__c =: cpsLocationCode];
                */
                //Approach changed due to open bug in Salesforce Reference W-4140040
                for(CPS_Location_Code__mdt objLocationMdt : [Select Label,DeveloperName 
                                                             from CPS_Location_Code__mdt]){
                    if(objLocationMdt.Label.equalsIgnoreCase(cpsLocationCode.trim())){
                        lstCpsData.add(objLocationMdt);
                        break;
                    }
                }
                System.debug('lstCpsData @@@'+lstCpsData );
                
                if(lstCpsData.size() > 0){
                    Pagereference pr;
                    locationName = lstCpsData[0].Label;
                    System.debug('locationName  @@@'+locationName);
                    
                    List<Cookie> lstlocName = new List<Cookie>
                    {new Cookie('locname', locationName, null, -1, false), new Cookie('satelliteloc', satelliteLocation, null, -1, false)};
                    
                    if(locationName.containsIgnoreCase('EOC Boston') || locationName.containsIgnoreCase('EOC Brockton')){
                        System.debug('Inside eocFound');
                        pr = new PageReference('/apex/EOCSignOn');
                    }
                    else if(locationName.containsIgnoreCase('TS Boston') || locationName.containsIgnoreCase('TS Brockton')){
                        System.debug('Inside tsFound');
                        pr = new PageReference('/apex/TSSignOn');
                    }
                    else{
                        return null;
                    }
                    
                    //pr.setCookies(new Cookie[] {locName});
                    pr.setCookies(lstlocName);
                    pr.setRedirect(true);
                    //pr.getParameters().put('satelliteloc',satelliteLocation);
                    return pr;
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Location Code not found. Please try again, or ask a staff member if you\'re unsure what to enter here.'));
                }   
            }
        }catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
            renderPgMsgBox = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(e)));
        }
        return null;
    }
}