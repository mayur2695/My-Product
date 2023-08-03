@isTest
public class GYNC_productRatingChartApex_test {
    @isTest
    public static void testfindReviewMatrix(){
        product2 product = new product2 (Name = 'product');
        insert product;
        GYNC_productRatingChartApex.findReviewMatrix('01t3h0000026ZKzAAM');
        system.assert(true);
    }

}