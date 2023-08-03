({
    doInit : function(component, event, helper) {
        console.log('check feature'+component.get("v.FeatureManagement"));
        var action = component.get("c.FeatureParameterVal");
        action.setParams({ 
            feature : component.get("v.FeatureManagement"),
            fieldName : component.get("v.FieldApiName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
                var res = response.getReturnValue();
                component.set("v.Allowed",res);
                
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
    itemsChange : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    callEvent : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
               $A.get('e.force:refreshView').fire();
            }), 500
        );
        if(component.get("v.ObjectName")!='Admin'&& component.get("v.ObjectName")!='Any Data Connect'){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:GYNL_AllObjectDataConnect",
                componentAttributes: {
                    ObjectName : component.get("v.ObjectName"),
                    ParentName : component.get("v.ParentName"),
                    iconName : component.get("v.iconName"),
                    MainSelectedTab :"one"
                }
            });
            evt.fire();
        }
        else{
            if(component.get("v.ObjectName")=='Admin'){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:GYNL_AdminScreen",
                    componentAttributes: {
                        
                        ParentName : component.get("v.ParentName")
                        
                    }
                });
                evt.fire();
            }
            else{
                //GYNL_SAPTableReplicationHome
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:GYNL_SAPTableReplicationHome"
                    
                });
                evt.fire();
            }
        }
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