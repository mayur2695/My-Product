({
    deleteConfig : function(component, event, helper) {
        //alert(event.getSource().get("v.name"));
        let configDetail = event.getSource().get("v.name").split("-");
        component.set("v.tableSelected", event.getSource().get("v.name"));
        component.set("v.deleteConfigModalFlag", true);
    },
    deleteConfirmed : function(component, event, helper) {
        component.set("v.loadingFlag", true);
       var action = component.get("c.deleteObjectMapping");
        action.setParams({ 
            systemId : component.get("v.systemId"),
            tableName : component.get("v.tableSelected")
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let statusMg = response.getReturnValue();
                if(statusMg == "success") {
                    helper.showToatMsgHelper("success", "Success!", "Object Mapping successfully deleted.");                    
                }
                else {
                    helper.showToatMsgHelper("error", "Error!", statusMg);
                }
                component.set("v.deleteConfigModalFlag", false);
                helper.loadAllExistingMapping(component, event, helper);   
                component.set("v.loadingFlag", false);
                
            }     
            
        });
        $A.enqueueAction(action);
    },
    handleSearchEvent : function(component, event, helper) {
        //alert("3");
        if(event.getParam("origin") == "fieldSearch" && event.getParam("operationType") == "search")
            helper.searchFieldHelper(component, event.getParam("searchPara"));
        if(event.getParam("origin") == "fieldSearch" && event.getParam("operationType") == "select")
            helper.fieldSelectedHelper(component, event.getParam("seletedValue"));
    },
	doInit : function(component, event, helper) {
        helper.loadAllExistingMapping(component, event, helper);    
        helper.initializeEmpApi(component);
	},
    StartMassSync : function(component, event, helper) {
        //alert("Mass sync started for testing");
        component.set("v.loadingFlag", true);
        var action = component.get("c.startMassSyncSAP");
        action.setParams({ 
            tableNameSAP : event.getSource().get("v.name"),
            systemId : component.get("v.systemId")
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loadingFlag", false);
                let msg = response.getReturnValue();
                if(msg == 'success') return helper.showToatMsgHelper("success", "Success!", "Mass Sync Successfully Started.");
                if(msg.includes("Error")) return helper.showToatMsgHelper("error", "Error!", msg);
                
                helper.showToatMsgHelper("warning", "", msg);
                
                
            }  
            else {
                helper.showToatMsgHelper("error", "Error!", "There is some error. Please try again later.");
                //alert("");
            }
            component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
    },
    closeModel : function(component, event, helper) {
        component.set("v.openObjectModalFlag", false);
        component.set("v.deleteConfigModalFlag", false);
    },
    editTableMaping : function(component, event, helper) {
        //alert(event.getSource().get("v.name"));
        //console.log("Check filter mapping: "+JSON.stringify(component.get("v.fieldMapping")));
        helper.editExistingMapping(component, event.getSource().get("v.name"));
        
    },
    handleEditEvent : function(component, event, helper) {
        helper.editExistingMapping(component, event.getParam("arguments").selectedTableName);
    },
    saveFilter : function(component, event, helper) {
        component.set("v.loadingFlag",true);
        var action = component.get("c.storeFilterData");
        action.setParams({ 
            configRecId : component.get("v.selectedConfigId"),
            availableFilter : JSON.stringify(component.get("v.existingFilter"))
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("Call apex: "+ JSON.stringify(response.getError()));
            if (state === "SUCCESS") {
                helper.saveAllField(component, event, helper);
                
                //alert("Check: "+ response.getReturnValue());
                //helper.showToatMsgHelper('success', 'Success!', 'Filters Added Successfully.');
                //component.set("v.openObjectModalFlag", false);
                //$A.get('e.force:refreshView').fire();
                //component.set("v.loadingFlag",false);
                
                
                
            }  
            else {
                alert("There is some error. Please try again later.");
            }
            //component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
        
        
        
        
    }
})