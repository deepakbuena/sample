({
   doInit : function(component, event, helper) {
      $A.createComponent(
         "c:CustomSALTRecordList",
         {
 
         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   },
   NavigateComponent : function(component,event,helper) {
       console.log("kkkk---"+event.getParam("result"));
      $A.createComponent(
         "c:SALTClientReportAttachmentList",
         {
           "recordId" : event.getParam("result")
         },
         function(newCmp){
            if (component.isValid()) {
                console.log(newCmp);
                component.set("v.body", newCmp);
            }
         }
      );
   },
    NavigateBackToMainCmp : function(component,event,helper) {
       $A.createComponent(
         "c:CustomSALTRecordList",
         {
           
         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   },
   /* NavigateTOPDF : function(component,event,helper) {
        console.log("kkkk0000000");
        console.log(event.getParam("result"));
        $A.createComponent(
            "c:SALTPDFViewer",
            {
                "pdfData" : event.getParam("result")
            },
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    NavigateToList : function(component,event, helper){
     	console.log("kkkk111111");
        console.log(event.getParam("result"));   
        $A.createComponent(
            "c:CombinedAttachments",
            {
                "recordId" : event.getParam("result")
            },
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    } */
    
})