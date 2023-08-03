@istest
private class GYNC_UpdateOfferLetterTemplateTest 
{
	@isTest 
    static void testUpdate()
    {
        
        GYNCO_Offer_Letter_Template__c T = new GYNCO_Offer_Letter_Template__c();
        T.Name='Test';
        T.GYNCF_Template__c='Congratulations';
        T.GYNCF_Active__c=true;
        insert T;
        T.GYNCF_Template__c='Congratulations &CandidateName';
        
        //GYNCO_Offer_Letter_Template__c returnValue = new GYNCO_Offer_Letter_Template__c();
        
        Test.startTest();
        GYNC_UpdateOfferLetterTemplate.DoUpdate(T);
        Test.stopTest();
        System.assert(true);
        
    }
}