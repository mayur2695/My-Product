({
    installAllRecord : function(component, event, helper) {
        var action = component.get("c.doInstall");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                alert("From server: " + response.getReturnValue());

                
            }
            
        });

        $A.enqueueAction(action);

    }
})