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
       
        
        //Call Server Side Controller method
        //alert('childrecord'+component.get("v.recordId"));
        var action = component.get('c.getRelatedProducts');

       action.setParams({
            prodId :component.get("v.recordId")//'01t55000003mt58AAA'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var finalrelatedProdList = response.getReturnValue();  
                console.log('finalrelatedProdList'+JSON.stringify(response.getReturnValue()));
                var pageSize = component.get("v.pageSize");
                //set the related products available and set to relatedProdList
                component.set("v.relatedProdList",finalrelatedProdList); 
                console.log('relatedproducts'+ component.get("v.relatedProdList"));
                component.set("v.totalRecords", component.get("v.relatedProdList").length);
                component.set("v.startPage", 0);                
                component.set("v.endPage", pageSize - 1);
                var PagList = [];
                for ( var i=0; i< pageSize; i++ ) {
                    if ( component.get("v.relatedProdList").length> i )
                        PagList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PagList);
            }
        });
        $A.enqueueAction(action);  
    },
    navigate : function(component, event, helper) {
        //  var searchResults = event.getSource().getLocalId();
        var prodId = event.target.getAttribute("id");
        //  var urlval = event.getSource().get("v.id");
        //alert('searchResults'+convoId);
        
        
    },
    myAction:function(component,event,helper){  
        console.log('Enter Here'); 
        var inputname = event.currentTarget.id; 
        //alert('inputid'+inputname);
        var evt = $A.get("e.force:navigateToComponent");     
        console.log('evt'+evt);    
        evt.setParams({         
            componentDef: "c:GYNL_productDetailComponent",   
            componentAttributes :{ recordId : inputname}     
        });        
        evt.fire();  
    },
     next: function (component, event, helper) {
  var sObjectList = component.get("v.relatedProdList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PagList = [];
        var counter = 0;
        for ( var i = end + 1; i < end + pageSize + 1; i++ ) {
            if ( sObjectList.length > i ) {
                PagList.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
       console.log('end'+end);
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', PagList);
 },
     previous: function (component, event, helper) {
  var sObjectList = component.get("v.relatedProdList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PagList = [];
        var counter = 0;
        for ( var i= start-pageSize; i < start ; i++ ) {
            if ( i > -1 ) {
                PagList.push(sObjectList[i]);
                counter ++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
         console.log('end'+end);
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', PagList);
 },
     scriptsLoaded : function(component, event, helper) {
        // alert('Theme loaded ' +component.get("v.staticresourceName"));
     }
    
})