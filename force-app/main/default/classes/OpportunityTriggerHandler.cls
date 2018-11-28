/**************************
Name : DevTeam
Changes : Set 'ByPassRolloverWFRules' field value on rollover opportunity true
Date : 9/22/2016
**************************/

public class OpportunityTriggerHandler{
    
    //public static boolean firstRun = true;
    public static boolean runOnce_createImpCase = false;
    public static boolean runOnce_rolloverOpportunity = false;

    //Class to create Case for Implementation
    public static void createImpCase(Set<Id> opptyKeySet) {
        
        //Instantiate a list of Cases to insert
        List<Case> caseList = new List<Case>();
        ID recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation Consumer Services').getRecordTypeId();
        
        //Query the entire list of updated Opportunities
        List<Opportunity> opptyList = [SELECT Name,
                                            RecordTypeId,
                                            StageName, 
                                            Renewal_Opp__c,
                                            Account.OwnerId,
                                            Account.Owner.isActive, 
                                            Account.Name, 
                                            (SELECT ContactId, Role FROM OpportunityContactRoles WHERE isPrimary = true LIMIT 1) 
                                    From Opportunity 
                                    WHERE Id IN :opptyKeySet];
        
        //Check Opportunities for criteria and create cases if it passes 
        for(Opportunity o : opptyList){
            
            //Record Type = Business Development AND Stage = Implementation BUT NOT Renewal = true OR OpportunityName contains renewal
            Case c = new Case();
            c.Subject = o.Account.Name + ' - Implementation';
            c.RecordTypeId = recTypeId; //Record Type: Implementation Consumer Services
            c.Origin = 'Email';
            c.Status = 'WIP';
            c.Type = 'Implementation';
            c.Opportunity_Link__c = URL.getSalesforceBaseUrl().toExternalForm().replace('http://','https://') + '/' + o.id;
            c.AccountId = o.AccountId;

            if(o.Account.Owner.isActive == true){
                //Change Owner
                c.OwnerId = o.Account.OwnerId;
            }
            if(o.OpportunityContactRoles.size() > 0){
                c.ContactId = o.OpportunityContactRoles[0].ContactId;
            }
            caseList.add(c);                
        }
        if(caseList.size()>0){
            Database.insert(caseList,false);
            runOnce_createImpCase = true;
        }
    }

    public static void rolloverOpportunity(List<Opportunity> opptyList){

        List<Opportunity> insertOppty = new List<Opportunity>();

        for(Opportunity oppty : opptyList){

            Date nextFYDate;
            String nextFYString;
            String[] listOfFY = new String[]{};

            listOfFY.add(System.today().addYears(-2).year().format().remove(','));
            listOfFY.add(System.today().addYears(-1).year().format().remove(','));
            listOfFY.add(System.today().year().format().remove(','));
            listOfFY.add(System.today().addYears(1).year().format().remove(','));
            listOfFY.add(System.today().addYears(2).year().format().remove(','));

            //Determine last day of the next fiscal year
            if(System.today() < Date.newInstance(System.today().year(),7,1)){
                //This FY
                nextFYDate = Date.newInstance(System.today().addYears(1).year(),6,30);
                nextFYString = System.today().addYears(1).year().format().remove(',');

            } else{
                //Next FY
                nextFYDate = Date.newInstance(System.today().addYears(2).year(),6,30);
                nextFYString = System.today().addYears(2).year().format().remove(',');
            }

            //Create new rollover Opportunity
            for(String year : listOfFY){

                if(oppty.Name.contains(year)){
                    oppty.Name = oppty.Name.replace(year,nextFYString);
                }
            }
            if(oppty.StageName == 'Closed - Lost'){
                oppty.StageName = 'Prospect';
                oppty.Primary_Loss_Reason__c = null;
                oppty.Loss__c = false;
            }
            oppty.CloseDate = nextFYDate;
            oppty.Rollover__c = false;
            oppty.Create_Rollover_Oppty__c = false;
            oppty.ByPassRolloverWFRules__c=True; 
            insertOppty.add(oppty);
        }

        insert insertOppty;
        runOnce_rolloverOpportunity = true;
    }
}