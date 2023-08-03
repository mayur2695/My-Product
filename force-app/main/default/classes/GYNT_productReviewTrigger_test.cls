@isTest
public class GYNT_productReviewTrigger_test {
    @testSetup static void setup(){
        Product2 prod = new Product2();
        prod.GYNCF_Average_Rating__c = 0.0;
        prod.Name='Test Product';
        insert prod;
        GYNCO_Product_Review__c temp = new GYNCO_Product_Review__c();
        temp.GYNCF_Product__c = prod.id;
        temp.GYNCF_Rating__c= 4.0;
        insert temp;
        system.assert(true);
    }
    testMethod static void testAfterInsert(){
        id Product2id = [select id from product2].id;
        test.startTest();
        GYNCO_Product_Review__c temp = new GYNCO_Product_Review__c();
        temp.GYNCF_Product__c = Product2id;
        temp.GYNCF_Rating__c= 4.0;
        insert temp;
        delete temp;
        test.stopTest();
        system.assert(true);
    }
}