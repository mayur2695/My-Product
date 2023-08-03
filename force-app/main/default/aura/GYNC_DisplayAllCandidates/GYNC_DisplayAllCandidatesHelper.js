({
    getData : function(component){
        component.set("v.totalRows",0);
        component.set("v.loadOffset",1);
        component.set("v.currentCount",10);
        
        // call apex class method
        var getPositionId=component.get("v.recordId");
        var action = component.get("c.getCandidateRecords");
        action.setParams({
            //how many rows to load during initialization
            "initialRows" : component.get("v.initialRows"),
             PositionId:getPositionId  
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var toastReference = $A.get("e.force:showToast");
            
            if(state == "SUCCESS"){
                var CandidateWrapper = response.getReturnValue();
                  if(CandidateWrapper.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",CandidateWrapper.totalRecords);  
                    
                    var candidateList = CandidateWrapper.candidateList;
                    //  alert(candidateList[0].Attachments[0].Name);
                    // play a for each loop on list of account and set Candidate URL in custom 'candidateName' field
                    candidateList.forEach(function(candidate){
                        candidate.candidateName = '/'+candidate.Id;
                        });
                    // set the updated response on data aura attribute  
                    component.set("v.data",candidateList);
                    // display a success message  
                   /* toastReference.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : CandidateWrapper.message,
                        "mode" : "dismissible"
                    });
                    toastReference.fire();*/
                }
                else{ // if any server side error, display error msg from response
                    toastReference.setParams({
                        "type" : "Error",
                        "title" : "Error",
                        "message" : CandidateWrapper.message,
                        "mode" : "sticky"
                    }); 
                    toastReference.fire();
                }
            }
            else{ // if any callback error, display error msg
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'An error occurred during Initialization '+state,
                    "mode" : "sticky"
                });
                toastReference.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    loadData : function(component){
        var getPositionId=component.get("v.recordId");
        return new Promise($A.getCallback(function(resolve){
            var limit = component.get("v.initialRows");
            var offset = component.get("v.currentCount");
            var totalRows = component.get("v.totalRows");
            if(limit + offset > totalRows){
                limit = totalRows - offset;
            }
            var action = component.get("c.loadCandidateRecords");
            action.setParams({
                "rowLimit" :  limit,
                "rowOffset" : offset,
                PositionId:getPositionId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                var newData = response.getReturnValue();
                // play a for each loop on list of new candidates and set Candidate URL in custom 'candidateName' field
                newData.forEach(function(candidate){
                    candidate.candidateName = '/'+candidate.Id;
                });
                resolve(newData);
                var currentCount = component.get("v.currentCount");
                currentCount += component.get("v.initialRows");
                // set the current count with number of records loaded 
                component.set("v.currentCount",currentCount);
            });
            $A.enqueueAction(action);
        }));
    }
})