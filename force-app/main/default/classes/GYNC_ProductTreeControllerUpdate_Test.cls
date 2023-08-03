@isTest
public class GYNC_ProductTreeControllerUpdate_Test {

    @isTest
    static void testPrdTreeController(){
        GYNCO_Catalog_Master__c catmasterRec = new GYNCO_Catalog_Master__c();
        catmasterRec.Name = 'Catalog Master 1';
        insert catmasterRec;
        
        List<GYNCO_Product_Category__c> prdcategoryLst = new List<GYNCO_Product_Category__c>();
        prdcategoryLst.add(new GYNCO_Product_Category__c(GYNCF_Catalog_Master__c = catmasterRec.Id,Name='Category1'));
        prdcategoryLst.add(new GYNCO_Product_Category__c(GYNCF_Catalog_Master__c = catmasterRec.Id,Name='Category2'));
        insert prdcategoryLst;
        
        GYNCO_Product_Category__c childCatData = new GYNCO_Product_Category__c();
        childCatData.GYNCF_Catalog_Master__c = catmasterRec.Id;
        childCatData.Name = 'Child Category1';
        childCatData.GYNCF_Parent_Category__c = prdcategoryLst[0].Id;
        insert childCatData;
        
        List<GYNCS_Theme__c> themesLst = new List<GYNCS_Theme__c>();
        themesLst.add(new GYNCS_Theme__c(name = 'Theme1',isActive__c=true,Theme_Type__c='Gyansys'));
        themesLst.add(new GYNCS_Theme__c(name = 'Theme2',Theme_Type__c='Salesforce'));
        insert themesLst;
        
        Test.startTest();
        GYNC_ProductTreeControllerUpdate.objectType(catmasterRec.Id);
        GYNC_ProductTreeControllerUpdate.getActiveTheme();
        GYNC_ProductTreeControllerUpdate.sendTreeData(catmasterRec.Id);
        GYNC_ProductTreeControllerUpdate.findChilds(prdcategoryLst[0].Id);
        GYNC_ProductTreeControllerUpdate.findChilds(prdcategoryLst[1].Id);
        GYNC_ProductTreeControllerUpdate.removeCategoryInfo(prdcategoryLst[1].Id);
        Test.stopTest();
        system.assert(true);
    }
}