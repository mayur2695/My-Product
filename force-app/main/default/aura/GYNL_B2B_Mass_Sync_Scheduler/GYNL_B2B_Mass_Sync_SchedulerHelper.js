({
	getCheckBoxValueHelper : function(component) {
		var checkVal = component.get("v.value");
        console.log('The value from the component==>'+checkVal);
        component.set("v.dayselected",checkVal);
	},
    onCheckHelper : function(component){
       //var checkValAll = component.get("v.myBool");
       //var checkCmp = component.find("checkbox1");
       var getval= component.get("v.Everydaycheckbox");
         
       //var resultCmp = component.find("dayValue");
	   component.set("v.allDay",getval);
       console.log('The value from all===>'+getval);
       
       //var element = document.getElementById("myDIV");
       if(getval==true){
           
           //element.classList.add("slds-hide");
           component.set("v.myDIV",false);
         }
       if(getval==false){
            //element.classList.remove("slds-hide");
           component.set("v.myDIV",true);
        }
        
    },
    handleErrors : function(errors) {
    // Configure error toast
    let toastParams = {
        title: "Error",
        message: "Unknown error", // Default error message
        type: "error"
    };
    // Pass the error message if any
    if (errors && Array.isArray(errors) && errors.length > 0) {
        toastParams.message = errors[0].message;
    }
    // Fire error toast
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams(toastParams);
    toastEvent.fire();
},
 	getDays: function (component) {
		
	}
})