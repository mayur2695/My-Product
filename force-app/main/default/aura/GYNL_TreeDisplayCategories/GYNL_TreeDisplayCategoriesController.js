({
    doInit: function (cmp, event, helper) { 
        //Added By Spandana for Dynamic Theme 05/26
        var themeaction = cmp.get('c.getActiveTheme');
        themeaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result= response.getReturnValue();
                cmp.set("v.staticresourceName", response.getReturnValue());
                //alert('result==='+result);
            }
        });
        $A.enqueueAction(themeaction);
        //Ended By Spandana for Dynamic Theme 05/26
        helper.productTreeBuild(cmp, event, helper);
    },
    handleClick: function(cmp,event,helper){
        //alert('Root Category Creation clicked>>>>');
        var cInfo = cmp.get("v.cInfo");
        cmp.set("v.catalogMasterName",cInfo.Id);
        cmp.set("v.showRootCreate", true);
    },
    handleSelect: function (cmp, event, helper) {
        var id = event.getParam('name');
        console.log("id", id);
        cmp.set("v.selectedId" ,id);        
        helper.retrieveData(cmp, event, helper, id);
    },
    closeDialog: function(cmp, event, helper) {
        cmp.set("v.showDialog", false);
    },
    handleSuccessRoot: function(cmp,event,helper){
        cmp.set("v.showRootCreate", false);
        helper.productTreeBuild(cmp, event, helper);
    },
    handleSuccess: function(cmp, event, helper) {
        cmp.set("v.showDialog", false);
        helper.productTreeBuild(cmp, event, helper);
    },
    onCancelRoot: function(cmp,event,helper){
        cmp.set("v.showRootCreate", false);
    },
    onCancel: function(cmp, event, helper) {
        cmp.set("v.showDialog", false);
    },
    closeEdit: function(cmp, event, helper) {
        cmp.set("v.showDialog", false);
        helper.productTreeBuild(cmp, event, helper);
    },
    closePro: function(cmp, event, helper) {
        cmp.set("v.showDialog", false);
        helper.productTreeBuild(cmp, event, helper);
    },
    handleTreeEvent: function(cmp, event, helper){
        //alert('Event Fired>>>');
        helper.productTreeBuild(cmp, event, helper);
    },
    handleDelCatData: function(cmp,event,helper){
        var cid = cmp.get('v.objId');
        //alert('selected category id>>>'+cid);
        //cmp.set("v.selectedId",cid);
        var action = cmp.get("c.findChilds");
        action.setParams({ "categoryId" : cid });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                //alert('result response>>>>'+res);
                if(res == 'NoData') {
                    //alert('good to delete');
                    var resVal = confirm('Are you sure want to delete?');
                    if(resVal){
                        //call delete helper method..
                        helper.removeCategory(cmp, event, helper, cid);
                        cmp.set("v.showDialog", false);
        				helper.productTreeBuild(cmp, event, helper);
                    }
                    
                }
                if(res == 'DataExists'){
                    alert('Selected Category has childs and unable to delete category.');
                }
                
            }
        });
        $A.enqueueAction(action);
        
    }
})