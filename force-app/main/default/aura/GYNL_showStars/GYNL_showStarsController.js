({
    doInit : function(component, event, helper) {
       
        if(component.get("v.ratingSelected")!=null && component.get("v.ratingSelected")!=undefined){
            var percentageRating = (parseFloat(component.get("v.ratingSelected"))*100)/component.get("v.maxRating");
            //alert(percentageRating);
            component.set("v.percentageRating", percentageRating);  
        }
        
    }
})