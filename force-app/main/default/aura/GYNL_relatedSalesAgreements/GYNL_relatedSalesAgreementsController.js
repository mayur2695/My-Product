({
    doInit: function (component, event, helper) {
        var orderItemId = component.get("v.recordId");
        console.log('orderItemID->'+orderItemId);
        var action = component.get("c.fetchSalesAgreement");
        action.setParams({
            "orderItemid":orderItemId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state->"+state);
            if (state === "SUCCESS") {
                var listItems = response.getReturnValue();
                var namespace = "GYANSYS";
                console.log('Namespace->'+namespace);
                var responseAsString = listItems;
                console.log('Response as String->'+responseAsString);
              //  debugger;
               // console.log('response->'+JSON.stringify(listItems));
                if(namespace != null && namespace != "c") {
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                }
                var results=JSON.parse(responseAsString);
              //  console.log('Results->'+results);
                component.set("v.saList", results);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    updateSA: function(component,event,helper){
        // debugger;
        console.log('Inside save function');
        //       console.log(event.getSource());
        //var chosenVal = event.getSource().get("v.value");
        var chosenVal= component.find("uzr").get("v.value");
        console.log('SA ID'+chosenVal);
        var orderItemId = component.get("v.recordId");
        console.log('order Id->'+ orderItemId);
        var action1 = component.get("c.updateSalesAgreement");
        console.log(action1);
        action1.setParams({
            "orderItemid":orderItemId,
            "selectedSA": chosenVal
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("state->"+state);
            if (state === "SUCCESS") {
                console.log('2nd method success');
            }
        });
        $A.enqueueAction(action1); 
        $A.get('e.force:refreshView').fire();
        
    }
})