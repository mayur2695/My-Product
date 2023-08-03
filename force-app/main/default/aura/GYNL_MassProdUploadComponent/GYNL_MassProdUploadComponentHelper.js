({
    createCSVObject : function(cmp, jsonstr,objectType) {
        var check=false;
        if(objectType=='Product'){
            cmp.set('v.ShowHideBar1', true);
            var action = cmp.get('c.insertProducts');
            var interval = setInterval($A.getCallback(function () {
                var progress1 = cmp.get('v.progress1');
                cmp.set('v.progress1', progress1 === 100 ? cmp.set("v.ShowHideBar1",false) : progress1 + 20);
            }), 1000);
        }
        else{
            check = true;
            cmp.set('v.ShowHideBar2', true);
            var action = cmp.get('c.insertCatalogs');
            var interval = setInterval($A.getCallback(function () {
                var progress2 = cmp.get('v.progress2');
                cmp.set('v.progress2', progress2 === 100 ? cmp.set("v.ShowHideBar2",false) : progress2 + 20);
            }), 1000);                       
        }
        action.setParams({
            ProductString : jsonstr,
            insertPrefer : 0
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state == "SUCCESS") {
                console.log(response.getReturnValue());
                if(check==true){
                    check =false;
                    var action2 = cmp.get("c.insertCatalogs");
                    action2.setParams({
                        ProductString : jsonstr,	
                                 insertPrefer : 1
                    });
                    action2.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                            
                        }
                        
                    });
                    $A.enqueueAction(action2);
                }
                if(objectType=='Product'){
                    cmp.set("v.ShowsccessIcon1",true);
                    alert(cmp.get("v.ShowsccessIcon1"));
                    document.getElementById("ProdDiv").style.color="green";
                    cmp.set("v.ProductFileName",' File has been Proccesed');
                }
                else{
                    document.getElementById("categoryDiv").style.color="green";
                    cmp.set("v.ShowsccessIcon2",true);
                    cmp.set("v.CategoryFileName",'File has been Proccesed');   
                }
            }
            else if (state === "INCOMPLETE") {
                if(objectType=='Product'){
                    cmp.set("v.ProductFileName",'File has been uploaded');
                }
                else{
                    cmp.set("v.CategoryFileName",'File has been uploaded');   
                }
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            cmp.set("v.fileName",errors[0].message);
                            console.log("Error message: " + 
                                        errors[0].message);
                            if(objectType=='Product'){
                                cmp.set("v.ProductFileName",'File has been uploaded');
                            }
                            else{
                                cmp.set("v.CategoryFileName",'File has been uploaded');   
                            }
                        }
                    } else {
                        cmp.set("v.fileName",'Unknown error');
                        console.log("Unknown error");
                        if(objectType=='Product'){
                            cmp.set("v.ProductFileName",'File has been uploaded');
                        }
                        else{
                            cmp.set("v.CategoryFileName",'File has been uploaded');   
                        }
                    }
                }        });
        $A.enqueueAction(action);
    },
    CSV2JSON: function (component,csv,filetype) {
        //  console.log('Incoming csv = ' + csv);
        
        //var array = [];
        var arr = []; 
        
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        
        /*var headers = arr[0].split(',');
                    for(var i=0;i<headers.length;i++){
                        headers[i]=headers[i].replace(/ +/g, "");
                    }*/
        if(filetype=='Product'){
            var headers=['id','Total_Price','Tags','Category_Name'];
        }
        else{
            var headers=['Catalog_Name','Category_Name','Parent_Category_Name'];
        }
        console.log('headers'+headers);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                console.log('headers'+headers[j]);
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        return json;
        
        
    }
})