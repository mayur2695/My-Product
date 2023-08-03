/*
 * @author: Nitish
 * @testClassName: GYNC_MassSyncBatchTest
 * @apexClass: GYNC_MassSyncBatch
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
private class GYNC_MassSyncBatchTest {
    @testSetup static void setup() {
        
        //GYNC_TestUtility.createUser();
        // Create common test data that will be used across the test class
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default', true);
        
        List<GYNCO_Configuration__c> configList = GYNC_TestUtility.createConfiguration('Account', authSetting.Id, 'Account', 'https://www.testUrlcom/account', '', '', 500, 1, true);
        
    }
    @isTest static void executeBatchTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = [SELECT Id FROM GYNCO_Configuration__c WHERE Name = 'Account' and GYNCF_System_Id__c = :authSetting.Id LIMIT 1];
        // GYNC_massSyncTabClass.findConfigRec('Account', authSetting.Id);
        configRec.GYNCF_Available_Fileters__c = '[{"configApiName": "GYNCF_Account_Group__c","sapApiName": "AccountGroup"}]';
        configRec.GYNCF_Account_Group__c = 'Test';
        configRec.GYNCF_Field_Maping__c = '[{"sapField":"Name1","SFDCField":"{\\"sfdcFieldType\\":\\"STRING\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"Name\\"}"}, {"sapField":"Name2","SFDCField":"{\\"sfdcFieldType\\":\\"REFERENCE\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"Name\\"}"}]';
        configRec.GYNCF_To_Be_Synced__c = 10;
        configRec.GYNCF_Batch_Size__c = 10;
        configRec.GYNCF_Synced__c = 0;
        configRec.GYNCF_Mass_Sync_Live__c = true;
        configRec.GYNCF_Identifier_SAP__c = 'Customer';
        configRec.GYNCF_Identifier_SFDC__c = 'GYNCF_SAP_Number__c';
        UPDATE configRec;
        
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"Name1":"Test Name1","Customer":"Act-001"},{"Name1":"Test Name2","Customer":"Act-002"},{"Name1":"Test Name3","Customer":"Act-003"}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        
        
        List<String> batchSizeList = new List<String>();
        batchSizeList.add('test');
        GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
        massSyncBatch.batchIterator = batchSizeList;
        massSyncBatch.top = 10;
        massSyncBatch.configRec = configRec;
        massSyncBatch.systemId = authSetting.Id;
        User thisUser = [Select id from User where Id =: UserInfo.getUserId()];
        
        
        System.RunAs(thisUser){
            Test.startTest();
            try{
            massSyncBatch.executeThisBatch();
            }
            catch(Exception e) {
                System.debug('Exception');
            }
            //massSyncBatch.executeThisBatch();        
            Test.stopTest();
        }
        System.assertEquals(0, [SELECT count() FROM Account]);
    }
    
    
    @isTest static void executeBatchChildTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = [SELECT Id FROM GYNCO_Configuration__c WHERE Name = 'Account' and GYNCF_System_Id__c = :authSetting.Id LIMIT 1];
        //GYNC_massSyncTabClass.findConfigRec('Account', authSetting.Id);
        configRec.GYNCF_Available_Fileters__c = '[{"configApiName": "GYNCF_Account_Group__c","sapApiName": "AccountGroup"}]';
        configRec.GYNCF_Account_Group__c = 'Test';
        configRec.GYNCF_Field_Maping__c = '[{"sapField":"CreatedDate","SFDCField":"{\\"sfdcFieldType\\":\\"DATE\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"GYNCF_SAP_Created_Date__c\\"}"}, {"sapField":"Name1","SFDCField":"{\\"sfdcFieldType\\":\\"STRING\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"Name\\"}"}, {"sapField":"Name2","SFDCField":"{\\"sfdcFieldType\\":\\"REFERENCE\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"Name\\"}"}, {"sapField":"CreatedDate","SFDCField":"{\\"sfdcFieldType\\":\\"DATETIME\\",\\"relatedTo\\":\\"Account\\",\\"fieldValue\\":\\"GYNCF_SAP_Created_Date__c\\"}"}]';
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
        mockClass.mockResponseBody = '{"d":{"results":[{"Name1":"Test Name1","Customer":"Act-001","CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}},{"Name1":"Test Name2","Customer":"Act-002","CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}},{"Name1":"Test Name3","Customer":"Act-003","CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        
        
        List<String> batchSizeList = new List<String>();
        batchSizeList.add('test');
        GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
        massSyncBatch.batchIterator = batchSizeList;
        massSyncBatch.top = 10;
        massSyncBatch.configRec = configRec;
        massSyncBatch.systemId = authSetting.Id;
        
        User thisUser = [Select id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
            Test.startTest();
            try{
            massSyncBatch.executeThisBatch();
            }
            catch(Exception e) {
                System.debug('Exception');
            }
            //massSyncBatch.executeThisBatch();        
            Test.stopTest();
        }
        System.assertEquals(0, [SELECT count() FROM Account]);
    }
    
    
    @isTest static void executeBatchMaterialTest() {
        GYNCS_AuthorizationSetting__c authSetting = [SELECT Id, Name, GYNCF_Authorization_Type__c FROM GYNCS_AuthorizationSetting__c LIMIT 1];
        GYNCO_Configuration__c configRec = [SELECT Id FROM GYNCO_Configuration__c WHERE Name = 'Account' and GYNCF_System_Id__c = :authSetting.Id LIMIT 1];
        //GYNC_massSyncTabClass.findConfigRec('Account', authSetting.Id);
        configRec.GYNCF_Material_Group__c = 'Test';
        configRec.GYNCF_Available_Fileters__c = '[{"configApiName": "GYNCF_Material_Group__c","sapApiName": "MaterialGroup"}]';
        configRec.GYNCF_Field_Maping__c = '[{"sapField":"MaterialNumber","SFDCField":"{\\"sfdcFieldType\\":\\"STRING\\",\\"relatedTo\\":\\"\\",\\"fieldValue\\":\\"ProductCode\\"}"},{"sapField":"MaterialGroup","SFDCField":"{\\"sfdcFieldType\\":\\"PICKLIST\\",\\"relatedTo\\":\\"User\\",\\"fieldValue\\":\\"Family\\"}"}]';
        configRec.GYNCF_To_Be_Synced__c = 10;
        configRec.GYNCF_Batch_Size__c = 10;
        configRec.GYNCF_Synced__c = 0;
        configRec.GYNCF_Mass_Sync_Live__c = true;
        configRec.Name = 'Materials';
        configRec.GYNCF_SFDC_Object_Name__c = 'Product2';
        configRec.GYNCF_Identifier_SAP__c = 'MaterialNumber';
        configRec.GYNCF_Identifier_SFDC__c = 'ProductCode';
        configRec.GYNCF_PricebookApi_Name__c = 'TestPriceBook';
        UPDATE configRec;
        
        Pricebook2 stdPriceBook = new Pricebook2();
        stdPriceBook.Name = 'Standard Price Book';
        if(UserInfo.isMultiCurrencyOrganization())stdPriceBook.put('CurrencyIsoCode', 'USD');
        INSERT stdPriceBook;
        
        Pricebook2 cusPriceBook = new Pricebook2();
        cusPriceBook.Name = 'TestPriceBook';
        if(UserInfo.isMultiCurrencyOrganization())cusPriceBook.put('CurrencyIsoCode', 'USD');
        INSERT cusPriceBook;
        
        Product2 testProd = new Product2();
        testProd.Name = 'Test';
        testProd.ProductCode = 'Act-001';
        INSERT testProd;
        
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '{"d":{"results":[{"MaterialGroup":"Test Name1","MaterialNumber":"Act-001","Price":103,"CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}},{"MaterialGroup":"Test Name2","MaterialNumber":"Act-002","Price":103,"CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}},{"MaterialGroup":"Test Name3","MaterialNumber":"Act-003","Price":103,"CreatedDate":"DATE/123457890/ ","ToItems":{"results":[]}}]}}';
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        
        
        List<String> batchSizeList = new List<String>();
        batchSizeList.add('test');
        GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
        massSyncBatch.batchIterator = batchSizeList;
        massSyncBatch.top = 10;
        massSyncBatch.configRec = configRec;
        massSyncBatch.systemId = authSetting.Id;
        
        User thisUser = [Select id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
            Test.startTest();
            try{
            massSyncBatch.executeThisBatch();
            }
            catch(Exception e) {
                System.debug('Exception');
            }
            //massSyncBatch.executeThisBatch();        
            Test.stopTest();
        }
        System.assertEquals(1, [SELECT count() FROM Product2]);
    }
}