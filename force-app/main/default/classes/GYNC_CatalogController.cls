public with sharing class GYNC_CatalogController {

    
    @AuraEnabled 
    public static List <GYNCO_Catalog_Master__c> fetchCatalogs() {
        //Qyery Catalog Records
        List<GYNCO_Catalog_Master__c> catList = [SELECT Id, Name, GYNCF_Active__c, 
                                    GYNCF_Description__c from GYNCO_Catalog_Master__c Order by Name LIMIT 10];
        //return list of Catalogs
        return catList;
    }
    
    @AuraEnabled
    public static List<Product2> fetchPrdData(string pname,String pageSize, String pageNumber) {
        //Query and return list of Contacts
        String searchKeyValue = '%'+pname+'%';
        
        List<Product2> searchResults = new List<Product2>();
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,name,GYNCF_Average_Rating__c,DisplayUrl,GYNCF_Product_Category__r.name,Description from Product2 where name LIKE: searchKeyValue LIMIT 100'));
        ssc.setpagesize(Integer.valueOf(pageSize));
        ssc.setPageNumber(Integer.valueOf(pageNumber));
        searchResults = (List<Product2>)ssc.getRecords();
        return searchResults;
    }
    
    @AuraEnabled
    public static void manageCatalogData(GYNCO_Catalog_Master__c selCatalog){
        //system.debug('selCatalog  incoming Value>>>>>'+selCatalog);
        if(selCatalog != NULL) {
            if(selCatalog.GYNCF_Active__c == true){
                updateCData(selCatalog);
            } else {
                update selCatalog;
            }
        }   
    }
    
    public static void updateCData(GYNCO_Catalog_Master__c selCatalog){
        List<GYNCO_Catalog_Master__c> existedActiveCatalogData = [Select id,name,GYNCF_Active__c,
                                                                          GYNCF_Description__c from GYNCO_Catalog_Master__c where GYNCF_Active__c = true];
                //upsert selCatalog;
                for(GYNCO_Catalog_Master__c temp: existedActiveCatalogData){
                    if(temp.id != selCatalog.id)
                        temp.GYNCF_Active__c = false;
                }
                if(!existedActiveCatalogData.contains(selCatalog))
                    existedActiveCatalogData.add(selCatalog);
                
                upsert existedActiveCatalogData;

   }
    
   @AuraEnabled
    public static list<GYNC_ProdUniquifier__c> getProdUniquifierdata(){
        
        Map<String, GYNC_ProdUniquifier__c> prodUniqData = GYNC_ProdUniquifier__c.getAll();
        
        //system.debug('Size>>>>'+prodUniqData.size());
        //system.debug('Data>>>'+prodUniqData.values());
        
        return prodUniqData.values();   
    }
    
    
     @AuraEnabled
    public static void manageProdUniquifierdata(Id pid){
        Map<String, GYNC_ProdUniquifier__c> prodUniqData = GYNC_ProdUniquifier__c.getAll();
        
        for (GYNC_ProdUniquifier__c rec : prodUniqData.values()){
            if(rec.Id == pid){
                rec.Active__c = true;
            }else{
                rec.Active__c = false;
            }        
        }
        //system.debug('Updated Data>>>>'+prodUniqData.values());
        update prodUniqData.values();
       
    } 
   
    
    // Added By Spandana
    @AuraEnabled
    public static list<GYNCS_Theme__c> getThemes(){
        List<GYNCS_Theme__c> themeList =  GYNCS_Theme__c.getAll().values();
  //  List<GYNCS_Theme__c> themeList = [SELECT Id,Name,Description__c,Theme_Type__c,isActive__c FROM GYNCS_Theme__c  ];
        return themeList;   
    }
    
    
     @AuraEnabled
    public static void manageTheme(Id themeid){
      //  List<GYNCS_Theme__c> themeLst = [SELECT Id,Name,Description__c,Theme_Type__c,isActive__c 
       //                                  FROM GYNCS_Theme__c ];
      List<GYNCS_Theme__c> themeLst = GYNCS_Theme__c.getAll().values();
        for (GYNCS_Theme__c themerec : GYNCS_Theme__c.getAll().values()){
            if(themerec.Id == themeid){
                themerec.isActive__c = true;
            }else{
                themerec.isActive__c = false;
            }        }
        //system.debug('themeid'+themeid);
        update themeLst;
       
    }
    // ENded By SPandana
}