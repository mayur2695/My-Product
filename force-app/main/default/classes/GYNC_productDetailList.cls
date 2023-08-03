public with sharing class GYNC_productDetailList {

     @AuraEnabled
        public static List <Product2> getDescription(String prodId) {
        List<Product2> prodList = [SELECT Id, Name,GYNCF_Average_Rating__c,GYNCF_Price__c,Prod_Image__c from Product2 WHERE Id=:prodId];
        return prodList;
        //return[SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId ='06955000001iz6RAAQ' LIMIT 1];
    } //01t55000003ms27AAA  LIMIT 1
    
    @AuraEnabled
    public static List <Product2> getDescription1(String prodId1) {
       List<Product2> prodList1 = [SELECT Description from Product2 WHERE Id=:prodId1];
        //prodList1[0].Description.replace('\r\n','||');
        //System.debug(prodList1);
        return prodList1;
    }
    
    @AuraEnabled
         public static id getContents(String prodId2){
         System.debug('Id Is:'+prodId2);
         String folderName= '';
         //String uniqueIdentifier =''; 
         //Id cId;
         Id Idtoreturn;
             for(GYNC_ProdUniquifier__c p : GYNC_ProdUniquifier__c.getAll().values()){
                 if(p.Active__c == TRUE){
                      folderName = p.Image_Locator__c;
                      //uniqueIdentifier = p.Name;
                 }
             }
             System.debug('FolderName is :: '+folderName);
                 Product2 prod = [SELECT Name,productCode from Product2 WHERE Id=:prodId2 LIMIT 1];
                 List<ContentFolderItem> cfiLst = [SELECT Id, Title FROM ContentFolderItem WHERE ParentContentFolderId IN (SELECT Id FROM ContentFolder WHERE Name =:folderName) AND Title =:prod.productCode limit 1];
             	 if(cfiLst.size() > 0){
                     Id cId = cfiLst[0].id; 
                     Idtoreturn = [select id from contentVersion where ContentDocumentId = :cId].id;
             	 }
             	 
                  System.debug('ID to return is :: '+Idtoreturn);
                 
             return Idtoreturn;
    }
    //Addded By Spandana 
   @AuraEnabled  
    public static String getActiveTheme(){
        String activeTheme = '';
        for(GYNCS_Theme__c th : GYNCS_Theme__c.getAll().values()){
            if(th.isActive__c == TRUE){
                activeTheme = th.Name;
                
            }
        }
        return activeTheme;
  
    }
    @AuraEnabled
    public static List<Product2> getImagesFromData(){
        return [SELECT Id, Name, ProductCode, Description, GYNCF_Average_Rating__c from Product2 Where GYNCF_Average_Rating__c != null ORDER BY GYNCF_Average_Rating__c DESC LIMIT 3];
    }
 }