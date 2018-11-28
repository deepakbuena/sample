public class CPSMissingDataAlertCtrl{
//SFD-74   
    @AuraEnabled
    public static List<String> getTargetInfo(String recordId)
    {
        Contact conRec = [Select Id,Eligibility__c,Annual_Taxable_Income__c,Income_Source__c,RecordTypeId,SSN_text__c,Permanent_Resident_ID_Text__c,
                          Are_you_a_US_Citizen__c,Is_Media_Release_Authorized__c,Limited_English_Proficiency__c,MobilePhone,Intake_Location__c,
                          At_Risk_Reading_LA_or_Math_ATOIS__c,At_Risk_Low_GPA_ATOIS__c,At_Risk_Alg_Not_Completed_10th_ATOIS__c,recordtype.name,
                          Parent_Signature_Needed_Received__c,Client_Signature_Needed_Received__c,Secondary_School_at_Intake_Picklist__c,Is_Text_ED_Participant__c,
                          Permanent_Resident_ID_Verified__c From Contact Where Id =:recordId];
                          
                          System.debug('conRec @@@@'+conRec);
                          
        List<String> allErrMsg=new List<String>();

        if(conRec.recordType.name=='CPS - EOC')
        {
            if(conRec.Secondary_School_at_Intake_Picklist__c != '' && conRec.Secondary_School_at_Intake_Picklist__c != 'None of these' && conRec.Secondary_School_at_Intake_Picklist__c != null)
                allErrMsg.add('ALERT! This Client is attending a Talent Search Target School.');
        }
        return allErrMsg;
    }
    
    @AuraEnabled
    public static List<String> getAllMissingInfo(String recordId)
    {
        Contact conRec = [Select Id,Eligibility__c,Annual_Taxable_Income__c,Income_Source__c,RecordTypeId,SSN_text__c,Permanent_Resident_ID_Text__c,
                          Are_you_a_US_Citizen__c,Is_Media_Release_Authorized__c,Limited_English_Proficiency__c,MobilePhone,Intake_Location__c,
                          At_Risk_Reading_LA_or_Math_ATOIS__c,At_Risk_Low_GPA_ATOIS__c,At_Risk_Alg_Not_Completed_10th_ATOIS__c,recordtype.name,
                          Parent_Signature_Needed_Received__c,Client_Signature_Needed_Received__c,Secondary_School_at_Intake_Picklist__c,Is_Text_ED_Participant__c,
                          Permanent_Resident_ID_Verified__c  From Contact Where Id =:recordId];//: ApexPages.currentPage().getParameters().get('id') AND (RecordTypeId =: recTypeCPS_TS OR RecordTypeId =: recTypeCPS_EOC OR RecordTypeId =: recTypeCPS_UB)];
        
        List<String> allErrMsg=new List<String>();
        if(conRec.recordType.name=='CPS - EOC' || conRec.recordType.name=='CPS - TS' || conRec.recordType.name=='CPS - UB')
        {
            if(conRec.Eligibility__c == ''|| conRec.Eligibility__c == 'Unknown/Not disclosed'|| conRec.Eligibility__c ==null )
                allErrMsg.add('Eligibility');
                
            if(conRec.Annual_Taxable_Income__c == ''|| conRec.Annual_Taxable_Income__c == 'Unknown'|| conRec.Annual_Taxable_Income__c ==null)
                allErrMsg.add('Annual Taxable Income');
                
            if((conRec.SSN_text__c == '' || conRec.SSN_text__c ==null) && (conRec.Permanent_Resident_ID_Text__c == ''|| conRec.Permanent_Resident_ID_Text__c == '000000000' || conRec.Permanent_Resident_ID_Text__c == null))
                allErrMsg.add('SSN OR Permanent Resident ID');
                
            if(conRec.Are_you_a_US_Citizen__c == 'No' && (conRec.Permanent_Resident_ID_Text__c == ''|| conRec.Permanent_Resident_ID_Text__c == '000000000' || conRec.Permanent_Resident_ID_Text__c == null))
                allErrMsg.add('Are you a US citizen?/Permanent Resident ID');
    
            if(conRec.Parent_Signature_Needed_Received__c == null || conRec.Parent_Signature_Needed_Received__c =='Needed/NOT Received' ||  conRec.Parent_Signature_Needed_Received__c =='' || conRec.Parent_Signature_Needed_Received__c == 'Unknown')
                allErrMsg.add('Parent Signature Needed/Received');
                
            if(conRec.Client_Signature_Needed_Received__c == null || conRec.Client_Signature_Needed_Received__c =='Needed/NOT Received' ||  conRec.Client_Signature_Needed_Received__c =='' || conRec.Client_Signature_Needed_Received__c == 'Unknown')
                allErrMsg.add('Client Signature Needed/Received');
            
            if(conRec.Is_Media_Release_Authorized__c == '' || conRec.Is_Media_Release_Authorized__c ==null)
                allErrMsg.add('Is Media Release Authorized?');
            
            if(conRec.Limited_English_Proficiency__c == null ||  conRec.Limited_English_Proficiency__c  =='' || conRec.Limited_English_Proficiency__c == 'Unknown')
                allErrMsg.add('Limited English Proficiency');
                
            if((conRec.Is_Text_ED_Participant__c == null ||  conRec.Is_Text_ED_Participant__c =='' || conRec.Is_Text_ED_Participant__c == 'Unknown') && (conRec.MobilePhone != ''&& conRec.MobilePhone!=null)  && conRec.Intake_Location__c == 'EOC Boston')
                allErrMsg.add('Is Text ED Participant?');
                
            if(conRec.Permanent_Resident_ID_Text__c != null && conRec.Permanent_Resident_ID_Verified__c == False )
                allErrMsg.add('Permanent Resident ID is not verified');
                
            if(conRec.recordType.name=='CPS - EOC')
            {
                if(conRec.Income_Source__c == '' || conRec.Income_Source__c == 'Unknown' || conRec.Income_Source__c == null)
                    allErrMsg.add('Income Source');
            }
            
            if(conRec.recordType.name=='CPS - UB')
            {
                if(conRec.At_Risk_Reading_LA_or_Math_ATOIS__c == '' || conRec.At_Risk_Reading_LA_or_Math_ATOIS__c == 'Unknown' || conRec.At_Risk_Reading_LA_or_Math_ATOIS__c == null)
                    allErrMsg.add('At Risk: Reading/LA or Math (ATOIS)');
                
                if(conRec.At_Risk_Low_GPA_ATOIS__c == '' || conRec.At_Risk_Low_GPA_ATOIS__c == 'Unknown' || conRec.At_Risk_Low_GPA_ATOIS__c == null)
                    allErrMsg.add('At Risk: Low GPA');
                
                if(conRec.At_Risk_Alg_Not_Completed_10th_ATOIS__c == '' || conRec.At_Risk_Alg_Not_Completed_10th_ATOIS__c == 'Unknown' || conRec.At_Risk_Alg_Not_Completed_10th_ATOIS__c == null)
                    allErrMsg.add('At Risk: Alg Not Completed 10th (ATOIS)');
            }
        }
        if(allErrMsg.size()>0)
            allErrMsg.add(0,'ALERT! The following field(s) are missing data:');
        return allErrMsg;
    }
}