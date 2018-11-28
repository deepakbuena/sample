({
    helperMethod : function(component) {

    },

    validateComponent : function(component) {
        var valid = true;

         if (component.isValid()) {
            valid =  ( component.get("v.chatButtontId") != undefined && component.get("v.chatButtontId") != '')
                        || ( component.get("v.endpoint") != undefined && component.get("v.endpoint") != '')
                        || ( component.get("v.deploymentId") != undefined && component.get("v.deploymentId") != '')
                        || ( component.get("v.deploymentUrl") != undefined && component.get("v.deploymentUrl") != '')
                        || ( component.get("v.organizationId") != undefined && component.get("v.organizationId") != '') ;
        }
         return valid;
    },
    bindLiveAgent : function (component,data){
        //custom handler for online/offline update
        function updateLiveAgentButton(component) {

            if (component.isValid()) {
                var onlineBtn = document.getElementById('btONline');//component.find("btONline");
                var offlineBtn = document.getElementById('btOFFline');//component.find("btOFFline");

                 if( (  typeof onlineBtn != "undefined"  ) &&
                     (  typeof offlineBtn != "undefined"  )){

                     if ( component.get("v.isLiveAgentOnline")== true){
                          $A.util.removeClass(onlineBtn, "toggle");
                          $A.util.addClass(offlineBtn, "toggle");
                     }else{
                         $A.util.removeClass(offlineBtn, "toggle");
                         $A.util.addClass(onlineBtn, "toggle");
                     }
                }
            }
        }

        component.set("v.isLiveAgentOnline",false);
        var chatBtn    = data.chatButtontId;
        liveagent.addButtonEventHandler(chatBtn, function(e) {
            if (e == liveagent.BUTTON_EVENT.BUTTON_AVAILABLE) {
                component.set("v.isLiveAgentOnline",true);
            } else if (e == liveagent.BUTTON_EVENT.BUTTON_UNAVAILABLE) {
                component.set("v.isLiveAgentOnline",false);
            }
            if (component.get("v.previousIsLiveAgentOnline") == null){
                component.set("v.previousIsLiveAgentOnline",false);
            }else {
                component.set("v.previousIsLiveAgentOnline",component.get("v.isLiveAgentOnline"));
            }


            updateLiveAgentButton(component);
        });

        if (data.userSessionData && typeof data.contactId != undefined){
            var contactId = data.contactId;
            var recTypeId = data.recTypeId;
            if (contactId != undefined){
                liveagent.addCustomDetail('Contact Id', contactId, false);
                liveagent.addCustomDetail('Case Status','New', false);
                liveagent.addCustomDetail('Case Origin','Employer Community', false);
                liveagent.addCustomDetail('Case Record Type',recTypeId, false);
                // An auto query that searches contacts whose id exactly matches based on
                //the community user's contact. The guid for the contact will be hidden from the agent.
                // The contact will be automatically associated to the chat and opened in the Console for the agent
                liveagent.findOrCreate('Contact').map('Id','Contact Id',true,true,false).saveToTranscript('ContactId').showOnCreate();
                // Set case details
                
                liveagent.findOrCreate('Case')
                .map('RecordTypeId','Case Record Type',false,false,true) 
            	.map('Status','Case Status',false,false,true)
            	.map('Origin','Case Origin',false,false,true)
            	.map('ContactId','Contact Id',false,false,true)
            	.saveToTranscript('CaseId').showOnCreate();
                //set the visitor's name to the value of the contact's first and last name
                liveagent.setName(data.contactName);
            }
        }
        liveagent.init( data.LA_chatServerURL, data.LA_deploymentId,  data.organizationId);
    }
})