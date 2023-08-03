/*
* @author: Sapna kumari
* @testClassName: GYNC_createCustomfieldController_Test
* @apexClass: GYNC_createCustomfieldController
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 19th Jun 2020
*
* @version: V2
* Comments: Why modification needed
* @modifiedBy:
* @modifiedDate:
*/
@isTest(seeAllData=false)
public class GYNC_createCustomfieldController_Test {
    //Below is a method with @testsetup annotation, the name can be anything like setup(),oneTimeData(), etc.
    @testSetup static void setup() {
        GYNC_TestUtility.createUser();
        
        //configuration record
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        System.debug('sysmId'+sysmId);
        String ServicURL = '/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/SALESDOCUMENTSet';
        List<GYNCO_Configuration__c> config= GYNC_TestUtility.createConfiguration('Sales Order',sysmId,'Order',ServicURL,'','',500,1,true);
        config[0].Name = 'Sales Order';
        update config;
        String Id = config[0].Id;
        System.debug('config'+config);
        //Create custom field record
        GYNCO_Custom_Field__c custom = GYNC_TestUtility.createCustomField('Test__c','Test',Id,sysmId,'Text','Sales Order','Order',true);
    }
    
    @isTest 
    public static void testName() {
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
            string sysmId = string.valueOf(sysId.Id);
            System.debug('sysmId'+sysmId);
            String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
            List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
            
            GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
            cusobj.Name = 'Sales Order';
            cusobj.GYNCF_System_Id__c = sysmId;
            update cusobj;
            
            GYNCO_Custom_Field__c cus1 = [select Id,Name,Picklist_Values__c,GYNF_System_ID__c,Add_Field_To_Salesforce__c,Item__c,SFDC_Object_Name__c from GYNCO_Custom_Field__c limit 1];
            cus1.Item__c = false;
            cus1.GYNF_System_ID__c = sysmId;
            cus1.Add_Field_To_Salesforce__c = true;
            cus1.Picklist_Values__c = pickval;
            update cus1;
            
            System.debug('cus1'+cus1.SFDC_Object_Name__c);
            
            //Setting mock for Soap
            MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
            List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
            MetadataService.SaveResult result = new MetadataService.SaveResult();
            result.fullName = 'Order';
            results.add(result);
            MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
            resEement.result = results;
            mockWebservice1.responseElementObject = resEement;
            Test.setMock(WebServiceMock.class, mockWebservice1);
            
            Test.startTest();  
            String customlist = GYNC_createCustomfieldController.getfieldData('Sales Order',sysmId);
            String customlist1 = GYNC_createCustomfieldController.checkduplicatevalue('Sales Order',sysmId);
            GYNC_createCustomfieldController.addtoSfdc(cus1.Id);
            GYNC_createCustomfieldController.CreateCustomField('Test','Test__c','Text','Sales Order',true,false,pickval,sysmId);
            GYNC_createCustomfieldController.CreateCustomField('Test','Test__c','Number','Sales Order',false,false,pickval,sysmId);
            Test.stopTest(); 
            Boolean presentField = false;
            Schema.DescribeSObjectResult a_desc = Order.sObjectType.getDescribe(); 
            Map<String, Schema.SObjectField> a_fields = a_desc.fields.getMap();
            //system.debug('a_fields: '+a_fields);
            for(String fieldName : a_fields.keySet()){
                system.debug('fieldName: '+fieldName);
                if(fieldName == 'test__c'){
                    presentField= true;
                }
            }
            System.assertEquals(presentField, false);
        }
        
