({
    showBatchLogs : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Log Number', fieldName: 'Id', type: 'url',typeAttributes:{
                label: { fieldName: 'Name' }, 
                target: '_blank'}},
            {label: 'Batch Run Date', fieldName: 'CreatedDate', type: 'date',typeAttributes: {  
                day: 'numeric',  
                month: 'short',  
                year: 'numeric',  
                hour: '2-digit',  
                minute: '2-digit',  
                second: '2-digit',  
                hour12: true}},
            //{label: 'Batch Status', fieldName: 'GYNCF_Apex_Job_Status__c', type: 'text'},
            {
                fieldName: "GYNCF_Apex_Job_Status__c", label: "Batch Status",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    },
                    "iconName": {
                        "fieldName": "displayIconName"
                    }
                }
            },
            {label: 'Message', fieldName: 'GYNCF_Comments__c', type: 'text'},
        ]);
            //console.log(JSON.stringify(component.get("v.columns")));
            var SystemId=component.get("v.SystemId");
            var businessObjectName = component.get("v.ObjectName");
            var action = component.get("c.batchLogs");
            action.setParams({systemId:SystemId,
            bussObjectName:businessObjectName});
            action.setCallback(this, function(response){
            var state = response.getState(); //Checking response status
            var namespace = $A.get("$Label.c.GYNCL_Namespace");
var responseAsString = response.getReturnValue();
if(namespace != null && namespace != "c") {
responseAsString = responseAsString.replace(new RegExp(namespace +"__", 'g'), "");
}
            var results = JSON.parse(responseAsString); 
            results.forEach(function(record){
            if(typeof record.Id != 'undefined'){ 
                if(record.GYNCF_Apex_Job_Status__c == 'Success'){
                record.showClass =  'greencolor';
                record.displayIconName = 'utility:check';  
                }
                else if(record.GYNCF_Apex_Job_Status__c == 'Fail'){
                record.showClass =  'redcolor';
                record.displayIconName = 'utility:close';     
                }
            	else if(record.GYNCF_Apex_Job_Status__c == 'Partially Successful'){
                record.showClass =  'OrangeColor';
                record.displayIconName = 'utility:warning';     
                }
                else{
                record.showClass = '';
                record.displayIconName = '';
                }
                record.Id = '/'+record.Id;
            }
            });
            console.log('results'+JSON.stringify(results));
            component.set("v.data",results);
            //console.log('loglist'+JSON.stringify(component.get("v.data")));
            component.set("v.showModal",true);
            });
            $A.enqueueAction(action);
            
            },
            
            closeModal: function(component, event, helper){
            component.set("v.showModal",false);    
            }
            })