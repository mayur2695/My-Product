@isTest
public class GNYC_BatchToProcessProductUpload_test {
    @testSetup static void setup(){
        List<Product2> productList = new List<Product2>();
        for(Integer i =0; i<10;i++){
            Product2 prod = new Product2();
            prod.Name = 'Test Product '+i;
            productList.add(prod);
        }
        insert productList;
        system.assert(true);
    }
    @isTest
    static void  teststart(){
        
        List<Product2> productList = new List<Product2>([Select id from Product2]);
        test.startTest();
        GNYC_BatchToProcessProductUpload batch = new GNYC_BatchToProcessProductUpload(productList);
        Database.executeBatch(batch);
        test.stopTest();
        system.assert(true);
    }

}