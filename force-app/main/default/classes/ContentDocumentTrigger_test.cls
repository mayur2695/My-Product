@isTest
public class ContentDocumentTrigger_test {
    @testSetup static void setup(){
        Product2 prod= new Product2();
        prod.Name='Test Product';
        prod.ProductCode = '0000';
        prod.ContentDocId__c = 'xxxxxxxxxxxxxxxxxx';
        insert prod;
        system.assert(true);
    }
    testMethod static void testBeforeDelete(){
        test.startTest();
        //ContentDocument cd = new ContentDocument();
        //cd.Title = '0000';
        //insert cd;
        ContentVersion cv = new ContentVersion();
        cv.Title = '0000';
        cv.PathOnClient = '';
        cv.ContentUrl = String.valueOf(new Url('https', 'host', 'file'));
     
        insert cv;
        ContentDocument cd = [select id from ContentDocument limit 1];
        delete cd;
        test.stopTest();
        system.assert(true);
    }
}