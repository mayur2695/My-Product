({
	saveEventhelperMethod : function(component, event, helper) {
		var childComp = component.find('childCompCustomer');
        var eventMsgFrmChild  = event.getParam("CronFromParent");
        //Cron expession 
        var nameval = component.find("name").get("v.value");
        
		childComp.callChild();
        var action = component.get('c.createSchedularRecord'); 
         action.setParams({
            "cronExp" : component.get("v.CronTrigger"),
             "name"   : nameval
             
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                 toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    
    checkChildMessagehelperMethod : function(component, event, helper){
         //Fetch event message set in child component.
        var eventMsgFrmChild  = event.getParam("CronFromParent");
        
        //Set event message to display in UI.
        component.set("v.CronTrigger", eventMsgFrmChild);
        console.log('=======Get value=========>'+component.get("v.CronTrigger"));
    },
    
    showToasthelperMethod : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
        
    }
})