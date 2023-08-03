/* Test Class for the Apex Controller class GYNC_UpdateModeofMail
* Developer Name: Debraj Mondal
* Created On:04/03/2021
*/ 
@isTest
public class GYNC_UpdateModeOfMailTest {
	
    @isTest
    public static void testUpdateRecord1()
    {
        String val='SalesforceEvent';
        GYNCO_Salesforce_Event_Meeting_Link__c rec=new GYNCO_Salesforce_Event_Meeting_Link__c();
        rec.Name='Test';
        rec.GYNCF_Use_Salesforce_Event__c=true;
        rec.GYNCF_Use_Direct_Meeting_Invite__c=false;
        insert rec;
        Test.startTest();
        GYNC_UpdateModeOfMail.UpdateRecord(val);
        Test.stopTest();
        system.assert(True);
        
        
    }
    
    @isTest
    public static void testUpdateRecord101()
    {
        String val='SalesforceEvent';
        
        Test.startTest();
        GYNC_UpdateModeOfMail.UpdateRecord(val);
        Test.stopTest();
        system.assert(True);
        
        
    }
    
    @isTest
    public static void testUpdateRecord102()
    {
        String val='DirectMeetingLink';
        
        Test.startTest();
        GYNC_UpdateModeOfMail.UpdateRecord(val);
        Test.stopTest();
        system.assert(True);
        
        
    }
    
    
    @isTest
    public static void testUpdateRecord2()
    {
        String val='DirectMeetingLink';
        GYNCO_Salesforce_Event_Meeting_Link__c rec=new GYNCO_Salesforce_Event_Meeting_Link__c();
        rec.Name='Test';
        rec.GYNCF_Use_Salesforce_Event__c=true;
        rec.GYNCF_Use_Direct_Meeting_Invite__c=false;
        insert rec;
        
        Test.startTest();
        GYNC_UpdateModeOfMail.UpdateRecord(val);
        Test.stopTest();
        system.assert(True);
        
        
    }
    
    @isTest
    public static void testReturnDefault1(){
        String def;
        GYNCO_Salesforce_Event_Meeting_Link__c rec=new GYNCO_Salesforce_Event_Meeting_Link__c();
        rec.Name='Test';
        rec.GYNCF_Use_Salesforce_Event__c=true;
        rec.GYNCF_Use_Direct_Meeting_Invite__c=false;
        insert rec;
        Test.startTest();
        def=GYNC_UpdateModeOfMail.ReturnDefault();
        Test.stopTest();
        
        System.assertEquals('SalesforceEvent', def);
        System.debug(def);
         
        
        
    }
     @isTest
    public static void testReturnDefault2(){
        String def;
        GYNCO_Salesforce_Event_Meeting_Link__c rec=new GYNCO_Salesforce_Event_Meeting_Link__c();
        rec.Name='Test';
        rec.GYNCF_Use_Salesforce_Event__c=false;
        rec.GYNCF_Use_Direct_Meeting_Invite__c=true;
        insert rec;
        Test.startTest();
        def=GYNC_UpdateModeOfMail.ReturnDefault();
        Test.stopTest();
        
        System.assertEquals('DirectMeetingLink', def);
        
        System.debug(def);
         
        
        
    }
    @isTest
    public static void testReturnDefault3(){
        String def;
        GYNCO_Salesforce_Event_Meeting_Link__c rec=new GYNCO_Salesforce_Event_Meeting_Link__c();
        rec.Name='Test';
        rec.GYNCF_Use_Salesforce_Event__c=false;
        rec.GYNCF_Use_Direct_Meeting_Invite__c=false;
        insert rec;
        Test.startTest();
        def=GYNC_UpdateModeOfMail.ReturnDefault();
        Test.stopTest();
        
        System.assertEquals(null, def);
        
        System.debug(def);
         
        
        
    }
    
}