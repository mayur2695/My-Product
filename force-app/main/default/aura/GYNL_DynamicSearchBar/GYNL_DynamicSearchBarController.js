({
    closeOptions : function(component, event, helper) {
        var itemList = component.get("v.itemList");
        itemList.length = 0
        component.set("v.itemList",itemList);
        
    },
    searchItem : function(component, event, helper) {
        console.log("Check: "+ event.getSource().get("v.value").length);
        if(event.getSource().get("v.value").length>0) {
            var cmpEvent = component.getEvent("GYNE_DynamicSearchEvent");
            cmpEvent.setParams({
                "searchPara" : event.getSource().get("v.value"),
                "origin" : component.get("v.origin"),
                "operationType" : "search"
            });
            cmpEvent.fire();
        }
        else {
            var itemList = component.get("v.itemList");
            itemList.length = 0
            component.set("v.itemList",itemList);
        }

		
	},
    itemSelected : function(component, event, helper) {
        var cmpEvent = component.getEvent("GYNE_DynamicSearchEvent");
        cmpEvent.setParams({
            "seletedValue" : event.currentTarget.id,
            "origin" : component.get("v.origin"),
            "operationType" : "select"
        });
        cmpEvent.fire();

		
	}
    
    
})