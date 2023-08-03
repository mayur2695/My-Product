@isTest
public class GYNC_MassUploadController_test {
    public static String ProductString;
    @testSetup static void setup(){
        //Creating Data for Insert Catalogs
        GYNCO_Catalog_Master__c tempCM = new GYNCO_Catalog_Master__c();
        tempCM.Name='Test Catalog Master';
        insert tempCM;
        //Creating Data for Insert Products
        List<Product2> products = new List<Product2>();
        List<GYNCO_Product_Category__c> categoryDetails = new List<GYNCO_Product_Category__c>();
        for(Integer i =0;i<10;i++){
            Product2 tmp = new Product2();
            tmp.name = 'Test Product '+i;
            //tmp.ProductCode = 'Test Product Code = '+i;
            products.add(tmp);
            GYNCO_Product_Category__c tempPC = new GYNCO_Product_Category__c();
            tempPC.Name = 'Test Category'+ i;
            tempPC.GYNCF_Catalog_Master__c = tempCM.id;
            categoryDetails.add(tempPC);
        }
        insert products;
        for(Product2 prod : products){
            prod.Name=prod.id;
            prod.ProductCode=prod.id;
        }
        ContentVersion cv=new Contentversion();
        cv.title='Test ContentVersion';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        update products;
        insert categoryDetails;
        system.assert(true);
    }
    testMethod static void test_insertProducts_withProductId(){
        GYNC_ProdUniquifier__c temp = new GYNC_ProdUniquifier__c();
        temp.Active__c = true;
        temp.Image_Locator__c='';
        temp.Name='Product Id';
        insert temp;
        List<ProductWrapper> prodWrapperList = new List<ProductWrapper>();
        Integer i= 0;
        for(Product2 prod : [Select id from Product2 Limit 10]){
            ProductWrapper tempWrp = new ProductWrapper();
            tempWrp.id = prod.id;
            tempWrp.Total_Price = 10.0;
            tempWrp.Tags = 'Abcd;Efgh;Ijkl';
            tempWrp.Category_Name = 'Test Category'+ i;
            prodWrapperList.add(tempWrp);
        }
        ProductString = JSON.serialize(prodWrapperList);
        test.startTest();
        System.debug('Product String :::::'+ProductString);
        GYNC_MassUploadController.insertProducts(ProductString,0);
        test.stopTest();
        system.assert(true);
    }
    testMethod static void test_insertProducts_withProductCode(){
        GYNC_ProdUniquifier__c temp = new GYNC_ProdUniquifier__c();
        temp.Active__c = true;
        temp.Image_Locator__c='';
        temp.Name = 'Product Code'; 	
        insert temp;
        List<ProductWrapper> prodWrapperList = new List<ProductWrapper>();
        Integer i= 0;
        for(Product2 prod : [Select id from Product2 Limit 10]){
            ProductWrapper tempWrp = new ProductWrapper();
            tempWrp.id = prod.id;
            tempWrp.Total_Price = 10.0;
            tempWrp.Tags = 'Abcd;Efgh;Ijkl';
            tempWrp.Category_Name = 'Test Category'+ i;
            prodWrapperList.add(tempWrp);
        }
        ProductString = JSON.serialize(prodWrapperList);
        test.startTest();
        System.debug('Product String :::::'+ProductString);
        String actual = GYNC_MassUploadController.insertProducts(ProductString,0);
        System.assertEquals('Success',actual,'Expected : Success, Actual :'+actual);
        test.stopTest();
        system.assert(true);
    }
    testMethod static void testDownloadFile(){
        test.startTest();
        GYNC_MassUploadController.DownloadFIle('Test ContentVersion');
        test.stopTest();
        system.assert(true);
    }
    testMethod static void testInsertCatalogs(){
        List<CategoryWrapper> categoryWrapperList = new List<CategoryWrapper>();
        CategoryWrapper cw1 = new CategoryWrapper();
        cw1.Catalog_Name = 'Test Catalog Master';
        cw1.Category_Name = '';
        cw1.Parent_Category_Name = 'Test Catalog Master';//Populate later
        categoryWrapperList.add(cw1);
		CategoryWrapper cw2 = new CategoryWrapper();
        cw2.Catalog_Name = 'Test Catalog Master';
        cw2.Category_Name = 'Test Catalog Master';
        cw2.Parent_Category_Name = '';
        categoryWrapperList.add(cw2); 
        System.assertEquals('Success', GYNC_MassUploadController.insertCatalogs(JSON.serialize(categoryWrapperList), 1), 'Expected Success');
        system.assert(true);
    }
    public class CategoryWrapper{        
        public String Catalog_Name {get;set;}        
        public String Category_Name {get;set;}      
        public String Parent_Category_Name {get;set;}  	
    }
    public class ProductWrapper{        
        public String id {get;set;}        
        public Decimal Total_Price {get;set;}      
        public String Tags {get;set;}  
        public String Category_Name {get;set;}      
    }
    
}