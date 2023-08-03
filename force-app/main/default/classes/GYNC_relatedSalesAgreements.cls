/* Controller class for the Lightning Component GYNL_relatedSalesAgreements
* Developer Name: Indrajit Mitra
* Created On:05/02/2021
*/ 


public with sharing class GYNC_relatedSalesAgreements {
    
// method to update the picklist with related Sales Agreements based on the product selected in the order level
    @AuraEnabled
    public static String fetchSalesAgreement(String orderItemid){
        List<OrderItem> oItemList= new List<OrderItem>();
        List<SalesAgreement> saList= new List<SalesAgreement>();
        oItemList = [select id,Product2Id,OrderId from OrderItem where id=: orderItemid];
        System.debug('oItemList->'+oItemList);
        Set<ID>oPID= new Set<ID>();
        for(OrderItem obj: oItemList){
            oPID.add(obj.Product2Id);
        }
        System.debug('oPID->'+oPID);
        List<SalesAgreementProduct> sapList = new List<SalesAgreementProduct>();
        sapList= [ select id,SalesAgreementId, ProductId from SalesAgreementProduct where ProductId IN: oPID];
        System.debug('sapList->'+sapList);
        Set<ID> sapListID = new Set<ID>();
        for(SalesAgreementProduct objSap:sapList ){
            sapListID.add(objSap.SalesAgreementId);
        }
        System.debug('sapListID->'+sapListID);
        saList= [select id,name,Status from SalesAgreement where id IN: sapListID and Status='Activated'];
        System.debug('saList->'+saList);
        
        return JSON.Serialize(saList);
        
    }
    
    
    // method to save the selected sales agreement from the picklist and map it to the product in the order level
    @AuraEnabled
    public static void updateSalesAgreement(String orderItemid,String selectedSA){
       System.debug('Inside updateSalesAgreement');
        System.debug('orderItemid->'+orderItemid);
        System.debug('selectedSA->'+selectedSA);
        Decimal db;
       OrderItem  newOrderItem = [select id,Sales_Agreement__c,Product2Id,Discount_Percentage__c from OrderItem where id=:orderItemid limit 1 ];
        System.debug('newOrderItem->'+newOrderItem);
       List<SalesAgreementProduct>sapL= [select DiscountPercentage from SalesAgreementProduct where SalesAgreementId=: selectedSA];
        for(SalesAgreementProduct obj: sapL){
            db= obj.DiscountPercentage;
        }
        System.debug('Discount Percentage->'+db);
        newOrderItem.Sales_Agreement__c = selectedSA;
        newOrderItem.Discount_Percentage__c = db;
        update newOrderItem;
        System.debug('newOrderItem->'+newOrderItem);
    }
}