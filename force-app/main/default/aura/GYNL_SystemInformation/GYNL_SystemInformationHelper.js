({
	refreshData : function(component,evnt,data) {
		var action=component.get("c.Systemdata");
         action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=JSON.parse(response.getReturnValue());
                
                //if(result.length>0){
                component.set("v.options",result);
                 window.setTimeout(
                    $A.getCallback(function() {
                        //for(var i in result){
                   // if(result[i].value=='Default'){
                        component.set("v.selectedValue",data);
                        console.log('datta'+component.get("v.selectedValue"));
                        component.set("v.selectedSystemId",data);
                   // }
                    //alert(component.get("v.selectedSystemId"));
                    
               // }
                    }), 500
                );
                //component.set("v.selectedValue",data);
               // component.set("v.selectedSystemId",data);
               // alert(component.get("v.selectedValue")+'--'+data);
                //}
                //var SystemData=JSON.parse(result.SystemData);
                //component.set("v.options",SystemData);
                //component.set("v.Edit",true);
                //console.log(JSON.stringify(response.getReturnValue()));
                
            }
        });
        $A.enqueueAction(action);
	}
})