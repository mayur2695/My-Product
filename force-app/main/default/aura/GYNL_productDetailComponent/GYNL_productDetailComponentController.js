({
    doInit : function(component, event, helper) {
        //Added By Spandana for Dynamic Theme 05/26
        var themeaction = component.get('c.getActiveTheme');
        themeaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result= response.getReturnValue();
                component.set("v.staticresourceName", response.getReturnValue());
                //alert('result==='+result);
            }
        });
        $A.enqueueAction(themeaction);
        //Ended By Spandana for Dynamic Theme 05/26
        var recordId = component.get("v.recordId");
        //If component called from force:navigateToComponent event then recordId not to be set
        //If component called from lightning:navigation, then recordId would be undefined and needs to be set from
        //page reference
        //alert('recordid'+component.get('v.recordId'));
        if (recordId == undefined) {
            var pageReference = component.get("v.pageReference");
            
            component.set("v.recordId", pageReference.state.c__recordId);
            //alert('Product Id is:'+ component.get('v.recordId'));
        }

        var action = component.get("c.getDescription");
        action.setParams({
            prodId : component.get("v.recordId") 
        });
        action.setCallback(this, function (response) {  
            var state = response.getState();   
            if (state == 'SUCCESS') {  
                var result = response.getReturnValue(); 
                component.set("v.ProdDetails", result);
                
                
            }
            else{  
                console.log('something bad happend! :: 1');  
            }  
        });  
        var action1 = component.get("c.getDescription1");
        
        action1.setParams({
            prodId1 : component.get("v.recordId") 
        });
        action1.setCallback(this, function (response) {   
            var state1 = response.getState();   
            if(state1 == 'SUCCESS'){  
                try{
                    var result1 = response.getReturnValue();
                    var test = result1;
                    var array = [];
                    array = JSON.stringify(test[0].Description).split("\\r\\n");
                    component.set("v.Details",array); 
                }
                catch(e){
                    console.log('Error'+e);
                }
            }
            else{  
                console.log('something bad happend! :: 2');  
            }  
        }); 
        var action2 = component.get("c.getContents");
        
        action2.setParams({
            prodId2 : component.get("v.recordId") 
        });
        action2.setCallback(this, function (response) {  
            var state2 = response.getState();   
            if(state2 == 'SUCCESS'){  
                var result2 = response.getReturnValue();
                result2 = '/sfc/servlet.shepherd/version/download/' + result2;
                component.set("v.ProdDetails1",result2);
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.helperMethod(component,event)
                    })
                );
            }

            else
            {  
                console.log('something bad happend! :: 3');  
            }  
        }); 
        $A.enqueueAction(action);  
        $A.enqueueAction(action1);
        $A.enqueueAction(action2); 
    },
    /*scriptsLoaded : function(component, event, helper) {
        console.log("Scripts succesfully loaded");	
        $('#zoom_01').okzoom({
            width:200,
            height:200
        });
    },*/
    M1 : function(component, event, helper) {
        var options = {
            width: 400,
            zoomWidth: 500,
            offset: {vertical: 0, horizontal: 10}
        };
        new ImageZoom(document.getElementById("img-container"), options);
        console.log('script');
    },
    changeimage : function(component, event, helper) {
        document.getElementById('image').src=component.get("v.ProdDetails1");
        /* var options = {
            width: 400,
            zoomWidth: 500,
            offset: {vertical: 0, horizontal: 10}
        };
        new ImageZoom(document.getElementById("img-container"), options);*/
        helper.helperMethod(component,event);
        //alert(document.getElementById('image').src);
    },
    scriptsLoaded1:function(component, event, helper) {
        //alert('Theme Loaded' + component.get("v.staticresourceName"));
    },
    changeReviewTab : function(component, event, helper) {
        component.find("reviewTabSet").set("v.selectedTabId", "two");
        $A.get('e.force:refreshView').fire();
        
        //alert();
    },
    reInit: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();

    },
    redirectToPreviousPage: function(component,event,helper){
        window.history.back();
    }
})