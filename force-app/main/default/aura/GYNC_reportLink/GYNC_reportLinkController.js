({
	OnClickStd : function(component, event, helper) 
    {
     var report = event.target.id;
     var action = component.get("c.getStandardReport");
     action.setParams({
     "reportLabel" : report
     });
     action.setCallback(this, function(response) {
     var state = response.getState();
     //alert(state);
     if (state === "SUCCESS") {
     var result = response.getReturnValue();
     var urlStandardreport = '/lightning/r/Report/'+ result + '/view';
     component.set("v.urlPlannedreport",urlStandardreport); }
     });
     $A.enqueueAction(action);
	},
    
    OnClickStd2 : function(component, event, helper) 
    {
     var report = event.target.id;
     var action = component.get("c.getStandardReport");
     action.setParams({
     "reportLabel" : report
     });
     action.setCallback(this, function(response) {
     var state = response.getState();
     //alert(state);
     if (state === "SUCCESS") {
     var result = response.getReturnValue();
     var urlStandardreport = '/lightning/r/Report/'+ result + '/view';
     component.set("v.urlPlannedreport2",urlStandardreport); }
     });
     $A.enqueueAction(action);
	},
    
    OnClickStd3 : function(component, event, helper) 
    {
     var report = event.target.id;
     var action = component.get("c.getStandardReport");
     action.setParams({
     "reportLabel" : report
     });
     action.setCallback(this, function(response) {
     var state = response.getState();
     //alert(state);
     if (state === "SUCCESS") {
     var result = response.getReturnValue();
     var urlStandardreport = '/lightning/r/Report/'+ result + '/view';
     component.set("v.urlPlannedreport3",urlStandardreport); }
     });
     $A.enqueueAction(action);
	}
})