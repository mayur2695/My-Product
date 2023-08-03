({
	helperdoinit : function(component, event) {
		console.log('inside helper');
         if(component.get("v.SelectedTab") === 'Quotation' || component.get("v.SelectedTab") === 'Sales Order' || component.get("v.SelectedTab") === 'Invoice' ){
            component.set("v.forItemfield",true);
        }
        component.set("v.labelOfField",null);
        component.set("v.Type",null);
        component.set("v.PickListvalue",null);
        component.set("v.addFieldToSF",false);
        component.set("v.addFieldToItemobject",false);
        var appEvent = $A.get("e.c:RefershCustomtable");
        appEvent.setParams({
            "firetableDonit" : "RefershTable" });
        appEvent.fire();
	},
    
    checkduplicate : function(component, event,datalist,objName,SystemId){
        var action = component.get("c.checkduplicatevalue");
        action.setParams({
            ObjName : objName,
            SystemId : SystemId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + JSON.stringify(response.getReturnValue()));
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var responseAsString = response.getReturnValue();
                if(namespace != null && namespace != "c") {
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                } 
                console.log("From server as string: " + responseAsString);
               
                var customlist = JSON.parse(responseAsString);
                console.log(datalist.length);
                for(var i = 0; i< customlist.length; i++){
                     console.log(i+ '***inside first for**' + customlist[i]); 
                    for(var j =0; j< datalist.length ;j++){
                        console.log(i+ '***inside second for**' + datalist[i]); 
                        if(datalist[j].name == customlist[i].Label__c){
                                datalist.splice(j, 1);
                        }
                    }
                }
                console.log(JSON.stringify(datalist)+'datalist####');
                component.set("v.SAPfetchedData",datalist);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})