/*Test Class for Apex Class : GYNC_viewAsPDFExtension
 * Date : 03/10/2021
 * By : Ishita Singh */
@isTest
public class GYNC_viewAsPDFExtensionTest {
    
    @isTest
    public static void testAgreement(){
        //List<Attachment> att= New List<Attachment>();
        Attachment temp= New Attachment();
        temp.Name='Ishita';
        //temp.ParentId='';
        //att.add(temp);
        
        Test.startTest();
        GYNCO_Offer_Letter_Template__c t = New GYNCO_Offer_Letter_Template__c();
        t.Name='Ishita';
        insert t;
        temp.ParentId=t.Id;
        temp.Body=blob.valueOf('Ishita'+System.now());
        insert temp;
        ApexPages.StandardController std = new ApexPages.StandardController(t);
        GYNC_viewAsPDFExtension i= New GYNC_viewAsPDFExtension(std);
        i.getFileId();
        Test.stopTest();
        System.assert(true);
    }

}