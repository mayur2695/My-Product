({
    doinit : function(component, event, helper) {
       
        //Call apex to get all product categories with Parent Category
        var action = component.get("c.getProductscategories");
        action.setCallback(this, function(response){
            //Get all categories
            var resp = response.getReturnValue();
            //Final list to categories
            var items = [];		
            var nodes = [];
            //Iterate over all categories
            for(var i=0; i<resp.length; i++){
                var isActive = false;
                if(resp[i].GYNCF_Catalog_Master__r != undefined){
                    isActive = resp[i].GYNCF_Catalog_Master__r.GYNCF_Active__c;
                }
                //Create a new object to store each category
                var item = new Object();	
                item.label = resp[i].Name;								//Stores the Category Name
                item.name = resp[i].Id;									//Stores the Category Id
                item.metatext = resp[i].GYNCF_Parent_Category__c;		//Stores the Parent Category Id
                item.items = [];										//Stores the Child Categories
                var foundAndPushed = false;								//Boolean to to check if top level categories are added to the list
                //Call helper method to find parent and associate accordingly
                items = helper.searchForKeyAndPush(item, items, foundAndPushed, resp[i].GYNCF_Level__c, isActive);
                
            }
            console.log(JSON.stringify(items));
            //Set the final list of categories to the component attribute
            component.set("v.items",items);
            component.set("v.iteratedItems",items);
        });
        $A.enqueueAction(action);
    },
    /*handleSelect: function(component,event,helper){
        var selected = event.getParam('name');
        //alert(selected);
        var action = component.get("c.getproducts");
        action.setParams({
            CategoryID : selected
        });
        action.setCallback(this, function(response){
            var returnedProducts = response.getReturnValue();
            var browsegrideventfire = $A.get("e.c:GYNE_ProductGridInboundEvent");
            browsegrideventfire.setParams({
                filteredProducts : returnedProducts
            });
            browsegrideventfire.fire();
        });
        $A.enqueueAction(action);
    },*/
    
    getSubCategories: function (component, event, helper) {
        // added by mayur
        var cmpEvent = component.getEvent("cmpEvent3");
        cmpEvent.setParams({
            "isChecked2": "false"
        });
        cmpEvent.fire();

        component.set("v.showMainMenuButton",true);
        var categoryClicked = event.target.id;
        var iteratedItems = component.get("v.iteratedItems");
        for(var i=0; i<iteratedItems.length; i++){
            if(iteratedItems[i].name == categoryClicked){
                if(iteratedItems[i].items.length > 0){
                    component.set("v.iteratedItems",iteratedItems[i].items);
                    break;
                }
                else{
                    var action = component.get("c.getproducts");
                    action.setParams({
                        CategoryID : categoryClicked
                    });
                    action.setCallback(this, function(response){
                        var returnedProducts = response.getReturnValue();
                        var browsegrideventfire = $A.get("e.c:GYNE_ProductGridInboundEvent");
                        browsegrideventfire.setParams({
                            filteredProducts : returnedProducts,
							//parent : 'browse'
                        });
                        browsegrideventfire.fire();
                    });
                    $A.enqueueAction(action);
                }
            }
            
        }
    },
    
    toMainMenu :function(component,event,helper){
        component.set("v.showMainMenuButton",false);
        var allitems = component.get("v.items");
        component.set("v.iteratedItems", allitems);
        // added by mayur
        var cmpEvent = component.getEvent("cmpEvent3");
        cmpEvent.setParams({
            "isChecked2": "true"
        });
        cmpEvent.fire();

    }
    
})