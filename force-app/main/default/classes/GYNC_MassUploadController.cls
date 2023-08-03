public with sharing class GYNC_MassUploadController {  
    @AuraEnabled
    public static string insertProducts(String ProductString, Integer insertPrefer){
        String queryField='';
        Map<String,Id> categoryDetailsMap=new Map<String,Id>();
        Map<String,Id> ProductsMap=new Map<String,Id>();
        List<Product2> MassProductList = new List<Product2> ();
        List<Product2> ProductLists = new List<Product2>();
        List<ProductWrapper> ProductWrapperInstance = (List<ProductWrapper>)JSON.deserialize(ProductString, List<ProductWrapper>.class);
        List<GYNCO_Product_Category__c> categoryDetails=new List<GYNCO_Product_Category__c>([Select id,name from GYNCO_Product_Category__c]);
        List<GYNC_ProdUniquifier__c> prodid = GYNC_ProdUniquifier__c.getall().values();
        System.debug('catalog details list'+categoryDetails);
  for(GYNC_ProdUniquifier__c customInstance: prodid){
            if(customInstance.Active__c==true){
                queryField=customInstance.name;
            }
        }
        for(GYNCO_Product_Category__c categoryInstance:categoryDetails){
            categoryDetailsMap.put(categoryInstance.Name,categoryInstance.Id);
        }
        Set<String> querydata=new Set<String>();
        System.debug('wrapperdata'+ProductWrapperInstance);
        System.debug('query data'+queryField);
        if(queryField=='Product Code'){
            System.debug('In');
            for(ProductWrapper wrapperInstance:ProductWrapperInstance){
                querydata.add(wrapperInstance.id);
                            System.debug('querydata0'+querydata);
            }
            System.debug('querydata1'+querydata);
            ProductLists= ([Select id,name,ProductCode from Product2 where ProductCode In:querydata]);
        }  
        else if(queryField=='Product Name'){
            for(ProductWrapper wrapperInstance:ProductWrapperInstance){
                querydata.add(wrapperInstance.id);
            }
            ProductLists= ([Select id,name,ProductCode from Product2 where Name In:querydata]);
        }        
        for(GYNC_ProdUniquifier__c customInstance: prodid){
            if(customInstance.Active__c==true){
                queryField=customInstance.name;
            }
        }
        if(queryField!='Product Id'){
        }
        System.debug(ProductLists);
        For (Product2 prodInstance:ProductLists){
            if(queryField=='Product Code'){
                ProductsMap.put(prodInstance.ProductCode,prodInstance.id);
            }  
            else if(queryField=='Product Name'){
                ProductsMap.put(prodInstance.name,prodInstance.id);
            }
        }
       
        for(ProductWrapper wrapperInstance:ProductWrapperInstance){
            Product2 ProductInstance= New Product2();
            if(queryField=='Product Id'){
                ProductInstance.id=wrapperInstance.id;
            }
            else{
                ProductInstance.id=ProductsMap.get(wrapperInstance.id);
            }
            ProductInstance.GYNCF_Price__c=wrapperInstance.Total_Price;
            ProductInstance.GYNCF_Tags__c=wrapperInstance.Tags;
            ProductInstance.GYNCF_Product_Category__c=categoryDetailsMap.get(wrapperInstance.Category_Name);
            MassProductList.add(ProductInstance);
        }
        System.debug(ProductsMap);
        GNYC_BatchToProcessProductUpload batchInstance = new GNYC_BatchToProcessProductUpload(MassProductList);
        Id batchInstanceId=database.executeBatch(batchInstance,2000);
        return 'Success';
    }
    @AuraEnabled
    public static string DownloadFIle(String FileName){
        ContentVersion oldCV = [Select Id,Title from ContentVersion Where title=:FileName ];
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        String URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+oldCV.Id;
        system.debug('Download URL:' +URlDownload);
        return URlDownload;
    }
    @AuraEnabled
    public static string insertCatalogs(String ProductString, Integer insertPrefer){
        Map<String,Id> categoryDetailsMap=new Map<String,Id>();
        Map<String,Id> catalogDetailsMap=new Map<String,Id>();
        Map<String,String> catalogCatalogMap=new Map<String,String>();
        List<CategoryWrapper> CategoryWrapperInstance = (List<CategoryWrapper>)JSON.deserialize(ProductString, List<CategoryWrapper>.class);
        String catalogId=[Select id from GYNCO_Catalog_Master__c where name=:CategoryWrapperInstance[0].Catalog_Name].id;
        List<GYNCO_Product_Category__c> categoryDetails=new List<GYNCO_Product_Category__c>([Select id,name,GYNCF_Hierarchy__c,GYNCF_Catalog_Master__r.Name,GYNCF_Catalog_Master__c from GYNCO_Product_Category__c]);
        List<GYNCO_Catalog_Master__c> catalogDetails=new List<GYNCO_Catalog_Master__c>([Select id,name from GYNCO_Catalog_Master__c]);
        System.debug('category details'+CategoryWrapperInstance);
        for(GYNCO_Product_Category__c categoryInstance:categoryDetails){
            categoryDetailsMap.put(categoryInstance.Name,categoryInstance.Id);
        }
        List<Id>topcategories=new List<Id>();
        for(GYNCO_Product_Category__c categoryInstance:categoryDetails){
            If(categoryInstance.GYNCF_Catalog_Master__c==catalogId)
                topcategories.add(categoryInstance.id);
        }
        for(GYNCO_Product_Category__c categoryInstance:categoryDetails){
            catalogCatalogMap.put(categoryInstance.Name,categoryInstance.GYNCF_Hierarchy__c.substring(0,18));
        }
        System.debug('categoryCatalogMap'+catalogCatalogMap);
       
        for(GYNCO_Catalog_Master__c catalogInstance:catalogDetails){
            catalogDetailsMap.put(catalogInstance.Name,catalogInstance.Id);
        }
        List<CategoryWrapper> CategoryWrapperInstanceUpdated = new List<CategoryWrapper>();
        List<GYNCO_Product_Category__c> categoryDetailsToUpsert=new List<GYNCO_Product_Category__c>();
        if(insertprefer==0)
        {
            for(CategoryWrapper wrapperInstance:CategoryWrapperInstance){
                if(wrapperInstance.Parent_Category_Name==''){
                    CategoryWrapperInstanceUpdated.add(wrapperInstance);
                }
            }
            CategoryWrapperInstance=CategoryWrapperInstanceUpdated;
        }
        for(CategoryWrapper wrapperInstance:CategoryWrapperInstance){
            GYNCO_Product_Category__c categoryInstance= New GYNCO_Product_Category__c();
            categoryInstance.Name=wrapperInstance.Category_Name;
            System.debug('CatalogId'+topcategories);
            System.debug('hirarcy'+catalogCatalogMap.get(wrapperInstance.Parent_Category_Name));
            System.debug('parent'+wrapperInstance.Parent_Category_Name);
            if(wrapperInstance.Parent_Category_Name!='' && wrapperInstance.Catalog_Name!='' && topcategories.contains(catalogCatalogMap.get(wrapperInstance.Parent_Category_Name))){
                categoryInstance.GYNCF_Parent_Category__c=categoryDetailsMap.get(wrapperInstance.Parent_Category_Name);
            }
            else if(wrapperInstance.Parent_Category_Name=='' && wrapperInstance.Catalog_Name!=''){
                categoryInstance.GYNCF_Catalog_Master__c=catalogDetailsMap.get(wrapperInstance.Catalog_Name);
            }
            if(wrapperInstance.Parent_Category_Name=='' && wrapperInstance.Catalog_Name == catalogCatalogMap.get(wrapperInstance.Category_Name)){
                System.debug('1'+WrapperInstance.category_Name);
                System.debug('2'+WrapperInstance.Catalog_Name);
                System.debug('3'+catalogCatalogMap.get(wrapperInstance.Category_Name));
                categoryInstance.Id=categoryDetailsMap.get(wrapperInstance.Category_Name);
            }
            else if(wrapperInstance.Parent_Category_Name!='' && topcategories.contains(catalogCatalogMap.get(wrapperInstance.Parent_Category_Name)) ){
                categoryInstance.Id=categoryDetailsMap.get(wrapperInstance.Category_Name);
            }
            else if((categoryInstance.Id==''|| categoryInstance.Id==null)){
                System.debug('else');
                categoryInstance.Id=null;
            }
            categoryDetailsToUpsert.add(categoryInstance);
        }
        System.debug('Category details'+categoryDetailsToUpsert);
        //database.upsert(categoryDetailsToUpsert);
        try {
            upsert categoryDetailsToUpsert;
        } catch(DmlException e) {
            // Process exception here
        }
        return 'Success';
    }
   
    public class CategoryWrapper{        
        public String Catalog_Name {get;set;}        
        public String Category_Name {get;set;}      
        public String Parent_Category_Name {get;set;}  
    }
    public class ProductWrapper{        
        public String id {get;set;}        
        public Decimal Total_Price {get;set;}      
        public String Tags {get;set;}  
        public String Category_Name {get;set;}      
    }
}