({
	doInit : function(component, event, helper) {
		var finalArrray=[];
        var objectData= new Object();
        objectData.iconName="quotes";
        objectData.ObjectName="Quotation";
        objectData.feature="quoteFlag";
        objectData.field='GYNPS_quotePermission__c';
        finalArrray.push(objectData);
        var objectData1= new Object();
        objectData1.iconName="orders";
        objectData1.ObjectName="Sales Order";
        objectData1.feature="orderFlag";
        objectData1.field='GYNPS_orderPermission__c';
        finalArrray.push(objectData1);
        var objectData2= new Object();
        objectData2.iconName="drafts";
        objectData2.ObjectName="Invoice";
        objectData2.feature="invoiceFlag";
        objectData2.field='GYNPS_invoicePermission__c';
        finalArrray.push(objectData2);
        var objectData3= new Object();
        objectData3.iconName="avatar";
        objectData3.ObjectName="Admin";
        objectData3.feature="adminSalesConnectFlag";
        objectData3.field='GYNPS_adminSalesConnectPermission__c';        
        finalArrray.push(objectData3);
        var objectData4= new Object();
        objectData4.iconName="custom";
        objectData4.ObjectName="Any Data Connect";
        objectData4.feature="anyConnectFlag";
        objectData4.field='GYNPS_anyConnectPermission__c';        
        finalArrray.push(objectData4);
        component.set("v.MainList",finalArrray);
	}
})