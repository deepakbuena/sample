/*
TestClassName : TSFormControllerTest
*/
public class TSFormController{
    //Internal usage
    public String intakeLocation{get; set;}
    public Date currentDate;
    public Contact objMatchedCon;
    public Boolean renderPgMsgBox{get;set;} //to render pagemessage box on the page
    
    
    //TS Sign On info
    public String firstName{get; set;}
    public String studentId{get;set;}
    public String lastName{get; set;}
    public Boolean isMobileParentGuardians{get; set;}
    public String middleInitials {get; set;}
    public Date birthDate{get; set;}
    public String email{get; set;}
    public String isMobileOktoText{get; set;}
    public List<SelectOption> isMobileOktoTextOptions{get; set;}
    public String mobilePhone{get; set;}
    public String preferredPhoneType{get; set;}
    public List<SelectOption> preferredPhoneTypeOptions{get; set;}
    public String homePhone{get; set;}
    public Boolean isHomeParentGuardians{get; set;}
    public String street{get; set;}
    public String zipCode{get; set;}
    public String city{get; set;}
    public String country{get; set;}
    public String state{get; set;}
    public String purposeOfVisit{get; set;}
    public List<SelectOption> purposeOfVisitOptions{get; set;} //Does not exist on Contact obj
    public String purposeofVisitOther{get; set;}
    
    
    //Intake info
    public String otherPhone{get; set;}
    public Boolean isOtherParentGuardians{get; set;}
    public String genderIdentity{get; set;}
    public List<SelectOption> genderIdentityOptions{get; set;}
    public String school{get; set;}
    public List<SelectOption> schoolOptions{get; set;} //Does not exist on Contact obj
    public String ethnicity{get; set;}
    public List<SelectOption> ethnicityOptions{get; set;}
    public String schoolOther{get; set;}
    public String usCitizen{get; set;}
    public List<SelectOption> usCitizenOptions{get; set;}
    public String ExpectedGraduationYear{get;set;}
    public String ReferredBy{get;set;}
    public String currentGradeLevel{get; set;}
    public List<SelectOption> currentGradeLevelOptions{get; set;} //Does not exist on Contact obj
    public String permanentResidentId{get;set;}
    public String socialSecurityNumber{get;set;}
    public String motherGuardian1FirstName{get; set;}
    public String motherGuardian1LastName{get; set;}
    public String fatherGuardian2FirstName{get; set;}
    public String fatherGuardian2LastName{get; set;}
    public String parentEmail{get; set;} 
    public String isMotherCollgGrad{get;set;}
    public List<SelectOption> isMotherCollgGradOptions{get; set;}
    public String isFatherCollgGrad{get;set;}
    public List<SelectOption> isFatherCollgGradOptions{get; set;}
    public String motherCollg{get;set;}
    public String fatherCollg{get;set;}
    public String annualTaxIncome{get;set;}
    public List<SelectOption> annualTaxIncomeOptions{get; set;}
    public Integer houseHoldSize{get; set;}
    public String statementOfNeed{get; set;}
    public List<SelectOption> statementOfNeedOptions{get; set;}
    public String otherPrograms{get;set;}
    public String tutorialTopic{get;set;}
    
    public String suffix{get; set;}
    public List<SelectOption> suffixOptions{get; set;}
    
