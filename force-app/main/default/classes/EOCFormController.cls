/*
TestClassName : EOCFormControllerTest
*/
public class EOCFormController
{
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String mddleInitials {get; set;}
    public String email{get; set;}
    public String preferredPhoneType{get; set;}
    public String mobilePhone{get; set;}
    public String homePhone{get; set;}
    public String isMobileOktoTest{get; set;}
    public String street{get; set;}
    public String city{get; set;}
    public String state{get; set;}
    public String zipCode{get; set;}
    public String country{get; set;}
    public String preferredLanguage{get; set;}
    public String additionalLanguage{get; set;}
    public String purposeofVisitOther{get; set;}
    public String purposeofVisit{get; set;}//multiselect picklist****************
    public String purposeofVisitSelectedOption{get; set;}
    //DS 13092018
    public String schGuidanceCounselor{get; set;}
    public String suffix{get; set;}
    
    public List<SelectOption> preferredPhoneTypeOptions{get; set;}
    public List<SelectOption> isMobileOktoTestOptions{get; set;}
    public List<SelectOption> preferredLanguageOptions{get; set;}
    public List<SelectOption> lstCPSAdvisorOption{get; set;}
    public List<SelectOption> purposeofVisitOptions{get; set;}
    public List<SelectOption> suffixOptions{get; set;}
    
    
    public Date birthDate{get; set;}
    
    public Boolean isMobileParentGuardians{get; set;}
    public Boolean isHomeParentGuardians{get; set;}    
    public Boolean haveAppoinment{get; set;}
    public Boolean meetAdvisor{get; set;}
    
    public ID cPSAdvisorRequested{get; set;}//lookup************************
    
    //Internal usage
    public String Capcha{get; set;}
    public String intakeLocation;
    public DateTime signOnDateTime{get; set;}
    public Date currentDate;
    public Boolean renderPgMsgBox{get;set;} //to render pagemessage box on the page
        
    //Intake info
    public String genderIdentity{get; set;}
    public String isMotherCollegeGrad{get; set;}
    public String ethnicity{get; set;}
    public String isFatherCollegeGrad{get; set;}
    public String maritialStatus{get; set;}
    public String annualTaxableIncome{get; set;}
    public String usCitizen{get; set;}
    public String primaryIncomeSource{get; set;}
    public String veteranStatus{get; set;}
    public String school{get; set;}
    public String schoolOther{get; set;}
    public String otherLearnedAboutProgram{get; set;}
    public String studentStatus{get; set;}
    public String learnAboutProgram{get; set;}
    public String careerGoals{get; set;}
    public String motherGuardian1FirstName{get; set;}
    public String motherGuardian1LastName{get; set;}
    public String fatherGuardian2FirstName{get; set;}
    public String fatherGuardian2LastName{get; set;}
    public String parentEmail{get; set;}
    public String socialSecurityNumber{get;set;}
    public String permanentResidentId{get;set;}
    
    public List<SelectOption> genderIdentityOptions{get; set;}
    public List<SelectOption> isMotherCollegeGradOptions{get; set;}
    public List<SelectOption> ethnicityOptions{get; set;}
    public List<SelectOption> isFatherCollegeGradOptions{get; set;}
    public List<SelectOption> maritialStatusOptions{get; set;}
    public List<SelectOption> annualTaxableIncomeOptions{get; set;}
    public List<SelectOption> usCitizenOptions{get; set;}
    public List<SelectOption> primaryIncomeSourceOptions{get; set;}
    public List<SelectOption> veteranStatusOptions{get; set;}    
    public List<SelectOption> schoolOptions{get; set;}
    public List<SelectOption> learnAboutProgramOptions{get; set;}
    public List<SelectOption> studentStatusOptions{get; set;}
    
    public Integer houseHoldSize{get; set;}
    
    Public String satelliteLoc{get; set;}
    
    // reCAPTCHA variables
    private static String baseUrl = 'https://www.google.com/recaptcha/api/verify';
    private static String secret = '6LePxF0UAAAAABVxK2SspMWT0AmqXPRfPx_Mdc4C';
    
    public String response{ 
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }

