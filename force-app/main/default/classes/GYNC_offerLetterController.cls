public with sharing class GYNC_offerLetterController {
    
    @AuraEnabled
    public static GYNCO_Offer_Letter_Template__c createTemplate(GYNCO_Offer_Letter_Template__c template){
        upsert template;
        System.debug(template);
        return template;
    }
}