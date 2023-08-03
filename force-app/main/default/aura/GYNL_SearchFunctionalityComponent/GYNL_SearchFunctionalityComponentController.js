({  
   doInit :function(component,event,helper){ 
     console.log('Calling do init');
        var action = component.get("c.searchData"); 

        
    //   alert(this.action);
     action.setCallback(this,function(response){   
       var state = response.getState();
        //alert(state);
       if(state == 'SUCCESS'){  
          // alert('Yes');
         var result = response.getReturnValue();     
         component.set("v.unfilteredData",result);  
         console.log(result);
         helper.createCategoryList(component,result);
         component.set("v.data",result);  
       }else{  
          // alert("SAD");
         console.log('something bad happend! ');  
       }  
     });  
     $A.enqueueAction(action);  
   }, 
    
    // handleRangeChange : function(component, event, helper){
    //     //console.log("Max : "+component.get("v.maxPrice"));
    //     //console.log("Min : "+component.get("v.minPrice"));
    //     //console.log("Value :"+component.get("v.val"));
    //     console.log("Slider changed");
    // },
    
    doFilter: function (component, event, helper) { 
        helper.findRecords(component, event, helper);  
   },
    onChange: function(component, event, helper,result){
        var action1= component.get("c.priceLowToHigh");
        var getproduct = component.get("v.data");
        action1.setParams({v : getproduct});
        var action2= component.get("c.priceHighToLow");
        action2.setParams({v : getproduct});
        var action3= component.get("c.popularityLowToHigh");
        action3.setParams({v : getproduct});
        var action4= component.get("c.popularityHighToLow");
        action4.setParams({v : getproduct});
        var value= component.find('select').get('v.value');
        console.log('show the value from select'+value);
        console.log('show the value from select'+action1);
        if(value=='prl2h'){
           // alert('You chose option 1');
            action1.setCallback(this,function(response){
                var state = response.getState();
                console.log('show the state'+state);
                if(state == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var disp= JSON.stringify(result);
                    var sortedRecords = result.sort(function(a, b) {
                        return a.GYNCF_Price__c - b.GYNCF_Price__c;});
                    console.log('** '+JSON.stringify(result));   
                //component.set("v.data", sortedRecords);
                   // alert(disp);
                    helper.callEvent(component,event,helper,sortedRecords);
                    component.set("v.dataPrLowToHigh",sortedRecords);
                    console.log("Event Fired from option 1");
                }
            });
            $A.enqueueAction(action1);
        }
         if(value=='prh2l'){
            //alert('You chose option 2');
             action2.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var disp= JSON.stringify(result);
                    var sortedRecords = result.sort(function(b, a) {
                        return a.GYNCF_Price__c - b.GYNCF_Price__c;});
                    console.log('** '+JSON.stringify(result));
                    //alert(disp);
                    component.set("v.dataPrHighToLow",sortedRecords);
                    helper.callEvent(component,event,helper,sortedRecords);
                    console.log("Event Fired from option 2");
                }
            });
            $A.enqueueAction(action2);
        }
         if(value=='pol2h'){
            //alert('You chose option 3');
             action3.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var disp= JSON.stringify(result);
                    var sortedRecords = result.sort(function(a, b) {
                        return a.GYNCF_Average_Rating__c - b.GYNCF_Average_Rating__c;});
                    console.log('** '+JSON.stringify(result)); 
                    //alert(disp);
                    component.set("v.dataPoLowToHigh",sortedRecords);
                    helper.callEvent(component,event,helper,sortedRecords);
                    console.log("Event Fired from option 3");
                }
            });
            $A.enqueueAction(action3);
        }
         if(value=='poh2l'){
           // alert('You chose option 4');
             action4.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var disp= JSON.stringify(result);
                    var sortedRecords = result.sort(function(b, a) {
                        return a.GYNCF_Average_Rating__c - b.GYNCF_Average_Rating__c;});
                    console.log('** '+JSON.stringify(result));
                    //alert(result);
                    component.set("v.dataPoHighToLow",sortedRecords);
                    helper.callEvent(component,event,helper,sortedRecords);
                    console.log("Event Fired from option 4");
                }
            });
            $A.enqueueAction(action4);
        }
   /*     if(value='one')
            alert('Null Value');*/
    },
      handleRangeChange: function (component, event) {
          var action = component.get("c.sliderProducts");
          var getProduct = component.get("v.data");
        action.setParams({limitFromSlider :event.getParam("value"),v : getProduct });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.products", response.getReturnValue());
                var cmpEvent = $A.get("e.c:GYNE_ProductGridInboundEvent");
                cmpEvent.setParams({
                    "filteredProducts" : response.getReturnValue(),
                    	//parent : 'search'
                });
                cmpEvent.fire();
                
                
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        console.log(component.get("v.products"));
        
    },
    scriptsLoaded: function(component, event, helper) {
        console.log("gyansys theme script loaded");
    },
    /*,
 /*   priceSlide: function(component, event,helper){
        alert(component.get("v.value"));
    }*/
    
    onHandlerChange: function (component, event) {
        var searchKey = component.get("v.searchCriteria");
        if (searchKey == "") {
            //component.set("v.data", component.get("v.unfilteredData"));
            var cmpEvent4 = component.getEvent("cmpEvent1");
            cmpEvent4.setParams({
                "isChecked3": "true"
            });
            cmpEvent4.fire();
        }
        else
        {
            console.log('Hello');
            var cmpEvent2 = component.getEvent("cmpEvent2");
            cmpEvent2.setParams({
                "isChecked": "false"
            });
            cmpEvent2.fire();
            
            }



    }
    
    
    
 })