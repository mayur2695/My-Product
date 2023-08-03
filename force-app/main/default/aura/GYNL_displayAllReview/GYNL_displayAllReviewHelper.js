({
	helperFindReview : function(component) {
		 var action = component.get("c.findAllReviews");
        action.setParams({ 
            productId : component.get("v.recordId"),
            showAllReview : component.get("v.showAllReview"),
            recordCount : component.get("v.itemsOnFirstPage")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                //alert("Inside Success");
                component.set("v.allReviews",response.getReturnValue());
                console.log(JSON.stringify(component.get("v.allReviews")));
            }
        });
        $A.enqueueAction(action);
	}
})