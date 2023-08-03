({
    doInit : function(component, event, helper) {
        //alert('record id in rating chart'+ component.get("v.recordId"));
        var action = component.get("c.findReviewMatrix");
        action.setParams({ 
            productId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                //alert("Inside Success");
                
                
                
                component.set("v.ratingMatrix",response.getReturnValue().ratingMatrix);
                component.set("v.ratingCount",response.getReturnValue().totalRatingCount);
                console.log('line 18'+ response.getReturnValue().averageRating);
                if(response.getReturnValue().averageRating != undefined){
                    var overallRating = parseFloat(response.getReturnValue().averageRating);
                    component.set("v.overallRating",overallRating.toFixed(2));
                }
                
                component.set("v.loading", true);
            }
        });
        $A.enqueueAction(action);
        
    }
})