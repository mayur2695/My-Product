/*
 * @author: Sushri
 * @testClassName: GYNC_SyncAPIFieldNamesSAPClass_Test
 * @apexClass: GYNC_SyncAPIFieldNamesSAPClass
 * @description: This class is to test the logic of the apex class
 * @version: V1
 * @createdDate: 22th Jun 2020
 *
 * @version: V2
 * Comments: Why modification needed
 * @modifiedBy:
 * @modifiedDate:
 */
@isTest
private class GYNC_SyncAPIFieldNamesSAPClass_Test {
    @testSetup static void setup(){
        GYNC_TestUtility.createUser();
        GYNCS_AuthorizationSetting__c authSetting = new GYNCS_AuthorizationSetting__c();
        authSetting.GYNCF_Authorization_Type__c='Basic';
        authSetting.GYNCF_Base_URL__c='http://ec2-18-215-72-123.compute-1.amazonaws.com:8080';
        authSetting.GYNCF_Client_Id__c='324ce91c-f435-3bd8-b0e9-2b13d4b156a3';
        authSetting.GYNCF_Client_Secret__c='Starlight1$';
        authSetting.GYNCF_oAuth_Login_URL__c='https://oauthasservices-s0008805481trial.hanatrial.ondemand.com/oauth2/api/v1/token';
        authSetting.GYNCF_Password__c='init1234';
        authSetting.Name='Default';
        authSetting.GYNCF_User_Name__c='DSingh';
        insert authSetting;
        
        GYNCO_Configuration__c config = new GYNCO_Configuration__c();
        config.Name = 'Sales Order';
        config.GYNCF_Service_URL__c = 'http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/SALESDOCUMENTSet';
        config.GYANF_SAP_Object_API__c = 'SF_SALESDOCUMENTS_SRV';
        config.GYNCF_SAP_API_Fields__c = 'Channel,Delta,Lastrundate,ManualAddress,SalesDocument,Category,SoldTo,SoldToName,ShipTo,ShipToName,BillTo,BillToName,DocumentType,CreationDate,BillingStatus,DeliveryStatus,DocumentStatus,CustomerReference,CustomerReferenceDate,ReferenceDocument,RequestedDeliveryDate,PaymentTerms,SalesOrganization,DistributionChannel,Division,NetValue,Currency,TotalTax,TotalFreight,SalesDocument,Name,Street,City,Region,PostalCode,Country,TelephoneNumber,Email,,ItemDiscount,ItemListPrice,ManualPrice,SalesDocument,SalesDocumentItem,Material,MaterialDescription,Plant,StorageLocation,CustomerMaterial,OrderQuantity,UnitOfMeasure,ItemNetPrice,ItemTax,ItemFreight,ItemCostsushri test item,VBELN,test sales';
        config.GYNCF_Nodes_for_SAP_API__c = 'CUSTOMER';
        config.GYNCF_System_Id__c = authSetting.id;
        insert config;
        
		GYNCO_Custom_Field__c cust = new GYNCO_Custom_Field__c();
        cust.Label__c = 'ZZNEWFIELD';
        cust.Configuration__c = config.id;
		insert cust;
    }
    static testMethod void syncAPI() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForXMLResponse());
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            Test.startTest();
            id systemId = [Select id from GYNCS_AuthorizationSetting__c].id;
            GYNC_SyncAPIFieldNamesSAPClass.getAPIFieldsfromSAP('Sales Order',systemId);
            Test.stopTest();
            System.assertEquals(1,[select count() from GYNCO_Custom_Field__c]);
        }
    } 
}