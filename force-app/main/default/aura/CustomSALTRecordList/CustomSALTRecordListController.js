({
	doInit : function(component, event, helper) {
        helper.getLoggedInUserId(component);
        //helper.getListViewOption(component);
		helper.getClientReports(component);
        helper.getCurrentSortField(component);
        helper.isCreateAble(component);
        
        
    },
    createrecord : function (component, event,helper){
        var idx = event.target.id;
        helper.createRecord(component,idx);
    },
    gotoList : function (component, event, helper) {
		var id=event.target.id;
        console.log(id);
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": listviews.Id,
            "listViewName": null,
            "scope": "Account"
        });
            navEvent.fire();
    },
    changeListView: function(component, event, helper) {
        console.log("dddddd");
        var clickedList = helper.getContainerDiv(event, null);
        var view =  component.find('Listview-Dropdown');
        $A.util.toggleClass(view, 'slds-is-open');
    },
    getClientReportByFilter : function(component, event, helper)
    {
        console.log("dddddddddddddd");
        var action=component.get("c.findAllByFilter");
        var id=event.target.id;
        action.setParams({"filterId": id});
        console.log("filter "+ id);
        action.setCallback(this, function(response) {
            var state = response.getState();
            var view =  component.find('Listview-Dropdown');
            $A.util.toggleClass(view, 'slds-is-open');
            if(state=='SUCCESS')
            {
            	component.set("v.tbDetails", response.getReturnValue());
            }
        });      
        $A.enqueueAction(action); 
    },
    
   toggle : function(component, event, helper) {
        console.log("ooooooo");
        var toggleText = component.find("FilterPanel");
		console.log(toggleText);
        $A.util.toggleClass(toggleText, "toggle");
    }
})
    
})