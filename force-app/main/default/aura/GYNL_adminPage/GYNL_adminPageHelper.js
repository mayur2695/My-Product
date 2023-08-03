({
	loaddata : function(component, event, helper,change) {
		 var action = component.get("c.getConfiguration");
        console.log('val-->'+component.get("v.SelectedSystem"));
        action.setParams({
            "SystemId":component.get("v.SelectedSystem")  
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                component.set("v.UrlList",JSON.parse(result));
                //var SystemData=JSON.parse(result.SystemData);
                //component.set("v.options",SystemData);
                
                component.set("v.Edit",change);
                //console.log(JSON.stringify(response.getReturnValue()));
                
            }
        });
        $A.enqueueAction(action);
	}
})