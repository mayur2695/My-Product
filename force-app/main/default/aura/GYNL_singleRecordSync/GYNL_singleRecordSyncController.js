({
    startSyncRecord : function(component, event, helper) {
        component.set("v.loadingFlag", true);
        //alert("Test: "+ event.getSource().get("v.name"));
        let searchPara = component.get("v.searchPara");
        let recName = event.getSource().get("v.name");
        if(!searchPara.includes(recName)) searchPara = recName;
        var action = component.get("c.syncSingleRecord");
        action.setParams({ 
            objNameSAP : component.get("v.objNameSAP"),
            systemId : component.get("v.systemId"),
            searchPara : searchPara
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                setTimeout(function(){ 
                    helper. showTostMsg(component,"success", "Success!", "Record Synced successfully.");
                }, 3000);
                //component.set("v.configRec", response.getReturnValue());
                //component.set("v.loadingFlag", response.getReturnValue().GYNCF_Mass_Sync_Live__c);
                
            }  
            else {
                
                alert("There is some error. Please try again later.");
            }
            //component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
        
        
    },
    doInit : function(component, event, helper) {
        component.set("v.loadingFlag", true);
        var action = component.get("c.findConfigRec");
        action.setParams({ 
            objNameSAP : component.get("v.objNameSAP"),
            systemId : component.get("v.systemId")
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.configRec", response.getReturnValue());
                //component.set("v.loadingFlag", response.getReturnValue().GYNCF_Mass_Sync_Live__c);
                
            }  
            else {
                
                alert("There is some error. Please try again later.");
            }
            component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
    },
    searchSAP : function(component, event, helper) {
        let searchPara = component.get("v.searchPara");
        if(searchPara.length > 0) {
            component.set("v.loadingFlag", true);
            let searchResultList = [];
            searchResultList.length = 0;
            component.set("v.searchResultList", searchResultList);
            var action = component.get("c.searchRecord");
            action.setParams({ 
                searchPara : searchPara,
                objNameSAP : component.get("v.objNameSAP"),
                systemId : component.get("v.systemId")
            });   
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    component.set("v.searchResultList", response.getReturnValue());     
                    
                }  
                else {
                    alert("There is some error. Please try again later.");
                }
                component.set("v.loadingFlag", false);
                
            });
            $A.enqueueAction(action);
        }
        else {
            component.set("v.searchResultList", []);
        }
    }
})