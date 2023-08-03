({
	getSchedulatListcontroller : function(component, event, helper) {
        console.log("event fire"+event.getParam("message"));
		helper.getSchedulatListhelperMethod(component, event, helper);
	},
    
    passCron : function(component, event, helper){
        helper.passCronhelperMethod(component, event, helper);
    },
    
    saveEvent :function(component, event, helper){
        helper.saveEventhelperMethod(component, event, helper);        
    }
   
})