public with sharing class ProposedConferenceAttendanceController {

    public Annual_Sales_Plan__c asp { get; set; }
    public String showPCARelatedlist {get; set;}
    public String numberOfRowToRemove { get; set; }
    public List<PCAWrapper> listPCA {get; set;}
    public List<Annual_Sales_Plan_Items__c> pcaToBeDelList;

    public proposedConferenceAttendanceController (ApexPages.StandardController sc) {
        if(sc != null && sc.getId() != null){
            asp = [Select Id,Name,Owner.Name,(Select Id,Name,Annual_Sales_Plan__c,Conference_Name_Presentation_Proposed__c,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,Proposed__c,Presenting__c,Conference_Name_Presentation_Proposed__r.StartDate,Conference_Name_Presentation_Proposed__r.Name,Conference_Name_Presentation_Proposed__r.Location__c,Conference_Name_Presentation_Proposed__r.EndDate,Conference_Name_Presentation_Proposed__r.BDAttending__c,Conference_Name_Presentation_Proposed__r.Presenting__c,Audience__c,School_Name__c,Total_Enrollments__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r Where PCA_Record__c = true AND Conference_Name_Presentation_Proposed__c != null Order By Name) From Annual_Sales_Plan__c Where Id =: sc.getId()];
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
    public void savePCA() {
        try{
            List<Annual_Sales_Plan_Items__c> insertProposedConferenceList = new List<Annual_Sales_Plan_Items__c>();
            String campId;
            List<Campaign> campList = [Select Id,BDAttending__c,Presenting__c From Campaign Where RecordType.Name = 'Conference' AND isActive = true];
            Map<Id,Campaign> campMap = new Map<Id,Campaign>();
            
            for(Campaign campTemp : campList){
                campMap.put(campTemp.Id,campTemp);    
            }
            
            for(PCAWrapper pcawTemp : listPCA) {
                campId = pcawTemp.pca.Conference_Name_Presentation_Proposed__c;
                if((pcawTemp.pca.Id==null && pcawTemp.pca.Conference_Name_Presentation_Proposed__c !=null)){
                    pcawTemp.pca.PCA_Record__c = true;
                    Boolean checkBDAttending = false;
                    Boolean checkPresenting = false;
                    List<String> bDAttendingList;
                    List<String> presentingList;
                    
                    if(campMap.get(campId).BDAttending__c != null && campMap.get(campId).BDAttending__c.contains(';')){
                        BDAttendingList = campMap.get(campId).BDAttending__c.split(';');
                        for(String s : bDAttendingList){
                            if(s==asp.Owner.Name)
                                checkBDAttending = true;
                        }
                    }else if(campMap.get(campId).BDAttending__c != null && campMap.get(campId).BDAttending__c == asp.Owner.Name){
                        checkBDAttending = true;
                    }
                    if(campMap.get(campId).Presenting__c != null && campMap.get(campId).Presenting__c.contains(';')){
                        PresentingList = campMap.get(campId).Presenting__c.split(';');
                        for(String s : presentingList){
                            if(s==asp.Owner.Name)
                                checkPresenting = true;
                        }
                    }else if(campMap.get(campId).Presenting__c != null && campMap.get(campId).Presenting__c == asp.Owner.Name){
                        checkPresenting = true;
                    }
                    
                    if(campMap.containsKey(campId)){
                        if(checkBDAttending){
                            pcawTemp.pca.Attending__c = true;
                            pcawTemp.pca.Proposed__c = false;
                        } 
                        else{
                            pcawTemp.pca.Proposed__c = true;
                            pcawTemp.pca.Attending__c = false;
                        }
                        if(checkPresenting){pcawTemp.pca.Presenting__c = true;}
                        else{pcawTemp.pca.Presenting__c = false;}
                    }
                    
                    insertProposedConferenceList.add(pcawTemp.pca);
                } else if(pcawTemp.pca.Id!=null){
                    insertProposedConferenceList.add(pcawTemp.pca);    
                }
            }
             
            upsert insertProposedConferenceList;
                        
            delete pcaToBeDelList;
            asp = [Select Id,Name,Owner.Name,(Select Id,Name,Annual_Sales_Plan__c,Conference_Name_Presentation_Proposed__r.Name,Conference_Name_Presentation_Proposed__c,Target_Aggregator_Name__c,Approved_Aggregator_Name__c,of_Targets_in_Territory__c,Aggregators_Status_Update__c,Total_Membership__c,Attending__c,Proposed__c,Presenting__c,Conference_Name_Presentation_Proposed__r.StartDate,Conference_Name_Presentation_Proposed__r.Location__c,School_Name__c,Conference_Name_Presentation_Proposed__r.EndDate,Audience__c,Total_Enrollments__c,Conference_Name_Presentation_Proposed__r.BDAttending__c,Conference_Name_Presentation_Proposed__r.Presenting__c,Target_ESSS_Status_Update__c From Proposed_Conference_Attendance__r Where PCA_Record__c = true AND Conference_Name_Presentation_Proposed__c != null) From Annual_Sales_Plan__c Where Id =: ApexPages.currentPage().getParameters().get('id')];
            showPCARelatedlist = 'true';
            preparePCAList();
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public void preparePCAList(){
        try{
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
            
            List<Annual_Sales_Plan_Items__c> insertProposedConferenceList = new List<Annual_Sales_Plan_Items__c>();
            String campId;
            List<Campaign> campList = [Select Id,BDAttending__c,Presenting__c From Campaign Where RecordType.Name = 'Conference' AND isActive = true];
            Map<Id,Campaign> campMap = new Map<Id,Campaign>();
            
            for(Campaign campTemp : campList){
                campMap.put(campTemp.Id,campTemp);    
            }
            
            for(PCAWrapper pcawTemp : listPCA) {
                if(pcawTemp.pca.Conference_Name_Presentation_Proposed__c != null){campId = pcawTemp.pca.Conference_Name_Presentation_Proposed__c;}
                Boolean checkBDAttending = false;
                Boolean checkPresenting = false;
                List<String> bDAttendingList;
                List<String> presentingList;
                
                if(campMap.get(campId).BDAttending__c != null && campMap.get(campId).BDAttending__c.contains(';')){
                    BDAttendingList = campMap.get(campId).BDAttending__c.split(';');
                    for(String s : bDAttendingList){
                        if(s==asp.Owner.Name){
                            checkBDAttending = true;
                        }    
                    }
                }else if(campMap.get(campId).BDAttending__c != null && campMap.get(campId).BDAttending__c == asp.Owner.Name){
                    checkBDAttending = true;
                }
                if(campMap.get(campId).Presenting__c != null && campMap.get(campId).Presenting__c.contains(';')){
                    PresentingList = campMap.get(campId).Presenting__c.split(';');
                    for(String s : presentingList){
                        if(s==asp.Owner.Name)
                            checkPresenting = true;
                    }
                }else if(campMap.get(campId).Presenting__c != null && campMap.get(campId).Presenting__c == asp.Owner.Name){
                    checkPresenting = true;
                }
                
                if(campMap.containsKey(campId)){
                    if(checkBDAttending){
                        pcawTemp.pca.Attending__c = true;
                        pcawTemp.pca.Proposed__c = false;
                    } 
                    else{
                        pcawTemp.pca.Proposed__c = true;
                        pcawTemp.pca.Attending__c = false;
                    }
                    if(checkPresenting){pcawTemp.pca.Presenting__c = true;}
                    else{pcawTemp.pca.Presenting__c = false;}
                }
            }
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public class PCAWrapper{
        public Annual_Sales_Plan_Items__c pca {get; set;}
    }
}