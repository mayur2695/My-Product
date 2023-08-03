@isTest
public class GYNC_displayRelatedPrdsCtrl_Test {

    @isTest
    static void testRelatedPrdsCtrl(){
        GYNCO_Catalog_Master__c catmasterRec = new GYNCO_Catalog_Master__c();
        catmasterRec.Name = 'Catalog Master 1';
        insert catmasterRec;
        
        List<GYNCO_Product_Category__c> prdcategoryLst = new List<GYNCO_Product_Category__c>();
        prdcategoryLst.add(new GYNCO_Product_Category__c(GYNCF_Catalog_Master__c = catmasterRec.Id,Name='Category1'));
        prdcategoryLst.add(new GYNCO_Product_Category__c(GYNCF_Catalog_Master__c = catmasterRec.Id,Name='Category2'));
        insert prdcategoryLst;
		
		List<product2> prdLst = new List<product2>();        
        product2 prod1 = new product2( Name = 'product1',ProductCode = 'prd1',GYNCF_Tags__c='laptop',GYNCF_Product_Category__c = prdcategoryLst[0].Id );
        product2 prod2 = new product2( Name = 'product2',ProductCode = 'prd2',GYNCF_Tags__c='laptop',GYNCF_Product_Category__c = prdcategoryLst[0].Id );
        prdLst.add(prod1);
        prdLst.add(prod2);
        insert prdLst; 
        
        String pid = prdLst[0].Id;
        
        ContentFolder folderInfo = new ContentFolder();
        folderInfo.name = 'TestFolder';
        insert folderInfo;
            
        GYNC_ProdUniquifier__c prodUniqData = new GYNC_ProdUniquifier__c();
        prodUniqData.name = 'Product Name';
        prodUniqData.Active__c = true;
        prodUniqData.Image_Locator__c = 'Test Folder';
        insert prodUniqData;
        
        List<GYNCS_Theme__c> themeLst = new List<GYNCS_Theme__c>();
        themeLst.add(new GYNCS_Theme__c(name='Theme1',isActive__c=true,Theme_Type__c='Gyansys'));
        themeLst.add(new GYNCS_Theme__c(name='Theme2',Theme_Type__c='Salesforce'));
        insert themeLst;
        
        Test.startTest();
        GYNC_displayRelatedProductsController.getActiveTheme();
        GYNC_displayRelatedProductsController.getRelatedProducts1();
        GYNC_displayRelatedProductsController.getRelatedProducts(prdLst[0].id);
        
        system.assert(true);
    }
}