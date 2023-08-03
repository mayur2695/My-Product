({
	getCandidates : function(component, event, helper) {
       // component.set("v.isOpen", true);
        component.set('v.column', [
            {label: "Name", fieldName: 'candidateName', type: 'url',typeAttributes:{label:{fieldName:'Name'},target:'_blank'}},
            {label: 'Email', fieldName: 'GYNCF_Email__c', type: 'text'},
            {label: 'Phone', fieldName: 'GYNCF_Phone_Number__c', type: 'text'},
            {label: 'Has Resume?', fieldName: 'GYNCF_Has_Resume__c', type: 'boolean'},
                     
            {label:'Upload Resume',type:'button-icon',typeAttributes:
             {iconName:'utility:upload',alternativeText:'Upload Resume',disabled: false}
            }
        ]);
        component.set("v.enableInfiniteLoading",true);
            //event.getSource().set("v.isLoading", true);
        helper.getData(component);
 	},
    
    handleLoadMore : function(component,event,helper){
        if(!(component.get("v.currentCount") >= component.get("v.totalRows"))){
            //To display the spinner
            event.getSource().set("v.isLoading", true); 
            //To handle data returned from Promise function
            helper.loadData(component).then(function(data){ 
                var currentData = component.get("v.data");
                var newData = currentData.concat(data);
                component.set("v.data", newData);
                //To hide the spinner
                event.getSource().set("v.isLoading", false); 
            });
        }
        else{
            //To stop loading more rows
            component.set("v.enableInfiniteLoading",false);
            event.getSource().set("v.isLoading", false);
       /*     var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                type:"Success",
                title:"Success",
                message:"All Candidate records are loaded",
                mode:"dismissible"
            });
            toastReference.fire();   */
        }
    },
    
        handleRowAction : function(component, event, helper) {
        component.set("v.isOpen", true);
    //action gives which action performed
       // var action = event.getParam('action');
        //row gives complete row information
        var row = event.getParam('row');
        //console.log('*****row:'+JSON.stringify(row));
        //console.log(JSON.stringify(action));
        component.set("v.parentId", row.Id);
       // var TestId=component.get("v.parentId");
        //alert('You have selected View Action for '+row.Name+'(id='+row.Id+')');
        //alert(TestId);
},
    CreateNewCandidate : function(component, event, helper) {
        component.set("v.NewCanIsOpen", true);
        
            }
    
})