    public EOCFormController()
    {
        try
        {
            //Internal usage
            if(ApexPages.CurrentPage().getCookies() != null && ApexPages.currentPage().getCookies().containsKey('locname'))
            {
                intakeLocation = apexpages.currentPage().getCookies().get('locname').getValue();
                System.debug('intakeLocation>>>>>>>>>>'+intakeLocation);
                
                satelliteLoc = apexpages.currentPage().getCookies().get('satelliteloc').getValue();
                System.debug('Satellite Location>>>>>>>>>>'+satelliteLoc);
            }
            
            renderPgMsgBox = false;
            //DS-buena 09/05/2018
            //signOnDateTime = DateTime.newInstance(date.valueOf(date.today()), Time.newInstance(0, 0, 0, 0));
            signOnDateTime = System.now();
            currentDate = Date.today();
            isMobileParentGuardians = false;
            isHomeParentGuardians =  false;
            haveAppoinment = false;
            meetAdvisor = false;
            
            
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
            
            
            //EOC Sign On****************
            if(mapFieldAPIToValues.containsKey('Preferred_Phone_Type__c')){
                preferredPhoneTypeOptions = mapFieldAPIToValues.get('Preferred_Phone_Type__c');
                preferredPhoneTypeOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Is_Mobile_OK_to_Text__c')){
                isMobileOktoTestOptions = mapFieldAPIToValues.get('Is_Mobile_OK_to_Text__c');
                isMobileOktoTestOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Primary_Purpose_of_Visit__c')){ //modified on 9 Nov 2018, by Aj *********
                //purposeofVisitOptions = mapFieldAPIToValues.get('Purpose_of_Visit_EOC_TS__c'); //Commented on 9 Nov 2018, by Aj *******
                purposeofVisitOptions = mapFieldAPIToValues.get('Primary_Purpose_of_Visit__c'); //Added on 9 Nov 2018, by Aj *********
                purposeofVisitOptions.add(0,new SelectOption('None','None')); //Added on 9 Nov 2018, by Aj *********
            }
            
            if(mapFieldAPIToValues.containsKey('Preferred_language__c')){
                preferredLanguageOptions = mapFieldAPIToValues.get('Preferred_language__c');
                preferredLanguageOptions.add(0,new SelectOption('','None'));
            }
            if(mapFieldAPIToValues.containsKey('Suffix__c')){
                suffixOptions = mapFieldAPIToValues.get('Suffix__c');
                suffixOptions.add(0,new SelectOption('','None'));
            }
            
            
            //EOC Intake
            if(mapFieldAPIToValues.containsKey('Gender__c')){
                genderIdentityOptions = mapFieldAPIToValues.get('Gender__c');
                genderIdentityOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Is_Mother_4yr_U_S_College_Grad__c')){
                isMotherCollegeGradOptions = mapFieldAPIToValues.get('Is_Mother_4yr_U_S_College_Grad__c');
                isMotherCollegeGradOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Ethnicity__c')){
                ethnicityOptions = mapFieldAPIToValues.get('Ethnicity__c');
                ethnicityOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Is_Father_4yr_U_S_College_Grad__c')){
                isFatherCollegeGradOptions = mapFieldAPIToValues.get('Is_Father_4yr_U_S_College_Grad__c');
                isFatherCollegeGradOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Marital_Status__c')){
                maritialStatusOptions = mapFieldAPIToValues.get('Marital_Status__c');
                maritialStatusOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Annual_Taxable_Income__c')){
                annualTaxableIncomeOptions = mapFieldAPIToValues.get('Annual_Taxable_Income__c');
                annualTaxableIncomeOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Are_you_a_US_Citizen__c')){
                usCitizenOptions = mapFieldAPIToValues.get('Are_you_a_US_Citizen__c');
                usCitizenOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Primary_Income_Source__c')){
                primaryIncomeSourceOptions = mapFieldAPIToValues.get('Primary_Income_Source__c');
                primaryIncomeSourceOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Veteran_Status__c')){
                veteranStatusOptions = mapFieldAPIToValues.get('Veteran_Status__c');
                veteranStatusOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Talent_Search_School__c')){
                schoolOptions = mapFieldAPIToValues.get('Talent_Search_School__c');
                schoolOptions.add(0,new SelectOption('','Select School'));
            }
            
            if(mapFieldAPIToValues.containsKey('Learned_About_Program__c')){
                learnAboutProgramOptions = mapFieldAPIToValues.get('Learned_About_Program__c');
                learnAboutProgramOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Student_Status__c')){
                studentStatusOptions = mapFieldAPIToValues.get('Student_Status__c');
                studentStatusOptions.add(0,new SelectOption('','None'));
            }
            
            lstCPSAdvisorOption = new List<SelectOption>();
            lstCPSAdvisorOption.add(new SelectOption('','None'));
            for(User objUser : [select id,name from User where isActive = true AND profile.name LIKE 'CPS - EOC%' AND Title != 'Test Account' ORDER BY Name]){
                lstCPSAdvisorOption.add(new SelectOption(objUser.Id,objUser.Name));
            }
        }
        catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in eOCFormController method>>>>>>>>>'+ex.getLineNumber() + ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
        }
    }
    
    //Method to redirect to input location page
    public PageReference redirectToHome()
    {
        PageReference homePage = new PageReference('/apex/CPS_Input_location').setRedirect(true);
       
        if(String.isBlank(intakeLocation))
        {
            System.debug('>>>>inside redirectToHome');
            return homePage;
        }
        else if(!intakeLocation.containsIgnoreCase('EOC'))
        {
            return homePage;
        }
        return null;
    }
    
    //Create EOC Sign On Lead and Task
    public PageReference registerLead()
    {
        try
        {
            System.debug('birthDate++++'+birthdate);
            System.debug('firstname++++'+firstname);
            System.debug('lastName+++++'+lastName);
            System.debug('purposeofVisitSelectedOption++++'+purposeofVisitSelectedOption);
            
            System.debug('mobilePhone@@@@@'+mobilePhone);
            if(/*passedCaptcha*/true)
            {
                //remove leading and ending space
                firstName = firstName.trim();
                lastName = lastName.trim();
                email = string.isNotBlank(email)?email.trim():null;
                
                Id idRecordTypeEOCContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - EOC').getRecordTypeId();
                
                Set<String> setCPSRecordTypeName = new Set<String>{'CPS - EOC','CPS - TS','CPS - UB'};
                
                String query;
                if((firstName != null && firstName != '') || email != null || mobilePhone != null)
                {
                    System.debug('birthDate>>>>>>'+birthDate);
                    String strBirthDate = String.valueOf(birthDate) + ' 00:00:00';
                    System.debug('strBirthDate>>>>'+strBirthDate);
                    
                    query = 'select id,name,Intake_Form_Expire_Date_EOC__c,accountid from contact where RecordType.Name in : setCPSRecordTypeName AND LastName =: lastName AND BirthDate_Text__c =: strBirthDate AND (FirstName =: firstName';
                    
                    //remove alpha and special characters from mobilePhone
                    if(String.isNotBlank(mobilePhone)){
                        mobilePhone = mobilePhone.trim();
                        Pattern numberOnly = Pattern.compile('[a-zA-Z,(,),\\-,,[,], ]');
                        Matcher matcher = numberOnly.matcher(mobilePhone);
                        String mobilePhoneNumeric = matcher.replaceAll('');
                        system.debug('mobilePhoneNumeric>>>>>'+mobilePhoneNumeric);
                        query = String.isNotBlank(mobilePhoneNumeric)?query+' OR MobilePhoneNumeric__c =: mobilePhoneNumeric':query;
                    }
                    
                    
                    query = String.isNotBlank(email)?query+' OR Email =: email':query;
                    query += ')';
                    query += ' order by lastModifiedDate desc limit 1';
                }
                
                if(query != null)
                {
                    System.debug('query>>>>>>'+query);
                    List<Contact> lstMatchedContact = Database.query(query);
                    System.debug('lstMatchedContact>>>>>>>>>>'+lstMatchedContact);
                    // DS 13092018 if(lstMatchedContact != null && lstMatchedContact.size()>0 && currentDate < lstMatchedContact[0].Intake_Form_Expire_Date_EOC__c)
                    if(lstMatchedContact != null && lstMatchedContact.size()>0 && currentDate <= lstMatchedContact[0].Intake_Form_Expire_Date_EOC__c)
                    {
                            
                        //Get record type id for new Lead
                        String recordTypeName = 'CPS - EOC';
                        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                        
                        //Get Queue id for new Lead
                        Id queueId;
                        for(Group objGroup : [select Id from Group where Type = 'Queue' AND name =: intakeLocation limit 1]){
                            queueId = objGroup.id;
                        }
                        
                        //Insert Lead
                        Lead objLead = initilizeNewLead(leadRecordTypeId,queueId);
                        insert objLead;
                        
                        //Insert Task
                        if(meetAdvisor)
                        {
                            Task objTask = initializeNewTask('Advising Session','Meeting',objLead); //Modified on 12 Nov 2018, by Aj
                            insert objTask;
                        }
                        else
                        {
                            Task objTask = initializeNewTask('Use Resources','Use Resources',objLead); //Modified on 12 Nov 2018, by Aj
                            objTask.Status = 'Closed'; //Added on 12 Nov 2018, by Aj
                            insert objTask;
                        }
                        
                        //Redirect to confirmation page
                        PageReference confirmationPage = new PageReference('/apex/ConfirmationPage');
                        confirmationPage.getParameters().put('origin', 'eoc');
                        confirmationPage.setRedirect(false);
                        return confirmationPage;
                    }
                    else
                    {
                        PageReference intakeEOCFormRef = new PageReference('/apex/EOCIntake');
                        intakeEOCFormRef.setRedirect(false);
                        return intakeEOCFormRef;
                    }
                }
            }
            else
            {
                System.debug('wrong captcha>>>>>>>');
            }
            return null;
        }
        catch(Exception ex)
        {
            renderPgMsgBox = true;
            system.debug('Exception in registerLead method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            return null;
        }
    }
    
    //Create EOC Intake Lead and Task
    public PageReference registerIntakeLead()
    {
        try
        {
            //Boolean passedCaptcha = captchaController.doVerify();
            if(/*passedCaptcha*/true)
            {
                //if(true){
                System.debug('registerIntakeLead>>>>>');
                //Get record type id for new Lead
                String recordTypeName = 'CPS - EOC';
                Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                
                //Get Queue id for new Lead
                Id queueId;
                for(Group objGroup : [select Id from Group where Type = 'Queue' AND name =: intakeLocation limit 1]){
                    queueId = objGroup.id;
                }
                
                //Insert Lead
                Lead objLead = initilizeNewLead(leadRecordTypeId,queueId);
                objLead.Intake_Date__c = Date.today();
                if(String.isNotBlank(GenderIdentity)){
                    objLead.Gender__c = GenderIdentity;
                }
                if(String.isNotBlank(isMotherCollegeGrad)){
                    objLead.Is_Mother_4yr_U_S_College_Grad__c = isMotherCollegeGrad;
                }   
                if(String.isNotBlank(ethnicity)){
                    objLead.Ethnicity__c = ethnicity;
                }
                if(String.isNotBlank(IsFatherCollegeGrad)){
                    objLead.Is_Father_4yr_U_S_College_Grad__c = IsFatherCollegeGrad;
                }
                if(String.isNotBlank(maritialStatus)){
                    objLead.Marital_Status__c = maritialStatus;
                }
                if(String.isNotBlank(annualTaxableIncome)){
                    objLead.Annual_Taxable_Income__c = annualTaxableIncome;
                }
                if(String.isNotBlank(usCitizen)){
                    objLead.Are_you_a_US_Citizen__c = usCitizen;
                }
                if(String.isNotBlank(primaryIncomeSource)){
                    objLead.Primary_Income_Source__c = primaryIncomeSource;
                }
                if(String.isNotBlank(veteranStatus)){
                    objLead.Veteran_Status__c = veteranStatus;
                }
                if(houseHoldSize != null){
                    objLead.Household_Size__c = houseHoldSize;
                }
                if(String.isNotBlank(school)){
                    objLead.Talent_Search_School__c = school;
                }
                if(String.isNotBlank(learnAboutProgram)){
                    objLead.Learned_About_Program__c = learnAboutProgram;
                }
                if(String.isNotBlank(schoolOther)){
                    objLead.School_Other__c = schoolOther;
                }
                if(String.isNotBlank(otherLearnedAboutProgram)){
                    objLead.Other_Learned_about_program__c = otherLearnedAboutProgram;
                }
                if(String.isNotBlank(studentStatus)){
                    objLead.Student_Status__c = studentStatus;
                }
                if(String.isNotBlank(careerGoals)){
                    objLead.Career_Goals__c = careerGoals;
                }
                if(String.isNotBlank(motherGuardian1FirstName)){
                    objLead.Mother_Guardian1_First_Name__c = motherGuardian1FirstName;
                }
                if(String.isNotBlank(motherGuardian1LastName)){
                    objLead.Mother_Guardian1_Last_Name__c = motherGuardian1LastName;
                }
                if(String.isNotBlank(fatherGuardian2FirstName)){
                    objLead.Father_Guardian2_First_Name__c = fatherGuardian2FirstName;
                }
                if(String.isNotBlank(fatherGuardian2LastName)){
                    objLead.Father_Guardian2_Last_Name__c = fatherGuardian2LastName;
                }
                if(String.isNotBlank(parentEmail)){
                    objLead.Parent_Email__c = parentEmail;
                }
                if(String.isNotBlank(permanentResidentId)){
                    objLead.Permanent_Resident_ID_Text__c = permanentResidentId;
                }
                if(String.isNotBlank(socialSecurityNumber)){
                    objLead.SSN_text__c = socialSecurityNumber.replace('-','');
                }
                
                System.debug('objLead>>>>>'+objLead);
                insert objLead;
                
                //Insert Task
                if(meetAdvisor)
                {
                    Task objTask = initializeNewTask('Advising Session','Meeting',objLead); //Modified on 12 Nov 2018, by Aj
                    insert objTask;
                }
                else
                {
                    Task objTask = initializeNewTask('Use Resources','Use Resources',objLead); //Modified on 12 Nov 2018, by Aj
                    objTask.Status = 'Closed';
                    insert objTask;
                }
                //Redirect to confirmation page
                PageReference confirmationPage = new PageReference('/apex/ConfirmationPage?');
                confirmationPage.getParameters().put('origin', 'eoc');
                confirmationPage.setRedirect(false);
                return confirmationPage;
            }
            else
            {
                System.debug('wrong captcha>>>>>>>');
                return null;
            }
        }
        catch(Exception ex)
        {
            renderPgMsgBox = true;
            system.debug('Exception in registerIntakeLead method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            return null;
        }
    }
    
    public Lead initilizeNewLead(String recordTypeId,String ownerId){
        //Lead fields assignment
        Lead objLead = new Lead();
        objLead.Company = 'College Planning Services '+Date.today().year();
        objLead.LastName = lastName;
        objLead.Status = 'Open';
        
        if(String.isNotBlank(firstName)){
            objLead.FirstName = firstName;
        }
        if(String.isNotBlank(intakeLocation)){
            objLead.Intake_Location__c = intakeLocation;
        }
        if(String.isNotBlank(recordTypeId)){
            objLead.recordTypeId = recordTypeId; 
        }
        if(String.isNotBlank(ownerId)){
            objLead.Ownerid = ownerId;
        }
        if(String.isNotBlank(mddleInitials)){
            objLead.Middle_Initial__c = mddleInitials;
        }
        if(birthDate != null){
            objLead.BirthDate__c = birthDate;
        }
        if(String.isNotBlank(email)){
            objLead.Email = email;
        }
        if(String.isNotBlank(preferredPhoneType)){
            objLead.Preferred_Phone_Type__c = preferredPhoneType;
        }
        System.debug('mobilePhone @@@@@'+mobilePhone );
        if(mobilePhone != null){
            objLead.Mobile_Phone__c = mobilePhone;
        }
        if(homePhone != null){
            objLead.Home_Phone__c = homePhone;
        }
        if(isMobileParentGuardians){
            objLead.Is_Mobile_Mobile_Guardian__c = isMobileParentGuardians;
        }
        if(isHomeParentGuardians){
            objLead.Is_Home_Parent_Guardian__c = isHomeParentGuardians;
        }
        if(String.isNotBlank(isMobileOktoTest)){
            objLead.Is_Mobile_OK_to_Text__c = isMobileOktoTest;
        }
        if(String.isNotBlank(street)){
            objLead.Street = street;
        }
        if(String.isNotBlank(city)){
            objLead.City = city;
        }
        if(String.isNotBlank(state)){
            objLead.State = state;
        }
        if(String.isNotBlank(zipCode)){
            objLead.PostalCode = zipCode;
        }
        if(String.isNotBlank(country)){
            objLead.Country = country;
        }
        if(haveAppoinment){
            objLead.Have_Appointment__c = haveAppoinment;
        }
        if(String.isNotBlank(preferredLanguage)){
            objLead.Preferred_language__c = preferredLanguage;
        }
        if(meetAdvisor){
            objLead.Meet_with_Advisor__c = meetAdvisor;
        }
        if(String.isNotBlank(additionalLanguage)){
            objLead.Additional_Languages__c = additionalLanguage;
        }
        if(cPSAdvisorRequested != null){
            objLead.CPS_Advisor_Requested__c = cPSAdvisorRequested;
        }
        if(String.isNotBlank(purposeofVisitOther)){
            objLead.Purpose_of_Visit__c = purposeofVisitOther;
        }
        if(String.isNotBlank(satelliteLoc)){
            objLead.Satellite_Intake_Location_EOC__c = satelliteLoc;
        } 
        
        //Added by DS 13092018
        if(String.isNotBlank(schGuidanceCounselor)){
            objLead.School_Guidance_Counselor__c= schGuidanceCounselor;
        }
        
        // Added by RS on 20092018
        if(String.isNotBlank(suffix)){
            objLead.Suffix__c = suffix;
        }
        
        /*** Commented on 9 Nov 2018, by Aj *********
        // modified by Ravinder on 24072018
        objLead.Purpose_of_Visit_EOC_TS__c = purposeofVisitSelectedOption.replace(',',';').removeEnd(']').removeStart('[');  //Deepak 13072018
        System.debug('purposeofVisitSelectedOption@@@@'+purposeofVisitSelectedOption);
        *************************************/
        //*** Added on 9 NOv 2018, by Aj***********
        
        if(meetAdvisor) 
        {
            if(purposeofVisitSelectedOption == 'None') //Added by RS on 11142018
            {
                objLead.Primary_Purpose_of_Visit__c = Null; // Modified by RS on 11142018
            }
            else //Added by RS on 11142018
            {
                objLead.Primary_Purpose_of_Visit__c = purposeofVisitSelectedOption; // Modified by RS on 11142018
            }
        }
        else
        {
            objLead.Primary_Purpose_of_Visit__c =  'Use Resources';
        }
        //*****************************************
        
        objLead.Sign_On_DateTime__c = System.now();
        return objLead;
        
    }
    
    public Task initializeNewTask(String subject, String type, Lead objLead)
    {
        Id tskOwnerId = [select id,name from user where name =: Label.CPSSignOn_AdvProcess and isActive = true].id;
        Id idRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CPS - Task').getRecordTypeId();
        
        Task objTask = new Task();
        objTask.Subject = subject;
        objTask.Type = type;
        objTask.whoId = objLead.Id;
        objTask.status = 'In Progress';
        objTask.ActivityDate = Date.today();
        objTask.Satellite_Location_EOC__c = objLead.Satellite_Intake_Location_EOC__c; //Added by DS 13092018 //Modified on 12 Nov 2018, by Aj*******
        objTask.Purpose_of_Visit_Other__c = objLead.Purpose_of_Visit__c; //Added on 12 Nov 2018, by Aj******
        objTask.Primary_Purpose_of_Visit__c = objLead.Primary_Purpose_of_Visit__c; //Added on 12 Nov 2018, by Aj******
        
        if(tskOwnerId != null)
        {
            objTask.Ownerid = tskOwnerId;
        }
        if(idRecordType != null){
            objTask.recordTypeId = idRecordType;
        }
        return objTask;
    }
    public PageReference redirectToSignOn()
    {
        PageReference  p=Page.EOCSignOn;
        return p.setRedirect(true);
    }   
}