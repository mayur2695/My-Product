({
    myAction: function (component, event, helper) {
        //Added By Spandana for Dynamic Theme 06/04
        var themeaction = component.get('c.getActiveTheme');
        
        themeaction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.staticresourceName", response.getReturnValue());
                //    alert('result==='+result);
            }
        });
        $A.enqueueAction(themeaction);

        var action = component.get("c.getImagesFromData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.array", result);
                for (var i = 0; i < response.getReturnValue().length; i++) {
                    console.log(response.getReturnValue()[i].Id);
                }
                
                
                
            }
            else {
                console.log('something bad happend! :: 1');
            }
        });
        $A.enqueueAction(action);

        //Ended By Spandana for Dynamic Theme 06/04
	},
    scriptsLoaded: function(component, event, helper) {
       // alert('gyansys theme script loaded');
    },
    clearGrid : function(component, event, helper) {
       component.set("v.AllProducts",null);
    }
    
    ,

    handleComponentEvent : function(component, event) {
        // set the handler attributes based on event data
        var message = event.getParam("isChecked");
        component.set("v.isVisible", message);
    },
    handleComponentEvent2 : function(component, event) {
        // set the handler attributes based on event data
        var message = event.getParam("isChecked2");
        component.set("v.isVisible2", message);
    },
    handleComponentEvent3 : function(component, event) {
        
        // set the handler attributes based on event data
        var message = event.getParam("isChecked3");
        component.set("v.isVisible3", message);
    }
})