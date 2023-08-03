({
    getCatalogsData : function(c,e,h){
        try {
            var action = c.get("c.fetchCatalogs");
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    //alert('Result>>>>'+response.getError());
                    c.set("v.acctList", response.getReturnValue());
                } else {
                    console.log('ERROR');
                    console.log(response.getError());
                    alert('Error>>>>'+response.getError());
                }
            });
            $A.enqueueAction(action);
        } catch (ex) {
            console.log(ex);
        }
        //Calling Product Uniquifier Custom Settings data
        try{
            var prodUniqaction = c.get("c.getProdUniquifierdata");
            prodUniqaction.setCallback(this,function(response){
                var resVal = response.getState();
                if(resVal === "SUCCESS"){
                    c.set("v.prodUniqList", response.getReturnValue());
                }else {
                    console.log('ERROR');
                    console.log(response.getError());
                    alert('Error>>>>'+response.getError());
                }
                
            });
            $A.enqueueAction(prodUniqaction);
        } catch(ex){
            console.log(ex);
        }
        var actionTheme = c.get("c.getThemes");
        actionTheme.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result= response.getReturnValue();
                console.log('result'+JSON.stringify(result));
                for(var i in result){
                    if(result[i].isActive__c == true){
                         c.set("v.staticresourceName", result[i].Name);
                    }
                }//alert('themenameselcted'+ c.get("v.staticresourceName"));
                c.set("v.themeList", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionTheme);
        
   }

})