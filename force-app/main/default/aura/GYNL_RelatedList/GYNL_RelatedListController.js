({
    doInit : function(component, event, helper) {
        //Will Send the Id of the current Account to get the related list record
        var AccRecordId = component.get("v.recordId");
        component.set('v.QuotationCol', [
            {fieldName: 'Id',label: 'SAP Order Number', type: 'url',typeAttributes:{
                label: { fieldName: 'GYNCF_Salesorder__c'}, 
                target: '_blank'}},
            {fieldName: 'TotalAmount', label: 'Amount', type: 'currency',cellAttributes: { alignment: 'left' }},
            {fieldName: 'Status',label: 'Status', type: 'Text'},
            {fieldName: 'EffectiveDate',label: 'Order Start Date', type: 'Text'}
        ]);
        helper.onloadcolmn(component, event,AccRecordId);
        helper.callToApex(component, event, helper);
        //helper.getquotelistvalue(component, event, AccRecordId);
    },
    
    //To handle the selected option
    handleChange : function(component, event, helper) {
        var selvalue = component.get("v.Boxvaluesselected");
        //console.log('check existing'+selvalue);
        var selectedValues = event.getParam("value");
        component.set("v.Boxvaluesselected",selectedValues);
    },
    
    closeModel : function(component, event, helper) {
        component.set('v.ToOpenDualbox',false);
    },
    
    openModel : function(component, event, helper) {
        component.set('v.ToOpenDualbox',true);       
    },
    
    AddColMethod : function(component, event, helper) {
        //get selected value
        var getlist = component.get("v.Boxvaluesselected");
        //get the list of all fields
        var getAll=component.get("v.Boxoptions");
        //console.log('getList'+getlist);
        var newcol = [];
        for(var i in getlist){
            var valObject = new Object(); 
            for(var j in getAll){
                if(getlist[i]==getAll[j]['value']){
                    valObject.fieldName=getAll[j]['value'];
                    
                    if(getAll[j]['type'].toLowerCase()=='id'){
                        valObject.type='url';
                        valObject.typeAttributes = { label: { fieldName: 'GYNCF_Salesorder__c'},target: '_blank'};
                        valObject.label='SAP Order Number';  
                    }
                    else if(getAll[j]['type'].toLowerCase()=='currency'){
                        valObject.type = getAll[j]['type'].toLowerCase();
                        valObject.label=getAll[j]['label'];
                        valObject.cellAttributes = { alignment: 'left' };
                    }
                    else{
                        valObject.type=getAll[j]['type'].toLowerCase();
                        valObject.label=getAll[j]['label'];
                    }
                }
            }
            newcol.push(valObject);
            
        }
        //console.log('newcol22222'+newcol);
        component.set('v.QuotationCol',newcol);
        helper.sendcoluntoApex(component, event,newcol);
        helper.sendNewcolumnToApex(component, event,getlist);
        component.set('v.ToOpenDualbox',false);
    }
})