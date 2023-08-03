public with sharing class GYNC_UpdateOfferLetterTemplate 
{
     @AuraEnabled
     public static GYNCO_Offer_Letter_Template__c DoUpdate(GYNCO_Offer_Letter_Template__c Temp) 
     {
         GYNCO_Offer_Letter_Template__c T = New GYNCO_Offer_Letter_Template__c();
         T= [SELECT Id,Name,GYNCF_Template__c FROM GYNCO_Offer_Letter_Template__c WHERE ID =:Temp.Id];
         T.Name = Temp.Name;
         T.GYNCF_Template__c = Temp.GYNCF_Template__c;
        
         Update T;
         return T;
	 }
}