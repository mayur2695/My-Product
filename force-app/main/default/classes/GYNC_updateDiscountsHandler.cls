/* Handler class for Trigger GYNT_updateDiscounts
* Developer Name: Indrajit Mitra
* Created On:28/01/2021
*/ 


public with sharing class GYNC_updateDiscountsHandler {
    
    public static void discountUpdate(List<OrderItem> oItemList){
        Set<ID> oItemProduct= new Set<ID>();
        System.debug('oItemList->'+ oItemList);
        Set<ID> orderItemID= new Set<ID>();
        Boolean newOrder;
        for(OrderItem orderItemList: oItemList){
            orderItemID.add(orderItemList.OrderId);
        }
        System.debug('orderItemID->'+ orderItemID);
        List<Order> orderList= new List <Order>();
        Set<id> SaID= new Set<id>();
        orderList=[select id,SalesAgreementId from Order where id IN: orderItemID];
        System.debug('orderList->'+orderList);
        for(Order objTest: orderList){
           
                SaID.add(objTest.SalesAgreementId);
        }
        System.debug('newOrder->'+ newOrder);
        System.debug('SaID->'+ SaID);

        List<SalesAgreementProduct> saList = new List<SalesAgreementProduct>();
        saList=[select id, DiscountPercentage,SalesAgreementId,ProductId from SalesAgreementProduct where SalesAgreementId IN:SaID];
        System.debug('saList->'+saList);
        for(SalesAgreementProduct sa : saList){
            for(OrderItem obj: oItemList){
                System.debug('Sales Agreement Discount Percentage->'+ sa.DiscountPercentage);
                if(sa.ProductId == obj.Product2Id ){
                    obj.Discount_Percentage__c = sa.DiscountPercentage;
                }
                System.debug('Order Item Discount Percentage->'+ obj.Discount_Percentage__c);
            }
            
        }
    }
}