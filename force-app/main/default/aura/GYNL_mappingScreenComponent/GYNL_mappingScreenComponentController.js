({
    doInit: function (component, event, helper) {
       //helper.fetchObjectNames(component);
        if(!component.get("v.showPicklist")){
            helper.OptionSelected(component,event);
        }
    },
    handleOptionSelected: function (component, event,helper) {
        helper.OptionSelected(component,event);
    },
    addMappingRow : function(component,event,helper){
        helper.addingDataToRows(component);
    },
    saveMapping : function(component,event,helper){
        helper.saveMapping(component);
    },
    closeMappingRow : function(component,event,helper){
        helper.closeMapping(component,event);	
    }
})