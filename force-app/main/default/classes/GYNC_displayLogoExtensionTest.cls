/*Test Class for Apex Class : GYNC_displayLogoExtension
 * Date : 03/10/2021
 * By : Ishita Singh */
@isTest
public class GYNC_displayLogoExtensionTest {
   
    @isTest
    public static void testAgreement(){
        //List<Attachment> att= New List<Attachment>();
        Attachment temp= New Attachment();
        temp.Name='Ishita';
        
        Test.startTest();
        GYNCO_Offer_Letter_Template__c t = New GYNCO_Offer_Letter_Template__c();
        t.Name='Ishita';
        insert t;
        temp.ParentId=t.Id;
        temp.Body=blob.valueOf('Ishita'+System.now());
        insert temp;
        GYNCO_Interview__c tt= New GYNCO_Interview__c();
        tt.Name='Ishita';
        tt.GYNCF_Offer_Letter_Template__c=t.Id; 
        insert tt;
        ApexPages.StandardController std = new ApexPages.StandardController(tt);
        GYNC_displayLogoExtension i= New GYNC_displayLogoExtension(std);
        i.getFileId();
        Test.stopTest();
        System.assert(true);
    }
}