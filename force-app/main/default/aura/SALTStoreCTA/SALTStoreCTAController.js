({
	fireAnalytics : function(component, event, helper) {
        var url = component.get("v.linkTarget");
        window.open(url);
        var analyticsInteraction = $A.get("e.forceCommunity:analyticsInteraction");
        analyticsInteraction.setParams({
            hitType : 'event',
            eventCategory : 'Button',
            eventAction : 'click',
            eventLabel : url
        });
        analyticsInteraction.fire();
	}
})