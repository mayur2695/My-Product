@isTest
public class GYNC_TemplateAUTOActivisionTest {
    
    @isTest
    public static void testAgreements1(){
        
   LIST<GYNCO_Offer_Letter_Template__c> temp = New LIST<GYNCO_Offer_Letter_Template__c>();
        GYNCO_Offer_Letter_Template__c t = NEW GYNCO_Offer_Letter_Template__c();
    t.Name = 'Wipro';
    t.GYNCF_Template__c='hi';
        temp.add(t);
      //  insert temp;
        
    Test.startTest();
    
    GYNC_TemplateAutoActivision.ActiveFirstTemplate(temp);
        
    Test.stopTest();
    System.assert(true);
    }
}