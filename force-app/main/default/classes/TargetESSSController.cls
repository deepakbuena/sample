public with sharing class TargetESSSController {

    public Annual_Sales_Plan__c asp { get; set; }
    public String showPCARelatedlist {get; set;}
    public String numberOfRowToRemove { get; set; }
    public List<PCAWrapper> listPCA {get; set;}
    public String selAccId{get;set;}
    public String selIndex{get;set;}
    public List<Annual_Sales_Plan_Items__c> pcaToBeDelList;
    Date startDate;
    Date endDate;

    public TargetESSSController(ApexPages.StandardController sc) {
        if(sc != null && sc.getId() != null){
            asp = [Select Id,Name,Start_Date__c,End_Date__c,(Select Id,Name,Opportunity__c,Opportunity__r.Name,Opportunity__r.StageName,Annual_Sales_Plan__c,CreatedDate,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,School_Name__c,School_Name__r.Name,Total_Enrollments__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r Where School_Name__c != null AND Target_Record__c = 'Target ESSS Schools') From Annual_Sales_Plan__c Where Id =: sc.getId()];
            startDate = asp.Start_Date__c;
            endDate = asp.End_Date__c;
            showPCARelatedlist = 'true';
            preparePCAList();
        }
    }
    public void addRows(){
        PCAWrapper wrapper = new PCAWrapper();
        wrapper.pca = new Annual_Sales_Plan_Items__c(Annual_Sales_Plan__c = asp.Id);
        wrapper.index = listPCA.size();
        wrapper.oppList = new List<SelectOption>();
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
    
    public void saveTargetESSS() {
        try{
            List<Annual_Sales_Plan_Items__c> targetESSSList = new List<Annual_Sales_Plan_Items__c>(); 
            
            for(PCAWrapper pcawTemp : listPCA) {
                if(pcawTemp.pca.Id==null && pcawTemp.pca.School_Name__c != null){
                    pcawTemp.pca.Target_Record__c = 'Target ESSS Schools';
                    pcawTemp.pca.Opportunity__c = pcawTemp.selOppId;
                    targetESSSList.add(pcawTemp.pca);   
                } else if(pcawTemp.pca.Id!=null){
                    pcawTemp.pca.Opportunity__c = pcawTemp.selOppId;
                    targetESSSList.add(pcawTemp.pca);
                }
               
            }    
            upsert targetESSSList;
            
            delete pcaToBeDelList;
            asp = [Select Id,Name,(Select Id,Name,Opportunity__c,Opportunity__r.Name,Opportunity__r.StageName,Annual_Sales_Plan__c,CreatedDate,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,School_Name__c,School_Name__r.Name,Total_Enrollments__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r where School_Name__c != null AND Target_Record__c = 'Target ESSS Schools') From Annual_Sales_Plan__c Where Id =: ApexPages.currentPage().getParameters().get('id')];
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
        
        Set<Id> accAspIds = new Set<Id>();
        for(Annual_Sales_Plan_Items__c a : asp.Proposed_Conference_Attendance__r){
            accAspIds.add(a.School_Name__c);
        }
        
        Map<Id,List<Opportunity>> accOppMap = new Map<Id,List<Opportunity>>();
        List<Opportunity> oppList = [Select Id,Name,AccountId From Opportunity Where AccountId IN :accAspIds AND CloseDate >=: startDate AND CloseDate <=: endDate];
        for(Opportunity o : oppList){
            if(!accOppMap.containsKey(o.AccountId)){accOppMap.put(o.AccountId,new List<Opportunity>());}
            accOppMap.get(o.AccountId).add(o);
        }
        
        Integer count = 0;    
        for(Integer i = 1; i<=asp.Proposed_Conference_Attendance__r.size(); i++){
            PCAWrapper wrapper = new PCAWrapper();
            wrapper.pca = asp.Proposed_Conference_Attendance__r[i-1];
            wrapper.index = count;
            wrapper.oppList = new List<SelectOption>();
            wrapper.oppList.add(new SelectOption ('','--None--'));
            
            if(accOppMap.containsKey(wrapper.pca.School_Name__c)){
                for(Opportunity opp : accOppMap.get(wrapper.pca.School_Name__c)){
                    wrapper.oppList.add(new SelectOption (opp.Id,opp.Name));
                }
            }
            wrapper.selOppId = wrapper.pca.Opportunity__c;
            listPCA.add(wrapper) ;
            count++;
        }
        if(showPCARelatedlist!='true'){
            PCAWrapper wrapper = new PCAWrapper();
            wrapper.pca = new Annual_Sales_Plan_Items__c(Annual_Sales_Plan__c = asp.Id);
            wrapper.index = count;
            wrapper.oppList = new List<SelectOption>();
            listPCA.add(wrapper) ; 
            count++;  
        }
        for(PCAWrapper fqNew : listPCA){
            if(fqNew.pca.CreatedDate >= startDate && fqNew.pca.CreatedDate <= startDate.addMonths(3)){
                fqNew.fiscalQuarter = 'Q1';
            }
            if(fqNew.pca.CreatedDate >= startDate.addMonths(3) && fqNew.pca.CreatedDate <= startDate.addMonths(6)){
                fqNew.fiscalQuarter = 'Q2';
            }
            if(fqNew.pca.CreatedDate >= startDate.addMonths(6) && fqNew.pca.CreatedDate <= startDate.addMonths(9)){fqNew.fiscalQuarter = 'Q3';}
            if(fqNew.pca.CreatedDate >= startDate.addMonths(9) && fqNew.pca.CreatedDate <= startDate.addMonths(12)){fqNew.fiscalQuarter = 'Q4';}
        }
    }
    
    public void retrieveOpps(){
        List<Opportunity> oppLst = [Select Id,Name From Opportunity Where AccountId = :selAccId AND CloseDate >=: startDate AND CloseDate <=: endDate Order By Name ASC];
        for(PCAWrapper w : listPCA){
            if(Integer.valueOf(selIndex) == w.index){
                w.oppList = new List<SelectOption>();
                w.oppList.add(new SelectOption ('','--None--'));
                for(Opportunity o : oppLst){
                    w.oppList.add(new SelectOption(o.Id,o.Name));
                }
            }
        }
    }
    
    public class PCAWrapper{
        public Annual_Sales_Plan_Items__c pca {get; set;}
        public String fiscalQuarter {get;set;}
        public String selOppId {get;set;}
        public List<SelectOption> oppList{get;set;}
        public Integer index {get;set;}
    }
}