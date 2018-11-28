public class AccountRiskReasonsController {

    public SelectOption[] selectedRisks { get; set;}
    public SelectOption[] allRisks { get; set;}
    public String id;
    public String outputMessage {
        get {
            IF(outputMessage.length()> 100) outputMessage = outputMessage.subString(0, 100) + '...';

            return outputMessage;
        }
        set;
    }
    public Boolean show { get; set;}
    public Boolean showLink { get; set;}
    public String url { get; set;}

    public AccountRiskReasonsController(ApexPages.StandardController controller) {
        outputMessage = '';
        url = '/apex/MultiPickList?id=' + account.id;
        Boolean fTime = false;
        String url = ApexPages.currentPage().getUrl();
        System.debug('url ' + url);
        id = Apexpages.currentPage().getParameters().get('id'); // Account Id

        if (id != null) {
           

            selectedRisks = new List <SelectOption> ();

            List <String> risks = generateList([SELECT Name, id FROM SecondaryRisk__c]);
            List <String> riskByAccount = generateList([select name from Secondary_Risk_Lost_Reason__c where parentId__C = : id order by sort_Order__C ASC ]);


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
           
            for (String c: setRiskByAccount) {
                selectedRisks.add(new SelectOption(c, c));
            }
           
            
            List <Secondary_Risk_Lost_Reason__c> tempList = [select id, name from Secondary_Risk_Lost_Reason__c where parentId__C = : id order by sort_Order__C ASC];
            for (Secondary_Risk_Lost_Reason__c scTemp: tempList) {
                if (fTime == false) {
                    outputMessage = scTemp.name;
                    fTime = true;
                } else {
                    outputMessage += ';' + scTemp.name;
                }

            }
            System.debug('outputMessage is ' + outputMessage);
            System.debug('outputMessage is ' + outputMessage.length());
            if (outputMessage.length() == 0) {
                show = False;
                showLink = true;
                outputMessage = 'Select Risk Reasons';
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