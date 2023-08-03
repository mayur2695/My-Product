({
    doInitMethod: function (component, event) {
        var SystemId=component.get("v.SystemId");
        console.log('helper'+component.get("v.SystemId"));
        var action = component.get("c.GetRecords");
        action.setParams({systemId:SystemId});
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var namespace = $A.get("$Label.c.GYNCL_Namespace");
var responseAsString = response.getReturnValue();
if(namespace != null && namespace != "c") {
responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
}
            var results=JSON.parse(responseAsString);
            
            console.log('data '+JSON.stringify(results));
            if(results.length > 0){
            for (var i in results){
                
                if(results[i].Name =="Sales Order"){
                    component.set("v.SalesOrderList",results[i]);
                }
                if(results[i].Name =="Invoice"){
                    component.set("v.InvoiceList",results[i]);
                }
                if(results[i].Name =="Equipment"){
                    component.set("v.EquipmentList",results[i]);
                }
                if(results[i].Name =="List Price"){
                    component.set("v.ListPriceList",results[i]);
                }
                if(results[i].Name =="Customer"){
                    component.set("v.CustomerList",results[i]);
                }
                if(results[i].Name =="Quotation"){
                    component.set("v.QuotationList",results[i]);
                }
                if(results[i].Name =="Materials"){
                    component.set("v.MaterialList",results[i]);
                }
                //added for pricing by Manisha(2/11) 
                 if(results[i].Name =="Pricing"){
                    component.set("v.CustomerList",results[i]);
                }
                // added for BOM by Indrajit(2/11)
                if(results[i].Name =="BOM"){
                    component.set("v.CustomerList",results[i]);
                }
            }
            }
            else{
            	component.set("v.SalesOrderList",[]);
                component.set("v.InvoiceList",[]);
                component.set("v.EquipmentList",[]);
                component.set("v.CustomerList",[]);
                component.set("v.QuotationList",[]);
                component.set("v.MaterialList",[]);              
            }
        });
        $A.enqueueAction(action);   
    },
    getObjectList : function(component, event, helper){
        var action = component.get('c.listAllObject');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
var responseAsString = response.getReturnValue();
if(namespace != null && namespace != "c") {
responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
}
                var responseValue = JSON.parse(responseAsString);
                var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i].split('####')[0],
                        key : responseValue[i].split('####')[1]
                    });
                }
                lstOptions.sort();
                component.set('v.objectList', lstOptions);
            }
        });
        $A.enqueueAction(action);
    },
    getOrderValues : function(component, event, helper){
        var action = component.get('c.OrderStatusValues');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
var responseAsString = response.getReturnValue();
if(namespace != null && namespace != "c") {
responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
}
                var responseValue = JSON.parse(responseAsString);
                var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i],
                        key : responseValue[i]
                    });
                }
                lstOptions.sort();
                component.set('v.orderStatusList', lstOptions);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*showScheduledBatch : function(component, event, helper){
        var action = component.get('c.getBatchRecords');
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state'+state);
            if(state === 'SUCCESS'){
                var results = response.getReturnValue();
                for(var i in results){
                   console.log("enter");
                	if(results[i].includes("Sales Order")){
                    component.set("v.SalesOrderBatchList",results[i]);
                }
                if(results[i].includes("Invoice")){
                    component.set("v.InvoiceBatchList",results[i]);
                }
                if(results[i].includes("Equipment")){
                    component.set("v.EquipmentBatchList",results[i]);
                }
                if(results[i].includes("Customer")){
                    console.log("enter");
                    component.set("v.CustomerBatchList",results[i]);
                        console.log('Customer'+' '+results[i]);
                }
                if(results[i].includes("Quotation")){
                    component.set("v.QuotationBatchList",results[i]);
                }
                if(results[i].includes("Materials")){
                    component.set("v.MaterialBatchList",results[i]);
                }
                }
            }
        });
        $A.enqueueAction(action);
    }*/
    
    addfilterstoField : function(component, event, helper,ObjectName,fieldSAPName,picklistIndicator){
        console.log(component.get("v.SystemId"));
        var SystemId = component.get("v.SystemId");
        var action = component.get("c.AddGroupMemberfromSAP");
        action.setParams({
            Objname : ObjectName,
            FieldName : fieldSAPName,
            indicator : picklistIndicator,
            SySId : SystemId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState() === 'SUCCESS'){
                //console.log(JSON.parse(response.getReturnValue()));
                var final=JSON.parse(response.getReturnValue());
                
                if(final.feed.entry==undefined){
                    let toastParams = {
                        title: "Warning!!",
                        message:'No Picklist value is available for this field', 
                        type: "warning"
                    };
                    
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams(toastParams);
                    toastEvent.fire();
                }
                else{
                    var datalist=[];
                    var finalResult=final.feed.entry;
                    if(finalResult.length ==undefined){
                        var data1 = new Object();
                        data1.label=finalResult.content.properties.value +'-'+finalResult[i].content.properties.Description;
                        data1.value=finalResult.content.properties.value;
                        datalist.push(data1);                            
                    }
                    else{
                        for(var i in finalResult){
                            var data = new Object();
                            if(finalResult[i].content.properties != undefined){
                                if(finalResult[i].content.properties.Value != undefined && finalResult[i].content.properties.Value != null  && finalResult[i].content.properties.Value != '')
                                {
                                    var str = '';
                                    if(finalResult[i].content.properties.Description != undefined){
                                        str='-'+finalResult[i].content.properties.Description;
                                    }
                                    data.label=finalResult[i].content.properties.Value+str;
                                    data.value=finalResult[i].content.properties.Value;
                                    datalist.push(data);
                                }
                            }
                        }
                    }
                    //console.log('data'+JSON.stringify(datalist));
                    component.set("v.FilterValue",datalist);
                }
            }
            else{
                //console.log(response.getError());
                let errors = response.getError();
                let message = ''; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    for (var i = 0; i < errors.length; i++) { 
                        message =  errors[i].message;
                    }
                }
                // Display the message
                //console.error(message);
                let toastParams = {
                    title: "Error",
                    message:message, 
                    type: "error"
                };
                
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
                component.set("v.AddfiltertotheField",false);
            }
            
        });
        $A.enqueueAction(action);
    }
});