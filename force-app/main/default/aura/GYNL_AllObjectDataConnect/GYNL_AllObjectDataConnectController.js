({
    doInit : function(component, event, helper) {
        //alert(component.get('v.ObjectName'));
        var action=component.get("c.Systemdata");
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=JSON.parse(response.getReturnValue());
                
                //if(result.length>0){
                //component.set("v.options",result);
                for(var i in result){
                    console.log('data'+result[i].value);
                    if(result[i].value=='Default'){
                        component.set("v.SystemId",result[i].key);
                        
                        // component.set("v.selectedSystemId",result[i].key);
                    }
                }
                //component.set("v.SystemId",result[0].key);
                
                // component.set("v.selectedSystemId",result[0].key);
                //alert(component.get("v.SystemId"));
                //}
                //var SystemData=JSON.parse(result.SystemData);
                //component.set("v.options",SystemData);
                //component.set("v.Edit",true);
                //console.log(JSON.stringify(response.getReturnValue()));
				 //$A.get('e.force:refreshView').fire();                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    itemsChange: function(component, event, helper) {
        if(!component.get("v.CheckRender")){
            component.set("v.CheckRender",true);
            alert();
        	//$A.get('e.force:refreshView').fire(); 
        }
    },
    onchange : function(component, event, helper) {
        var SystemId =component.get("v.SystemId");
        component.set("v.SystemId",SystemId);
        var tab=component.get("v.MainSelectedTab");
        if(tab=="two"){
            var childComponent = component.find("mapping");
        childComponent.childMessageMethod();
        }
       /* var SystemId =component.get("v.SystemId");
        
        $A.get('e.force:refreshView').fire();
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.MainSelectedTab",tab);
        		component.set("v.SystemId",SystemId);
                console.log('tab'+component.get("v.MainSelectedTab")+'-System-'+component.get("v.SystemId"));
                
       
            }), 5000
        );*/
        
    }
})