({
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
    OnClickB2B : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:GYNL_B2B_ClickObjects"
            /*componentAttributes: {
                ObjectName : component.get("v.ObjectName"),
                ParentName : component.get("v.ParentName"),
                iconName : component.get("v.iconName")
            }*/
        });
        evt.fire();
    }
})