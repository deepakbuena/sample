({
	doInit : function(component, event, helper) {
		var action=component.get("c.getAttachmentInfo");
        action.setParams({"iRecordId": component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(" state"+state);
            if(state=='SUCCESS')
            {
                var result = response.getReturnValue();
                console.log("result "+result);
                
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                    component.set("v.liAttachment",JSON.parse(result));
                
            } 
            else if(state == "ERROR")
            {
                alert('Error in calling server side action');
            }
        });      
        $A.enqueueAction(action); 
        helper.getUploadPermission(component);
        helper.getFollowStatus(component,event);
	},
    saveDownload : function(component,event,helper)
    {
        var recordId = event.target.id;
        helper.saveDownLoadInfo(component,event,recordId);
    },
    sendToPDF : function (component,event, helper){
        var recordId = event.target.id;
        helper.openPDF(component,event,recordId);
    },
     changeTab: function(component, event, helper) {
        var clickedTab = helper.getContainerDiv(event, null);
        var tabs =  component.find('tabpageNotesAttachments');
        for(idx = 0; idx < tabs.length; idx++)
         {
             tab = tabs[idx].elements[0];
             console.log(tab.children[0].getAttribute('aria-controls'));
             $A.util.removeClass(tab, 'slds-active');
             $A.util.removeClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-show');
             $A.util.addClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-hide');
         }

        $A.util.addClass(clickedTab, 'slds-active');
        $A.util.addClass(component.find(clickedTab.children[0].getAttribute('aria-controls')), 'slds-show');
        $A.util.removeClass(component.find(clickedTab.children[0].getAttribute('aria-controls')), 'slds-hide');
    },
    openCombinedAttachments : function(component,event,helper){
        console.log("record Id  "+component.get("v.recordId"));
        var id=component.get("v.recordId");
        console.log(id);
        var evt = $A.get("e.c:CombinedAttachmentsEvt");
        console.log(evt);
        evt.setParams({"result": id});
        console.log(evt);
        evt.fire();
    },
    recordViewed : function (component, event,helper){
        var idx = event.target.id;
        helper.recordViewed(component,idx);
    },
    
    createFollow : function(component,event)
    {
    	var action=component.get('c.followRecord');
        action.setParams({"recordId":component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(" state"+state);
            if(state=='SUCCESS')
            {
                var result = response.getReturnValue();
                console.log("result 2  "+result);
                if(result=='success')
                {
                    var fButton=component.find("follow");
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.addClass(fButton, 'slds-text-selected');

                    fButton=component.find("following");
                    $A.util.addClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.removeClass(fButton, 'slds-text-selected'); 

                    fButton=component.find("unfollow");
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected');
                    $A.util.addClass(fButton, 'slds-text-selected-focus');
                     
                }
                else
                {
                 	var fButton=component.find("follow");
                    $A.util.addClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.removeClass(fButton, 'slds-text-selected');    
                    
                    fButton=component.find("following");
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected');
                    $A.util.addClass(fButton, 'slds-text-selected-focus');
                    
                    fButton=component.find("unfollow");
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.addClass(fButton, 'slds-text-selected');
                     
                }
            } 
            else if(state == "ERROR")
            {
                alert('Error in calling server side action');
            }
        });      
        $A.enqueueAction(action);
	},
    
    deleteRecordA : function(component,event)
    {
        var action=component.get("c.deleteRecord");
        console.log("xxxxxxxx"+component.get('v.recordId'));
        action.setParams({"recordId":event.currentTarget.dataset.id});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("D state"+state);
            if(state=='SUCCESS')
            {
                var result=response.getReturnValue();
                console.log(result);
                console.log(result!='success');
                if(result!='success')
                {
                    console.log("vvvvv"+response.getReturnValue());
                    component.set("v.errMessage",response.getReturnValue());
                    var modal=component.find("ErrorModal");
                    console.log('modal '+modal);
                    $A.util.removeClass(modal,'slds-hide');
                    $A.util.addClass(modal,'slds-show');
                }
            }
            else
            {
                
            }
        });
        $A.enqueueAction(action);
    },
    
    hideModal:function(component,event)
    {
        console.log("fffff");
        var modal=component.find("ErrorModal");
        $A.util.removeClass(modal,"slds-show");
        $A.util.addClass(modal,"slds-hide");
    },
    goBack : function(component,idx) {       	
        var evt = $A.get("e.c:NavigateBack");
        evt.setParams({"result": idx});
        evt.fire();
	}

    

})