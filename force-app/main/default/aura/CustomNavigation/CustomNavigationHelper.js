({
    doInit : function(cmp, ev) {
        var action = cmp.get("c.getAccessToInteractiveReportsTab");
		
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set('v.showInteractiveRpTab', response.getReturnValue());
            }
            else if (state === "ERROR") {
                console.log(JSON.stringify(errors));
                alert('Error : ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    }
})