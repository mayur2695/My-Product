({
    saveAllField : function(component, event, helper) {
        let allSAPFields = component.get("v.allSAPFieldsSelectedObj");
        let fieldMapping = component.get("v.fieldMapping");
        let existingField = [];
        let deleteFields = [];
        fieldMapping.forEach((item)=>{
            existingField.push(item.sapField);
        });
         
        allSAPFields.forEach((item)=>{
            //fields already added
            if(item.isSelected && existingField.indexOf(item.fieldName) != -1) {
            	item.isAdded = true;
        	}
            else {
            item.isAdded = false;
        }
            
            //old fields to be deleted
            if(!item.isSelected && existingField.indexOf(item.fieldName) != -1) deleteFields.push(item.fieldName);
            
            
        });
        var action = component.get("c.updateFieldMap");
        action.setParams({ 
            configRecId : component.get("v.selectedConfigId"),
            selectedFieldsString : JSON.stringify(allSAPFields),
            deleteFields : deleteFields
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("Call apex: "+ JSON.stringify(response.getError()));
            if (state === "SUCCESS") {
                let statusMsg = response.getReturnValue();
                if(statusMsg == "success") {
                    helper.showToatMsgHelper('success', 'Success!', 'Filters Added Successfully.');
                    
                }
                else {
                    helper.showToatMsgHelper('error', 'Error!', statusMsg);
                    
                }
                component.set("v.openObjectModalFlag", false);
                    $A.get('e.force:refreshView').fire();
                    component.set("v.loadingFlag",false);
                //alert("Check: "+ response.getReturnValue());
                
                
                
                
            }  
            else {
                alert("There is some error. Please try again later.");
            }
            //component.set("v.loadingFlag", false);
            
        });
        $A.enqueueAction(action);
        
            
	},
    loadAllExistingMapping : function(component, event, helper) {
        component.set("v.baseURL",window.location.origin);
        var action = component.get("c.findExistingTableMapping");
        action.setParams({ 
            systemId : component.get("v.systemId")
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let existingTableMapAsString = response.getReturnValue();
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                
                if(namespace != null && namespace != "c") {
                    existingTableMapAsString = existingTableMapAsString.replace(new RegExp(namespace +"__", 'g'), "");
                }
                
                
                
                let existingTableMap = JSON.parse(existingTableMapAsString);
                let sapTableMap = new Map();
                component.set("v.existingTableMap", existingTableMap);
                existingTableMap.forEach((item)=>{
                    sapTableMap.set(item.Name, item);
                });
                component.set("v.sapTableMap", sapTableMap);
                
            }     
            
        });
        $A.enqueueAction(action);
    },
    searchFieldHelper : function(component, searchPara) {
        
        let availableFields = [];
        var fieldMapping = component.get("v.fieldMapping");
        for(var obj of fieldMapping) {
            if(obj.sapField.toLowerCase().includes(searchPara.toLowerCase())) {
                availableFields.push({"value":obj.sapField});
            }
        }
        if(availableFields.length > 0) {
            component.set("v.availableFields", availableFields);
        }
        else {
            component.set("v.availableFields", []);
        }
        
    },
    fieldSelectedHelper : function(component, seletedValue) {
        component.set("v.availableFields", []);
        var fieldMapping = component.get("v.fieldMapping");
        for(var obj of fieldMapping) {
            if(obj.sapField.toLowerCase() == seletedValue.toLowerCase()) {
                var seletedField = Object.assign({}, obj);
                break;
            }
        }
        var existingFilter = component.get("v.existingFilter");
        //alert(JSON.parse(seletedField.SFDCField).sfdcFieldType);
        existingFilter.push({
            "sapFieldName":seletedField.sapField,
            "valueLow":"",
            "valueHigh":"",
            "type":JSON.parse(seletedField.SFDCField).sfdcFieldType,
            "sfdcfieldName": JSON.parse(seletedField.SFDCField).fieldValue,
            "operationType":"EQ"
        });
        component.set("v.existingFilter", existingFilter);
        //existingFilter
    },
    showToatMsgHelper : function(type, title, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": msg
        });
        toastEvent.fire();
    },
    editExistingMapping : function(component, editTable) {
        component.set("v.loadingFlag", true);
        component.set("v.tableSelected", editTable);
        let existingTableMap = component.get("v.existingTableMap");
        let sapTableMap = component.get("v.sapTableMap");
        if(sapTableMap.has(editTable)) {
            let table = sapTableMap.get(editTable);
            component.set("v.selectedConfigId",table.Id);
            component.set("v.fieldMapping", JSON.parse(table.GYNCF_Field_Maping__c));
            if(table.GYNCF_Available_Fileters__c != null) component.set("v.existingFilter",JSON.parse(table.GYNCF_Available_Fileters__c));
        }
        
        //get all the available field from SAP

        var action = component.get("c.fetchAllFields");
        action.setParams({ 
            tableName : editTable,
            systemId : component.get("v.systemId")
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let allSAPFields = JSON.parse(response.getReturnValue());
                let fieldMapping = component.get("v.fieldMapping");
                let existingField = [];
                fieldMapping.forEach((item)=>{existingField.push(item.sapField);});
                allSAPFields.forEach((item)=>{
                    if(existingField.indexOf(item.fieldName) != -1) item.isSelected = true;                                                                    
                }); 
                component.set("v.allSAPFieldsSelectedObj",allSAPFields);
                component.set("v.loadingFlag", false);
            }     
            
        });
        $A.enqueueAction(action);
        
        component.set("v.openObjectModalFlag", true);
        
        
    },
    initializeEmpApi : function(component) {
        const empApi = component.find("empApi");
        const channel = '/topic/MassSyncTabNew';
        const replayId = -1;
        empApi.onError($A.getCallback(error => {
            console.error('EMP API error: ', JSON.stringify(error));
        }));
        empApi.subscribe(channel, replayId, function(message) {
            
            
            var AllObjData = component.get("v.existingTableMap");
            for(var x in AllObjData){
            	if(AllObjData[x].Id == message.data['sobject'].Id ){
            			let sobjAsString = JSON.stringify(message.data['sobject']);
            	
                        var namespace = $A.get("$Label.c.GYNCL_Namespace");
                        
                        if(namespace != null && namespace != "c") {
                        	sobjAsString = sobjAsString.replace(new RegExp(namespace +"__", 'g'), "");
                    	}
            		    let sobjData = JSON.parse(sobjAsString);
                   		AllObjData[x].GYNCF_Mass_Sync_Live__c = sobjData.GYNCF_Mass_Sync_Live__c;
            			AllObjData[x].GYNCF_Last_Synced__c = sobjData.GYNCF_Last_Synced__c;
            			AllObjData[x].GYNCF_isFLSActive__c = sobjData.GYNCF_isFLSActive__c;
                       
                }
                
    		}
            component.set("v.existingTableMap" , AllObjData);
    	});
	}

})