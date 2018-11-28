({
    getFollowStatus:function(component,event)
    {
        var action=component.get("c.isRecordFollowed");
        console.log('ccccc '+component.get("v.recordId"));
        var idx=component.get("v.recordId");
        action.setParams({"recordId":idx});
        console.log("xxxxxx");
        console.log(action.getParams("recordId"));
        console.log("yyyyy");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("follow "+state);
            if(state=="SUCCESS")
            {
                var result=response.getReturnValue();
                console.log("follow result "+result);
                if(result=='followed')
                {
                    var fButton=component.find("follow");
                    console.log(fButton);
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.addClass(fButton, 'slds-text-selected');
                    
                    
                    fButton=component.find("following");
                    $A.util.removeClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected');
                    $A.util.addClass(fButton, 'slds-text-selected-focus');
                    
                    fButton=component.find("unfollow");
                    $A.util.addClass(fButton, 'slds-text-not-selected');
                    $A.util.removeClass(fButton, 'slds-text-selected-focus');
                    $A.util.removeClass(fButton, 'slds-text-selected');
                                     
                }
            }
        }); 
        $A.enqueueAction(action);
    },
    recordViewed : function(component,id,callback) {
        var action = component.get("c.visitedRecord");
        action.setParams({"recordId": id});
        
        if(callback){
            action.setCallback(this,callback);
        }
        $A.enqueueAction(action);
    },
    saveDownLoadInfo : function(component,event,recordId) {
        console.log("Download started"+recordId);
        var action=component.get("c.saveDownloadSF");
        action.setParams({"attachmentId":recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
        }); 
        $A.enqueueAction(action); 
        console.log("Download completed");
    },
	openPDF : function(component,event,recordId) {
        console.log("sss");
        var action=component.get("c.getPDFData");
        
        action.setParams({"attachmentID":recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS')
            { 
				console.log(response.getReturnValue());
                var evt = $A.get("e.c:SALTPDFViewerEvt");
                evt.setParams({"result": response.getReturnValue()});
                evt.fire();
            }
        }); 
        $A.enqueueAction(action); 
    },
    getContainerDiv: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('slds-tabs--default__item')) {
            return elem;
        }
        else {
            return this.getContainerDiv(event, elem.parentElement);
        }
    },
    getUploadPermission : function(component)
    {
        	console.log("check donwload");
        var action=component.get("c.hasUploadPermission");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS')
            {
            	component.set("v.canUpload", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})