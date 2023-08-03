({
    handleActive: function (cmp, event, helper) {
        //helper.loadsTab(cmp, event);
    },
    
    showEdit: function (cmp, event, helper) {
        //cmp.set("v.isModalOpen", true); 
        cmp.set("v.Editable", false);
        cmp.set("v.ShowFrequencyComponent",true);
        
    },
    
    cancelChanges: function (component, event, helper) {
        
        component.set("v.Editable", true);
        component.set("v.ShowFrequencyComponent",false);
        helper.doInitMethod(component);
    },
    showAdvancedSettings: function(cmp, event, helper) {
        if(cmp.get("v.showAdvancedSettings")== true){
            cmp.set("v.showAdvancedSettings",false);        
        }
        else{
            cmp.set("v.showAdvancedSettings",true);     
        }
        
    },
    
    doInit : function(component, event, helper) {
        component.set("v.Editable", true);
        helper.doInitMethod(component);
        helper.getObjectList(component);
        helper.getOrderValues(component);
        console.log('conroler'+component.get("v.SystemId"));
    },
    
    tabSelected: function(component,event,helper) {
        component.set("v.Editable", true);
        component.set("v.ShowFrequencyComponent",false);
        component.set("v.showAdvancedSettings",false);
        var Tabvalue = component.get("v.selTabId");
        var ExistingValue = component.get("v.GYNCO_syncParamRecordList");
        
    },
    saveRec : function(component,event,helper) {
        var Tabvalue = component.get("v.selTabId");
        console.log(component.get("v.value"));
        
        var finalList;
        if(Tabvalue == 'Customer'){
            finalList =component.get("v.CustomerList");
        }
        if(Tabvalue == 'Materials'){
            finalList =component.get("v.MaterialList");
        }
        if(Tabvalue == 'Equipment'){
            finalList =component.get("v.EquipmentList");
        }
        if(Tabvalue == 'Sales Order'){
            finalList =component.get("v.SalesOrderList");
        }
        if(Tabvalue == 'Quotation'){
            finalList =component.get("v.QuotationList");
        }
        if(Tabvalue == 'Invoice'){
            finalList =component.get("v.InvoiceList");
        }
        console.log(Tabvalue);
        //finalList.GYNCF_CRON_Expression__c=component.get("v.CronTrigger");
        //console.log('expression ++'+JSON.stringify(finalList.GYNCF_CRON_Expression__c));
        //comment this 2 line code for check package issue
        if(!finalList.GYNCF_Mass_Sync__c){
            finalList.GYNCF_Mass_Sync_Frequency__c='';
        }
        var namespace = $A.get("$Label.c.GYNCL_Namespace");
        if(namespace != null && namespace != "c") {
            for (var key in finalList) {
                if(key.endsWith("__c") && !key.startsWith(namespace +"__") ) {
                    finalList[namespace + "__"+key] = finalList[key];
                }
            }
        }
        console.log('74'+ JSON.stringify(finalList));
        var action = component.get("c.ConfigRecordUpdate");
        action.setParams({
            configRec:JSON.stringify(finalList) 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState() === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Save Record Success',
                    message: component.get("v.selTabId")+' Record has been saved successfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();    
            }
            
        });
        $A.enqueueAction(action);
        //helper.showScheduledBatch(component);
        component.set("v.Editable", true);
        component.set("v.ShowFrequencyComponent",false);
    },
    
    AddAGroupMember : function(component,event,helper) {
        component.set("v.FilterValue","");
        var ObjectName = event.getSource().get("v.ariaControls").toUpperCase();
        ObjectName=ObjectName.replace(/ +/g, "");
        var fieldSAPName = event.getSource().get("v.ariaDescribedBy");
        component.set("v.storebuttonName",fieldSAPName);
        console.log('ObjectName'+ObjectName + ''+ 'fieldSAPName'+fieldSAPName);
        var picklistIndicator="";
        var Tabvalue = component.get("v.selTabId");
        helper.addfilterstoField(component, event, helper,ObjectName,fieldSAPName,picklistIndicator);
        component.set("v.AddfiltertotheField",true);
    },
    
    handleChange: function (component, event) {
        //alert(event.getParam('value'));
        var selval = event.getParam('value');
        component.set("v.SelectedFilter",selval);
    },
    
    AddFiltervalueToField : function (component, event) {
        var selectedvalue = component.get("v.SelectedFilteroptions");
        var newStr = '';
        for(var i = 0 ; i<selectedvalue.length ; i++){
            if(i != (selectedvalue.length-1))
                newStr = newStr + selectedvalue[i]+',';
            else
                newStr = newStr+selectedvalue[i];        
        }
        var Tabvalue = component.get("v.selTabId");
        var fieldSAPName = component.get("v.storebuttonName");
        console.log('Tabvalue'+Tabvalue + '   fieldSAPName'+ fieldSAPName );
        
        if(Tabvalue == 'Customer'){
            if(fieldSAPName === 'KTOKD'){
                component.set("v.CustomerList.GYNCF_Account_Group__c ",newStr);
            }
            if(fieldSAPName === 'VKORG'){
                component.set("v.CustomerList.GYNCF_Sales_Org__c ",newStr);
            }
            if(fieldSAPName === 'VTWEG'){
                component.set("v.CustomerList.GYNCF_Distribution_Channel__c ",newStr);
            }
            if(fieldSAPName === 'SPART'){
                component.set("v.CustomerList.GYNCF_Division__c ",newStr);
            }       
        }
        if(Tabvalue == 'Materials'){
            if(fieldSAPName === 'MATKL'){
                component.set("v.MaterialList.GYNCF_Material_Group__c",newStr);
            }
            if(fieldSAPName === 'MTART'){
                component.set("v.MaterialList.GYNCF_Material_Type__c",newStr);
            }
            if(fieldSAPName === 'VKORG'){
                component.set("v.MaterialList.GYNCF_Sales_Org__c",newStr);
            }
            if(fieldSAPName === 'VTWEG'){
                component.set("v.MaterialList.GYNCF_Distribution_Channel__c",newStr);
            }    
        }
        if(Tabvalue == 'Equipment'){       
            if(fieldSAPName === 'VKORG'){
                component.set("v.EquipmentList.GYNCF_Sales_Org__c",newStr);
            }
            if(fieldSAPName === 'ISTAT'){
                component.set("v.EquipmentList.GYNCF_System_Status__c",newStr);
            }  
        }
        if(Tabvalue == 'Sales Order'){
            if(fieldSAPName === 'AUART'){
                component.set("v.SalesOrderList.GYNCF_Document_Type__c",newStr);
            }
            if(fieldSAPName === 'VKORG'){
                component.set("v.SalesOrderList.GYNCF_Sales_Org__c",newStr);
            }  
            if(fieldSAPName === 'VTWEG'){
                component.set("v.SalesOrderList.GYNCF_Distribution_Channel__c",newStr);
            }
            if(fieldSAPName === 'SPART'){
                component.set("v.SalesOrderList.GYNCF_Division__c",newStr);
            }  
            if(fieldSAPName === 'GBSTK'){
                component.set("v.SalesOrderList.GYNCF_Document_Status__c",newStr);
            }
        }
        if(Tabvalue == 'Quotation'){
            if(fieldSAPName === 'AUART'){
                component.set("v.QuotationList.GYNCF_Document_Type__c",newStr);
            }
            if(fieldSAPName === 'VKORG'){
                component.set("v.QuotationList.GYNCF_Sales_Org__c",newStr);
            }  
            if(fieldSAPName === 'VTWEG'){
                component.set("v.QuotationList.GYNCF_Distribution_Channel__c",newStr);
            }
            if(fieldSAPName === 'GBSTK'){
                component.set("v.QuotationList.GYNCF_Document_Status__c",newStr);
            } 
        }
        if(Tabvalue == 'Invoice'){
            if(fieldSAPName === 'FKART'){
                component.set("v.InvoiceList.GYNCF_Billing_Type__c",newStr);
            }
            if(fieldSAPName === 'BUKRS'){
                component.set("v.InvoiceList.GYNCF_Company_Code__c",newStr);
            }  
            if(fieldSAPName === 'VKORG'){
                component.set("v.InvoiceList.GYNCF_Sales_Org__c",newStr);
            }
        }
        
        component.set("v.AddfiltertotheField",false);
    },
    
    closeModel : function (component, event) {
        component.set("v.AddfiltertotheField",false);
    }
    
});