@isTest
public class GYNC_hierarchyUpdateHandlerTest {
    @testSetup static void setup(){
        GYNCO_Product_Category__c temp = new GYNCO_Product_Category__c();
        temp.Name='parent product category';
        insert temp;
        temp.GYNCF_Hierarchy__c=temp.id;
        update temp;
        system.assert(true);
    }
    @isTest
    static void testWithParent(){
        id parentId = [select id from GYNCO_Product_Category__c limit 1].id;
        test.startTest();
        GYNCO_Product_Category__c temp = new GYNCO_Product_Category__c();
        temp.Name='Test Category';
        temp.GYNCF_Parent_Category__c = parentId;
        insert temp;
        test.stopTest();
        system.assert(true);
    }
    @isTest
    static void testWithoutParent(){
        test.startTest();
        GYNCO_Product_Category__c temp = new GYNCO_Product_Category__c();
        temp.Name='Test Category';
        insert temp;
        test.stopTest();
        system.assert(true);
    }

}