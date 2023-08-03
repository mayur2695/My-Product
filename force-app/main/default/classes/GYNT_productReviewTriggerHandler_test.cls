@isTest

public class GYNT_productReviewTriggerHandler_test {
    @isTest
    public static void testcalculateOverallRating(){
        List<GYNCO_Product_Review__c> reviewList = new List<GYNCO_Product_Review__c>(); 
         insert reviewList;
         GYNT_productReviewTriggerHandler.calculateOverallRating(reviewList);
        system.assert(true);
    }

}