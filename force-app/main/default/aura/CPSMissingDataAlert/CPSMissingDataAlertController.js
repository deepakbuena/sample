({
    init: function(component, event, helper) {
        var cRecordId = component.get("v.recordId");
        var action = component.get("c.getAllMissingInfo");
        action.setParams({recordId: cRecordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {               
                component.set("v.msgList", response.getReturnValue());
            }
        });
        
        var action2 = component.get("c.getTargetInfo");
        action2.setParams({recordId: cRecordId});
        action2.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.atTargtSchool", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action2);
    }
})