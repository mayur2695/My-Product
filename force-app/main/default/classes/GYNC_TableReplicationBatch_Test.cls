/*
* @author: Debiprasad
* @testClassName: GYNC_TableReplicationBatch_Test
* @apexClass: GYNC_TableReplicationBatch
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 22nd Jun 2020
*/
@IsTest(SeeAllData=false)
public class GYNC_TableReplicationBatch_Test {
    @testSetup static void setup() {
        // Create common test data that will be used across the test class
         //GYNC_TestUtility.createUser();
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('Account', authSetting.Id, 'Account', 'https://www.testUrlcom/account', '', '', 500, 1, true);
        
    }
    @isTest static void executeBatchTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = GYNC_massSyncTabClass.findConfigRec('Account', authSetting.Id);
        configRec.GYNCF_Available_Fileters__c = '[{"sapFieldName":"PARTNER","valueLow":"101,100","valueHigh":"","type":"STRING","sfdcfieldName":"PARTNER__c","operationType":"EQ"}]';
        configRec.GYNCF_Account_Group__c = 'Test';
        configRec.GYNCF_Field_Maping__c ='[{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'PARTNER__c\'}","sapField":"PARTNER"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'TYPE__c\'}","sapField":"TYPE"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BPKIND__c\'}","sapField":"BPKIND"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BU_GROUP__c\'}","sapField":"BU_GROUP"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG1__c\'}","sapField":"NAME_ORG1"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG2__c\'}","sapField":"NAME_ORG2"}]';
        configRec.GYNCF_To_Be_Synced__c = 10;
        configRec.GYNCF_Batch_Size__c = 10;
        configRec.GYNCF_Synced__c = 0;
        configRec.GYNCF_Mass_Sync_Live__c = true;
        configRec.GYNCF_Identifier_SAP__c = 'Customer';
        configRec.GYNCF_Identifier_SFDC__c = 'GYNCF_SAP_Number__c';
        configRec.GYNCF_LineItemApi_Name__c = 'Asset';
        configRec.GYNCF_LineItem_Identifier_SAP__c = 'Customer';
        configRec.GYNCF_LineItem_Identifier_SFDC__c = 'AccountId';
        UPDATE configRec;
        
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d": {"ToFields":{"results":[]} }}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        List<String> batchSizeList = new List<String>();
        batchSizeList.add('test');
        GYNC_TableReplicationBatch Replication = new GYNC_TableReplicationBatch();
        Replication.batchIterator = batchSizeList;
        Replication.top = 2;
        Replication.skip= 10;
        Replication.configRec = configRec;
        Replication.systemId = authSetting.Id;
       // user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
       // System.runAs(u) {
        Test.startTest();
        try{
        Replication.executeThisBatch(); 
        }
        catch(exception e){
            system.debug('line56:');
        }
        Test.stopTest();
        System.assertEquals(0, [select count() from Account]);
       //}
    }
}