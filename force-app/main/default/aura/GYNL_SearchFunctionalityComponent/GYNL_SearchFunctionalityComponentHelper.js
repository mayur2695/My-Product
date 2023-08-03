({  
    findRecords: function (component, event, helper) {
        

    
        var data = component.get("v.data");  
        var allData = component.get("v.unfilteredData");  
        var searchKey = component.get("v.searchCriteria");  
        if(data!=undefined || data.size>0){  
            var filtereddata = allData.filter(word => (!searchKey) || word.Name.toLowerCase().indexOf(searchKey.toLowerCase()) > -1);  
          /*  var sortedRecords = filtereddata.sort(function(a, b) {
                return a.GYNCF_Price__c - b.GYNCF_Price__c;});
            console.log('** '+JSON.stringify(filtereddata));  
        }   
        */
        //component.set("v.data", sortedRecords); 
            //added by mkh
       /* component.set("v.isVisible",false);
            
        var cmpEvent = $A.get("e.c:GYNE_DynamicSearchEvent");
        cmpEvent.fire();*/
    }
        component.set("v.data", filtereddata);    
        if(searchKey==''){   
            //component.set("v.data", component.get("v.unfilteredData"));
            var cmpEvent2 = component.getEvent("cmpEvent2");
        cmpEvent2.setParams({
            "isChecked": "true"
        });
            cmpEvent2.fire();
            
        }
        helper.callEvent(component,event,helper,component.get("v.data"));
        helper.createCategoryList(component,component.get("v.data"));
        console.log("Event Fired");
        
    },
    
    callEvent : function(component,event,helper,data){
        
        var category= component.get("v.products");
        
            
        var cmpEvent = $A.get("e.c:GYNE_ProductGridInboundEvent");
        cmpEvent.setParams({
            "filteredProducts" : data
        });
        cmpEvent.fire();
    },
    createCategoryList : function(component,listOfProducts){
        var map = new Map();
        try{
            listOfProducts.forEach((e)=>{
            var key = e.GYNCF_Product_Category__r.Name;
            if(map.has(key)){
            var value = parseInt(e.GYNF_Availability__c)+map.get(key);
            // debugger;
            map.set(key,value);
            console.log('get the value e.GYNF_Availability__c'+JSON.stringify(value));
        }else{
                               var value = parseInt(e.GYNF_Availability__c);
                               console.log('get the value e.GYNF_Availability__c'+JSON.stringify(value));
        map.set(key,value);
        }
});
   }
  catch(e){
                    console.log('Error'+e);
                }
//console.log('Map : '+map);
var categoryList = []
//a:::b
map.forEach((a,b)=>{
    categoryList.push({category:b,count:a});
});
//console.log('Category List : '+categoryList);
//categoryList.forEach((e)=>console.log(e));
component.set("v.categoryList",categoryList);
}
})