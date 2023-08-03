({
    showMyToast : function(component, event, statusObj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : statusObj.status,
            type: statusObj.status,
            mode: 'dismissible',
            message: statusObj.statusMessage
            
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})