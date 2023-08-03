({
    doInit : function(component, event, helper){
        var action=component.get("c.LandingFeatureParameterVal");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
                var res = response.getReturnValue();
                
                component.set("v.MasterAllowed",res.split(".")[0]);
                component.set("v.SalesAllowed",res.split(".")[1]);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    callMaster : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:GYNL_MasterDataConnect"
            /*componentAttributes: {
                ObjectName : component.get("v.ObjectName"),
                ParentName : component.get("v.ParentName"),
                iconName : component.get("v.iconName")
            }*/
        });
        evt.fire();
    },
    callOrder : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:GYNL_OrderToCashConnect"
            /*componentAttributes: {
                ObjectName : component.get("v.ObjectName"),
                ParentName : component.get("v.ParentName"),
                iconName : component.get("v.iconName")
            }*/
        });
        evt.fire();
    },
    showMyToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        mode: 'sticky',
        message: 'Current License does not allow you to use this feature.Please Contact Gyansy Sales Team <salesteam@gyansys.com>',
        type:'warning'        
    });
    toastEvent.fire();
}
})