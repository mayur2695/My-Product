({
    showTostMsg : function(component,type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            duration:' 2000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
        component.set("v.loadingFlag", false);
    }
    
})