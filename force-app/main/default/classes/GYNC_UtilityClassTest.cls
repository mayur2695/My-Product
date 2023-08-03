/*
 * @author: Nitish
 * @testClassName: GYNC_UtilityClassTest
 * @apexClass: GYNC_UtilityClass
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
private class GYNC_UtilityClassTest {
	@testSetup static void setup() {
        GYNC_TestUtility.createUser();
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('TestObj', authSetting.Id, 'TestObj', 'https://www.testUrlcom/account', '', '', 500, 5, true);
        for(GYNCO_Configuration__c item : configList)
        	item.GYNCF_Operation_Type__c = 'Table Replication Sync';
        UPDATE configList;
    }
    @isTest static void findDefultSystemIdTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        
        String systemId = '';
        Test.startTest();
		systemId = GYNC_UtilityClass.findDefultSystemId(authSetting.Id);
		Test.stopTest();
        System.assertEquals(authSetting.Id, systemId);
    }
    
    @isTest static void findSystemTest() {
        List<GYNC_UtilityClass.keyValueWrapper> allSystems = new List<GYNC_UtilityClass.keyValueWrapper>();
        Test.startTest();
		allSystems = GYNC_UtilityClass.findSystem();
		Test.stopTest();
        System.assertEquals([SELECT count() FROM GYNCS_AuthorizationSetting__c], allSystems.size());
    }
    
    @isTest static void findSystemParaTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCS_AuthorizationSetting__c authResponse = new GYNCS_AuthorizationSetting__c();
        Test.startTest();
		authResponse = GYNC_UtilityClass.findSystem(authSetting.Id);
		Test.stopTest();
        System.assertEquals(authSetting.Name, authResponse.Name);
    }
    
    @isTest static void findSystemParaTest1() {
        GYNCS_AuthorizationSetting__c authResponse = new GYNCS_AuthorizationSetting__c();
        Test.startTest();
		authResponse = GYNC_UtilityClass.findSystem('');
		Test.stopTest();
        System.assertEquals(null, authResponse);
    }
    
    @isTest static void findXcsrfTokenTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        Map<String, String> mockResponseHeader = new Map<String, String>();
		mockResponseHeader.put('x-csrf-token','AnyValue');
        mockResponseHeader.put('Set-Cookie','AnyValueX');
        mockClass.mockResponseHeader = mockResponseHeader;
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        HTTPResponse apiResponse;
        Test.startTest();
        GYNC_UtilityClass.systemId = authSetting.Id;
		apiResponse = GYNC_UtilityClass.findXcsrfToken('https://www.testing.com/test');
		Test.stopTest();
        System.assertEquals(200, apiResponse.getStatusCode());
    }
    
    
    @isTest static void buildRequestBodyTest() {
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = GYNC_massSyncTabClass.findConfigRec('TestObj', authSetting.Id);
        configRec.GYNCF_Available_Fileters__c = '[{"sapFieldName":"PARTNER","valueLow":"101,100","valueHigh":"","type":"STRING","sfdcfieldName":"PARTNER__c","operationType":"EQ"}]';
        configRec.GYNCF_Field_Maping__c = '[{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'PARTNER__c\'}","sapField":"PARTNER"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'TYPE__c\'}","sapField":"TYPE"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BPKIND__c\'}","sapField":"BPKIND"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BU_GROUP__c\'}","sapField":"BU_GROUP"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG1__c\'}","sapField":"NAME_ORG1"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG2__c\'}","sapField":"NAME_ORG2"}]';
        UPDATE configRec;
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        Map<String, String> mockResponseHeader = new Map<String, String>();
		mockResponseHeader.put('x-csrf-token','AnyValue');
        mockResponseHeader.put('Set-Cookie','AnyValueX');
        mockClass.mockResponseHeader = mockResponseHeader;
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        HTTPResponse apiResponse;
        String response;
        Test.startTest();
        GYNC_UtilityClass.systemId = authSetting.Id;
		response = GYNC_UtilityClass.buildRequestBody(configRec, 5, 5, true);
        apiResponse = GYNC_UtilityClass.findTableReplicationData('http://www.testing.com/test',response);
		Test.stopTest();
        System.assertEquals(200, apiResponse.getStatusCode());
        }
    }
    
    
    
    
    
    @isTest static void processTableReplicationResponseTest() {
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = GYNC_massSyncTabClass.findConfigRec('TestObj', authSetting.Id);
        configRec.GYNCF_Available_Fileters__c = '[{"sapFieldName":"PARTNER","valueLow":"101,100","valueHigh":"","type":"STRING","sfdcfieldName":"PARTNER__c","operationType":"EQ"}]';
        configRec.GYNCF_Field_Maping__c = '[{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'PARTNER__c\'}","sapField":"PARTNER"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'TYPE__c\'}","sapField":"TYPE"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BPKIND__c\'}","sapField":"BPKIND"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'BU_GROUP__c\'}","sapField":"BU_GROUP"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG1__c\'}","sapField":"NAME_ORG1"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'NAME_ORG2__c\'}","sapField":"NAME_ORG2"}]';
        UPDATE configRec;
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        Map<String, String> mockResponseHeader = new Map<String, String>();
		mockResponseHeader.put('x-csrf-token','AnyValue');
        mockResponseHeader.put('Set-Cookie','AnyValueX');
        mockClass.mockResponseHeader = mockResponseHeader;
        Test.setMock(HttpCalloutMock.class, mockClass);
        String objListString = '[{"FieldName" : "VBELN","IsKey" : true,"Key" : "0000000005","Table" : "VBAK","Value" : "0000000005","ToTableFromFields" : {}},{"FieldName" : "VBELN","IsKey" : true,"Key" : "0000000005","Table" : "VBAK","Value" : "0000000005","ToTableFromFields" : {}}]';
        HTTPResponse apiResponse;
        String response;
        Test.startTest();
        GYNC_UtilityClass.systemId = authSetting.Id;
        GYNC_UtilityClass.processTableReplicationResponse((List<Object>)JSON.deserializeUntyped(objListString), configRec.GYNCF_Field_Maping__c, 'Account');
		//system.debug('test126: '+GYNC_UtilityClass.processTableReplicationResponse((List<Object>)JSON.deserializeUntyped(objListString), configRec.GYNCF_Field_Maping__c, 'Account'));
        //response = GYNC_UtilityClass.buildRequestBody(configRec, 5, 5, true);
        //apiResponse = GYNC_UtilityClass.findTableReplicationData('http://www.testing.com/test',response);
		Test.stopTest();
        System.assertEquals(0,[select count() from Account]);
        }
    }
    
}