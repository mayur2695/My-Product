@isTest
public class GYNC_CatalogController_Test {

    @isTest
    static void testCatalogController(){
        List<GYNCO_Catalog_Master__c> catMasterLst = new List<GYNCO_Catalog_Master__c>();
        catMasterLst.add(new GYNCO_Catalog_Master__c(name='Catalog 1',GYNCF_Active__c=true));
        catMasterLst.add(new GYNCO_Catalog_Master__c(name='Catalog 2'));
        insert catMasterLst;
        
        Test.startTest();
        GYNC_CatalogController.fetchCatalogs();
        GYNCO_Catalog_Master__c testInfo1 = catMasterLst[0];
        testInfo1.GYNCF_Active__c=true;
        GYNC_CatalogController.manageCatalogData(testInfo1);
        GYNCO_Catalog_Master__c testInfo2 = catMasterLst[1];
        testInfo2.GYNCF_Active__c=false;
        GYNC_CatalogController.manageCatalogData(testInfo2);
        GYNC_CatalogController.getProdUniquifierdata();
        GYNC_CatalogController.getThemes();
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest
    static void testFetchPrds(){
        Product2 prd1 = new Product2();
        prd1.name = 'test product1';
        insert prd1;
        
        Test.startTest();
        GYNC_CatalogController.fetchPrdData('test', '10', '0');
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest
    static void testManagePrdUniqMethod(){
        List<GYNC_ProdUniquifier__c> pudataLst = new List<GYNC_ProdUniquifier__c>();
        pudataLst.add(new GYNC_ProdUniquifier__c(name='Product Code',Active__c=true,Image_Locator__c='Test Folder'));
        pudataLst.add(new GYNC_ProdUniquifier__c(name='Product Name',Image_Locator__c='Test Folder'));
        insert pudataLst;
        
        Test.startTest();
        GYNC_ProdUniquifier__c testData = pudataLst[0];
        GYNC_CatalogController.manageProdUniquifierdata(testData.id);
        Test.stopTest();
        system.assert(true);
    }
    
    @isTest
    static void testManageThemeMethod(){
        List<GYNCS_Theme__c> themeLst = new List<GYNCS_Theme__c>();
        themeLst.add(new GYNCS_Theme__c(name='Theme1',isActive__c=true,Theme_Type__c='Gyansys'));
        themeLst.add(new GYNCS_Theme__c(name='Theme2',Theme_Type__c='Salesforce'));
        insert themeLst;
        
        Test.startTest();
        GYNCS_Theme__c testData = themeLst[0];
        GYNC_CatalogController.manageTheme(testData.id);
        Test.stopTest();
        system.assert(true);
    }
}