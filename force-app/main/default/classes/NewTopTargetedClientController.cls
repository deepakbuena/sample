/*
@Name                : NewTopTargetedClientController 
@Author              : GS Dev Team
@Date                : January 8, 2016
@Description         : Controller class for NewTopTargetedClient Page to enter at least three unique accounts when entering first time but more accounts can also be added later
*/

public with sharing class NewTopTargetedClientController {

    //variables
    public Mutually_Agreed_to_Objectives__c m2o { get; set; }
    public List<TopTargetedWrapper> listTopTargeted {get; set;}
    public String numberOfRowToRemove { get; set; }
    public String showTtcRelatedlist {get; set;}
    public List<Top_Targeted_School__c> tccToBeDelList;

    public NewTopTargetedClientController (ApexPages.StandardController sc) {
        if(sc != null && sc.getId() != null){
            m2o = [Select Id,Name,(Select Id,Name,Mutually_Agreed_to_Objectives__c,Account__c,Account__r.Name,Substantive_Visits__c From Visits__r) From Mutually_Agreed_to_Objectives__c Where Id =: sc.getId()];
            showTtcRelatedlist = 'true';
            prepareTopTargetList();
        }
    }
    
    public void addRows(){
        if(listTopTargeted.size()<=4){
            TopTargetedWrapper wrapper = new TopTargetedWrapper();
            wrapper.index = String.valueOf(listTopTargeted.size()+1);
            wrapper.tts = new Top_Targeted_School__c(Mutually_Agreed_to_Objectives__c = m2o.Id);
            listTopTargeted.add(wrapper);
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, but you can add maximum 5 records only.'));
        }
    }
    
    public void removeRows(){
        List<TopTargetedWrapper> ttwTemp = new List<TopTargetedWrapper>();
        for(TopTargetedWrapper ttw : listTopTargeted){
            if(ttw.tts.Id == numberOfRowToRemove){
               tccToBeDelList.add(ttw.tts); 
            }
            else{
                ttwTemp.add(ttw);
            }
        }
        listTopTargeted = new List<TopTargetedWrapper>();
        listTopTargeted = ttwTemp;
    }
    
     public void saveTargetClient() {
        try{
            List<Top_Targeted_School__c> insertTopTargetedList = new List<Top_Targeted_School__c>();
            
            Boolean uniqueAccValues = true;
            for(TopTargetedWrapper ttwTemp : listTopTargeted) {
                if(ttwTemp.tts.Account__c!=null){
                   for(TopTargetedWrapper ttwTemp2 : listTopTargeted) {
                        if(ttwTemp2.tts.Account__c!=null && ttwTemp.tts.Account__c == ttwTemp2.tts.Account__c && ttwTemp.index!=ttwTemp2.index){
                            uniqueAccValues = false;
                        }
                    } 
                }
            }
            if(uniqueAccValues == false){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account field values must be unique'));
                return;
            }
            for(TopTargetedWrapper ttwTemp : listTopTargeted) {
                if(ttwTemp.tts.Account__c!=null && ttwTemp.tts.Id==null){
                    insertTopTargetedList.add(ttwTemp.tts);
                }
            }    
            insert insertTopTargetedList;
            delete tccToBeDelList;
            m2o = [Select Id,Name,(Select Id,Name,Mutually_Agreed_to_Objectives__c,Account__c,Account__r.Name,Substantive_Visits__c From Visits__r) From Mutually_Agreed_to_Objectives__c Where Id =: ApexPAges.currentPage().getParameters().get('id')];
            showTtcRelatedlist = 'true';
            prepareTopTargetList();
        }
        catch(Exception e){
            System.debug('An exception has occurred: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }
    
    public void prepareTopTargetList(){
        tccToBeDelList = new List<Top_Targeted_School__c>();
        listTopTargeted = new List<TopTargetedWrapper>();
        
        if(m2o.visits__r.size()>=3){
            for(Integer i = 1; i<=m2o.visits__r.size(); i++){
                TopTargetedWrapper wrapper = new TopTargetedWrapper();
                wrapper.index = String.valueOf(i);
                wrapper.tts = m2o.visits__r[i-1];
                listTopTargeted.add(wrapper) ;
            }
            if(showTtcRelatedlist!='true' && listTopTargeted.size()<=4){
                TopTargetedWrapper wrapper = new TopTargetedWrapper();
                wrapper.index = String.valueOf(listTopTargeted.size()+1);
                wrapper.tts = new Top_Targeted_School__c(Mutually_Agreed_to_Objectives__c = m2o.Id);
                listTopTargeted.add(wrapper) ;   
            }  
        }
        else{
            if(showTtcRelatedlist!='true'){
                for(Integer i = 1; i<=3; i++){
                    TopTargetedWrapper wrapper = new TopTargetedWrapper();
                    wrapper.index = String.valueOf(i);
                    wrapper.tts = new Top_Targeted_School__c(Mutually_Agreed_to_Objectives__c = m2o.Id);
                    listTopTargeted.add(wrapper) ;
                }
            }
        }    
    }
    
    public class TopTargetedWrapper{
        public Top_Targeted_School__c tts {get; set;}
        public String index{ get; set; }
    }
}