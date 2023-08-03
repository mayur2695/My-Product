({
    getSchedulatListhelperMethod : function(component, event, helper) {
        var SelectedId=event.getParam("message");
        var action = component.get('c.getSchedulatList');
        action.setParams({objName:component.get("v.ObjectName"),
                          sysId:component.get("v.SystemId")});
        action.setCallback(this, function(response) {
            var namespace = $A.get("$Label.c.GYNCL_Namespace");
var responseAsString = response.getReturnValue();
if(namespace != null && namespace != "c") {
responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
}
            var allValues = JSON.parse(responseAsString);
            console.log('allValues -- >> ' + JSON.stringify(allValues));
            component.set("v.schedlist", allValues);
            if(SelectedId != undefined && SelectedId!=''&& SelectedId!=null){
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.selectedValue",SelectedId);
                    }), 500
                );   
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    passCronhelperMethod : function(component, event, helper){
        var schId= component.find('PicklistId').get('v.value');
        console.log('The value====>'+schId);
        component.set("v.SchedId", schId);
    },
    saveEventhelperMethod : function(component, event, helper){
        var schId= component.get("v.SchedId");
        var objname= component.get("v.ObjectName");
        var sysid= component.get("v.SystemId");
        console.log('The schedlist'+schId);
        var action= component.get('c.sendCronToSchedule');
        action.setParams({
            "schId" : schId,
            "objnam" : objname,
            "sysId"  : sysid
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
                
                var reloadBatch = $A.get("e.c:ReloadNewBatchSetting");
                    reloadBatch.setParams({"message" :"event fired" }); 
                	reloadBatch.fire(); 
            }
        });
        $A.enqueueAction(action);
    }
    
})