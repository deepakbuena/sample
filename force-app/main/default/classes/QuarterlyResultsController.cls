public class QuarterlyResultsController{

    public List<FQWrapper> listFQWrapper {get; set;}
    Period p = [Select StartDate, EndDate From Period Where type = 'Year' and StartDate = THIS_FISCAL_YEAR];
    
    public QuarterlyResultsController(ApexPages.StandardController controller) {
        Annual_Sales_Plan__c asp = (Annual_Sales_Plan__c)controller.getRecord();
        asp = [SELECT ID,OwnerID,Start_Date__c,End_Date__c FROM Annual_Sales_Plan__c WHERE ID =:asp.id];
        List<Opportunity> opps = [Select Id,Name,Total_in_Enrollment__c,CloseDate,StageName,Fiscal_Year__c From Opportunity Where (StageName = 'Implementation' OR StageName = 'In Production' OR StageName = 'Verbal Committment' OR StageName = 'Closed - Won') AND CloseDate >=: asp.Start_Date__c AND CloseDate <=: asp.End_Date__c AND OwnerId =:asp.OwnerId];
        listFQWrapper = new List<FQWrapper>();
        
        for(Opportunity opp : opps){
            FQWrapper fqNew = new FQWrapper();
            fqNew.oppFQ = opp ;
            if(opp.CloseDate >= asp.Start_Date__c && opp.CloseDate <= asp.Start_Date__c.addMonths(3)){
                fqNew.fiscalQuarter = 'Q1';
            }
            if(opp.CloseDate >= asp.Start_Date__c.addMonths(3) && opp.CloseDate <= asp.Start_Date__c.addMonths(6)){
                fqNew.fiscalQuarter = 'Q2';
            }
            if(opp.CloseDate >= asp.Start_Date__c.addMonths(6) && opp.CloseDate <= asp.Start_Date__c.addMonths(9)){
                fqNew.fiscalQuarter = 'Q3';
            }
            if(opp.CloseDate >= asp.Start_Date__c.addMonths(9) && opp.CloseDate <= asp.Start_Date__c.addMonths(12)){
                fqNew.fiscalQuarter = 'Q4';
            }
            listFQWrapper.add(fqNew);
        }
    }
    
    public class FQWrapper{
        public Opportunity oppFQ {get;set;}
        public String fiscalQuarter {get;set;}      
    }
}