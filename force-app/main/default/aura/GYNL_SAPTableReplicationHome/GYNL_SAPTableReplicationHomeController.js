({
    doInit : function(component, event, helper) {
        
    },
    refreshComponent : function(component, event, helper) {
        //let systemId = component.get("v.systemId");
        component.set("v.loadingFlag", "true");
        component.set("v.refreshFlag", "false");
        setTimeout(function(){ 
            component.set("v.loadingFlag", "false");
            component.set("v.refreshFlag", "true"); 
        }, 1000);
        
    },
    handleSearchEvent : function(component, event, helper) {
        if(event.getParam("origin") == "tableSearch" && event.getParam("operationType") == "search")
            helper.searchTable(component, event.getParam("searchPara"));
        if(event.getParam("origin") == "tableSearch" && event.getParam("operationType") == "select")
            helper.tableSelected(component, event.getParam("seletedValue"));
    },
    
    
    closeModel : function(component, event, helper) {
        component.set("v.openObjectModalFlag", false);
    },
    selectAllFields : function(component, event, helper) {
        helper.changeSelectedFlagHelper(component, true);
    },
    unSelectAllFields : function(component, event, helper) {
        helper.changeSelectedFlagHelper(component, false);
    },
    createObj : function(component, event, helper) {
        component.set("v.loadingFlag", true);
        var sfdcObjName = component.get("v.SFDCObjName");
        if(sfdcObjName.includes("/")) {
            alert("/ is not allowered in a sfdc label name.");
            return;
        }
        if(!isNaN(sfdcObjName.charAt(0))) {
            alert(sfdcObjName.charAt(0) +" is not allowered in the starting.");
            return;
        }
        
        
        
        var action = component.get("c.customSFDCObj");
        action.setParams({ 
            tableSelected : component.get("v.tableSelected"),
            SFDCObjName : sfdcObjName.trim(),
            selectedFieldsString : JSON.stringify(component.get("v.availableSAPFields")),
            systemId : component.get("v.systemId")
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("Call apex: "+ JSON.stringify(response.getError()));
            if (state === "SUCCESS") {
                
                //alert("Check: "+ response.getReturnValue());
                helper.showToatMsgHelper('success', 'Success!', 'SAP Table Successfully Added.');
                component.set("v.openObjectModalFlag", false);
                $A.get('e.force:refreshView').fire();
                
                
            }  
            else {
                alert("There is some error. Please try again later.");
            }
            component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
    
	}
})