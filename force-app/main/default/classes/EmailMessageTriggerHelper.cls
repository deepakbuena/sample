public class EmailMessageTriggerHelper{

    //To get metadata records once for DL masking
    static List<Driving_License_Regex_for_State__mdt> lstMetaData = new List<Driving_License_Regex_for_State__mdt>();
    static{
        lstMetaData = [select id,State_Name__c,State_Abbreviation_Regex__c,State_Abbreviation__c,
                                                              Regex_for_DL_Masking__c,High_False_Positive_Rate__c
                                                              from Driving_License_Regex_for_State__mdt];
    }

    public static Set<Id> setCaseId = new Set<Id>();
    public static Map<Id,String> mapCaseIdToSubject = new Map<Id,String>();
    public static Map<Id,String> mapCaseIdToDescription = new Map<Id,String>();
    static String htmlBodyStr ;
    public static void maskValues(List<EmailMessage> lstEmailMsg){
        try{
            setCaseId = new Set<Id>();
            mapCaseIdToSubject = new Map<Id,String>();
            mapCaseIdToDescription = new Map<Id,String>();
            
            for(EmailMessage objEmailMsg : lstEmailMsg){
                String maskedString;
                
                if((objEmailMsg.Subject != null && objEmailMsg.Subject != '')
                    ||(objEmailMsg.TextBody != null && objEmailMsg.TextBody != '')
                    ||(objEmailMsg.HtmlBody != null && objEmailMsg.HtmlBody != ''))
                {
                    maskSSN(objEmailMsg);
                }              
                objEmailMsg.Subject = DrivingLicenceMasker.maskDL(objEmailMsg.Subject,lstMetaData);
                objEmailMsg = DrivingLicenceMasker.maskBody(objEmailMsg,lstMetaData);
                
                if(objEmailMsg.ParentId != null){
                    setCaseId.add(objEmailMsg.ParentId);
                    mapCaseIdToSubject.put(objEmailMsg.ParentId,objEmailMsg.Subject);
                    mapCaseIdToDescription.put(objEmailMsg.ParentId,objEmailMsg.TextBody);
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception>>>>>>'+ex);
            System.debug('Error>>>>>>'+ex.getLineNumber());

        }
    }

    

    //Method to update realted Case
    public static void updateCase(List<EmailMessage> lstEmailMsg){
        try{
            List<Case> listCaseUpdate = new List<Case>();
            for(Case objCase : [Select Id,Description,Subject,
                                (select ToAddress from EmailMessages)
                                from Case 
                                where Id IN : setCaseId]){

                if(objCase.EmailMessages.size() == 1){
                    if(mapCaseIdToSubject.containsKey(objCase.id) && mapCaseIdToSubject.get(objCase.id) != null){
                        objCase.Subject = mapCaseIdToSubject.get(objCase.id);
                    }
                    if(mapCaseIdToDescription.containsKey(objCase.id) && mapCaseIdToDescription.get(objCase.id) != null){
                        objCase.Description = mapCaseIdToDescription.get(objCase.id);
                    }
                    listCaseUpdate.add(objCase);
                }
            }
            
            if(listCaseUpdate.size() > 0){
                update listCaseUpdate ;
            }
        }
        catch(Exception ex){
            System.debug('Error>>>>>>'+ex);
            System.debug('Error>>>>>>'+ex.getLineNumber());
        }
    }
    
    //Method to mask SSN
    public static void maskSSN(EmailMessage emailObj)
    {
        htmlBodyStr=null;
        boolean isSSKeyFound = false;
        boolean isRoutingFound = false; 
        Set<String> lstSSNRegex = new Set<String>{'[ ,.,*,,,\n,:,-][0-9]{3}[-]{1}?[0-9]{2}[-]{1}?[0-9]{4}[ ,.,*,,,\n,:,-]',
                                    '[ ,.,*,,,\n,:,-][0-9]{3}[ ]{1}?[0-9]{2}[ ]{1}?[0-9]{4}[ ,.,*,,,\n,:,-]',
                                    '[ ,.,*,,,\n,:,-][0-9]{3}[.]{1}?[0-9]{2}[.]{1}?[0-9]{4}[ ,.,*,,,\n,:,-]'};
        
        Set<String> lstRoutingRegex = new Set<String>{
                                    '[ ,.,*,,,\n,:,-][0,1,2,3,6,7,8]{1}[0-9]{3}[-]{1}?[0-9]{4}[-]{1}?[0-9]{1}[ ,.,*,,,\n,:,-]'
                                    };
        
        for(String ssnKeyword : Label.SSN_Keywords.split(';')){
            if(emailObj.TextBody.containsIgnoreCase(ssnKeyword) || emailObj.subject.containsIgnoreCase(ssnKeyword)){            
                isSSKeyFound = true;
                break;
            }
        }
        for(String routingKeyword : Label.Routing_Keywords.split(';')){
            if(emailObj.TextBody.containsIgnoreCase(routingKeyword) || emailObj.subject.containsIgnoreCase(routingKeyword)){
                isRoutingFound = true;
                break;
            }
        }   
        if(isSSKeyFound) lstSSNRegex.add('[ ,.,*,,,\n,:,-][0-9]{9}[ ,.,*,,,\n,:,-]');
        if(isRoutingFound) lstRoutingRegex.add('[ ,.,*,,,\n,:,-][0,1,2,3,6,7,8]{1}[0-9]{8}[ ,.,*,,,\n,:,-]');   
        
        for(String ssnRgx : lstSSNRegex)
        {   
            if(!String.isEmpty(emailObj.TextBody)) 
            {
                htmlBodyStr= emailObj.HtmlBody;
                emailObj.TextBody = maskValue(ssnRgx,emailObj.TextBody,' XXX-XX-XXXX ');    
                emailObj.HtmlBody = htmlBodyStr;
            }
            if(!String.isEmpty(emailObj.subject)) 
            {
                emailObj.subject = maskValue(ssnRgx,emailObj.subject,' XXX-XX-XXXX ');
            }
        }
        for(String ssnRgx : lstRoutingRegex)
        {   
            if(!String.isEmpty(emailObj.TextBody)) 
            {
                htmlBodyStr= emailObj.HtmlBody;
                emailObj.TextBody = maskValue(ssnRgx,emailObj.TextBody ,' XXXX-XXXX-X ');    
                emailObj.HtmlBody = htmlBodyStr;               
            }
            if(!String.isEmpty(emailObj.subject)) 
            {
                emailObj.subject = maskValue(ssnRgx,emailObj.subject,' XXXX-XXXX-X ');
            }
        }   
    }

    public static string maskValue(String ssnRgx,String inputString, String maskStr)
    {
        inputString =' '+inputString+' ';
        Pattern ssnPattern1 = Pattern.compile(ssnRgx);
        Matcher ssnMatcher1 = ssnPattern1.matcher(inputString);
        while(ssnMatcher1.find())
        {
            String matchedPattern = ssnMatcher1.group();
            matchedPattern=matchedPattern.remove('\n');
            matchedPattern=matchedPattern.remove('*');
            inputString = inputString.replace(matchedPattern,maskStr);            
            if(!String.isEmpty(htmlBodyStr))
            {  
                htmlBodyStr=htmlBodyStr.remove('<wbr>');
                htmlBodyStr = htmlBodyStr.replace(matchedPattern.trim(),maskStr);
            }
            ssnMatcher1 = ssnPattern1.matcher(inputString);
        }
        return inputString; 
    }    
}