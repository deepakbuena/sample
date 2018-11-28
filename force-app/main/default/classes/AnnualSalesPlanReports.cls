public class AnnualSalesPlanReports{

    public String report1{get;set;}
    public String report2{get;set;}
    public String ownerName{get;set;}
    Period p2 = [Select StartDate, EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER];
    
    public String FQ1StartDate{get;set;}
    public String FQ1EndDate{get;set;}
    public String FQ2StartDate{get;set;}
    public String FQ2EndDate{get;set;}
    public String FQ3StartDate{get;set;}
    public String FQ3EndDate{get;set;}
    public String FQ4StartDate{get;set;}
    public String FQ4EndDate{get;set;}
    public Boolean currentQuarter1{get;set;}
    public Boolean currentQuarter2{get;set;}
    public Boolean currentQuarter3{get;set;}
    public Boolean currentQuarter4{get;set;}
    
    public AnnualSalesPlanReports(ApexPages.StandardController controller) {
        Annual_Sales_Plan__c asp = (Annual_Sales_Plan__c)controller.getRecord();
        asp = [SELECT ID,Owner.Name,Start_Date__c,End_Date__c FROM Annual_Sales_Plan__c WHERE ID =:asp.id];
        ownerName = asp.Owner.Name;
                
        FQ1StartDate = String.valueof(asp.Start_Date__c);
        FQ1EndDate = String.valueof(asp.Start_Date__c.addMonths(3).addDays(-1));
        FQ2StartDate = String.valueof(asp.Start_Date__c.addMonths(3));
        FQ2EndDate = String.valueof(asp.Start_Date__c.addMonths(6).addDays(-1));
        FQ3StartDate = String.valueof(asp.Start_Date__c.addMonths(6));
        FQ3EndDate = String.valueof(asp.Start_Date__c.addMonths(9).addDays(-1));
        FQ4StartDate = String.valueof(asp.Start_Date__c.addMonths(9));
        FQ4EndDate = String.valueof(asp.Start_Date__c.addMonths(12).addDays(-1));
        
        if(FQ1StartDate >= String.valueOf(p2.StartDate) && FQ1EndDate <= String.valueOf(p2.EndDate)){currentQuarter1 = true;}
        if(FQ2StartDate >= String.valueOf(p2.StartDate) && FQ2EndDate <= String.valueOf(p2.EndDate)){currentQuarter2 = true;}
        if(FQ3StartDate >= String.valueOf(p2.StartDate) && FQ3EndDate <= String.valueOf(p2.EndDate)){currentQuarter3 = true;}
        if(FQ4StartDate >= String.valueOf(p2.StartDate) && FQ4EndDate <= String.valueOf(p2.EndDate)){currentQuarter4 = true;}
        
        report1 = [Select Id From Report Where DeveloperName = 'Quarterly_Targeted_Visits'][0].Id;
        report2 = [Select Id From Report Where DeveloperName = 'Quarterly_Expected_vs_Received_Contracts'][0].Id;
    }
}