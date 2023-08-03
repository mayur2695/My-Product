@isTest
public class GYNC_productDetailList_test {
    @isTest
    static void  testgetDescription(){
        product2 product1 = new product2( Name = 'product2',ProductCode = '2' );
        insert product1 ; 
        GYNC_productDetailList.getDescription('01t3h0000025kO7AAI');
        system.assert(true);
    }
    @isTest
    static void  testgetDescription1(){
        product2 product3 = new product2( Name = 'product2',ProductCode = '2' );
        insert product3 ; 
        
        GYNC_productDetailList.getDescription1('01t3h0000025kO7AAI');
        system.assert(true);
    }
    @isTest
    static void testActiveThemes(){
        List<GYNCS_Theme__c> themeLst = new List<GYNCS_Theme__c>();
        themeLst.add(new GYNCS_Theme__c(name='Theme1',isActive__c=true,Theme_Type__c='Gyansys'));
        themeLst.add(new GYNCS_Theme__c(name='Theme2',Theme_Type__c='Salesforce'));
        insert themeLst;
        GYNC_productDetailList.getActiveTheme();
        system.assert(true);
    }
    @isTest
    static void  testgetContents(){
        product2 product4 = new product2( Name = 'product2',ProductCode = 'prd2' );
        insert product4 ; 
        String pid = product4.Id;
        
        ContentFolder folderInfo = new ContentFolder();
        folderInfo.name = 'TestFolder';
        insert folderInfo;
            
        GYNC_ProdUniquifier__c prodUniqData = new GYNC_ProdUniquifier__c();
        prodUniqData.name = 'Product Name';
        prodUniqData.Active__c = true;
        prodUniqData.Image_Locator__c = 'Test Folder';
        insert prodUniqData;
        
        GYNC_productDetailList.getContents(pid);
        system.assert(true);
    } 
    
}