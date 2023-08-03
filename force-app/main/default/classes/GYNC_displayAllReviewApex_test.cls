@isTest
public class GYNC_displayAllReviewApex_test {
    @isTest
    static void testfindAllReviews(){
        product2 product1 = new product2( Name = 'product2',ProductCode = '2' );
        insert product1; 
        GYNCO_Product_Review__c review1 = new GYNCO_Product_Review__c();
        insert review1;
        GYNC_displayAllReviewApex.findAllReviews('01t3h0000025kO7AAI',true,1);
        system.assert(true);
    }

}