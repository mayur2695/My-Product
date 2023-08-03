public with sharing class OrderNewButtonController {
    
    @AuraEnabled
    public static List<SalesAgreement> fetchSalesAggrement(String accountId){
       List<SalesAgreement> salesList = new List<SalesAgreement>();
        salesList=[select id,Name,AccountId from SalesAgreement where AccountId=:accountId ];
        
        return salesList;
    }

}