({
    init : function(component, event, helper) {

        function liveAgentStart(){
            //timeout to initiate liveAgent
            window.setTimeout(
                $A.getCallback(function() {
                    if (component.isValid()) {
                        var data = {};
                        data.LA_chatServerURL =component.get("v.endpoint");
                        data.LA_deploymentId =component.get("v.deploymentId");
                        data.organizationId =component.get("v.organizationId");
                        data.chatButtontId =component.get("v.chatButtontId");
                        data.userSessionData =component.get("v.userSessionData");
                        if (component.get("v.contact") != null){
                            data.contactId =component.get("v.contact").Id;
                            data.contactName =component.get("v.contact").Name;
                        }
                        if (component.get("v.caseRecType") != null){
                            data.recTypeId =component.get("v.caseRecType");
                        }
                        function initLiveAgent (data){
                            var self = this;
                            self.data = data;

                            if ((typeof liveagent == "object") && (document.getElementById('btONline') != null )){
                                console.log('CTRL  init live agent');
                                clearInterval(interV);
                                helper.bindLiveAgent(component,data);
                            }else{
                                    console.log('CTRL  timeout to init live agent');
                            }
                        }
                        //setInterval to initiate liveAgent when liveagent object
                        // is available
                        interV = setInterval(initLiveAgent,500,data);
                    }else{
                    console.log('CTRL  component is not valid');
                }
                }), 100
            );
        }

        var isValid = helper.validateComponent(component);
        component.set("v.isInvalidInput", !isValid);
        if ( isValid){
            if ( component.get("v.userSessionData") == true){
                //retrieve logged user Contact Details
        		var action = component.get("c.getContact");
        		action.setCallback(this, function(a) {
                    component.set("v.contact", a.getReturnValue());
                    liveAgentStart();
        		});
        		$A.enqueueAction(action);
                var action = component.get("c.getCaseRecordTypeId");
                    action.setCallback(this, function(x) {
                      component.set("v.caseRecType", x.getReturnValue()); 
                        liveAgentStart();
                  });
                
                $A.enqueueAction(action);
            }else {
                liveAgentStart();
            }

            var chatBtn = component.get("v.chatButtontId")+'';
            //adding liveAgent buttons wo global array
            if (!window._laq) { window._laq = []; }
            window._laq.push(function(){
                liveagent.showWhenOnline(
                    (function (chatBtn) {
                            return chatBtn;
                        })(chatBtn)
                    , document.getElementById('btONline'));
                liveagent.showWhenOffline(
                    (function (chatBtn) {
                            return chatBtn;
                        })(chatBtn)
                    , document.getElementById('btOFFline'));
            });
        }
    },

    startChat : function(component, event, helper) {
        liveagent.startChat(component.get("v.chatButtontId"));
    }
})