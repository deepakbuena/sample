({
    isCreateAble : function(component)
    {
        var action=component.get("c.hasCreatePermission");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("hasCreatePermission "+state);
            if(state=='SUCCESS')
            {
            	component.set("v.canCreate", response.getReturnValue());
            }
        });      
        $A.enqueueAction(action); 
    },
	getClientReports : function(component) {
        var action=component.get("c.findAll");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("findAll "+state);
            if(state=='SUCCESS')
            {
            	component.set("v.tbDetails", response.getReturnValue());
            }
        });      
        $A.enqueueAction(action); 
	},
    
    getLoggedInUserId : function(component) {
        var action=component.get("c.getUserId");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("getUserId "+state);
            if(state=='SUCCESS')
            {
            	component.set("v.userId", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });      
        $A.enqueueAction(action); 

	},
	createRecord : function(component,idx) {       	
        this.upsertRecord(component,idx,function(a){           
        });

        var evt = $A.get("e.c:SALTClientReportAttEvt");
            evt.setParams({
                "result": idx
            });
   			evt.fire();
	},
    upsertRecord : function(component,idx,callback) {
        var action = component.get("c.saveRecord");
        //var newrecordDetails = component.get("v.newrecordDetails");
        action.setParams({
            //"newrecordDetails": newrecordDetails,
            "curl": idx
        });
        
        if(callback){
            action.setCallback(this,callback);
        }
        $A.enqueueAction(action);
	},
    getCurrentSortField :  function(component)
    {
        var action=component.get("c.getCurrentSortedByName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("sorted "+state);
            if(state=='SUCCESS')
            {
                console.log(response.getReturnValue());
                component.set("v.sortedby", response.getReturnValue());
            }
        });      
        $A.enqueueAction(action); 
    },  
    getListViewOption : function(component)
    {
        var action=component.get("c.getAvailableListviews");
        action.setCallback(this, function(response){
           var state=response.getState(); 
            console.log("getAvailableListviews "+state);
            if(state=='SUCCESS')
            {
                component.set("v.listviews",response.getReturnValue());
                console.log("list views  "+ response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    getContainerDiv: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
            console.log("elem "+elem);
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('slds-dropdown-trigger')) {
            return elem;
        }
        else {
            return this.getContainerDiv(event, elem.parentElement);
        }
    },
})