({
    handleCreateOLT: function(component, event)  
    {
        debugger;
        console.log('inside handleCreateOLT');
        /*var action = component.get("c.createTemplate");
        var offerlettertemp=component.get("v.newOfferLetterTemplate");
            action.setParams({
                offerlettertemplate
            });*/
        var temp=component.get("v.newOfferLetterTemplate");
        console.log('temp->'+JSON.stringify(temp));
        
        var action=component.get("c.createTemplate");
        console.log('action->'+action);
        action.setParams({ 
            "template": temp
        })
        // Configure the response handler for the action
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State->'+state);
            if(state === "SUCCESS") {
                component.set("v.message", "Template created successfully");
                component.set("v.parentId", response.getReturnValue().Id);
                var toastReference = $A.get("e.force:showToast");
               toastReference.setParams({
                type:"Success",
                title:"Success",
                message:"Email Template is successfully created.",
                mode:"dismissible"
                   });
            toastReference.fire();
                
            }
            else if (state === "ERROR") {
                console.log('Problem saving Template, response state: ' + state);
                alert("Failed");
            }
            else {
                console.log('Unknown problem, response state: ' + state);
                alert("Unknown error");
            }
                
        });
 
        // Send the request to create the new contact
        $A.enqueueAction(action);
        component.set("v.isOpen",true);
    },
    })
    /*handleUploadFinished: function (cmp, event) {
        console.log('inside handleUploadFinished');
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Logo uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },*/
    /*handleClick: function (cmp,event){
        component.set("v.isOpen",true);
    },*/

/*doInit: function (component, event, helper) {
        var orderItemId = component.get("v.recordId");
       console.log('orderItemID->'+orderItemId);
        console.log(orderItemId);
        var action = component.get("c.fetchSalesAgreement");
        action.setParams({
          "orderItemid":orderItemId
      });
        action.setCallback(this, function(response){
                var state = response.getState();
            console.log("state->"+state);
                if (state === "SUCCESS") {
                    var listItems = response.getReturnValue();
                    console.log('response->'+JSON.stringify(listItems));
                    component.set("v.saList", listItems);
                }
        });
       
        $A.enqueueAction(action);
    },*/