({
    doInit : function(component, event, helper) {
       console.log('tab '+ component.get("v.SelectedTab"));
       helper.helperdoinit(component, event);
    },
    
    handleClick : function(component, event, helper) {
        //console.log('check');     
        component.set("v.NewField",true);
    },
    fetchallSAP : function(component, event, helper) {
        var objName=component.get("v.SelectedTab").toUpperCase();
            objName=objName.replace(/ +/g, "");
            var SystemId = component.get("v.selectedSystemId");
            var picklistIndicator="";
            if(component.get("v.addFieldToItemobject")){
                picklistIndicator="X";
            }
        console.log(component.get("v.selectedSystemId")+'sdfg');
        var action = component.get("c.fetchSAPallFields");
            action.setParams({ 
                businessObject : objName,
                indicator : picklistIndicator,
                SysId : SystemId
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var final=JSON.parse(response.getReturnValue());
                    //console.log('suceess list'+JSON.stringify(final.feed.entry));
                    
                    if(final.feed.entry==undefined){
                        let toastParams = {
                            title: "Warning!!",
                            message:'No Fields avaible on this Object', 
                            type: "warning"
                        };
                        
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams(toastParams);
                        toastEvent.fire();
                    }
                    else{
                        
                        var datalist=[];
                        var finalResult=final.feed.entry;
                        //console.log('data-->'+finalResult.length);
                        if(finalResult.length ==undefined){
							 var data1 = new Object();
							 data1.name=finalResult.content.properties.Field;
							 data1.type=finalResult.content.properties.EdmCoreType;
							 datalist.push(data1);                            
                        }
                        else{
                        for(var i in finalResult){
                            var data = new Object();
                            //console.log(finalResult[i].content);
                            if(finalResult[i].content.properties.Field != undefined)
                                data.name=finalResult[i].content.properties.Field;
                            else
                                data.name='';
                            if(finalResult[i].content.properties.EdmCoreType !=undefined)
                                data.type=finalResult[i].content.properties.EdmCoreType;
                            else
                                data.type='';
                            datalist.push(data);
                            //console.log('value:'+finalResult[i].content.properties.Value);
                            //console.log('Label:'+finalResult[i].content.properties.Description);
                        }
                        }
                        console.log('data'+JSON.stringify(datalist));
                        var objname1 = component.get("v.SelectedTab");
                        helper.checkduplicate(component, event,datalist,objname1,SystemId);
                        //component.set("v.SAPfetchedData",datalist);
                        component.set("v.fetched",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The Field has been fetched successfully.Please select custom fields",
                            "type": "success"
                        });
                        toastEvent.fire();
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
                    
                }
                
            });
            $A.enqueueAction(action);
    },
    handlecreate : function(component, event, helper) {
        //var recId = component.get("v.recordId");
        component.set("v.errorSection",false);
        var label1 =component.get("v.labelOfField");
        var Name1 = label1.replace(/ /g, "_")+'__c';
        //var Name1 =component.get("v.Name");
        var fetchedData =component.get("v.fetchedData");
        //var Length1 =component.get("v.Length");
        //helper.checkduplicate(component, event);
        console.log('label1'+label1+'--Name1--'+Name1+'-fetchedData-'+fetchedData  + 'addFieldToSF'+component.get("v.SelectedTab"));
        var action = component.get("c.CreateCustomField");
        action.setParams({ 
            Label : component.get("v.labelOfField"),
            Name : Name1,
            Type : component.get("v.Type"),
            objectName  : component.get("v.SelectedTab"),
            AddToSalesforce : component.get("v.addFieldToSF"),
            AddToItemObj : component.get("v.addFieldToItemobject"),
            PicklistValues : component.get("v.fetchedData"),
            systemId : component.get("v.selectedSystemId")
        });
        console.log('action calld');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.NewField",false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The Field has been Created successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
                helper.helperdoinit(component, event);
            } 
            else{
                let toastParams = {
                    title: "Error",
                    message:"Field Not Created!!Try Again", 
                    type: "error"
                };
                
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    handleCancel : function(component, event, helper) {
        component.set("v.NewField",false);
        //$A.get('e.force:refreshView').fire();
        helper.helperdoinit(component, event);
    },
    
    fetchValuefromSAP  : function(component, event, helper) {
        component.set("v.errorSection",false);
        if(component.get("v.labelOfField") != null){
            var objName=component.get("v.SelectedTab").toUpperCase();
            objName=objName.replace(/ +/g, "");
            var label =component.get("v.labelOfField");
            var picklistIndicator="";
            if(component.get("v.addFieldToItemobject")){
                picklistIndicator="I";
            }
            var action = component.get("c.fetchSAPPicklist");
            action.setParams({ 
                businessObject : objName,
                fieldName : label,
                indicator : picklistIndicator,
                SysId : component.get("v.selectedSystemId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var final=JSON.parse(response.getReturnValue());
                    //console.log('suceess list'+JSON.stringify(final));
                    //console.log('suceess list'+JSON.stringify(final.feed.entry));
                    
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
                        for(var i in finalResult){
                            var data = new Object();
                            if(finalResult[i].content.properties.Value != undefined)
                                data.key=finalResult[i].content.properties.Value;
                            else
                                data.key='';
                            if(finalResult[i].content.properties.Description !=undefined)
                                data.value=finalResult[i].content.properties.Description;
                            else
                                data.value='';
                            datalist.push(data);
                            //console.log('value:'+finalResult[i].content.properties.Value);
                            //console.log('Label:'+finalResult[i].content.properties.Description);
                        }
                        console.log('data'+JSON.stringify(datalist));
                        var keyList=[];
                        for(var i in datalist){
                            keyList.push(datalist[i].key);
                        }
                        console.log('KeyList'+keyList.join());
                        component.set("v.PickListvalue",keyList.join());
                        component.set("v.fetchedData",datalist);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The Field Values has been feched successfully.",
                            "type": "success"
                        });
                        toastEvent.fire();
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
                    
                }
                
            });
            $A.enqueueAction(action);
            
            
        }
        else{
            component.set("v.errorSection",true);
            component.set("v.AddErrorMessage",'Enter the **Custom Field Name**');
        }
    },
    
    HandlechangePicklist  : function(component, event, helper) {
        if(component.get("v.Type") == 'Picklist'){
            component.set("v.Pickval",true);
        }   
        else{
            component.set("v.Pickval",false);
        }
    },
    changeobject : function(component, event, helper) {
        var label=component.get("v.labelOfField");
        var data=component.get("v.SAPfetchedData");
        for(var i in data){
            if(data[i].name==label){
                var datatype=data[i].type.replace('Edm.','').trim();
                var typeval='';
                if(datatype=="String"){
                    typeval='Text';
                }
                if(datatype=="Decimal"){
                    typeval='Number';
                }
                if(datatype=="Checkbox"){
                    typeval='Checkbox';
                }
                if(datatype=="DateTime"){
                    typeval='Date';
                }
                if(datatype=="Currency"){
                    typeval='Currency';
                }
                if(datatype=="Picklist"){
                    typeval='Picklist';
                }
                component.set("v.Type",typeval);
            }
        }
        
    }
})