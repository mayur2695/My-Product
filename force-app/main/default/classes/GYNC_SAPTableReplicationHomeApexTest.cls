/*
 * @author: Nitish
 * @testClassName: GYNC_SAPTableReplicationHomeApexTest
 * @apexClass: GYNC_SAPTableReplicationHomeApex
 * @description: This class is to test the logic of the apex class
 * @version: V1
 * @createdDate: 19th Jun 2020
 *
 * @version: V2
 * Comments: Why modification needed
 * @modifiedBy:
 * @modifiedDate:
 */
 
@isTest(seeAllData = false)
private class GYNC_SAPTableReplicationHomeApexTest {
    
    
    
    
    @testSetup static void setup() {
        GYNC_TestUtility.createUser();
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('TestObj', authSetting.Id, 'TestObj', 'https://www.testUrlcom/account', '', '', 500, 5, true);
        for(GYNCO_Configuration__c item : configList)
        	item.GYNCF_Operation_Type__c = 'Table Replication Sync';
        UPDATE configList;
    }
 
    @isTest static void findConfigRecTest() {
        GYNCO_Configuration__c configRec = [SELECT Id, Name, GYNCF_Identifier_SFDC__c, GYNCF_System_Id__c FROM GYNCO_Configuration__c limit 1];
		GYNCO_Configuration__c configRecResponse = new GYNCO_Configuration__c();
		user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            Test.startTest();
            configRecResponse = GYNC_SAPTableReplicationHomeApex.findConfigRec(configRec.Name, configRec.GYNCF_System_Id__c);
            Test.stopTest();
        }
        System.assertEquals(configRec.GYNCF_Identifier_SFDC__c, configRecResponse.GYNCF_Identifier_SFDC__c);
        
    }
    
    @isTest static void searchSAPTableTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        List<GYNC_SAPTableReplicationHomeApex.sapTableWrapper> searchTable = new List<GYNC_SAPTableReplicationHomeApex.sapTableWrapper>();
        String searchTableAsString;
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"Value":"KNA1","Description":"General Data in Customer Master"}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        Test.startTest();
		searchTableAsString = GYNC_SAPTableReplicationHomeApex.searchSAPTable('KNA', authSetting.Id);
		Test.stopTest();
        searchTable = (List<GYNC_SAPTableReplicationHomeApex.sapTableWrapper>)JSON.deserialize(searchTableAsString, List<GYNC_SAPTableReplicationHomeApex.sapTableWrapper>.class);
        System.assertEquals(1, searchTable.size());
        
    }
    
    @isTest static void fetchAllFieldsTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper> searchTable = new List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>();
        String searchTableAsString;
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"Field":"test1","Key":true,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test2","Key":false,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test3","Key":false,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test4","Key":true,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        Test.startTest();
		searchTableAsString = GYNC_SAPTableReplicationHomeApex.fetchAllFields('KNA', authSetting.Id);
		Test.stopTest();
        searchTable = (List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>)JSON.deserialize(searchTableAsString, List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>.class);
        System.assertEquals(4, searchTable.size());
        
    }
    
    
    @isTest static void customSFDCObjTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper> searchTable = new List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>();
        String searchTableAsString;
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"Field":"test1","Key":true,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test2","Key":false,"EdmCoreType":"Edm.Boolean","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test3","Key":false,"EdmCoreType":"Edm.Single","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test4","Key":true,"EdmCoreType":"Edm.Decimal","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test5","Key":true,"EdmCoreType":"Edm.DateTime","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        Test.startTest();
        searchTableAsString = GYNC_SAPTableReplicationHomeApex.fetchAllFields('KNA', authSetting.Id);
        searchTable = (List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>)JSON.deserialize(searchTableAsString, List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>.class);
        for(GYNC_SAPTableReplicationHomeApex.sapFieldWrapper element : searchTable) {
            element.isSelected = true;
        }
        
        
        
        MockWebServiceResponseGenerator mockWebservice = new MockWebServiceResponseGenerator();
        //mockWebservice.responseElement =  new MetadataService.SaveResult();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.success = true;
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        
        mockWebservice.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice);
		
        
        
        GYNC_SAPTableReplicationHomeApex.customSFDCObj('KNA', 'KNA', JSON.serialize(searchTable), authSetting.Id);
		Test.stopTest();
        System.assertEquals(5, searchTable.size());
        
    }
    
    
    @isTest static void findExistingTableMappingTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        List<GYNCO_Configuration__c> configList = new List<GYNCO_Configuration__c>();
        String configListAsString;
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            Test.startTest();
            configListAsString = GYNC_SAPTableReplicationHomeApex.findExistingTableMapping(authSetting.Id);
            Test.stopTest();
        }
        configList = (List<GYNCO_Configuration__c>)JSON.deserialize(configListAsString, List<GYNCO_Configuration__c>.class);
        System.assertEquals([SELECT count() FROM GYNCO_Configuration__c WHERE GYNCF_Operation_Type__c = 'Table Replication Sync'], configList.size());
        
    }
    
    @isTest static void startMassSyncSAPTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        
        GYNCO_Configuration__c configRec = [SELECT Id, Name, GYNCF_SFDC_Object_Name__c, GYNCF_Field_Maping__c, GYNCF_Available_Fileters__c FROM GYNCO_Configuration__c LIMIT 1];
        configRec.Name = 'KNA';
        configRec.GYNCF_SFDC_Object_Name__c = 'Account';
        configRec.GYNCF_Field_Maping__c = '[{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'Name\'}","sapField":"CLIENT"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'Name\'}","sapField":"PARTNER"},{"SFDCField":"{\'sfdcFieldType\':\'STRING\',\'fieldValue\':\'Name\'}","sapField":"TYPE"}]';
        UPDATE configRec;
        
        String response = '';
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d" : {"ToFields" : {"results":[{"CLIENT":"test","PARTNER":"test","TYPE":"test"}]}, "ToFilters":{"results":[{"FieldName":"&inlinecount","ValueLow":"6"}]}}}';
        Map<String, String> mockResponseHeader = new Map<String, String>();
		mockResponseHeader.put('x-csrf-token','AnyValue');
        mockResponseHeader.put('Set-Cookie','AnyValueX');
        mockClass.mockResponseHeader = mockResponseHeader;
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            
            Test.startTest();
            response = GYNC_SAPTableReplicationHomeApex.startMassSyncSAP('KNA', authSetting.Id);
            Test.stopTest();
        }
        System.assertEquals([SELECT count() FROM GYNCO_Configuration__c WHERE GYNCF_Operation_Type__c = 'Table Replication Sync'],5);
        
    }
    
    @isTest static void storeFilterDataTest() {
        GYNCO_Configuration__c configRec = [SELECT Id, Name, GYNCF_SFDC_Object_Name__c, GYNCF_Field_Maping__c, GYNCF_Available_Fileters__c FROM GYNCO_Configuration__c LIMIT 1];
        Test.startTest();
		GYNC_SAPTableReplicationHomeApex.storeFilterData(configRec.Id, 'Testing Filters');
		Test.stopTest();
        System.assertEquals('Testing Filters', [SELECT GYNCF_Available_Fileters__c FROM GYNCO_Configuration__c WHERE Id = :configRec.Id LIMIT 1].GYNCF_Available_Fileters__c);
        
    }
    
    
    @isTest static void updateFieldMapTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = [SELECT Id, Name, GYNCF_SFDC_Object_Name__c, GYNCF_Field_Maping__c, GYNCF_Available_Fileters__c FROM GYNCO_Configuration__c LIMIT 1];
        List<String> deleteFields = new List<String>();
        deleteFields.add('Test 1');
        deleteFields.add('Test 2');
        
        
        List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper> searchTable = new List<GYNC_SAPTableReplicationHomeApex.sapFieldWrapper>();
        String searchTableAsString;
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"Field":"test1","Key":true,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test2","Key":false,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test3","Key":false,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10},{"Field":"test4","Key":true,"EdmCoreType":"Edm.String","EdmPrecision":0,"EdmScale":0,"EdmMaxLength":10}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        Test.startTest();
		searchTableAsString = GYNC_SAPTableReplicationHomeApex.fetchAllFields('KNA', authSetting.Id);
       system.debug('searchTableAsString: '+searchTableAsString);
		GYNC_SAPTableReplicationHomeApex.updateFieldMap(configRec.Id, searchTableAsString, deleteFields);
		Test.stopTest();
        System.assertEquals(null, [SELECT GYNCF_Available_Fileters__c FROM GYNCO_Configuration__c WHERE Id = :configRec.Id LIMIT 1].GYNCF_Available_Fileters__c);
        
    }
  
}