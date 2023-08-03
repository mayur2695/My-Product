({
    callEvent : function(component, event, helper) {
        if(component.get("v.ObjectName")!='Admin'&& component.get("v.ObjectName")!='Any Data Connect'){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:GYNL_B2B_AllObjectDataConnect",
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
                componentDef : "c:GYNL_adminPage",
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
    }
})