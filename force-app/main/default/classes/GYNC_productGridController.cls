public with sharing class GYNC_productGridController {
    @AuraEnabled
    public static List<Product2> getProductsWithImages(List<Product2> productsWithoutImages){
        System.debug('productsWithoutImages='+productsWithoutImages);
        String folderName= '';
        String uniqueIdentifier =''; 
        List<Product2> productsWithImages = new List<Product2>();
        for(GYNC_ProdUniquifier__c p : GYNC_ProdUniquifier__c.getAll().values()){
            if(p.Active__c == TRUE){
                folderName = p.Image_Locator__c;
                uniqueIdentifier = p.Name;
                break;
            }
        }
        List<String> queryBy = new List<String>();
        for(Product2 each : productsWithoutImages){
            if(uniqueIdentifier.equals('Product Code')){
            	queryBy.add(each.ProductCode);
                System.debug('each.ProductCode'+each.ProductCode);
            }
            else if(uniqueIdentifier.equals('Product Id')){
                queryBy.add(each.Id);
            }
            else if(uniqueIdentifier.equals('Product Name')){
                queryBy.add(each.Name);
            }
        }
        System.debug('queryBy='+queryBy);
        String query = 'SELECT Id, Title FROM ContentFolderItem WHERE ParentContentFolderId IN (SELECT Id FROM ContentFolder WHERE Name =:folderName) AND Title IN: queryBy';
        List<ContentFolderItem> items = Database.query(query);
        Map<String, String> mapFileWithTitle = new Map<String, String>();
        Map<String, String> mapCVWithTitle = new Map<String, String>();
        for(ContentFolderItem each : items){
            mapFileWithTitle.put(each.Id, each.Title);
        }
        for(ContentVersion eachVersion : [SELECT Id,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: mapFileWithTitle.keyset()]){
            mapCVWithTitle.put(mapFileWithTitle.get(eachVersion.ContentDocumentId),eachVersion.Id);
        }
        for(Product2 eachProd : productsWithoutImages){
            String key = uniqueIdentifier.equals('Product Code') ?
                			eachProd.ProductCode :
            				uniqueIdentifier.equals('Product Id') ?
                                eachProd.Id :
            					uniqueIdentifier.equals('Product Name') ?
                                    eachProd.Name :
            						'';
            System.debug('Key='+key);
            System.debug('mapCVWithTitle='+mapCVWithTitle);
            eachProd.GYNCF_ImageDoc__c = mapCVWithTitle.get(key);
            productsWithImages.add(eachProd);
        }
        return productsWithImages;
    }
}