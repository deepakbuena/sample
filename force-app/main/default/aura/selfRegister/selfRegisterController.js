({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
        component.set('v.extraFields', helper.getExtraFields(component, event, helper));
        component.set("v.communitytermsAndConditionsUrl", helper.getcommunitytermsAndConditionsUrl(component, event, helper));
    },
    
    handleSelfRegister: function (component, event, helpler) {
        helpler.handleSelfRegister(component, event, helpler);
    },
    
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    onKeyUp: function(component, event, helpler){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleSelfRegister(component, event, helpler);
        }
    },
    navigateToCommunityTerms: function(cmp, event, helper) {
        var commTermsUrl = cmp.get("v.communitytermsAndConditionsUrl");
        if ($A.util.isUndefinedOrNull(commTermsUrl)) {
            commTermsUrl = cmp.get("v.termsAndConditionsUrl");
        }
        var attributes = { url: commTermsUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    }
})