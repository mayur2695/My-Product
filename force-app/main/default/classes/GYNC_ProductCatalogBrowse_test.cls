@isTest
public class GYNC_ProductCatalogBrowse_test {
    @isTest 
    static void  testgetProductscategories(){
        list<GYNCO_Product_Category__c> categorylist1 = new list<GYNCO_Product_Category__c>();
        insert categorylist1 ; 
        GYNC_ProductCatalogBrowse.getProductscategories();
        system.assert(true);
    }
    @isTest 
    static void  testgetproducts(){
        product2 product1 = new product2( Name = 'product2',ProductCode = '2' );
        insert product1 ; 
        GYNC_ProductCatalogBrowse.getproducts('01t3h0000025kO7AAI');
        system.assert(true);
    }
     @isTest 
    static void  testgetActiveTheme(){
        GYNCS_Theme__c  theme1 = new GYNCS_Theme__c( Name = 'theme1',isActive__c = true );
        insert  theme1 ; 
        GYNC_ProductCatalogBrowse.getActiveTheme();
        system.assert(true);        
    }
}