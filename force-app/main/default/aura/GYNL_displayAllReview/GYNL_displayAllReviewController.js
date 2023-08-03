({
    doInit : function(component, event, helper) {
       helper.helperFindReview(component);
        
    },
    clickShowMore : function(component, event, helper) {
        component.set("v.showAllReview",true); 
         helper.helperFindReview(component);
    },
     clickShowLess : function(component, event, helper) {
        component.set("v.showAllReview",false); 
         helper.helperFindReview(component);
    }
})