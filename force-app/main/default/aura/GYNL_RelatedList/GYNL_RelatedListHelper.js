({
    callToApex : function(component, event, helper) {
        //console.log('inside helper'  + component.get("v.QuotationCol"));
        //value to the box
        var defaultoption = JSON.stringify(component.get("v.QuotationCol"));
        var Optionlist = [];
        var action = component.get("c.FetchThefields");
        action.setParams({ 
            defaultfield : defaultoption 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var responseAsString = response.getReturnValue();
                if(namespace != null && namespace != "c") {
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                } 
                //console.log("From server as string: " + responseAsString);
                
                var res = JSON.parse(responseAsString);
                for(var i=0; i< res.length; i++){
                    var item = {
                        "label" : res[i].fieldsName,
                        "value" : res[i].FieledAPIName,
                        "type" : res[i].FieldType
                    };
                    Optionlist.push(item);
                    
                }
                //console.log('Optionlist'+JSON.stringify(Optionlist));
                component.set("v.Boxoptions",Optionlist);
                var check = component.get("v.QuotationCol");
                var selectedArr = [];
                for(var i in check){
                    selectedArr.push(check[i].fieldName);
                }
                component.set("v.Boxvaluesselected", selectedArr);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
            //get selected value
            var getlist = component.get("v.Boxvaluesselected");
            console.log('getlist14675'+getlist);
            this.sendNewcolumnToApex(component, event, getlist);
            console.log("open dualbox");
            //component.set('v.ToOpenDualbox',true);
        });
        $A.enqueueAction(action);
    },
    //removed as dynamic query pasrt has been added
    /*getquotelistvalue : function(component, event, AccRecordId) {
        //Apex Call
        //console.log('column check'+JSON.stringify(component.get('v.QuotationCol')));
        var action = component.get("c.FetchTheRecords");
        action.setParams({ AccountId : AccRecordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var responseAsString = response.getReturnValue();
                if(namespace != null && namespace != "c") {
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                } 
                //console.log("From server: " + JSON.stringify(response.getReturnValue()));
                //console.log("From server as string: " + responseAsString);
                
                var records =JSON.parse(responseAsString);
                var length = records.length;
                component.set("v.Listlength",length);
                records.forEach(function(record){
                    record.Id = '/lightning/r/Order/'+record.Id+'/view';
                    if(record.GYNCF_Salesorder__c == ''){
                        record.GYNCF_Salesorder__c = 'NUll';
                    }
                });
                console.log('12345'+JSON.stringify(records));
                var quoteList = component.set('v.QuotationList',records);
                //console.log('quoteList'+quoteList);
                //component.set('v.InvoiceList', responce.Invoice);
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
    },*/
    
    sendNewcolumnToApex : function(component, event,getlist){
        var action = component.get("c.sendNewcolumn");
        action.setParams({ 
            newcolumn : getlist,
            AccountId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                var responseAsString = response.getReturnValue();
                if(namespace != null && namespace != "c") {
                    responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
                } 
                //.log("From server 1111: " + JSON.stringify(response.getReturnValue()));
                //console.log("From server as string2222: " + responseAsString);
                
                var records =JSON.parse(responseAsString);
                var length = records.length;
                component.set("v.Listlength",length);
                //console.log('records'+records);
                
                records.forEach(function(record){
                    record.Id = '/lightning/r/Order/'+record.Id+'/view';
                    //record.Id = record.Id;
                    //alert('out'+ record.GYNCF_Salesorder__c);
                    if(record.GYNCF_Salesorder__c == '' || record.GYNCF_Salesorder__c == undefined){
                        //alert('inside');
                        record.GYNCF_Salesorder__c = 'Null';
                    }
                });
                console.log(`line136: ${JSON.stringify(records)}`);
                var quoteList = component.set('v.QuotationList',records);
                //console.log("From server: " + response.getReturnValue());
                //var res = response.getReturnValue(); 
                //component.set("v.QuotationList",res);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sendcoluntoApex : function(component, event,newcol){
        var col = JSON.stringify(newcol);
        //console.log('col-----------'+col);
        var action = component.get("c.fetchtheColumn");
        action.setParams({ 
            colval : col
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // console.log("From server: " + response.getReturnValue());
                var res = response.getReturnValue();   
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    onloadcolmn : function(component, event){
        
        var action = component.get("c.onloadfechorderrecord");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server:11111 " + response.getReturnValue());
                var res = response.getReturnValue();
                //if(res != null){
                var obj = JSON.parse(res);
                //console.log('res'+  JSON.stringify(obj));
                component.set('v.QuotationCol',obj);
                console.log('res335'+  JSON.stringify(component.get('v.QuotationCol')));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})