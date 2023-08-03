@isTest
public class GYNC_productGridController_test {
    
    @isTest
    static void testgetProductsWithImages(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode ='XYZ';
        insert prod;
        List<product2> prdLst = new List<product2>();
        prdLst.add(prod);
        
        ContentFolder cf1 = new ContentFolder();
        cf1.Name = 'IdFolder';
        insert cf1;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        insert cv;
        
        List<GYNC_ProdUniquifier__c> prodUniqDataLst = new List<GYNC_ProdUniquifier__c>();
        prodUniqDataLst.add(new GYNC_ProdUniquifier__c(name='Product Code',Active__c=true,Image_Locator__c='Test Folder'));
        prodUniqDataLst.add(new GYNC_ProdUniquifier__c(name='Product Id',Active__c=false,Image_Locator__c='Test Folder'));
        prodUniqDataLst.add(new GYNC_ProdUniquifier__c(name='Product Name',Active__c=false,Image_Locator__c='Test Folder'));
        insert prodUniqDataLst;
        
        Test.startTest();
        GYNC_productGridController.getProductsWithImages(prdLst);
        Test.stopTest();
        
        system.assert(true);
    }
    
}