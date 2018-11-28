public class AnnualSalesPlanNewButton{

    public Annual_Sales_Plan__c asp;
    Period p = [Select StartDate, EndDate From Period Where type = 'Year' and StartDate = THIS_FISCAL_YEAR];
    String fiscalYear = String.valueOf(p.EndDate);
    List<String> fYear = fiscalYear.split('-');
    String fY = fYear[0];
    String userFName = UserInfo.getFirstName();
    String userLName = UserInfo.getLastName();
    String fInitial = userFName.subString(0,1);
    Date startDate = p.StartDate;
    Date endDate = p.EndDate;
    
        
    public AnnualSalesPlanNewButton(ApexPages.StandardController controller) {
        asp = new Annual_Sales_Plan__c();
        asp.Name = 'BusDev Plan FY' + fY + ' ' + fInitial + userLName;
        asp.Start_Date__c = startDate;
        asp.End_Date__c = endDate;
    }
    
    public PageReference init(){
        try{
            insert asp;
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
        PageReference pr =  new PageReference('/' + asp.id); 
        return pr.setRedirect(true);
    }
}