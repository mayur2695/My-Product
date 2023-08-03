({
    showMyToast : function(component, event, statusObj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : statusObj.status,
            type: statusObj.status,
            mode: 'dismissible',
            message: statusObj.statusMessage
            
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    
    ShowMyObjAndIcon : function(component, event, helper) {
        //alert("cehckenter");
        var progress = component.get('v.progress');
        var action = component.get("c.getObjectName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                //alert("enter");
                console.log('Inside  success');
                var allRes = response.getReturnValue();
                var allResponseAsString = JSON.stringify(allRes);
                var namespace = $A.get("$Label.c.GYNCL_Namespace");
                //var responseAsString = response.getReturnValue();
                console.log('Inside  namespace: '+ namespace);
                console.log('Inside  allResponseAsString: '+ allResponseAsString);
                if(namespace != null && namespace != "c") {
                    allResponseAsString = allResponseAsString.replace(new RegExp(namespace +"__", 'g'), "");           
                }
                console.log('Inside  responseAsString: '+ allResponseAsString);
                var allResponse = JSON.parse(allResponseAsString);
                console.log(JSON.stringify(allResponse));
                var TimeZone = allResponse.Timezone;
                
                var allValues =allResponse.ConfigObjVal;
                console.log('allValues: '+ JSON.stringify(allValues));
                for(var i=0;i<allValues.length;i++){
                    var ToBeSynced = allValues[i].GYNCF_To_Be_Synced__c;
                    var Synced = allValues[i].GYNCF_Synced__c;
                    
                    if(allValues[i].GYNCF_Last_Synced__c != undefined){
                        //console.log('before=='+ allValues[i].GYNCF_Last_Synced__c.split('T')[1].substring(1,8));
                        //console.log('before1=='+ allValues[i].GYNCF_Last_Synced__c.split('T')[0].format(dd-mm-yyyy));
                        var d = new Date(allValues[i].GYNCF_Last_Synced__c);
                        allValues[i].GYNCF_Last_Synced__c= 'Last Synced : '+d.toLocaleString('en-US', { timeZone: TimeZone });
                        //allValues[i].GYNCF_Last_Synced__c = ('Last Synced : '+d.getUTCDate()+'/'+d.getUTCMonth()+'/'+d.getUTCFullYear()+',  '+d.getUTCHours()+':'+d.getUTCMinutes()+':'+d.getUTCSeconds());
                           //allValues[i].GYNCF_Last_Synced__c= 'Last Synced : '+allValues[i].GYNCF_Last_Synced__c.split('T')[0]+',   '+allValues[i].GYNCF_Last_Synced__c.split('T')[1].substring(0,8);
                    //console.log('after=='+allValues[i].GYNCF_Last_Synced__c);
                    }
                    
                    
                    if(ToBeSynced != undefined && ToBeSynced != 0 ){
                        allValues[i].progress = ((allValues[i].GYNCF_Synced__c*100)/allValues[i].GYNCF_To_Be_Synced__c).toFixed(2);     
                    }
                    else if(ToBeSynced == 0){
                        allValues[i].progress = 0;
                    }
                }
                component.set("v.objectList", allValues);
                component.set("v.TimeZone", TimeZone);
                //alert(component.get('v.progress'));
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
})