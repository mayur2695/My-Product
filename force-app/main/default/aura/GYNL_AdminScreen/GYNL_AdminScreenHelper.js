({
    loaddata : function(component, event, helper,change) {
        console.log('vl-->'+component.get("v.SelectedSystem"));
        if($A.util.isEmpty(component.get("v.SelectedSystem"))) {
            return;
        }
        var action = component.get("c.getConfiguration");
        action.setParams({
            "SystemId":component.get("v.SelectedSystem")  
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var result = response.getReturnValue();
                if(namespace != null && namespace != "c") { 
                    result = result.replace(new RegExp(namespace +"__", 'g'), "");
                } 
                result=JSON.parse(result);
                
                component.set("v.UrlList",result);
                //var SystemData=JSON.parse(result.SystemData);
                //component.set("v.options",SystemData);
                
                component.set("v.Edit",change);
                //console.log(JSON.stringify(response.getReturnValue()));
                
            }
        });
        $A.enqueueAction(action);
    }
})