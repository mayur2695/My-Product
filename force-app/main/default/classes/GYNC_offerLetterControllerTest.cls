/*Test class for Apex class GYNC_offerLetterController
 *Date : 03/09/2021
 *By : Ishita Singh*/
@isTest
public class GYNC_offerLetterControllerTest {
    
    @isTest
    public static void testAgreement(){
        GYNCO_Offer_Letter_Template__c temp= New GYNCO_Offer_Letter_Template__c();
        temp.Name='Ishita';
        temp.GYNCF_Template__c='Congratulations';
        upsert temp;
        System.debug(temp); 
        Test.startTest();
        GYNC_offerLetterController.createTemplate(temp);
        Test.stopTest();
        System.assert(true);
        
    }

}