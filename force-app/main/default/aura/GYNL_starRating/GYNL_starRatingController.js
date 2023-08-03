({
	handleClick : function(component, event, helper) {
		component.set("v.ratingSelected", event.currentTarget.id);
        component.set("v.currentRatingValue", event.currentTarget.id);
	},
    hoverIn : function(component, event, helper) {
        //component.set("v.hoverOn", true);
		component.set("v.ratingSelected", event.currentTarget.id);
        //alert(event.currentTarget.id);
		//alert("Test");
	},
    hoverOut : function(component, event, helper) {
        //alert();
        component.set("v.ratingSelected", component.get("v.currentRatingValue"));
	},
    doinit : function(component, event, helper) {
     //  alert('doinit loaded');
	 var staticResoucename = event.getParam("getTheme");
      
        component.set("v.staticresourceName",staticResoucename);
     //   alert('***'+component.get("v.staticresourceName"));
        console.log('###'+component.get("v.staticresourceName"));
	},
     scriptsLoaded :function(component, event, helper) {
    // alert('afterscripts-themee1 loaded');
    },
})