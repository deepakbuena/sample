public class EventCheckInFormControllerMobile{
    //Event CheckIn Form Variables
    public String firstName{get; set;}
    public String lastName{get; set;}
    public String studentId{get; set;}
    public Date birthDate{get; set;}
    public String email{get; set;}
    public String mobilePhone{get; set;}
    public String checkInNotes{get; set;}
    public String campaignName{get;set;}
    public String zipCode{get; set;}
    
    //Backend Variables
    String location;
    String campaignId;
    Id idRecordTypeEOCContact;
    Id idRecordTypeTSContact;
    Id idRecordTypeUBContact; //Added on 23 Oct 2018, by Ajay************** 
    Id accountId;
    List<Campaign> lstCampaign;
    Date currentDate;
    public boolean renderPgMsgBox{get;set;} //To render pagemessage box on the page
    public boolean renderStudentId{get;set;} //To render Student ID field the page
    public boolean showPopup{get;set;} //Render popup or main page
        
    List<CampaignMemberStatus> lstCMStatus = new List<CampaignMemberStatus>(); //Added on 22 Oct 2018, by Ajay************** 
    Set<String> setCMRespondedStatus = new Set<String>(); //Added on 22 Oct 2018, by Ajay**************
    
    public eventCheckinFormControllerMobile(){
        try{
            renderPgMsgBox = false; //set page message visibility
        
            //Set showPopup
            showPopup = false;
            
            //Set current date
            currentDate = System.today();
                        
            //Get campaign id
            if(apexpages.currentPage().getCookies() != null && apexpages.currentPage().getCookies().containsKey('campId')){
                campaignId = apexpages.currentPage().getCookies().get('campId').getValue();
                System.debug('campaignId>>>>>>>'+campaignId);
            }
            
            //Get record type ids
            idRecordTypeEOCContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - EOC').getRecordTypeId();
            idRecordTypeTSContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - TS').getRecordTypeId();
            idRecordTypeUBContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - UB').getRecordTypeId();
            
            
            //Get valid Account
            String accountName = 'College Planning Services '+system.today().year();
            
            system.debug('======accountName '+accountName);
            for(Account objAcc : [select Id from Account where Name =: accountName limit 1]){
                accountId = objAcc.id;
            }
            
            //Get Campaign info
            lstCampaign = [select id,Name,CPS_Center_Affiliation_Intake_Location__c,ownerid 
                           from Campaign 
                           where id =: campaignId limit 1];
            
            //Added on 22 Oct 2018, by Ajay**************
            //Get responded status for the campaign
            for(CampaignMemberStatus objCampMemberStatus : [select id,Label
                                                            from CampaignMemberStatus 
                                                            where CampaignId =: campaignId and HasResponded = true]){
                lstCMStatus.add(objCampMemberStatus);
                setCMRespondedStatus.add(objCampMemberStatus.Label);
            }
            //************************************************
            
            //Get location name               
            if(lstCampaign != null && lstCampaign.size()>0){
                System.debug('lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c>>>>>'+lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c);
                location = String.isNotBlank(lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c)?lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c:null;
                campaignName = lstCampaign[0].Name;
            }
            System.debug('locagtion>>>>>>>>>>'+location);
            renderStudentId = (location.containsIgnoreCase('TS') || location.containsIgnoreCase('UB'))?true:false;
        }
        catch(Exception ex){
            renderPgMsgBox = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Something went wrong! please contact your administrator!'));
        }
    }
    
    
    //Method to redirect to input location page
    public PageReference redirectToHome(){
        if(String.isBlank(campaignId)){
            System.debug('>>>>inside redirectToHome');
            PageReference homePage = new PageReference('/apex/Mobile_Phone_Demo1');
            homePage.setRedirect(true);
            return homePage;
        }
        return null;
    }
    
    
    
    public pageReference createRecords(){
        try{
            String mobilePhoneNumeric;
            //remove leading and ending space
            firstName = firstName.trim();
            lastName = lastName.trim();
            email = string.isNotBlank(email)?email.trim():null;
            
            //remove alpha and special characters from mobilePhone
            if(String.isNotBlank(mobilePhone)){
                mobilePhone = mobilePhone.trim();
                Pattern numberOnly = Pattern.compile('[a-zA-Z,(,),\\-,,[,], ]');
                Matcher matcher = numberOnly.matcher(mobilePhone);
                mobilePhoneNumeric = matcher.replaceAll('');
                system.debug('mobilePhoneNumeric>>>>>'+mobilePhoneNumeric);
            }
            
            String query;
            Set<String> setCPSRecordTypeName = new Set<String>{'CPS - EOC','CPS - TS','CPS - UB'};
            query = 'select id,name,Intake_Date__c,Intake_Form_Expire_Date_EOC__c,accountid,(select id,Status from CampaignMembers where campaignId =: campaignId) from contact where RecordType.Name in : setCPSRecordTypeName AND';
            
            //If studentId not null
            if(studentId != null && studentId != ''){
                query += ' ((LastName =: lastName AND Student_ID__c =: studentId) OR';
            }
            
            System.debug('birthDate>>>>>'+birthDate);
            String strBirthDate = String.valueOf(birthDate).trim() + ' 00:00:00';
            System.debug('strBirthDate>>>>>>>>>>'+strBirthDate);
            query += ' (LastName =: lastName AND BirthDate_Text__c =: strBirthDate AND (FirstName =: firstName';
            
            //If mobilePhone not blank
            query = String.isNotBlank(mobilePhoneNumeric)?query+' OR MobilePhoneNumeric__c =: mobilePhoneNumeric':query;
            
            //If mobilePhone not email
            query = email != null?query+' OR email =: email':query;
            
            query += '))';
            
            if(String.isNotBlank(location) && (location.containsIgnoreCase('TS') || location.containsIgnoreCase('UB')) && studentId != null && studentId != ''){
                query += ')';
            }
            
            query += ' order by lastModifiedDate desc limit 1';
            
            System.debug('lastName>>>>>'+lastName);
            System.debug('mobilePhone>>>>>'+mobilePhone);
            System.debug('strBirthDate>>>>>'+strBirthDate);
            System.debug('firstName>>>>>'+firstName);
            
            if(
                query != null 
                && String.isNotBlank(location) 
                && (location.containsIgnoreCase('EOC') || location.containsIgnoreCase('TS') || location.containsIgnoreCase('UB'))
            ){
                System.debug('query>>>>>>'+query);
                
                List<Contact> lstMatchedContact = Database.query(query);
                system.debug('=======lstMatchedContact'+lstMatchedContact);
                CampaignMember objCampMemToUpdate = new CampaignMember(); //Added on 22 Oct 2018, by Aj*********
                
                if(lstMatchedContact != null && lstMatchedContact.size()>0){
                    System.debug('lstMatchedContact@@@@@'+lstMatchedContact[0].Id);
                    
                    //To check if already linked
                    if(lstMatchedContact[0].CampaignMembers.size()>0){
                        //Added on 22 Oct 2018, by Aj*********
                        if(setCMRespondedStatus.contains(lstMatchedContact[0].CampaignMembers[0].Status)){
                            showPopup = true;
                            return null;
                        }
                        else{
                            objCampMemToUpdate.Id = lstMatchedContact[0].CampaignMembers[0].id;
                            objCampMemToUpdate.Status = lstCMStatus[0].Label;
                            update objCampMemToUpdate;
                        }
                        //************************************
                    }
                    else{
                        //To create campaign member
                        createCampaignMember(lstMatchedContact[0].id);
                    }
                }
                else{
                    Contact objContact = createContact();
                    createCampaignMember(objContact.id);
                }
                //Redirect to confirmation page
                PageReference confirmationPage = new PageReference('/apex/EventCheckInConfirmation');
                confirmationPage.setRedirect(true);
                return confirmationPage;
            }   
            return null;
        }
        catch(Exception ex){
            system.debug('ex.getMessage()>>>>>>'+ex.getMessage());
            renderPgMsgBox = true;
            String message = 'Something went wrong! please contact your administrator!';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,message));
            return null;
        }
    }
    
    public PageReference okPopUp(){
        showPopup = false;
        return null;
    }
    
    public PageReference cancelPopUp(){
        //Redirect to confirmation page
        PageReference confirmationPage = new PageReference('/apex/EventCheckInConfirmation');
        confirmationPage.setRedirect(true);
        return confirmationPage;
    }
    
    //Method to insert CampaignMember
    public void createCampaignMember(Id contactId){
        System.debug('checkInNotes>>>>>'+checkInNotes);
        
        CampaignMember objCM =  new CampaignMember();
        objCM.CampaignId = campaignId;
        objCM.Contactid = contactId;
        if(lstCMStatus != null && lstCMStatus.size()>0){
            objCM.Status = lstCMStatus[0].Label;
        }
        if(String.isNotBlank(checkInNotes)){
            objCM.Check_In_Notes__c = checkInNotes;
        }
        objCM.Contact_Created_From_Event_Check_In__c = true; //Modified on 22 Oct 2018, by Aj***********
        insert objCM;
    }
    
    //Method to create contact
    public Contact createContact(){
        Contact objContact = new Contact();
        
        objContact.LastName = lastName;
        if(String.isNotBlank(firstName)){
            objContact.FirstName = firstName;
        }
        if(String.isNotBlank(zipCode)){
            objContact.MailingPostalCode = zipCode;
        }
        if(birthDate != null){
            objContact.BirthDate = Date.valueOf(birthDate);
            System.debug('objContact.BirthDate>>>>>>>'+objContact.BirthDate);
        }
        if(String.isNotBlank(email)){
            objContact.Email = email;
        }
        if(String.isNotBlank(mobilePhone)){
            objContact.MobilePhone = mobilePhone;
        }
        if(String.isNotBlank(location)){
            if(location.containsIgnoreCase('EOC')){
                objContact.recordTypeId = idRecordTypeEOCContact;
            }
            else if(location.containsIgnoreCase('TS')){
                objContact.recordTypeId = idRecordTypeTSContact;
            }
            else if(location.containsIgnoreCase('UB')){
                objContact.recordTypeId = idRecordTypeUBContact;
            }
        }
        if(accountId != null){
            objContact.AccountId = accountId;
        }
        objContact.Auto_Created_Source__c = 'CPS Event Check In';
        if(lstCampaign != null && lstCampaign.size()>0){
            if(lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c != null){
                objContact.Intake_Location__c = lstCampaign[0].CPS_Center_Affiliation_Intake_Location__c;
            }
            objContact.OwnerId = lstCampaign[0].ownerId;
        }
        if(String.isNotBlank(studentId)){
            objContact.Student_ID__c = studentId;
        }
        System.debug('objContact.LastName>>>'+objContact.LastName);
        insert objContact;
        return objContact;
    }
}