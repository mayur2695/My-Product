({
	handleCancel : function(component, event, helper) {
		component.set("v.isOpen", false);
	},
    doSave : function(component, event, helper) {
        var Template = component.get("v.newOfferLetterTemplate");
        var action = component.get("c.DoUpdate");
      // set param to method  
        action.setParams({
            'Temp': Template
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastReference = $A.get("e.force:showToast");
               toastReference.setParams({
                type:"Success",
                title:"Success",
                message:"Offer letter template is successfully updated.",
                mode:"dismissible"
            });
            toastReference.fire();
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
        component.set("v.isOpen", false);
    }
})