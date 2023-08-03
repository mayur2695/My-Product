({
    doInit : function(component, event, helper) {
        var action=component.get("c.Systemdata");
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=JSON.parse(response.getReturnValue());
                
                //if(result.length>0){
                component.set("v.options",result);
                console.log('val'+JSON.stringify(component.get("v.options")));
               window.setTimeout(
                    $A.getCallback(function() {
                        for(var i in result){
                            if(result[i].value=='Default'){
                                component.set("v.selectedValue",result[i].key);
                                console.log('datta'+component.get("v.selectedValue"));
                                component.set("v.selectedSystemId",result[i].key);
                            }
                            //alert(component.get("v.selectedSystemId"));
                            
                        }
                    }), 500
                );
                
                
                //alert(component.get("v.selectedSystemId"));
                //}
                //var SystemData=JSON.parse(result.SystemData);
                //component.set("v.options",SystemData);
                //component.set("v.Edit",true);
                //console.log(JSON.stringify(response.getReturnValue()));
                
            }
        });
        $A.enqueueAction(action);
    },
    createSystem : function(component, event, helper) {
        component.set("v.NewSystem",true);
    },
    handleCancel :function(component, event, helper) {
        component.set("v.NewSystem",false);
    },
    handlecreate :function(component, event, helper) {
        var action=component.get("c.createSetting");
        action.setParams({
            "Name": component.get("v.NewSystemName"),
            "BaseUrl": component.get("v.NewSystemUrl")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            component.set("v.NewSystem",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success",
                "message": "New System has been created successfully.",
                "type":"success"
            });
            toastEvent.fire();
                component.set("v.IsEdit",false);
            helper.refreshData(component,event,response.getReturnValue());
            //component.set("v.selectedValue",response.getReturnValue());
            
            // console.log(component.get("v.selectedValue"));
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": "Not able to create New System.Contact System Admin",
                "type":"error"
            });
            toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    updateSystemId :function(component, event, helper) {
        component.set("v.selectedSystemId",component.get("v.selectedValue"));
    }
})