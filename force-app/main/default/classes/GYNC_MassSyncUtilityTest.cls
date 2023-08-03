/*
 * @author: Nitish
 * @testClassName: GYNC_MassSyncUtilityTest
 * @apexClass: GYNC_MassSyncUtility
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
private class GYNC_MassSyncUtilityTest {
	@testSetup static void setup() {
        GYNC_TestUtility.createUser();
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('TestObj', authSetting.Id, 'TestObj', 'https://www.testUrlcom/account', '', '', 500, 5, true);
        /*for(GYNCO_Configuration__c item : configList)
        	item.GYNCF_Operation_Type__c = 'Table Replication Sync';
        UPDATE configList;*/
    }
    
    @isTest static void callMassSyncTest() {
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        
        GYNCO_Configuration__c configRec = GYNC_massSyncTabClass.findConfigRec('TestObj', authSetting.Id);
		String response = '';
         
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"__count":10}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
		Test.startTest();
		response = GYNC_MassSyncUtility.callMassSync(configRec, authSetting.Id);
		Test.stopTest();
        System.assertEquals('Success',response);
        }
        
    }
}