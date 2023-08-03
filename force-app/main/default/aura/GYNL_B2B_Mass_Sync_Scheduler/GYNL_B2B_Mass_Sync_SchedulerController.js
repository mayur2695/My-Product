({
    getCheckBoxValue : function(component, event, helper) {
        helper.getCheckBoxValueHelper(component);
        
    },
    selectedBatch : function(component,event,helper){
        var objName=component.get("v.ObjectName");
        var action = component.get("c.fetchScheduleRecord");
        action.setParams({
            ObjectName:objName,
            systemId:component.get("v.SystemId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState() === 'SUCCESS'){
                var results = response.getReturnValue();
                console.log('schedule List'+JSON.stringify(results));
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.BatchName",results.Name);
                        component.set("v.rdvalue",results.GYNCF_Frequency_Selected__c);
                        component.set("v.selectedDateValue",results.GYNCF_Day_of_Month_Selected__c);
                        component.set("v.selecteddatavalAttr",results.GYNCF_Day_of_Month_Selected__c);
                        if(results.GYNCF_Days_Selected__c != '' && results.GYNCF_Days_Selected__c !=undefined && results.GYNCF_Days_Selected__c !=null){
                        	component.set("v.value",results.GYNCF_Days_Selected__c.split(',')); 
                            component.set("v.dayselected",results.GYNCF_Days_Selected__c.split(','));
                        }
                        component.set("v.allDay",results.GYNCF_Everyday_Selected__c);
                        component.set("v.Everydaycheckbox",results.GYNCF_Everyday_Selected__c);
                        if(component.get("v.Everydaycheckbox") == true){
                            component.set("v.myDIV",false)
                        }
                        else{
                        	component.set("v.myDIV",true)    
                        }
                        component.set("v.variantCheck",results.GYNC_Batch_Variant__c);
                        component.set("v.selectedValue",results.GYNCF_Time_Selected__c);
                        component.set("v.timeVal",results.GYNCF_Time_Selected__c);
                    }), 500
                );
                
            }    
        });
        $A.enqueueAction(action); 
    },
    
    onCheck : function(component,event,helper){
        //Checked value to create crone
        
        helper.onCheckHelper(component);
    },
    
    loadOptions: function(component,helper) {
        component.set("v.rdvalue","W");
        component.set("v.globalDiv",true);
        component.set("v.weekly",true);
        component.set("v.mothlyid",false);
        component.set("v.selecteddatavalAttr",'');
        component.set("v.Everydaycheckbox",false);
        component.set("v.myDIV",true);
        component.set("v.value",[]);
        var opts = [
            { value: "None", label: "None" },
            { value: "1", label: "1:00" },
            { value: "2", label: "2:00" },
            { value: "3", label: "3:00" },
            { value: "4", label: "4:00" },
            { value: "5", label: "5:00" },
            { value: "6", label: "6:00" },
            { value: "7", label: "7:00" },
            { value: "8", label: "8:00" },
            { value: "9", label: "9:00" },
            { value: "10", label: "10:00" },
            { value: "11", label: "11:00" },
            { value: "12", label: "12:00" },
            { value: "13", label: "13:00" },
            { value: "14", label: "14:00" },
            { value: "15", label: "15:00" },
            { value: "16", label: "16:00" },
            { value: "17", label: "17:00" },
            { value: "18", label: "18:00" },
            { value: "19", label: "19:00" },
            { value: "20", label: "20:00" },
            { value: "21", label: "21:00" },
            { value: "22", label: "22:00" },
            { value: "23", label: "23:00" },
            { value: "24", label: "24:00" }
            
        ];
        component.set("v.option", opts);
        //var checkCmp = component.find("checkbox");
        var getTimeVal= component.get("v.option")
        console.log('The selected time is =====>'+getTimeVal);
        
    },
    
    getselectedValue: function(component){
        var getTimeVal= component.get("v.selectedValue")
        console.log('The selected time is =====>'+getTimeVal);
        //resultCmp = cmp.find("timeVal");
        component.set("v.timeVal",getTimeVal);
        console.log(component.get("v.timeVal"));
    },
    handleClick: function(component,event,helper){
        var BatchName=component.get("v.BatchName");
        //alert('$$$$'+component.get("v.SystemId"));
        var objName=component.get("v.ObjectName");
        var allstr= component.get("v.allDay");
        console.log(component.get("v.allDay"));
        var Timestr= component.get("v.timeVal");
        console.log(component.get("v.timeVal"));
        var daysel= component.get("v.dayselected");
        var getdateval= component.get("v.selecteddatavalAttr"); 
        var msgFrmEvent = component.getEvent("CronEvent");
        var crnstr;
        console.log('Both values are==>'+allstr+''+Timestr);
        //helper.createCroneExtensionHelper(allstr,Timestr);
        if(allstr== true && Timestr!= null && component.get("v.rdvalue")=='W'){
            //daily
            crnstr= '0'+' '+'0'+' '+Timestr+' '+'*'+' '+'*'+' '+'?';
            console.log('The crone extr1===>'+crnstr);
            
        }
        if(Timestr!= null && daysel.length>0 && component.get("v.rdvalue")=='W' && (allstr==null || allstr==false)){
            //var ds=daysel.split();
            ////weekly
            crnstr= '0'+' '+'0'+' '+Timestr+' '+'?'+' '+'*'+' '+daysel;
            console.log('The crone extr2===>'+crnstr);
        }
        if( getdateval!= null && Timestr!= null && component.get("v.rdvalue")=='M'){
            //monthly
            crnstr='0'+' '+'0'+' '+Timestr+' '+ getdateval+' '+'*'+' '+'?';
            console.log('The crone extr3===>'+crnstr);
        }
        msgFrmEvent.setParams({"CronFromParent": crnstr});
        msgFrmEvent.fire();
        console.log('final cron value'+crnstr);
        console.log('The crone getdateval===>'+getdateval);
        console.log('The crone Timestr===>'+Timestr);
        console.log('The crone daysel===>'+daysel);
        console.log(objName+' '+component.get("v.SystemId")+' '+BatchName);
        var action = component.get("c.scheduleBatch");
        action.setParams({
            ObjectName:objName,
            CronExpression:crnstr,
            systemId:component.get("v.SystemId"),
            batchName:BatchName,
            frequency:component.get("v.rdvalue"),
            dayOfMonth:getdateval,
            everydayCheck:component.get("v.Everydaycheckbox"),
            startTime:Timestr,
            selectedDays:daysel.toString(),
            isVariant:component.get("v.variantCheck")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState() === 'SUCCESS'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Batch Success',
                    message: objName+' Batch Scheduled Successfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                var result=response.getReturnValue();
                console.log('result'+result);
                toastEvent.fire(); 
                if(result != null && result!='' && result!=undefined){
                	var updateList = $A.get("e.c:GYNL_UpdateVariantList");
                    updateList.setParams({"message" :result }); 
                	updateList.fire();    
                }
               
                
            }
            else{
                let errors = response.getError();
                helper.handleErrors(errors);
            }
            //helper.getTime(component);
            //helper.getDays(component);
        });
        $A.enqueueAction(action);
        
    },
    
    onChangeRadioButton: function(component,event){
        //var weeklyElement = component.get("v.weekly");
        //var mothlyid = component.get("v.mothlyid");
        var radiovalue= component.get("v.rdvalue");
        //var globalDivVal = component.get("v.globalDiv");
        
        console.log('radiovalue'+radiovalue);
        if(radiovalue=='W'){
            //globalDivVal.classList.remove("slds-hide");
            component.set("v.globalDiv",true);
            //weeklyElement.classList.remove("slds-hide");
            component.set("v.weekly",true);
            //mothlyid.classList.add("slds-hide");
            component.set("v.mothlyid",false);
            component.set("v.selecteddatavalAttr",'');
            //document.getElementById("myForm").reset();
            component.set("v.Everydaycheckbox",false);
            component.set("v.myDIV",true);
            component.set("v.value",[]);
        }
        if(radiovalue=='M'){
            //globalDivVal.classList.remove("slds-hide");
            component.set("v.globalDiv",true);
            //weeklyElement.classList.add("slds-hide");
            component.set("v.weekly",false);
            //mothlyid.classList.remove("slds-hide");
            component.set("v.mothlyid",true);
            component.set("v.dayselected",'');
            //document.getElementById("myForm").reset();
            component.set("v.selectedDateValue","");
        }
        //helper.onChangeRadioButtonHelper(component,weeklyElement);
    },
    dataloadOptions: function (component,helper) {
        var optsdata = [
            { value: "None", label: "None" },
            { value: "1", label: "1" },
            { value: "2", label: "2" },
            { value: "3", label: "3" },
            { value: "4", label: "4" },
            { value: "5", label: "5" },
            { value: "6", label: "6" },
            { value: "7", label: "7" },
            { value: "8", label: "8" },
            { value: "9", label: "9" },
            { value: "10", label: "10" },
            { value: "11", label: "11" },
            { value: "12", label: "12" },
            { value: "13", label: "13" },
            { value: "14", label: "14" },
            { value: "15", label: "15" },
            { value: "16", label: "16" },
            { value: "17", label: "17" },
            { value: "18", label: "18" },
            { value: "19", label: "19" },
            { value: "20", label: "20" },
            { value: "21", label: "21" },
            { value: "22", label: "22" },
            { value: "23", label: "23" },
            { value: "24", label: "24" },
            { value: "25", label: "25" },
            { value: "26", label: "26" },
            { value: "27", label: "27" },
            { value: "28", label: "28" },
            { value: "29", label: "29" },
            { value: "30", label: "30" },
            { value: "31", label: "31" }
            
        ];
        component.set("v.Dateoption", optsdata);
        //var checkCmp = component.find("checkbox");
        var getTimeVal= component.get("v.Dateoption")
        console.log('The selected time is =====>'+getTimeVal);
        
    },
    
    
    dayMonth: function(component,event){
        var getdateval= component.get("v.selectedDateValue");
        component.set("v.selecteddatavalAttr",getdateval);
        console.log('getdateval==++'+getdateval);
    }
    
})