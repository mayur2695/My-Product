({
	handleChange : function(component, event, helper) {
        var action = component.get('c.UpdateRecord'); 
        action.setParams({
            "value" : component.get('v.value') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') 
            {
                //if returned state is success shows a pop-up message.
               var toastReference = $A.get("e.force:showToast");
               toastReference.setParams({
                type:"Success",
                title:"Success",
                message:"Event Format is successfully updated.",
                mode:"dismissible"
            });
            toastReference.fire();
            }
        });
        $A.enqueueAction(action);
	},
    doInit :function(component, event, helper) // executes when the component loads initially
    {
        var action = component.get('c.ReturnDefault'); 
        action.setCallback(this, function(a){
          var state = a.getState(); // get the response state
            if(state == 'SUCCESS') 
            {
                component.set('v.value', a.getReturnValue());
                //loads the previous value of the radio buttons when the screen is reloaded.
            }
        });
        $A.enqueueAction(action);
    }
})