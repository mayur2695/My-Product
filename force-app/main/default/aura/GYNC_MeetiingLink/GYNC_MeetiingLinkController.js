({
	doCancel : function(component, event, helper) // executes when cancel button is clicked
    {
		component.set("v.MeetingLink", "");// erasing MeetingLink component
	},
    doSave : function(component, event, helper) // ececutes when the save button is clicked
    {
        var PosId = component.get("v.recordId");
        var action = component.get('c.UpdateRecord'); //calling UpdateRecord method 
        action.setParams({
            "recordId" : PosId,
            "Link" : component.get('v.MeetingLink')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                
                //Showing a success message
               var toastReference = $A.get("e.force:showToast");
               toastReference.setParams({
                type:"Success",
                title:"Success",
                message:"Meeting link is successfully uploaded",
                mode:"dismissible"
            });
            toastReference.fire();
            }
        });
        $A.enqueueAction(action);
        component.set("v.MeetingLink2", component.get('v.MeetingLink')); 
        component.set("v.MeetingLink", "");
    },
    doInit : function(component, event, helper) //executes when the component loads
    {
        var PosId = component.get("v.recordId"); 
        var action = component.get('c.IfMeetingLink'); //calling IfMeetingLink method
        action.setParams({
            "recordId" : PosId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
               component.set('v.IsOpen', a.getReturnValue().GYNCF_Send_Direct_Meeting_lnvite__c);//makes the component visible
               component.set('v.MeetingLink2', a.getReturnValue().GYNCF_Meeting_Link__c);// displays priviously entered meeting link
            }
             
        });
        $A.enqueueAction(action);
    }
})