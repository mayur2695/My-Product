public with sharing class GYNC_ProductTreeControllerUpdate {

    @AuraEnabled
    public static String objectType(Id objId) {
        Schema.SObjectType token = objId.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();
        return dr.getName();
    }
    
    @AuraEnabled
    public static string findChilds(Id categoryId){
        
        List<GYNCO_Product_Category__c> childCatData = [Select id,name from GYNCO_Product_Category__c where GYNCF_Parent_Category__c =: categoryId];
        List<Product2> associatedPrds = [Select id,name from Product2 where GYNCF_Product_Category__c =: categoryId];
        
        if(childCatData.isEmpty() && associatedPrds.isEmpty())
            return 'NoData';
        else return 'DataExists';
    }
    
    @AuraEnabled
    public static void removeCategoryInfo(Id catId){
        List<GYNCO_Product_Category__c> categoryInfo = [Select id,name from GYNCO_Product_Category__c where id =: catId];
        
        if(!categoryInfo.isEmpty())
        	delete categoryInfo;
    }
    
    @AuraEnabled
    public static TreeGird sendTreeData(Id catMasterId) {
        
        Set<String> CatNames = new Set<String>();
        Set<Id> cIds = new Set<Id>();
        
        List<GYNCO_Product_Category__c> cat = [select id, Name from GYNCO_Product_Category__c where GYNCF_Parent_Category__c =null and GYNCF_Catalog_Master__c=: catMasterId];
        
         for(GYNCO_Product_Category__c ctgry:cat) {
            CatNames.add(ctgry.name);
            cIds.add(ctgry.Id);
        }
        
        List<GYNCO_Product_Category__c> subCat = [select id, Name,GYNCF_Parent_Category__r.Name  from GYNCO_Product_Category__c where GYNCF_Parent_Category__c !=null ];// and GYNCF_Catalog_Master__c='a0A55000008okWQEAY'
        
        
        for(GYNCO_Product_Category__c sub: subCat) {
            CatNames.add(sub.Name);
        }
        
       
        List<product2> prodData = [select id, name, GYNCF_Product_Category__r.Name from product2 where GYNCF_Product_Category__r.Name IN : CatNames];
               
        TreeGird wrapData = new TreeGird();
        wrapData.mainTree=cat;
        wrapData.subTree = subCat;
        wrapData.prodList = prodData;
        return wrapData;
    }
    
    public class TreeGird {
         @AuraEnabled
         public List<GYNCO_Product_Category__c> mainTree {get;set;}
         @AuraEnabled
         public List<GYNCO_Product_Category__c> subTree {get;set;}
         @AuraEnabled
         public List<product2> prodList {get;set;}
    }
    // Added by spandana 05/27
         @AuraEnabled  
    public static String getActiveTheme(){
        List<GYNCS_Theme__c> prodList = [SELECT Id,Name,Description__c,Theme_Type__c,isActive__c 
                                         FROM GYNCS_Theme__c WHERE isActive__c = true
                                        ];
        return prodList[0].Name;   
    }
    // Ended
}