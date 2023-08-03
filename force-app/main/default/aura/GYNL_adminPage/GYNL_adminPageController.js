({
    handleClick : function(component, event, helper) {
        if(component.get("v.Radiovalue")=="option1"){
            component.set("v.selectedUP", "true");
            component.set("v.selectedOAuth", "false");
        }
        else{
            component.set("v.selectedOAuth", "true");
            component.set("v.selectedUP", "false");
        }
    },
    edit : function(component, event, helper) {
        component.set("v.Edit",false);
    },
    save : function(component, event, helper) {
        // alert changed to console.log by aniket
        console.log("URL List: "+JSON.stringify(component.get("v.UrlList")));
        console.log("Systemid: "+ component.get("v.SelectedSystem"));
        var action = component.get("c.updateauth");
        action.setParams({
            "wrap":component.get("v.UrlList"),
            "systemId":component.get("v.SelectedSystem")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert changed to console.log by aniket
            console.log("Check state: "+state);
            console.log("Check return value: "+ response.getReturnValue() );
            if (state === "SUCCESS") {
                component.set("v.Edit",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully.",
                    "type":"success"
                });
                toastEvent.fire();
                //console.log(JSON.stringify(response.getReturnValue()));
                
            }
        });
        $A.enqueueAction(action);
    },
    cancel : function(component, event, helper) {
        helper.loaddata(component, event, helper,true);
    },
    showpassword : function(component, event, helper) {
        if(component.get("v.showpassword")){
            component.set("v.showpassword",false);
        }
        else{
            component.set("v.showpassword",true);
        }
    },
    doInit : function(component, event, helper) {
        helper.loaddata(component, event, helper,true);
    },
    change :function(component, event, helper) {
        helper.loaddata(component, event, helper,true);
        
    },
    showpasswordClient : function(component, event, helper) {
        if(component.get("v.showpasswordClient")){
            component.set("v.showpasswordClient",false);
        }
        else{
            component.set("v.showpasswordClient",true);
        }
    },
    DeleteSystem : function(component, event, helper) {
        //alert(component.get("v.SelectedSystem"));
        var SystemId = component.get("v.SelectedSystem");
        var action = component.get("c.DeleteSystemRec");
        action.setParams({"systemId":SystemId});
        var statusObj = {"status":"","statusMessage": ""};
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {           
                var allValues = response.getReturnValue();
                if(allValues != 'Error'){
                statusObj.status = response.getState();
                statusObj.statusMessage = response.getReturnValue() + ' System is Successfully Deleted!';
                }else{
                    statusObj.status ='Error';
                    statusObj.statusMessage = 'This System Can not Deleted';
                }
                    $A.get('e.force:refreshView').fire();
            }                    
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title : statusObj.status,
            type: statusObj.status,
            mode: 'dismissible',
            message: statusObj.statusMessage
            
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
            
        });
        $A.enqueueAction(action);
    }
})