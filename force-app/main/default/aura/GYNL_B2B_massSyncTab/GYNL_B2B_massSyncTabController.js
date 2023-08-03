({
    init: function(component, event, helper) {
        helper.ShowMyObjAndIcon(component, event, helper);
        const empApi = component.find("empApi");
        const channel = '/topic/MassSyncTabNew';
        const replayId = -1;
        empApi.onError($A.getCallback(error => {
            console.error('EMP API error: ', JSON.stringify(error));
        }));
            empApi.subscribe(channel, replayId, function(message) {
            var progress = component.get('v.progress');
            var AllObjData = component.get("v.objectList");
            for(var x in AllObjData){
            if(AllObjData[x].Id == message.data['sobject'].Id ){
            //For massSync Button disable and enable According to Mass Sync Checkbox
            
            AllObjData[x].GYNCF_Mass_Sync__c = message.data['sobject'].GYNCF_Mass_Sync__c;
            
            // Display Progress Bar
            if(message.data['sobject'].GYNCF_Mass_Sync_Live__c == true){
            AllObjData[x].GYNCF_Mass_Sync_Live__c = true;
            var ToBeSyncedStrm = message.data['sobject'].GYNCF_To_Be_Synced__c;
            var SyncedStrm = message.data['sobject'].GYNCF_Synced__c;
            if(ToBeSyncedStrm != undefined && ToBeSyncedStrm != 0){
            AllObjData[x].progress = ((SyncedStrm*100)/ToBeSyncedStrm).toFixed(2);
        }else if(ToBeSyncedStrm == 0){
            AllObjData[x].progress = 0;
        }
        }
            else if(message.data['sobject'].GYNCF_Mass_Sync_Live__c == false){
            AllObjData[x].GYNCF_Mass_Sync_Live__c = false;
        }
            // Display Last Synced Date
            
            if(message.data['sobject'].GYNCF_Last_Synced__c != undefined){
            //console.log("timebefore : " + (message.data['sobject'].GYNCF_Last_Synced__c));
            var UserTimeZone = component.get('v.TimeZone');
            var d = new Date(message.data['sobject'].GYNCF_Last_Synced__c);
            //console.log("timeDDD===: " + (d));
            AllObjData[x].GYNCF_Last_Synced__c = 'Last Synced : '+d.toLocaleString('en-US', { timeZone: UserTimeZone });
                       //AllObjData[x].GYNCF_Last_Synced__c = ('Last Synced : '+d.getUTCDate()+'/'+d.getUTCMonth()+'/'+d.getUTCFullYear()+',  '+d.getUTCHours()+':'+d.getUTCMinutes()+':'+d.getUTCSeconds());
                       // AllObjData[x].GYNCF_Last_Synced__c= 'Last Synced : '+message.data['sobject'].GYNCF_Last_Synced__c.split('T')[0]+',   '+message.data['sobject'].GYNCF_Last_Synced__c.split('T')[1].substring(0,8);
                       //console.log("Timeafter : " + AllObjData[x].GYNCF_Last_Synced__c);
                       }
                       
                       }
                       component.set("v.objectList" , AllObjData);
    }
   // console.log("Event Received : " + JSON.stringify(message));
    
});

},
    ProceedMassSync: function(component, event, helper) {
        component.set("v.OpenModal", false);
        var spinner = component.get("v.loaded");
        spinner = true;
        component.set("v.loaded" , spinner);
        var objectName = event.getSource().get("v.name");
        var systemid = event.getSource().get("v.value");
        var action = component.get("c.startMassSync");
        action.setParams({"objNameSAP":objectName,"systemId":systemid});
        var statusObj = {"status":"","statusMessage": ""};
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
                var allValues = response.getReturnValue();
                if(allValues != null){
                    spinner = false;
                }
                component.set("v.loaded" , spinner);
                
                statusObj.status = response.getReturnValue();
                //alert("check 48: "+ response.getReturnValue());
                if(response.getReturnValue() === "Success") {
                    statusObj.statusMessage = `Mass Sync for ${objectName} started successfully!`;
                        //$A.get('e.force:refreshView').fire();
                        }
                        else{
                        statusObj.statusMessage = `Mass Sync for ${objectName} couldnot able to process!`;
                        //$A.get('e.force:refreshView').fire();
                        }
                        
                        
                        }                    
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    statusObj.status = "Error";
                                    statusObj.statusMessage = errors[0].message;
                                    
                                }
                            } 
                            else {
                                //console.log("Unknown Error");
                            }
                            component.set("v.loaded" , false);
                        }
                    helper.showMyToast(component, event, statusObj);
                });
                $A.enqueueAction(action);   
            },
                massSyncButton: function(component, event, helper) {
                    component.set("v.OpenModal", true);
                },
                    cancle: function(component, event, helper) {
                        component.set("v.OpenModal", false);
                    }
        })