public class GYNC_displayAllReviewApex {
    @Auraenabled
    public static List<GYNCO_Product_Review__c> findAllReviews(Id productId, Boolean showAllReview, Integer recordCount){
        List<GYNCO_Product_Review__c> revList = new List<GYNCO_Product_Review__c>();
        if(showAllReview){
            revList = [SELECT name, Id, GYNCF_Review_Description__c, GYNCF_Rating__c, CreatedBy.Name FROM GYNCO_Product_Review__c where GYNCF_Product__c =:productId ORDER BY CreatedDate DESC ];
        }
        else{
            revList = [SELECT name, Id, GYNCF_Review_Description__c, GYNCF_Rating__c, CreatedBy.Name FROM GYNCO_Product_Review__c where GYNCF_Product__c =:productId ORDER BY CreatedDate DESC LIMIT :recordCount];
        }
        return revList;
    }
}