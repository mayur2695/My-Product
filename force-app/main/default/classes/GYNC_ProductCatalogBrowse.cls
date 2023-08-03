public with sharing class GYNC_ProductCatalogBrowse {
	@AuraEnabled
    public static List<GYNCO_Product_Category__c> getProductscategories(){
        return [SELECT Id, Name,GYNCF_Parent_Category__c,GYNCF_Level__c, GYNCF_Catalog_Master__r.GYNCF_Active__c FROM GYNCO_Product_Category__c ORDER BY GYNCF_Level__c ASC];
    }
    @AuraEnabled
    public static List<Product2> getproducts(string CategoryID){
        return [SELECT Id, Name,ProductCode,GYNF_Availability__c,GYNCF_Price__c,GYNCF_Product_Category__r.name,GYNCF_Average_Rating__c from Product2 Where GYNCF_Product_Category__c=: CategoryID]; 
    }
    @AuraEnabled  
    public static String getActiveTheme(){
        List<GYNCS_Theme__c> prodList = [SELECT Id,Name,Description__c,Theme_Type__c,isActive__c 
                                         FROM GYNCS_Theme__c WHERE isActive__c = true
                                        ];
        return prodList[0].Name;   
    }

    @AuraEnabled
    public static List<Product2> getImagesFromData(){
        return [SELECT Id, Name,Description,ProductCode,GYNCF_Average_Rating__c,ContentDocId__c  from Product2 Where GYNCF_Average_Rating__c != null ORDER BY GYNCF_Average_Rating__c DESC LIMIT 3];
       
    }
}