@isTest
public class GYNC_TemplateShowControllerTest {
    @isTest
    public static void FetchLookupTest()
    {
        String searchkey='Test';
        String obj='GYNCO_Offer_Letter_Template__c';
        String fld='name';
        GYNCO_Offer_Letter_Template__c olt=new GYNCO_Offer_Letter_Template__c(name='Test', 
                                                                              GYNCF_Template__c='GYNCO_Offer_Letter_Template__c',
                                                                              GYNCF_Active__c=true );
        insert olt;
        Test.startTest();
        
        GYNC_TemplateShowController.fetchLookUpValues(searchkey,obj,fld);
        Test.stopTest();
        System.assert(true);
    }
    
    @isTest
    public static void selectTemplateTest1()
    {
        Test.startTest();
     GYNCO_Offer_Letter_Template__c olt=new GYNCO_Offer_Letter_Template__c();
       olt.name='Wipro';
       olt.GYNCF_Template__c='Congratulations. You have been selected.';
       olt.GYNCF_Active__c=true;
       insert olt;
        GYNC_TemplateShowController.SelectTemplate(olt);
        Test.stopTest();
        System.assert(true);
    }
    
    @isTest
    public static void selectTemplateTest2()
    {
        LIST <GYNCO_Offer_Letter_Template__c> temp=new LIST <GYNCO_Offer_Letter_Template__c>();
        Test.startTest();
        GYNCO_Offer_Letter_Template__c olt=new GYNCO_Offer_Letter_Template__c();
        olt.name='Gyansys';
        olt.GYNCF_Template__c='Congratulations. You have been selected.';
        olt.GYNCF_Active__c=true;
        insert(olt);
        GYNCO_Offer_Letter_Template__c olt1=new GYNCO_Offer_Letter_Template__c();
       olt1.name='Wipro';
       olt1.GYNCF_Template__c='Congratulations. You have been selected.';
       olt1.GYNCF_Active__c=false;
        insert olt1;
        
        temp=GYNC_TemplateShowController.SelectTemplate(olt1);
        Test.stopTest();
        System.assertEquals(false,temp[0].GYNCF_Active__c);
    }
    @isTest
    public static void fetchTableDataTest()
    {
        LIST <GYNCO_Offer_Letter_Template__c> Temps = New List<GYNCO_Offer_Letter_Template__c>();
        GYNCO_Offer_Letter_Template__c[] olt=[SELECT Id,Name,GYNCF_Active__c,GYNCF_Template__c FROM GYNCO_Offer_Letter_Template__c];
        Test.startTest();
        Temps=GYNC_TemplateShowController.fetchTableData();
        Test.stopTest();
        System.assertEquals(olt, temps);
    }

}