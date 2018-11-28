public class OnboardingFormEditcls {

    public Onboarding_Form__c oObject{get;set;}
    public OnboardingFormEditcls (ApexPages.StandardController stdController){
        this.oObject= (Onboarding_Form__c )stdController.getrecord();
        for(Account acc : [SELECT Id,Name,Type,Recordtype.Name FROM Account WHERE Id =: oObject.School_Name__c and Recordtype.Name = 'School']){
           oObject.Name = acc.Name + ' '+'Onboarding' +' ' + date.today().month() + '-'+ date.today().Year();
           oObject.Type__c  = acc.Type;
        }
   }
   
   public PageReference saveOff(){
       
       try{
            if(oObject != null){
            insert oObject;
            }
          }
       catch(system.dmlException e) 
          {
            Apexpages.AddMessages(e);
            return null;
          }
        PageReference page = new Pagereference('/'+oObject.Id);
        page.setRedirect(true);
        return page;
   }
}