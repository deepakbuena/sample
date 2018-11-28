public class FscYrResultsController{
    
    public List<RFP_Process__c> rfpList{get;set;}
    public FscYrResultsController(ApexPages.StandardController controller) {
        rfpList = new List<RFP_Process__c>();
        Annual_Sales_Plan__c asp = (Annual_Sales_Plan__c)controller.getRecord();
        asp = [SELECT ID,OwnerID,Start_Date__c,End_Date__c FROM Annual_Sales_Plan__c WHERE ID =:asp.id];
        List<RFP_Process__c> rfpListNew = [Select RFP_Account__c,RFP_Account__r.Name,RFP_Type__c,RFP_Due_Date__c,RFP_Status__c,RFP_Value__c,RFP_Received_Date__c From RFP_Process__c Where RFP_Account__r.Regional_Account_Executive__c =: asp.OwnerId];
        for(RFP_Process__c rftTemp : rfpListNew){
            if(rftTemp.RFP_Due_Date__c!=null){
                if(rftTemp.RFP_Due_Date__c >= asp.Start_Date__c && rftTemp.RFP_Due_Date__c <= asp.End_Date__c ){
                   rfpList.add(rftTemp);
                }
            }else if(rftTemp.RFP_Received_Date__c!=null){
                if(rftTemp.RFP_Received_Date__c >= asp.Start_Date__c && rftTemp.RFP_Received_Date__c <= asp.End_Date__c){
                    rfpList.add(rftTemp);
                }
            }else{
                rfpList.add(rftTemp);
            }
        }
    }
}