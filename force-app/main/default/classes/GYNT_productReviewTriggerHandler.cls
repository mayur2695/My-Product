public with sharing class GYNT_productReviewTriggerHandler {
    public static void calculateOverallRating(List<GYNCO_Product_Review__c> reviewList){
        Set<id> prodIdSet = new set<id>();
        List<Product2> proIdList= new List<Product2>();
        for(GYNCO_Product_Review__c prod : reviewList){
            prodIdSet.add(prod.GYNCF_Product__c);
        }
        proIdList = [SELECT id,GYNCF_Average_Rating__c, (SELECT GYNCF_Rating__c FROM Reviews__r) FROM Product2 WHERE Id IN :prodIdSet];
        
        for(Product2 prod : proIdList ){
            Integer reviewCount = prod.Reviews__r.size();
            Integer sum = 0;
            for(GYNCO_Product_Review__c review : prod.Reviews__r){
                sum = sum + Integer.valueOf(review.GYNCF_Rating__c);
            }
            prod.GYNCF_Average_Rating__c = Decimal.valueOf(sum)/reviewCount;
        }
        update proIdList;
    }
}