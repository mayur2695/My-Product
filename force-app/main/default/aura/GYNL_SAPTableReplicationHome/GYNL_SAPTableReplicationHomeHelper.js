({
    changeSelectedFlagHelper : function(component, isSelected) {
        let availableSAPFields = component.get("v.availableSAPFields");
        for(let field of availableSAPFields) {
            field.isSelected = isSelected;
        }
        component.set("v.availableSAPFields", availableSAPFields);
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
    searchTable : function(component, searchPara) {
        
        console.log("Check point 4: "+searchPara);
        if(searchPara.length >= 3) {
            component.set("v.spinnerFlag", true);
            console.log("Check point 6: "+searchPara);
            var action = component.get("c.searchSAPTable");
            action.setParams({ 
                searchPara : searchPara,
                systemId : component.get("v.systemId")
            });        
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    let availableSAPTablesAsString = response.getReturnValue();
                    let availableSAPTables = JSON.parse(availableSAPTablesAsString);
                    
                    let existingTableMap = component.get("v.existingTableMap");
                    for(var element of availableSAPTables) {
                        existingTableMap.forEach((item)=>{
                            if(item.Name == element.value) element.isAdded = true;
                            
                        });
                        
                        
                    }
                    //console.log("Check availableSAPTables: " + JSON.stringify(availableSAPTables));
                    component.set("v.availableSAPTables",availableSAPTables);
                    component.set("v.spinnerFlag", false);
                    
                }     
                
            });
            $A.enqueueAction(action);
        }
        else component.set("v.availableSAPTables",[]);
    },
    tableSelected : function(component, selectedTable) {
        
        let sapTableMap = component.get("v.sapTableMap");
        if(sapTableMap.has(selectedTable))  {
            
            var mappedTableComp = component.find("mappedTable");
        	mappedTableComp.editExisting(selectedTable);
            
        }
        else {
            component.set("v.tableSelected", selectedTable);
            component.set("v.SFDCObjName", selectedTable.replace(new RegExp('\/', "g"), " ").trim());
            component.set("v.loadingFlag", true);
            var action = component.get("c.fetchAllFields");
            action.setParams({ 
                tableName : selectedTable,
                systemId : component.get("v.systemId")
            });        
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.availableSAPFields",JSON.parse(response.getReturnValue()));
                    component.set("v.availableSAPTables", []);
                    component.set("v.openObjectModalFlag", true);
                    component.set("v.loadingFlag", false);
                    
                    
                    
                }     
                
            });
            $A.enqueueAction(action);
        }
        
    }
})