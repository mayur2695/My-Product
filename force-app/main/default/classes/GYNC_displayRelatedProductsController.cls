public with sharing class GYNC_displayRelatedProductsController {
@AuraEnabled
    public static List<product2> getRelatedProducts1(){
        List<product2> prodList = [Select Id, Name,DisplayUrl,GYNCF_Average_Rating__c,GYNCF_Price__c,Prod_Image__c,ContentDocId__c
                                   FROM product2
                                 ];
        return prodList;   
    }
    
@AuraEnabled
    public static List < product2 > getRelatedProducts(ID prodId) {
        List < product2 > prodList = [SELECT Id, Name, DisplayUrl, GYNCF_Average_Rating__c, GYNCF_Price__c,
                                      GYNCF_Product_Category__c, GYNCF_Tags__c, Prod_Image__c, ContentDocId__c
                                      FROM product2 WHERE Id =: prodId
                                     ];
        String productCategoryId;
        for (product2 prd: prodList) {
            productCategoryId = prd.GYNCF_Product_Category__c;
        }
        List < product2 > prodCatLst = [SELECT Id, Name, DisplayUrl, GYNCF_Average_Rating__c, GYNCF_Price__c,
                                        GYNCF_Product_Category__c, GYNCF_Tags__c, Prod_Image__c, ContentDocId__c
                                        FROM product2 WHERE GYNCF_Product_Category__c =: productCategoryId
                                       ];
        List < productWrapper > prodWraplst = new List < productWrapper > ();
        Map < Id, Integer > prodMap = new Map < Id, Integer > ();
        Integer i = 0;
        list < product2 > finalProductLst = new list < product2 > ();
        for (Product2 prod: prodCatLst) {
            finalProductLst.add(prod);
            productWrapper pw = new productWrapper();
            pw.prodRecord = prod;
            prodWraplst.add(pw);
            prodMap.put(prod.Id, i++);
        }
        system.debug('prodWraplst' + prodWraplst);
        String query = 'SELECT Id, Name,DisplayUrl,GYNCF_Average_Rating__c,GYNCF_Price__c, GYNCF_Product_Category__c,GYNCF_Tags__c,Prod_Image__c,ContentDocId__c FROM product2 WHERE' + ' ';
        String searchTagFld = prodList[0].GYNCF_Tags__c;
        system.debug('search' + searchTagFld);
        List < String > splitstrTagFld = new List < String > ();
        if (searchTagFld != null) {
            splitstrTagFld = searchTagFld.split('[\\s#@&.?$+-]+');
            if (splitstrTagFld[0] == '') {
                splitstrTagFld.remove(0);
            }
            
            system.debug(splitstrTagFld);
            List < String > fields = new List < String > {
                'GYNCF_Tags__c'
                    };
                        List < String > fieldClause = new List < String > ();
            for (Integer j = 0; j <= splitstrTagFld.size() - 1; j++) {
                for (String field: fields) {
                    fieldClause.add(field + ' LIKE' + ' \'' + '%' + splitstrTagFld[j] + '%' + '\'');
                }
            }
            query += String.join(fieldClause, ' OR ');
            
            System.debug('****' + query);
            List < product2 > prodTagLst = Database.query(query);
            system.debug('prodtaglist****' + prodTagLst);
            for (Product2 prod: prodTagLst) {
                if (!prodMap.containsKey(prod.Id)) {
                    finalProductLst.add(prod);
                    productWrapper pw = new productWrapper();
                    pw.prodRecord = prod;
                    prodWraplst.add(pw);
                    prodMap.put(prod.Id, i++);
                }
            }
            system.debug('*****prodWraplst' + finalProductLst);
        }
        //  return prodWraplst;
        return finalProductLst;
    }
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
        public static id getContents(String prodId2) {
        System.debug('Id :::::'+prodId2);
        //Id = '01t55000003ms24AAA';
        Set<Id> contentIds = new Set<Id>();
            for(ContentDocumentLink contList :[SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Product2 where id =:prodId2) and LinkedEntity.Type='Product2']){
                        contentIds.add(contList.ContentDocumentId);
            }
        return [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN :contentIds limit 1].id;
        }
    public class productWrapper{
     @AuraEnabled 	public product2 prodRecord{get;set;}   
	/*@AuraEnabled 	public String Url{get;set;}
	@AuraEnabled 	public String Name{get;set;}
	@AuraEnabled 	public Decimal price{get;set;}
    @AuraEnabled     public Decimal Rating{get;set;}
    @AuraEnabled     public Id productId{get;set;}*/
    }
}