    //Constructor
    public tSFormController(){
        try{
            System.debug('register>>>>>>'+birthdate);
            //Internal Usage
            if(apexpages.currentPage().getCookies() != null && apexpages.currentPage().getCookies().containsKey('locname')){
                intakeLocation = apexpages.currentPage().getCookies().get('locname').getValue();
            }
            System.debug('intakeLocation>>>>>>>>>>'+intakeLocation);
            
            currentDate = Date.today();
            isMobileParentGuardians = false;
            isHomeParentGuardians = false;
            isOtherParentGuardians = false;
            renderPgMsgBox = false;
            
            
            //Get valid picklist values
            Id idRecordTypePicklistConfig = Schema.SObjectType.CPS_Picklist_Config__c.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            Map<String,List<SelectOption>> mapFieldAPIToValues = new Map<String,List<SelectOption>>();
            for(CPS_Picklist_Config__c objPicklistConfig : [select Name,Picklist_API_Name__c,Valid_Values__c
                                                            from CPS_Picklist_Config__c where recordTypeId =: idRecordTypePicklistConfig]){
                List<SelectOption> lstOptions = new List<SelectOption>();
                for(String value : objPicklistConfig.Valid_Values__c.split(';')){
                    SelectOption option = new SelectOption(value,value);
                    lstOptions.add(option);
                }
                System.debug('lstOptions>>>>>>'+lstOptions);
                if(lstOptions.size()>0){
                    mapFieldAPIToValues.put(objPicklistConfig.Picklist_API_Name__c,lstOptions);
                }
            }
            
            
            if(mapFieldAPIToValues.containsKey('Is_Mobile_OK_to_Text__c')){
                isMobileOktoTextOptions = mapFieldAPIToValues.get('Is_Mobile_OK_to_Text__c');
                isMobileOktoTextOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Preferred_Phone_Type__c')){
                preferredPhoneTypeOptions = mapFieldAPIToValues.get('Preferred_Phone_Type__c');
                preferredPhoneTypeOptions.add(0,new SelectOption('','None'));
            }
            
             if(mapFieldAPIToValues.containsKey('Primary_Purpose_of_Visit__c')){  //modified on 9 Nov 2018, by Aj *********
                //purposeofVisitOptions = mapFieldAPIToValues.get('Purpose_of_Visit_EOC_TS__c'); //Commented on 9 Nov 2018, by Aj *******
                purposeofVisitOptions = mapFieldAPIToValues.get('Primary_Purpose_of_Visit__c'); //Added on 9 Nov 2018, by Aj *********
                purposeofVisitOptions.add(0,new SelectOption('','None')); //Added on 9 Nov 2018, by Aj *********
            }
            
            if(mapFieldAPIToValues.containsKey('Gender__c')){
                genderIdentityOptions = mapFieldAPIToValues.get('Gender__c');
                genderIdentityOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Secondary_School_at_Intake_Picklist__c')){
                schoolOptions = mapFieldAPIToValues.get('Secondary_School_at_Intake_Picklist__c');
                schoolOptions.add(0,new SelectOption('','Select School'));
                
            }
            
            if(mapFieldAPIToValues.containsKey('Ethnicity__c')){
                ethnicityOptions = mapFieldAPIToValues.get('Ethnicity__c');
                ethnicityOptions.add(0,new SelectOption('','None'));
            }
            
            usCitizenOptions = getPickListValues('Are_you_a_US_Citizen__c');
            if(mapFieldAPIToValues.containsKey('Are_you_a_US_Citizen__c')){
                usCitizenOptions = mapFieldAPIToValues.get('Are_you_a_US_Citizen__c');
                usCitizenOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Grade_Level_at_Entry__c')){
                currentGradeLevelOptions = mapFieldAPIToValues.get('Grade_Level_at_Entry__c');
                currentGradeLevelOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Is_Mother_College_graduate__c')){
                isMotherCollgGradOptions = mapFieldAPIToValues.get('Is_Mother_College_graduate__c');
                isMotherCollgGradOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Is_Father_College_graduate__c')){
                isFatherCollgGradOptions = mapFieldAPIToValues.get('Is_Father_College_graduate__c');
                isFatherCollgGradOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Annual_Taxable_Income__c')){
                annualTaxIncomeOptions = mapFieldAPIToValues.get('Annual_Taxable_Income__c');
                annualTaxIncomeOptions.add(0,new SelectOption('','None'));
            }
            
            if(mapFieldAPIToValues.containsKey('Statement_of_Need__c')){
                statementOfNeedOptions = mapFieldAPIToValues.get('Statement_of_Need__c');
            }
            // Added by RS on 20092018
            if(mapFieldAPIToValues.containsKey('Suffix__c')){
                suffixOptions = mapFieldAPIToValues.get('Suffix__c');
                suffixOptions.add(0,new SelectOption('','None'));
            }
        }
        catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in TSFormController method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
        }
    }
    
    //Method to redirect to input location page
    public PageReference redirectToHome(){
        PageReference homePage = new PageReference('/apex/CPS_Input_location');
        homePage.setRedirect(true);
        
        if(String.isBlank(intakeLocation)){
            System.debug('>>>>inside redirectToHome');
            return homePage;
        }
        else if(!intakeLocation.containsIgnoreCase('TS')){
            return homePage;
        }
        return null;
    }
    
    //Method to get picklist values
    public List<SelectOption> getPicklistValues(String fieldName){
        System.debug('inside>>>>>>>>');
        List<SelectOption> lstPickvals = new List<SelectOption>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Contact');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        lstPickvals.add(new SelectOption('','None'));
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(new SelectOption(a.getValue(),a.getLabel()));//add the value  to our final list
        }
        System.debug('lstPickvals>>>>>>>>'+lstPickvals);
        return lstPickvals; 
    }
    
    
    //Method for SignOn form
    public PageReference registerContact(){
        try{
            System.debug('register>>>>>>'+birthdate);
            //Boolean passedCaptcha = captchaController.doVerify();
            if(/*passedCaptcha*/true){
                Id idRecordTypeTSContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CPS - TS').getRecordTypeId();
                
                Set<String> setCPSRecordTypeName = new Set<String>{'CPS - EOC','CPS - TS','CPS - UB'};
                
                String query;
                if((studentId != null && studentId != '') || (firstName != null && firstName != '') || email != null || mobilePhone != null){
                    String strBirthDate = String.valueOf(birthDate).trim() + ' 00:00:00';
                    System.debug('strBirthDate>>>>'+strBirthDate);
                    
                    query = 'select id,name,Intake_Date__c,Intake_Form_Expire_Date_EOC__c,accountid from contact where RecordType.Name in : setCPSRecordTypeName AND';
                    if(studentId != null && studentId != ''){
                        studentId = studentId.trim();
                        lastName = lastName.trim();
                        query += ' ((LastName =: lastName AND Student_ID__c =: studentId) OR';
                    }
                    if(firstName != null || mobilePhone != null || email != null){ 
                        firstName = firstName.trim();
                        if(String.isNotBlank(email)){
                            email = email.trim();
                        }
                        if(String.isNotBlank(mobilePhone)){
                            mobilePhone = mobilePhone.trim();
                            
                            //remove alpha and special characters from mobilePhone
                            Pattern numberOnly = Pattern.compile('[a-zA-Z,(,),\\-,,[,], ]');
                            Matcher matcher = numberOnly.matcher(mobilePhone);
                            String mobilePhoneNumeric = matcher.replaceAll('');
                            system.debug('mobilePhoneNumeric>>>>>'+mobilePhoneNumeric);
                        }
                        
                        query += ' (LastName =: lastName AND BirthDate_Text__c =: strBirthDate AND (FirstName =: firstName';
                    
                        query = mobilePhone != null?query+' OR MobilePhoneNumeric__c =: mobilePhoneNumeric':query;
                        query = email != null?query+' OR email =: email':query;
                        query += '))';
                    }
                    if(studentId != null && studentId != ''){
                        query += ')';
                    }
                    query += ' order by lastModifiedDate desc limit 1';
                }
                
                if(query != null){
                    System.debug('query>>>>>>'+query);
                    List<Contact> lstMatchedContact = Database.query(query);
                    if(lstMatchedContact != null && lstMatchedContact.size()>0){
                        if(lstMatchedContact[0].Intake_Date__c != null && Integer.valueOf(lstMatchedContact[0].Intake_Date__c.year()) > Integer.valueOf('1901')){
                            //Insert Task
                            Task objTask = initilizeNewTask('TS New Task',lstMatchedContact[0].id);
                            insert objTask;
                            
                            //Redirect to confirmation page
                            PageReference confirmationPage = new PageReference('/apex/ConfirmationPage');
                            confirmationPage.getParameters().put('origin', 'ts');
                            confirmationPage.setRedirect(false);
                            return confirmationPage;
                        }
                        else{
                            objMatchedCon = lstMatchedContact[0];
                            renderPgMsgBox=false;
                            return new PageReference('/apex/TSIntake').setRedirect(false);
                        }
                    }
                    else{
                        renderPgMsgBox=false;
                        return  new PageReference('/apex/TSIntake').setRedirect(false);
                    }
                }
                return null;
            }   
            else{
                System.debug('wrong captcha>>>>>>>');
                return null;
            }
        }
        catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in registerContact method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            return null;
        }
    }
    
    //Method for Intake form
    public PageReference registerIntakeContact(){
        try{
            //Get record type id for new Lead
            //Boolean passedCaptcha = captchaController.doVerify();
            if(/*passedCaptcha*/true){
                String recordTypeName = 'CPS - TS';
                Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                
                //Get Queue id for new Lead
                Id queueId;
                for(Group objGroup : [select Id from Group where Type = 'Queue' AND name =: intakeLocation limit 1]){
                    queueId = objGroup.id;
                }
                
                //Get valid Account
                Id accountId;
                String accountName = 'College Planning Services '+Date.today().year();
                for(Account objAcc : [select Id from Account where Name =: accountName limit 1]){
                    accountId = objAcc.id;
                }
                
                //Get User Ids
                Set<String> setUserName = new Set<String>{'Julie Kimball','Rose Arthur'};
                Map<String,Id> mapUserNameToId = new Map<String,Id>();
                for(User objUser : [select Id,name from User where Name in : setUserName]){
                    mapUserNameToId.put(objUser.Name,objUser.Id);
                }
                
                Contact objContact = initilizeNewContact(conRecordTypeId,queueId);
                System.debug('objMatchedCon>>>>>>'+objMatchedCon);
                if(objMatchedCon != null){
                    objContact.id = objMatchedCon.id;
                }
                else{
                    objContact.Intake_Location__c = String.isNotBlank(intakeLocation)?intakeLocation:null;
                    if(accountId != null){
                        objContact.AccountId = accountId;
                    }
                    if(intakeLocation == 'TS Boston'){
                        if(mapUserNameToId.containsKey('Julie Kimball')){
                            objContact.OwnerId = mapUserNameToId.get('Julie Kimball');
                        }
                    }
                    else{
                        if(mapUserNameToId.containsKey('Rose Arthur')){
                            objContact.OwnerId = mapUserNameToId.get('Rose Arthur');
                        }
                    }
                }
                objContact.Intake_Date__c = Date.today();
                if(String.isNotBlank(street)){
                    objContact.MailingStreet = street;
                }
                if(String.isNotBlank(zipCode)){
                    objContact.MailingPostalCode = zipCode;
                }
                if(String.isNotBlank(city)){
                    objContact.MailingCity = city;
                }
                if(String.isNotBlank(country)){
                    objContact.MailingCountry = country;
                }
                if(String.isNotBlank(state)){
                    objContact.MailingState = state;
                }
                if(String.isNotBlank(preferredPhoneType)){
                    objContact.Preferred_Phone_Type__c = preferredPhoneType;
                }
                if(isMobileParentGuardians){
                    objContact.Is_Mobile_Parent_Guardian__c = isMobileParentGuardians;
                }
                if(String.isNotBlank(homePhone)){
                    objContact.HomePhone =  homePhone;
                }
                if(String.isNotBlank(isMobileOktoText)){
                    objContact.Is_Mobile_OK_to_Text__c = isMobileOktoText;
                }
                if(isHomeParentGuardians){
                    objContact.Is_Home_Parent_Guardian_checkbox__c = isHomeParentGuardians;
                }
                if(String.isNotBlank(otherPhone)){
                    objContact.OtherPhone = otherPhone;
                }
                if(isOtherParentGuardians){
                    objContact.Is_Other_Parent_Guardian__c = isOtherParentGuardians;
                }
                if(String.isNotBlank(genderIdentity)){
                    objContact.Gender__c = genderIdentity;
                }
                if(String.isNotBlank(school)){
                    objContact.Secondary_School_at_Intake_Picklist__c = school;
                }
                if(String.isNotBlank(ethnicity)){
                    objContact.Ethnicity__c = ethnicity;
                }
                if(String.isNotBlank(schoolOther)){
                    objContact.Secondary_School_Other__c = schoolOther;
                }
                if(String.isNotBlank(usCitizen)){
                    objContact.Are_you_a_US_Citizen__c = usCitizen;
                }
                if(ExpectedGraduationYear != null){
                    objContact.Expected_Graduation_Year__c = ExpectedGraduationYear;
                }
                if(String.isNotBlank(ReferredBy)){
                    objContact.Referred_by__c = ReferredBy;
                }
                
                if(String.isNotBlank(currentGradeLevel)){
                    objContact.Grade_Level_at_Entry__c = currentGradeLevel;
                }
                
                if(String.isNotBlank(permanentResidentId)){
                    objContact.Permanent_Resident_ID_Text__c = permanentResidentId;
                }
                if(String.isNotBlank(socialSecurityNumber)){
                    objContact.SSN_text__c = socialSecurityNumber.replace('-','');
                }
                if(String.isNotBlank(motherGuardian1FirstName)){
                    objContact.Mother_Guardian1_First_Name__c = motherGuardian1FirstName;
                }
                if(String.isNotBlank(motherGuardian1LastName)){
                    objContact.Mother_Guardian1_Last_Name__c = motherGuardian1LastName;
                }
                if(String.isNotBlank(fatherGuardian2FirstName)){
                    objContact.Father_Guardian2_First_Name__c = fatherGuardian2FirstName;
                }
                if(String.isNotBlank(fatherGuardian2LastName)){
                    objContact.Father_Guardian2_Last_Name__c = fatherGuardian2LastName;
                }
                if(String.isNotBlank(parentEmail)){
                    objContact.Parent_Email__c = parentEmail;
                }
                if(String.isNotBlank(isMotherCollgGrad)){
                    objContact.Is_Mother_College_graduate__c = isMotherCollgGrad;
                }
                if(String.isNotBlank(isFatherCollgGrad)){
                    objContact.Is_Father_College_graduate__c = isFatherCollgGrad;
                }
                if(String.isNotBlank(motherCollg)){
                    objContact.Mother_s_college__c = motherCollg;
                }
                if(String.isNotBlank(fatherCollg)){
                    objContact.Father_s_college__c = fatherCollg;
                }
                if(String.isNotBlank(annualTaxIncome)){
                    objContact.Annual_Taxable_Income__c = annualTaxIncome;
                }
                if(houseHoldSize != null){
                    objContact.Household_Size__c = houseHoldSize;
                }
                objContact.Statement_of_Need__c = statementOfNeed.replace(',',';').removeEnd(']').removeStart('[');
                
                if(String.isNotBlank(otherPrograms)){
                    objContact.Other_Programs__c = otherPrograms;
                }
                if(String.isNotBlank(tutorialTopic)){
                    objContact.Tutoring_Topic__c = tutorialTopic;
                }
                if(String.isNotBlank(studentId)){
                    objContact.Student_ID__c = studentId;
                }
                
                System.debug('objContact>>>>>>'+objContact.id);
                //upsert contact
                upsert objContact;
                
                //Insert Task
                Task objTask = initilizeNewTask('TS New Task',objContact.id);
                insert objTask;
                
                //Redirect to confirmation page
                PageReference confirmationPage = new PageReference('/apex/ConfirmationPage');
                confirmationPage.getParameters().put('origin', 'ts');
                confirmationPage.setRedirect(false);
                return confirmationPage;
            }else{
                System.debug('wrong captcha>>>>>>>');
                return null;
            }
        }
        catch(Exception ex){
            renderPgMsgBox = true;
            system.debug('Exception in registerContact method>>>>>>>>>'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,String.valueOf(ex)));
            return null;
        }
    }
    
    
    
    public Contact initilizeNewContact(String recordTypeId,String ownerId){
        //Contact fields assignment
        Contact objContact = new Contact();
        objContact.LastName = lastName;
        if(String.isNotBlank(firstName)){
            objContact.FirstName = firstName;
        }
        if(String.isNotBlank(middleInitials)){
            objContact.Middle_Name__c = middleInitials;
        }
        // Added by RS on 20092018
        if(String.isNotBlank(suffix)){
            objContact.Suffix__c = suffix;
        }
        System.debug('birthDate>>>>>>>>>>'+birthDate);
        if(birthDate != null){
            objContact.BirthDate = Date.valueOf(birthDate);
        }
        if(String.isNotBlank(email)){
            objContact.Email = email;
        }
        if(String.isNotBlank(mobilePhone)){
            objContact.MobilePhone = mobilePhone;
        }
        if(String.isNotBlank(recordTypeId)){
            objContact.recordTypeId = recordTypeId;
        }
        objContact.Auto_Created_Source__c = 'CPS Sign On';
        return objContact;
    }
    
    public Task initilizeNewTask(String subject, Id parentId){
        Id tskOwnerId = [select id,name from user where name =: Label.CPSSignOn_AdvProcess and isActive = true].id;
        System.debug('tskOwnerId>>>>>>>'+tskOwnerId);
        Id idRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CPS - Task').getRecordTypeId();
        
        Task objTask = new Task();
        objTask.Subject = subject;
        objTask.whoId = parentId;
        objTask.status = 'In Progress';
        objTask.ActivityDate = Date.today();
        objTask.Purpose_of_Visit_Other__c = purposeofVisitOther; // Added by RS on 11142018
        objTask.Primary_Purpose_of_Visit__c = purposeOfVisit; // Added by RS on 11142018
        if(tskOwnerId != null){
            objTask.Ownerid = tskOwnerId;
            System.debug('objTask.Ownerid>>>>>>>'+objTask.Ownerid);
        }
        if(idRecordType != null){
            objTask.recordTypeId = idRecordType;
            System.debug('objTask.recordTypeId>>>>>>>'+objTask.recordTypeId);
        }
        return objTask;
    }
    public PageReference redirectToSignOn()
    {
        PageReference  p=Page.TSSignOn;
        return p.setRedirect(true);
    } 
}