({
    doinit : function(component, event, helper) {
        var allproducts = event.getParam("filteredProducts");
        var action = component.get("c.getProductsWithImages");
        action.setParams({
            productsWithoutImages : allproducts
        });
        action.setCallback(this, function(response){
            allproducts = response.getReturnValue();
            if(allproducts.length > 0){
                component.set("v.containsData",true);
                component.set("v.showError",false);
            }
            else{
                component.set("v.containsData",false);
                component.set("v.showError",true);
            }
            component.set("v.AllProducts",allproducts);
            var pageNumber=1;
            component.set("v.PageNumber",pageNumber);
            var productLimit=component.get("v.Productlimit");
            var numberofPages;
            //it will show the number of products to be shown in the current page
            var prodarray=[];
            for(var i=1;i<=allproducts.length;i++){
                if(i<=pageNumber*productLimit){
                    prodarray.push(allproducts[i-1]);
                }
            }
            component.set("v.ProductsforCurrentPage",prodarray);
            
            if(allproducts.length%productLimit==0){
                numberofPages=allproducts.length/productLimit;
            }
            else{
                numberofPages=allproducts.length/productLimit+1;
            }
            var pageNumberarray = [];
            if(numberofPages!=null){
                for(var i=1;i<=numberofPages;i++){
                    pageNumberarray.push(i);
                }
                component.set("v.PageNumberList",pageNumberarray);
            }
        });
        $A.enqueueAction(action);
        
    },
    //clicking of the pagebutton it will show the number of products
    onclickButton : function(component, event, helper) {
        var btnClicked = parseInt(event.target.id);
        component.set("v.PageNumber",btnClicked);
        var allProducts = component.get("v.AllProducts");
        var productLimit = component.get("v.Productlimit");
        var prodarray=[];
        for(var i=1;i<=allProducts.length;i++){
            if(i<=btnClicked*productLimit && i>(btnClicked-1)*productLimit){
                prodarray.push(allProducts[i-1]);
            }
            
        }
        component.set("v.ProductsforCurrentPage",prodarray);
       //debugger;
        var totalPages = component.get("v.PageNumberList").length;
        if(btnClicked == component.get("v.PageNumberEnd")){
            if(btnClicked+1 == totalPages){
                var diffrence = totalPages - btnClicked;
                component.set("v.PageNumberEnd",totalPages);
                component.set("v.PageNumberStart",totalPages-component.get("v.PageNumberLimit"));
            }
            if(btnClicked+1 < totalPages){
                component.set("v.PageNumberEnd",btnClicked+1);
                component.set("v.PageNumberStart",component.get("v.PageNumberStart")+1);
            }
        }
        else if(btnClicked == component.get("v.PageNumberStart")+1){
            if(btnClicked-1 == 1){
                component.set("v.PageNumberEnd",component.get("v.PageNumberLimit"));
                component.set("v.PageNumberStart",0);
            }
            if(btnClicked-1 > 1){
                component.set("v.PageNumberEnd",component.get("v.PageNumberEnd")-1);
                component.set("v.PageNumberStart",btnClicked-2);
            }
        }
        //page will go up when the button is clicked
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
    },
    
    //it will navigate to the ProductDetail page
    navigateDetailPage: function (component, event, helper) {
        
        var productId = event.target.id;
        
        var navigation = component.find("nav");

        var navigateToDetailedPage= {
            "type": 'standard__component',
            "attributes": {
                "componentName": "c__GYNL_productDetailComponent"
            },
            "state": {
                "c__recordId" : productId
            }
        }
        navigation.navigate(navigateToDetailedPage); 
    },
    
    //custom theme
    scriptsLoaded: function(component, event, helper) {
        alert('gyansys theme script loaded');
    },
    
    //Pagination for jump on to thr next page
    nextBtnGrp: function(component, event, helper) {
        if(component.get("v.PageNumberEnd") < component.get("v.PageNumberList").length){
            component.set("v.PageNumberStart",component.get("v.PageNumberStart")+1);
            component.set("v.PageNumberEnd",component.get("v.PageNumberEnd")+1);
        }
    },
    
    //Pagination for jump on to thr previous page
    prevBtnGrp: function(component, event, helper) {
        if(component.get("v.PageNumberStart") != 0){
            component.set("v.PageNumberStart",component.get("v.PageNumberStart")-1);
            component.set("v.PageNumberEnd",component.get("v.PageNumberEnd")-1);
        }
    }
    
})