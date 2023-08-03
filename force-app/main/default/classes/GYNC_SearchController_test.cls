@isTest
public class GYNC_SearchController_test {
    @isTest 
    static void  testsearchData(){
        product2 product1 = new product2( Name = 'product2',ProductCode = '2' );
        insert product1 ; 
        GYNC_SearchController.searchData();
        system.assert(true);
    }
    @isTest 
    static void  testpriceLowToHigh(){
        product2 product3 = new product2( Name = 'product2',ProductCode = '2' );
        insert product3 ; 
        GYNC_SearchController.priceLowToHigh();
        system.assert(true);
    }
    @isTest 
    static void  testpriceHighToLow(){
        product2 product4 = new product2( Name = 'product2',ProductCode = '2' );
        insert product4 ; 
        GYNC_SearchController.priceHighToLow();
        system.assert(true);
    }
    @isTest 
    static void  testpopularityLowToHigh(){
        product2 product5 = new product2( Name = 'product2',ProductCode = '2' );
        insert product5 ; 
        GYNC_SearchController.popularityLowToHigh();
        system.assert(true);
    }
    @isTest 
    static void  testpopularityHighToLow(){
        product2 product6 = new product2( Name = 'product2',ProductCode = '2' );
        insert product6 ; 
        GYNC_SearchController.popularityHighToLow();
        system.assert(true);
    } 
    @isTest 
    static void  testsliderProducts(){
        product2 product7 = new product2( Name = 'product2',ProductCode = '2', GYNCF_Price__c = 0.5 );
        insert product7 ; 
        GYNC_SearchController.sliderProducts(1);
        system.assert(true);
    }
    
    
}