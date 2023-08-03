({
	doSave : function(component, event, helper) 
    {
        var Name =component.get("v.CandidateObj.Name");
      if(Name == null || Name == "")// throw an error if required fields are blank
      {
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "ERROR!",
                    "message": "Please fill up all the required fields"
                });
                toastEvent.fire();
      }
      else
      {
        
                 /** Server side controller calling logic. **/
        var PositionId = component.get("v.PositionId");
        component.set("v.CandidateObj.GYNCF_Position__c	", PositionId);
        //Calling server side controller's saveCandidate() method.
        var action = component.get("c.saveCandidate");
        //Set method parameter of saveCandidate() method.
        action.setParams({"Candidate": component.get("v.CandidateObj")});
        
        action.setCallback(this, function(response){
            //<response.getState()> return response status as SUCCESS/ERROR/INCOMPLETE etc.
            var state = response.getState();
            //If response from server side is <SUCCESS>, then we will display a success message.
            if (state === "SUCCESS")
            {
                var CandidateId = response.getReturnValue();
                component.set("v.CandidateId", CandidateId);
                //Success message display logic.
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                     type: 'success',
                    "title": "Success!",
                    "message": "Candidate record has been inserted successfully."
                                    });
                toastEvent.fire();
                // close model box
                component.set("v.NewCanIsOpen", false);
                // set all the lightning input component values to default
                component.set("v.CandidateObj.Name", null);
                component.set("v.CandidateObj.GYNCF_Phone_Number__c", null);
                component.set("v.CandidateObj.GYNCF_Email__c", null);
                component.set("v.CandidateObj.GYNCF_Location__c", "Carmel");
                // refresh the page         
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") 
            {
                //Offline message display logic.
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "OFFLINE!",
                    "message": "You are in offline."
                });
                toastEvent.fire();
            }
            else if (state === "ERROR") 
            {
                //Error message display logic.
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type":"error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
            else 
            {
                //Unknown message display logic.
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "UNKOWN!",
                    "type":"error",
                    "message": "Unknown error."
                });
                toastEvent.fire();
            }
                 
          });
            $A.enqueueAction(action);
      }
    },
     closeModel: function(component, event, helper) 
    {
       //for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.NewCanIsOpen", false);
        // set all the lightning input component values to default
         component.set("v.CandidateObj.Name", null);
         component.set("v.CandidateObj.GYNCF_Phone_Number__c", null);
         component.set("v.CandidateObj.GYNCF_Email__c", null);
         component.set("v.CandidateObj.GYNCF_Location__c", "Carmel");
    }
})