        //System.assertEquals(customlist1[0].Name, 'Test');
    }
    @isTest 
    public static void testName1() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        System.debug('sysmId'+sysmId);
        String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
        
        GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
        cusobj.Name = 'Sales Order';
        cusobj.GYNCF_System_Id__c = sysmId;
        cusobj.GYNCF_LineItemApi_Name__c = 'OrderItem';
        update cusobj;
        
        //Setting mock for Soap
        MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.fullName = 'Order';
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        mockWebservice1.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice1);
        
        Test.startTest();  
        GYNC_createCustomfieldController.CreateCustomField('Test1','Test1__c','Number','Sales Order',true,true,pickval,sysmId);
        Test.stopTest(); 
        System.assertEquals(cusobj.Name, 'Sales Order');
    }
    }
    
    @isTest 
    public static void testName2() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        System.debug('sysmId'+sysmId);
        String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
        
        GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
        cusobj.Name = 'Sales Order';
        cusobj.GYNCF_System_Id__c = sysmId;
        cusobj.GYNCF_LineItemApi_Name__c = 'OrderItem';
        update cusobj;
        
        //Setting mock for Soap
        MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.fullName = 'Order';
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        mockWebservice1.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice1);
        
        Test.startTest();  
        GYNC_createCustomfieldController.CreateCustomField('Test2','Test2__c','Currency','Sales Order',true,false,pickval,sysmId);
        Test.stopTest(); 
        System.assertEquals(cusobj.Name, 'Sales Order');
        }
    }
    
    @isTest 
    public static void testName3() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        System.debug('sysmId'+sysmId);
        String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
        
        GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
        cusobj.Name = 'Sales Order';
        cusobj.GYNCF_System_Id__c = sysmId;
        cusobj.GYNCF_LineItemApi_Name__c = 'OrderItem';
        update cusobj;
        
        //Setting mock for Soap
        MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.fullName = 'Order';
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        mockWebservice1.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice1);
        
        Test.startTest();  
        GYNC_createCustomfieldController.CreateCustomField('Test4','Test4__c','Picklist','Sales Order',true,false,pickval,sysmId);
        Test.stopTest(); 
        System.assertEquals(cusobj.Name, 'Sales Order');
        }
    }
    
    @isTest 
    public static void testName4() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        System.debug('sysmId'+sysmId);
        String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
        
        GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
        cusobj.Name = 'Sales Order';
        cusobj.GYNCF_System_Id__c = sysmId;
        cusobj.GYNCF_LineItemApi_Name__c = 'OrderItem';
        update cusobj;
        
        //Setting mock for Soap
        MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.fullName = 'Order';
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        mockWebservice1.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice1);
        
        Test.startTest();  
        GYNC_createCustomfieldController.CreateCustomField('Test3','Test3__c','Checkbox','Sales Order',true,false,pickval,sysmId);
        Test.stopTest(); 
        System.assertEquals(cusobj.Name, 'Sales Order');
        }
    }
    
    @isTest 
    public static void testName5() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        String pickval = '[{"key":"0001","value":"Sales Org. 0001"},{"key":"CH10","value":"Dom. Sales Org CH"},{"key":"NA01","value":"US / CA - Sales Org"},{"key":"WEST","value":"Sales Org. West"},{"key":"IDI1","value":"IDI-Fix Me"},{"key":"V100","value":"VISHAL IND PVT LTD"},{"key":"T200","value":"BAKERY SALES ORG"},{"key":"F100","value":"USA VISHAL"},{"key":"S100","value":"PISHAL DRYFRUITS S O"},{"key":"VVSO","value":"VISHAL VAIBHAV S ORG"}]';
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(pickval);
        
        GYNCO_Configuration__c cusobj = [select Id,Name,GYNCF_System_Id__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c limit 1];
        cusobj.Name = 'Sales Order';
        cusobj.GYNCF_System_Id__c = sysmId;
        cusobj.GYNCF_LineItemApi_Name__c = 'OrderItem';
        update cusobj;
        
        //Setting mock for Soap
        MockWebServiceResponseGenerator mockWebservice1 = new MockWebServiceResponseGenerator();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.fullName = 'Order';
        results.add(result);
        MetadataService.createMetadataResponse_element resEement = new MetadataService.createMetadataResponse_element();
        resEement.result = results;
        mockWebservice1.responseElementObject = resEement;
        Test.setMock(WebServiceMock.class, mockWebservice1);
        
        Test.startTest();  
        GYNC_createCustomfieldController.CreateCustomField('Test3','Test3__c','Date','Sales Order',true,false,pickval,sysmId);
        Test.stopTest(); 
        System.assertEquals(cusobj.Name, 'Sales Order');
        }
    }
    
    @isTest 
    public static void testmethodforRestCallout() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        //Setting mock for Rest
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = '<feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xml:base="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/"><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHEXTENSIONFIELDS</id><title type="text">EXTENSIONFIELDSSet</title><updated>2020-06-22T16:00:32Z</updated><author><name/></author><link href="FETCHEXTENSIONFIELDS" rel="self" title="EXTENSIONFIELDSSet"/><entry><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/EXTENSIONFIELDSSet(\'ZZDATE\')</id><title type="text">EXTENSIONFIELDSSet(\'ZZDATE\')</title><updated>2020-06-22T16:00:32Z</updated><category term="GCONNECT.SF_PICK_LIST_SRV.EXTENSIONFIELDS" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/><link href="EXTENSIONFIELDSSet(\'ZZDATE\')" rel="self" title="EXTENSIONFIELDS"/><content type="application/xml"><m:properties xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"><d:Field>ZZDATE</d:Field><d:Key>false</d:Key><d:EdmCoreType>Edm.DateTime</d:EdmCoreType><d:EdmPrecision>0</d:EdmPrecision><d:EdmScale>0</d:EdmScale><d:EdmMaxLength>10</d:EdmMaxLength></m:properties></content></entry></feed>';
        Test.setMock(HttpCalloutMock.class, mockClass);
        Test.startTest(); 
        String responce = GYNC_createCustomfieldController.fetchSAPallFields('SALESORDER','',sysmId);
        Test.stopTest(); 
        system.assertNotEquals(null,responce,'The responce should not be null' );
        }
    }
    @isTest 
    public static void testmethodforRestCallout1() {
         user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        //Setting mock for Rest
        MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
        mockClass.mockResponseBody = ' <feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xml:base="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/"><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHEXTENSIONFIELDS</id><title type="text">EXTENSIONFIELDSSet</title><updated>2020-06-22T16:00:32Z</updated><author><name/></author><link href="FETCHEXTENSIONFIELDS" rel="self" title="EXTENSIONFIELDSSet"/><entry><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/EXTENSIONFIELDSSet(\'ZZDATE\')</id><title type="text">EXTENSIONFIELDSSet(\'ZZDATE\')</title><updated>2020-06-22T16:00:32Z</updated><category term="GCONNECT.SF_PICK_LIST_SRV.EXTENSIONFIELDS" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/><link href="EXTENSIONFIELDSSet(\'ZZDATE\')" rel="self" title="EXTENSIONFIELDS"/><content type="application/xml"><m:properties xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"><d:Field>ZZDATE</d:Field><d:Key>false</d:Key><d:EdmCoreType>Edm.DateTime</d:EdmCoreType><d:EdmPrecision>0</d:EdmPrecision><d:EdmScale>0</d:EdmScale><d:EdmMaxLength>10</d:EdmMaxLength></m:properties></content></entry></feed>';
        Test.setMock(HttpCalloutMock.class, mockClass);
        Test.startTest(); 
        String responce = GYNC_createCustomfieldController.fetchSAPPicklist('SALESORDER','VKORG','',sysmId);
        Test.stopTest(); 
        system.assertNotEquals(null,responce,'The responce should not be null' );
    }
    }
}