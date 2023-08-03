({    
  accountChange: function (component, event,helper) {
      var accountId =component.find("accountId").get("v.value");
      //Apex Callout
      console.log('entereing');
      var action = component.get("c.fetchSalesAggrement");
      action.setParams({
          "accountId":accountId
      });
      action.setCallback(this,function(response){
          console.log('after'+JSON.stringify(response.getReturnValue()));
          component.set("v.options",response.getReturnValue());
          component.set("v.accountChange",true);
      });
      $A.enqueueAction(action);
      
  //alert(component.find("accountId").get("v.value"));
  }
    
})