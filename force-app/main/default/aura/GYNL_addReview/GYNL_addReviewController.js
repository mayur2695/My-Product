({
    submitForm : function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var allValues = event.getParam("fields");
        //alert(JSON.stringify(allValues));
        allValues.GYNCF_Product__c = component.get("v.recordId");
        allValues.GYNCF_Rating__c = component.get("v.storeRating");
        //alert(JSON.stringify(allValues));
        component.find('review').submit(allValues);
        //alert(JSON.stringify(test));
    },
    successful : function(component, event, helper) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type" : "success",
            "title": "Success!",
            "message" : "Review added successfully."
            
        });
        resultsToast.fire();
        component.find("commentid").reset();
        component.set("v.storeRating", 0);
        var appEvent = $A.get("e.c:GYNE_changeReviewTab");
        appEvent.fire();
    }
})