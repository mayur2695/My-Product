({
    fetchData : function(component, event, helper) {
        //Added By Spandana
         var actions = [
            { label: 'Activate','iconName': 'utility:check', name: 'Activate' }
                        ]
        component.set('v.themeColumns', [
            {label: 'Theme Name', fieldName: 'Name', type: 'text'},
                {label: 'Description', fieldName: 'Description__c', type: 'text'},
                {label: 'Theme Type', fieldName: 'Theme_Type__c', type: 'text'},
                {label: 'Active', fieldName: 'isActive__c', type: 'boolean'},
            	{type: 'action', typeAttributes: { rowActions: actions } },
                
            ]);
        //Ended By Spandana
        
        var actions = [
            { label: 'Edit','iconName': 'utility:edit', name: 'edit' },
            { label: 'View','iconName': 'utility:preview', name: 'view' }
        ]
        component.set('v.mycolumns', [
            {label: 'Catalog Name', fieldName: 'Name', type: 'text'},
                {label: 'Description', fieldName: 'GYNCF_Description__c', type: 'text'},
                {label: 'Active', fieldName: 'GYNCF_Active__c', type: 'boolean'},
            	{type: 'action', typeAttributes: { rowActions: actions } },
                
            ]);
        
        var actions = [
            { label: 'Activate','iconName': 'utility:check', name: 'Activate' }
                        ]
        component.set('v.prodUniqCols', [
            	{label: 'Unique Identifier', fieldName: 'Name', type: 'text'},
                {label: 'Image Locator', fieldName: 'Image_Locator__c', type: 'text'},
                {label: 'Active', fieldName: 'Active__c', type: 'boolean'},
            	{type: 'action', typeAttributes: { rowActions: actions } },
                
            ]);
        helper.getCatalogsData(component, event, helper);
    },
    
     handleProdUniqRowAction: function(component, event, helper) {
        var row = event.getParam('row');
       
        var recId = row.Id;
       
           var rowaction = component.get("c.manageProdUniquifierdata");
           rowaction.setParams({
               "pid": recId
           });
           rowaction.setCallback(this, function (response) {
               if(response.getState() === 'SUCCESS') {
                   helper.getCatalogsData(component, event, helper);
               }
           });
           $A.enqueueAction(rowaction);
    },
       handleRowAction : function(c,e,h)
            {
            
            var action = e.getParam('action');
            var row = e.getParam('row');
            
            switch (action.name) {
                case 'edit':
                c.set("v.isOpen",true);
                c.set("v.selectedAccount",row);
            	var selVal = c.get("v.selectedAccount");
            	var checkCmp = c.find("checkbox");
            	checkCmp.set("v.value",selVal.GYNCF_Active__c);
                
                break;
                
                case 'view':
            	c.set("v.selectedAccount",row);
            	var selCatalog = c.get("v.selectedAccount");
            	//alert('selected Catalog Name:'+selCatalog.Name);
                c.set("v.showGrid",true);
                break;
            }
            
            },
            scatalog : function(c,e,h){
            	c.set("v.showGrid",false);
            },
            closeModel : function(c,e,h)
            {
            c.set("v.isOpen",false);
            h.getCatalogsData(c,e,h);
            },
            closeCreateWindow : function(c,e,h)
            {
            c.set("v.isNew",false);
            h.getCatalogsData(c,e,h);
            },
            onCheck: function(cmp, evt) {
                var checkCmp = cmp.find("checkbox");
                cmp.set("v.selectedAccount.GYNCF_Active__c", checkCmp.get("v.value"));
			},
            onSelect: function(cmp, evt) {
                var checkCmp = cmp.find("cbox");
                cmp.set("v.catalogData.GYNCF_Active__c", checkCmp.get("v.value"));
			},
            editCatalogData  : function(c,e,h) {
            	try {
                    var selectedCatalog = c.get("v.selectedAccount");
            		var action = c.get("c.manageCatalogData");
                    action.setParams({
                        "selCatalog": selectedCatalog
                    });
                    action.setCallback(this, function (r) {
                        if(r.getState() === 'SUCCESS') {
                            alert('Edit Record has been done successfully');
                            c.set("v.isOpen",false);
            				h.getCatalogsData(c,e,h);
                        } else {
                            alert('ERROR>>>'+r.getError());
                        }
                    });
                    $A.enqueueAction(action);
                } catch (ex) {
                    console.log(ex);
                }
            
            },
            onNewClick:function(c,e,h){
                c.set("v.isNew",true);
            	var selVal = c.get("v.catalogData");
            	var checkCmp = c.find("cbox");
            	checkCmp.set("v.value",selVal.GYNCF_Active__c);
            },
            createInfo:function(c,e,h){
            	try {
                    var action = c.get("c.manageCatalogData");
                    action.setParams({
                        "selCatalog": c.get("v.catalogData")
                    });
                    action.setCallback(this, function (r) {
                        //debugger;
            			if(r.getState() === 'SUCCESS') {
                            c.set("v.isNew",false);
                            h.getCatalogsData(c,e,h);
                        } else {
                            alert('ERROR>>>'+r.getError());
                        }
                    });
                    $A.enqueueAction(action);
                } catch (ex) {
                    console.log(ex);
                }
            },
       handleThemeRowAction: function(component, event, helper) {
        var row = event.getParam('row');
       
        var selectedthemeId = row.Id;
       
           var themerowaction = component.get("c.manageTheme");
           themerowaction.setParams({
               "themeid": selectedthemeId
           });
           themerowaction.setCallback(this, function (response) {
               if(response.getState() === 'SUCCESS') {
                   helper.getCatalogsData(component, event, helper);
               }
           });
           $A.enqueueAction(themerowaction);
    },
    scriptsLoaded: function(component, event, helper) {
      //  alert('gyansys theme script loaded');
    }
    
    
})