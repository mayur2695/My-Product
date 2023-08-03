({
	syncSAPFields : function(component, event, helper) {
        var syncAPI = component.get("c.getAPIFieldsfromSAP");
      	
        syncAPI.setParams({ObjectName : component.get('v.selTabId'),
                           systemId:  component.get('v.systemId')});
        syncAPI.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Congrats, Sync is complete!",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(syncAPI); 
	}
})