({
    doinit : function(component, event, helper) {
        console.log('data'+component.get("v.selectedtab"));
        var action=component.get("c.getfieldData");
        action.setParams({
            "ObjName":component.get("v.selectedtab"),
            "SysId" : component.get("v.selectedSystemId")
        });
        action.setCallback(this,function(response){
            var state= response.getState();
            if(state="SUCCESS"){
                component.set("v.CustomFieldList",response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
        
    },
    addtoSalesforce : function(component, event, helper) {
        //alert(event.currentTarget.id);
        //
        var action=component.get("c.addtoSfdc");
        action.setParams({
            "RecId":event.currentTarget.id
        });
        action.setCallback(this,function(response){
            var state= response.getState();
            if(state="SUCCESS"){
                var action1 = component.get('c.doinit');
                $A.enqueueAction(action1);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Successfully added to Salesforce",
                    "type":"success"
                });
                toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
                //component.set("v.CustomFieldList",response.getReturnValue());
                //console.log(JSON.stringify(response.getReturnValue()));
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in adding to Salesforce",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    handleApplicationEvent : function(component, event, helper) {
        console.log('inside event method');
        var action1 = component.get('c.doinit');
        $A.enqueueAction(action1);
    },
    
    itemsChange : function(component, event, helper) {
        var action1 = component.get('c.doinit');
        $A.enqueueAction(action1);
    }
})