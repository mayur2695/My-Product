({
    addingDataToRows : function(component,mapList,helper) {
        //this.OptionSelected(component,event);
        var mappingList = component.get("v.mappingList");
        if(mapList != undefined && mapList.length != 0){
            for(var str of mapList){
                mappingList.push(str);
            }  
        }
        else{
            mappingList.push({"sapField" : "","SFDCField" : ""});
        }
        component.set("v.mappingList",mappingList); 
    },
    fetchObjectNames : function(component){
        var action = component.get('c.fetchObjectNames');
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v.businessObjectList", opts);
            }
        });
        $A.enqueueAction(action);  
    },
    OptionSelected : function(component,event){
        component.set("v.loadingSpinner","true");
        component.set("v.mappingList",[]);
        //alert(component.get("v.selectedObject"));
        var onSelectedOption = component.get('c.fetchDependantPickListValues');
        onSelectedOption.setParams({
            selectedOption : component.get("v.selectedObject"),
            systemId : component.get("v.systemId")
            //event.getSource().get("v.value")
        });
        var mapList =[];
        onSelectedOption.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var responseAsString = response.getReturnValue();
                if(namespace != null && namespace != "c") { 
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                }
                var allPickListValues = JSON.parse(responseAsString);
                component.set("v.optionsSAP",allPickListValues.SAPAPIFields.sort());
                component.set("v.optionsSFDC",allPickListValues.SFDCFields.sort());
                component.set("v.LineItemList",allPickListValues.LineItemList.sort());
                console.log("heck 55: "+ JSON.stringify(allPickListValues));
                if(allPickListValues.mappingString != '' && allPickListValues.mappingString != null){
                    mapList = JSON.parse(allPickListValues.mappingString);
                }
                this.addingDataToRows(component,mapList);
                component.set("v.loadingSpinner","false");
            }
        });
        $A.enqueueAction(onSelectedOption);  
    },
    saveMapping : function(component){
        var mappingList = JSON.stringify(component.get("v.mappingList"));
        console.log('mappingList'+mappingList);
        var saveMapping = component.get("c.saveMappingList");
        saveMapping.setParams({mappingListFront: mappingList, 
                               SelectedOption :component.get("v.selectedObject"),
                               systemId: component.get("v.systemId")});
        saveMapping.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Congrats, Your mapping has been saved!",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(saveMapping); 
    },
    closeMapping : function(component,event){
        var indexChild = event.currentTarget.id;
        var mappingList = component.get("v.mappingList");
        mappingList.splice(indexChild,1);
        component.set("v.mappingList",mappingList); 
    }
})