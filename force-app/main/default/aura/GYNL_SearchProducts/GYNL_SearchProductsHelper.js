({
	retrieveProdsData : function(component,event,helper) {
		var keyVal = component.find("SearchBox").get("v.value");
        //alert('Search Key Value>>>>'+keyVal);
    	var action = component.get("c.fetchPrdData");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
         action.setParams({
             "pname": keyVal,
             'pageSize' : pageSize,
            'pageNumber' : pageNumber
         });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('Status>>>'+state);
            if (state === "SUCCESS") {
                //alert('Results>>>>'+response.getReturnValue());
                var results = response.getReturnValue();
                for (var i = 0; i < results.length; i++) {
                    var result = results[i];
                    if (result.GYNCF_Product_Category__c) result.Categoryname = result.GYNCF_Product_Category__r.Name;
                }
                /*if(results.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }*/
                component.set("v.dataSize", results.length);
                component.set("v.Results", results);
            }
        });
        $A.enqueueAction(action);		
	}
})