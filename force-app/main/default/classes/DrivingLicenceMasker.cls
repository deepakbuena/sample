public class DrivingLicenceMasker{
    
    static String HtmlBodyStr;
    
    public static EmailMessage maskBody(emailMessage message,List<Driving_License_Regex_for_State__mdt> lstMetaData)
    {
        HtmlBodyStr = String.isNotBlank(message.htmlBody) ? message.htmlBody : Null;
        
        String planMaskedStr = maskDL(message.TextBody,lstMetaData); 
        message.TextBody =  planMaskedStr;
        if(String.isNotBlank(HtmlBodyStr)) 
        message.htmlBody =  HtmlBodyStr; 
        return message;     
    }    
    public static String maskDL(String inputStr, List<Driving_License_Regex_for_State__mdt> lstMetaData){        
        
        //set to store the driving licence keywords from custom labels
        Set<String> setDLKeyword = new Set<String>();
        setDLKeyword.addAll(Label.Masking_DL_Keywords1.split(';'));
        setDLKeyword.addAll(Label.Masking_DL_Keywords2.split(';'));
        Set<String> setDLKeywordAbbre = new Set<String>();
        inputStr=' '+inputStr+' ';
        for(String keyWordStr : Label.Masking_DL_Keywords_Abbre.split(';'))
        {
            setDLKeywordAbbre.add(keyWordStr);
        }           
        //set to store the driving licence keywords abbrevations from custom label
        Map<String,Set<String>>   patternToStateMap = new Map<String,Set<String>>();
        Map<String,Driving_License_Regex_for_State__mdt>  StateNameWithData = new Map<String,Driving_License_Regex_for_State__mdt>();    
        Map<String,Set<Integer>> patternIndexMap = new Map<String,Set<Integer>>();
        Map<String,Set<Integer>> patternIndexMap2 = new Map<String,Set<Integer>>();
        Map<String,Set<String>> patternStateIndexMap = new Map<String,Set<String>>();
        Map<String,String> falsePositiveState = new Map<String,String>();       
        
        for(Driving_License_Regex_for_State__mdt objDdata : lstMetaData)
        {
            StateNameWithData.put(objDdata.State_Name__c,objDdata);
            for(String patternsStr : objDdata.Regex_for_DL_Masking__c.split(';'))
            {
                if(!patternToStateMap.containsKey(patternsStr))
                {                    
                    patternToStateMap.put(patternsStr,new Set<String>());
                }
                patternToStateMap.get(patternsStr).add(objDdata.State_Name__c);
            }            
        }
        
        //Debug.....
        System.debug('StateNameWithData>>>>>>>>>>'+StateNameWithData);
        System.debug('patternToStateMap>>>>>>>>>>'+patternToStateMap);
        
        // loop to find pattern in input String and get Index of it... 
        for(String patternStr : patternToStateMap.keySet())
        {
            Pattern varPattern = Pattern.compile(patternStr);
            Matcher varMatcher = varPattern.matcher(inputStr);
            Boolean isMatchFound = varMatcher.find();          
            while(isMatchFound)
            {
                if(!patternIndexMap.containsKey(patternStr))
                patternIndexMap.put(patternStr,new Set<integer>());
                patternIndexMap.get(patternStr).add(varMatcher.Start());
                isMatchFound = varMatcher.find();
            }
        }
        
        //Debug
        System.debug('patternIndexMap>>>>>>>>>>'+patternIndexMap);
        
        //if(!patternIndexMap.isEmpty()) // loop to find State within spacified range.
        for(String patternFistMatch : patternIndexMap.keySet())
        {
            for(integer indexValue : patternIndexMap.get(patternFistMatch))
            {       
                String matchedSring = inputStringBondryCheck(inputStr,indexValue,9,60); // this can we move to first loop....
                for(String stateName : patternToStateMap.get(patternFistMatch))
                {
                    Driving_License_Regex_for_State__mdt objDLMetaData = StateNameWithData.get(stateName);
                    if(objDLMetaData.High_False_Positive_Rate__c == 'Yes'){
                        falsePositiveState.put(patternFistMatch,stateName);
                    }
                    if(matchedSring.toLowerCase().contains(statename.toLowerCase()))
                    {
                        if(!patternStateIndexMap.containsKey(patternFistMatch))
                        {                            
                            patternStateIndexMap.put(patternFistMatch,new Set<String>());
                        }
                        patternStateIndexMap.get(patternFistMatch).add(statename);
                    }
                    else if(objDLMetaData.State_Abbreviation_Regex__c != null && objDLMetaData.State_Abbreviation_Regex__c != '')
                    {
                        Pattern myPattern = Pattern.compile(objDLMetaData.State_Abbreviation_Regex__c);
                        Matcher myMatcher = myPattern.matcher(matchedSring);
                        while(myMatcher.find()){
                            if(!patternStateIndexMap.containsKey(patternFistMatch))
                            {
                                patternStateIndexMap.put(patternFistMatch,new Set<String>());
                            }
                            patternStateIndexMap.get(patternFistMatch).add(objDLMetaData.State_Abbreviation__c);
                        }
                    }
                }
            }               
        }
        
        //Debug
        System.debug('patternStateIndexMap>>>>>>>>>>'+patternStateIndexMap);
        System.debug('falsePositiveState>>>>>>>>>>'+falsePositiveState);        
            
        // itrating all the values of matching keyword within specify String boundry.....
        if(!patternStateIndexMap.isEmpty())
        {
            for(String patternMatched : patternStateIndexMap.keySet())
            {       
                integer maxlegnth=60;
                if(falsePositiveState.ContainsKey(patternMatched)) maxlegnth=20;
                for(integer indexValue : patternIndexMap.get(patternMatched))
                {
                    String matchedSring = inputStringBondryCheck(inputStr,indexValue,9,maxlegnth); // this can we move to first loop....
                    string tempString= matchedSring;
                    for(String strKeyword : setDLKeyword)
                    {
                        if(matchedSring.toLowerCase().contains(strKeyword.toLowerCase()))
                        {
                            Pattern dlPattern = Pattern.compile(patternMatched);
                            Matcher dlMatcher = dlPattern.matcher(tempString);                      
                            while(dlMatcher.find()){
                                String maskStr  = dlMatcher.group();
                                String replacestr = ' XXXXXXX ';
                                String replacestr1 = 'XXXXXXX';
                                if(maskStr.endsWith('\n'))
                                {
                                    maskStr = maskStr.subString(0,maskStr.length()-1)+'<';
                                    replacestr1 =replacestr1+'\n';
                                }
                                else  replacestr1 =replacestr1+' ';
                                if(maskStr.startsWith('\n'))
                                {
                                    maskStr = '>'+maskStr.subString(1,maskStr.length()); 
                                    replacestr1 ='\n'+replacestr1; 
                                }
                                else  replacestr1 =' '+replacestr1;
                                replacestr = maskStr.contains('>') ? '>'+replacestr: replacestr;
                                replacestr = maskStr.contains('<') ? replacestr+'<': replacestr;
                                if(String.isNotBlank(HtmlBodyStr) && HtmlBodyStr.contains(maskStr)) HtmlBodyStr =HtmlBodyStr .replaceAll(maskStr,replacestr);                                
                                tempString = tempString.replaceFirst(patternMatched,replacestr1);
                                dlMatcher = dlPattern.matcher(tempString);                                
                            }
                            inputStr = inputStr.replaceAll(matchedSring,tempString);
                        }
                    }
                    for(String keywordRgx : setDLKeywordAbbre)
                    {
                        Pattern myPattern = Pattern.compile(keywordRgx);
                        Matcher myMatcher = myPattern.matcher(matchedSring);
                        while(myMatcher.find())
                        {
                            Pattern dlPattern = Pattern.compile(patternMatched);
                            Matcher dlMatcher = dlPattern.matcher(tempString);                      
                            while(dlMatcher.find()){
                                String maskStr  = dlMatcher.group();
                                String replacestr = ' XXXXXXX ';
                                String replacestr1 = 'XXXXXXX';
                                if(maskStr.endsWith('\n'))
                                {
                                    maskStr = maskStr.subString(0,maskStr.length()-1)+'<';
                                    replacestr1 =replacestr1+'\n';
                                }
                                else  replacestr1 =replacestr1+' ';
                                if(maskStr.startsWith('\n'))
                                {
                                    maskStr = '>'+maskStr.subString(1,maskStr.length()); 
                                    replacestr1 ='\n'+replacestr1; 
                                }
                                else  replacestr1 =' '+replacestr1;  
                                replacestr = maskStr.contains('>') ? '>'+replacestr: replacestr;
                                replacestr = maskStr.contains('<') ? replacestr +'<': replacestr;
                                if(String.isNotBlank(HtmlBodyStr) && HtmlBodyStr.contains(maskStr.trim())) 
                                HtmlBodyStr =HtmlBodyStr.replaceAll(maskStr.trim(),replacestr);
                                tempString = tempString.replaceFirst(patternMatched,' XXXXXXXXX ');
                                dlMatcher = dlPattern.matcher(tempString);                                
                            }
                            inputStr = inputStr.replaceAll(matchedSring,tempString);
                        }
                    }
                }
            }
        }
        return inputStr;
    }
    
    //method to check the lenght of the input text to set the index accordingly
    public static String inputStringBondryCheck(String inputStr,Integer indexValue,Integer keywordLength, Integer maxlegnth){       
        String subStringToMaskDL;
        if((indexValue-maxlegnth>=0) && (inputStr.length() >= indexValue+keywordLength+maxlegnth)){
            Integer leftTempStr  = inputStr.subString(indexValue-maxlegnth,indexValue).countMatches(' ');
            Integer rightTempStr = inputStr.subString(indexValue,indexValue+keywordLength+maxlegnth).countMatches(' ');
            Integer leftIndex    = indexValue-maxlegnth-leftTempStr >=0 ? indexValue-maxlegnth-leftTempStr : 0;
            Integer rightIndex   = indexValue+keywordLength+maxlegnth+rightTempStr < inputStr.length() ? indexValue+keywordLength+maxlegnth+rightTempStr : inputStr.length();
            subStringToMaskDL    = inputStr.subString(leftIndex,rightIndex);
        }
        else if(!(indexValue-maxlegnth>=0) && (inputStr.length() >= indexValue+keywordLength+maxlegnth)){
            String tempstr = inputStr.subString(indexValue,indexValue+keywordLength+maxlegnth);
            Integer i=tempstr.countMatches(' ');
            if(inputStr.length() >= indexValue+keywordLength+maxlegnth+i)maxlegnth = maxlegnth+i;
            subStringToMaskDL = inputStr.subString(0,indexValue+keywordLength+maxlegnth);
        }
        else if((indexValue-maxlegnth>=0) && !(inputStr.length() >= indexValue+keywordLength+maxlegnth)){
            Integer leftTempStr  = inputStr.subString(indexValue-maxlegnth,indexValue).countMatches(' ');
            Integer leftIndex    = indexValue-maxlegnth-leftTempStr >=0 ? indexValue-maxlegnth-leftTempStr : 0;
            subStringToMaskDL = inputStr.subString(leftIndex,inputStr.length());
        }
        else {
            subStringToMaskDL = inputStr;
        }
        return subStringToMaskDL;
    }    
}