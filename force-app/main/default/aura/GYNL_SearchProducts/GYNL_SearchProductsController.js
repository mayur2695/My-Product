({
	init : function(component, event, helper) {
        var catalogInfo = component.get("v.cdata");
        //console.log('catalog Name>>>',catalogInfo.Name);
		var actions = [
            { label: 'Assign Category','iconName': 'utility:reassign', name: 'assign' }
        ]
        component.set('v.columns', [
            { label: 'Product Name', fieldName: 'Name', type: 'text' },
            { label: 'Category', fieldName: 'Categoryname', type: 'text' },
            { label: 'Description', fieldName: 'Description', type: 'text' },
            { label: 'Rating', fieldName: 'GYNCF_Average_Rating__c', type: 'text' },
            {type: 'action', typeAttributes: { rowActions: actions } }
        ]);
	},
    closeSec: function(c,e,h){
        c.set("v.showPrdAssignSec",false);
    },
     handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.retrieveProdsData(component,event,helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.retrieveProdsData(component,event,helper);
    },
 
    handleData: function(c,e,h){
        var action = e.getParam('action');
        var rowVal = e.getParam('row');
        //alert('Selected Product Info>>>>'+rowVal.Id);
        switch (action.name) {
            case 'assign':
                c.set("v.showPrdAssignSec",true);
                c.set("v.pname",rowVal.Id);
                break;
        }
  
    },
    serachData : function(component,event,helper){
        helper.retrieveProdsData(component,event,helper);
	},
    handleSuccess:function(component,event,helper){
        component.set("v.showPrdAssignSec",false);
        var childTreeCmp = component.find("treeCmp");
 		childTreeCmp.refreshTree();
        helper.retrieveProdsData(component,event,helper);
         
    }
})