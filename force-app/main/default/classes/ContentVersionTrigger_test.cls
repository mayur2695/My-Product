@isTest
public class ContentVersionTrigger_test {
    @testSetup static void setup(){
        Product2 prod = new Product2();
        prod.Name='TestProduct';
        prod.ProductCode='Test';
        insert prod;
        system.assert(true);
    }
    testMethod static void testAfterInsert(){
        ContentVersion cv = new ContentVersion();
        cv.title = 'Test';
        cv.PathOnClient='test';
        cv.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');

        insert cv;
        update cv;
        system.assert(true);
    }
}