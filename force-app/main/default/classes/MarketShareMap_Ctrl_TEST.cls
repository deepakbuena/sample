@ISTEST
public class MarketShareMap_Ctrl_TEST
{
    public static testmethod void run()
    {    id rTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        Account acc=new Account(recordtypeid=rTypeId,name='test',Contract_Start__c=system.today()-10,Contract_end__c=System.today()+10,BillingState='CT');
        insert acc;   
        
       Datetime myDatetime = Datetime.now().adddays(1);
       String myDatetimeStr = myDatetime.format('MM/dd/yyyy');
       
        MarketShareMap_Ctrl.generateMap(myDatetimeStr,'');
        
        PageReference pageRef = Page.MarketShareMapPDF;
Test.setCurrentPage(pageRef);
ApexPages.currentPage().getParameters().put('date',myDatetimeStr );


        
        MarketShareMap_Ctrl obj =new MarketShareMap_Ctrl();
        obj.GenerateMapPDF();
        
        
        obj.dateP=myDatetimeStr;
        obj.stateP='CT';
        obj.fullState='Connecticut';
        obj.generateTable();
        
    }


}