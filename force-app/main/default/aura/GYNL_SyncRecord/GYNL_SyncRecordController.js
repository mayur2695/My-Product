({
    doInit : function(component, event, helper) {
        var action = component.get("c.syncRecord");
        action.setParams({ recordId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showMyToast(component, event,response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    }
})