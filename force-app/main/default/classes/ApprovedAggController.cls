public with sharing class ApprovedAggController {

    public Annual_Sales_Plan__c asp { get; set; }
    public String showPCARelatedlist {get; set;}
    public String numberOfRowToRemove { get; set; }
    public List<PCAWrapper> listPCA {get; set;}
    public List<Annual_Sales_Plan_Items__c> pcaToBeDelList;

    public ApprovedAggController (ApexPages.StandardController sc) {
        if(sc != null && sc.getId() != null){
            asp = [Select Id,Name,(Select Id,Name,Annual_Sales_Plan__c,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,Approved_Aggregator_Name__r.Name,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,School_Name__c,Total_Enrollments__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r Where Approved_Aggregator_Name__c != null) From Annual_Sales_Plan__c Where Id =: sc.getId()];
            showPCARelatedlist = 'true';
            preparePCAList();
        }
    }
    public void addRows(){
        PCAWrapper wrapper = new PCAWrapper();
        wrapper.pca = new Annual_Sales_Plan_Items__c(Annual_Sales_Plan__c = asp.Id);
        listPCA.add(wrapper);
    }
    public void removeRows(){
        List<PCAWrapper> pcawTemp = new List<PCAWrapper>();
        for(PCAWrapper pcaw : listPCA){
            if(pcaw.pca.Id == numberOfRowToRemove){
               pcaToBeDelList.add(pcaw.pca); 
            }
            else {
                pcawTemp.add(pcaw);
            }
        }
        listPCA = new List<PCAWrapper>();
        listPCA = pcawTemp;
    }
    
    public void saveCurrentAgg() {
        try{
            List<Annual_Sales_Plan_Items__c> currentAggregatorsList = new List<Annual_Sales_Plan_Items__c>();
            
            for(PCAWrapper pcawTemp : listPCA) {                
                if(pcawTemp.pca.Id==null && pcawTemp.pca.Approved_Aggregator_Name__c != null){
                    currentAggregatorsList.add(pcawTemp.pca);   
                } else if(pcawTemp.pca.Id!=null){
                    currentAggregatorsList.add(pcawTemp.pca);    
                }
                 if(pcawTemp.pca.Approved_Aggregator_Name__c == null && (pcawTemp.pca.Total_Membership__c != null || pcawTemp.pca.of_Targets_in_Territory__c != null || pcawTemp.pca.Aggregators_Status_Update__c != null)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must enter Approved Aggregator Name'));
                    return;
                }
            }    
            upsert currentAggregatorsList;
            
            delete pcaToBeDelList;
            asp = [Select Id,Name,(Select Id,Name,Annual_Sales_Plan__c,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,Approved_Aggregator_Name__r.Name,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,School_Name__c,Total_Enrollments__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r where Approved_Aggregator_Name__c != null) From Annual_Sales_Plan__c Where Id =: ApexPages.currentPage().getParameters().get('id')];
            showPCARelatedlist = 'true';
            preparePCAList();
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public void preparePCAList(){
        pcaToBeDelList = new List<Annual_Sales_Plan_Items__c>();
        listPCA = new List<PCAWrapper>();
            
        for(Integer i = 1; i<=asp.Proposed_Conference_Attendance__r.size(); i++){
            PCAWrapper wrapper = new PCAWrapper();
            wrapper.pca = asp.Proposed_Conference_Attendance__r[i-1];
            listPCA.add(wrapper) ;
        }
        if(showPCARelatedlist!='true'){
            PCAWrapper wrapper = new PCAWrapper();
            wrapper.pca = new Annual_Sales_Plan_Items__c(Annual_Sales_Plan__c = asp.Id);
            listPCA.add(wrapper) ;   
        }
    }
    
    public class PCAWrapper{
        public Annual_Sales_Plan_Items__c pca {get; set;}
    }
}