({
    
 
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set('v.column', [
            {label: "Template Name", fieldName: 'Name', type: 'text'},
            {label: 'Active?', fieldName: 'GYNCF_Active__c', type: 'boolean'},
                     
            {label:'Make Active',type:'button-icon',typeAttributes:
             {iconName:'utility:save',alternativeText:'Make Active',disabled: false}
            }
        ]);
        
    // get the selected Account record from the COMPONETN event 	 
    //   var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	 //  component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        var action = component.get("c.fetchTableData");
      //  action.setParams({
      //      'Comp': selectedAccountGetFromEvent.GYNCF_Company_Name__c
     //     });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set searchResult list with return value from server.
                component.set("v.data", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
        
     
        
	},
    handleRowAction : function(component, event, helper){
        var row = event.getParam('row');
        component.set("v.RowTemplate",row);
       // console.log('*****row:'+JSON.stringify(row));
       // alert('You have selected View Action for '+row.Name+'(id='+row.Id+')');
        var action = component.get("c.SelectTemplate");
        action.setParams({
            'Temp': component.get("v.RowTemplate")
          });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set searchResult list with return value from server.
                component.set("v.data", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    }
    
})