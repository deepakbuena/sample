({
	init : function(component, event, helper) {
        // <ltng:require scripts="{!v.urls}"/>
        $A.createComponent("ltng:require", {
            scripts: [component.get("v.paramURL")]
        }, function(ltngRequire) {
            component.set("v.body", [ltngRequire])
        });
	}
})