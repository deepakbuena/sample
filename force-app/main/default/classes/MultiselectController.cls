Public with sharing class MultiselectController {
    
    // SelectOption lists for public consumption
    public SelectOption[] leftOptions {get;set;}
    public SelectOption[] rightOptions {get;set;}
    public String accid {get;set;}
    public String accountid {get;set;}
    public String sObjType {get;set;}

    // Parse &-separated values and labels from value and 
    // put them in option
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i = 0; i < parts.size() / 2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i * 2], 'UTF-8'),
            EncodingUtil.urlDecode(parts[(i * 2) + 1], 'UTF-8')));
        }
    }

    // Backing for hidden text field containing the options from the left list
    public String leftOptionsHidden {
        get;
        set {
            leftOptionsHidden = value;
            setOptions(leftOptions, value);
        }
    }

    // Backing for hidden text field containing the options from the right list
    public String rightOptionsHidden {
        get;
        set {
            rightOptionsHidden = value;
            setOptions(rightOptions, value);
        }
    }

    public PageReference saveAccount() {
        List <SelectOption> options = new List <SelectOption> ();
        System.debug('rightOptionsHidden  is ' + rightOptionsHidden);
        String message='';
        String[] parts = rightOptionsHidden.split('&');
        for (Integer i = 0; i <parts.size() / 2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i * 2], 'UTF-8'),
            EncodingUtil.urlDecode(parts[(i * 2) + 1], 'UTF-8')));
        }

        List <Secondary_Risk_Lost_Reason__c> newRecordsList = new List <Secondary_Risk_Lost_Reason__c> ();
 
        Boolean first = true;
        String Primary;
        integer sortOrder = 0;
        for (SelectOption so: options) {
            sortOrder++;
            Secondary_Risk_Lost_Reason__c newRecord = new Secondary_Risk_Lost_Reason__c();
            newRecord.ParentId__c = accountid;
            newRecord.Name = so.getLabel();
            newRecord.Sort_Order__c = sortOrder;

            if (first == true) {
              //  message = so.getLabel();
                Primary = so.getLabel();
                first = false;
            } else {
                message = message + ';';
                message += so.getLabel();
            }


            newRecordsList.add(newRecord);

        }
        System.debug('message ' + message);
        System.debug('newRecordsList.size ' + newRecordsList.size());
        if (newRecordsList.size() >= 0) {
            // get existing records and delete them and insert new record
            List <Secondary_Risk_Lost_Reason__c> delRecordsList = new List <Secondary_Risk_Lost_Reason__c> ();
            delRecordsList = [select id from Secondary_Risk_Lost_Reason__c where parentId__C = : accountid];
            List <Account> accTemp = [select Primary_Risk_Lost_Reason__c,Secondary_Risk_Lost_Reason__c from account where id = : accountid];
            SavePoint sp = Database.setSavePoint();
            try {
                if (delRecordsList.size() > 0) delete delRecordsList;
                if (newRecordsList.size() > 0) {
                    accTemp[0].Primary_Risk_Lost_Reason__c = Primary;
                    accTemp[0].Secondary_Risk_Lost_Reason__c=message;
                    update accTemp;
                    insert newRecordsList;

                } else if (newRecordsList.size() == 0) {
                    accTemp[0].Primary_Risk_Lost_Reason__c = '';
                    accTemp[0].Secondary_Risk_Lost_Reason__c='';
                    update accTemp;

                }


            } catch (Exception e) {
                System.Debug('An exception has occured ' + e.getLineNumber() + ' ' + e.getMessage());
                Database.Rollback(sp);
            }

        }

        return null;


    }


    public PageReference saveCase() {
        List <SelectOption> options = new List <SelectOption> ();
        System.debug('rightOptionsHidden  is ' + rightOptionsHidden);
        String message='';
        Integer sortOrder = 0;
        String[] parts = rightOptionsHidden.split('&');
        for (Integer i = 0; i < parts.size() / 2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i * 2], 'UTF-8'),
            EncodingUtil.urlDecode(parts[(i * 2) + 1], 'UTF-8')));
        }

        List <Case_Barrier__c> newRecordsList = new List <Case_Barrier__c> ();
        Boolean first = true;
        String Primary;
        for (SelectOption so: options) {
            sortOrder++;
            Case_Barrier__c newRecord = new Case_Barrier__c();
            newRecord.Case__c = accountid;
            newRecord.Name = so.getLabel();
            newRecord.Sort_Order_No__c = sortOrder;

            if (first == true) {
              //  message = so.getLabel();
                Primary = so.getLabel();
                first = false;
            } else {
                message = message + ';';
                message += so.getLabel();
            }

            newRecordsList.add(newRecord);

        }
        System.debug('message ' + message);
        System.debug('newRecordsList.size ' + newRecordsList.size());
        if (newRecordsList.size() >= 0) {
            // get existing records and delete them and insert new record
            List <Case_Barrier__c> delRecordsList = new List <Case_Barrier__c> ();
            delRecordsList = [select id from Case_Barrier__c where case__C = : accountid];
            List <Case> caseTemp = [select Barrier__c from  case where id = : accountid];
            SavePoint sp = Database.setSavePoint();
            try {
                if (delRecordsList.size() > 0) delete delRecordsList;
                if (newRecordsList.size() > 0) {
                    caseTemp[0].Barrier__c = message;
                    caseTemp[0].Barrier_to_Implementation__c=Primary;
                    update caseTemp;
                    insert newRecordsList;

                } else if (newRecordsList.size() == 0) {
                    caseTemp[0].Barrier__c = '';
                    caseTemp[0].Barrier_to_Implementation__c='';
                    update caseTemp;

                }


            } catch (Exception e) {
                System.Debug('An exception has occured ' + e.getLineNumber() + ' ' + e.getMessage());
                Database.Rollback(sp);
            }

        }

        return null;
    }
}