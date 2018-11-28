public with sharing class MultiselectPickListController {


    public SelectOption[] selectedRisks { get;set;}
    public SelectOption[] allRisks { get;set;}
    public String id;
    public String message { get;set;}
    public String PrimaryMessage { get;set;}
    public String outputMessage {
        get {
            IF(outputMessage.length()> 100) outputMessage = outputMessage.subString(0, 100) + '...';

            return outputMessage;
        }
        set;
    }
    public Boolean show { get;set;}
    public Boolean showLink{ get;set;}
    public Account acc { get;set;}

    public MultiselectPickListController() {
        outputMessage = '';
        Boolean fTime = false;
        String url = ApexPages.currentPage().getUrl();
        System.debug('url ' + url);
        id = Apexpages.currentPage().getParameters().get('id'); // Account Id

        if (id != null) {
            acc = [SELECT Id, Primary_Risk_Lost_Reason__c FROM Account where id = : id];

            selectedRisks = new List <SelectOption> ();

            List <String> risks = generateList([SELECT Name, id FROM SecondaryRisk__c]);

            List <String> riskByAccount = generateList([select name from Secondary_Risk_Lost_Reason__c where parentId__C = : id  order by sort_Order__C ASC ]);
            Map<Decimal,String> sortMap=new Map<Decimal,String>();
            
            for(Secondary_Risk_Lost_Reason__c sTemp :  [ select sort_Order__C, name from Secondary_Risk_Lost_Reason__c where parentId__C = : id  order by sort_Order__C ASC ])
            {
                    
            sortMap.put(sTemp.sort_Order__C,sTEmp.name);
            
            }
            
            System.debug('XXXXXXXXX '+sortMap);
            //create set to remove selected element
            Set <String> setRisks = new Set <String> ();
            setRisks.addAll(risks);

            Set <String> setRiskByAccount = new Set <String> ();
            setRiskByAccount.addAll(riskByAccount);

            setRisks.removeAll(setRiskByAccount);

            allRisks = new List <SelectOption> ();
            for (String c: setRisks) {
                allRisks.add(new SelectOption(c, c));
            }
/*
            for (String c: setRiskByAccount) {
                selectedRisks.add(new SelectOption(c, c));
            }
*/
/*
            for (Decimal c: sortMap.keyset()) {
             System.debug('XXXXXXX '+c);
                selectedRisks.add(new SelectOption(sortMap.get(c), sortMap.get(c)));
            }
            */
            
            list<decimal> ranksList = new list<decimal>();
            ranksList.addAll(sortMap.keySet());

            //now sort them
            ranksList.sort();
            
            system.debug('keys sorted '+ ranksList);
            
            for(Decimal dTemp : ranksList)
            {
                String sTemp=sortMap.get(dTemp);
               system.debug('keys sorted values '+ sTemp);
                selectedRisks.add(new SelectOption(sTemp, sTemp));
            
            }
            
            
            List <Secondary_Risk_Lost_Reason__c> tempList = [select id, name from Secondary_Risk_Lost_Reason__c where parentId__C = : id order by sort_Order__C ASC];
            for (Secondary_Risk_Lost_Reason__c scTemp: tempList) {
                if (fTime == false) {
                    outputMessage = scTemp.name;
                    fTime = true;
                    PrimaryMessage = scTemp.name;
                } else {
                    outputMessage += ';' + scTemp.name;
                }

            }

            if (outputMessage == '') {
                show = False;
                showLink = true;
                outputMessage = 'Select Secondary Reason';
            } else {
                show = true;
                showLink = False;
            }
        }
    }

    private List <String> generateList(List <sobject> sobj) {

        List <String> retStr = new List <String> ();

        for (sobject sTemp: sobj) {
            if (sTemp.getSObjectType() == Secondary_Risk_Lost_Reason__c.sObjectType) {
                sTemp = (Secondary_Risk_Lost_Reason__c) sTemp;
            } else if (sTemp.getSObjectType() == SecondaryRisk__c.sObjectType) {
                sTemp = (SecondaryRisk__c) sTemp;
            }

            retStr.add(String.valueOf(sTemp.get('Name')));
        }
        return retStr;


    }
}