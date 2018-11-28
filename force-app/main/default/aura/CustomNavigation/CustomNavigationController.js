({
    doInit : function(component, event, helper) {
        helper.doInit(component, event);
    },
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) 
        {
            component.getSuper().navigate(id);
		}
   }
    
})