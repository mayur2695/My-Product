/*
 * @author: Nitish
 * @testClassName: GYNC_tabPermissionBatchTest
 * @apexClass: GYNC_tabPermissionBatch
 * @description: This class is to test the logic of the apex class
 * @version: V1
 * @createdDate: 22th Jun 2020
 *
 * @version: V2
 * Comments: Why modification needed
 * @modifiedBy:
 * @modifiedDate:
 */
@isTest(seeAllData = false)
private class GYNC_tabPermissionBatchTest {
	@testSetup static void setup() {
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('TestObj', authSetting.Id, 'TestObj', 'https://www.testUrlcom/account', '', '', 500, 5, true);
        
    }
    
    @isTest static void executeBatchTest() {
        GYNCO_Configuration__c configRec = [SELECT Id, GYNCF_isFLSActive__c FROM GYNCO_Configuration__c LIMIT 1];
        configRec.GYNCF_isFLSActive__c = false;
        UPDATE configRec;
        List<String> SFDCFieldList = new List<String>();
        SFDCFieldList.add('Name');
        GYNC_tabPermissionBatch batchInstance = new GYNC_tabPermissionBatch();
        batchInstance.SFDCObjName = 'Account';
        batchInstance.SFDCFieldList = SFDCFieldList;
        batchInstance.configRec = configRec;
        
        //Setting mock
        MockWebServiceResponseGenerator mockWebservice = new MockWebServiceResponseGenerator();
        List<MetadataService.FileProperties> results = new List<MetadataService.FileProperties>();
        MetadataService.FileProperties result = new MetadataService.FileProperties();
        result.fullName = 'Admin';
        results.add(result);
        MetadataService.listMetadataResponse_element resEement = new MetadataService.listMetadataResponse_element();
        resEement.result = results;
        mockWebservice.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice);
        
        Test.startTest();
        Database.executeBatch(batchInstance, 1);
        
        Test.stopTest();
        System.assertEquals(true, [SELECT GYNCF_isFLSActive__c FROM GYNCO_Configuration__c WHERE Id = :configRec.Id].GYNCF_isFLSActive__c);
        
        
        
        
    }
}