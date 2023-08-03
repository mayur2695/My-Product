/*
 * @author: Nitish
 * @testClassName: GYNC_API_DispatcherTest
 * @apexClass: GYNC_API_Dispatcher
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
private class GYNC_API_DispatcherTest {
    @testSetup static void setup() {
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
    }
    
    @isTest static void makeCallOutBasicTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Map<String, String> apiHeader = new Map<String, String>();
        apiHeader.put('Test','Test');
        HTTPResponse apiResponse;
        Test.startTest();
        GYNC_API_Dispatcher.systemId = authSetting.Id;
		apiResponse = GYNC_API_Dispatcher.makeCallOut('GET', 'https://www.testing.com/test',apiHeader, '');
		Test.stopTest();
        System.assertEquals(200, apiResponse.getStatusCode());
    }
    
    @isTest static void makeCallOutoAuthTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        authSetting.GYNCF_Authorization_Type__c = 'oAuth';
        UPDATE authSetting;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Map<String, String> apiHeader = new Map<String, String>();
        apiHeader.put('Test','Test');
        HTTPResponse apiResponse;
        Test.startTest();
        GYNC_API_Dispatcher.systemId = authSetting.Id;
		apiResponse = GYNC_API_Dispatcher.makeCallOut('GET', 'https://www.testing.com/test',apiHeader, '');
		Test.stopTest();
        System.assertEquals(200, apiResponse.getStatusCode());
    }
}