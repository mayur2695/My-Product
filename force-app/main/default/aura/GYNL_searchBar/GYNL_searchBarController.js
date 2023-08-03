({
    
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
       //alert(getInputkeyWord);
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selection 
    clear :function(component,event,heplper){
        //alert(component.get("!v.selectedRecord"));
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
         //component.set("v.isOpen" , False);
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
        
         
         
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
           $A.util.addClass(lookUpTarget, 'slds-hide');
           $A.util.removeClass(lookUpTarget, 'slds-show'); 
	},
    openModel : function(component, event, helper) {
        component.set("v.isOpen", true);

       // component.set("v.listOfSearchRecords", null ); 
       // window.open("/lightning/r/GYNCO_Offer_Letter_Template__c/"+record.Id+"/edit?navigationLocation=DETAIL&backgroundContext=%2Flightning%2Fr%2FGYNCO_Offer_Letter_Template__c%2F"+record.Id+"%2Fview&count=3");
        //component.set("v.isOpen", true ); 
        //alert(component.get("!v.isOpen"));
        
    },
    openPreview : function(component, event, helper) {
      var recordId = component.get("v.selectedRecord").Id;   
        let urlVar ='/apex/GYNP_viewAsPDF?Id='+recordId;
        console.log('urlVar',urlVar);
       // alert(urlVar);
        window.open(urlVar, '_blank');
    /*    var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": urlVar
        });
        eUrl.fire();  */
    }
    
})