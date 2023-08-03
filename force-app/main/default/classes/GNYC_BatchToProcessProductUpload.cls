global with sharing class GNYC_BatchToProcessProductUpload implements Database.Batchable<sObject>, Database.Stateful {
    
    private List<Product2> ProductList;
    public GNYC_BatchToProcessProductUpload(List<Product2> ProductListData) {
        ProductList = ProductListData;
    }
    
    global List<Product2> start(Database.BatchableContext BC) {
        return ProductList;
    }
    
    global void execute(Database.BatchableContext BC, List<Product2> ProdListUpdate) {
        update ProdListUpdate;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}